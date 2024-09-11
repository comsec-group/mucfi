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
bool cellift_ge(RTLIL::Module *module, RTLIL::Cell *cell, unsigned int num_taints, std::vector<string> *excluded_signals) {

    const unsigned int A = 0, B = 1, Y = 2;
    const unsigned int NUM_PORTS = 3;
    RTLIL::SigSpec ports[NUM_PORTS] = {cell->getPort(ID::A), cell->getPort(ID::B), cell->getPort(ID::Y)};
    std::vector<RTLIL::SigSpec> port_taints[NUM_PORTS];

    log("$ge cell port sizes: A: %d, B: %d, Y: %d\n", ports[A].size(), ports[B].size(), ports[Y].size());

    for (unsigned int i = 0; i < NUM_PORTS; ++i)
        port_taints[i] = get_corresponding_taint_signals(module, excluded_signals, ports[i], num_taints);

    int is_signed_comparison = cell->getParam(ID::A_SIGNED).as_bool() && cell->getParam(ID::B_SIGNED).as_bool();
    int output_width = ports[Y].size();
    int data_size = std::max(ports[A].size(), ports[B].size());
    RTLIL::SigSpec extended_a(ports[A]);
    RTLIL::SigSpec extended_b(ports[B]);

    if (ports[A].size() < data_size) { // Sign-extend A if necessary.
        if (cell->getParam(ID::A_SIGNED).as_bool()) {
            RTLIL::SigBit curr_msb = ports[A][ports[A].size()-1];
            extended_a.append(RTLIL::SigSpec(curr_msb, data_size-ports[A].size()));
        }
        else
            extended_a.append(RTLIL::SigSpec(RTLIL::State::S0, data_size-ports[A].size()));
    }

    if (ports[B].size() < data_size) { // Sign-extend B if necessary.
        if (cell->getParam(ID::B_SIGNED).as_bool()) {
            RTLIL::SigBit curr_msb = ports[B][ports[B].size()-1];
            extended_b.append(RTLIL::SigSpec(curr_msb, data_size-ports[B].size()));
        }
        else
            extended_b.append(RTLIL::SigSpec(RTLIL::State::S0, data_size-ports[B].size()));
    }

    // Compare the two extremes.
    for (unsigned int taint_id = 0; taint_id < num_taints; taint_id++) {
        // Taints are also "sign-extended".
        RTLIL::SigSpec extended_a_taint(port_taints[A][taint_id]);
        RTLIL::SigSpec extended_b_taint(port_taints[B][taint_id]);

        if (port_taints[A][taint_id].size() < data_size) { // Sign-extend A if necessary.
            if (cell->getParam(ID::A_SIGNED).as_bool()) {
                RTLIL::SigBit curr_msb = port_taints[A][taint_id][port_taints[A][taint_id].size()-1];
                extended_a_taint.append(RTLIL::SigSpec(curr_msb, data_size-port_taints[A][taint_id].size()));
            }
            else
                extended_a_taint.append(RTLIL::SigSpec(RTLIL::State::S0, data_size-port_taints[A][taint_id].size()));
        }
        if (port_taints[B][taint_id].size() < data_size) { // Sign-extend B if necessary.
            if (cell->getParam(ID::B_SIGNED).as_bool()) {
                RTLIL::SigBit curr_msb = port_taints[B][taint_id][port_taints[B][taint_id].size()-1];
                extended_b_taint.append(RTLIL::SigSpec(curr_msb, data_size-port_taints[B][taint_id].size()));
            }
            else
                extended_b_taint.append(RTLIL::SigSpec(RTLIL::State::S0, data_size-port_taints[B][taint_id].size()));
        }

        RTLIL::SigSpec not_a_taint_lsbs = module->Not(NEW_ID, extended_a_taint.extract(0, data_size-1));
        RTLIL::SigSpec not_a_taint_msb = module->Not(NEW_ID, extended_a_taint[data_size-1]);
        RTLIL::SigSpec not_b_taint_lsbs = module->Not(NEW_ID, extended_b_taint.extract(0, data_size-1));
        RTLIL::SigSpec not_b_taint_msb = module->Not(NEW_ID, extended_b_taint[data_size-1]);

        // Compute the minimal and maximal possible value for A and for B when influenced by the taints.
        RTLIL::SigSpec min_a_msb;
        RTLIL::SigSpec min_b_msb;
        RTLIL::SigSpec max_a_msb;
        RTLIL::SigSpec max_b_msb;
        if (is_signed_comparison) {
            min_a_msb = module->Or(NEW_ID, extended_a[data_size-1], extended_a_taint[data_size-1]); // i.e., try to reach 1.
            min_b_msb = module->Or(NEW_ID, extended_b[data_size-1], extended_b_taint[data_size-1]); // i.e., try to reach 1.
            max_a_msb = module->And(NEW_ID, extended_a[data_size-1], not_a_taint_msb); // i.e., try to reach 0.
            max_b_msb = module->And(NEW_ID, extended_b[data_size-1], not_b_taint_msb); // i.e., try to reach 0.
        }
        else { // unsigned comparison
            min_a_msb = module->And(NEW_ID, extended_a[data_size-1], not_a_taint_msb); // i.e., try to reach 0.
            min_b_msb = module->And(NEW_ID, extended_b[data_size-1], not_b_taint_msb); // i.e., try to reach 0.
            max_a_msb = module->Or(NEW_ID, extended_a[data_size-1], extended_a_taint[data_size-1]); // i.e., try to reach 1.
            max_b_msb = module->Or(NEW_ID, extended_b[data_size-1], extended_b_taint[data_size-1]); // i.e., try to reach 1.
        }

        // LSBs are always unset for minimization and set for maximization, whenever tainted.
        RTLIL::SigSpec min_a = module->And(NEW_ID, extended_a.extract(0, data_size-1), not_a_taint_lsbs);
        RTLIL::SigSpec min_b = module->And(NEW_ID, extended_b.extract(0, data_size-1), not_b_taint_lsbs);
        RTLIL::SigSpec max_a = module->Or(NEW_ID, extended_a.extract(0, data_size-1), extended_a_taint.extract(0, data_size-1));
        RTLIL::SigSpec max_b = module->Or(NEW_ID, extended_b.extract(0, data_size-1), extended_b_taint.extract(0, data_size-1));

        // Append the MSB.
        min_a.append(min_a_msb);
        min_b.append(min_b_msb);
        max_a.append(max_a_msb);
        max_b.append(max_b_msb);

        // Instantiate the same gate with the two extremes.
        RTLIL::Wire *min_a_max_b_out = module->addWire(NEW_ID, 1);
        RTLIL::Wire *max_a_min_b_out = module->addWire(NEW_ID, 1);
        RTLIL::Cell *min_a_max_b_cell = module->addGe(NEW_ID, min_a, max_b, min_a_max_b_out);
        RTLIL::Cell *max_a_min_b_cell = module->addGe(NEW_ID, max_a, min_b, max_a_min_b_out);

        // Give the same parameters to the new comparison gates.
        for (auto &param: cell->parameters) {
            min_a_max_b_cell->setParam(param.first, param.second);
            max_a_min_b_cell->setParam(param.first, param.second);
        }
        min_a_max_b_cell->setParam(ID::A_WIDTH, data_size);
        max_a_min_b_cell->setParam(ID::A_WIDTH, data_size);
        min_a_max_b_cell->setParam(ID::B_WIDTH, data_size);
        max_a_min_b_cell->setParam(ID::B_WIDTH, data_size);
        min_a_max_b_cell->setParam(ID::Y_WIDTH, 1);
        max_a_min_b_cell->setParam(ID::Y_WIDTH, 1);

        // Xor the two comparison outputs to find a possible difference.
        module->addXor(NEW_ID, min_a_max_b_out, max_a_min_b_out, port_taints[Y][taint_id][0]);

        // For the other bits, taint the output as a constant.
        if (output_width > 1)
            module->connect(port_taints[Y][taint_id].extract_end(1), RTLIL::SigSpec(RTLIL::State::S0, output_width-1));
    }

    return true;
}
