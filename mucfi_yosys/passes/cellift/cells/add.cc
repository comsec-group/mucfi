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
bool cellift_add(RTLIL::Module *module, RTLIL::Cell *cell, unsigned int num_taints, std::vector<string> *excluded_signals) {

    const unsigned int A = 0, B = 1, Y = 2;
    const unsigned int NUM_PORTS = 3;
    RTLIL::SigSpec ports[NUM_PORTS] = {cell->getPort(ID::A), cell->getPort(ID::B), cell->getPort(ID::Y)};
    std::vector<RTLIL::SigSpec> port_taints[NUM_PORTS];

    for (unsigned int i = 0; i < NUM_PORTS; ++i)
        port_taints[i] = get_corresponding_taint_signals(module, excluded_signals, ports[i], num_taints);

    int output_width = ports[Y].size();
    RTLIL::SigSpec extended_a(ports[A]);
    RTLIL::SigSpec extended_b(ports[B]);
    if (ports[A].size() < output_width)
        extended_a.append(RTLIL::SigSpec(RTLIL::State::S0, output_width-ports[A].size()));
    if (ports[B].size() < output_width)
        extended_b.append(RTLIL::SigSpec(RTLIL::State::S0, output_width-ports[B].size()));

    for (unsigned int taint_id = 0; taint_id < num_taints; taint_id++) {
        // Extend the inputs to the output width.
        RTLIL::SigSpec extended_a_taint(port_taints[A][taint_id]);
        RTLIL::SigSpec extended_b_taint(port_taints[B][taint_id]);
        if (ports[A].size() < output_width)
            extended_a_taint.append(RTLIL::SigSpec(RTLIL::State::S0, output_width-ports[A].size()));
        if (ports[B].size() < output_width)
            extended_b_taint.append(RTLIL::SigSpec(RTLIL::State::S0, output_width-ports[B].size()));

        // Left side of the xor
        RTLIL::SigSpec not_a_taint = module->Not(NEW_ID, extended_a_taint);
        RTLIL::SigSpec not_b_taint = module->Not(NEW_ID, extended_b_taint);
        RTLIL::SigSpec a_and_not_a_taint = module->And(NEW_ID, extended_a, not_a_taint);
        RTLIL::SigSpec b_and_not_b_taint = module->And(NEW_ID, extended_b, not_b_taint);
        RTLIL::SigSpec a_plus_b_not_taints = module->Add(NEW_ID, a_and_not_a_taint, b_and_not_b_taint);
        
        // Right side of the xor
        RTLIL::SigSpec a_or_a_taint = module->Or(NEW_ID, extended_a, extended_a_taint);
        RTLIL::SigSpec b_or_b_taint = module->Or(NEW_ID, extended_b, extended_b_taint);
        RTLIL::SigSpec a_plus_b_or_taints = module->Add(NEW_ID, a_or_a_taint, b_or_b_taint);

        // Xor, then OR with the tainted signals to produce the taint output.
        RTLIL::SigSpec a_xor_b_taints = module->Xor(NEW_ID, a_plus_b_not_taints, a_plus_b_or_taints);
        RTLIL::SigSpec a_taint_or_xor = module->Or(NEW_ID, a_xor_b_taints, extended_a_taint);
        module->addOr(NEW_ID, a_taint_or_xor, extended_b_taint, port_taints[Y][taint_id]);
    }

    return true;
}
