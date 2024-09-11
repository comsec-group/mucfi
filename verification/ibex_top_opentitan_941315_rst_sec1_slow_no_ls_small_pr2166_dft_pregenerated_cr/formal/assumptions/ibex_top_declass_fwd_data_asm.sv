asm_declass_rf_wdata_fwd_wb: assume property (!u_ibex_core__rf_wdata_fwd_wb_t0);
asm_declass_rf_wdata_wb: assume property (!u_ibex_core__rf_wdata_wb_ecc_o_t0);

// how is this different from the mux select declassification?
asm_declass_fwd_equals_regs: assume property (u_ibex_core__id_stage_i__rf_wdata_fwd_wb_i_t0 == u_ibex_core__id_stage_i__rf_rdata_a_i_t0 | u_ibex_core__id_stage_i__rf_rdata_b_i_t0);
