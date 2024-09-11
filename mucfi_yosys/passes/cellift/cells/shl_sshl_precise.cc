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
bool cellift_shl_sshl_precise(RTLIL::Module *module, RTLIL::Cell *cell, unsigned int num_taints, std::vector<string> *excluded_signals) {

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

    log("Treating...\n");
    log("  A width:     %d\n", ports[A].size());
    log("  B width:     %d\n", ports[B].size());
    log("  Y width:     %d\n", ports[Y].size());
    log("  Cell type:   %s\n", cell->name.c_str());
    log("  Cell name:   %s\n", cell->type.c_str());
    log("  Curr module: %s\n", module->name.c_str());
    log("  Extended A size: %d\n", extended_a.size());

    for (unsigned int taint_id = 0; taint_id < num_taints; taint_id++) {
        RTLIL::SigSpec extended_a_taint = port_taints[A][taint_id];
        RTLIL::SigSpec extended_b_taint = port_taints[B][taint_id];
        if (ports[Y].size() > ports[A].size())
            extended_a_taint.append(RTLIL::SigSpec(RTLIL::State::S0, output_width-port_taints[A][taint_id].size()));
        if (clog2_y > ports[B].size())
            extended_b_taint.append(RTLIL::SigSpec(RTLIL::State::S0, clog2_y-port_taints[B][taint_id].size()));

        // Phase 1: Shift with untainted part of B.
        RTLIL::SigSpec not_b_taint = module->Not(NEW_ID, port_taints[B][taint_id]);
        RTLIL::SigSpec untainted_b = module->And(NEW_ID, ports[B], not_b_taint);

        RTLIL::SigSpec interm_a = module->Shl(NEW_ID, extended_a, untainted_b);
        RTLIL::SigSpec interm_a_taint = module->Shl(NEW_ID, extended_a_taint, untainted_b);
        RTLIL::SigSpec interm_a_or_taint = module->Or(NEW_ID, interm_a, interm_a_taint);

        log_assert(interm_a.size() == interm_a_taint.size());

        // Phase 2: Shift with tainted part of B.
        std::vector<RTLIL::SigSpec> can_b_taint_reach;

        can_b_taint_reach.push_back(RTLIL::State::S0);
        for (int k = 1; k < output_width+1; k++) {
            if (k >= 1L << b_size) {
                // If k is unreachable due to B being too narrow, then 0.
                can_b_taint_reach.push_back(RTLIL::State::S0);
            } else {
                RTLIL::SigSpec k_and_b_taint = module->And(NEW_ID, port_taints[B][taint_id], RTLIL::SigSpec(k, ports[B].size()));
                RTLIL::SigBit is_match = module->Eq(NEW_ID, k_and_b_taint, k);
                can_b_taint_reach.push_back(is_match);
            }
        }

        std::vector<SigBit> xor_left_side, xor_right_side;
        std::vector<SigBit> or_left_side, or_right_side;
        std::vector<SigBit> and_right_side;

        // Find out bitwise whether output bits are tainted.
        for (int N = 0; N < output_width; N++) {
            // log("N: %d.\n", N);

            for (int k = N; k > 0 ; k--) {
                xor_left_side.push_back(interm_a[N]);
                xor_right_side.push_back(interm_a[N-k]);

                or_left_side.push_back(interm_a_taint[N]);
                or_right_side.push_back(interm_a_taint[N-k]);

                and_right_side.push_back(can_b_taint_reach[k]);
            }
        }

        RTLIL::SigSpec a_xor = module->Xor(NEW_ID, xor_left_side, xor_right_side);
        RTLIL::SigSpec is_one_tainted = module->Or(NEW_ID, or_left_side, or_right_side);
        RTLIL::SigSpec are_tainted_or_distinct = module->Or(NEW_ID, a_xor, is_one_tainted);
        RTLIL::SigSpec and_out = module->And(NEW_ID, are_tainted_or_distinct, and_right_side);

        std::vector<pool<RTLIL::SigBit>> are_some_taint_matches;

        std::vector<SigBit> and_final_left_side, and_final_right_side;

        unsigned int curr_index = 0;
        for (int N = 0; N < output_width; N++) {

            are_some_taint_matches.push_back(pool<RTLIL::SigBit>());
            for (int k = N; k > 0 ; k--)
                are_some_taint_matches[N].insert(and_out[curr_index++]);

            // Since the tainted b can always reach zero, the taint also propagates if a_N is tainted.
            are_some_taint_matches[N].insert(interm_a_taint[N]);

            // As the last step, the taint propagates if the tainted b can be larger than N, and if a_N is high (or tainted, but this is already captured above).
            RTLIL::SigBit is_b_taint_large_enough_to_zero_out = module->Gt(NEW_ID, extended_b_taint, N);
            and_final_left_side.push_back(is_b_taint_large_enough_to_zero_out);
            and_final_right_side.push_back(interm_a_or_taint[N]);
        }

        RTLIL::SigSpec and_final_out = module->And(NEW_ID, and_final_left_side, and_final_right_side);

        for (int N = 0; N < output_width; N++) {
            are_some_taint_matches[N].insert(and_final_out[N]);
            module->addReduceOr(NEW_ID, are_some_taint_matches[N], port_taints[Y][taint_id][N]);
        }
    }

    return true;
}
