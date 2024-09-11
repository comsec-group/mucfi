#include "kernel/rtlil.h"
#include "kernel/utils.h"
#include "kernel/log.h"
#include "kernel/yosys.h"

USING_YOSYS_NAMESPACE
extern std::vector<RTLIL::SigSpec> get_corresponding_taint_signals(RTLIL::Module* module, std::vector<string> *excluded_signals, const RTLIL::SigSpec &sig, unsigned int num_taints);

/**
 * @param module the current module instance
 * @param cell the current cell instance
 * @return keep_current_cell
 */
bool cellift_pmux_large_cells(RTLIL::Module *module, RTLIL::Cell *cell, unsigned int num_taints, std::vector<string> *excluded_signals) {

    log("Instrumenting pmux with large cells.\n");

    // This implementation supposes that at most one bit of S is ever high (but more of S's taint bits can be).

    const unsigned int A = 0, B = 1, S = 2, Y = 3;
    const unsigned int NUM_PORTS = 4;
    RTLIL::SigSpec ports[NUM_PORTS] = {cell->getPort(ID::A), cell->getPort(ID::B), cell->getPort(ID::S), cell->getPort(ID::Y)};
    std::vector<RTLIL::SigSpec> port_taints[NUM_PORTS];

    for (unsigned int i = 0; i < NUM_PORTS; ++i)
        port_taints[i] = get_corresponding_taint_signals(module, excluded_signals, ports[i], num_taints);

    int a_size = ports[A].size();
    int b_size = ports[B].size();
    int s_size = ports[S].size();
    log_assert(b_size == a_size * s_size);

    // Extend to B size.
    std::vector<RTLIL::SigBit> extended_s_to_b_size_vect(b_size);
    int id_in_loop = 0;
    for (int id_in_s = 0; id_in_s < s_size; id_in_s++)
        for (int id_in_data = 0; id_in_data < a_size; id_in_data++)
            extended_s_to_b_size_vect[id_in_loop++] = ports[S][id_in_s];
    RTLIL::SigSpec extended_s_to_b_size(extended_s_to_b_size_vect);
    log_assert(extended_s_to_b_size.size() == b_size);

    for (unsigned int taint_id = 0; taint_id < num_taints; taint_id++) {
        // Extend to B size.
        std::vector<RTLIL::SigBit> extended_s_taint_to_b_size_vect(b_size);
        id_in_loop = 0;
        for (int id_in_s = 0; id_in_s < s_size; id_in_s++)
            for (int id_in_data = 0; id_in_data < a_size; id_in_data++)
                extended_s_taint_to_b_size_vect[id_in_loop++] = port_taints[S][taint_id][id_in_s];
        RTLIL::SigSpec extended_s_taint_to_b_size(extended_s_taint_to_b_size_vect);
        log_assert(extended_s_taint_to_b_size.size() == b_size);

        // Is S tainted.
        RTLIL::SigSpec is_s_tainted = module->ReduceOr(NEW_ID, port_taints[S][taint_id]);
        // S or S taint, extended to B size.
        RTLIL::SigSpec extended_s_or_s_taint_b_size = module->Or(NEW_ID, extended_s_to_b_size, extended_s_taint_to_b_size);
        log_assert(extended_s_or_s_taint_b_size.size() == b_size);
        // S or S taint, not extended to B size.
        RTLIL::SigSpec s_or_s_taint = module->Or(NEW_ID, ports[S], port_taints[S][taint_id]);
        // S taint-equal to zero.
        RTLIL::SigSpec not_s_taint = module->Not(NEW_ID, port_taints[S][taint_id]);
        RTLIL::SigSpec s_and_not_s_taint = module->And(NEW_ID, ports[S], not_s_taint);
        RTLIL::SigSpec s_taint_equal_zero = module->LogicNot(NEW_ID, s_and_not_s_taint);
        RTLIL::SigSpec extended_s_taint_equal_zero_to_a_size = RTLIL::SigSpec(RTLIL::SigBit(s_taint_equal_zero), a_size);

        // Taints coming explicitly from the data input port.
        // A
        RTLIL::SigSpec a_taint_and_s_taint_equal_zero = module->And(NEW_ID, port_taints[A][taint_id], extended_s_taint_equal_zero_to_a_size);
        // B
        RTLIL::SigSpec b_taint_and_s_taint = module->And(NEW_ID, port_taints[B][taint_id], extended_s_or_s_taint_b_size);
        // Fold the taint flow.
        vector<RTLIL::SigSpec> folded_or_b_taint_flow;
        folded_or_b_taint_flow.push_back(module->Or(NEW_ID, a_taint_and_s_taint_equal_zero, b_taint_and_s_taint.extract(0, a_size)));
        for (int id_in_s = 1; id_in_s < s_size; id_in_s++)
            folded_or_b_taint_flow.push_back(module->Or(NEW_ID, folded_or_b_taint_flow[id_in_s-1], b_taint_and_s_taint.extract(a_size*id_in_s, a_size)));

        // Prepare the AND gate between Si and Sk bits
        std::vector<SigBit> and_between_sbits_left_side, and_between_sbits_right_side;
        for (int i = 0; i < s_size-1; i++) {
            for (int k = i+1; k < s_size; k++) {
                and_between_sbits_left_side.push_back(s_or_s_taint[i]);
                and_between_sbits_right_side.push_back(s_or_s_taint[k]);
            }
        }
        RTLIL::SigSpec and_between_sbits = module->And(NEW_ID, and_between_sbits_left_side, and_between_sbits_right_side);

        // Prepare the XOR gate
        std::vector<SigBit> xor_left_side, xor_right_side;
        // Xor starts between Bi and Bk
        for (int i = 0; i < s_size-1; i++) {
            for (int k = i+1; k < s_size; k++) {
                for (int id_in_data = 0; id_in_data < a_size; id_in_data++) {
                    xor_left_side.push_back(ports[B][i*a_size+id_in_data]);
                    xor_right_side.push_back(ports[B][k*a_size+id_in_data]);
                }
            }
        }
        // Xor continues between Bi and A
        for (int i = 0; i < s_size; i++) {
            for (int id_in_data = 0; id_in_data < a_size; id_in_data++) {
                xor_left_side.push_back(ports[B][i*a_size+id_in_data]);
                xor_right_side.push_back(ports[A][id_in_data]);
            }
        }
        RTLIL::SigSpec xor_out = module->Xor(NEW_ID, xor_left_side, xor_right_side);

        // Prepare the AND gate of the middle
        std::vector<SigBit> and_mid_left_side, and_mid_right_side;
        // On the BB side
        id_in_loop = 0;
        for (int i = 0; i < s_size-1; i++) {
            for (int k = i+1; k < s_size; k++) {
                // For the left side, the output of the S&S gate must be extended
                for (int id_in_data = 0; id_in_data < a_size; id_in_data++) {
                    and_mid_left_side.push_back(and_between_sbits[id_in_loop]);
                    and_mid_right_side.push_back(xor_out[id_in_loop*a_size+id_in_data]);
                }
                id_in_loop++;
            }
        }
        // On the AB side
        for (int i = 0; i < s_size; i++) {
            // For the left side, the output of the S&S gate must be extended
            for (int id_in_data = 0; id_in_data < a_size; id_in_data++) {
                and_mid_left_side.push_back(s_or_s_taint[i]);
                and_mid_right_side.push_back(xor_out[id_in_loop*a_size+id_in_data]);
            }
            id_in_loop++;
        }
        RTLIL::SigSpec and_mid = module->And(NEW_ID, and_mid_left_side, and_mid_right_side);

        // Prepare the two OR-reduction vectors.
        // Alternatively, one could use intermediate results instead of doing one or-reduction per data bit.
        vector<pool<SigBit>> or_reduction_bb_input_pool(a_size);
        vector<pool<SigBit>> or_reduction_ab_input_pool(a_size);
        // On the BB side
        id_in_loop = 0;
        for (int i = 0; i < s_size-1; i++) {
            for (int k = i+1; k < s_size; k++) {
                for (int id_in_data = 0; id_in_data < a_size; id_in_data++)
                    or_reduction_bb_input_pool[id_in_data].insert(and_mid[id_in_loop*a_size+id_in_data]);
                id_in_loop++;
            }
        }
        // On the AB side
        for (int i = 0; i < s_size; i++) {
            // For the left side, the output of the S&S gate must be extended
            for (int id_in_data = 0; id_in_data < a_size; id_in_data++)
                or_reduction_ab_input_pool[id_in_data].insert(and_mid[id_in_loop*a_size+id_in_data]);
            id_in_loop++;
        }

        // Create one or-reduction for each data bit.
        vector<RTLIL::SigBit> or_reductions_bb_vect(a_size);
        vector<RTLIL::SigBit> or_reductions_ab_vect(a_size);
        for (int id_in_data = 0; id_in_data < a_size; id_in_data++) {
            or_reductions_bb_vect[id_in_data] = module->ReduceOr(NEW_ID, or_reduction_bb_input_pool[id_in_data]);
            or_reductions_ab_vect[id_in_data] = module->ReduceOr(NEW_ID, or_reduction_ab_input_pool[id_in_data]);
        }

        RTLIL::SigSpec or_reduction_bb(or_reductions_bb_vect);
        RTLIL::SigSpec or_reduction_ab(or_reductions_ab_vect);

        // Put everything together.
        RTLIL::SigSpec s_taint_eq_zero_and_reduce_ab = module->And(NEW_ID, extended_s_taint_equal_zero_to_a_size, or_reduction_ab);

        // Output taint.
        RTLIL::SigSpec or_ab_bb = module->Or(NEW_ID, or_reduction_bb, s_taint_eq_zero_and_reduce_ab);
        module->addOr(NEW_ID, or_reduction_bb, folded_or_b_taint_flow[s_size-1], port_taints[Y][taint_id]);
    }

    return true;
}


/**
 * Use reasonably-sized cells
 * @param module the current module instance
 * @param cell the current cell instance
 * @return keep_current_cell
 */
bool cellift_pmux_small_cells(RTLIL::Module *module, RTLIL::Cell *cell, unsigned int num_taints, std::vector<string> *excluded_signals) {

    log("Instrumenting pmux with small cells.\n");

    // This implementation supposes that at most one bit of S is ever high (but more of S's taint bits can be).

    const unsigned int A = 0, B = 1, S = 2, Y = 3;
    const unsigned int NUM_PORTS = 4;
    RTLIL::SigSpec ports[NUM_PORTS] = {cell->getPort(ID::A), cell->getPort(ID::B), cell->getPort(ID::S), cell->getPort(ID::Y)};
    std::vector<RTLIL::SigSpec> port_taints[NUM_PORTS];

    for (unsigned int i = 0; i < NUM_PORTS; ++i)
        port_taints[i] = get_corresponding_taint_signals(module, excluded_signals, ports[i], num_taints);

    int a_size = ports[A].size();
    int b_size = ports[B].size();
    int s_size = ports[S].size();
    log_assert(b_size == a_size * s_size);

    // If s_size == 1, then instrument it as a multiplexer. TODO Improve by serendipity.
    if (s_size == 1) {
        int data_size = ports[A].size();
        RTLIL::SigSpec extended_s = RTLIL::SigSpec(RTLIL::SigBit(ports[S]), data_size);

        for (unsigned int taint_id = 0; taint_id < num_taints; taint_id++) {
            RTLIL::SigSpec extended_s_taint = RTLIL::SigSpec(RTLIL::SigBit(port_taints[S][taint_id]), data_size);
            // Taints coming from the data input port.
            RTLIL::SigSpec not_s = module->Not(NEW_ID, extended_s);
            RTLIL::SigSpec not_s_or_s_taint = module->Or(NEW_ID, extended_s_taint, not_s);
            RTLIL::SigSpec s_or_s_taint = module->Or(NEW_ID, extended_s_taint, extended_s);

            RTLIL::SigSpec a_taint_and_not_s_or_s_taint = module->And(NEW_ID, port_taints[A][taint_id], not_s_or_s_taint);
            RTLIL::SigSpec b_taint_and_s_or_s_taint = module->And(NEW_ID, port_taints[B][taint_id], s_or_s_taint);
            RTLIL::SigSpec data_taint_stream = module->Or(NEW_ID, a_taint_and_not_s_or_s_taint, b_taint_and_s_or_s_taint);

            // Taint coming from the control input port.
            RTLIL::SigSpec a_xor_b = module->Xor(NEW_ID, ports[A], ports[B]);
            RTLIL::SigSpec s_taint_and_a_xor_b = module->And(NEW_ID, extended_s_taint, a_xor_b);

            // Output taint.
            module->addOr(NEW_ID, s_taint_and_a_xor_b, data_taint_stream, port_taints[Y][taint_id]);
        }
        return true;
    }

    // Else, s_size > 0

    // Extend to B size.
    std::vector<RTLIL::SigBit> extended_s_to_b_size_vect(b_size);
    int id_in_loop = 0;
    for (int id_in_s = 0; id_in_s < s_size; id_in_s++)
        for (int id_in_data = 0; id_in_data < a_size; id_in_data++)
            extended_s_to_b_size_vect[id_in_loop++] = ports[S][id_in_s];
    RTLIL::SigSpec extended_s_to_b_size(extended_s_to_b_size_vect);
    log_assert(extended_s_to_b_size.size() == b_size);

    for (unsigned int taint_id = 0; taint_id < num_taints; taint_id++) {
        // Extend to B size.
        std::vector<RTLIL::SigBit> extended_s_taint_to_b_size_vect(b_size);
        id_in_loop = 0;
        for (int id_in_s = 0; id_in_s < s_size; id_in_s++)
            for (int id_in_data = 0; id_in_data < a_size; id_in_data++)
                extended_s_taint_to_b_size_vect[id_in_loop++] = port_taints[S][taint_id][id_in_s];
        RTLIL::SigSpec extended_s_taint_to_b_size(extended_s_taint_to_b_size_vect);
        log_assert(extended_s_taint_to_b_size.size() == b_size);

        // Is S tainted.
        RTLIL::SigSpec is_s_tainted = module->ReduceOr(NEW_ID, port_taints[S][taint_id]);
        // S or S taint, extended to B size.
        RTLIL::SigSpec extended_s_or_s_taint_b_size = module->Or(NEW_ID, extended_s_to_b_size, extended_s_taint_to_b_size);
        log_assert(extended_s_or_s_taint_b_size.size() == b_size);
        // S or S taint, not extended to B size.
        RTLIL::SigSpec s_or_s_taint = module->Or(NEW_ID, ports[S], port_taints[S][taint_id]);
        // S taint-equal to zero.
        RTLIL::SigSpec not_s_taint = module->Not(NEW_ID, port_taints[S][taint_id]);
        RTLIL::SigSpec s_and_not_s_taint = module->And(NEW_ID, ports[S], not_s_taint);
        RTLIL::SigSpec s_taint_equal_zero = module->LogicNot(NEW_ID, s_and_not_s_taint);
        RTLIL::SigSpec extended_s_taint_equal_zero_to_a_size = RTLIL::SigSpec(RTLIL::SigBit(s_taint_equal_zero), a_size);

        // Taints coming explicitly from the data input port.
        // A
        RTLIL::SigSpec a_taint_and_s_taint_equal_zero = module->And(NEW_ID, port_taints[A][taint_id], extended_s_taint_equal_zero_to_a_size);
        // B
        RTLIL::SigSpec b_taint_and_s_taint = module->And(NEW_ID, port_taints[B][taint_id], extended_s_or_s_taint_b_size);
        // Fold the taint flow.
        vector<RTLIL::SigSpec> folded_or_b_taint_flow;
        folded_or_b_taint_flow.push_back(module->Or(NEW_ID, a_taint_and_s_taint_equal_zero, b_taint_and_s_taint.extract(0, a_size)));
        for (int id_in_s = 1; id_in_s < s_size; id_in_s++)
            folded_or_b_taint_flow.push_back(module->Or(NEW_ID, folded_or_b_taint_flow[id_in_s-1], b_taint_and_s_taint.extract(a_size*id_in_s, a_size)));

        // Taints coming from mismatch between A and B.
        vector<RTLIL::SigSpec> folded_a_against_b;
        for (int i = 0; i < s_size; i++) {
            RTLIL::SigSpec a_b_xor = module->Xor(NEW_ID, ports[A], ports[B].extract(a_size*i, a_size));
            RTLIL::SigSpec a_against_b_conjunction = module->And(NEW_ID, RTLIL::SigSpec(s_or_s_taint[i], a_size), a_b_xor);
            if (i == 0)
                folded_a_against_b.push_back(a_against_b_conjunction);
            else
                folded_a_against_b.push_back(module->Or(NEW_ID, folded_a_against_b[i-1], a_against_b_conjunction));
        }
        RTLIL::SigSpec a_against_b_before_checking_s_tainted = module->And(NEW_ID, extended_s_taint_equal_zero_to_a_size, folded_a_against_b[s_size-1]);
        RTLIL::SigSpec a_against_b = module->And(NEW_ID, a_against_b_before_checking_s_tainted, RTLIL::SigSpec(is_s_tainted, a_size));

        // Taints coming from mismatch between Bi and Bk.
        vector<RTLIL::SigSpec> folded_b_against_b;
        for (int i = 0; i < s_size-1; i++) {
            for (int k = i+1; k < s_size; k++) {
                RTLIL::SigSpec s_conjunction = module->And(NEW_ID, RTLIL::SigSpec(s_or_s_taint[i], a_size), RTLIL::SigSpec(s_or_s_taint[k], a_size));
                RTLIL::SigSpec b_xor = module->Xor(NEW_ID, ports[B].extract(a_size*i, a_size), ports[B].extract(a_size*k, a_size));
                RTLIL::SigSpec b_against_b_conjunction = module->And(NEW_ID, s_conjunction, b_xor);
                if (i == 0)
                    folded_b_against_b.push_back(b_against_b_conjunction);
                else
                    folded_b_against_b.push_back(module->Or(NEW_ID, folded_b_against_b[i-1], b_against_b_conjunction));
            }
        }

        // Output taint.
        RTLIL::SigSpec or_ab_bb = module->Or(NEW_ID, a_against_b, folded_b_against_b[folded_b_against_b.size()-1]);
        module->addOr(NEW_ID, or_ab_bb, folded_or_b_taint_flow[s_size-1], port_taints[Y][taint_id]);
    }

    return true;
}

/**
 * Only propagate data flow taints
 * @param module the current module instance
 * @param cell the current cell instance
 * @return keep_current_cell
 */
bool cellift_pmux_data_flow(RTLIL::Module *module, RTLIL::Cell *cell, unsigned int num_taints, std::vector<string> *excluded_signals) {

    const unsigned int A = 0, B = 1, S = 2, Y = 3;
    const unsigned int NUM_PORTS = 4;
    RTLIL::SigSpec ports[NUM_PORTS] = {cell->getPort(ID::A), cell->getPort(ID::B), cell->getPort(ID::S), cell->getPort(ID::Y)};
    std::vector<RTLIL::SigSpec> port_taints[NUM_PORTS];

    for (unsigned int i = 0; i < NUM_PORTS; ++i)
        port_taints[i] = get_corresponding_taint_signals(module, excluded_signals, ports[i], num_taints);

    int a_size = ports[A].size();
    int b_size = ports[B].size();
    int s_size = ports[S].size();
    log_assert(b_size == a_size * s_size);

    // If all bits of S are zero, propagate the taint of A
    // else propagate the taint of the selected part of B

    for (unsigned int taint_id = 0; taint_id < num_taints; taint_id++) {
        module->addPmux(NEW_ID,port_taints[A][taint_id], port_taints[B][taint_id], cell->getPort(ID::S), port_taints[Y][taint_id]);
    }

    return true;

}