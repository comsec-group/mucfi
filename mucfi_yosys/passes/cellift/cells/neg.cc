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
bool cellift_neg(RTLIL::Module *module, RTLIL::Cell *cell, unsigned int num_taints, std::vector<string> *excluded_signals) {

    const unsigned int A = 0, Y = 1;
    const unsigned int NUM_PORTS = 2;
    RTLIL::SigSpec ports[NUM_PORTS] = {cell->getPort(ID::A), cell->getPort(ID::Y)};
    std::vector<RTLIL::SigSpec> port_taints[NUM_PORTS];

    if (ports[A].size() != ports[Y].size())
        log_cmd_error("In $neg, all ports must have the same size.\n");
    for (unsigned int i = 0; i < NUM_PORTS; ++i)
        port_taints[i] = get_corresponding_taint_signals(module, excluded_signals, ports[i], num_taints);

    int data_size = ports[A].size();

    // Construct the signal with only zeros, except the LSB is one.
    std::vector<RTLIL::SigBit> one_signal;
    one_signal.push_back(RTLIL::State::S1);
    for (int i = 1; i < data_size; i++)
        one_signal.push_back(RTLIL::State::S0);

    for (unsigned int taint_id = 0; taint_id < num_taints; taint_id++) {
        RTLIL::SigSpec not_a_taint = module->Not(NEW_ID, port_taints[A][taint_id]);
        RTLIL::SigSpec a_and_not_a_taint = module->And(NEW_ID, ports[A], not_a_taint);
        RTLIL::SigSpec a_or_a_taint = module->Or(NEW_ID, ports[A], port_taints[A][taint_id]);

        RTLIL::SigSpec neg_a_and_not_a_taint = module->Neg(NEW_ID, a_and_not_a_taint);
        RTLIL::SigSpec neg_a_or_a_taint = module->Neg(NEW_ID, a_or_a_taint);

        RTLIL::SigSpec xor_out_toggled = module->Xor(NEW_ID, neg_a_and_not_a_taint, neg_a_or_a_taint);
        module->addOr(NEW_ID, xor_out_toggled, port_taints[A][taint_id], port_taints[Y][taint_id]);
    }
    return true;
}
