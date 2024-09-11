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
bool cellift_mod(RTLIL::Module *module, RTLIL::Cell *cell, unsigned int num_taints, std::vector<string> *excluded_signals) {

    const unsigned int A = 0, B = 1, Y = 2;
    const unsigned int NUM_PORTS = 3;
    RTLIL::SigSpec ports[NUM_PORTS] = {cell->getPort(ID::A), cell->getPort(ID::B), cell->getPort(ID::Y)};
    std::vector<RTLIL::SigSpec> port_taints[NUM_PORTS];

    for (unsigned int i = 0; i < NUM_PORTS; ++i)
        port_taints[i] = get_corresponding_taint_signals(module, excluded_signals, ports[i], num_taints);

    int output_width = ports[Y].size();

    for (unsigned int taint_id = 0; taint_id < num_taints; taint_id++) {
        // (a) Check whether B is tainted (in this case, the output will be fully tainted).
        RTLIL::SigBit  is_b_tainted = module->ReduceOr(NEW_ID, port_taints[B][taint_id]);
        // Prepare a SigSpec as wide as the output. This will be Or'ed with the output of (b).
        RTLIL::SigSpec is_b_tainted_sigspec = RTLIL::SigSpec(is_b_tainted, output_width);

        // (b) Apply an identical $mod to A's taint input.
        RTLIL::Wire* taint_mod_wire = module->addWire(NEW_ID, output_width);
        RTLIL::Cell* taint_mod_cell = module->addMod(NEW_ID, port_taints[A][taint_id], ports[B], taint_mod_wire);
        for (auto &param: cell->parameters)
            taint_mod_cell->setParam(param.first, param.second);
        RTLIL::SigSpec taint_mod_sigspec(taint_mod_wire);

        // Disjunct (a) and (b).
        module->addOr(NEW_ID, is_b_tainted_sigspec, taint_mod_sigspec, port_taints[Y][taint_id]);
    }

    return true;
}

/**
 * Only propagate taint of the dividend value, treating the divisor as control input.
 * @param module the current module instance
 * @param cell the current cell instance
*
 * @return keep_current_cell
 */
bool cellift_mod_data_flow(RTLIL::Module *module, RTLIL::Cell *cell, unsigned int num_taints, std::vector<string> *excluded_signals) {

    const unsigned int A = 0, B = 1, Y = 2;
    const unsigned int NUM_PORTS = 3;
    RTLIL::SigSpec ports[NUM_PORTS] = {cell->getPort(ID::A), cell->getPort(ID::B), cell->getPort(ID::Y)};
    std::vector<RTLIL::SigSpec> port_taints[NUM_PORTS];

    for (unsigned int i = 0; i < NUM_PORTS; ++i)
        port_taints[i] = get_corresponding_taint_signals(module, excluded_signals, ports[i], num_taints);

    for (unsigned int taint_id = 0; taint_id < num_taints; taint_id++) {

        // Apply an identical $mod to A's taint input.
        RTLIL::Cell* taint_mod_cell = module->addMod(NEW_ID, port_taints[A][taint_id], ports[B], port_taints[Y][taint_id]);

    }

    return true;
}
