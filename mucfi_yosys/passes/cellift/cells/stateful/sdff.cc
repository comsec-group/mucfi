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
bool cellift_sdff(RTLIL::Module *module, RTLIL::Cell *cell, unsigned int num_taints, std::vector<string> *excluded_signals) {

    const unsigned int CLK = 0, SRST = 1, D = 2, Q = 3;
    const unsigned int NUM_PORTS = 4;
    RTLIL::SigSpec ports[NUM_PORTS] = {cell->getPort(ID::CLK), cell->getPort(ID::SRST), cell->getPort(ID::D), cell->getPort(ID::Q)};
    std::vector<RTLIL::SigSpec> port_taints[NUM_PORTS];
    for (unsigned int i = 0; i < NUM_PORTS; ++i)
        port_taints[i] = get_corresponding_taint_signals(module, excluded_signals, ports[i], num_taints);

    int srst_val = 0;
    bool clk_polarity = cell->getParam(ID(CLK_POLARITY)).as_bool();
    bool rst_lvl      = cell->getParam(ID(SRST_POLARITY)).as_bool();

    for (unsigned int taint_id = 0; taint_id < num_taints; taint_id++) {
        RTLIL::Cell *new_ff = module->addSdff(NEW_ID, ports[CLK], ports[SRST], port_taints[D][taint_id], port_taints[Q][taint_id], RTLIL::Const(srst_val, ports[Q].size()), clk_polarity, rst_lvl);
        new_ff->set_bool_attribute(ID(taint_ff));
    }

    return true;
}
