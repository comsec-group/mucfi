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
bool cellift_conjunctive_three_inputs(RTLIL::Module *module, RTLIL::Cell *cell, unsigned int num_taints, std::vector<string> *excluded_signals) {

    const unsigned int A = 0, B = 1, S = 2, Y = 3;
    const unsigned int NUM_PORTS = 4;
    RTLIL::SigSpec ports[NUM_PORTS] = {cell->getPort(ID::A), cell->getPort(ID::B), cell->getPort(ID::S), cell->getPort(ID::Y)};
    std::vector<RTLIL::SigSpec> port_taints[NUM_PORTS];

    int y_width = ports[Y].size();
    int s_width = ports[S].size();

    for (unsigned int i = 0; i < NUM_PORTS; ++i)
        port_taints[i] = get_corresponding_taint_signals(module, excluded_signals, ports[i], num_taints);

    for (unsigned int taint_id = 0; taint_id < num_taints; taint_id++) {
        RTLIL::SigSpec a_reduction = module->ReduceOr(NEW_ID, port_taints[A][taint_id]);
        RTLIL::SigSpec b_reduction = module->ReduceOr(NEW_ID, port_taints[B][taint_id]);
        RTLIL::SigSpec s_reduction;
        if (s_width > 1)
            s_reduction = module->ReduceOr(NEW_ID, port_taints[S][taint_id]);
        else
            s_reduction = port_taints[S][taint_id];

        if (ports[Y].size() == 1) {
            RTLIL::SigSpec before_s = module->Or(NEW_ID, a_reduction, b_reduction);
            module->addOr(NEW_ID, before_s, s_reduction, port_taints[Y][taint_id]);
        }
        else {
            RTLIL::SigSpec before_s = module->Or(NEW_ID, a_reduction, b_reduction);
            RTLIL::SigSpec singlebit_ret = module->Or(NEW_ID, before_s, s_reduction);
            RTLIL::SigSpec multibit_ret(singlebit_ret, y_width);
            module->connect(port_taints[Y][taint_id], multibit_ret);
        }
    }

    return true;
}
