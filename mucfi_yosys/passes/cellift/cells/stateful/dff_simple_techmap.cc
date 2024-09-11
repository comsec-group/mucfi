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
bool cellift_dff_simple_techmap(RTLIL::Module *module, RTLIL::Cell *cell, unsigned int num_taints, std::vector<string> *excluded_signals) {

    const unsigned int D = 0, Q = 1, C = 2;
    const unsigned int NUM_PORTS = 3;
    RTLIL::SigSpec ports[NUM_PORTS] = {cell->getPort(ID::D), cell->getPort(ID::Q), cell->getPort(ID::C)};
    std::vector<RTLIL::SigSpec> port_taints[2]; // The clock is always considered untainted

    if (ports[D].size() != 1 || ports[Q].size() != 1)
        log_cmd_error("Multi-bit signal found.  Run `splitnets` first.\n");
    port_taints[D] = get_corresponding_taint_signals(module, excluded_signals, ports[D], num_taints);
    port_taints[Q] = get_corresponding_taint_signals(module, excluded_signals, ports[Q], num_taints);

    bool clk_polarity = cell->type.in(ID($_DFF_P_));
    for (unsigned int taint_id = 0; taint_id < num_taints; taint_id++) {
        RTLIL::Cell *new_ff = module->addDff(cell->name.str() + "_taint_dff_" + std::to_string(taint_id), ports[C], port_taints[D][taint_id], port_taints[Q][taint_id], clk_polarity);
        new_ff->set_bool_attribute(ID(taint_ff));
    }

    return true;
}
