// Generated by /data/kceesay/workspace/mucfi/automation/fpv_core_setup/taint_states.py
checker chk_no_taint_ever();

  as_no_taint_ever_u_ex__regwr_data_t0: assert property(!u_ex__regwr_data_t0);
  as_no_taint_ever_u_ex__regwr_sel_t0: assert property(!u_ex__regwr_sel_t0);
  as_no_taint_ever_u_ex__trap_cause_t0: assert property(!u_ex__trap_cause_t0);
  as_no_taint_ever_u_ex__trap_value_t0: assert property(!u_ex__trap_value_t0);
  as_no_taint_ever_u_id__decode_addr_t0: assert property(!u_id__decode_addr_t0);
  as_no_taint_ever_u_id__decode_aluop_t0: assert property(!u_id__decode_aluop_t0);
  as_no_taint_ever_u_id__decode_basic_t0: assert property(!u_id__decode_basic_t0);
  as_no_taint_ever_u_id__decode_branch_t0: assert property(!u_id__decode_branch_t0);
  as_no_taint_ever_u_id__decode_csr_t0: assert property(!u_id__decode_csr_t0);
  as_no_taint_ever_u_id__decode_illegal_t0: assert property(!u_id__decode_illegal_t0);
  as_no_taint_ever_u_id__decode_ir_t0: assert property(!u_id__decode_ir_t0);
  as_no_taint_ever_u_id__decode_jump_t0: assert property(!u_id__decode_jump_t0);
  as_no_taint_ever_u_id__decode_load_t0: assert property(!u_id__decode_load_t0);
  as_no_taint_ever_u_id__decode_mask_t0: assert property(!u_id__decode_mask_t0);
  as_no_taint_ever_u_id__decode_misaligned_jmp_t0: assert property(!u_id__decode_misaligned_jmp_t0);
  as_no_taint_ever_u_id__decode_misaligned_ldst_t0: assert property(!u_id__decode_misaligned_ldst_t0);
  as_no_taint_ever_u_id__decode_op1_t0: assert property(!u_id__decode_op1_t0);
  as_no_taint_ever_u_id__decode_op2_t0: assert property(!u_id__decode_op2_t0);
  as_no_taint_ever_u_id__decode_pc_t0: assert property(!u_id__decode_pc_t0);
  as_no_taint_ever_u_id__decode_regwr_alu_t0: assert property(!u_id__decode_regwr_alu_t0);
  as_no_taint_ever_u_id__decode_store_t0: assert property(!u_id__decode_store_t0);
  as_no_taint_ever_u_id__decode_sysop_t0: assert property(!u_id__decode_sysop_t0);
  as_no_taint_ever_u_id__decode_system_t0: assert property(!u_id__decode_system_t0);
  as_no_taint_ever_u_id__decode_vld_t0: assert property(!u_id__decode_vld_t0);
  as_no_taint_ever_u_if__fetch_ir_t0: assert property(!u_if__fetch_ir_t0);
  as_no_taint_ever_u_if__fetch_pc_t0: assert property(!u_if__fetch_pc_t0);
  as_no_taint_ever_u_if__fetch_vld_t0: assert property(!u_if__fetch_vld_t0);
  as_no_taint_ever_u_if__pc_last_t0: assert property(!u_if__pc_last_t0);
  as_no_taint_ever_u_if__pc_t0: assert property(!u_if__pc_t0);
  as_no_taint_ever_u_if__skid_buffer_t0: assert property(!u_if__skid_buffer_t0);
  as_no_taint_ever_u_ex__u_csr___1089_: assert property(!u_ex__u_csr___1089_);
  as_no_taint_ever_u_ex__u_csr___1093_: assert property(!u_ex__u_csr___1093_);
  as_no_taint_ever_u_ex__u_csr__csr_data_t0: assert property(!u_ex__u_csr__csr_data_t0);
  as_no_taint_ever_u_ex__u_csr__mcause_t0: assert property(!u_ex__u_csr__mcause_t0);
  as_no_taint_ever_u_ex__u_csr__mepc_t0: assert property(!u_ex__u_csr__mepc_t0);
  as_no_taint_ever_u_ex__u_csr__mie_t0: assert property(!u_ex__u_csr__mie_t0);
  as_no_taint_ever_u_ex__u_csr__mip_t0: assert property(!u_ex__u_csr__mip_t0);
  as_no_taint_ever_u_ex__u_csr__mscratch_t0: assert property(!u_ex__u_csr__mscratch_t0);
  as_no_taint_ever_u_ex__u_csr__mtval_t0: assert property(!u_ex__u_csr__mtval_t0);
  as_no_taint_ever_u_ex__u_csr__regwr_csr_t0: assert property(!u_ex__u_csr__regwr_csr_t0);
  as_no_taint_ever_u_ex__u_csr__trap_handle_t0: assert property(!u_ex__u_csr__trap_handle_t0);
  as_no_taint_ever_u_if__u_rf___0742_: assert property(!u_if__u_rf___0742_);
  as_no_taint_ever_u_if__u_rf___1126_: assert property(!u_if__u_rf___1126_);
  as_no_taint_ever_u_if__u_rf__regrd_rs1_en_t0: assert property(!u_if__u_rf__regrd_rs1_en_t0);
  as_no_taint_ever_u_if__u_rf__regrd_rs1_t0: assert property(!u_if__u_rf__regrd_rs1_t0);
  as_no_taint_ever_u_if__u_rf__regrd_rs2_en_t0: assert property(!u_if__u_rf__regrd_rs2_en_t0);
  as_no_taint_ever_u_if__u_rf__regrd_rs2_t0: assert property(!u_if__u_rf__regrd_rs2_t0);
  as_no_taint_ever_u_ex__u_csr__u_hpmcounter0__count_high_t0: assert property(!u_ex__u_csr__u_hpmcounter0__count_high_t0);
  as_no_taint_ever_u_ex__u_csr__u_hpmcounter0__count_low_t0: assert property(!u_ex__u_csr__u_hpmcounter0__count_low_t0);
  as_no_taint_ever_u_ex__u_csr__u_hpmcounter1__count_high_t0: assert property(!u_ex__u_csr__u_hpmcounter1__count_high_t0);
  as_no_taint_ever_u_ex__u_csr__u_hpmcounter1__count_low_t0: assert property(!u_ex__u_csr__u_hpmcounter1__count_low_t0);
endchecker