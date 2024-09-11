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
bool cellift_eq_ne(RTLIL::Module *module, RTLIL::Cell *cell, unsigned int num_taints, std::vector<string> *excluded_signals) {

    const unsigned int A = 0, B = 1, Y = 2;
    const unsigned int NUM_PORTS = 3;
    RTLIL::SigSpec ports[NUM_PORTS] = {cell->getPort(ID::A), cell->getPort(ID::B), cell->getPort(ID::Y)};
    std::vector<RTLIL::SigSpec> port_taints[NUM_PORTS];
    for (unsigned int i = 0; i < NUM_PORTS; ++i)
        port_taints[i] = get_corresponding_taint_signals(module, excluded_signals, ports[i], num_taints);

    int output_width = ports[Y].size();
    int input_width = std::max(ports[A].size(), ports[B].size());
    RTLIL::SigSpec extended_a = ports[A];
    RTLIL::SigSpec extended_b = ports[B];
    if (ports[A].size() < input_width)
        if (cell->getParam(ID::A_SIGNED).as_bool())
            extended_a.append(RTLIL::SigSpec(RTLIL::State::S0, input_width-ports[A].size()));
    if (ports[B].size() < input_width)
        extended_b.append(RTLIL::SigSpec(RTLIL::State::S0, input_width-ports[B].size()));

    // For eq, the taint is transmitted to the first bit of the output whenever one of the bits is tainted.
    for (unsigned int taint_id = 0; taint_id < num_taints; taint_id++) {
        RTLIL::SigSpec extended_a_taint = port_taints[A][taint_id];
        RTLIL::SigSpec extended_b_taint = port_taints[B][taint_id];
        if (ports[A].size() < input_width)
            extended_a_taint.append(RTLIL::SigSpec(RTLIL::State::S0, input_width-ports[A].size()));
        if (ports[B].size() < input_width)
            extended_b_taint.append(RTLIL::SigSpec(RTLIL::State::S0, input_width-ports[B].size()));

        // First, check whether at least 1 input bit is tainted. Does not depend on any data.
        pool<RTLIL::SigBit> bits_to_reduce;

        for (auto &a_taint_bit: extended_a_taint.bits())
            bits_to_reduce.insert(a_taint_bit);

        for (auto &b_taint_bit: extended_b_taint.bits())
            bits_to_reduce.insert(b_taint_bit);

        RTLIL::SigSpec or_reduce_taint_output = module->ReduceOr(NEW_ID, bits_to_reduce);

        // Second, check whether the non-tainted bits match: maskdout the tainted values and compare.
        RTLIL::SigSpec disjunct_taint_ids = module->Or(NEW_ID, extended_a_taint, extended_b_taint);
        RTLIL::SigSpec not_disjunct_taint_ids = module->Not(NEW_ID, disjunct_taint_ids);
        RTLIL::SigSpec a_non_tainted_input_vals = module->And(NEW_ID, extended_a, not_disjunct_taint_ids);
        RTLIL::SigSpec b_non_tainted_input_vals = module->And(NEW_ID, extended_b, not_disjunct_taint_ids);

        RTLIL::SigSpec are_non_tainted_bits_equal = module->Eq(NEW_ID, a_non_tainted_input_vals, b_non_tainted_input_vals);

        module->addAnd(NEW_ID, are_non_tainted_bits_equal, or_reduce_taint_output, port_taints[Y][taint_id][0]);

        // For the other bits, taint the output as a constant.
        if (output_width > 1)
            module->connect(port_taints[Y][taint_id].extract_end(1), RTLIL::SigSpec(RTLIL::State::S0, output_width-1));
    }

    return true;
}
