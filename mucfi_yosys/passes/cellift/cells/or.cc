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
bool cellift_or(RTLIL::Module *module, RTLIL::Cell *cell, unsigned int num_taints, std::vector<string> *excluded_signals) {

    const unsigned int A = 0, B = 1, Y = 2;
    const unsigned int NUM_PORTS = 3;
    RTLIL::SigSpec ports[NUM_PORTS] = {cell->getPort(ID::A), cell->getPort(ID::B), cell->getPort(ID::Y)};
    std::vector<RTLIL::SigSpec> port_taints[NUM_PORTS];

    for (unsigned int i = 0; i < NUM_PORTS; ++i)
        port_taints[i] = get_corresponding_taint_signals(module, excluded_signals, ports[i], num_taints);

    int output_width = ports[Y].size();
    RTLIL::SigSpec extended_a = ports[A];
    RTLIL::SigSpec extended_b = ports[B];
    if (ports[A].size() < output_width)
        extended_a.append(RTLIL::SigSpec(RTLIL::State::S0, output_width-ports[A].size()));
    else if (ports[A].size() > output_width)
        extended_a.extract(0, output_width);
    if (ports[B].size() < output_width)
        extended_b.append(RTLIL::SigSpec(RTLIL::State::S0, output_width-ports[B].size()));
    else if (ports[B].size() > output_width)
        extended_b.extract(0, output_width);

    for (unsigned int i = 0; i < NUM_PORTS; ++i)
        port_taints[i] = get_corresponding_taint_signals(module, excluded_signals, ports[i], num_taints);

    for (unsigned int taint_id = 0; taint_id < num_taints; taint_id++) {
        RTLIL::SigSpec extended_a_taint = port_taints[A][taint_id];
        RTLIL::SigSpec extended_b_taint = port_taints[B][taint_id];

        if (ports[A].size() < output_width)
            extended_a_taint.append(RTLIL::SigSpec(RTLIL::State::S0, output_width-ports[A].size()));
        else if (ports[A].size() > output_width)
            extended_a_taint.extract(0, output_width);
        if (ports[B].size() < output_width)
            extended_b_taint.append(RTLIL::SigSpec(RTLIL::State::S0, output_width-ports[B].size()));
        else if (ports[B].size() > output_width)
            extended_b_taint.extract(0, output_width);

        // The one must be tainted and the other must be 1 for the taint to propagate.
        RTLIL::SigSpec not_a = module->Not(NEW_ID, extended_a);
        RTLIL::SigSpec not_b = module->Not(NEW_ID, extended_b);
        RTLIL::SigSpec a_taint_and_not_b = module->And(NEW_ID, extended_a_taint, not_b);
        RTLIL::SigSpec b_taint_and_not_a = module->And(NEW_ID, extended_b_taint, not_a);
        RTLIL::SigSpec a_taint_and_b_taint = module->And(NEW_ID, extended_a_taint, extended_b_taint);
        RTLIL::SigSpec a_taint_and_b_or_reverse = module->Or(NEW_ID, a_taint_and_not_b, b_taint_and_not_a);
        module->addOr(NEW_ID, a_taint_and_b_or_reverse, a_taint_and_b_taint, port_taints[Y][taint_id]);
    }

    return true;
}
