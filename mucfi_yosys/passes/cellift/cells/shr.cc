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
bool cellift_shr(RTLIL::Module *module, RTLIL::Cell *cell, unsigned int num_taints, std::vector<string> *excluded_signals) {

    const unsigned int A = 0, B = 1, Y = 2;
    const unsigned int NUM_PORTS = 3;
    RTLIL::SigSpec ports[NUM_PORTS] = {cell->getPort(ID::A), cell->getPort(ID::B), cell->getPort(ID::Y)};
    std::vector<RTLIL::SigSpec> port_taints[NUM_PORTS];

    for (unsigned int i = 0; i < NUM_PORTS; ++i)
        port_taints[i] = get_corresponding_taint_signals(module, excluded_signals, ports[i], num_taints);

    int b_size = ports[B].size();
    int output_width = ports[Y].size();
    int clog2_y = ceil(log2(output_width));

    // Extend the input A port to the output widths.
    RTLIL::SigSpec extended_a = ports[A];
    if (output_width > ports[A].size())
        extended_a.append(RTLIL::SigSpec(RTLIL::State::S0, output_width-ports[A].size()));

    for (unsigned int taint_id = 0; taint_id < num_taints; taint_id++) {
        RTLIL::SigSpec extended_a_taint = port_taints[A][taint_id];
        RTLIL::SigSpec extended_b_taint = port_taints[B][taint_id];
        if (output_width > ports[A].size())
            extended_a_taint.append(RTLIL::SigSpec(RTLIL::State::S0, output_width-port_taints[A][taint_id].size()));
        if (clog2_y > ports[B].size())
            extended_b_taint.append(RTLIL::SigSpec(RTLIL::State::S0, clog2_y-port_taints[B][taint_id].size()));

        // Phase 1: Shift with untainted part of B.
        RTLIL::SigSpec not_b_taint = module->Not(NEW_ID, port_taints[B][taint_id]);
        RTLIL::SigSpec untainted_b = module->And(NEW_ID, ports[B], not_b_taint);

        RTLIL::SigSpec interm_a = module->Shr(NEW_ID, extended_a, untainted_b);
        RTLIL::SigSpec interm_a_taint = module->Shr(NEW_ID, extended_a_taint, untainted_b);
        RTLIL::SigSpec interm_a_or_taint = module->Or(NEW_ID, interm_a, interm_a_taint);

        log_assert(interm_a.size() == interm_a_taint.size());

        // Phase 2: Shift with tainted part of B.

        std::vector<RTLIL::SigBit> can_b_taint_reach;

        can_b_taint_reach.push_back(RTLIL::State::S0);
        for (int k = 1; k < output_width+1; k++) {
            if (k >= 1L << b_size) {
                // If k is unreachable due to B being too narrow, then 0.
                can_b_taint_reach.push_back(RTLIL::State::S0);
            } else {
                RTLIL::SigSpec k_and_b_taint = module->And(NEW_ID, port_taints[B][taint_id], RTLIL::SigSpec(k, ports[B].size()));
                RTLIL::SigSpec is_match = module->Eq(NEW_ID, k_and_b_taint, k);
                can_b_taint_reach.push_back(is_match);
            }
        }

        // Reduces the repeated or and xor cells
        std::vector<SigBit> xor_left_side, xor_right_side;
        std::vector<SigBit> or_taint_left_side, or_taint_right_side;
        std::vector<SigBit> and_right_side;
        for (int N = 0; N < output_width; N++) {
            for (int k = 1; k < output_width-N; k++) {
                xor_left_side.push_back(interm_a[N]);
                xor_right_side.push_back(interm_a[N+k]);

                or_taint_left_side.push_back(interm_a_taint[N]);
                or_taint_right_side.push_back(interm_a_taint[N+k]);

                and_right_side.push_back(can_b_taint_reach[k]);
            }
        }
        RTLIL::SigSpec xor_out = module->Xor(NEW_ID, xor_left_side, xor_right_side);
        RTLIL::SigSpec or_taint_out = module->Or(NEW_ID, or_taint_left_side, or_taint_right_side);
        RTLIL::SigSpec or_diff_out = module->Or(NEW_ID, xor_out, or_taint_out);
        RTLIL::SigSpec and_out = module->And(NEW_ID, or_diff_out, and_right_side);

        std::vector<SigBit> and_final_right_side, and_final_left_side;

        // Find out bitwise whether output bits are tainted.
        std::vector<pool<RTLIL::SigBit>> are_some_taint_matches;

        unsigned int curr_index = 0;
        for (int N = 0; N < output_width; N++) {

            are_some_taint_matches.push_back(pool<RTLIL::SigBit>());
            for (int k = 1; k < output_width-N; k++)
                are_some_taint_matches[N].insert(and_out[curr_index++]);

            // Since the tainted b can always reach zero, the taint also propagates if a_N is tainted.
            are_some_taint_matches[N].insert(interm_a_taint[N]);

            // As the last step, the taint propagates if the tainted b can be larger than N, and if a_N is high (or tainted, but this is already captured above).

            // RTLIL::SigBit is_b_taint_large_enough_to_zero_out = module->Ge(NEW_ID, extended_b_taint, ports[A].size()-N);
            and_final_right_side.push_back(module->Ge(NEW_ID, extended_b_taint, ports[A].size()-N)); // To look: maybe output_data_size-N instead?
        }

        RTLIL::SigSpec and_final = module->And(NEW_ID, interm_a_or_taint, and_final_right_side);

        for (int N = 0; N < output_width; N++) {
            are_some_taint_matches[N].insert(and_final[N]);
            module->addReduceOr(NEW_ID, are_some_taint_matches[N], port_taints[Y][taint_id][N]);
        }
    }

    return true;
}
