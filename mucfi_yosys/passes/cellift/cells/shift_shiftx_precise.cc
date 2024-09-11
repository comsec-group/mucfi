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
bool cellift_shift_shiftx_precise(RTLIL::Module *module, RTLIL::Cell *cell, unsigned int num_taints, std::vector<string> *excluded_signals) {

    const unsigned int A = 0, B = 1, Y = 2;
    const unsigned int NUM_PORTS = 3;
    RTLIL::SigSpec ports[NUM_PORTS] = {cell->getPort(ID::A), cell->getPort(ID::B), cell->getPort(ID::Y)};
    std::vector<RTLIL::SigSpec> port_taints[NUM_PORTS];

    for (unsigned int i = 0; i < NUM_PORTS; ++i)
        port_taints[i] = get_corresponding_taint_signals(module, excluded_signals, ports[i], num_taints);

    int is_b_signed = cell->getParam(ID::B_SIGNED).as_int(true);

    int b_size = ports[B].size();
    int output_data_width = ports[Y].size();
    int extended_width = std::max(output_data_width, ports[A].size());

    // Extend the input A port to the output widths.
    RTLIL::SigSpec extended_a = ports[A];
    if (output_data_width > ports[A].size())
        extended_a.append(RTLIL::SigSpec(RTLIL::State::S0, output_data_width-ports[A].size()));
    RTLIL::SigSpec not_a = module->Not(NEW_ID, extended_a);
    RTLIL::SigSpec not_b = module->Not(NEW_ID, ports[B]);

    for (unsigned int taint_id = 0; taint_id < num_taints; taint_id++) {
        // Extend A taint.
        RTLIL::SigSpec extended_a_taint = port_taints[A][taint_id];
        if (output_data_width > ports[A].size())
            extended_a_taint.append(RTLIL::SigSpec(RTLIL::State::S0, port_taints[Y][taint_id].size()-port_taints[A][taint_id].size()));
        RTLIL::SigSpec a_or_a_taint = module->Or(NEW_ID, extended_a, extended_a_taint);

        // Compute utility SigSpecs for later.
        RTLIL::SigSpec not_b_taint = module->Not(NEW_ID, port_taints[B][taint_id]);

        // Starts from -output_data_width and reaches +output_data_width
        std::vector<RTLIL::SigBit> can_b_taint_reach_offset;

        // Limits reachable by b according to its width.
        // Depends on whether B is signed or unsigned.

        double min_reachable;
        double max_reachable;
        if (is_b_signed) {
            min_reachable = -pow(2, b_size-1);
            max_reachable = -min_reachable -1;
        } else {
            min_reachable = 0;
            max_reachable = pow(2, b_size)-1;
        }

        for (int k = -extended_width; k < extended_width+1; k++) {
            if (k < min_reachable || k > max_reachable) {
                // If k is unreachable due to B being too narrow, then 0.
                can_b_taint_reach_offset.push_back(RTLIL::State::S0);
            } else {
                int k_width = 0;

                if (k) {
                    if (!is_b_signed)
                        k_width = ceil_log2(k+1);
                    else { // Signed b
                        if (k > 0)
                            k_width = ceil_log2(k+1)+1;
                        else // k < 0
                            k_width = ceil_log2(-k+1);
                    }
                }

                RTLIL::SigSpec extended_k(k, k_width);
                // Extend k if useful (use sign-extension).
                if (b_size > extended_k.size()) {
                    if (k < 0)
                        extended_k.append(RTLIL::SigSpec(RTLIL::State::S1, b_size-k_width));
                    else
                        extended_k.append(RTLIL::SigSpec(RTLIL::State::S0, b_size-k_width));
                }


                // k is reachable under two conjunctive conditions: (1) all zeros in k must be T= 0 in b, and (2) all ones in k must be T= 1 in b.
                // Condition (1).
                RTLIL::SigSpec b_taint_or_not_b = module->Or(NEW_ID, not_b, port_taints[B][taint_id]);
                RTLIL::SigSpec not_k = module->Not(NEW_ID, extended_k);
                RTLIL::SigSpec not_k_and_b_taint_or_not_b = module->And(NEW_ID, not_k, b_taint_or_not_b);
                RTLIL::SigBit k_condition_one = module->Eq(NEW_ID, not_k_and_b_taint_or_not_b, not_k);

                // Condition (2).
                RTLIL::SigSpec b_taint_or_b = module->Or(NEW_ID, ports[B], port_taints[B][taint_id]);
                RTLIL::SigSpec k_and_b_taint_or_b = module->And(NEW_ID, extended_k, b_taint_or_b);
                RTLIL::SigBit k_condition_two = module->Eq(NEW_ID, k_and_b_taint_or_b, extended_k);

                // Conjunction of the two conditions.
                can_b_taint_reach_offset.push_back(module->And(NEW_ID, k_condition_one, k_condition_two));
            }
        }

        // Determine the "a-taint-distinct-a" property.
        std::vector<std::vector<RTLIL::SigBit>> a_taint_or_distinct_a; // The first dimension is always smaller or equal to the second dimension.
        for (int i = 0; i < extended_width; i++) {
            std::vector<RTLIL::SigBit> a_taint_or_distinct_a_line;
            // For j < i.
            for (int j = 0; j < i; j++) {
                RTLIL::SigBit are_distinct = module->Xor(NEW_ID, extended_a[i], extended_a[j]);
                RTLIL::SigBit is_some_tainted = module->Or(NEW_ID, extended_a_taint[i], extended_a_taint[j]);
                a_taint_or_distinct_a_line.push_back(module->Or(NEW_ID, are_distinct, is_some_tainted));
            }
            // For j == i, cannot be different from itself but can be tainted.
            a_taint_or_distinct_a_line.push_back(extended_a_taint[i]);
            // Add the line to the table.
            a_taint_or_distinct_a.push_back(a_taint_or_distinct_a_line);
        }

        // Determine the "a-taint-or-one" property.
        RTLIL::SigSpec a_taint_or_one = module->Or(NEW_ID, extended_a, extended_a_taint);

        // Find out bitwise whether output bits are tainted.
        for (int out_bit_id = 0; out_bit_id < output_data_width; out_bit_id++) {
            pool<RTLIL::SigBit> is_some_match;

            // First, iterate through all the spacing values.
            for (int spacing = 0; spacing < extended_width; spacing++) {
                for (int offset_high = -out_bit_id+spacing; offset_high < extended_width-out_bit_id; offset_high++) {

                    int offset_low = offset_high-spacing;
                    int index_low = offset_low+out_bit_id;
                    int index_high = index_low+spacing;

                    // can_b_taint_reach_offset has a negative offset of extended_width.
                    RTLIL::SigBit can_b_reach_both = module->And(NEW_ID, can_b_taint_reach_offset[offset_low+extended_width], can_b_taint_reach_offset[offset_high+extended_width]);
                    is_some_match.insert(module->And(NEW_ID, can_b_reach_both, a_taint_or_distinct_a[index_high][index_low]));
                }
            }

            // Find out whether the current output bit can be set or tainted. Combined with the ability of B to be large, it provides information about the output bit taint.

            pool<RTLIL::SigBit> can_be_set_or_tainted_pool;
            for (int offset = -out_bit_id; offset < extended_width-out_bit_id; offset++) {
                can_be_set_or_tainted_pool.insert(module->And(NEW_ID, a_or_a_taint[offset+out_bit_id], can_b_taint_reach_offset[extended_width+offset]));
            }
            RTLIL::SigBit can_be_set_or_tainted = module->ReduceOr(NEW_ID, can_be_set_or_tainted_pool);

            // Second, check whether b can overflow. (i) check whether B is wide enough to reach the given limit. (ii) Check whether B indeed reaches this limit.
            int upper_limit = extended_width-out_bit_id;
            int lower_limit = -out_bit_id-1;

            // Upper limit: B must be wide enough. Pay attention to signedness.
            RTLIL::SigBit is_b_upper_overflow;

            if (max_reachable < upper_limit)
                is_b_upper_overflow = RTLIL::State::S0;						
            else {

                RTLIL::Wire* b_ge_wire = module->addWire(NEW_ID, 1);

                // Generate the largest possible B value depending on its signedness.
                RTLIL::SigBit max_b_msb;
                RTLIL::SigBit not_b_taint_msb = module->Not(NEW_ID, port_taints[B][taint_id][b_size-1]);

                if (is_b_signed) {
                    max_b_msb = module->And(NEW_ID, ports[B][b_size-1], not_b_taint_msb); // i.e., try to reach 0.
                }
                else { // unsigned comparison
                    max_b_msb = module->Or(NEW_ID, ports[B][b_size-1], port_taints[B][taint_id][b_size-1]); // i.e., try to reach 1.
                }

                RTLIL::SigSpec max_b;
                if (b_size > 1) {
                    max_b = module->Or(NEW_ID, ports[B].extract(0, b_size-1), port_taints[B][taint_id].extract(0, b_size-1));
                    max_b.append(max_b_msb);
                } else
                    max_b = max_b_msb;

                RTLIL::Cell* b_ge_cell = module->addGe(NEW_ID, max_b, RTLIL::SigSpec(upper_limit, b_size), b_ge_wire);

                b_ge_cell->setParam("\\A_SIGNED", false);
                b_ge_cell->setParam("\\B_SIGNED", false); // B is positive anyways. The upper limit should not reach the order of magnitude of 2**31.
                b_ge_cell->setParam("\\A_WIDTH", b_size);
                b_ge_cell->setParam("\\B_WIDTH", b_size);
                b_ge_cell->setParam("\\Y_WIDTH", 1);

                // Make sure that b can be positive
                if (is_b_signed) {
                    RTLIL::SigBit can_be_positive = module->Or(NEW_ID, port_taints[B][taint_id][b_size-1], not_b[b_size-1]);
                    RTLIL::SigBit is_ge = module->And(NEW_ID, b_ge_wire, can_be_positive);
                    is_b_upper_overflow = module->And(NEW_ID, can_be_set_or_tainted, is_ge);
                }
                else
                    is_b_upper_overflow = module->And(NEW_ID, can_be_set_or_tainted, b_ge_wire);
            }

            // Lower limit: B must be wide enough. Can only be reached if B is signed.
            RTLIL::SigBit is_b_lower_overflow;
            if (min_reachable > lower_limit) { // Always true when B is signed

                is_b_lower_overflow = RTLIL::State::S0;
            }
            else {

                RTLIL::Wire* b_le_wire = module->addWire(NEW_ID, 1);

                // Generate the smallest possible B value: unset all the tainted bits except the MSB because B is signed.
                RTLIL::SigBit min_b_msb;
                min_b_msb = module->Or(NEW_ID, ports[B][b_size-1], port_taints[B][taint_id][b_size-1]); // i.e., try to reach 0.

                RTLIL::SigSpec min_b;
                if (b_size > 1) {
                    min_b = module->And(NEW_ID, ports[B].extract(0, b_size-1), not_b_taint.extract(0, b_size-1));
                    min_b.append(min_b_msb);
                } else
                    min_b = min_b_msb;

                RTLIL::Cell* b_le_cell = module->addLe(NEW_ID, min_b, RTLIL::SigSpec(lower_limit, b_size), b_le_wire);

                b_le_cell->setParam("\\A_SIGNED", true);
                b_le_cell->setParam("\\B_SIGNED", true); // B is positive anyways. The lower limit should not reach the order of magnitude of 2**31.
                b_le_cell->setParam("\\A_WIDTH", b_size);
                b_le_cell->setParam("\\B_WIDTH", b_size);
                b_le_cell->setParam("\\Y_WIDTH", 1);

                log("Connecting is_b_lower_overflow (out bit %d).\n", out_bit_id);
                is_b_lower_overflow = module->And(NEW_ID, can_be_set_or_tainted, b_le_wire);
            }

            is_some_match.insert(module->Or(NEW_ID, is_b_upper_overflow, is_b_lower_overflow));

            module->addReduceOr(NEW_ID, is_some_match, port_taints[Y][taint_id][out_bit_id]);
        }
    }

    return true;
}
