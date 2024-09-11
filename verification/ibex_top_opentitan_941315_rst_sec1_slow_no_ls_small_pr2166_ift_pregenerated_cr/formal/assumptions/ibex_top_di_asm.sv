

// // Can the malicious REM use a different rs1 than the zero register? Yes
// // fetch_enable_i is the value relevant? No
// // RESULT: CEX
// // asm_di_not_zero_reg: assume property(!(u_ibex_core__id_stage_i__instr_rdata_i[6:0] == 7'b0110011 && u_ibex_core__id_stage_i__instr_rdata_i[14:12] == 3'b110
// //                                         && u_ibex_core__id_stage_i__instr_rdata_i[19:15] == 5'b00000));
// // asm_di_no_instr_err: assume property(!instr_err_i);
// // asm_di_not_irq_software_i: assume property (!irq_software_i);
// // asm_di_not_irq_timer_i: assume property (!irq_timer_i);
// // asm_di_not_irq_external_i: assume property (!irq_external_i);
// // asm_di_not_irq_fast_i: assume property (!irq_fast_i);
// // asm_di_not_irq_nm_i: assume property (!irq_nm_i);
// // asm_di_not_debug_req_i: assume property (!debug_req_i);
// // asm_di_correct_fetch_enable: assume property (fetch_enable_i == 4'b0101); // IbexMuBiOn  = 4'b0101;





// // The most restricted config that still gives the CEX:



// // // // Can we load data into the register before the malicious instruction? Yes
// // // // RESULT: CEX
// // logic iuv_rem = (u_ibex_core__id_stage_i__instr_rdata_i[6:0] == 7'b0110011 && u_ibex_core__id_stage_i__instr_rdata_i[14:12] == 3'b110);
// // logic iuv_uses_reg1 = u_ibex_core__id_stage_i__instr_rdata_i[19:15] == 5'b00001;
// // logic reg1_not_zero = gen_regfile_ff__register_file_i__g_rf_flops_1___rf_reg_q != 0;

// // asm_di_use_reg1: assume property(iuv_rem |-> iuv_uses_reg1);

// // // Ensure that the register used by the malicious instruction is not zero when the instruction
// // // is decoded. Works on in-order cores.
// // asm_di_reg1_has_val: assume property(iuv_rem && iuv_uses_reg1 |-> reg1_not_zero);

// // asm_di_no_instr_err: assume property(!instr_err_i);
// // asm_di_not_irq_software_i: assume property (!irq_software_i);
// // asm_di_not_irq_timer_i: assume property (!irq_timer_i);
// // asm_di_not_irq_external_i: assume property (!irq_external_i);
// // asm_di_not_irq_fast_i: assume property (!irq_fast_i);
// // asm_di_not_irq_nm_i: assume property (!irq_nm_i);
// // asm_di_not_debug_req_i: assume property (!debug_req_i);
// // asm_di_correct_fetch_enable: assume property (fetch_enable_i == 4'b0101); // IbexMuBiOn  = 4'b0101;







// // NEXT:
// // Can we keep the data independent timing mode on and still get a CEX? NO
// // RESULT: PROVEN
// // logic iuv_rem = (u_ibex_core__id_stage_i__instr_rdata_i[6:0] == 7'b0110011 && u_ibex_core__id_stage_i__instr_rdata_i[14:12] == 3'b110);
// // logic iuv_uses_reg1 = u_ibex_core__id_stage_i__instr_rdata_i[19:15] == 5'b00001;
// // logic reg1_not_zero = gen_regfile_ff__register_file_i__g_rf_flops_1___rf_reg_q != 0;
// // logic is_csr_ecall_ebreak = (u_ibex_core__id_stage_i__decoder_i__instr_rdata_i[6:0] == 7'b1110011);

// // asm_di_use_reg1: assume property(iuv_rem |-> iuv_uses_reg1);

// // // Ensure that the register used by the malicious instruction is not zero when the instruction
// // // is decoded. Works on in-order cores.
// // asm_di_reg1_has_val: assume property(iuv_rem && iuv_uses_reg1 |-> reg1_not_zero);

// // // Have this already in the start cond.
// // // asm_di_iuv_in_dit_mode: assume property (iuv_rem |-> u_ibex_core__cs_registers_i__data_ind_timing_o);

// // // Disallow any CSR register interactions once the DIT mode is on.
// // asm_di_dit_mode_never_switched_off: assume property(
// //   u_ibex_core__cs_registers_i__data_ind_timing_o |-> !is_csr_ecall_ebreak);

// // asm_di_no_instr_err: assume property(!instr_err_i);
// // asm_di_not_irq_software_i: assume property (!irq_software_i);
// // asm_di_not_irq_timer_i: assume property (!irq_timer_i);
// // asm_di_not_irq_external_i: assume property (!irq_external_i);
// // asm_di_not_irq_fast_i: assume property (!irq_fast_i);
// // asm_di_not_irq_nm_i: assume property (!irq_nm_i);
// // asm_di_not_debug_req_i: assume property (!debug_req_i);
// // asm_di_correct_fetch_enable: assume property (fetch_enable_i == 4'b0101); // IbexMuBiOn  = 4'b0101;






// // // // Can we set test_en to 0? No, To 1? YES
// // // What other inputs are fixed in normal operating conditions?
// // // // RESULT: CEX
// // logic iuv_rem = (u_ibex_core__id_stage_i__instr_rdata_i[6:0] == 7'b0110011 && u_ibex_core__id_stage_i__instr_rdata_i[14:12] == 3'b110);
// // logic iuv_uses_reg1 = u_ibex_core__id_stage_i__instr_rdata_i[19:15] == 5'b00001;
// // logic reg1_not_zero = gen_regfile_ff__register_file_i__g_rf_flops_1___rf_reg_q != 0;

// // asm_di_use_reg1: assume property(iuv_rem |-> iuv_uses_reg1);

// // // Ensure that the register used by the malicious instruction is not zero when the instruction
// // // is decoded. Works on in-order cores.
// // asm_di_reg1_has_val: assume property(iuv_rem && iuv_uses_reg1 |-> reg1_not_zero);

// ///////////////////////////////////////////////////////////////////////////////////////////////////////
// // // Normal and good operating conditions:

// // asm_di_no_instr_err: assume property(!instr_err_i);
// // asm_di_no_data_err: assume property(!data_err_i);


// // asm_di_not_irq_software_i: assume property (!irq_software_i);
// // asm_di_not_irq_timer_i: assume property (!irq_timer_i);
// // asm_di_not_irq_external_i: assume property (!irq_external_i);
// // asm_di_not_irq_fast_i: assume property (!irq_fast_i);
// // asm_di_not_irq_nm_i: assume property (!irq_nm_i);



// // asm_di_not_debug_req_i: assume property (!debug_req_i);
// // asm_di_correct_fetch_enable: assume property (fetch_enable_i == 4'b0101); // IbexMuBiOn  = 4'b0101;
// // // Doc: Test controlled reset. If DFT not used, tie off to 1.
// // asm_di_scan_rst_ni: assume property (scan_rst_ni == 1); // enable (1) the shadow core (test_en_i == 0 also disables it)
// // asm_di_test_en_i: assume property (test_en_i == 0);

// // // Calculate correct ECC bits

// // `include "formal/properties/prim_secded_inv_39_32_enc.sv"

// // logic [38:0] instr_rdata_with_ecc;

// // prim_secded_inv_39_32_enc instr_ecc(
// //   .data_i(instr_rdata_i),
// //   .data_o(instr_rdata_with_ecc)
// // );

// // asm_di_no_instr_ecc_error: assume property(instr_rdata_intg_i == instr_rdata_with_ecc[38:32]);

// // logic [38:0] data_rdata_with_ecc;

// // prim_secded_inv_39_32_enc data_ecc(
// //   .data_i(data_rdata_i),
// //   .data_o(data_rdata_with_ecc)
// // );

// // asm_di_no_data_ecc_error: assume property(data_rdata_intg_i == data_rdata_with_ecc[38:32]);


// // ///////////////////////////////////////////////////////////////////////////////////////////////////////
// // // // Normal and good operating conditions, but with instuction and data errors allowed

// // // asm_di_no_instr_err: assume property(!instr_err_i);
// // // asm_di_no_data_err: assume property(!data_err_i);


// // asm_di_not_irq_software_i: assume property (!irq_software_i);
// // asm_di_not_irq_timer_i: assume property (!irq_timer_i);
// // asm_di_not_irq_external_i: assume property (!irq_external_i);
// // asm_di_not_irq_fast_i: assume property (!irq_fast_i);
// // asm_di_not_irq_nm_i: assume property (!irq_nm_i);



// // asm_di_not_debug_req_i: assume property (!debug_req_i);
// // asm_di_correct_fetch_enable: assume property (fetch_enable_i == 4'b0101); // IbexMuBiOn  = 4'b0101;
// // // Doc: Test controlled reset. If DFT not used, tie off to 1.
// // asm_di_scan_rst_ni: assume property (scan_rst_ni == 1); // enable (1) the shadow core (test_en_i == 0 also disables it)
// // asm_di_test_en_i: assume property (test_en_i == 0);

// // // Calculate correct ECC bits

// // `include "formal/properties/prim_secded_inv_39_32_enc.sv"

// // logic [38:0] instr_rdata_with_ecc;

// // prim_secded_inv_39_32_enc instr_ecc(
// //   .data_i(instr_rdata_i),
// //   .data_o(instr_rdata_with_ecc)
// // );

// // asm_di_no_instr_ecc_error: assume property(instr_rdata_intg_i == instr_rdata_with_ecc[38:32]);

// // logic [38:0] data_rdata_with_ecc;

// // prim_secded_inv_39_32_enc data_ecc(
// //   .data_i(data_rdata_i),
// //   .data_o(data_rdata_with_ecc)
// // );

// // asm_di_no_data_ecc_error: assume property(data_rdata_intg_i == data_rdata_with_ecc[38:32]);


// // ///////////////////////////////////////////////////////////////////////////////////////////////////////
// // // // // Normal and good operating conditions, but with instuction and data errors and interrupts allowed

// asm_di_no_instr_err: assume property(!instr_err_i);
// // asm_di_no_data_err: assume property(!data_err_i);


// asm_di_not_irq_software_i: assume property (!irq_software_i);
// asm_di_not_irq_timer_i: assume property (!irq_timer_i);
// asm_di_not_irq_external_i: assume property (!irq_external_i);
// asm_di_not_irq_fast_i: assume property (!irq_fast_i);
// asm_di_not_irq_nm_i: assume property (!irq_nm_i);



// asm_di_not_debug_req_i: assume property (!debug_req_i);
// asm_di_correct_fetch_enable: assume property (fetch_enable_i == 4'b0101); // IbexMuBiOn  = 4'b0101;
// // Doc: Test controlled reset. If DFT not used, tie off to 1.
// asm_di_scan_rst_ni: assume property (scan_rst_ni == 1); // enable (1) the shadow core (test_en_i == 0 also disables it)
// asm_di_test_en_i: assume property (test_en_i == 0);

// // Calculate correct ECC bits

// `include "../ibex_top_opentitan_941315_rst_sec1_slow/formal/properties/prim_secded_inv_39_32_enc.sv"

// logic [38:0] instr_rdata_with_ecc;

// prim_secded_inv_39_32_enc instr_ecc(
//   .data_i(instr_rdata_i),
//   .data_o(instr_rdata_with_ecc)
// );

// asm_di_no_instr_ecc_error: assume property(instr_rdata_intg_i == instr_rdata_with_ecc[38:32]);

// logic [38:0] data_rdata_with_ecc;

// prim_secded_inv_39_32_enc data_ecc(
//   .data_i(data_rdata_i),
//   .data_o(data_rdata_with_ecc)
// );

// asm_di_no_data_ecc_error: assume property(data_rdata_intg_i == data_rdata_with_ecc[38:32]);

// // // // Can we load data into the register before the malicious instruction?
// // // RESULT:
// logic iuv_rem = (u_ibex_core__id_stage_i__instr_rdata_i[6:0] == 7'b0110011 && u_ibex_core__id_stage_i__instr_rdata_i[14:12] == 3'b110);
// logic iuv_uses_reg1 = u_ibex_core__id_stage_i__instr_rdata_i[19:15] == 5'b00001;
// logic reg1_not_zero = gen_regfile_ff__register_file_i__g_rf_flops_1___rf_reg_q != 39'h2A00000000; // prim_secded_pkg::SecdedInv3932ZeroWord

// asm_di_use_reg1: assume property(iuv_rem |-> iuv_uses_reg1);

// // Ensure that the register used by the malicious instruction is not zero when the instruction
// // is decoded. Works on in-order cores.
// asm_di_reg1_has_val: assume property(iuv_rem && iuv_uses_reg1 |-> reg1_not_zero);


// // // Can we get a CEX without the major alert? YES
// // // No Lockstep alert
// asm_di_no_major_alert: assume property (!alert_major_internal_o);

// asm_di_no_X_in_div_by_zero_t0: assume property (!u_ibex_core__ex_block_i__gen_multdiv_slow__multdiv_i__div_by_zero_q_t0);

// asm_di_data_err_only_in_md_state_3: assume property (data_err_i |-> (u_ibex_core__ex_block_i__gen_multdiv_slow__multdiv_i__md_state_q == 3));




/// NO DATA ERR = excluding the known bug
// asm_di_no_data_err: assume property(!data_err_i);
