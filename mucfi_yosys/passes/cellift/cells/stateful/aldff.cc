#include "kernel/register.h"
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
bool cellift_aldff(RTLIL::Module *module, RTLIL::Cell *cell, unsigned int num_taints, std::vector<string> *excluded_signals, bool opt_data_flow) {

    const unsigned int CLK = 0, ALOAD = 1, AD = 2, D = 3, Q = 4;
    const unsigned int NUM_PORTS = 5;
    RTLIL::SigSpec ports[NUM_PORTS] = {cell->getPort(ID::CLK), cell->getPort(ID::ALOAD), cell->getPort(ID::AD), cell->getPort(ID::D), cell->getPort(ID::Q)};
    std::vector<RTLIL::SigSpec> port_taints[NUM_PORTS];
    for (unsigned int i = 0; i < NUM_PORTS; ++i)
        port_taints[i] = get_corresponding_taint_signals(module, excluded_signals, ports[i], num_taints);

    int data_size = ports[AD].size();
    RTLIL::SigSpec extended_s = RTLIL::SigSpec(RTLIL::SigBit(ports[ALOAD]), data_size);

    int arst_val = 0;
    for (unsigned int taint_id = 0; taint_id < num_taints; taint_id++) {

        // same taint logic as mux: S = ALOAD, A = D, B = AD

        RTLIL::SigSpec extended_s_taint = RTLIL::SigSpec(RTLIL::SigBit(port_taints[ALOAD][taint_id]), data_size);
        RTLIL::SigSpec not_s = module->Not(NEW_ID, extended_s);

        // Mux output taint.
        RTLIL::SigSpec mux_t;

        if (!opt_data_flow) {
            // Taints coming from the data input port.
            RTLIL::SigSpec not_s_or_s_taint = module->Or(NEW_ID, extended_s_taint, not_s);
            RTLIL::SigSpec s_or_s_taint = module->Or(NEW_ID, extended_s_taint, extended_s);

            RTLIL::SigSpec a_taint_and_not_s_or_s_taint = module->And(NEW_ID, port_taints[D][taint_id], not_s_or_s_taint);
            RTLIL::SigSpec b_taint_and_s_or_s_taint = module->And(NEW_ID, port_taints[AD][taint_id], s_or_s_taint);
            RTLIL::SigSpec data_taint_stream = module->Or(NEW_ID, a_taint_and_not_s_or_s_taint, b_taint_and_s_or_s_taint);

            // Taint coming from the control input port.
            RTLIL::SigSpec a_xor_b = module->Xor(NEW_ID, ports[D], ports[AD]);
            RTLIL::SigSpec s_taint_and_a_xor_b = module->And(NEW_ID, extended_s_taint, a_xor_b);

            mux_t = module->Or(NEW_ID, s_taint_and_a_xor_b, data_taint_stream);
        } else {
            RTLIL::SigSpec not_s_and_a_taint = module->And(NEW_ID, not_s, port_taints[D][taint_id]);
            RTLIL::SigSpec s_and_b_taint = module->And(NEW_ID, extended_s, port_taints[AD][taint_id]);
            mux_t = module->Or(NEW_ID, not_s_and_a_taint, s_and_b_taint);
        }

        // aldff that passes on the taint
        RTLIL::Cell *new_ff = module->addAldff(NEW_ID, ports[CLK], ports[ALOAD], mux_t, port_taints[Q]
        [taint_id], mux_t,
                                cell->getParam(ID(CLK_POLARITY)).as_bool(), cell->getParam(ID(ALOAD_POLARITY)).as_bool(),
                                cell->get_src_attribute());
        new_ff->set_bool_attribute(ID(taint_ff));
    }

    return true;
}
