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
bool cellift_logic_and(RTLIL::Module *module, RTLIL::Cell *cell, unsigned int num_taints, std::vector<string> *excluded_signals) {

    const unsigned int A = 0, B = 1, Y = 2;
    const unsigned int NUM_PORTS = 3;
    RTLIL::SigSpec ports[NUM_PORTS] = {cell->getPort(ID::A), cell->getPort(ID::B), cell->getPort(ID::Y)};
    std::vector<RTLIL::SigSpec> port_taints[NUM_PORTS];

    for (unsigned int i = 0; i < NUM_PORTS; ++i)
        port_taints[i] = get_corresponding_taint_signals(module, excluded_signals, ports[i], num_taints);

    if (ports[A].size() == 1 && ports[B].size() == 1) // Equivalent to traditional and operator.
        for (unsigned int taint_id = 0; taint_id < num_taints; taint_id++) {
            RTLIL::SigSpec a_taint_and_b = module->And(NEW_ID, port_taints[A][taint_id], ports[B]);
            RTLIL::SigSpec b_taint_and_a = module->And(NEW_ID, port_taints[B][taint_id], ports[A]);
            RTLIL::SigSpec a_taint_and_b_taint = module->And(NEW_ID, port_taints[A][taint_id], port_taints[B][taint_id]);
            RTLIL::SigSpec a_taint_and_b_or_reverse = module->Or(NEW_ID, a_taint_and_b, b_taint_and_a);
            module->addOr(NEW_ID, a_taint_and_b_or_reverse, a_taint_and_b_taint, port_taints[Y][taint_id][0]);

            // For the other bits, taint the output as a constant.
            if (ports[Y].size() > 1)
                module->connect(port_taints[Y][taint_id].extract_end(1), RTLIL::SigSpec(RTLIL::State::S0, ports[Y].size()-1));
        }
    else
        for (unsigned int taint_id = 0; taint_id < num_taints; taint_id++) {
            RTLIL::SigSpec not_a_taint = module->Not(NEW_ID, port_taints[A][taint_id]);
            RTLIL::SigSpec not_b_taint = module->Not(NEW_ID, port_taints[B][taint_id]);

            // Instantiate the tainted assignments for A and B that maximize/minimize the possibility of a $logic_and. 
            RTLIL::SigSpec min_a = module->And(NEW_ID, ports[A], not_a_taint);
            RTLIL::SigSpec max_a = module->Or(NEW_ID, ports[A], port_taints[A][taint_id]);
            RTLIL::SigSpec min_b = module->And(NEW_ID, ports[B], not_b_taint);
            RTLIL::SigSpec max_b = module->Or(NEW_ID, ports[B], port_taints[B][taint_id]);

            RTLIL::SigSpec min_a_bit = module->ReduceOr(NEW_ID, min_a);
            RTLIL::SigSpec max_a_bit = module->ReduceOr(NEW_ID, max_a);
            RTLIL::SigSpec min_b_bit = module->ReduceOr(NEW_ID, min_b);
            RTLIL::SigSpec max_b_bit = module->ReduceOr(NEW_ID, max_b);

            // Instantiate the maximal and minimal $logic_and.
            RTLIL::SigSpec min_and = module->And(NEW_ID, min_a_bit, min_b_bit);
            RTLIL::SigSpec max_and = module->And(NEW_ID, max_a_bit, max_b_bit);

            // Xor them to see if the output can be influenced by tainted inputs.
            module->addXor(NEW_ID, min_and, max_and, port_taints[Y][taint_id][0]);

            // For the other bits, taint the output as a constant.
            if (ports[Y].size() > 1)
                module->connect(port_taints[Y][taint_id].extract_end(1), RTLIL::SigSpec(RTLIL::State::S0, ports[Y].size()-1));
        }

    return true;
}
