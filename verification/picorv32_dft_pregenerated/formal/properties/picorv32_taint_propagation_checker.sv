// Generated by /data/kceesay/workspace/mucfi/automation/fpv_core_setup/taint_states.py
checker pc_taint_find_taint_propagation_bounded(untyped bound);

  c_taint_propagation__1626_: cover property(##bound _1626_);
  c_taint_propagation__1868_: cover property(##bound _1868_);
  c_taint_propagation__1870_: cover property(##bound _1870_);
  c_taint_propagation__1871_: cover property(##bound _1871_);
  c_taint_propagation__1874_: cover property(##bound _1874_);
  c_taint_propagation__1886_: cover property(##bound _1886_);
  c_taint_propagation_alu_out_q_t0: cover property(##bound alu_out_q_t0);
  c_taint_propagation_cached_insn_opcode_t0: cover property(##bound cached_insn_opcode_t0);
  c_taint_propagation_cached_insn_rs1_t0: cover property(##bound cached_insn_rs1_t0);
  c_taint_propagation_cached_insn_rs2_t0: cover property(##bound cached_insn_rs2_t0);
  c_taint_propagation_count_cycle_t0: cover property(##bound count_cycle_t0);
  c_taint_propagation_count_instr_t0: cover property(##bound count_instr_t0);
  c_taint_propagation_dbg_rs1val_t0: cover property(##bound dbg_rs1val_t0);
  c_taint_propagation_dbg_rs2val_t0: cover property(##bound dbg_rs2val_t0);
  c_taint_propagation_decoded_imm_t0: cover property(##bound decoded_imm_t0);
  c_taint_propagation_decoded_rd_t0: cover property(##bound decoded_rd_t0);
  c_taint_propagation_decoded_rs1_t0: cover property(##bound decoded_rs1_t0);
  c_taint_propagation_decoded_rs2_t0: cover property(##bound decoded_rs2_t0);
  c_taint_propagation_latched_rd_t0: cover property(##bound latched_rd_t0);
  c_taint_propagation_mem_addr_t0: cover property(##bound mem_addr_t0);
  c_taint_propagation_mem_instr_t0: cover property(##bound mem_instr_t0);
  c_taint_propagation_mem_rdata_q_t0: cover property(##bound mem_rdata_q_t0);
  c_taint_propagation_mem_valid_t0: cover property(##bound mem_valid_t0);
  c_taint_propagation_mem_wdata_t0: cover property(##bound mem_wdata_t0);
  c_taint_propagation_mem_wstrb_t0: cover property(##bound mem_wstrb_t0);
  c_taint_propagation_next_insn_opcode_t0: cover property(##bound next_insn_opcode_t0);
  c_taint_propagation_pcpi_insn_t0: cover property(##bound pcpi_insn_t0);
  c_taint_propagation_pcpi_rs1_t0: cover property(##bound pcpi_rs1_t0);
  c_taint_propagation_pcpi_rs2_t0: cover property(##bound pcpi_rs2_t0);
  c_taint_propagation_pcpi_valid_t0: cover property(##bound pcpi_valid_t0);
  c_taint_propagation_q_insn_rs1_t0: cover property(##bound q_insn_rs1_t0);
  c_taint_propagation_q_insn_rs2_t0: cover property(##bound q_insn_rs2_t0);
  c_taint_propagation_reg_next_pc_t0: cover property(##bound reg_next_pc_t0);
  c_taint_propagation_reg_out_t0: cover property(##bound reg_out_t0);
  c_taint_propagation_reg_pc_t0: cover property(##bound reg_pc_t0);
  c_taint_propagation_rvfi_mem_addr_t0: cover property(##bound rvfi_mem_addr_t0);
  c_taint_propagation_rvfi_mem_rdata_t0: cover property(##bound rvfi_mem_rdata_t0);
  c_taint_propagation_rvfi_mem_rmask_t0: cover property(##bound rvfi_mem_rmask_t0);
  c_taint_propagation_rvfi_mem_wdata_t0: cover property(##bound rvfi_mem_wdata_t0);
  c_taint_propagation_rvfi_mem_wmask_t0: cover property(##bound rvfi_mem_wmask_t0);
  c_taint_propagation_rvfi_order_t0: cover property(##bound rvfi_order_t0);
  c_taint_propagation_rvfi_pc_rdata_t0: cover property(##bound rvfi_pc_rdata_t0);
  c_taint_propagation_rvfi_pc_wdata_t0: cover property(##bound rvfi_pc_wdata_t0);
  c_taint_propagation_rvfi_rd_addr_t0: cover property(##bound rvfi_rd_addr_t0);
  c_taint_propagation_rvfi_rd_wdata_t0: cover property(##bound rvfi_rd_wdata_t0);
  c_taint_propagation_rvfi_rs1_addr_t0: cover property(##bound rvfi_rs1_addr_t0);
  c_taint_propagation_rvfi_rs1_rdata_t0: cover property(##bound rvfi_rs1_rdata_t0);
  c_taint_propagation_rvfi_rs2_addr_t0: cover property(##bound rvfi_rs2_addr_t0);
  c_taint_propagation_rvfi_rs2_rdata_t0: cover property(##bound rvfi_rs2_rdata_t0);
  c_taint_propagation_genblk1__genblk1__pcpi_mul___820_: cover property(##bound genblk1__genblk1__pcpi_mul___820_);
  c_taint_propagation_genblk1__genblk1__pcpi_mul__pcpi_rd_t0: cover property(##bound genblk1__genblk1__pcpi_mul__pcpi_rd_t0);
  c_taint_propagation_genblk1__genblk1__pcpi_mul__rd_t0: cover property(##bound genblk1__genblk1__pcpi_mul__rd_t0);
  c_taint_propagation_genblk1__genblk1__pcpi_mul__rs2_t0: cover property(##bound genblk1__genblk1__pcpi_mul__rs2_t0);
  c_taint_propagation_genblk2__pcpi_div__dividend_t0: cover property(##bound genblk2__pcpi_div__dividend_t0);
  c_taint_propagation_genblk2__pcpi_div__divisor_t0: cover property(##bound genblk2__pcpi_div__divisor_t0);
  c_taint_propagation_genblk2__pcpi_div__pcpi_rd_t0: cover property(##bound genblk2__pcpi_div__pcpi_rd_t0);
  c_taint_propagation_genblk2__pcpi_div__quotient_msk_t0: cover property(##bound genblk2__pcpi_div__quotient_msk_t0);
  c_taint_propagation_genblk2__pcpi_div__quotient_t0: cover property(##bound genblk2__pcpi_div__quotient_t0);
endchecker