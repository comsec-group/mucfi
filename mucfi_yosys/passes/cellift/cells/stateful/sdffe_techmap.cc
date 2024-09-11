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
bool cellift_sdffe_techmap(RTLIL::Module *module, RTLIL::Cell *cell, unsigned int num_taints, std::vector<string> *excluded_signals, bool opt_data_flow) {

    const unsigned int C = 0, R = 1, E = 2, D = 3, Q = 4;
    const unsigned int NUM_PORTS = 5;
    RTLIL::SigSpec ports[NUM_PORTS] = {cell->getPort(ID::C), cell->getPort(ID::R), cell->getPort(ID::E), cell->getPort(ID::D), cell->getPort(ID::Q)};
    std::vector<RTLIL::SigSpec> port_taints[NUM_PORTS];
    for (unsigned int i = 0; i < NUM_PORTS; ++i)
        port_taints[i] = get_corresponding_taint_signals(module, excluded_signals, ports[i], num_taints);

    int data_width = ports[D].size();
    int clk_polarity = cell->type.in(ID($_SDFFE_PN0N_), ID($_SDFFE_PN0P_), ID($_SDFFE_PN1N_), ID($_SDFFE_PN1P_), ID($_SDFFE_PP0N_), ID($_SDFFE_PP0P_), ID($_SDFFE_PP1N_), ID($_SDFFE_PP1P_));
    int en_polarity  = cell->type.in(ID($_SDFFE_NN0P_), ID($_SDFFE_NN1P_), ID($_SDFFE_NP0P_), ID($_SDFFE_NP1P_), ID($_SDFFE_PN0P_), ID($_SDFFE_PN1P_), ID($_SDFFE_PP0P_), ID($_SDFFE_PP1P_));
    int rst_polarity = cell->type.in(ID($_SDFFE_NN1N_), ID($_SDFFE_NN1P_), ID($_SDFFE_NP1N_), ID($_SDFFE_NP1P_), ID($_SDFFE_PN1N_), ID($_SDFFE_PN1P_), ID($_SDFFE_PP1N_), ID($_SDFFE_PP1P_));
    int rst_val = 0; // Always reset the taint when getting the reset signal.

    RTLIL::SigBit en_bit = ports[E][0];
    RTLIL::SigBit not_en_bit = module->Not(NEW_ID, ports[E][0]);

    // Invert the en bits if necessary.
    RTLIL::SigSpec en_spec;
    RTLIL::SigSpec not_en_spec;
    if (en_polarity) {
        en_spec = RTLIL::SigSpec(en_bit, data_width);
        not_en_spec = RTLIL::SigSpec(not_en_bit, data_width);
    }
    else {
        not_en_spec = RTLIL::SigSpec(en_bit, data_width);
        en_spec = RTLIL::SigSpec(not_en_bit, data_width);
    }

    RTLIL::SigSpec d_xor_q = module->Xor(NEW_ID, ports[D], ports[Q]);
    for (unsigned int taint_id = 0; taint_id < num_taints; taint_id++) {
        RTLIL::SigSpec d_taint_or_q_taint = module->Or(NEW_ID, port_taints[D][taint_id], port_taints[Q][taint_id]);
        RTLIL::SigSpec d_q_tainted_or_distinct = module->Or(NEW_ID, d_xor_q, d_taint_or_q_taint);

        RTLIL::SigSpec en_spec_taint;
        en_spec_taint = RTLIL::SigSpec(port_taints[E][taint_id], data_width);

        // Intermediate signals to OR together.
        RTLIL::SigSpec reduce_or_arr[3];
        reduce_or_arr[0] = module->And(NEW_ID, en_spec, port_taints[D][taint_id]);
        reduce_or_arr[1] = module->And(NEW_ID, not_en_spec, port_taints[Q][taint_id]);
        reduce_or_arr[2] = module->And(NEW_ID, d_q_tainted_or_distinct, en_spec_taint);

        RTLIL::SigSpec reduce_or_interm = module->Or(NEW_ID, reduce_or_arr[0], reduce_or_arr[1]);
        RTLIL::SigSpec reduce_or_output;
        if (!opt_data_flow) {
            reduce_or_output = module->Or(NEW_ID, reduce_or_interm, reduce_or_arr[2]);
        } else {
            reduce_or_output = reduce_or_interm;
        }

        // No enable signal in the instrumentation. Everything is adapted in the input signal.
        RTLIL::Cell *new_ff = module->addSdff(NEW_ID, ports[C], ports[R], reduce_or_output, port_taints[Q][taint_id], RTLIL::Const(rst_val, data_width), clk_polarity, rst_polarity);
        new_ff->set_bool_attribute(ID(taint_ff));
    }

    return true;
}
