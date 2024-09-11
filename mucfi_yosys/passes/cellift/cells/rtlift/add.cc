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
bool rtlift_add(RTLIL::Module *module, RTLIL::Cell *cell, unsigned int num_taints, std::vector<string> *excluded_signals) {

    const unsigned int A = 0, B = 1, Y = 2;
    const unsigned int NUM_PORTS = 3;
    RTLIL::SigSpec ports[NUM_PORTS] = {cell->getPort(ID::A), cell->getPort(ID::B), cell->getPort(ID::Y)};
    std::vector<RTLIL::SigSpec> port_taints[NUM_PORTS];

    for (unsigned int i = 0; i < NUM_PORTS; ++i)
        port_taints[i] = get_corresponding_taint_signals(module, excluded_signals, ports[i], num_taints);

    int output_width = ports[Y].size();
    RTLIL::SigSpec extended_a(ports[A]);
    RTLIL::SigSpec extended_b(ports[B]);
    if (ports[A].size() < output_width)
        extended_a.append(RTLIL::SigSpec(RTLIL::State::S0, output_width-ports[A].size()));
    if (ports[B].size() < output_width)
        extended_b.append(RTLIL::SigSpec(RTLIL::State::S0, output_width-ports[B].size()));

    for (unsigned int taint_id = 0; taint_id < num_taints; taint_id++) {
        // Extend the inputs to the output width.
        RTLIL::SigSpec extended_a_taint(port_taints[A][taint_id]);
        RTLIL::SigSpec extended_b_taint(port_taints[B][taint_id]);
        if (ports[A].size() < output_width)
            extended_a_taint.append(RTLIL::SigSpec(RTLIL::State::S0, output_width-ports[A].size()));
        if (ports[B].size() < output_width)
            extended_b_taint.append(RTLIL::SigSpec(RTLIL::State::S0, output_width-ports[B].size()));

        // For each output element, create a full adder.
        std::vector<RTLIL::SigBit> carries;
        std::vector<RTLIL::SigBit> carry_taints;
        carries.push_back(RTLIL::State::S0);
        carry_taints.push_back(RTLIL::State::S0);

        for (int out_bit_id = 0; out_bit_id < output_width; out_bit_id++) {
            // Implement the actual full adder for each bit.
            // Output bit.
            RTLIL::SigSpec a_xor_b = module->Xor(NEW_ID, extended_a[out_bit_id], extended_b[out_bit_id]);
            module->addXor(NEW_ID, a_xor_b, carries[out_bit_id], ports[Y][out_bit_id]);
            // Carry bit.
            RTLIL::SigSpec a_and_b = module->And(NEW_ID, extended_a[out_bit_id], extended_b[out_bit_id]);
            RTLIL::SigSpec a_xor_b_and_cin = module->And(NEW_ID, a_xor_b, carries[out_bit_id]);
            carries.push_back(module->Or(NEW_ID, a_and_b, a_xor_b_and_cin));

            // Implement the shadow logic for each bit.
            // Output taint bit.
            RTLIL::SigSpec at_or_bt = module->Or(NEW_ID, extended_a_taint[out_bit_id], extended_b_taint[out_bit_id]);
            module->addOr(NEW_ID, at_or_bt, carry_taints[out_bit_id], port_taints[Y][taint_id][out_bit_id]);
            // Carry bit.
            pool<RTLIL::SigBit> carry_out_taint_ors;
            // at and bt.
            carry_out_taint_ors.insert(module->And(NEW_ID, extended_a_taint[out_bit_id], extended_b_taint[out_bit_id]));
            // at and cint.
            carry_out_taint_ors.insert(module->And(NEW_ID, extended_a_taint[out_bit_id], carry_taints[out_bit_id]));
            // bt and cint.
            carry_out_taint_ors.insert(module->And(NEW_ID, extended_b_taint[out_bit_id], carry_taints[out_bit_id]));
            // at and the others are not equal.
            RTLIL::SigSpec b_xor_cin = module->Xor(NEW_ID, extended_b[out_bit_id], carries[out_bit_id]);
            carry_out_taint_ors.insert(module->And(NEW_ID, extended_a_taint[out_bit_id], b_xor_cin));
            // bt and the others are not equal.
            RTLIL::SigSpec a_xor_cin = module->Xor(NEW_ID, extended_a[out_bit_id], carries[out_bit_id]);
            carry_out_taint_ors.insert(module->And(NEW_ID, extended_b_taint[out_bit_id], a_xor_cin));
            // cint and the others are not equal.
            carry_out_taint_ors.insert(module->And(NEW_ID, carry_taints[out_bit_id], a_xor_b));

            carry_taints.push_back(module->ReduceOr(NEW_ID, carry_out_taint_ors));
        }
    }

    return false; // Remove the current cell in the RTLIFT case.
}
