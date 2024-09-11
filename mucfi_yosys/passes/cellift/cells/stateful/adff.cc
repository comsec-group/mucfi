#include "kernel/register.h"
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
bool cellift_adff(RTLIL::Module *module, RTLIL::Cell *cell, unsigned int num_taints, std::vector<string> *excluded_signals) {

    const unsigned int CLK = 0, ARST = 1, D = 2, Q = 3;
    const unsigned int NUM_PORTS = 4;
    RTLIL::SigSpec ports[NUM_PORTS] = {cell->getPort(ID::CLK), cell->getPort(ID::ARST), cell->getPort(ID::D), cell->getPort(ID::Q)};
    std::vector<RTLIL::SigSpec> port_taints[NUM_PORTS];
    for (unsigned int i = 0; i < NUM_PORTS; ++i)
        port_taints[i] = get_corresponding_taint_signals(module, excluded_signals, ports[i], num_taints);

    // The taint logic corresponding to an $adff cell is also an $adff with same width and same polarities.
    // Its reset value is systematically zero.

    int arst_val = 0;
    for (unsigned int taint_id = 0; taint_id < num_taints; taint_id++) {
        RTLIL::Cell *new_ff = module->addAdff(NEW_ID, ports[CLK], ports[ARST], port_taints[D][taint_id], port_taints[Q][taint_id], RTLIL::Const(arst_val, ports[Q].size()), cell->getParam(ID(CLK_POLARITY)).as_bool(), cell->getParam(ID(ARST_POLARITY)).as_bool());
        new_ff->set_bool_attribute(ID(taint_ff));
    }

    return true;
}
