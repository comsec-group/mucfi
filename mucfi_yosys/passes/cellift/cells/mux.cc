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
bool cellift_mux(RTLIL::Module *module, RTLIL::Cell *cell, unsigned int num_taints, std::vector<string> *excluded_signals, bool opt_data_flow) {

    const unsigned int A = 0, B = 1, S = 2, Y = 3;
    const unsigned int NUM_PORTS = 4;
    RTLIL::SigSpec ports[NUM_PORTS] = {cell->getPort(ID::A), cell->getPort(ID::B), cell->getPort(ID::S), cell->getPort(ID::Y)};
    std::vector<RTLIL::SigSpec> port_taints[NUM_PORTS];

    if (ports[A].size() != ports[B].size() || ports[B].size() != ports[Y].size())
        log_cmd_error("In $mux, all data ports must have the same size.\n");
    for (unsigned int i = 0; i < NUM_PORTS; ++i)
        port_taints[i] = get_corresponding_taint_signals(module, excluded_signals, ports[i], num_taints);

    int data_size = ports[A].size();
    RTLIL::SigSpec extended_s = RTLIL::SigSpec(RTLIL::SigBit(ports[S]), data_size);
    RTLIL::SigSpec not_s = module->Not(NEW_ID, extended_s);

    for (unsigned int taint_id = 0; taint_id < num_taints; taint_id++) {
        RTLIL::SigSpec extended_s_taint = RTLIL::SigSpec(RTLIL::SigBit(port_taints[S][taint_id]), data_size);
        // Taints coming from the data input port.

        if (!opt_data_flow) {
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
        } else {
            RTLIL::SigSpec not_s_and_a_taint = module->And(NEW_ID, not_s, port_taints[A][taint_id]);
            RTLIL::SigSpec s_and_b_taint = module->And(NEW_ID, extended_s, port_taints[B][taint_id]);
            module->addOr(NEW_ID, not_s_and_a_taint, s_and_b_taint, port_taints[Y][taint_id]);
        }
    }

    return true;
}
