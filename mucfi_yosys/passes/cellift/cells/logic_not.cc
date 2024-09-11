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
bool cellift_logic_not(RTLIL::Module *module, RTLIL::Cell *cell, unsigned int num_taints, std::vector<string> *excluded_signals) {

    const unsigned int A = 0, Y = 1;
    const unsigned int NUM_PORTS = 2;
    RTLIL::SigSpec ports[NUM_PORTS] = {cell->getPort(ID::A), cell->getPort(ID::Y)};
    std::vector<RTLIL::SigSpec> port_taints[NUM_PORTS];

    for (unsigned int i = 0; i < NUM_PORTS; ++i)
        port_taints[i] = get_corresponding_taint_signals(module, excluded_signals, ports[i], num_taints);

    int data_size = ports[A].size();

    if (data_size == 1) // If data size is one, then this is a normal not.
        for (unsigned int taint_id = 0; taint_id < num_taints; taint_id++) {
            module->connect(port_taints[Y][taint_id][0], port_taints[A][taint_id]);

            // For the other bits, taint the output as a constant.
            if (ports[Y].size() > 1)
                module->connect(port_taints[Y][taint_id].extract_end(1), RTLIL::SigSpec(RTLIL::State::S0, ports[Y].size()-1));
        }
    else
        for (unsigned int taint_id = 0; taint_id < num_taints; taint_id++) {
            // The output can be influenced only if there is at least one tainted bit, and if all the up bits are tainted. 
            RTLIL::SigSpec reduce_or_taint = module->ReduceOr(NEW_ID, port_taints[A][taint_id]);

            RTLIL::SigSpec not_a_taint = module->Not(NEW_ID, port_taints[A][taint_id]);
            RTLIL::SigSpec non_tainted_inputs = module->And(NEW_ID, ports[A], not_a_taint);
            RTLIL::SigSpec not_is_some_high_input_not_tainted = module->LogicNot(NEW_ID, non_tainted_inputs);

            module->addAnd(NEW_ID, not_is_some_high_input_not_tainted, reduce_or_taint, port_taints[Y][taint_id][0]);

            // For the other bits, taint the output as a constant.
            if (ports[Y].size() > 1)
                module->connect(port_taints[Y][taint_id].extract_end(1), RTLIL::SigSpec(RTLIL::State::S0, ports[Y].size()-1));
        }

    return true;
}
