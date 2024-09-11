#include "kernel/rtlil.h"
#include "kernel/utils.h"
#include "kernel/log.h"
#include "kernel/yosys.h"

USING_YOSYS_NAMESPACE
extern std::vector<RTLIL::SigSpec> get_corresponding_taint_signals(RTLIL::Module* module, std::vector<string> *excluded_signals, const RTLIL::SigSpec &sig, unsigned int num_taints);

/**
 * @param module the current module instance
 * @param cell the current cell instance
*
 * @return keep_current_cell
 */
bool cellift_sub(RTLIL::Module *module, RTLIL::Cell *cell, unsigned int num_taints, std::vector<string> *excluded_signals) {

    const unsigned int A = 0, B = 1, Y = 2;
    const unsigned int NUM_PORTS = 3;
    RTLIL::SigSpec ports[NUM_PORTS] = {cell->getPort(ID::A), cell->getPort(ID::B), cell->getPort(ID::Y)};
    std::vector<RTLIL::SigSpec> port_taints[NUM_PORTS];

    for (unsigned int i = 0; i < NUM_PORTS; ++i)
        port_taints[i] = get_corresponding_taint_signals(module, excluded_signals, ports[i], num_taints);

    int output_width = ports[Y].size();

    RTLIL::SigSpec extended_a(ports[A]);
    RTLIL::SigSpec extended_b(ports[B]);
    if (ports[A].size() < output_width) { // Sign-extend A if necessary.
        if (cell->getParam(ID::A_SIGNED).as_bool()) {
            RTLIL::SigBit curr_msb = ports[A][ports[A].size()-1];
            extended_a.append(RTLIL::SigSpec(curr_msb, output_width-ports[A].size()));
        }
        else
            extended_a.append(RTLIL::SigSpec(RTLIL::State::S0, output_width-ports[A].size()));
    }
    else if (ports[A].size() > output_width)
        extended_a.extract(0, output_width);
    if (ports[B].size() < output_width) { // Sign-extend B if necessary.
        if (cell->getParam(ID::B_SIGNED).as_bool()) {
            RTLIL::SigBit curr_msb = ports[B][ports[B].size()-1];
            extended_b.append(RTLIL::SigSpec(curr_msb, output_width-ports[B].size()));
        }
        else
            extended_b.append(RTLIL::SigSpec(RTLIL::State::S0, output_width-ports[B].size()));
    }
    else if (ports[B].size() > output_width)
        extended_b.extract(0, output_width);

    // if (ports[A].size() != ports[B].size() || ports[B].size() != ports[Y].size())
    // 	log_cmd_error("In $sub, all ports must have the same size. Got A: %d, B: %d, Y: %d.\n", ports[A].size(), ports[B].size(), ports[Y].size());

    for (unsigned int taint_id = 0; taint_id < num_taints; taint_id++) {
        // Taints are also "sign-extended".
        RTLIL::SigSpec extended_a_taint(port_taints[A][taint_id]);
        RTLIL::SigSpec extended_b_taint(port_taints[B][taint_id]);
        if (port_taints[A][taint_id].size() < output_width) { // Sign-extend A if necessary.
            if (cell->getParam(ID::A_SIGNED).as_bool()) {
                RTLIL::SigBit curr_msb = port_taints[A][taint_id][port_taints[A][taint_id].size()-1];
                extended_a_taint.append(RTLIL::SigSpec(curr_msb, ports[Y].size()-port_taints[A][taint_id].size()));
            }
            else
                extended_a_taint.append(RTLIL::SigSpec(RTLIL::State::S0, ports[Y].size()-port_taints[A][taint_id].size()));
        }
        else if (port_taints[A][taint_id].size() > output_width)
            extended_a_taint.extract(0, output_width);
        if (port_taints[B][taint_id].size() < output_width) { // Sign-extend B if necessary.
            if (cell->getParam(ID::B_SIGNED).as_bool()) {
                RTLIL::SigBit curr_msb = port_taints[B][taint_id][port_taints[B][taint_id].size()-1];
                extended_b_taint.append(RTLIL::SigSpec(curr_msb, ports[Y].size()-port_taints[B][taint_id].size()));
            }
            else
                extended_b_taint.append(RTLIL::SigSpec(RTLIL::State::S0, ports[Y].size()-port_taints[B][taint_id].size()));
        }
        else if (port_taints[B][taint_id].size() > output_width)
            extended_b_taint.extract(0, output_width);

        RTLIL::SigSpec not_a_taint = module->Not(NEW_ID, extended_a_taint);
        RTLIL::SigSpec not_b_taint = module->Not(NEW_ID, extended_b_taint);

        RTLIL::SigSpec a_and_not_a_taint = module->And(NEW_ID, extended_a, not_a_taint);
        RTLIL::SigSpec b_and_not_b_taint = module->And(NEW_ID, extended_b, not_b_taint);

        RTLIL::SigSpec a_or_a_taint = module->Or(NEW_ID, extended_a, extended_a_taint);
        RTLIL::SigSpec b_or_b_taint = module->Or(NEW_ID, extended_b, extended_b_taint);

        RTLIL::SigSpec a_one_minus_b_zero = module->Sub(NEW_ID, a_or_a_taint, b_and_not_b_taint);
        RTLIL::SigSpec a_zero_minus_b_one = module->Sub(NEW_ID, a_and_not_a_taint, b_or_b_taint);

        RTLIL::SigSpec xor_subs = module->Xor(NEW_ID, a_one_minus_b_zero, a_zero_minus_b_one);
        RTLIL::SigSpec xor_subs_or_a_taint = module->Or(NEW_ID, xor_subs, extended_a_taint);
        module->addOr(NEW_ID, xor_subs_or_a_taint, extended_b_taint, port_taints[Y][taint_id]);
    }

    return true;
}
