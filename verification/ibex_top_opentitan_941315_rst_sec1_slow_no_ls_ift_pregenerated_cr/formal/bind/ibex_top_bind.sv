bind ibex_top ibex_top_fpv ibex_top_fpv_bind (
.clk_i(
  clk_i),
.rst_ni(
  rst_ni),
.test_en_i(
  test_en_i),
.ram_cfg_i(
  ram_cfg_i),
.hart_id_i(
  hart_id_i),
.boot_addr_i(
  boot_addr_i),
.instr_req_o(
  instr_req_o),
.instr_gnt_i(
  instr_gnt_i),
.instr_rvalid_i(
  instr_rvalid_i),
.instr_addr_o(
  instr_addr_o),
.instr_rdata_i(
  instr_rdata_i),
.instr_rdata_intg_i(
  instr_rdata_intg_i),
.instr_err_i(
  instr_err_i),
.data_req_o(
  data_req_o),
.data_gnt_i(
  data_gnt_i),
.data_rvalid_i(
  data_rvalid_i),
.data_we_o(
  data_we_o),
.data_be_o(
  data_be_o),
.data_addr_o(
  data_addr_o),
.data_wdata_o(
  data_wdata_o),
.data_wdata_intg_o(
  data_wdata_intg_o),
.data_rdata_i(
  data_rdata_i),
.data_rdata_intg_i(
  data_rdata_intg_i),
.data_err_i(
  data_err_i),
.irq_software_i(
  irq_software_i),
.irq_timer_i(
  irq_timer_i),
.irq_external_i(
  irq_external_i),
.irq_fast_i(
  irq_fast_i),
.irq_nm_i(
  irq_nm_i),
.scramble_key_valid_i(
  scramble_key_valid_i),
.scramble_key_i(
  scramble_key_i),
.scramble_nonce_i(
  scramble_nonce_i),
.scramble_req_o(
  scramble_req_o),
.debug_req_i(
  debug_req_i),
.crash_dump_o(
  crash_dump_o),
.double_fault_seen_o(
  double_fault_seen_o),
.fetch_enable_i(
  fetch_enable_i),
.alert_minor_o(
  alert_minor_o),
.alert_major_internal_o(
  alert_major_internal_o),
.alert_major_bus_o(
  alert_major_bus_o),
.core_sleep_o(
  core_sleep_o),
.scan_rst_ni(
  scan_rst_ni),
.instr_addr_o_t0(
  instr_addr_o_t0),
.instr_gnt_i_t0(
  instr_gnt_i_t0),
.instr_rvalid_i_t0(
  instr_rvalid_i_t0),
.boot_addr_i_t0(
  boot_addr_i_t0),
.instr_req_o_t0(
  instr_req_o_t0),
.instr_rdata_i_t0(
  instr_rdata_i_t0),
.instr_err_i_t0(
  instr_err_i_t0),
.data_req_o_t0(
  data_req_o_t0),
.data_we_o_t0(
  data_we_o_t0),
.test_en_i_t0(
  test_en_i_t0),
.debug_req_i_t0(
  debug_req_i_t0),
.irq_nm_i_t0(
  irq_nm_i_t0),
.data_addr_o_t0(
  data_addr_o_t0),
.data_be_o_t0(
  data_be_o_t0),
.data_gnt_i_t0(
  data_gnt_i_t0),
.data_rdata_i_t0(
  data_rdata_i_t0),
.data_rvalid_i_t0(
  data_rvalid_i_t0),
.data_wdata_o_t0(
  data_wdata_o_t0),
.double_fault_seen_o_t0(
  double_fault_seen_o_t0),
.hart_id_i_t0(
  hart_id_i_t0),
.irq_external_i_t0(
  irq_external_i_t0),
.irq_fast_i_t0(
  irq_fast_i_t0),
.irq_software_i_t0(
  irq_software_i_t0),
.irq_timer_i_t0(
  irq_timer_i_t0),
.alert_major_bus_o_t0(
  alert_major_bus_o_t0),
.alert_major_internal_o_t0(
  alert_major_internal_o_t0),
.alert_minor_o_t0(
  alert_minor_o_t0),
.crash_dump_o_t0(
  crash_dump_o_t0),
.data_err_i_t0(
  data_err_i_t0),
.fetch_enable_i_t0(
  fetch_enable_i_t0),
.core_sleep_o_t0(
  core_sleep_o_t0),
.data_rdata_intg_i_t0(
  data_rdata_intg_i_t0),
.data_wdata_intg_o_t0(
  data_wdata_intg_o_t0),
.instr_rdata_intg_i_t0(
  instr_rdata_intg_i_t0),
.ram_cfg_i_t0(
  ram_cfg_i_t0),
.scan_rst_ni_t0(
  scan_rst_ni_t0),
.scramble_key_i_t0(
  scramble_key_i_t0),
.scramble_key_valid_i_t0(
  scramble_key_valid_i_t0),
.scramble_nonce_i_t0(
  scramble_nonce_i_t0),
.scramble_req_o_t0(
  scramble_req_o_t0),
.clk(
  clk),
.clock_en(
  clock_en),
.core_alert_major_internal(
  core_alert_major_internal),
.core_alert_major_internal_t0(
  core_alert_major_internal_t0),
.core_busy_d(
  core_busy_d),
.core_busy_d_t0(
  core_busy_d_t0),
.core_busy_q(
  core_busy_q),
.core_busy_q_t0(
  core_busy_q_t0),
.data_wdata_core(
  data_wdata_core),
.data_wdata_core_t0(
  data_wdata_core_t0),
.dummy_instr_id(
  dummy_instr_id),
.dummy_instr_id_t0(
  dummy_instr_id_t0),
.dummy_instr_wb(
  dummy_instr_wb),
.dummy_instr_wb_t0(
  dummy_instr_wb_t0),
.fetch_enable_buf(
  fetch_enable_buf),
.fetch_enable_buf_t0(
  fetch_enable_buf_t0),
.ic_data_addr(
  ic_data_addr),
.ic_data_addr_t0(
  ic_data_addr_t0),
.ic_data_req(
  ic_data_req),
.ic_data_req_t0(
  ic_data_req_t0),
.ic_data_wdata(
  ic_data_wdata),
.ic_data_wdata_t0(
  ic_data_wdata_t0),
.ic_data_write(
  ic_data_write),
.ic_data_write_t0(
  ic_data_write_t0),
.ic_scr_key_req(
  ic_scr_key_req),
.ic_scr_key_req_t0(
  ic_scr_key_req_t0),
.ic_tag_addr(
  ic_tag_addr),
.ic_tag_addr_t0(
  ic_tag_addr_t0),
.ic_tag_req(
  ic_tag_req),
.ic_tag_req_t0(
  ic_tag_req_t0),
.ic_tag_wdata(
  ic_tag_wdata),
.ic_tag_wdata_t0(
  ic_tag_wdata_t0),
.ic_tag_write(
  ic_tag_write),
.ic_tag_write_t0(
  ic_tag_write_t0),
.irq_pending(
  irq_pending),
.irq_pending_t0(
  irq_pending_t0),
.rf_alert_major_internal(
  rf_alert_major_internal),
.rf_alert_major_internal_t0(
  rf_alert_major_internal_t0),
.rf_raddr_a(
  rf_raddr_a),
.rf_raddr_a_t0(
  rf_raddr_a_t0),
.rf_raddr_b(
  rf_raddr_b),
.rf_raddr_b_t0(
  rf_raddr_b_t0),
.rf_rdata_a_ecc(
  rf_rdata_a_ecc),
.rf_rdata_a_ecc_buf(
  rf_rdata_a_ecc_buf),
.rf_rdata_a_ecc_buf_t0(
  rf_rdata_a_ecc_buf_t0),
.rf_rdata_a_ecc_t0(
  rf_rdata_a_ecc_t0),
.rf_rdata_b_ecc(
  rf_rdata_b_ecc),
.rf_rdata_b_ecc_buf(
  rf_rdata_b_ecc_buf),
.rf_rdata_b_ecc_buf_t0(
  rf_rdata_b_ecc_buf_t0),
.rf_rdata_b_ecc_t0(
  rf_rdata_b_ecc_t0),
.rf_waddr_wb(
  rf_waddr_wb),
.rf_waddr_wb_t0(
  rf_waddr_wb_t0),
.rf_wdata_wb_ecc(
  rf_wdata_wb_ecc),
.rf_wdata_wb_ecc_t0(
  rf_wdata_wb_ecc_t0),
.rf_we_wb(
  rf_we_wb),
.rf_we_wb_t0(
  rf_we_wb_t0),
.core_clock_gate_i__clk_i(
  core_clock_gate_i.clk_i),
.core_clock_gate_i__en_i(
  core_clock_gate_i.en_i),
.core_clock_gate_i__test_en_i(
  core_clock_gate_i.test_en_i),
.core_clock_gate_i__clk_o(
  core_clock_gate_i.clk_o),
.core_clock_gate_i__clk_o_t0(
  core_clock_gate_i.clk_o_t0),
.core_clock_gate_i__en_i_t0(
  core_clock_gate_i.en_i_t0),
.core_clock_gate_i__test_en_i_t0(
  core_clock_gate_i.test_en_i_t0),
.core_clock_gate_i__en_latch(
  core_clock_gate_i.en_latch),
.core_clock_gate_i__en_latch_t0(
  core_clock_gate_i.en_latch_t0),
.g_clock_en_secure__u_prim_core_busy_flop__clk_i(
  \g_clock_en_secure.u_prim_core_busy_flop .clk_i),
.g_clock_en_secure__u_prim_core_busy_flop__rst_ni(
  \g_clock_en_secure.u_prim_core_busy_flop .rst_ni),
.g_clock_en_secure__u_prim_core_busy_flop__d_i(
  \g_clock_en_secure.u_prim_core_busy_flop .d_i),
.g_clock_en_secure__u_prim_core_busy_flop__q_o(
  \g_clock_en_secure.u_prim_core_busy_flop .q_o),
.g_clock_en_secure__u_prim_core_busy_flop__d_i_t0(
  \g_clock_en_secure.u_prim_core_busy_flop .d_i_t0),
.g_clock_en_secure__u_prim_core_busy_flop__q_o_t0(
  \g_clock_en_secure.u_prim_core_busy_flop .q_o_t0),
.g_clock_en_secure__u_prim_core_busy_flop__gen_generic__u_impl_generic__clk_i(
  \g_clock_en_secure.u_prim_core_busy_flop .\gen_generic.u_impl_generic .clk_i),
.g_clock_en_secure__u_prim_core_busy_flop__gen_generic__u_impl_generic__rst_ni(
  \g_clock_en_secure.u_prim_core_busy_flop .\gen_generic.u_impl_generic .rst_ni),
.g_clock_en_secure__u_prim_core_busy_flop__gen_generic__u_impl_generic__d_i(
  \g_clock_en_secure.u_prim_core_busy_flop .\gen_generic.u_impl_generic .d_i),
.g_clock_en_secure__u_prim_core_busy_flop__gen_generic__u_impl_generic__q_o(
  \g_clock_en_secure.u_prim_core_busy_flop .\gen_generic.u_impl_generic .q_o),
.g_clock_en_secure__u_prim_core_busy_flop__gen_generic__u_impl_generic__d_i_t0(
  \g_clock_en_secure.u_prim_core_busy_flop .\gen_generic.u_impl_generic .d_i_t0),
.g_clock_en_secure__u_prim_core_busy_flop__gen_generic__u_impl_generic__q_o_t0(
  \g_clock_en_secure.u_prim_core_busy_flop .\gen_generic.u_impl_generic .q_o_t0),
.gen_mem_wdata_ecc__u_prim_buf_data_wdata_intg__in_i(
  \gen_mem_wdata_ecc.u_prim_buf_data_wdata_intg .in_i),
.gen_mem_wdata_ecc__u_prim_buf_data_wdata_intg__out_o(
  \gen_mem_wdata_ecc.u_prim_buf_data_wdata_intg .out_o),
.gen_mem_wdata_ecc__u_prim_buf_data_wdata_intg__in_i_t0(
  \gen_mem_wdata_ecc.u_prim_buf_data_wdata_intg .in_i_t0),
.gen_mem_wdata_ecc__u_prim_buf_data_wdata_intg__out_o_t0(
  \gen_mem_wdata_ecc.u_prim_buf_data_wdata_intg .out_o_t0),
.gen_mem_wdata_ecc__u_prim_buf_data_wdata_intg__gen_generic__u_impl_generic__in_i(
  \gen_mem_wdata_ecc.u_prim_buf_data_wdata_intg .\gen_generic.u_impl_generic .in_i),
.gen_mem_wdata_ecc__u_prim_buf_data_wdata_intg__gen_generic__u_impl_generic__out_o(
  \gen_mem_wdata_ecc.u_prim_buf_data_wdata_intg .\gen_generic.u_impl_generic .out_o),
.gen_mem_wdata_ecc__u_prim_buf_data_wdata_intg__gen_generic__u_impl_generic__in_i_t0(
  \gen_mem_wdata_ecc.u_prim_buf_data_wdata_intg .\gen_generic.u_impl_generic .in_i_t0),
.gen_mem_wdata_ecc__u_prim_buf_data_wdata_intg__gen_generic__u_impl_generic__out_o_t0(
  \gen_mem_wdata_ecc.u_prim_buf_data_wdata_intg .\gen_generic.u_impl_generic .out_o_t0),
.gen_mem_wdata_ecc__u_prim_buf_data_wdata_intg__gen_generic__u_impl_generic__inv(
  \gen_mem_wdata_ecc.u_prim_buf_data_wdata_intg .\gen_generic.u_impl_generic .inv),
.gen_regfile_ff__register_file_i__clk_i(
  \gen_regfile_ff.register_file_i .clk_i),
.gen_regfile_ff__register_file_i__rst_ni(
  \gen_regfile_ff.register_file_i .rst_ni),
.gen_regfile_ff__register_file_i__test_en_i(
  \gen_regfile_ff.register_file_i .test_en_i),
.gen_regfile_ff__register_file_i__dummy_instr_id_i(
  \gen_regfile_ff.register_file_i .dummy_instr_id_i),
.gen_regfile_ff__register_file_i__dummy_instr_wb_i(
  \gen_regfile_ff.register_file_i .dummy_instr_wb_i),
.gen_regfile_ff__register_file_i__raddr_a_i(
  \gen_regfile_ff.register_file_i .raddr_a_i),
.gen_regfile_ff__register_file_i__rdata_a_o(
  \gen_regfile_ff.register_file_i .rdata_a_o),
.gen_regfile_ff__register_file_i__raddr_b_i(
  \gen_regfile_ff.register_file_i .raddr_b_i),
.gen_regfile_ff__register_file_i__rdata_b_o(
  \gen_regfile_ff.register_file_i .rdata_b_o),
.gen_regfile_ff__register_file_i__waddr_a_i(
  \gen_regfile_ff.register_file_i .waddr_a_i),
.gen_regfile_ff__register_file_i__wdata_a_i(
  \gen_regfile_ff.register_file_i .wdata_a_i),
.gen_regfile_ff__register_file_i__we_a_i(
  \gen_regfile_ff.register_file_i .we_a_i),
.gen_regfile_ff__register_file_i__err_o(
  \gen_regfile_ff.register_file_i .err_o),
.gen_regfile_ff__register_file_i__test_en_i_t0(
  \gen_regfile_ff.register_file_i .test_en_i_t0),
.gen_regfile_ff__register_file_i__err_o_t0(
  \gen_regfile_ff.register_file_i .err_o_t0),
.gen_regfile_ff__register_file_i__dummy_instr_id_i_t0(
  \gen_regfile_ff.register_file_i .dummy_instr_id_i_t0),
.gen_regfile_ff__register_file_i__dummy_instr_wb_i_t0(
  \gen_regfile_ff.register_file_i .dummy_instr_wb_i_t0),
.gen_regfile_ff__register_file_i__raddr_a_i_t0(
  \gen_regfile_ff.register_file_i .raddr_a_i_t0),
.gen_regfile_ff__register_file_i__raddr_b_i_t0(
  \gen_regfile_ff.register_file_i .raddr_b_i_t0),
.gen_regfile_ff__register_file_i__rdata_a_o_t0(
  \gen_regfile_ff.register_file_i .rdata_a_o_t0),
.gen_regfile_ff__register_file_i__rdata_b_o_t0(
  \gen_regfile_ff.register_file_i .rdata_b_o_t0),
.gen_regfile_ff__register_file_i__waddr_a_i_t0(
  \gen_regfile_ff.register_file_i .waddr_a_i_t0),
.gen_regfile_ff__register_file_i__wdata_a_i_t0(
  \gen_regfile_ff.register_file_i .wdata_a_i_t0),
.gen_regfile_ff__register_file_i__we_a_i_t0(
  \gen_regfile_ff.register_file_i .we_a_i_t0),
.gen_regfile_ff__register_file_i__g_dummy_r0__rf_r0_q(
  \gen_regfile_ff.register_file_i .\g_dummy_r0.rf_r0_q ),
.gen_regfile_ff__register_file_i__g_dummy_r0__rf_r0_q_t0(
  \gen_regfile_ff.register_file_i .\g_dummy_r0.rf_r0_q_t0 ),
.gen_regfile_ff__register_file_i__g_dummy_r0__we_r0_dummy(
  \gen_regfile_ff.register_file_i .\g_dummy_r0.we_r0_dummy ),
.gen_regfile_ff__register_file_i__g_dummy_r0__we_r0_dummy_t0(
  \gen_regfile_ff.register_file_i .\g_dummy_r0.we_r0_dummy_t0 ),
.gen_regfile_ff__register_file_i__g_rf_flops_10___rf_reg_q(
  \gen_regfile_ff.register_file_i .\g_rf_flops[10].rf_reg_q ),
.gen_regfile_ff__register_file_i__g_rf_flops_10___rf_reg_q_t0(
  \gen_regfile_ff.register_file_i .\g_rf_flops[10].rf_reg_q_t0 ),
.gen_regfile_ff__register_file_i__g_rf_flops_11___rf_reg_q(
  \gen_regfile_ff.register_file_i .\g_rf_flops[11].rf_reg_q ),
.gen_regfile_ff__register_file_i__g_rf_flops_11___rf_reg_q_t0(
  \gen_regfile_ff.register_file_i .\g_rf_flops[11].rf_reg_q_t0 ),
.gen_regfile_ff__register_file_i__g_rf_flops_12___rf_reg_q(
  \gen_regfile_ff.register_file_i .\g_rf_flops[12].rf_reg_q ),
.gen_regfile_ff__register_file_i__g_rf_flops_12___rf_reg_q_t0(
  \gen_regfile_ff.register_file_i .\g_rf_flops[12].rf_reg_q_t0 ),
.gen_regfile_ff__register_file_i__g_rf_flops_13___rf_reg_q(
  \gen_regfile_ff.register_file_i .\g_rf_flops[13].rf_reg_q ),
.gen_regfile_ff__register_file_i__g_rf_flops_13___rf_reg_q_t0(
  \gen_regfile_ff.register_file_i .\g_rf_flops[13].rf_reg_q_t0 ),
.gen_regfile_ff__register_file_i__g_rf_flops_14___rf_reg_q(
  \gen_regfile_ff.register_file_i .\g_rf_flops[14].rf_reg_q ),
.gen_regfile_ff__register_file_i__g_rf_flops_14___rf_reg_q_t0(
  \gen_regfile_ff.register_file_i .\g_rf_flops[14].rf_reg_q_t0 ),
.gen_regfile_ff__register_file_i__g_rf_flops_15___rf_reg_q(
  \gen_regfile_ff.register_file_i .\g_rf_flops[15].rf_reg_q ),
.gen_regfile_ff__register_file_i__g_rf_flops_15___rf_reg_q_t0(
  \gen_regfile_ff.register_file_i .\g_rf_flops[15].rf_reg_q_t0 ),
.gen_regfile_ff__register_file_i__g_rf_flops_16___rf_reg_q(
  \gen_regfile_ff.register_file_i .\g_rf_flops[16].rf_reg_q ),
.gen_regfile_ff__register_file_i__g_rf_flops_16___rf_reg_q_t0(
  \gen_regfile_ff.register_file_i .\g_rf_flops[16].rf_reg_q_t0 ),
.gen_regfile_ff__register_file_i__g_rf_flops_17___rf_reg_q(
  \gen_regfile_ff.register_file_i .\g_rf_flops[17].rf_reg_q ),
.gen_regfile_ff__register_file_i__g_rf_flops_17___rf_reg_q_t0(
  \gen_regfile_ff.register_file_i .\g_rf_flops[17].rf_reg_q_t0 ),
.gen_regfile_ff__register_file_i__g_rf_flops_18___rf_reg_q(
  \gen_regfile_ff.register_file_i .\g_rf_flops[18].rf_reg_q ),
.gen_regfile_ff__register_file_i__g_rf_flops_18___rf_reg_q_t0(
  \gen_regfile_ff.register_file_i .\g_rf_flops[18].rf_reg_q_t0 ),
.gen_regfile_ff__register_file_i__g_rf_flops_19___rf_reg_q(
  \gen_regfile_ff.register_file_i .\g_rf_flops[19].rf_reg_q ),
.gen_regfile_ff__register_file_i__g_rf_flops_19___rf_reg_q_t0(
  \gen_regfile_ff.register_file_i .\g_rf_flops[19].rf_reg_q_t0 ),
.gen_regfile_ff__register_file_i__g_rf_flops_1___rf_reg_q(
  \gen_regfile_ff.register_file_i .\g_rf_flops[1].rf_reg_q ),
.gen_regfile_ff__register_file_i__g_rf_flops_1___rf_reg_q_t0(
  \gen_regfile_ff.register_file_i .\g_rf_flops[1].rf_reg_q_t0 ),
.gen_regfile_ff__register_file_i__g_rf_flops_20___rf_reg_q(
  \gen_regfile_ff.register_file_i .\g_rf_flops[20].rf_reg_q ),
.gen_regfile_ff__register_file_i__g_rf_flops_20___rf_reg_q_t0(
  \gen_regfile_ff.register_file_i .\g_rf_flops[20].rf_reg_q_t0 ),
.gen_regfile_ff__register_file_i__g_rf_flops_21___rf_reg_q(
  \gen_regfile_ff.register_file_i .\g_rf_flops[21].rf_reg_q ),
.gen_regfile_ff__register_file_i__g_rf_flops_21___rf_reg_q_t0(
  \gen_regfile_ff.register_file_i .\g_rf_flops[21].rf_reg_q_t0 ),
.gen_regfile_ff__register_file_i__g_rf_flops_22___rf_reg_q(
  \gen_regfile_ff.register_file_i .\g_rf_flops[22].rf_reg_q ),
.gen_regfile_ff__register_file_i__g_rf_flops_22___rf_reg_q_t0(
  \gen_regfile_ff.register_file_i .\g_rf_flops[22].rf_reg_q_t0 ),
.gen_regfile_ff__register_file_i__g_rf_flops_23___rf_reg_q(
  \gen_regfile_ff.register_file_i .\g_rf_flops[23].rf_reg_q ),
.gen_regfile_ff__register_file_i__g_rf_flops_23___rf_reg_q_t0(
  \gen_regfile_ff.register_file_i .\g_rf_flops[23].rf_reg_q_t0 ),
.gen_regfile_ff__register_file_i__g_rf_flops_24___rf_reg_q(
  \gen_regfile_ff.register_file_i .\g_rf_flops[24].rf_reg_q ),
.gen_regfile_ff__register_file_i__g_rf_flops_24___rf_reg_q_t0(
  \gen_regfile_ff.register_file_i .\g_rf_flops[24].rf_reg_q_t0 ),
.gen_regfile_ff__register_file_i__g_rf_flops_25___rf_reg_q(
  \gen_regfile_ff.register_file_i .\g_rf_flops[25].rf_reg_q ),
.gen_regfile_ff__register_file_i__g_rf_flops_25___rf_reg_q_t0(
  \gen_regfile_ff.register_file_i .\g_rf_flops[25].rf_reg_q_t0 ),
.gen_regfile_ff__register_file_i__g_rf_flops_26___rf_reg_q(
  \gen_regfile_ff.register_file_i .\g_rf_flops[26].rf_reg_q ),
.gen_regfile_ff__register_file_i__g_rf_flops_26___rf_reg_q_t0(
  \gen_regfile_ff.register_file_i .\g_rf_flops[26].rf_reg_q_t0 ),
.gen_regfile_ff__register_file_i__g_rf_flops_27___rf_reg_q(
  \gen_regfile_ff.register_file_i .\g_rf_flops[27].rf_reg_q ),
.gen_regfile_ff__register_file_i__g_rf_flops_27___rf_reg_q_t0(
  \gen_regfile_ff.register_file_i .\g_rf_flops[27].rf_reg_q_t0 ),
.gen_regfile_ff__register_file_i__g_rf_flops_28___rf_reg_q(
  \gen_regfile_ff.register_file_i .\g_rf_flops[28].rf_reg_q ),
.gen_regfile_ff__register_file_i__g_rf_flops_28___rf_reg_q_t0(
  \gen_regfile_ff.register_file_i .\g_rf_flops[28].rf_reg_q_t0 ),
.gen_regfile_ff__register_file_i__g_rf_flops_29___rf_reg_q(
  \gen_regfile_ff.register_file_i .\g_rf_flops[29].rf_reg_q ),
.gen_regfile_ff__register_file_i__g_rf_flops_29___rf_reg_q_t0(
  \gen_regfile_ff.register_file_i .\g_rf_flops[29].rf_reg_q_t0 ),
.gen_regfile_ff__register_file_i__g_rf_flops_2___rf_reg_q(
  \gen_regfile_ff.register_file_i .\g_rf_flops[2].rf_reg_q ),
.gen_regfile_ff__register_file_i__g_rf_flops_2___rf_reg_q_t0(
  \gen_regfile_ff.register_file_i .\g_rf_flops[2].rf_reg_q_t0 ),
.gen_regfile_ff__register_file_i__g_rf_flops_30___rf_reg_q(
  \gen_regfile_ff.register_file_i .\g_rf_flops[30].rf_reg_q ),
.gen_regfile_ff__register_file_i__g_rf_flops_30___rf_reg_q_t0(
  \gen_regfile_ff.register_file_i .\g_rf_flops[30].rf_reg_q_t0 ),
.gen_regfile_ff__register_file_i__g_rf_flops_31___rf_reg_q(
  \gen_regfile_ff.register_file_i .\g_rf_flops[31].rf_reg_q ),
.gen_regfile_ff__register_file_i__g_rf_flops_31___rf_reg_q_t0(
  \gen_regfile_ff.register_file_i .\g_rf_flops[31].rf_reg_q_t0 ),
.gen_regfile_ff__register_file_i__g_rf_flops_3___rf_reg_q(
  \gen_regfile_ff.register_file_i .\g_rf_flops[3].rf_reg_q ),
.gen_regfile_ff__register_file_i__g_rf_flops_3___rf_reg_q_t0(
  \gen_regfile_ff.register_file_i .\g_rf_flops[3].rf_reg_q_t0 ),
.gen_regfile_ff__register_file_i__g_rf_flops_4___rf_reg_q(
  \gen_regfile_ff.register_file_i .\g_rf_flops[4].rf_reg_q ),
.gen_regfile_ff__register_file_i__g_rf_flops_4___rf_reg_q_t0(
  \gen_regfile_ff.register_file_i .\g_rf_flops[4].rf_reg_q_t0 ),
.gen_regfile_ff__register_file_i__g_rf_flops_5___rf_reg_q(
  \gen_regfile_ff.register_file_i .\g_rf_flops[5].rf_reg_q ),
.gen_regfile_ff__register_file_i__g_rf_flops_5___rf_reg_q_t0(
  \gen_regfile_ff.register_file_i .\g_rf_flops[5].rf_reg_q_t0 ),
.gen_regfile_ff__register_file_i__g_rf_flops_6___rf_reg_q(
  \gen_regfile_ff.register_file_i .\g_rf_flops[6].rf_reg_q ),
.gen_regfile_ff__register_file_i__g_rf_flops_6___rf_reg_q_t0(
  \gen_regfile_ff.register_file_i .\g_rf_flops[6].rf_reg_q_t0 ),
.gen_regfile_ff__register_file_i__g_rf_flops_7___rf_reg_q(
  \gen_regfile_ff.register_file_i .\g_rf_flops[7].rf_reg_q ),
.gen_regfile_ff__register_file_i__g_rf_flops_7___rf_reg_q_t0(
  \gen_regfile_ff.register_file_i .\g_rf_flops[7].rf_reg_q_t0 ),
.gen_regfile_ff__register_file_i__g_rf_flops_8___rf_reg_q(
  \gen_regfile_ff.register_file_i .\g_rf_flops[8].rf_reg_q ),
.gen_regfile_ff__register_file_i__g_rf_flops_8___rf_reg_q_t0(
  \gen_regfile_ff.register_file_i .\g_rf_flops[8].rf_reg_q_t0 ),
.gen_regfile_ff__register_file_i__g_rf_flops_9___rf_reg_q(
  \gen_regfile_ff.register_file_i .\g_rf_flops[9].rf_reg_q ),
.gen_regfile_ff__register_file_i__g_rf_flops_9___rf_reg_q_t0(
  \gen_regfile_ff.register_file_i .\g_rf_flops[9].rf_reg_q_t0 ),
.gen_regfile_ff__register_file_i__gen_wren_check__we_a_dec_buf(
  \gen_regfile_ff.register_file_i .\gen_wren_check.we_a_dec_buf ),
.gen_regfile_ff__register_file_i__gen_wren_check__we_a_dec_buf_t0(
  \gen_regfile_ff.register_file_i .\gen_wren_check.we_a_dec_buf_t0 ),
.gen_regfile_ff__register_file_i__rf_reg_0_(
  \gen_regfile_ff.register_file_i .\rf_reg[0] ),
.gen_regfile_ff__register_file_i__rf_reg_0__t0(
  \gen_regfile_ff.register_file_i .\rf_reg[0]_t0 ),
.gen_regfile_ff__register_file_i__we_a_dec(
  \gen_regfile_ff.register_file_i .we_a_dec),
.gen_regfile_ff__register_file_i__we_a_dec_t0(
  \gen_regfile_ff.register_file_i .we_a_dec_t0),
.gen_regfile_ff__register_file_i__gen_wren_check__u_prim_buf__in_i(
  \gen_regfile_ff.register_file_i .\gen_wren_check.u_prim_buf .in_i),
.gen_regfile_ff__register_file_i__gen_wren_check__u_prim_buf__out_o(
  \gen_regfile_ff.register_file_i .\gen_wren_check.u_prim_buf .out_o),
.gen_regfile_ff__register_file_i__gen_wren_check__u_prim_buf__in_i_t0(
  \gen_regfile_ff.register_file_i .\gen_wren_check.u_prim_buf .in_i_t0),
.gen_regfile_ff__register_file_i__gen_wren_check__u_prim_buf__out_o_t0(
  \gen_regfile_ff.register_file_i .\gen_wren_check.u_prim_buf .out_o_t0),
.gen_regfile_ff__register_file_i__gen_wren_check__u_prim_buf__gen_generic__u_impl_generic__in_i(
  \gen_regfile_ff.register_file_i .\gen_wren_check.u_prim_buf .\gen_generic.u_impl_generic .in_i),
.gen_regfile_ff__register_file_i__gen_wren_check__u_prim_buf__gen_generic__u_impl_generic__out_o(
  \gen_regfile_ff.register_file_i .\gen_wren_check.u_prim_buf .\gen_generic.u_impl_generic .out_o),
.gen_regfile_ff__register_file_i__gen_wren_check__u_prim_buf__gen_generic__u_impl_generic__in_i_t0(
  \gen_regfile_ff.register_file_i .\gen_wren_check.u_prim_buf .\gen_generic.u_impl_generic .in_i_t0),
.gen_regfile_ff__register_file_i__gen_wren_check__u_prim_buf__gen_generic__u_impl_generic__out_o_t0(
  \gen_regfile_ff.register_file_i .\gen_wren_check.u_prim_buf .\gen_generic.u_impl_generic .out_o_t0),
.gen_regfile_ff__register_file_i__gen_wren_check__u_prim_buf__gen_generic__u_impl_generic__inv(
  \gen_regfile_ff.register_file_i .\gen_wren_check.u_prim_buf .\gen_generic.u_impl_generic .inv),
.gen_regfile_ff__register_file_i__gen_wren_check__u_prim_onehot_check__clk_i(
  \gen_regfile_ff.register_file_i .\gen_wren_check.u_prim_onehot_check .clk_i),
.gen_regfile_ff__register_file_i__gen_wren_check__u_prim_onehot_check__rst_ni(
  \gen_regfile_ff.register_file_i .\gen_wren_check.u_prim_onehot_check .rst_ni),
.gen_regfile_ff__register_file_i__gen_wren_check__u_prim_onehot_check__oh_i(
  \gen_regfile_ff.register_file_i .\gen_wren_check.u_prim_onehot_check .oh_i),
.gen_regfile_ff__register_file_i__gen_wren_check__u_prim_onehot_check__addr_i(
  \gen_regfile_ff.register_file_i .\gen_wren_check.u_prim_onehot_check .addr_i),
.gen_regfile_ff__register_file_i__gen_wren_check__u_prim_onehot_check__en_i(
  \gen_regfile_ff.register_file_i .\gen_wren_check.u_prim_onehot_check .en_i),
.gen_regfile_ff__register_file_i__gen_wren_check__u_prim_onehot_check__err_o(
  \gen_regfile_ff.register_file_i .\gen_wren_check.u_prim_onehot_check .err_o),
.gen_regfile_ff__register_file_i__gen_wren_check__u_prim_onehot_check__addr_i_t0(
  \gen_regfile_ff.register_file_i .\gen_wren_check.u_prim_onehot_check .addr_i_t0),
.gen_regfile_ff__register_file_i__gen_wren_check__u_prim_onehot_check__en_i_t0(
  \gen_regfile_ff.register_file_i .\gen_wren_check.u_prim_onehot_check .en_i_t0),
.gen_regfile_ff__register_file_i__gen_wren_check__u_prim_onehot_check__err_o_t0(
  \gen_regfile_ff.register_file_i .\gen_wren_check.u_prim_onehot_check .err_o_t0),
.gen_regfile_ff__register_file_i__gen_wren_check__u_prim_onehot_check__oh_i_t0(
  \gen_regfile_ff.register_file_i .\gen_wren_check.u_prim_onehot_check .oh_i_t0),
.gen_regfile_ff__register_file_i__gen_wren_check__u_prim_onehot_check__addr_err(
  \gen_regfile_ff.register_file_i .\gen_wren_check.u_prim_onehot_check .addr_err),
.gen_regfile_ff__register_file_i__gen_wren_check__u_prim_onehot_check__addr_err_t0(
  \gen_regfile_ff.register_file_i .\gen_wren_check.u_prim_onehot_check .addr_err_t0),
.gen_regfile_ff__register_file_i__gen_wren_check__u_prim_onehot_check__and_tree(
  \gen_regfile_ff.register_file_i .\gen_wren_check.u_prim_onehot_check .and_tree),
.gen_regfile_ff__register_file_i__gen_wren_check__u_prim_onehot_check__and_tree_t0(
  \gen_regfile_ff.register_file_i .\gen_wren_check.u_prim_onehot_check .and_tree_t0),
.gen_regfile_ff__register_file_i__gen_wren_check__u_prim_onehot_check__enable_err(
  \gen_regfile_ff.register_file_i .\gen_wren_check.u_prim_onehot_check .enable_err),
.gen_regfile_ff__register_file_i__gen_wren_check__u_prim_onehot_check__enable_err_t0(
  \gen_regfile_ff.register_file_i .\gen_wren_check.u_prim_onehot_check .enable_err_t0),
.gen_regfile_ff__register_file_i__gen_wren_check__u_prim_onehot_check__err_tree(
  \gen_regfile_ff.register_file_i .\gen_wren_check.u_prim_onehot_check .err_tree),
.gen_regfile_ff__register_file_i__gen_wren_check__u_prim_onehot_check__err_tree_t0(
  \gen_regfile_ff.register_file_i .\gen_wren_check.u_prim_onehot_check .err_tree_t0),
.gen_regfile_ff__register_file_i__gen_wren_check__u_prim_onehot_check__oh0_err(
  \gen_regfile_ff.register_file_i .\gen_wren_check.u_prim_onehot_check .oh0_err),
.gen_regfile_ff__register_file_i__gen_wren_check__u_prim_onehot_check__oh0_err_t0(
  \gen_regfile_ff.register_file_i .\gen_wren_check.u_prim_onehot_check .oh0_err_t0),
.gen_regfile_ff__register_file_i__gen_wren_check__u_prim_onehot_check__or_tree(
  \gen_regfile_ff.register_file_i .\gen_wren_check.u_prim_onehot_check .or_tree),
.gen_regfile_ff__register_file_i__gen_wren_check__u_prim_onehot_check__or_tree_t0(
  \gen_regfile_ff.register_file_i .\gen_wren_check.u_prim_onehot_check .or_tree_t0),
.u_fetch_enable_buf__in_i(
  u_fetch_enable_buf.in_i),
.u_fetch_enable_buf__out_o(
  u_fetch_enable_buf.out_o),
.u_fetch_enable_buf__in_i_t0(
  u_fetch_enable_buf.in_i_t0),
.u_fetch_enable_buf__out_o_t0(
  u_fetch_enable_buf.out_o_t0),
.u_fetch_enable_buf__gen_generic__u_impl_generic__in_i(
  u_fetch_enable_buf.\gen_generic.u_impl_generic .in_i),
.u_fetch_enable_buf__gen_generic__u_impl_generic__out_o(
  u_fetch_enable_buf.\gen_generic.u_impl_generic .out_o),
.u_fetch_enable_buf__gen_generic__u_impl_generic__in_i_t0(
  u_fetch_enable_buf.\gen_generic.u_impl_generic .in_i_t0),
.u_fetch_enable_buf__gen_generic__u_impl_generic__out_o_t0(
  u_fetch_enable_buf.\gen_generic.u_impl_generic .out_o_t0),
.u_fetch_enable_buf__gen_generic__u_impl_generic__inv(
  u_fetch_enable_buf.\gen_generic.u_impl_generic .inv),
.u_ibex_core__clk_i(
  u_ibex_core.clk_i),
.u_ibex_core__rst_ni(
  u_ibex_core.rst_ni),
.u_ibex_core__hart_id_i(
  u_ibex_core.hart_id_i),
.u_ibex_core__boot_addr_i(
  u_ibex_core.boot_addr_i),
.u_ibex_core__instr_req_o(
  u_ibex_core.instr_req_o),
.u_ibex_core__instr_gnt_i(
  u_ibex_core.instr_gnt_i),
.u_ibex_core__instr_rvalid_i(
  u_ibex_core.instr_rvalid_i),
.u_ibex_core__instr_addr_o(
  u_ibex_core.instr_addr_o),
.u_ibex_core__instr_rdata_i(
  u_ibex_core.instr_rdata_i),
.u_ibex_core__instr_err_i(
  u_ibex_core.instr_err_i),
.u_ibex_core__data_req_o(
  u_ibex_core.data_req_o),
.u_ibex_core__data_gnt_i(
  u_ibex_core.data_gnt_i),
.u_ibex_core__data_rvalid_i(
  u_ibex_core.data_rvalid_i),
.u_ibex_core__data_we_o(
  u_ibex_core.data_we_o),
.u_ibex_core__data_be_o(
  u_ibex_core.data_be_o),
.u_ibex_core__data_addr_o(
  u_ibex_core.data_addr_o),
.u_ibex_core__data_wdata_o(
  u_ibex_core.data_wdata_o),
.u_ibex_core__data_rdata_i(
  u_ibex_core.data_rdata_i),
.u_ibex_core__data_err_i(
  u_ibex_core.data_err_i),
.u_ibex_core__dummy_instr_id_o(
  u_ibex_core.dummy_instr_id_o),
.u_ibex_core__dummy_instr_wb_o(
  u_ibex_core.dummy_instr_wb_o),
.u_ibex_core__rf_raddr_a_o(
  u_ibex_core.rf_raddr_a_o),
.u_ibex_core__rf_raddr_b_o(
  u_ibex_core.rf_raddr_b_o),
.u_ibex_core__rf_waddr_wb_o(
  u_ibex_core.rf_waddr_wb_o),
.u_ibex_core__rf_we_wb_o(
  u_ibex_core.rf_we_wb_o),
.u_ibex_core__rf_wdata_wb_ecc_o(
  u_ibex_core.rf_wdata_wb_ecc_o),
.u_ibex_core__rf_rdata_a_ecc_i(
  u_ibex_core.rf_rdata_a_ecc_i),
.u_ibex_core__rf_rdata_b_ecc_i(
  u_ibex_core.rf_rdata_b_ecc_i),
.u_ibex_core__ic_tag_req_o(
  u_ibex_core.ic_tag_req_o),
.u_ibex_core__ic_tag_write_o(
  u_ibex_core.ic_tag_write_o),
.u_ibex_core__ic_tag_addr_o(
  u_ibex_core.ic_tag_addr_o),
.u_ibex_core__ic_tag_wdata_o(
  u_ibex_core.ic_tag_wdata_o),
.u_ibex_core__ic_tag_rdata_i(
  u_ibex_core.ic_tag_rdata_i),
.u_ibex_core__ic_data_req_o(
  u_ibex_core.ic_data_req_o),
.u_ibex_core__ic_data_write_o(
  u_ibex_core.ic_data_write_o),
.u_ibex_core__ic_data_addr_o(
  u_ibex_core.ic_data_addr_o),
.u_ibex_core__ic_data_wdata_o(
  u_ibex_core.ic_data_wdata_o),
.u_ibex_core__ic_data_rdata_i(
  u_ibex_core.ic_data_rdata_i),
.u_ibex_core__ic_scr_key_valid_i(
  u_ibex_core.ic_scr_key_valid_i),
.u_ibex_core__ic_scr_key_req_o(
  u_ibex_core.ic_scr_key_req_o),
.u_ibex_core__irq_software_i(
  u_ibex_core.irq_software_i),
.u_ibex_core__irq_timer_i(
  u_ibex_core.irq_timer_i),
.u_ibex_core__irq_external_i(
  u_ibex_core.irq_external_i),
.u_ibex_core__irq_fast_i(
  u_ibex_core.irq_fast_i),
.u_ibex_core__irq_nm_i(
  u_ibex_core.irq_nm_i),
.u_ibex_core__irq_pending_o(
  u_ibex_core.irq_pending_o),
.u_ibex_core__debug_req_i(
  u_ibex_core.debug_req_i),
.u_ibex_core__crash_dump_o(
  u_ibex_core.crash_dump_o),
.u_ibex_core__double_fault_seen_o(
  u_ibex_core.double_fault_seen_o),
.u_ibex_core__fetch_enable_i(
  u_ibex_core.fetch_enable_i),
.u_ibex_core__alert_minor_o(
  u_ibex_core.alert_minor_o),
.u_ibex_core__alert_major_internal_o(
  u_ibex_core.alert_major_internal_o),
.u_ibex_core__alert_major_bus_o(
  u_ibex_core.alert_major_bus_o),
.u_ibex_core__core_busy_o(
  u_ibex_core.core_busy_o),
.u_ibex_core__instr_addr_o_t0(
  u_ibex_core.instr_addr_o_t0),
.u_ibex_core__instr_gnt_i_t0(
  u_ibex_core.instr_gnt_i_t0),
.u_ibex_core__instr_rvalid_i_t0(
  u_ibex_core.instr_rvalid_i_t0),
.u_ibex_core__ic_tag_write_o_t0(
  u_ibex_core.ic_tag_write_o_t0),
.u_ibex_core__ic_tag_wdata_o_t0(
  u_ibex_core.ic_tag_wdata_o_t0),
.u_ibex_core__ic_tag_req_o_t0(
  u_ibex_core.ic_tag_req_o_t0),
.u_ibex_core__ic_tag_rdata_i_t0(
  u_ibex_core.ic_tag_rdata_i_t0),
.u_ibex_core__ic_tag_addr_o_t0(
  u_ibex_core.ic_tag_addr_o_t0),
.u_ibex_core__ic_scr_key_valid_i_t0(
  u_ibex_core.ic_scr_key_valid_i_t0),
.u_ibex_core__ic_scr_key_req_o_t0(
  u_ibex_core.ic_scr_key_req_o_t0),
.u_ibex_core__ic_data_write_o_t0(
  u_ibex_core.ic_data_write_o_t0),
.u_ibex_core__ic_data_wdata_o_t0(
  u_ibex_core.ic_data_wdata_o_t0),
.u_ibex_core__ic_data_req_o_t0(
  u_ibex_core.ic_data_req_o_t0),
.u_ibex_core__ic_data_rdata_i_t0(
  u_ibex_core.ic_data_rdata_i_t0),
.u_ibex_core__ic_data_addr_o_t0(
  u_ibex_core.ic_data_addr_o_t0),
.u_ibex_core__dummy_instr_id_o_t0(
  u_ibex_core.dummy_instr_id_o_t0),
.u_ibex_core__boot_addr_i_t0(
  u_ibex_core.boot_addr_i_t0),
.u_ibex_core__instr_req_o_t0(
  u_ibex_core.instr_req_o_t0),
.u_ibex_core__instr_rdata_i_t0(
  u_ibex_core.instr_rdata_i_t0),
.u_ibex_core__instr_err_i_t0(
  u_ibex_core.instr_err_i_t0),
.u_ibex_core__data_req_o_t0(
  u_ibex_core.data_req_o_t0),
.u_ibex_core__data_we_o_t0(
  u_ibex_core.data_we_o_t0),
.u_ibex_core__rf_raddr_a_o_t0(
  u_ibex_core.rf_raddr_a_o_t0),
.u_ibex_core__rf_raddr_b_o_t0(
  u_ibex_core.rf_raddr_b_o_t0),
.u_ibex_core__debug_req_i_t0(
  u_ibex_core.debug_req_i_t0),
.u_ibex_core__irq_nm_i_t0(
  u_ibex_core.irq_nm_i_t0),
.u_ibex_core__data_addr_o_t0(
  u_ibex_core.data_addr_o_t0),
.u_ibex_core__data_be_o_t0(
  u_ibex_core.data_be_o_t0),
.u_ibex_core__data_gnt_i_t0(
  u_ibex_core.data_gnt_i_t0),
.u_ibex_core__data_rdata_i_t0(
  u_ibex_core.data_rdata_i_t0),
.u_ibex_core__data_rvalid_i_t0(
  u_ibex_core.data_rvalid_i_t0),
.u_ibex_core__data_wdata_o_t0(
  u_ibex_core.data_wdata_o_t0),
.u_ibex_core__dummy_instr_wb_o_t0(
  u_ibex_core.dummy_instr_wb_o_t0),
.u_ibex_core__rf_waddr_wb_o_t0(
  u_ibex_core.rf_waddr_wb_o_t0),
.u_ibex_core__rf_we_wb_o_t0(
  u_ibex_core.rf_we_wb_o_t0),
.u_ibex_core__double_fault_seen_o_t0(
  u_ibex_core.double_fault_seen_o_t0),
.u_ibex_core__hart_id_i_t0(
  u_ibex_core.hart_id_i_t0),
.u_ibex_core__irq_external_i_t0(
  u_ibex_core.irq_external_i_t0),
.u_ibex_core__irq_fast_i_t0(
  u_ibex_core.irq_fast_i_t0),
.u_ibex_core__irq_pending_o_t0(
  u_ibex_core.irq_pending_o_t0),
.u_ibex_core__irq_software_i_t0(
  u_ibex_core.irq_software_i_t0),
.u_ibex_core__irq_timer_i_t0(
  u_ibex_core.irq_timer_i_t0),
.u_ibex_core__alert_major_bus_o_t0(
  u_ibex_core.alert_major_bus_o_t0),
.u_ibex_core__alert_major_internal_o_t0(
  u_ibex_core.alert_major_internal_o_t0),
.u_ibex_core__alert_minor_o_t0(
  u_ibex_core.alert_minor_o_t0),
.u_ibex_core__core_busy_o_t0(
  u_ibex_core.core_busy_o_t0),
.u_ibex_core__crash_dump_o_t0(
  u_ibex_core.crash_dump_o_t0),
.u_ibex_core__data_err_i_t0(
  u_ibex_core.data_err_i_t0),
.u_ibex_core__fetch_enable_i_t0(
  u_ibex_core.fetch_enable_i_t0),
.u_ibex_core__rf_rdata_a_ecc_i_t0(
  u_ibex_core.rf_rdata_a_ecc_i_t0),
.u_ibex_core__rf_rdata_b_ecc_i_t0(
  u_ibex_core.rf_rdata_b_ecc_i_t0),
.u_ibex_core__rf_wdata_wb_ecc_o_t0(
  u_ibex_core.rf_wdata_wb_ecc_o_t0),
.u_ibex_core__alu_adder_result_ex(
  u_ibex_core.alu_adder_result_ex),
.u_ibex_core__alu_adder_result_ex_t0(
  u_ibex_core.alu_adder_result_ex_t0),
.u_ibex_core__alu_operand_a_ex(
  u_ibex_core.alu_operand_a_ex),
.u_ibex_core__alu_operand_a_ex_t0(
  u_ibex_core.alu_operand_a_ex_t0),
.u_ibex_core__alu_operand_b_ex(
  u_ibex_core.alu_operand_b_ex),
.u_ibex_core__alu_operand_b_ex_t0(
  u_ibex_core.alu_operand_b_ex_t0),
.u_ibex_core__alu_operator_ex(
  u_ibex_core.alu_operator_ex),
.u_ibex_core__alu_operator_ex_t0(
  u_ibex_core.alu_operator_ex_t0),
.u_ibex_core__branch_decision(
  u_ibex_core.branch_decision),
.u_ibex_core__branch_decision_t0(
  u_ibex_core.branch_decision_t0),
.u_ibex_core__branch_target_ex(
  u_ibex_core.branch_target_ex),
.u_ibex_core__branch_target_ex_t0(
  u_ibex_core.branch_target_ex_t0),
.u_ibex_core__bt_a_operand(
  u_ibex_core.bt_a_operand),
.u_ibex_core__bt_a_operand_t0(
  u_ibex_core.bt_a_operand_t0),
.u_ibex_core__bt_b_operand(
  u_ibex_core.bt_b_operand),
.u_ibex_core__bt_b_operand_t0(
  u_ibex_core.bt_b_operand_t0),
.u_ibex_core__crash_dump_mtval(
  u_ibex_core.crash_dump_mtval),
.u_ibex_core__crash_dump_mtval_t0(
  u_ibex_core.crash_dump_mtval_t0),
.u_ibex_core__csr_access(
  u_ibex_core.csr_access),
.u_ibex_core__csr_access_t0(
  u_ibex_core.csr_access_t0),
.u_ibex_core__csr_addr(
  u_ibex_core.csr_addr),
.u_ibex_core__csr_addr_t0(
  u_ibex_core.csr_addr_t0),
.u_ibex_core__csr_depc(
  u_ibex_core.csr_depc),
.u_ibex_core__csr_depc_t0(
  u_ibex_core.csr_depc_t0),
.u_ibex_core__csr_mepc(
  u_ibex_core.csr_mepc),
.u_ibex_core__csr_mepc_t0(
  u_ibex_core.csr_mepc_t0),
.u_ibex_core__csr_mstatus_mie(
  u_ibex_core.csr_mstatus_mie),
.u_ibex_core__csr_mstatus_mie_t0(
  u_ibex_core.csr_mstatus_mie_t0),
.u_ibex_core__csr_mstatus_tw(
  u_ibex_core.csr_mstatus_tw),
.u_ibex_core__csr_mstatus_tw_t0(
  u_ibex_core.csr_mstatus_tw_t0),
.u_ibex_core__csr_mtval(
  u_ibex_core.csr_mtval),
.u_ibex_core__csr_mtval_t0(
  u_ibex_core.csr_mtval_t0),
.u_ibex_core__csr_mtvec(
  u_ibex_core.csr_mtvec),
.u_ibex_core__csr_mtvec_init(
  u_ibex_core.csr_mtvec_init),
.u_ibex_core__csr_mtvec_init_t0(
  u_ibex_core.csr_mtvec_init_t0),
.u_ibex_core__csr_mtvec_t0(
  u_ibex_core.csr_mtvec_t0),
.u_ibex_core__csr_op(
  u_ibex_core.csr_op),
.u_ibex_core__csr_op_en(
  u_ibex_core.csr_op_en),
.u_ibex_core__csr_op_en_t0(
  u_ibex_core.csr_op_en_t0),
.u_ibex_core__csr_op_t0(
  u_ibex_core.csr_op_t0),
.u_ibex_core__csr_pmp_addr(
  u_ibex_core.csr_pmp_addr),
.u_ibex_core__csr_pmp_addr_t0(
  u_ibex_core.csr_pmp_addr_t0),
.u_ibex_core__csr_pmp_cfg(
  u_ibex_core.csr_pmp_cfg),
.u_ibex_core__csr_pmp_cfg_t0(
  u_ibex_core.csr_pmp_cfg_t0),
.u_ibex_core__csr_pmp_mseccfg(
  u_ibex_core.csr_pmp_mseccfg),
.u_ibex_core__csr_pmp_mseccfg_t0(
  u_ibex_core.csr_pmp_mseccfg_t0),
.u_ibex_core__csr_rdata(
  u_ibex_core.csr_rdata),
.u_ibex_core__csr_rdata_t0(
  u_ibex_core.csr_rdata_t0),
.u_ibex_core__csr_restore_dret_id(
  u_ibex_core.csr_restore_dret_id),
.u_ibex_core__csr_restore_dret_id_t0(
  u_ibex_core.csr_restore_dret_id_t0),
.u_ibex_core__csr_restore_mret_id(
  u_ibex_core.csr_restore_mret_id),
.u_ibex_core__csr_restore_mret_id_t0(
  u_ibex_core.csr_restore_mret_id_t0),
.u_ibex_core__csr_save_cause(
  u_ibex_core.csr_save_cause),
.u_ibex_core__csr_save_cause_t0(
  u_ibex_core.csr_save_cause_t0),
.u_ibex_core__csr_save_id(
  u_ibex_core.csr_save_id),
.u_ibex_core__csr_save_id_t0(
  u_ibex_core.csr_save_id_t0),
.u_ibex_core__csr_save_if(
  u_ibex_core.csr_save_if),
.u_ibex_core__csr_save_if_t0(
  u_ibex_core.csr_save_if_t0),
.u_ibex_core__csr_save_wb(
  u_ibex_core.csr_save_wb),
.u_ibex_core__csr_save_wb_t0(
  u_ibex_core.csr_save_wb_t0),
.u_ibex_core__csr_shadow_err(
  u_ibex_core.csr_shadow_err),
.u_ibex_core__csr_shadow_err_t0(
  u_ibex_core.csr_shadow_err_t0),
.u_ibex_core__ctrl_busy(
  u_ibex_core.ctrl_busy),
.u_ibex_core__ctrl_busy_t0(
  u_ibex_core.ctrl_busy_t0),
.u_ibex_core__data_ind_timing(
  u_ibex_core.data_ind_timing),
.u_ibex_core__data_ind_timing_t0(
  u_ibex_core.data_ind_timing_t0),
.u_ibex_core__debug_cause(
  u_ibex_core.debug_cause),
.u_ibex_core__debug_cause_t0(
  u_ibex_core.debug_cause_t0),
.u_ibex_core__debug_csr_save(
  u_ibex_core.debug_csr_save),
.u_ibex_core__debug_csr_save_t0(
  u_ibex_core.debug_csr_save_t0),
.u_ibex_core__debug_ebreakm(
  u_ibex_core.debug_ebreakm),
.u_ibex_core__debug_ebreakm_t0(
  u_ibex_core.debug_ebreakm_t0),
.u_ibex_core__debug_ebreaku(
  u_ibex_core.debug_ebreaku),
.u_ibex_core__debug_ebreaku_t0(
  u_ibex_core.debug_ebreaku_t0),
.u_ibex_core__debug_mode(
  u_ibex_core.debug_mode),
.u_ibex_core__debug_mode_entering(
  u_ibex_core.debug_mode_entering),
.u_ibex_core__debug_mode_entering_t0(
  u_ibex_core.debug_mode_entering_t0),
.u_ibex_core__debug_mode_t0(
  u_ibex_core.debug_mode_t0),
.u_ibex_core__debug_single_step(
  u_ibex_core.debug_single_step),
.u_ibex_core__debug_single_step_t0(
  u_ibex_core.debug_single_step_t0),
.u_ibex_core__div_en_ex(
  u_ibex_core.div_en_ex),
.u_ibex_core__div_en_ex_t0(
  u_ibex_core.div_en_ex_t0),
.u_ibex_core__div_sel_ex(
  u_ibex_core.div_sel_ex),
.u_ibex_core__div_sel_ex_t0(
  u_ibex_core.div_sel_ex_t0),
.u_ibex_core__dummy_instr_en(
  u_ibex_core.dummy_instr_en),
.u_ibex_core__dummy_instr_en_t0(
  u_ibex_core.dummy_instr_en_t0),
.u_ibex_core__dummy_instr_mask(
  u_ibex_core.dummy_instr_mask),
.u_ibex_core__dummy_instr_mask_t0(
  u_ibex_core.dummy_instr_mask_t0),
.u_ibex_core__dummy_instr_seed(
  u_ibex_core.dummy_instr_seed),
.u_ibex_core__dummy_instr_seed_en(
  u_ibex_core.dummy_instr_seed_en),
.u_ibex_core__dummy_instr_seed_en_t0(
  u_ibex_core.dummy_instr_seed_en_t0),
.u_ibex_core__dummy_instr_seed_t0(
  u_ibex_core.dummy_instr_seed_t0),
.u_ibex_core__en_wb(
  u_ibex_core.en_wb),
.u_ibex_core__en_wb_t0(
  u_ibex_core.en_wb_t0),
.u_ibex_core__ex_valid(
  u_ibex_core.ex_valid),
.u_ibex_core__ex_valid_t0(
  u_ibex_core.ex_valid_t0),
.u_ibex_core__exc_cause(
  u_ibex_core.exc_cause),
.u_ibex_core__exc_cause_t0(
  u_ibex_core.exc_cause_t0),
.u_ibex_core__exc_pc_mux_id(
  u_ibex_core.exc_pc_mux_id),
.u_ibex_core__exc_pc_mux_id_t0(
  u_ibex_core.exc_pc_mux_id_t0),
.u_ibex_core__g_core_busy_secure__busy_bits_buf(
  u_ibex_core.\g_core_busy_secure.busy_bits_buf ),
.u_ibex_core__g_core_busy_secure__busy_bits_buf_t0(
  u_ibex_core.\g_core_busy_secure.busy_bits_buf_t0 ),
.u_ibex_core__g_no_pmp__unused_priv_lvl_ls(
  u_ibex_core.\g_no_pmp.unused_priv_lvl_ls ),
.u_ibex_core__g_no_pmp__unused_priv_lvl_ls_t0(
  u_ibex_core.\g_no_pmp.unused_priv_lvl_ls_t0 ),
.u_ibex_core__gen_regfile_ecc__rf_ecc_err_a(
  u_ibex_core.\gen_regfile_ecc.rf_ecc_err_a ),
.u_ibex_core__gen_regfile_ecc__rf_ecc_err_a_id(
  u_ibex_core.\gen_regfile_ecc.rf_ecc_err_a_id ),
.u_ibex_core__gen_regfile_ecc__rf_ecc_err_a_id_t0(
  u_ibex_core.\gen_regfile_ecc.rf_ecc_err_a_id_t0 ),
.u_ibex_core__gen_regfile_ecc__rf_ecc_err_a_t0(
  u_ibex_core.\gen_regfile_ecc.rf_ecc_err_a_t0 ),
.u_ibex_core__gen_regfile_ecc__rf_ecc_err_b(
  u_ibex_core.\gen_regfile_ecc.rf_ecc_err_b ),
.u_ibex_core__gen_regfile_ecc__rf_ecc_err_b_id(
  u_ibex_core.\gen_regfile_ecc.rf_ecc_err_b_id ),
.u_ibex_core__gen_regfile_ecc__rf_ecc_err_b_id_t0(
  u_ibex_core.\gen_regfile_ecc.rf_ecc_err_b_id_t0 ),
.u_ibex_core__gen_regfile_ecc__rf_ecc_err_b_t0(
  u_ibex_core.\gen_regfile_ecc.rf_ecc_err_b_t0 ),
.u_ibex_core__icache_enable(
  u_ibex_core.icache_enable),
.u_ibex_core__icache_enable_t0(
  u_ibex_core.icache_enable_t0),
.u_ibex_core__icache_inval(
  u_ibex_core.icache_inval),
.u_ibex_core__icache_inval_t0(
  u_ibex_core.icache_inval_t0),
.u_ibex_core__id_in_ready(
  u_ibex_core.id_in_ready),
.u_ibex_core__id_in_ready_t0(
  u_ibex_core.id_in_ready_t0),
.u_ibex_core__if_busy(
  u_ibex_core.if_busy),
.u_ibex_core__if_busy_t0(
  u_ibex_core.if_busy_t0),
.u_ibex_core__illegal_c_insn_id(
  u_ibex_core.illegal_c_insn_id),
.u_ibex_core__illegal_c_insn_id_t0(
  u_ibex_core.illegal_c_insn_id_t0),
.u_ibex_core__illegal_csr_insn_id(
  u_ibex_core.illegal_csr_insn_id),
.u_ibex_core__illegal_csr_insn_id_t0(
  u_ibex_core.illegal_csr_insn_id_t0),
.u_ibex_core__illegal_insn_id(
  u_ibex_core.illegal_insn_id),
.u_ibex_core__illegal_insn_id_t0(
  u_ibex_core.illegal_insn_id_t0),
.u_ibex_core__imd_val_d_ex(
  u_ibex_core.imd_val_d_ex),
.u_ibex_core__imd_val_d_ex_t0(
  u_ibex_core.imd_val_d_ex_t0),
.u_ibex_core__imd_val_q_ex(
  u_ibex_core.imd_val_q_ex),
.u_ibex_core__imd_val_q_ex_t0(
  u_ibex_core.imd_val_q_ex_t0),
.u_ibex_core__imd_val_we_ex(
  u_ibex_core.imd_val_we_ex),
.u_ibex_core__imd_val_we_ex_t0(
  u_ibex_core.imd_val_we_ex_t0),
.u_ibex_core__instr_bp_taken_id(
  u_ibex_core.instr_bp_taken_id),
.u_ibex_core__instr_bp_taken_id_t0(
  u_ibex_core.instr_bp_taken_id_t0),
.u_ibex_core__instr_done_wb(
  u_ibex_core.instr_done_wb),
.u_ibex_core__instr_done_wb_t0(
  u_ibex_core.instr_done_wb_t0),
.u_ibex_core__instr_exec(
  u_ibex_core.instr_exec),
.u_ibex_core__instr_exec_t0(
  u_ibex_core.instr_exec_t0),
.u_ibex_core__instr_fetch_err(
  u_ibex_core.instr_fetch_err),
.u_ibex_core__instr_fetch_err_plus2(
  u_ibex_core.instr_fetch_err_plus2),
.u_ibex_core__instr_fetch_err_plus2_t0(
  u_ibex_core.instr_fetch_err_plus2_t0),
.u_ibex_core__instr_fetch_err_t0(
  u_ibex_core.instr_fetch_err_t0),
.u_ibex_core__instr_first_cycle_id(
  u_ibex_core.instr_first_cycle_id),
.u_ibex_core__instr_first_cycle_id_t0(
  u_ibex_core.instr_first_cycle_id_t0),
.u_ibex_core__instr_id_done(
  u_ibex_core.instr_id_done),
.u_ibex_core__instr_id_done_t0(
  u_ibex_core.instr_id_done_t0),
.u_ibex_core__instr_intg_err(
  u_ibex_core.instr_intg_err),
.u_ibex_core__instr_intg_err_t0(
  u_ibex_core.instr_intg_err_t0),
.u_ibex_core__instr_is_compressed_id(
  u_ibex_core.instr_is_compressed_id),
.u_ibex_core__instr_is_compressed_id_t0(
  u_ibex_core.instr_is_compressed_id_t0),
.u_ibex_core__instr_new_id(
  u_ibex_core.instr_new_id),
.u_ibex_core__instr_new_id_t0(
  u_ibex_core.instr_new_id_t0),
.u_ibex_core__instr_perf_count_id(
  u_ibex_core.instr_perf_count_id),
.u_ibex_core__instr_perf_count_id_t0(
  u_ibex_core.instr_perf_count_id_t0),
.u_ibex_core__instr_rdata_alu_id(
  u_ibex_core.instr_rdata_alu_id),
.u_ibex_core__instr_rdata_alu_id_t0(
  u_ibex_core.instr_rdata_alu_id_t0),
.u_ibex_core__instr_rdata_c_id(
  u_ibex_core.instr_rdata_c_id),
.u_ibex_core__instr_rdata_c_id_t0(
  u_ibex_core.instr_rdata_c_id_t0),
.u_ibex_core__instr_rdata_id(
  u_ibex_core.instr_rdata_id),
.u_ibex_core__instr_rdata_id_t0(
  u_ibex_core.instr_rdata_id_t0),
.u_ibex_core__instr_req_gated(
  u_ibex_core.instr_req_gated),
.u_ibex_core__instr_req_gated_t0(
  u_ibex_core.instr_req_gated_t0),
.u_ibex_core__instr_req_int(
  u_ibex_core.instr_req_int),
.u_ibex_core__instr_req_int_t0(
  u_ibex_core.instr_req_int_t0),
.u_ibex_core__instr_type_wb(
  u_ibex_core.instr_type_wb),
.u_ibex_core__instr_type_wb_t0(
  u_ibex_core.instr_type_wb_t0),
.u_ibex_core__instr_valid_clear(
  u_ibex_core.instr_valid_clear),
.u_ibex_core__instr_valid_clear_t0(
  u_ibex_core.instr_valid_clear_t0),
.u_ibex_core__instr_valid_id(
  u_ibex_core.instr_valid_id),
.u_ibex_core__instr_valid_id_t0(
  u_ibex_core.instr_valid_id_t0),
.u_ibex_core__irqs(
  u_ibex_core.irqs),
.u_ibex_core__irqs_t0(
  u_ibex_core.irqs_t0),
.u_ibex_core__lsu_addr_incr_req(
  u_ibex_core.lsu_addr_incr_req),
.u_ibex_core__lsu_addr_incr_req_t0(
  u_ibex_core.lsu_addr_incr_req_t0),
.u_ibex_core__lsu_addr_last(
  u_ibex_core.lsu_addr_last),
.u_ibex_core__lsu_addr_last_t0(
  u_ibex_core.lsu_addr_last_t0),
.u_ibex_core__lsu_busy(
  u_ibex_core.lsu_busy),
.u_ibex_core__lsu_busy_t0(
  u_ibex_core.lsu_busy_t0),
.u_ibex_core__lsu_load_err(
  u_ibex_core.lsu_load_err),
.u_ibex_core__lsu_load_err_t0(
  u_ibex_core.lsu_load_err_t0),
.u_ibex_core__lsu_load_resp_intg_err(
  u_ibex_core.lsu_load_resp_intg_err),
.u_ibex_core__lsu_load_resp_intg_err_t0(
  u_ibex_core.lsu_load_resp_intg_err_t0),
.u_ibex_core__lsu_req(
  u_ibex_core.lsu_req),
.u_ibex_core__lsu_req_done(
  u_ibex_core.lsu_req_done),
.u_ibex_core__lsu_req_done_t0(
  u_ibex_core.lsu_req_done_t0),
.u_ibex_core__lsu_req_t0(
  u_ibex_core.lsu_req_t0),
.u_ibex_core__lsu_resp_err(
  u_ibex_core.lsu_resp_err),
.u_ibex_core__lsu_resp_err_t0(
  u_ibex_core.lsu_resp_err_t0),
.u_ibex_core__lsu_resp_valid(
  u_ibex_core.lsu_resp_valid),
.u_ibex_core__lsu_resp_valid_t0(
  u_ibex_core.lsu_resp_valid_t0),
.u_ibex_core__lsu_sign_ext(
  u_ibex_core.lsu_sign_ext),
.u_ibex_core__lsu_sign_ext_t0(
  u_ibex_core.lsu_sign_ext_t0),
.u_ibex_core__lsu_store_err(
  u_ibex_core.lsu_store_err),
.u_ibex_core__lsu_store_err_t0(
  u_ibex_core.lsu_store_err_t0),
.u_ibex_core__lsu_store_resp_intg_err(
  u_ibex_core.lsu_store_resp_intg_err),
.u_ibex_core__lsu_store_resp_intg_err_t0(
  u_ibex_core.lsu_store_resp_intg_err_t0),
.u_ibex_core__lsu_type(
  u_ibex_core.lsu_type),
.u_ibex_core__lsu_type_t0(
  u_ibex_core.lsu_type_t0),
.u_ibex_core__lsu_wdata(
  u_ibex_core.lsu_wdata),
.u_ibex_core__lsu_wdata_t0(
  u_ibex_core.lsu_wdata_t0),
.u_ibex_core__lsu_we(
  u_ibex_core.lsu_we),
.u_ibex_core__lsu_we_t0(
  u_ibex_core.lsu_we_t0),
.u_ibex_core__mult_en_ex(
  u_ibex_core.mult_en_ex),
.u_ibex_core__mult_en_ex_t0(
  u_ibex_core.mult_en_ex_t0),
.u_ibex_core__mult_sel_ex(
  u_ibex_core.mult_sel_ex),
.u_ibex_core__mult_sel_ex_t0(
  u_ibex_core.mult_sel_ex_t0),
.u_ibex_core__multdiv_operand_a_ex(
  u_ibex_core.multdiv_operand_a_ex),
.u_ibex_core__multdiv_operand_a_ex_t0(
  u_ibex_core.multdiv_operand_a_ex_t0),
.u_ibex_core__multdiv_operand_b_ex(
  u_ibex_core.multdiv_operand_b_ex),
.u_ibex_core__multdiv_operand_b_ex_t0(
  u_ibex_core.multdiv_operand_b_ex_t0),
.u_ibex_core__multdiv_operator_ex(
  u_ibex_core.multdiv_operator_ex),
.u_ibex_core__multdiv_operator_ex_t0(
  u_ibex_core.multdiv_operator_ex_t0),
.u_ibex_core__multdiv_ready_id(
  u_ibex_core.multdiv_ready_id),
.u_ibex_core__multdiv_ready_id_t0(
  u_ibex_core.multdiv_ready_id_t0),
.u_ibex_core__multdiv_signed_mode_ex(
  u_ibex_core.multdiv_signed_mode_ex),
.u_ibex_core__multdiv_signed_mode_ex_t0(
  u_ibex_core.multdiv_signed_mode_ex_t0),
.u_ibex_core__nmi_mode(
  u_ibex_core.nmi_mode),
.u_ibex_core__nmi_mode_t0(
  u_ibex_core.nmi_mode_t0),
.u_ibex_core__nt_branch_addr(
  u_ibex_core.nt_branch_addr),
.u_ibex_core__nt_branch_addr_t0(
  u_ibex_core.nt_branch_addr_t0),
.u_ibex_core__nt_branch_mispredict(
  u_ibex_core.nt_branch_mispredict),
.u_ibex_core__nt_branch_mispredict_t0(
  u_ibex_core.nt_branch_mispredict_t0),
.u_ibex_core__outstanding_load_wb(
  u_ibex_core.outstanding_load_wb),
.u_ibex_core__outstanding_load_wb_t0(
  u_ibex_core.outstanding_load_wb_t0),
.u_ibex_core__outstanding_store_wb(
  u_ibex_core.outstanding_store_wb),
.u_ibex_core__outstanding_store_wb_t0(
  u_ibex_core.outstanding_store_wb_t0),
.u_ibex_core__pc_id(
  u_ibex_core.pc_id),
.u_ibex_core__pc_id_t0(
  u_ibex_core.pc_id_t0),
.u_ibex_core__pc_if(
  u_ibex_core.pc_if),
.u_ibex_core__pc_if_t0(
  u_ibex_core.pc_if_t0),
.u_ibex_core__pc_mismatch_alert(
  u_ibex_core.pc_mismatch_alert),
.u_ibex_core__pc_mismatch_alert_t0(
  u_ibex_core.pc_mismatch_alert_t0),
.u_ibex_core__pc_mux_id(
  u_ibex_core.pc_mux_id),
.u_ibex_core__pc_mux_id_t0(
  u_ibex_core.pc_mux_id_t0),
.u_ibex_core__pc_set(
  u_ibex_core.pc_set),
.u_ibex_core__pc_set_t0(
  u_ibex_core.pc_set_t0),
.u_ibex_core__pc_wb(
  u_ibex_core.pc_wb),
.u_ibex_core__pc_wb_t0(
  u_ibex_core.pc_wb_t0),
.u_ibex_core__perf_branch(
  u_ibex_core.perf_branch),
.u_ibex_core__perf_branch_t0(
  u_ibex_core.perf_branch_t0),
.u_ibex_core__perf_div_wait(
  u_ibex_core.perf_div_wait),
.u_ibex_core__perf_div_wait_t0(
  u_ibex_core.perf_div_wait_t0),
.u_ibex_core__perf_dside_wait(
  u_ibex_core.perf_dside_wait),
.u_ibex_core__perf_dside_wait_t0(
  u_ibex_core.perf_dside_wait_t0),
.u_ibex_core__perf_instr_ret_compressed_wb(
  u_ibex_core.perf_instr_ret_compressed_wb),
.u_ibex_core__perf_instr_ret_compressed_wb_spec(
  u_ibex_core.perf_instr_ret_compressed_wb_spec),
.u_ibex_core__perf_instr_ret_compressed_wb_spec_t0(
  u_ibex_core.perf_instr_ret_compressed_wb_spec_t0),
.u_ibex_core__perf_instr_ret_compressed_wb_t0(
  u_ibex_core.perf_instr_ret_compressed_wb_t0),
.u_ibex_core__perf_instr_ret_wb(
  u_ibex_core.perf_instr_ret_wb),
.u_ibex_core__perf_instr_ret_wb_spec(
  u_ibex_core.perf_instr_ret_wb_spec),
.u_ibex_core__perf_instr_ret_wb_spec_t0(
  u_ibex_core.perf_instr_ret_wb_spec_t0),
.u_ibex_core__perf_instr_ret_wb_t0(
  u_ibex_core.perf_instr_ret_wb_t0),
.u_ibex_core__perf_iside_wait(
  u_ibex_core.perf_iside_wait),
.u_ibex_core__perf_iside_wait_t0(
  u_ibex_core.perf_iside_wait_t0),
.u_ibex_core__perf_jump(
  u_ibex_core.perf_jump),
.u_ibex_core__perf_jump_t0(
  u_ibex_core.perf_jump_t0),
.u_ibex_core__perf_load(
  u_ibex_core.perf_load),
.u_ibex_core__perf_load_t0(
  u_ibex_core.perf_load_t0),
.u_ibex_core__perf_mul_wait(
  u_ibex_core.perf_mul_wait),
.u_ibex_core__perf_mul_wait_t0(
  u_ibex_core.perf_mul_wait_t0),
.u_ibex_core__perf_store(
  u_ibex_core.perf_store),
.u_ibex_core__perf_store_t0(
  u_ibex_core.perf_store_t0),
.u_ibex_core__perf_tbranch(
  u_ibex_core.perf_tbranch),
.u_ibex_core__perf_tbranch_t0(
  u_ibex_core.perf_tbranch_t0),
.u_ibex_core__priv_mode_id(
  u_ibex_core.priv_mode_id),
.u_ibex_core__priv_mode_id_t0(
  u_ibex_core.priv_mode_id_t0),
.u_ibex_core__ready_wb(
  u_ibex_core.ready_wb),
.u_ibex_core__ready_wb_t0(
  u_ibex_core.ready_wb_t0),
.u_ibex_core__result_ex(
  u_ibex_core.result_ex),
.u_ibex_core__result_ex_t0(
  u_ibex_core.result_ex_t0),
.u_ibex_core__rf_ecc_err_comb(
  u_ibex_core.rf_ecc_err_comb),
.u_ibex_core__rf_ecc_err_comb_t0(
  u_ibex_core.rf_ecc_err_comb_t0),
.u_ibex_core__rf_rd_a_wb_match(
  u_ibex_core.rf_rd_a_wb_match),
.u_ibex_core__rf_rd_a_wb_match_t0(
  u_ibex_core.rf_rd_a_wb_match_t0),
.u_ibex_core__rf_rd_b_wb_match(
  u_ibex_core.rf_rd_b_wb_match),
.u_ibex_core__rf_rd_b_wb_match_t0(
  u_ibex_core.rf_rd_b_wb_match_t0),
.u_ibex_core__rf_ren_a(
  u_ibex_core.rf_ren_a),
.u_ibex_core__rf_ren_a_t0(
  u_ibex_core.rf_ren_a_t0),
.u_ibex_core__rf_ren_b(
  u_ibex_core.rf_ren_b),
.u_ibex_core__rf_ren_b_t0(
  u_ibex_core.rf_ren_b_t0),
.u_ibex_core__rf_waddr_id(
  u_ibex_core.rf_waddr_id),
.u_ibex_core__rf_waddr_id_t0(
  u_ibex_core.rf_waddr_id_t0),
.u_ibex_core__rf_wdata_fwd_wb(
  u_ibex_core.rf_wdata_fwd_wb),
.u_ibex_core__rf_wdata_fwd_wb_t0(
  u_ibex_core.rf_wdata_fwd_wb_t0),
.u_ibex_core__rf_wdata_id(
  u_ibex_core.rf_wdata_id),
.u_ibex_core__rf_wdata_id_t0(
  u_ibex_core.rf_wdata_id_t0),
.u_ibex_core__rf_wdata_lsu(
  u_ibex_core.rf_wdata_lsu),
.u_ibex_core__rf_wdata_lsu_t0(
  u_ibex_core.rf_wdata_lsu_t0),
.u_ibex_core__rf_wdata_wb(
  u_ibex_core.rf_wdata_wb),
.u_ibex_core__rf_wdata_wb_t0(
  u_ibex_core.rf_wdata_wb_t0),
.u_ibex_core__rf_we_id(
  u_ibex_core.rf_we_id),
.u_ibex_core__rf_we_id_t0(
  u_ibex_core.rf_we_id_t0),
.u_ibex_core__rf_we_lsu(
  u_ibex_core.rf_we_lsu),
.u_ibex_core__rf_we_lsu_t0(
  u_ibex_core.rf_we_lsu_t0),
.u_ibex_core__rf_write_wb(
  u_ibex_core.rf_write_wb),
.u_ibex_core__rf_write_wb_t0(
  u_ibex_core.rf_write_wb_t0),
.u_ibex_core__trigger_match(
  u_ibex_core.trigger_match),
.u_ibex_core__trigger_match_t0(
  u_ibex_core.trigger_match_t0),
.u_ibex_core__cs_registers_i__clk_i(
  u_ibex_core.cs_registers_i.clk_i),
.u_ibex_core__cs_registers_i__rst_ni(
  u_ibex_core.cs_registers_i.rst_ni),
.u_ibex_core__cs_registers_i__hart_id_i(
  u_ibex_core.cs_registers_i.hart_id_i),
.u_ibex_core__cs_registers_i__priv_mode_id_o(
  u_ibex_core.cs_registers_i.priv_mode_id_o),
.u_ibex_core__cs_registers_i__priv_mode_lsu_o(
  u_ibex_core.cs_registers_i.priv_mode_lsu_o),
.u_ibex_core__cs_registers_i__csr_mstatus_tw_o(
  u_ibex_core.cs_registers_i.csr_mstatus_tw_o),
.u_ibex_core__cs_registers_i__csr_mtvec_o(
  u_ibex_core.cs_registers_i.csr_mtvec_o),
.u_ibex_core__cs_registers_i__csr_mtvec_init_i(
  u_ibex_core.cs_registers_i.csr_mtvec_init_i),
.u_ibex_core__cs_registers_i__boot_addr_i(
  u_ibex_core.cs_registers_i.boot_addr_i),
.u_ibex_core__cs_registers_i__csr_access_i(
  u_ibex_core.cs_registers_i.csr_access_i),
.u_ibex_core__cs_registers_i__csr_addr_i(
  u_ibex_core.cs_registers_i.csr_addr_i),
.u_ibex_core__cs_registers_i__csr_wdata_i(
  u_ibex_core.cs_registers_i.csr_wdata_i),
.u_ibex_core__cs_registers_i__csr_op_i(
  u_ibex_core.cs_registers_i.csr_op_i),
.u_ibex_core__cs_registers_i__csr_op_en_i(
  u_ibex_core.cs_registers_i.csr_op_en_i),
.u_ibex_core__cs_registers_i__csr_rdata_o(
  u_ibex_core.cs_registers_i.csr_rdata_o),
.u_ibex_core__cs_registers_i__irq_software_i(
  u_ibex_core.cs_registers_i.irq_software_i),
.u_ibex_core__cs_registers_i__irq_timer_i(
  u_ibex_core.cs_registers_i.irq_timer_i),
.u_ibex_core__cs_registers_i__irq_external_i(
  u_ibex_core.cs_registers_i.irq_external_i),
.u_ibex_core__cs_registers_i__irq_fast_i(
  u_ibex_core.cs_registers_i.irq_fast_i),
.u_ibex_core__cs_registers_i__nmi_mode_i(
  u_ibex_core.cs_registers_i.nmi_mode_i),
.u_ibex_core__cs_registers_i__irq_pending_o(
  u_ibex_core.cs_registers_i.irq_pending_o),
.u_ibex_core__cs_registers_i__irqs_o(
  u_ibex_core.cs_registers_i.irqs_o),
.u_ibex_core__cs_registers_i__csr_mstatus_mie_o(
  u_ibex_core.cs_registers_i.csr_mstatus_mie_o),
.u_ibex_core__cs_registers_i__csr_mepc_o(
  u_ibex_core.cs_registers_i.csr_mepc_o),
.u_ibex_core__cs_registers_i__csr_mtval_o(
  u_ibex_core.cs_registers_i.csr_mtval_o),
.u_ibex_core__cs_registers_i__csr_pmp_cfg_o(
  u_ibex_core.cs_registers_i.csr_pmp_cfg_o),
.u_ibex_core__cs_registers_i__csr_pmp_addr_o(
  u_ibex_core.cs_registers_i.csr_pmp_addr_o),
.u_ibex_core__cs_registers_i__csr_pmp_mseccfg_o(
  u_ibex_core.cs_registers_i.csr_pmp_mseccfg_o),
.u_ibex_core__cs_registers_i__debug_mode_i(
  u_ibex_core.cs_registers_i.debug_mode_i),
.u_ibex_core__cs_registers_i__debug_mode_entering_i(
  u_ibex_core.cs_registers_i.debug_mode_entering_i),
.u_ibex_core__cs_registers_i__debug_cause_i(
  u_ibex_core.cs_registers_i.debug_cause_i),
.u_ibex_core__cs_registers_i__debug_csr_save_i(
  u_ibex_core.cs_registers_i.debug_csr_save_i),
.u_ibex_core__cs_registers_i__csr_depc_o(
  u_ibex_core.cs_registers_i.csr_depc_o),
.u_ibex_core__cs_registers_i__debug_single_step_o(
  u_ibex_core.cs_registers_i.debug_single_step_o),
.u_ibex_core__cs_registers_i__debug_ebreakm_o(
  u_ibex_core.cs_registers_i.debug_ebreakm_o),
.u_ibex_core__cs_registers_i__debug_ebreaku_o(
  u_ibex_core.cs_registers_i.debug_ebreaku_o),
.u_ibex_core__cs_registers_i__trigger_match_o(
  u_ibex_core.cs_registers_i.trigger_match_o),
.u_ibex_core__cs_registers_i__pc_if_i(
  u_ibex_core.cs_registers_i.pc_if_i),
.u_ibex_core__cs_registers_i__pc_id_i(
  u_ibex_core.cs_registers_i.pc_id_i),
.u_ibex_core__cs_registers_i__pc_wb_i(
  u_ibex_core.cs_registers_i.pc_wb_i),
.u_ibex_core__cs_registers_i__data_ind_timing_o(
  u_ibex_core.cs_registers_i.data_ind_timing_o),
.u_ibex_core__cs_registers_i__dummy_instr_en_o(
  u_ibex_core.cs_registers_i.dummy_instr_en_o),
.u_ibex_core__cs_registers_i__dummy_instr_mask_o(
  u_ibex_core.cs_registers_i.dummy_instr_mask_o),
.u_ibex_core__cs_registers_i__dummy_instr_seed_en_o(
  u_ibex_core.cs_registers_i.dummy_instr_seed_en_o),
.u_ibex_core__cs_registers_i__dummy_instr_seed_o(
  u_ibex_core.cs_registers_i.dummy_instr_seed_o),
.u_ibex_core__cs_registers_i__icache_enable_o(
  u_ibex_core.cs_registers_i.icache_enable_o),
.u_ibex_core__cs_registers_i__csr_shadow_err_o(
  u_ibex_core.cs_registers_i.csr_shadow_err_o),
.u_ibex_core__cs_registers_i__ic_scr_key_valid_i(
  u_ibex_core.cs_registers_i.ic_scr_key_valid_i),
.u_ibex_core__cs_registers_i__csr_save_if_i(
  u_ibex_core.cs_registers_i.csr_save_if_i),
.u_ibex_core__cs_registers_i__csr_save_id_i(
  u_ibex_core.cs_registers_i.csr_save_id_i),
.u_ibex_core__cs_registers_i__csr_save_wb_i(
  u_ibex_core.cs_registers_i.csr_save_wb_i),
.u_ibex_core__cs_registers_i__csr_restore_mret_i(
  u_ibex_core.cs_registers_i.csr_restore_mret_i),
.u_ibex_core__cs_registers_i__csr_restore_dret_i(
  u_ibex_core.cs_registers_i.csr_restore_dret_i),
.u_ibex_core__cs_registers_i__csr_save_cause_i(
  u_ibex_core.cs_registers_i.csr_save_cause_i),
.u_ibex_core__cs_registers_i__csr_mcause_i(
  u_ibex_core.cs_registers_i.csr_mcause_i),
.u_ibex_core__cs_registers_i__csr_mtval_i(
  u_ibex_core.cs_registers_i.csr_mtval_i),
.u_ibex_core__cs_registers_i__illegal_csr_insn_o(
  u_ibex_core.cs_registers_i.illegal_csr_insn_o),
.u_ibex_core__cs_registers_i__double_fault_seen_o(
  u_ibex_core.cs_registers_i.double_fault_seen_o),
.u_ibex_core__cs_registers_i__instr_ret_i(
  u_ibex_core.cs_registers_i.instr_ret_i),
.u_ibex_core__cs_registers_i__instr_ret_compressed_i(
  u_ibex_core.cs_registers_i.instr_ret_compressed_i),
.u_ibex_core__cs_registers_i__instr_ret_spec_i(
  u_ibex_core.cs_registers_i.instr_ret_spec_i),
.u_ibex_core__cs_registers_i__instr_ret_compressed_spec_i(
  u_ibex_core.cs_registers_i.instr_ret_compressed_spec_i),
.u_ibex_core__cs_registers_i__iside_wait_i(
  u_ibex_core.cs_registers_i.iside_wait_i),
.u_ibex_core__cs_registers_i__jump_i(
  u_ibex_core.cs_registers_i.jump_i),
.u_ibex_core__cs_registers_i__branch_i(
  u_ibex_core.cs_registers_i.branch_i),
.u_ibex_core__cs_registers_i__branch_taken_i(
  u_ibex_core.cs_registers_i.branch_taken_i),
.u_ibex_core__cs_registers_i__mem_load_i(
  u_ibex_core.cs_registers_i.mem_load_i),
.u_ibex_core__cs_registers_i__mem_store_i(
  u_ibex_core.cs_registers_i.mem_store_i),
.u_ibex_core__cs_registers_i__dside_wait_i(
  u_ibex_core.cs_registers_i.dside_wait_i),
.u_ibex_core__cs_registers_i__mul_wait_i(
  u_ibex_core.cs_registers_i.mul_wait_i),
.u_ibex_core__cs_registers_i__div_wait_i(
  u_ibex_core.cs_registers_i.div_wait_i),
.u_ibex_core__cs_registers_i__ic_scr_key_valid_i_t0(
  u_ibex_core.cs_registers_i.ic_scr_key_valid_i_t0),
.u_ibex_core__cs_registers_i__boot_addr_i_t0(
  u_ibex_core.cs_registers_i.boot_addr_i_t0),
.u_ibex_core__cs_registers_i__branch_i_t0(
  u_ibex_core.cs_registers_i.branch_i_t0),
.u_ibex_core__cs_registers_i__branch_taken_i_t0(
  u_ibex_core.cs_registers_i.branch_taken_i_t0),
.u_ibex_core__cs_registers_i__csr_mtval_o_t0(
  u_ibex_core.cs_registers_i.csr_mtval_o_t0),
.u_ibex_core__cs_registers_i__pc_id_i_t0(
  u_ibex_core.cs_registers_i.pc_id_i_t0),
.u_ibex_core__cs_registers_i__csr_access_i_t0(
  u_ibex_core.cs_registers_i.csr_access_i_t0),
.u_ibex_core__cs_registers_i__csr_addr_i_t0(
  u_ibex_core.cs_registers_i.csr_addr_i_t0),
.u_ibex_core__cs_registers_i__csr_depc_o_t0(
  u_ibex_core.cs_registers_i.csr_depc_o_t0),
.u_ibex_core__cs_registers_i__csr_mcause_i_t0(
  u_ibex_core.cs_registers_i.csr_mcause_i_t0),
.u_ibex_core__cs_registers_i__csr_mepc_o_t0(
  u_ibex_core.cs_registers_i.csr_mepc_o_t0),
.u_ibex_core__cs_registers_i__csr_mstatus_mie_o_t0(
  u_ibex_core.cs_registers_i.csr_mstatus_mie_o_t0),
.u_ibex_core__cs_registers_i__csr_mstatus_tw_o_t0(
  u_ibex_core.cs_registers_i.csr_mstatus_tw_o_t0),
.u_ibex_core__cs_registers_i__csr_mtval_i_t0(
  u_ibex_core.cs_registers_i.csr_mtval_i_t0),
.u_ibex_core__cs_registers_i__csr_mtvec_init_i_t0(
  u_ibex_core.cs_registers_i.csr_mtvec_init_i_t0),
.u_ibex_core__cs_registers_i__csr_mtvec_o_t0(
  u_ibex_core.cs_registers_i.csr_mtvec_o_t0),
.u_ibex_core__cs_registers_i__csr_op_en_i_t0(
  u_ibex_core.cs_registers_i.csr_op_en_i_t0),
.u_ibex_core__cs_registers_i__csr_op_i_t0(
  u_ibex_core.cs_registers_i.csr_op_i_t0),
.u_ibex_core__cs_registers_i__csr_pmp_addr_o_t0(
  u_ibex_core.cs_registers_i.csr_pmp_addr_o_t0),
.u_ibex_core__cs_registers_i__csr_pmp_cfg_o_t0(
  u_ibex_core.cs_registers_i.csr_pmp_cfg_o_t0),
.u_ibex_core__cs_registers_i__csr_pmp_mseccfg_o_t0(
  u_ibex_core.cs_registers_i.csr_pmp_mseccfg_o_t0),
.u_ibex_core__cs_registers_i__csr_rdata_o_t0(
  u_ibex_core.cs_registers_i.csr_rdata_o_t0),
.u_ibex_core__cs_registers_i__csr_restore_dret_i_t0(
  u_ibex_core.cs_registers_i.csr_restore_dret_i_t0),
.u_ibex_core__cs_registers_i__csr_restore_mret_i_t0(
  u_ibex_core.cs_registers_i.csr_restore_mret_i_t0),
.u_ibex_core__cs_registers_i__csr_save_cause_i_t0(
  u_ibex_core.cs_registers_i.csr_save_cause_i_t0),
.u_ibex_core__cs_registers_i__csr_save_id_i_t0(
  u_ibex_core.cs_registers_i.csr_save_id_i_t0),
.u_ibex_core__cs_registers_i__csr_save_if_i_t0(
  u_ibex_core.cs_registers_i.csr_save_if_i_t0),
.u_ibex_core__cs_registers_i__csr_save_wb_i_t0(
  u_ibex_core.cs_registers_i.csr_save_wb_i_t0),
.u_ibex_core__cs_registers_i__csr_shadow_err_o_t0(
  u_ibex_core.cs_registers_i.csr_shadow_err_o_t0),
.u_ibex_core__cs_registers_i__csr_wdata_i_t0(
  u_ibex_core.cs_registers_i.csr_wdata_i_t0),
.u_ibex_core__cs_registers_i__data_ind_timing_o_t0(
  u_ibex_core.cs_registers_i.data_ind_timing_o_t0),
.u_ibex_core__cs_registers_i__debug_cause_i_t0(
  u_ibex_core.cs_registers_i.debug_cause_i_t0),
.u_ibex_core__cs_registers_i__debug_csr_save_i_t0(
  u_ibex_core.cs_registers_i.debug_csr_save_i_t0),
.u_ibex_core__cs_registers_i__debug_ebreakm_o_t0(
  u_ibex_core.cs_registers_i.debug_ebreakm_o_t0),
.u_ibex_core__cs_registers_i__debug_ebreaku_o_t0(
  u_ibex_core.cs_registers_i.debug_ebreaku_o_t0),
.u_ibex_core__cs_registers_i__debug_mode_entering_i_t0(
  u_ibex_core.cs_registers_i.debug_mode_entering_i_t0),
.u_ibex_core__cs_registers_i__debug_mode_i_t0(
  u_ibex_core.cs_registers_i.debug_mode_i_t0),
.u_ibex_core__cs_registers_i__debug_single_step_o_t0(
  u_ibex_core.cs_registers_i.debug_single_step_o_t0),
.u_ibex_core__cs_registers_i__div_wait_i_t0(
  u_ibex_core.cs_registers_i.div_wait_i_t0),
.u_ibex_core__cs_registers_i__double_fault_seen_o_t0(
  u_ibex_core.cs_registers_i.double_fault_seen_o_t0),
.u_ibex_core__cs_registers_i__dside_wait_i_t0(
  u_ibex_core.cs_registers_i.dside_wait_i_t0),
.u_ibex_core__cs_registers_i__dummy_instr_en_o_t0(
  u_ibex_core.cs_registers_i.dummy_instr_en_o_t0),
.u_ibex_core__cs_registers_i__dummy_instr_mask_o_t0(
  u_ibex_core.cs_registers_i.dummy_instr_mask_o_t0),
.u_ibex_core__cs_registers_i__dummy_instr_seed_en_o_t0(
  u_ibex_core.cs_registers_i.dummy_instr_seed_en_o_t0),
.u_ibex_core__cs_registers_i__dummy_instr_seed_o_t0(
  u_ibex_core.cs_registers_i.dummy_instr_seed_o_t0),
.u_ibex_core__cs_registers_i__hart_id_i_t0(
  u_ibex_core.cs_registers_i.hart_id_i_t0),
.u_ibex_core__cs_registers_i__icache_enable_o_t0(
  u_ibex_core.cs_registers_i.icache_enable_o_t0),
.u_ibex_core__cs_registers_i__illegal_csr_insn_o_t0(
  u_ibex_core.cs_registers_i.illegal_csr_insn_o_t0),
.u_ibex_core__cs_registers_i__instr_ret_compressed_i_t0(
  u_ibex_core.cs_registers_i.instr_ret_compressed_i_t0),
.u_ibex_core__cs_registers_i__instr_ret_compressed_spec_i_t0(
  u_ibex_core.cs_registers_i.instr_ret_compressed_spec_i_t0),
.u_ibex_core__cs_registers_i__instr_ret_i_t0(
  u_ibex_core.cs_registers_i.instr_ret_i_t0),
.u_ibex_core__cs_registers_i__instr_ret_spec_i_t0(
  u_ibex_core.cs_registers_i.instr_ret_spec_i_t0),
.u_ibex_core__cs_registers_i__irq_external_i_t0(
  u_ibex_core.cs_registers_i.irq_external_i_t0),
.u_ibex_core__cs_registers_i__irq_fast_i_t0(
  u_ibex_core.cs_registers_i.irq_fast_i_t0),
.u_ibex_core__cs_registers_i__irq_pending_o_t0(
  u_ibex_core.cs_registers_i.irq_pending_o_t0),
.u_ibex_core__cs_registers_i__irq_software_i_t0(
  u_ibex_core.cs_registers_i.irq_software_i_t0),
.u_ibex_core__cs_registers_i__irq_timer_i_t0(
  u_ibex_core.cs_registers_i.irq_timer_i_t0),
.u_ibex_core__cs_registers_i__irqs_o_t0(
  u_ibex_core.cs_registers_i.irqs_o_t0),
.u_ibex_core__cs_registers_i__iside_wait_i_t0(
  u_ibex_core.cs_registers_i.iside_wait_i_t0),
.u_ibex_core__cs_registers_i__jump_i_t0(
  u_ibex_core.cs_registers_i.jump_i_t0),
.u_ibex_core__cs_registers_i__mem_load_i_t0(
  u_ibex_core.cs_registers_i.mem_load_i_t0),
.u_ibex_core__cs_registers_i__mem_store_i_t0(
  u_ibex_core.cs_registers_i.mem_store_i_t0),
.u_ibex_core__cs_registers_i__mul_wait_i_t0(
  u_ibex_core.cs_registers_i.mul_wait_i_t0),
.u_ibex_core__cs_registers_i__nmi_mode_i_t0(
  u_ibex_core.cs_registers_i.nmi_mode_i_t0),
.u_ibex_core__cs_registers_i__pc_if_i_t0(
  u_ibex_core.cs_registers_i.pc_if_i_t0),
.u_ibex_core__cs_registers_i__pc_wb_i_t0(
  u_ibex_core.cs_registers_i.pc_wb_i_t0),
.u_ibex_core__cs_registers_i__priv_mode_id_o_t0(
  u_ibex_core.cs_registers_i.priv_mode_id_o_t0),
.u_ibex_core__cs_registers_i__priv_mode_lsu_o_t0(
  u_ibex_core.cs_registers_i.priv_mode_lsu_o_t0),
.u_ibex_core__cs_registers_i__trigger_match_o_t0(
  u_ibex_core.cs_registers_i.trigger_match_o_t0),
.u_ibex_core__cs_registers_i__cpuctrlsts_part_d(
  u_ibex_core.cs_registers_i.cpuctrlsts_part_d),
.u_ibex_core__cs_registers_i__cpuctrlsts_part_d_t0(
  u_ibex_core.cs_registers_i.cpuctrlsts_part_d_t0),
.u_ibex_core__cs_registers_i__cpuctrlsts_part_err(
  u_ibex_core.cs_registers_i.cpuctrlsts_part_err),
.u_ibex_core__cs_registers_i__cpuctrlsts_part_err_t0(
  u_ibex_core.cs_registers_i.cpuctrlsts_part_err_t0),
.u_ibex_core__cs_registers_i__cpuctrlsts_part_q(
  u_ibex_core.cs_registers_i.cpuctrlsts_part_q),
.u_ibex_core__cs_registers_i__cpuctrlsts_part_q_t0(
  u_ibex_core.cs_registers_i.cpuctrlsts_part_q_t0),
.u_ibex_core__cs_registers_i__cpuctrlsts_part_we(
  u_ibex_core.cs_registers_i.cpuctrlsts_part_we),
.u_ibex_core__cs_registers_i__cpuctrlsts_part_we_t0(
  u_ibex_core.cs_registers_i.cpuctrlsts_part_we_t0),
.u_ibex_core__cs_registers_i__csr_we_int(
  u_ibex_core.cs_registers_i.csr_we_int),
.u_ibex_core__cs_registers_i__csr_we_int_t0(
  u_ibex_core.cs_registers_i.csr_we_int_t0),
.u_ibex_core__cs_registers_i__csr_wr(
  u_ibex_core.cs_registers_i.csr_wr),
.u_ibex_core__cs_registers_i__csr_wr_t0(
  u_ibex_core.cs_registers_i.csr_wr_t0),
.u_ibex_core__cs_registers_i__dbg_csr(
  u_ibex_core.cs_registers_i.dbg_csr),
.u_ibex_core__cs_registers_i__dbg_csr_t0(
  u_ibex_core.cs_registers_i.dbg_csr_t0),
.u_ibex_core__cs_registers_i__dcsr_d(
  u_ibex_core.cs_registers_i.dcsr_d),
.u_ibex_core__cs_registers_i__dcsr_d_t0(
  u_ibex_core.cs_registers_i.dcsr_d_t0),
.u_ibex_core__cs_registers_i__dcsr_en(
  u_ibex_core.cs_registers_i.dcsr_en),
.u_ibex_core__cs_registers_i__dcsr_en_t0(
  u_ibex_core.cs_registers_i.dcsr_en_t0),
.u_ibex_core__cs_registers_i__dcsr_q(
  u_ibex_core.cs_registers_i.dcsr_q),
.u_ibex_core__cs_registers_i__dcsr_q_t0(
  u_ibex_core.cs_registers_i.dcsr_q_t0),
.u_ibex_core__cs_registers_i__depc_d(
  u_ibex_core.cs_registers_i.depc_d),
.u_ibex_core__cs_registers_i__depc_d_t0(
  u_ibex_core.cs_registers_i.depc_d_t0),
.u_ibex_core__cs_registers_i__depc_en(
  u_ibex_core.cs_registers_i.depc_en),
.u_ibex_core__cs_registers_i__depc_en_t0(
  u_ibex_core.cs_registers_i.depc_en_t0),
.u_ibex_core__cs_registers_i__dscratch0_en(
  u_ibex_core.cs_registers_i.dscratch0_en),
.u_ibex_core__cs_registers_i__dscratch0_en_t0(
  u_ibex_core.cs_registers_i.dscratch0_en_t0),
.u_ibex_core__cs_registers_i__dscratch0_q(
  u_ibex_core.cs_registers_i.dscratch0_q),
.u_ibex_core__cs_registers_i__dscratch0_q_t0(
  u_ibex_core.cs_registers_i.dscratch0_q_t0),
.u_ibex_core__cs_registers_i__dscratch1_en(
  u_ibex_core.cs_registers_i.dscratch1_en),
.u_ibex_core__cs_registers_i__dscratch1_en_t0(
  u_ibex_core.cs_registers_i.dscratch1_en_t0),
.u_ibex_core__cs_registers_i__dscratch1_q(
  u_ibex_core.cs_registers_i.dscratch1_q),
.u_ibex_core__cs_registers_i__dscratch1_q_t0(
  u_ibex_core.cs_registers_i.dscratch1_q_t0),
.u_ibex_core__cs_registers_i__illegal_csr(
  u_ibex_core.cs_registers_i.illegal_csr),
.u_ibex_core__cs_registers_i__illegal_csr_dbg(
  u_ibex_core.cs_registers_i.illegal_csr_dbg),
.u_ibex_core__cs_registers_i__illegal_csr_dbg_t0(
  u_ibex_core.cs_registers_i.illegal_csr_dbg_t0),
.u_ibex_core__cs_registers_i__illegal_csr_priv(
  u_ibex_core.cs_registers_i.illegal_csr_priv),
.u_ibex_core__cs_registers_i__illegal_csr_priv_t0(
  u_ibex_core.cs_registers_i.illegal_csr_priv_t0),
.u_ibex_core__cs_registers_i__illegal_csr_t0(
  u_ibex_core.cs_registers_i.illegal_csr_t0),
.u_ibex_core__cs_registers_i__illegal_csr_write(
  u_ibex_core.cs_registers_i.illegal_csr_write),
.u_ibex_core__cs_registers_i__illegal_csr_write_t0(
  u_ibex_core.cs_registers_i.illegal_csr_write_t0),
.u_ibex_core__cs_registers_i__mcause_d(
  u_ibex_core.cs_registers_i.mcause_d),
.u_ibex_core__cs_registers_i__mcause_d_t0(
  u_ibex_core.cs_registers_i.mcause_d_t0),
.u_ibex_core__cs_registers_i__mcause_en(
  u_ibex_core.cs_registers_i.mcause_en),
.u_ibex_core__cs_registers_i__mcause_en_t0(
  u_ibex_core.cs_registers_i.mcause_en_t0),
.u_ibex_core__cs_registers_i__mcause_q(
  u_ibex_core.cs_registers_i.mcause_q),
.u_ibex_core__cs_registers_i__mcause_q_t0(
  u_ibex_core.cs_registers_i.mcause_q_t0),
.u_ibex_core__cs_registers_i__mcountinhibit(
  u_ibex_core.cs_registers_i.mcountinhibit),
.u_ibex_core__cs_registers_i__mcountinhibit_t0(
  u_ibex_core.cs_registers_i.mcountinhibit_t0),
.u_ibex_core__cs_registers_i__mcountinhibit_we(
  u_ibex_core.cs_registers_i.mcountinhibit_we),
.u_ibex_core__cs_registers_i__mcountinhibit_we_t0(
  u_ibex_core.cs_registers_i.mcountinhibit_we_t0),
.u_ibex_core__cs_registers_i__mepc_d(
  u_ibex_core.cs_registers_i.mepc_d),
.u_ibex_core__cs_registers_i__mepc_d_t0(
  u_ibex_core.cs_registers_i.mepc_d_t0),
.u_ibex_core__cs_registers_i__mepc_en(
  u_ibex_core.cs_registers_i.mepc_en),
.u_ibex_core__cs_registers_i__mepc_en_t0(
  u_ibex_core.cs_registers_i.mepc_en_t0),
.u_ibex_core__cs_registers_i__mhpmcounter_0_(
  u_ibex_core.cs_registers_i.\mhpmcounter[0] ),
.u_ibex_core__cs_registers_i__mhpmcounter_0__t0(
  u_ibex_core.cs_registers_i.\mhpmcounter[0]_t0 ),
.u_ibex_core__cs_registers_i__mhpmcounter_2_(
  u_ibex_core.cs_registers_i.\mhpmcounter[2] ),
.u_ibex_core__cs_registers_i__mhpmcounter_2__t0(
  u_ibex_core.cs_registers_i.\mhpmcounter[2]_t0 ),
.u_ibex_core__cs_registers_i__mhpmcounter_we(
  u_ibex_core.cs_registers_i.mhpmcounter_we),
.u_ibex_core__cs_registers_i__mhpmcounter_we_t0(
  u_ibex_core.cs_registers_i.mhpmcounter_we_t0),
.u_ibex_core__cs_registers_i__mhpmcounterh_we(
  u_ibex_core.cs_registers_i.mhpmcounterh_we),
.u_ibex_core__cs_registers_i__mhpmcounterh_we_t0(
  u_ibex_core.cs_registers_i.mhpmcounterh_we_t0),
.u_ibex_core__cs_registers_i__mie_en(
  u_ibex_core.cs_registers_i.mie_en),
.u_ibex_core__cs_registers_i__mie_en_t0(
  u_ibex_core.cs_registers_i.mie_en_t0),
.u_ibex_core__cs_registers_i__mie_q(
  u_ibex_core.cs_registers_i.mie_q),
.u_ibex_core__cs_registers_i__mie_q_t0(
  u_ibex_core.cs_registers_i.mie_q_t0),
.u_ibex_core__cs_registers_i__minstret_next(
  u_ibex_core.cs_registers_i.minstret_next),
.u_ibex_core__cs_registers_i__minstret_next_t0(
  u_ibex_core.cs_registers_i.minstret_next_t0),
.u_ibex_core__cs_registers_i__minstret_raw(
  u_ibex_core.cs_registers_i.minstret_raw),
.u_ibex_core__cs_registers_i__minstret_raw_t0(
  u_ibex_core.cs_registers_i.minstret_raw_t0),
.u_ibex_core__cs_registers_i__mscratch_en(
  u_ibex_core.cs_registers_i.mscratch_en),
.u_ibex_core__cs_registers_i__mscratch_en_t0(
  u_ibex_core.cs_registers_i.mscratch_en_t0),
.u_ibex_core__cs_registers_i__mscratch_q(
  u_ibex_core.cs_registers_i.mscratch_q),
.u_ibex_core__cs_registers_i__mscratch_q_t0(
  u_ibex_core.cs_registers_i.mscratch_q_t0),
.u_ibex_core__cs_registers_i__mstack_cause_q(
  u_ibex_core.cs_registers_i.mstack_cause_q),
.u_ibex_core__cs_registers_i__mstack_cause_q_t0(
  u_ibex_core.cs_registers_i.mstack_cause_q_t0),
.u_ibex_core__cs_registers_i__mstack_en(
  u_ibex_core.cs_registers_i.mstack_en),
.u_ibex_core__cs_registers_i__mstack_en_t0(
  u_ibex_core.cs_registers_i.mstack_en_t0),
.u_ibex_core__cs_registers_i__mstack_epc_q(
  u_ibex_core.cs_registers_i.mstack_epc_q),
.u_ibex_core__cs_registers_i__mstack_epc_q_t0(
  u_ibex_core.cs_registers_i.mstack_epc_q_t0),
.u_ibex_core__cs_registers_i__mstack_q(
  u_ibex_core.cs_registers_i.mstack_q),
.u_ibex_core__cs_registers_i__mstack_q_t0(
  u_ibex_core.cs_registers_i.mstack_q_t0),
.u_ibex_core__cs_registers_i__mstatus_d(
  u_ibex_core.cs_registers_i.mstatus_d),
.u_ibex_core__cs_registers_i__mstatus_d_t0(
  u_ibex_core.cs_registers_i.mstatus_d_t0),
.u_ibex_core__cs_registers_i__mstatus_en(
  u_ibex_core.cs_registers_i.mstatus_en),
.u_ibex_core__cs_registers_i__mstatus_en_t0(
  u_ibex_core.cs_registers_i.mstatus_en_t0),
.u_ibex_core__cs_registers_i__mstatus_err(
  u_ibex_core.cs_registers_i.mstatus_err),
.u_ibex_core__cs_registers_i__mstatus_err_t0(
  u_ibex_core.cs_registers_i.mstatus_err_t0),
.u_ibex_core__cs_registers_i__mstatus_q(
  u_ibex_core.cs_registers_i.mstatus_q),
.u_ibex_core__cs_registers_i__mstatus_q_t0(
  u_ibex_core.cs_registers_i.mstatus_q_t0),
.u_ibex_core__cs_registers_i__mtval_d(
  u_ibex_core.cs_registers_i.mtval_d),
.u_ibex_core__cs_registers_i__mtval_d_t0(
  u_ibex_core.cs_registers_i.mtval_d_t0),
.u_ibex_core__cs_registers_i__mtval_en(
  u_ibex_core.cs_registers_i.mtval_en),
.u_ibex_core__cs_registers_i__mtval_en_t0(
  u_ibex_core.cs_registers_i.mtval_en_t0),
.u_ibex_core__cs_registers_i__mtvec_d(
  u_ibex_core.cs_registers_i.mtvec_d),
.u_ibex_core__cs_registers_i__mtvec_d_t0(
  u_ibex_core.cs_registers_i.mtvec_d_t0),
.u_ibex_core__cs_registers_i__mtvec_en(
  u_ibex_core.cs_registers_i.mtvec_en),
.u_ibex_core__cs_registers_i__mtvec_en_t0(
  u_ibex_core.cs_registers_i.mtvec_en_t0),
.u_ibex_core__cs_registers_i__mtvec_err(
  u_ibex_core.cs_registers_i.mtvec_err),
.u_ibex_core__cs_registers_i__mtvec_err_t0(
  u_ibex_core.cs_registers_i.mtvec_err_t0),
.u_ibex_core__cs_registers_i__priv_lvl_d(
  u_ibex_core.cs_registers_i.priv_lvl_d),
.u_ibex_core__cs_registers_i__priv_lvl_d_t0(
  u_ibex_core.cs_registers_i.priv_lvl_d_t0),
.u_ibex_core__cs_registers_i__mcycle_counter_i__clk_i(
  u_ibex_core.cs_registers_i.mcycle_counter_i.clk_i),
.u_ibex_core__cs_registers_i__mcycle_counter_i__rst_ni(
  u_ibex_core.cs_registers_i.mcycle_counter_i.rst_ni),
.u_ibex_core__cs_registers_i__mcycle_counter_i__counter_inc_i(
  u_ibex_core.cs_registers_i.mcycle_counter_i.counter_inc_i),
.u_ibex_core__cs_registers_i__mcycle_counter_i__counterh_we_i(
  u_ibex_core.cs_registers_i.mcycle_counter_i.counterh_we_i),
.u_ibex_core__cs_registers_i__mcycle_counter_i__counter_we_i(
  u_ibex_core.cs_registers_i.mcycle_counter_i.counter_we_i),
.u_ibex_core__cs_registers_i__mcycle_counter_i__counter_val_i(
  u_ibex_core.cs_registers_i.mcycle_counter_i.counter_val_i),
.u_ibex_core__cs_registers_i__mcycle_counter_i__counter_val_o(
  u_ibex_core.cs_registers_i.mcycle_counter_i.counter_val_o),
.u_ibex_core__cs_registers_i__mcycle_counter_i__counter_val_upd_o(
  u_ibex_core.cs_registers_i.mcycle_counter_i.counter_val_upd_o),
.u_ibex_core__cs_registers_i__mcycle_counter_i__counter_inc_i_t0(
  u_ibex_core.cs_registers_i.mcycle_counter_i.counter_inc_i_t0),
.u_ibex_core__cs_registers_i__mcycle_counter_i__counter_val_i_t0(
  u_ibex_core.cs_registers_i.mcycle_counter_i.counter_val_i_t0),
.u_ibex_core__cs_registers_i__mcycle_counter_i__counter_val_o_t0(
  u_ibex_core.cs_registers_i.mcycle_counter_i.counter_val_o_t0),
.u_ibex_core__cs_registers_i__mcycle_counter_i__counter_val_upd_o_t0(
  u_ibex_core.cs_registers_i.mcycle_counter_i.counter_val_upd_o_t0),
.u_ibex_core__cs_registers_i__mcycle_counter_i__counter_we_i_t0(
  u_ibex_core.cs_registers_i.mcycle_counter_i.counter_we_i_t0),
.u_ibex_core__cs_registers_i__mcycle_counter_i__counterh_we_i_t0(
  u_ibex_core.cs_registers_i.mcycle_counter_i.counterh_we_i_t0),
.u_ibex_core__cs_registers_i__mcycle_counter_i__counter_d(
  u_ibex_core.cs_registers_i.mcycle_counter_i.counter_d),
.u_ibex_core__cs_registers_i__mcycle_counter_i__counter_d_t0(
  u_ibex_core.cs_registers_i.mcycle_counter_i.counter_d_t0),
.u_ibex_core__cs_registers_i__mcycle_counter_i__counter_load(
  u_ibex_core.cs_registers_i.mcycle_counter_i.counter_load),
.u_ibex_core__cs_registers_i__mcycle_counter_i__counter_load_t0(
  u_ibex_core.cs_registers_i.mcycle_counter_i.counter_load_t0),
.u_ibex_core__cs_registers_i__mcycle_counter_i__counter_upd(
  u_ibex_core.cs_registers_i.mcycle_counter_i.counter_upd),
.u_ibex_core__cs_registers_i__mcycle_counter_i__counter_upd_t0(
  u_ibex_core.cs_registers_i.mcycle_counter_i.counter_upd_t0),
.u_ibex_core__cs_registers_i__mcycle_counter_i__we(
  u_ibex_core.cs_registers_i.mcycle_counter_i.we),
.u_ibex_core__cs_registers_i__mcycle_counter_i__we_t0(
  u_ibex_core.cs_registers_i.mcycle_counter_i.we_t0),
.u_ibex_core__cs_registers_i__minstret_counter_i__clk_i(
  u_ibex_core.cs_registers_i.minstret_counter_i.clk_i),
.u_ibex_core__cs_registers_i__minstret_counter_i__rst_ni(
  u_ibex_core.cs_registers_i.minstret_counter_i.rst_ni),
.u_ibex_core__cs_registers_i__minstret_counter_i__counter_inc_i(
  u_ibex_core.cs_registers_i.minstret_counter_i.counter_inc_i),
.u_ibex_core__cs_registers_i__minstret_counter_i__counterh_we_i(
  u_ibex_core.cs_registers_i.minstret_counter_i.counterh_we_i),
.u_ibex_core__cs_registers_i__minstret_counter_i__counter_we_i(
  u_ibex_core.cs_registers_i.minstret_counter_i.counter_we_i),
.u_ibex_core__cs_registers_i__minstret_counter_i__counter_val_i(
  u_ibex_core.cs_registers_i.minstret_counter_i.counter_val_i),
.u_ibex_core__cs_registers_i__minstret_counter_i__counter_val_o(
  u_ibex_core.cs_registers_i.minstret_counter_i.counter_val_o),
.u_ibex_core__cs_registers_i__minstret_counter_i__counter_val_upd_o(
  u_ibex_core.cs_registers_i.minstret_counter_i.counter_val_upd_o),
.u_ibex_core__cs_registers_i__minstret_counter_i__counter_inc_i_t0(
  u_ibex_core.cs_registers_i.minstret_counter_i.counter_inc_i_t0),
.u_ibex_core__cs_registers_i__minstret_counter_i__counter_val_i_t0(
  u_ibex_core.cs_registers_i.minstret_counter_i.counter_val_i_t0),
.u_ibex_core__cs_registers_i__minstret_counter_i__counter_val_o_t0(
  u_ibex_core.cs_registers_i.minstret_counter_i.counter_val_o_t0),
.u_ibex_core__cs_registers_i__minstret_counter_i__counter_val_upd_o_t0(
  u_ibex_core.cs_registers_i.minstret_counter_i.counter_val_upd_o_t0),
.u_ibex_core__cs_registers_i__minstret_counter_i__counter_we_i_t0(
  u_ibex_core.cs_registers_i.minstret_counter_i.counter_we_i_t0),
.u_ibex_core__cs_registers_i__minstret_counter_i__counterh_we_i_t0(
  u_ibex_core.cs_registers_i.minstret_counter_i.counterh_we_i_t0),
.u_ibex_core__cs_registers_i__minstret_counter_i__counter_d(
  u_ibex_core.cs_registers_i.minstret_counter_i.counter_d),
.u_ibex_core__cs_registers_i__minstret_counter_i__counter_d_t0(
  u_ibex_core.cs_registers_i.minstret_counter_i.counter_d_t0),
.u_ibex_core__cs_registers_i__minstret_counter_i__counter_load(
  u_ibex_core.cs_registers_i.minstret_counter_i.counter_load),
.u_ibex_core__cs_registers_i__minstret_counter_i__counter_load_t0(
  u_ibex_core.cs_registers_i.minstret_counter_i.counter_load_t0),
.u_ibex_core__cs_registers_i__minstret_counter_i__we(
  u_ibex_core.cs_registers_i.minstret_counter_i.we),
.u_ibex_core__cs_registers_i__minstret_counter_i__we_t0(
  u_ibex_core.cs_registers_i.minstret_counter_i.we_t0),
.u_ibex_core__cs_registers_i__u_cpuctrlsts_part_csr__clk_i(
  u_ibex_core.cs_registers_i.u_cpuctrlsts_part_csr.clk_i),
.u_ibex_core__cs_registers_i__u_cpuctrlsts_part_csr__rst_ni(
  u_ibex_core.cs_registers_i.u_cpuctrlsts_part_csr.rst_ni),
.u_ibex_core__cs_registers_i__u_cpuctrlsts_part_csr__wr_data_i(
  u_ibex_core.cs_registers_i.u_cpuctrlsts_part_csr.wr_data_i),
.u_ibex_core__cs_registers_i__u_cpuctrlsts_part_csr__wr_en_i(
  u_ibex_core.cs_registers_i.u_cpuctrlsts_part_csr.wr_en_i),
.u_ibex_core__cs_registers_i__u_cpuctrlsts_part_csr__rd_data_o(
  u_ibex_core.cs_registers_i.u_cpuctrlsts_part_csr.rd_data_o),
.u_ibex_core__cs_registers_i__u_cpuctrlsts_part_csr__rd_error_o(
  u_ibex_core.cs_registers_i.u_cpuctrlsts_part_csr.rd_error_o),
.u_ibex_core__cs_registers_i__u_cpuctrlsts_part_csr__rd_data_o_t0(
  u_ibex_core.cs_registers_i.u_cpuctrlsts_part_csr.rd_data_o_t0),
.u_ibex_core__cs_registers_i__u_cpuctrlsts_part_csr__rd_error_o_t0(
  u_ibex_core.cs_registers_i.u_cpuctrlsts_part_csr.rd_error_o_t0),
.u_ibex_core__cs_registers_i__u_cpuctrlsts_part_csr__wr_data_i_t0(
  u_ibex_core.cs_registers_i.u_cpuctrlsts_part_csr.wr_data_i_t0),
.u_ibex_core__cs_registers_i__u_cpuctrlsts_part_csr__wr_en_i_t0(
  u_ibex_core.cs_registers_i.u_cpuctrlsts_part_csr.wr_en_i_t0),
.u_ibex_core__cs_registers_i__u_dcsr_csr__clk_i(
  u_ibex_core.cs_registers_i.u_dcsr_csr.clk_i),
.u_ibex_core__cs_registers_i__u_dcsr_csr__rst_ni(
  u_ibex_core.cs_registers_i.u_dcsr_csr.rst_ni),
.u_ibex_core__cs_registers_i__u_dcsr_csr__wr_data_i(
  u_ibex_core.cs_registers_i.u_dcsr_csr.wr_data_i),
.u_ibex_core__cs_registers_i__u_dcsr_csr__wr_en_i(
  u_ibex_core.cs_registers_i.u_dcsr_csr.wr_en_i),
.u_ibex_core__cs_registers_i__u_dcsr_csr__rd_data_o(
  u_ibex_core.cs_registers_i.u_dcsr_csr.rd_data_o),
.u_ibex_core__cs_registers_i__u_dcsr_csr__rd_error_o(
  u_ibex_core.cs_registers_i.u_dcsr_csr.rd_error_o),
.u_ibex_core__cs_registers_i__u_dcsr_csr__rd_data_o_t0(
  u_ibex_core.cs_registers_i.u_dcsr_csr.rd_data_o_t0),
.u_ibex_core__cs_registers_i__u_dcsr_csr__rd_error_o_t0(
  u_ibex_core.cs_registers_i.u_dcsr_csr.rd_error_o_t0),
.u_ibex_core__cs_registers_i__u_dcsr_csr__wr_data_i_t0(
  u_ibex_core.cs_registers_i.u_dcsr_csr.wr_data_i_t0),
.u_ibex_core__cs_registers_i__u_dcsr_csr__wr_en_i_t0(
  u_ibex_core.cs_registers_i.u_dcsr_csr.wr_en_i_t0),
.u_ibex_core__cs_registers_i__u_depc_csr__clk_i(
  u_ibex_core.cs_registers_i.u_depc_csr.clk_i),
.u_ibex_core__cs_registers_i__u_depc_csr__rst_ni(
  u_ibex_core.cs_registers_i.u_depc_csr.rst_ni),
.u_ibex_core__cs_registers_i__u_depc_csr__wr_data_i(
  u_ibex_core.cs_registers_i.u_depc_csr.wr_data_i),
.u_ibex_core__cs_registers_i__u_depc_csr__wr_en_i(
  u_ibex_core.cs_registers_i.u_depc_csr.wr_en_i),
.u_ibex_core__cs_registers_i__u_depc_csr__rd_data_o(
  u_ibex_core.cs_registers_i.u_depc_csr.rd_data_o),
.u_ibex_core__cs_registers_i__u_depc_csr__rd_error_o(
  u_ibex_core.cs_registers_i.u_depc_csr.rd_error_o),
.u_ibex_core__cs_registers_i__u_depc_csr__rd_data_o_t0(
  u_ibex_core.cs_registers_i.u_depc_csr.rd_data_o_t0),
.u_ibex_core__cs_registers_i__u_depc_csr__rd_error_o_t0(
  u_ibex_core.cs_registers_i.u_depc_csr.rd_error_o_t0),
.u_ibex_core__cs_registers_i__u_depc_csr__wr_data_i_t0(
  u_ibex_core.cs_registers_i.u_depc_csr.wr_data_i_t0),
.u_ibex_core__cs_registers_i__u_depc_csr__wr_en_i_t0(
  u_ibex_core.cs_registers_i.u_depc_csr.wr_en_i_t0),
.u_ibex_core__cs_registers_i__u_dscratch0_csr__clk_i(
  u_ibex_core.cs_registers_i.u_dscratch0_csr.clk_i),
.u_ibex_core__cs_registers_i__u_dscratch0_csr__rst_ni(
  u_ibex_core.cs_registers_i.u_dscratch0_csr.rst_ni),
.u_ibex_core__cs_registers_i__u_dscratch0_csr__wr_data_i(
  u_ibex_core.cs_registers_i.u_dscratch0_csr.wr_data_i),
.u_ibex_core__cs_registers_i__u_dscratch0_csr__wr_en_i(
  u_ibex_core.cs_registers_i.u_dscratch0_csr.wr_en_i),
.u_ibex_core__cs_registers_i__u_dscratch0_csr__rd_data_o(
  u_ibex_core.cs_registers_i.u_dscratch0_csr.rd_data_o),
.u_ibex_core__cs_registers_i__u_dscratch0_csr__rd_error_o(
  u_ibex_core.cs_registers_i.u_dscratch0_csr.rd_error_o),
.u_ibex_core__cs_registers_i__u_dscratch0_csr__rd_data_o_t0(
  u_ibex_core.cs_registers_i.u_dscratch0_csr.rd_data_o_t0),
.u_ibex_core__cs_registers_i__u_dscratch0_csr__rd_error_o_t0(
  u_ibex_core.cs_registers_i.u_dscratch0_csr.rd_error_o_t0),
.u_ibex_core__cs_registers_i__u_dscratch0_csr__wr_data_i_t0(
  u_ibex_core.cs_registers_i.u_dscratch0_csr.wr_data_i_t0),
.u_ibex_core__cs_registers_i__u_dscratch0_csr__wr_en_i_t0(
  u_ibex_core.cs_registers_i.u_dscratch0_csr.wr_en_i_t0),
.u_ibex_core__cs_registers_i__u_dscratch1_csr__clk_i(
  u_ibex_core.cs_registers_i.u_dscratch1_csr.clk_i),
.u_ibex_core__cs_registers_i__u_dscratch1_csr__rst_ni(
  u_ibex_core.cs_registers_i.u_dscratch1_csr.rst_ni),
.u_ibex_core__cs_registers_i__u_dscratch1_csr__wr_data_i(
  u_ibex_core.cs_registers_i.u_dscratch1_csr.wr_data_i),
.u_ibex_core__cs_registers_i__u_dscratch1_csr__wr_en_i(
  u_ibex_core.cs_registers_i.u_dscratch1_csr.wr_en_i),
.u_ibex_core__cs_registers_i__u_dscratch1_csr__rd_data_o(
  u_ibex_core.cs_registers_i.u_dscratch1_csr.rd_data_o),
.u_ibex_core__cs_registers_i__u_dscratch1_csr__rd_error_o(
  u_ibex_core.cs_registers_i.u_dscratch1_csr.rd_error_o),
.u_ibex_core__cs_registers_i__u_dscratch1_csr__rd_data_o_t0(
  u_ibex_core.cs_registers_i.u_dscratch1_csr.rd_data_o_t0),
.u_ibex_core__cs_registers_i__u_dscratch1_csr__rd_error_o_t0(
  u_ibex_core.cs_registers_i.u_dscratch1_csr.rd_error_o_t0),
.u_ibex_core__cs_registers_i__u_dscratch1_csr__wr_data_i_t0(
  u_ibex_core.cs_registers_i.u_dscratch1_csr.wr_data_i_t0),
.u_ibex_core__cs_registers_i__u_dscratch1_csr__wr_en_i_t0(
  u_ibex_core.cs_registers_i.u_dscratch1_csr.wr_en_i_t0),
.u_ibex_core__cs_registers_i__u_mcause_csr__clk_i(
  u_ibex_core.cs_registers_i.u_mcause_csr.clk_i),
.u_ibex_core__cs_registers_i__u_mcause_csr__rst_ni(
  u_ibex_core.cs_registers_i.u_mcause_csr.rst_ni),
.u_ibex_core__cs_registers_i__u_mcause_csr__wr_data_i(
  u_ibex_core.cs_registers_i.u_mcause_csr.wr_data_i),
.u_ibex_core__cs_registers_i__u_mcause_csr__wr_en_i(
  u_ibex_core.cs_registers_i.u_mcause_csr.wr_en_i),
.u_ibex_core__cs_registers_i__u_mcause_csr__rd_data_o(
  u_ibex_core.cs_registers_i.u_mcause_csr.rd_data_o),
.u_ibex_core__cs_registers_i__u_mcause_csr__rd_error_o(
  u_ibex_core.cs_registers_i.u_mcause_csr.rd_error_o),
.u_ibex_core__cs_registers_i__u_mcause_csr__rd_data_o_t0(
  u_ibex_core.cs_registers_i.u_mcause_csr.rd_data_o_t0),
.u_ibex_core__cs_registers_i__u_mcause_csr__rd_error_o_t0(
  u_ibex_core.cs_registers_i.u_mcause_csr.rd_error_o_t0),
.u_ibex_core__cs_registers_i__u_mcause_csr__wr_data_i_t0(
  u_ibex_core.cs_registers_i.u_mcause_csr.wr_data_i_t0),
.u_ibex_core__cs_registers_i__u_mcause_csr__wr_en_i_t0(
  u_ibex_core.cs_registers_i.u_mcause_csr.wr_en_i_t0),
.u_ibex_core__cs_registers_i__u_mepc_csr__clk_i(
  u_ibex_core.cs_registers_i.u_mepc_csr.clk_i),
.u_ibex_core__cs_registers_i__u_mepc_csr__rst_ni(
  u_ibex_core.cs_registers_i.u_mepc_csr.rst_ni),
.u_ibex_core__cs_registers_i__u_mepc_csr__wr_data_i(
  u_ibex_core.cs_registers_i.u_mepc_csr.wr_data_i),
.u_ibex_core__cs_registers_i__u_mepc_csr__wr_en_i(
  u_ibex_core.cs_registers_i.u_mepc_csr.wr_en_i),
.u_ibex_core__cs_registers_i__u_mepc_csr__rd_data_o(
  u_ibex_core.cs_registers_i.u_mepc_csr.rd_data_o),
.u_ibex_core__cs_registers_i__u_mepc_csr__rd_error_o(
  u_ibex_core.cs_registers_i.u_mepc_csr.rd_error_o),
.u_ibex_core__cs_registers_i__u_mepc_csr__rd_data_o_t0(
  u_ibex_core.cs_registers_i.u_mepc_csr.rd_data_o_t0),
.u_ibex_core__cs_registers_i__u_mepc_csr__rd_error_o_t0(
  u_ibex_core.cs_registers_i.u_mepc_csr.rd_error_o_t0),
.u_ibex_core__cs_registers_i__u_mepc_csr__wr_data_i_t0(
  u_ibex_core.cs_registers_i.u_mepc_csr.wr_data_i_t0),
.u_ibex_core__cs_registers_i__u_mepc_csr__wr_en_i_t0(
  u_ibex_core.cs_registers_i.u_mepc_csr.wr_en_i_t0),
.u_ibex_core__cs_registers_i__u_mie_csr__clk_i(
  u_ibex_core.cs_registers_i.u_mie_csr.clk_i),
.u_ibex_core__cs_registers_i__u_mie_csr__rst_ni(
  u_ibex_core.cs_registers_i.u_mie_csr.rst_ni),
.u_ibex_core__cs_registers_i__u_mie_csr__wr_data_i(
  u_ibex_core.cs_registers_i.u_mie_csr.wr_data_i),
.u_ibex_core__cs_registers_i__u_mie_csr__wr_en_i(
  u_ibex_core.cs_registers_i.u_mie_csr.wr_en_i),
.u_ibex_core__cs_registers_i__u_mie_csr__rd_data_o(
  u_ibex_core.cs_registers_i.u_mie_csr.rd_data_o),
.u_ibex_core__cs_registers_i__u_mie_csr__rd_error_o(
  u_ibex_core.cs_registers_i.u_mie_csr.rd_error_o),
.u_ibex_core__cs_registers_i__u_mie_csr__rd_data_o_t0(
  u_ibex_core.cs_registers_i.u_mie_csr.rd_data_o_t0),
.u_ibex_core__cs_registers_i__u_mie_csr__rd_error_o_t0(
  u_ibex_core.cs_registers_i.u_mie_csr.rd_error_o_t0),
.u_ibex_core__cs_registers_i__u_mie_csr__wr_data_i_t0(
  u_ibex_core.cs_registers_i.u_mie_csr.wr_data_i_t0),
.u_ibex_core__cs_registers_i__u_mie_csr__wr_en_i_t0(
  u_ibex_core.cs_registers_i.u_mie_csr.wr_en_i_t0),
.u_ibex_core__cs_registers_i__u_mscratch_csr__clk_i(
  u_ibex_core.cs_registers_i.u_mscratch_csr.clk_i),
.u_ibex_core__cs_registers_i__u_mscratch_csr__rst_ni(
  u_ibex_core.cs_registers_i.u_mscratch_csr.rst_ni),
.u_ibex_core__cs_registers_i__u_mscratch_csr__wr_data_i(
  u_ibex_core.cs_registers_i.u_mscratch_csr.wr_data_i),
.u_ibex_core__cs_registers_i__u_mscratch_csr__wr_en_i(
  u_ibex_core.cs_registers_i.u_mscratch_csr.wr_en_i),
.u_ibex_core__cs_registers_i__u_mscratch_csr__rd_data_o(
  u_ibex_core.cs_registers_i.u_mscratch_csr.rd_data_o),
.u_ibex_core__cs_registers_i__u_mscratch_csr__rd_error_o(
  u_ibex_core.cs_registers_i.u_mscratch_csr.rd_error_o),
.u_ibex_core__cs_registers_i__u_mscratch_csr__rd_data_o_t0(
  u_ibex_core.cs_registers_i.u_mscratch_csr.rd_data_o_t0),
.u_ibex_core__cs_registers_i__u_mscratch_csr__rd_error_o_t0(
  u_ibex_core.cs_registers_i.u_mscratch_csr.rd_error_o_t0),
.u_ibex_core__cs_registers_i__u_mscratch_csr__wr_data_i_t0(
  u_ibex_core.cs_registers_i.u_mscratch_csr.wr_data_i_t0),
.u_ibex_core__cs_registers_i__u_mscratch_csr__wr_en_i_t0(
  u_ibex_core.cs_registers_i.u_mscratch_csr.wr_en_i_t0),
.u_ibex_core__cs_registers_i__u_mstack_cause_csr__clk_i(
  u_ibex_core.cs_registers_i.u_mstack_cause_csr.clk_i),
.u_ibex_core__cs_registers_i__u_mstack_cause_csr__rst_ni(
  u_ibex_core.cs_registers_i.u_mstack_cause_csr.rst_ni),
.u_ibex_core__cs_registers_i__u_mstack_cause_csr__wr_data_i(
  u_ibex_core.cs_registers_i.u_mstack_cause_csr.wr_data_i),
.u_ibex_core__cs_registers_i__u_mstack_cause_csr__wr_en_i(
  u_ibex_core.cs_registers_i.u_mstack_cause_csr.wr_en_i),
.u_ibex_core__cs_registers_i__u_mstack_cause_csr__rd_data_o(
  u_ibex_core.cs_registers_i.u_mstack_cause_csr.rd_data_o),
.u_ibex_core__cs_registers_i__u_mstack_cause_csr__rd_error_o(
  u_ibex_core.cs_registers_i.u_mstack_cause_csr.rd_error_o),
.u_ibex_core__cs_registers_i__u_mstack_cause_csr__rd_data_o_t0(
  u_ibex_core.cs_registers_i.u_mstack_cause_csr.rd_data_o_t0),
.u_ibex_core__cs_registers_i__u_mstack_cause_csr__rd_error_o_t0(
  u_ibex_core.cs_registers_i.u_mstack_cause_csr.rd_error_o_t0),
.u_ibex_core__cs_registers_i__u_mstack_cause_csr__wr_data_i_t0(
  u_ibex_core.cs_registers_i.u_mstack_cause_csr.wr_data_i_t0),
.u_ibex_core__cs_registers_i__u_mstack_cause_csr__wr_en_i_t0(
  u_ibex_core.cs_registers_i.u_mstack_cause_csr.wr_en_i_t0),
.u_ibex_core__cs_registers_i__u_mstack_csr__clk_i(
  u_ibex_core.cs_registers_i.u_mstack_csr.clk_i),
.u_ibex_core__cs_registers_i__u_mstack_csr__rst_ni(
  u_ibex_core.cs_registers_i.u_mstack_csr.rst_ni),
.u_ibex_core__cs_registers_i__u_mstack_csr__wr_data_i(
  u_ibex_core.cs_registers_i.u_mstack_csr.wr_data_i),
.u_ibex_core__cs_registers_i__u_mstack_csr__wr_en_i(
  u_ibex_core.cs_registers_i.u_mstack_csr.wr_en_i),
.u_ibex_core__cs_registers_i__u_mstack_csr__rd_data_o(
  u_ibex_core.cs_registers_i.u_mstack_csr.rd_data_o),
.u_ibex_core__cs_registers_i__u_mstack_csr__rd_error_o(
  u_ibex_core.cs_registers_i.u_mstack_csr.rd_error_o),
.u_ibex_core__cs_registers_i__u_mstack_csr__rd_data_o_t0(
  u_ibex_core.cs_registers_i.u_mstack_csr.rd_data_o_t0),
.u_ibex_core__cs_registers_i__u_mstack_csr__rd_error_o_t0(
  u_ibex_core.cs_registers_i.u_mstack_csr.rd_error_o_t0),
.u_ibex_core__cs_registers_i__u_mstack_csr__wr_data_i_t0(
  u_ibex_core.cs_registers_i.u_mstack_csr.wr_data_i_t0),
.u_ibex_core__cs_registers_i__u_mstack_csr__wr_en_i_t0(
  u_ibex_core.cs_registers_i.u_mstack_csr.wr_en_i_t0),
.u_ibex_core__cs_registers_i__u_mstack_epc_csr__clk_i(
  u_ibex_core.cs_registers_i.u_mstack_epc_csr.clk_i),
.u_ibex_core__cs_registers_i__u_mstack_epc_csr__rst_ni(
  u_ibex_core.cs_registers_i.u_mstack_epc_csr.rst_ni),
.u_ibex_core__cs_registers_i__u_mstack_epc_csr__wr_data_i(
  u_ibex_core.cs_registers_i.u_mstack_epc_csr.wr_data_i),
.u_ibex_core__cs_registers_i__u_mstack_epc_csr__wr_en_i(
  u_ibex_core.cs_registers_i.u_mstack_epc_csr.wr_en_i),
.u_ibex_core__cs_registers_i__u_mstack_epc_csr__rd_data_o(
  u_ibex_core.cs_registers_i.u_mstack_epc_csr.rd_data_o),
.u_ibex_core__cs_registers_i__u_mstack_epc_csr__rd_error_o(
  u_ibex_core.cs_registers_i.u_mstack_epc_csr.rd_error_o),
.u_ibex_core__cs_registers_i__u_mstack_epc_csr__rd_data_o_t0(
  u_ibex_core.cs_registers_i.u_mstack_epc_csr.rd_data_o_t0),
.u_ibex_core__cs_registers_i__u_mstack_epc_csr__rd_error_o_t0(
  u_ibex_core.cs_registers_i.u_mstack_epc_csr.rd_error_o_t0),
.u_ibex_core__cs_registers_i__u_mstack_epc_csr__wr_data_i_t0(
  u_ibex_core.cs_registers_i.u_mstack_epc_csr.wr_data_i_t0),
.u_ibex_core__cs_registers_i__u_mstack_epc_csr__wr_en_i_t0(
  u_ibex_core.cs_registers_i.u_mstack_epc_csr.wr_en_i_t0),
.u_ibex_core__cs_registers_i__u_mstatus_csr__clk_i(
  u_ibex_core.cs_registers_i.u_mstatus_csr.clk_i),
.u_ibex_core__cs_registers_i__u_mstatus_csr__rst_ni(
  u_ibex_core.cs_registers_i.u_mstatus_csr.rst_ni),
.u_ibex_core__cs_registers_i__u_mstatus_csr__wr_data_i(
  u_ibex_core.cs_registers_i.u_mstatus_csr.wr_data_i),
.u_ibex_core__cs_registers_i__u_mstatus_csr__wr_en_i(
  u_ibex_core.cs_registers_i.u_mstatus_csr.wr_en_i),
.u_ibex_core__cs_registers_i__u_mstatus_csr__rd_data_o(
  u_ibex_core.cs_registers_i.u_mstatus_csr.rd_data_o),
.u_ibex_core__cs_registers_i__u_mstatus_csr__rd_error_o(
  u_ibex_core.cs_registers_i.u_mstatus_csr.rd_error_o),
.u_ibex_core__cs_registers_i__u_mstatus_csr__rd_data_o_t0(
  u_ibex_core.cs_registers_i.u_mstatus_csr.rd_data_o_t0),
.u_ibex_core__cs_registers_i__u_mstatus_csr__rd_error_o_t0(
  u_ibex_core.cs_registers_i.u_mstatus_csr.rd_error_o_t0),
.u_ibex_core__cs_registers_i__u_mstatus_csr__wr_data_i_t0(
  u_ibex_core.cs_registers_i.u_mstatus_csr.wr_data_i_t0),
.u_ibex_core__cs_registers_i__u_mstatus_csr__wr_en_i_t0(
  u_ibex_core.cs_registers_i.u_mstatus_csr.wr_en_i_t0),
.u_ibex_core__cs_registers_i__u_mtval_csr__clk_i(
  u_ibex_core.cs_registers_i.u_mtval_csr.clk_i),
.u_ibex_core__cs_registers_i__u_mtval_csr__rst_ni(
  u_ibex_core.cs_registers_i.u_mtval_csr.rst_ni),
.u_ibex_core__cs_registers_i__u_mtval_csr__wr_data_i(
  u_ibex_core.cs_registers_i.u_mtval_csr.wr_data_i),
.u_ibex_core__cs_registers_i__u_mtval_csr__wr_en_i(
  u_ibex_core.cs_registers_i.u_mtval_csr.wr_en_i),
.u_ibex_core__cs_registers_i__u_mtval_csr__rd_data_o(
  u_ibex_core.cs_registers_i.u_mtval_csr.rd_data_o),
.u_ibex_core__cs_registers_i__u_mtval_csr__rd_error_o(
  u_ibex_core.cs_registers_i.u_mtval_csr.rd_error_o),
.u_ibex_core__cs_registers_i__u_mtval_csr__rd_data_o_t0(
  u_ibex_core.cs_registers_i.u_mtval_csr.rd_data_o_t0),
.u_ibex_core__cs_registers_i__u_mtval_csr__rd_error_o_t0(
  u_ibex_core.cs_registers_i.u_mtval_csr.rd_error_o_t0),
.u_ibex_core__cs_registers_i__u_mtval_csr__wr_data_i_t0(
  u_ibex_core.cs_registers_i.u_mtval_csr.wr_data_i_t0),
.u_ibex_core__cs_registers_i__u_mtval_csr__wr_en_i_t0(
  u_ibex_core.cs_registers_i.u_mtval_csr.wr_en_i_t0),
.u_ibex_core__cs_registers_i__u_mtvec_csr__clk_i(
  u_ibex_core.cs_registers_i.u_mtvec_csr.clk_i),
.u_ibex_core__cs_registers_i__u_mtvec_csr__rst_ni(
  u_ibex_core.cs_registers_i.u_mtvec_csr.rst_ni),
.u_ibex_core__cs_registers_i__u_mtvec_csr__wr_data_i(
  u_ibex_core.cs_registers_i.u_mtvec_csr.wr_data_i),
.u_ibex_core__cs_registers_i__u_mtvec_csr__wr_en_i(
  u_ibex_core.cs_registers_i.u_mtvec_csr.wr_en_i),
.u_ibex_core__cs_registers_i__u_mtvec_csr__rd_data_o(
  u_ibex_core.cs_registers_i.u_mtvec_csr.rd_data_o),
.u_ibex_core__cs_registers_i__u_mtvec_csr__rd_error_o(
  u_ibex_core.cs_registers_i.u_mtvec_csr.rd_error_o),
.u_ibex_core__cs_registers_i__u_mtvec_csr__rd_data_o_t0(
  u_ibex_core.cs_registers_i.u_mtvec_csr.rd_data_o_t0),
.u_ibex_core__cs_registers_i__u_mtvec_csr__rd_error_o_t0(
  u_ibex_core.cs_registers_i.u_mtvec_csr.rd_error_o_t0),
.u_ibex_core__cs_registers_i__u_mtvec_csr__wr_data_i_t0(
  u_ibex_core.cs_registers_i.u_mtvec_csr.wr_data_i_t0),
.u_ibex_core__cs_registers_i__u_mtvec_csr__wr_en_i_t0(
  u_ibex_core.cs_registers_i.u_mtvec_csr.wr_en_i_t0),
.u_ibex_core__ex_block_i__clk_i(
  u_ibex_core.ex_block_i.clk_i),
.u_ibex_core__ex_block_i__rst_ni(
  u_ibex_core.ex_block_i.rst_ni),
.u_ibex_core__ex_block_i__alu_operator_i(
  u_ibex_core.ex_block_i.alu_operator_i),
.u_ibex_core__ex_block_i__alu_operand_a_i(
  u_ibex_core.ex_block_i.alu_operand_a_i),
.u_ibex_core__ex_block_i__alu_operand_b_i(
  u_ibex_core.ex_block_i.alu_operand_b_i),
.u_ibex_core__ex_block_i__alu_instr_first_cycle_i(
  u_ibex_core.ex_block_i.alu_instr_first_cycle_i),
.u_ibex_core__ex_block_i__bt_a_operand_i(
  u_ibex_core.ex_block_i.bt_a_operand_i),
.u_ibex_core__ex_block_i__bt_b_operand_i(
  u_ibex_core.ex_block_i.bt_b_operand_i),
.u_ibex_core__ex_block_i__multdiv_operator_i(
  u_ibex_core.ex_block_i.multdiv_operator_i),
.u_ibex_core__ex_block_i__mult_en_i(
  u_ibex_core.ex_block_i.mult_en_i),
.u_ibex_core__ex_block_i__div_en_i(
  u_ibex_core.ex_block_i.div_en_i),
.u_ibex_core__ex_block_i__mult_sel_i(
  u_ibex_core.ex_block_i.mult_sel_i),
.u_ibex_core__ex_block_i__div_sel_i(
  u_ibex_core.ex_block_i.div_sel_i),
.u_ibex_core__ex_block_i__multdiv_signed_mode_i(
  u_ibex_core.ex_block_i.multdiv_signed_mode_i),
.u_ibex_core__ex_block_i__multdiv_operand_a_i(
  u_ibex_core.ex_block_i.multdiv_operand_a_i),
.u_ibex_core__ex_block_i__multdiv_operand_b_i(
  u_ibex_core.ex_block_i.multdiv_operand_b_i),
.u_ibex_core__ex_block_i__multdiv_ready_id_i(
  u_ibex_core.ex_block_i.multdiv_ready_id_i),
.u_ibex_core__ex_block_i__data_ind_timing_i(
  u_ibex_core.ex_block_i.data_ind_timing_i),
.u_ibex_core__ex_block_i__imd_val_we_o(
  u_ibex_core.ex_block_i.imd_val_we_o),
.u_ibex_core__ex_block_i__imd_val_d_o(
  u_ibex_core.ex_block_i.imd_val_d_o),
.u_ibex_core__ex_block_i__imd_val_q_i(
  u_ibex_core.ex_block_i.imd_val_q_i),
.u_ibex_core__ex_block_i__alu_adder_result_ex_o(
  u_ibex_core.ex_block_i.alu_adder_result_ex_o),
.u_ibex_core__ex_block_i__result_ex_o(
  u_ibex_core.ex_block_i.result_ex_o),
.u_ibex_core__ex_block_i__branch_target_o(
  u_ibex_core.ex_block_i.branch_target_o),
.u_ibex_core__ex_block_i__branch_decision_o(
  u_ibex_core.ex_block_i.branch_decision_o),
.u_ibex_core__ex_block_i__ex_valid_o(
  u_ibex_core.ex_block_i.ex_valid_o),
.u_ibex_core__ex_block_i__data_ind_timing_i_t0(
  u_ibex_core.ex_block_i.data_ind_timing_i_t0),
.u_ibex_core__ex_block_i__div_en_i_t0(
  u_ibex_core.ex_block_i.div_en_i_t0),
.u_ibex_core__ex_block_i__div_sel_i_t0(
  u_ibex_core.ex_block_i.div_sel_i_t0),
.u_ibex_core__ex_block_i__imd_val_d_o_t0(
  u_ibex_core.ex_block_i.imd_val_d_o_t0),
.u_ibex_core__ex_block_i__imd_val_q_i_t0(
  u_ibex_core.ex_block_i.imd_val_q_i_t0),
.u_ibex_core__ex_block_i__imd_val_we_o_t0(
  u_ibex_core.ex_block_i.imd_val_we_o_t0),
.u_ibex_core__ex_block_i__mult_en_i_t0(
  u_ibex_core.ex_block_i.mult_en_i_t0),
.u_ibex_core__ex_block_i__mult_sel_i_t0(
  u_ibex_core.ex_block_i.mult_sel_i_t0),
.u_ibex_core__ex_block_i__multdiv_ready_id_i_t0(
  u_ibex_core.ex_block_i.multdiv_ready_id_i_t0),
.u_ibex_core__ex_block_i__multdiv_operand_a_i_t0(
  u_ibex_core.ex_block_i.multdiv_operand_a_i_t0),
.u_ibex_core__ex_block_i__multdiv_operand_b_i_t0(
  u_ibex_core.ex_block_i.multdiv_operand_b_i_t0),
.u_ibex_core__ex_block_i__alu_adder_result_ex_o_t0(
  u_ibex_core.ex_block_i.alu_adder_result_ex_o_t0),
.u_ibex_core__ex_block_i__alu_instr_first_cycle_i_t0(
  u_ibex_core.ex_block_i.alu_instr_first_cycle_i_t0),
.u_ibex_core__ex_block_i__alu_operand_a_i_t0(
  u_ibex_core.ex_block_i.alu_operand_a_i_t0),
.u_ibex_core__ex_block_i__alu_operand_b_i_t0(
  u_ibex_core.ex_block_i.alu_operand_b_i_t0),
.u_ibex_core__ex_block_i__alu_operator_i_t0(
  u_ibex_core.ex_block_i.alu_operator_i_t0),
.u_ibex_core__ex_block_i__branch_decision_o_t0(
  u_ibex_core.ex_block_i.branch_decision_o_t0),
.u_ibex_core__ex_block_i__branch_target_o_t0(
  u_ibex_core.ex_block_i.branch_target_o_t0),
.u_ibex_core__ex_block_i__bt_a_operand_i_t0(
  u_ibex_core.ex_block_i.bt_a_operand_i_t0),
.u_ibex_core__ex_block_i__bt_b_operand_i_t0(
  u_ibex_core.ex_block_i.bt_b_operand_i_t0),
.u_ibex_core__ex_block_i__ex_valid_o_t0(
  u_ibex_core.ex_block_i.ex_valid_o_t0),
.u_ibex_core__ex_block_i__multdiv_operator_i_t0(
  u_ibex_core.ex_block_i.multdiv_operator_i_t0),
.u_ibex_core__ex_block_i__multdiv_signed_mode_i_t0(
  u_ibex_core.ex_block_i.multdiv_signed_mode_i_t0),
.u_ibex_core__ex_block_i__result_ex_o_t0(
  u_ibex_core.ex_block_i.result_ex_o_t0),
.u_ibex_core__ex_block_i__alu_adder_result_ext(
  u_ibex_core.ex_block_i.alu_adder_result_ext),
.u_ibex_core__ex_block_i__alu_adder_result_ext_t0(
  u_ibex_core.ex_block_i.alu_adder_result_ext_t0),
.u_ibex_core__ex_block_i__alu_imd_val_d(
  u_ibex_core.ex_block_i.alu_imd_val_d),
.u_ibex_core__ex_block_i__alu_imd_val_d_t0(
  u_ibex_core.ex_block_i.alu_imd_val_d_t0),
.u_ibex_core__ex_block_i__alu_imd_val_we(
  u_ibex_core.ex_block_i.alu_imd_val_we),
.u_ibex_core__ex_block_i__alu_imd_val_we_t0(
  u_ibex_core.ex_block_i.alu_imd_val_we_t0),
.u_ibex_core__ex_block_i__alu_is_equal_result(
  u_ibex_core.ex_block_i.alu_is_equal_result),
.u_ibex_core__ex_block_i__alu_is_equal_result_t0(
  u_ibex_core.ex_block_i.alu_is_equal_result_t0),
.u_ibex_core__ex_block_i__alu_result(
  u_ibex_core.ex_block_i.alu_result),
.u_ibex_core__ex_block_i__alu_result_t0(
  u_ibex_core.ex_block_i.alu_result_t0),
.u_ibex_core__ex_block_i__multdiv_alu_operand_a(
  u_ibex_core.ex_block_i.multdiv_alu_operand_a),
.u_ibex_core__ex_block_i__multdiv_alu_operand_a_t0(
  u_ibex_core.ex_block_i.multdiv_alu_operand_a_t0),
.u_ibex_core__ex_block_i__multdiv_alu_operand_b(
  u_ibex_core.ex_block_i.multdiv_alu_operand_b),
.u_ibex_core__ex_block_i__multdiv_alu_operand_b_t0(
  u_ibex_core.ex_block_i.multdiv_alu_operand_b_t0),
.u_ibex_core__ex_block_i__multdiv_imd_val_d(
  u_ibex_core.ex_block_i.multdiv_imd_val_d),
.u_ibex_core__ex_block_i__multdiv_imd_val_d_t0(
  u_ibex_core.ex_block_i.multdiv_imd_val_d_t0),
.u_ibex_core__ex_block_i__multdiv_imd_val_we(
  u_ibex_core.ex_block_i.multdiv_imd_val_we),
.u_ibex_core__ex_block_i__multdiv_imd_val_we_t0(
  u_ibex_core.ex_block_i.multdiv_imd_val_we_t0),
.u_ibex_core__ex_block_i__multdiv_result(
  u_ibex_core.ex_block_i.multdiv_result),
.u_ibex_core__ex_block_i__multdiv_result_t0(
  u_ibex_core.ex_block_i.multdiv_result_t0),
.u_ibex_core__ex_block_i__multdiv_sel(
  u_ibex_core.ex_block_i.multdiv_sel),
.u_ibex_core__ex_block_i__multdiv_sel_t0(
  u_ibex_core.ex_block_i.multdiv_sel_t0),
.u_ibex_core__ex_block_i__multdiv_valid(
  u_ibex_core.ex_block_i.multdiv_valid),
.u_ibex_core__ex_block_i__multdiv_valid_t0(
  u_ibex_core.ex_block_i.multdiv_valid_t0),
.u_ibex_core__ex_block_i__alu_i__operator_i(
  u_ibex_core.ex_block_i.alu_i.operator_i),
.u_ibex_core__ex_block_i__alu_i__operand_a_i(
  u_ibex_core.ex_block_i.alu_i.operand_a_i),
.u_ibex_core__ex_block_i__alu_i__operand_b_i(
  u_ibex_core.ex_block_i.alu_i.operand_b_i),
.u_ibex_core__ex_block_i__alu_i__instr_first_cycle_i(
  u_ibex_core.ex_block_i.alu_i.instr_first_cycle_i),
.u_ibex_core__ex_block_i__alu_i__multdiv_operand_a_i(
  u_ibex_core.ex_block_i.alu_i.multdiv_operand_a_i),
.u_ibex_core__ex_block_i__alu_i__multdiv_operand_b_i(
  u_ibex_core.ex_block_i.alu_i.multdiv_operand_b_i),
.u_ibex_core__ex_block_i__alu_i__multdiv_sel_i(
  u_ibex_core.ex_block_i.alu_i.multdiv_sel_i),
.u_ibex_core__ex_block_i__alu_i__imd_val_q_i(
  u_ibex_core.ex_block_i.alu_i.imd_val_q_i),
.u_ibex_core__ex_block_i__alu_i__imd_val_d_o(
  u_ibex_core.ex_block_i.alu_i.imd_val_d_o),
.u_ibex_core__ex_block_i__alu_i__imd_val_we_o(
  u_ibex_core.ex_block_i.alu_i.imd_val_we_o),
.u_ibex_core__ex_block_i__alu_i__adder_result_o(
  u_ibex_core.ex_block_i.alu_i.adder_result_o),
.u_ibex_core__ex_block_i__alu_i__adder_result_ext_o(
  u_ibex_core.ex_block_i.alu_i.adder_result_ext_o),
.u_ibex_core__ex_block_i__alu_i__result_o(
  u_ibex_core.ex_block_i.alu_i.result_o),
.u_ibex_core__ex_block_i__alu_i__comparison_result_o(
  u_ibex_core.ex_block_i.alu_i.comparison_result_o),
.u_ibex_core__ex_block_i__alu_i__is_equal_result_o(
  u_ibex_core.ex_block_i.alu_i.is_equal_result_o),
.u_ibex_core__ex_block_i__alu_i__instr_first_cycle_i_t0(
  u_ibex_core.ex_block_i.alu_i.instr_first_cycle_i_t0),
.u_ibex_core__ex_block_i__alu_i__imd_val_d_o_t0(
  u_ibex_core.ex_block_i.alu_i.imd_val_d_o_t0),
.u_ibex_core__ex_block_i__alu_i__imd_val_q_i_t0(
  u_ibex_core.ex_block_i.alu_i.imd_val_q_i_t0),
.u_ibex_core__ex_block_i__alu_i__imd_val_we_o_t0(
  u_ibex_core.ex_block_i.alu_i.imd_val_we_o_t0),
.u_ibex_core__ex_block_i__alu_i__operator_i_t0(
  u_ibex_core.ex_block_i.alu_i.operator_i_t0),
.u_ibex_core__ex_block_i__alu_i__adder_result_ext_o_t0(
  u_ibex_core.ex_block_i.alu_i.adder_result_ext_o_t0),
.u_ibex_core__ex_block_i__alu_i__adder_result_o_t0(
  u_ibex_core.ex_block_i.alu_i.adder_result_o_t0),
.u_ibex_core__ex_block_i__alu_i__comparison_result_o_t0(
  u_ibex_core.ex_block_i.alu_i.comparison_result_o_t0),
.u_ibex_core__ex_block_i__alu_i__is_equal_result_o_t0(
  u_ibex_core.ex_block_i.alu_i.is_equal_result_o_t0),
.u_ibex_core__ex_block_i__alu_i__multdiv_operand_a_i_t0(
  u_ibex_core.ex_block_i.alu_i.multdiv_operand_a_i_t0),
.u_ibex_core__ex_block_i__alu_i__multdiv_operand_b_i_t0(
  u_ibex_core.ex_block_i.alu_i.multdiv_operand_b_i_t0),
.u_ibex_core__ex_block_i__alu_i__multdiv_sel_i_t0(
  u_ibex_core.ex_block_i.alu_i.multdiv_sel_i_t0),
.u_ibex_core__ex_block_i__alu_i__operand_a_i_t0(
  u_ibex_core.ex_block_i.alu_i.operand_a_i_t0),
.u_ibex_core__ex_block_i__alu_i__operand_b_i_t0(
  u_ibex_core.ex_block_i.alu_i.operand_b_i_t0),
.u_ibex_core__ex_block_i__alu_i__result_o_t0(
  u_ibex_core.ex_block_i.alu_i.result_o_t0),
.u_ibex_core__ex_block_i__alu_i__adder_in_a(
  u_ibex_core.ex_block_i.alu_i.adder_in_a),
.u_ibex_core__ex_block_i__alu_i__adder_in_a_t0(
  u_ibex_core.ex_block_i.alu_i.adder_in_a_t0),
.u_ibex_core__ex_block_i__alu_i__adder_in_b(
  u_ibex_core.ex_block_i.alu_i.adder_in_b),
.u_ibex_core__ex_block_i__alu_i__adder_in_b_t0(
  u_ibex_core.ex_block_i.alu_i.adder_in_b_t0),
.u_ibex_core__ex_block_i__alu_i__adder_op_b_negate(
  u_ibex_core.ex_block_i.alu_i.adder_op_b_negate),
.u_ibex_core__ex_block_i__alu_i__adder_op_b_negate_t0(
  u_ibex_core.ex_block_i.alu_i.adder_op_b_negate_t0),
.u_ibex_core__ex_block_i__alu_i__bwlogic_and(
  u_ibex_core.ex_block_i.alu_i.bwlogic_and),
.u_ibex_core__ex_block_i__alu_i__bwlogic_and_result(
  u_ibex_core.ex_block_i.alu_i.bwlogic_and_result),
.u_ibex_core__ex_block_i__alu_i__bwlogic_and_result_t0(
  u_ibex_core.ex_block_i.alu_i.bwlogic_and_result_t0),
.u_ibex_core__ex_block_i__alu_i__bwlogic_and_t0(
  u_ibex_core.ex_block_i.alu_i.bwlogic_and_t0),
.u_ibex_core__ex_block_i__alu_i__bwlogic_or(
  u_ibex_core.ex_block_i.alu_i.bwlogic_or),
.u_ibex_core__ex_block_i__alu_i__bwlogic_or_result(
  u_ibex_core.ex_block_i.alu_i.bwlogic_or_result),
.u_ibex_core__ex_block_i__alu_i__bwlogic_or_result_t0(
  u_ibex_core.ex_block_i.alu_i.bwlogic_or_result_t0),
.u_ibex_core__ex_block_i__alu_i__bwlogic_or_t0(
  u_ibex_core.ex_block_i.alu_i.bwlogic_or_t0),
.u_ibex_core__ex_block_i__alu_i__bwlogic_result(
  u_ibex_core.ex_block_i.alu_i.bwlogic_result),
.u_ibex_core__ex_block_i__alu_i__bwlogic_result_t0(
  u_ibex_core.ex_block_i.alu_i.bwlogic_result_t0),
.u_ibex_core__ex_block_i__alu_i__bwlogic_xor_result(
  u_ibex_core.ex_block_i.alu_i.bwlogic_xor_result),
.u_ibex_core__ex_block_i__alu_i__bwlogic_xor_result_t0(
  u_ibex_core.ex_block_i.alu_i.bwlogic_xor_result_t0),
.u_ibex_core__ex_block_i__alu_i__cmp_signed(
  u_ibex_core.ex_block_i.alu_i.cmp_signed),
.u_ibex_core__ex_block_i__alu_i__cmp_signed_t0(
  u_ibex_core.ex_block_i.alu_i.cmp_signed_t0),
.u_ibex_core__ex_block_i__alu_i__is_greater_equal(
  u_ibex_core.ex_block_i.alu_i.is_greater_equal),
.u_ibex_core__ex_block_i__alu_i__is_greater_equal_t0(
  u_ibex_core.ex_block_i.alu_i.is_greater_equal_t0),
.u_ibex_core__ex_block_i__alu_i__operand_b_neg(
  u_ibex_core.ex_block_i.alu_i.operand_b_neg),
.u_ibex_core__ex_block_i__alu_i__shift_amt(
  u_ibex_core.ex_block_i.alu_i.shift_amt),
.u_ibex_core__ex_block_i__alu_i__shift_amt_compl(
  u_ibex_core.ex_block_i.alu_i.shift_amt_compl),
.u_ibex_core__ex_block_i__alu_i__shift_amt_compl_t0(
  u_ibex_core.ex_block_i.alu_i.shift_amt_compl_t0),
.u_ibex_core__ex_block_i__alu_i__shift_amt_t0(
  u_ibex_core.ex_block_i.alu_i.shift_amt_t0),
.u_ibex_core__ex_block_i__alu_i__shift_arith(
  u_ibex_core.ex_block_i.alu_i.shift_arith),
.u_ibex_core__ex_block_i__alu_i__shift_arith_t0(
  u_ibex_core.ex_block_i.alu_i.shift_arith_t0),
.u_ibex_core__ex_block_i__alu_i__shift_left(
  u_ibex_core.ex_block_i.alu_i.shift_left),
.u_ibex_core__ex_block_i__alu_i__shift_left_t0(
  u_ibex_core.ex_block_i.alu_i.shift_left_t0),
.u_ibex_core__ex_block_i__alu_i__shift_operand(
  u_ibex_core.ex_block_i.alu_i.shift_operand),
.u_ibex_core__ex_block_i__alu_i__shift_operand_t0(
  u_ibex_core.ex_block_i.alu_i.shift_operand_t0),
.u_ibex_core__ex_block_i__alu_i__shift_result(
  u_ibex_core.ex_block_i.alu_i.shift_result),
.u_ibex_core__ex_block_i__alu_i__shift_result_ext(
  u_ibex_core.ex_block_i.alu_i.shift_result_ext),
.u_ibex_core__ex_block_i__alu_i__shift_result_ext_t0(
  u_ibex_core.ex_block_i.alu_i.shift_result_ext_t0),
.u_ibex_core__ex_block_i__alu_i__shift_result_t0(
  u_ibex_core.ex_block_i.alu_i.shift_result_t0),
.u_ibex_core__ex_block_i__gen_multdiv_slow__multdiv_i__clk_i(
  u_ibex_core.ex_block_i.\gen_multdiv_slow.multdiv_i .clk_i),
.u_ibex_core__ex_block_i__gen_multdiv_slow__multdiv_i__rst_ni(
  u_ibex_core.ex_block_i.\gen_multdiv_slow.multdiv_i .rst_ni),
.u_ibex_core__ex_block_i__gen_multdiv_slow__multdiv_i__mult_en_i(
  u_ibex_core.ex_block_i.\gen_multdiv_slow.multdiv_i .mult_en_i),
.u_ibex_core__ex_block_i__gen_multdiv_slow__multdiv_i__div_en_i(
  u_ibex_core.ex_block_i.\gen_multdiv_slow.multdiv_i .div_en_i),
.u_ibex_core__ex_block_i__gen_multdiv_slow__multdiv_i__mult_sel_i(
  u_ibex_core.ex_block_i.\gen_multdiv_slow.multdiv_i .mult_sel_i),
.u_ibex_core__ex_block_i__gen_multdiv_slow__multdiv_i__div_sel_i(
  u_ibex_core.ex_block_i.\gen_multdiv_slow.multdiv_i .div_sel_i),
.u_ibex_core__ex_block_i__gen_multdiv_slow__multdiv_i__operator_i(
  u_ibex_core.ex_block_i.\gen_multdiv_slow.multdiv_i .operator_i),
.u_ibex_core__ex_block_i__gen_multdiv_slow__multdiv_i__signed_mode_i(
  u_ibex_core.ex_block_i.\gen_multdiv_slow.multdiv_i .signed_mode_i),
.u_ibex_core__ex_block_i__gen_multdiv_slow__multdiv_i__op_a_i(
  u_ibex_core.ex_block_i.\gen_multdiv_slow.multdiv_i .op_a_i),
.u_ibex_core__ex_block_i__gen_multdiv_slow__multdiv_i__op_b_i(
  u_ibex_core.ex_block_i.\gen_multdiv_slow.multdiv_i .op_b_i),
.u_ibex_core__ex_block_i__gen_multdiv_slow__multdiv_i__alu_adder_ext_i(
  u_ibex_core.ex_block_i.\gen_multdiv_slow.multdiv_i .alu_adder_ext_i),
.u_ibex_core__ex_block_i__gen_multdiv_slow__multdiv_i__alu_adder_i(
  u_ibex_core.ex_block_i.\gen_multdiv_slow.multdiv_i .alu_adder_i),
.u_ibex_core__ex_block_i__gen_multdiv_slow__multdiv_i__equal_to_zero_i(
  u_ibex_core.ex_block_i.\gen_multdiv_slow.multdiv_i .equal_to_zero_i),
.u_ibex_core__ex_block_i__gen_multdiv_slow__multdiv_i__data_ind_timing_i(
  u_ibex_core.ex_block_i.\gen_multdiv_slow.multdiv_i .data_ind_timing_i),
.u_ibex_core__ex_block_i__gen_multdiv_slow__multdiv_i__alu_operand_a_o(
  u_ibex_core.ex_block_i.\gen_multdiv_slow.multdiv_i .alu_operand_a_o),
.u_ibex_core__ex_block_i__gen_multdiv_slow__multdiv_i__alu_operand_b_o(
  u_ibex_core.ex_block_i.\gen_multdiv_slow.multdiv_i .alu_operand_b_o),
.u_ibex_core__ex_block_i__gen_multdiv_slow__multdiv_i__imd_val_q_i(
  u_ibex_core.ex_block_i.\gen_multdiv_slow.multdiv_i .imd_val_q_i),
.u_ibex_core__ex_block_i__gen_multdiv_slow__multdiv_i__imd_val_d_o(
  u_ibex_core.ex_block_i.\gen_multdiv_slow.multdiv_i .imd_val_d_o),
.u_ibex_core__ex_block_i__gen_multdiv_slow__multdiv_i__imd_val_we_o(
  u_ibex_core.ex_block_i.\gen_multdiv_slow.multdiv_i .imd_val_we_o),
.u_ibex_core__ex_block_i__gen_multdiv_slow__multdiv_i__multdiv_ready_id_i(
  u_ibex_core.ex_block_i.\gen_multdiv_slow.multdiv_i .multdiv_ready_id_i),
.u_ibex_core__ex_block_i__gen_multdiv_slow__multdiv_i__multdiv_result_o(
  u_ibex_core.ex_block_i.\gen_multdiv_slow.multdiv_i .multdiv_result_o),
.u_ibex_core__ex_block_i__gen_multdiv_slow__multdiv_i__valid_o(
  u_ibex_core.ex_block_i.\gen_multdiv_slow.multdiv_i .valid_o),
.u_ibex_core__ex_block_i__gen_multdiv_slow__multdiv_i__valid_o_t0(
  u_ibex_core.ex_block_i.\gen_multdiv_slow.multdiv_i .valid_o_t0),
.u_ibex_core__ex_block_i__gen_multdiv_slow__multdiv_i__data_ind_timing_i_t0(
  u_ibex_core.ex_block_i.\gen_multdiv_slow.multdiv_i .data_ind_timing_i_t0),
.u_ibex_core__ex_block_i__gen_multdiv_slow__multdiv_i__alu_adder_ext_i_t0(
  u_ibex_core.ex_block_i.\gen_multdiv_slow.multdiv_i .alu_adder_ext_i_t0),
.u_ibex_core__ex_block_i__gen_multdiv_slow__multdiv_i__alu_adder_i_t0(
  u_ibex_core.ex_block_i.\gen_multdiv_slow.multdiv_i .alu_adder_i_t0),
.u_ibex_core__ex_block_i__gen_multdiv_slow__multdiv_i__alu_operand_a_o_t0(
  u_ibex_core.ex_block_i.\gen_multdiv_slow.multdiv_i .alu_operand_a_o_t0),
.u_ibex_core__ex_block_i__gen_multdiv_slow__multdiv_i__alu_operand_b_o_t0(
  u_ibex_core.ex_block_i.\gen_multdiv_slow.multdiv_i .alu_operand_b_o_t0),
.u_ibex_core__ex_block_i__gen_multdiv_slow__multdiv_i__div_en_i_t0(
  u_ibex_core.ex_block_i.\gen_multdiv_slow.multdiv_i .div_en_i_t0),
.u_ibex_core__ex_block_i__gen_multdiv_slow__multdiv_i__div_sel_i_t0(
  u_ibex_core.ex_block_i.\gen_multdiv_slow.multdiv_i .div_sel_i_t0),
.u_ibex_core__ex_block_i__gen_multdiv_slow__multdiv_i__equal_to_zero_i_t0(
  u_ibex_core.ex_block_i.\gen_multdiv_slow.multdiv_i .equal_to_zero_i_t0),
.u_ibex_core__ex_block_i__gen_multdiv_slow__multdiv_i__imd_val_d_o_t0(
  u_ibex_core.ex_block_i.\gen_multdiv_slow.multdiv_i .imd_val_d_o_t0),
.u_ibex_core__ex_block_i__gen_multdiv_slow__multdiv_i__imd_val_q_i_t0(
  u_ibex_core.ex_block_i.\gen_multdiv_slow.multdiv_i .imd_val_q_i_t0),
.u_ibex_core__ex_block_i__gen_multdiv_slow__multdiv_i__imd_val_we_o_t0(
  u_ibex_core.ex_block_i.\gen_multdiv_slow.multdiv_i .imd_val_we_o_t0),
.u_ibex_core__ex_block_i__gen_multdiv_slow__multdiv_i__mult_en_i_t0(
  u_ibex_core.ex_block_i.\gen_multdiv_slow.multdiv_i .mult_en_i_t0),
.u_ibex_core__ex_block_i__gen_multdiv_slow__multdiv_i__mult_sel_i_t0(
  u_ibex_core.ex_block_i.\gen_multdiv_slow.multdiv_i .mult_sel_i_t0),
.u_ibex_core__ex_block_i__gen_multdiv_slow__multdiv_i__multdiv_ready_id_i_t0(
  u_ibex_core.ex_block_i.\gen_multdiv_slow.multdiv_i .multdiv_ready_id_i_t0),
.u_ibex_core__ex_block_i__gen_multdiv_slow__multdiv_i__multdiv_result_o_t0(
  u_ibex_core.ex_block_i.\gen_multdiv_slow.multdiv_i .multdiv_result_o_t0),
.u_ibex_core__ex_block_i__gen_multdiv_slow__multdiv_i__op_a_i_t0(
  u_ibex_core.ex_block_i.\gen_multdiv_slow.multdiv_i .op_a_i_t0),
.u_ibex_core__ex_block_i__gen_multdiv_slow__multdiv_i__op_b_i_t0(
  u_ibex_core.ex_block_i.\gen_multdiv_slow.multdiv_i .op_b_i_t0),
.u_ibex_core__ex_block_i__gen_multdiv_slow__multdiv_i__operator_i_t0(
  u_ibex_core.ex_block_i.\gen_multdiv_slow.multdiv_i .operator_i_t0),
.u_ibex_core__ex_block_i__gen_multdiv_slow__multdiv_i__signed_mode_i_t0(
  u_ibex_core.ex_block_i.\gen_multdiv_slow.multdiv_i .signed_mode_i_t0),
.u_ibex_core__ex_block_i__gen_multdiv_slow__multdiv_i__accum_window_d(
  u_ibex_core.ex_block_i.\gen_multdiv_slow.multdiv_i .accum_window_d),
.u_ibex_core__ex_block_i__gen_multdiv_slow__multdiv_i__accum_window_d_t0(
  u_ibex_core.ex_block_i.\gen_multdiv_slow.multdiv_i .accum_window_d_t0),
.u_ibex_core__ex_block_i__gen_multdiv_slow__multdiv_i__div_by_zero_q(
  u_ibex_core.ex_block_i.\gen_multdiv_slow.multdiv_i .div_by_zero_q),
.u_ibex_core__ex_block_i__gen_multdiv_slow__multdiv_i__div_by_zero_q_t0(
  u_ibex_core.ex_block_i.\gen_multdiv_slow.multdiv_i .div_by_zero_q_t0),
.u_ibex_core__ex_block_i__gen_multdiv_slow__multdiv_i__div_change_sign(
  u_ibex_core.ex_block_i.\gen_multdiv_slow.multdiv_i .div_change_sign),
.u_ibex_core__ex_block_i__gen_multdiv_slow__multdiv_i__div_change_sign_t0(
  u_ibex_core.ex_block_i.\gen_multdiv_slow.multdiv_i .div_change_sign_t0),
.u_ibex_core__ex_block_i__gen_multdiv_slow__multdiv_i__is_greater_equal(
  u_ibex_core.ex_block_i.\gen_multdiv_slow.multdiv_i .is_greater_equal),
.u_ibex_core__ex_block_i__gen_multdiv_slow__multdiv_i__is_greater_equal_t0(
  u_ibex_core.ex_block_i.\gen_multdiv_slow.multdiv_i .is_greater_equal_t0),
.u_ibex_core__ex_block_i__gen_multdiv_slow__multdiv_i__md_state_q(
  u_ibex_core.ex_block_i.\gen_multdiv_slow.multdiv_i .md_state_q),
.u_ibex_core__ex_block_i__gen_multdiv_slow__multdiv_i__md_state_q_t0(
  u_ibex_core.ex_block_i.\gen_multdiv_slow.multdiv_i .md_state_q_t0),
.u_ibex_core__ex_block_i__gen_multdiv_slow__multdiv_i__multdiv_count_q(
  u_ibex_core.ex_block_i.\gen_multdiv_slow.multdiv_i .multdiv_count_q),
.u_ibex_core__ex_block_i__gen_multdiv_slow__multdiv_i__multdiv_count_q_t0(
  u_ibex_core.ex_block_i.\gen_multdiv_slow.multdiv_i .multdiv_count_q_t0),
.u_ibex_core__ex_block_i__gen_multdiv_slow__multdiv_i__multdiv_en(
  u_ibex_core.ex_block_i.\gen_multdiv_slow.multdiv_i .multdiv_en),
.u_ibex_core__ex_block_i__gen_multdiv_slow__multdiv_i__multdiv_en_t0(
  u_ibex_core.ex_block_i.\gen_multdiv_slow.multdiv_i .multdiv_en_t0),
.u_ibex_core__ex_block_i__gen_multdiv_slow__multdiv_i__multdiv_hold(
  u_ibex_core.ex_block_i.\gen_multdiv_slow.multdiv_i .multdiv_hold),
.u_ibex_core__ex_block_i__gen_multdiv_slow__multdiv_i__multdiv_hold_t0(
  u_ibex_core.ex_block_i.\gen_multdiv_slow.multdiv_i .multdiv_hold_t0),
.u_ibex_core__ex_block_i__gen_multdiv_slow__multdiv_i__next_quotient(
  u_ibex_core.ex_block_i.\gen_multdiv_slow.multdiv_i .next_quotient),
.u_ibex_core__ex_block_i__gen_multdiv_slow__multdiv_i__next_quotient_t0(
  u_ibex_core.ex_block_i.\gen_multdiv_slow.multdiv_i .next_quotient_t0),
.u_ibex_core__ex_block_i__gen_multdiv_slow__multdiv_i__next_remainder(
  u_ibex_core.ex_block_i.\gen_multdiv_slow.multdiv_i .next_remainder),
.u_ibex_core__ex_block_i__gen_multdiv_slow__multdiv_i__next_remainder_t0(
  u_ibex_core.ex_block_i.\gen_multdiv_slow.multdiv_i .next_remainder_t0),
.u_ibex_core__ex_block_i__gen_multdiv_slow__multdiv_i__one_shift(
  u_ibex_core.ex_block_i.\gen_multdiv_slow.multdiv_i .one_shift),
.u_ibex_core__ex_block_i__gen_multdiv_slow__multdiv_i__one_shift_t0(
  u_ibex_core.ex_block_i.\gen_multdiv_slow.multdiv_i .one_shift_t0),
.u_ibex_core__ex_block_i__gen_multdiv_slow__multdiv_i__op_a_bw_last_pp(
  u_ibex_core.ex_block_i.\gen_multdiv_slow.multdiv_i .op_a_bw_last_pp),
.u_ibex_core__ex_block_i__gen_multdiv_slow__multdiv_i__op_a_bw_last_pp_t0(
  u_ibex_core.ex_block_i.\gen_multdiv_slow.multdiv_i .op_a_bw_last_pp_t0),
.u_ibex_core__ex_block_i__gen_multdiv_slow__multdiv_i__op_a_bw_pp(
  u_ibex_core.ex_block_i.\gen_multdiv_slow.multdiv_i .op_a_bw_pp),
.u_ibex_core__ex_block_i__gen_multdiv_slow__multdiv_i__op_a_shift_q(
  u_ibex_core.ex_block_i.\gen_multdiv_slow.multdiv_i .op_a_shift_q),
.u_ibex_core__ex_block_i__gen_multdiv_slow__multdiv_i__op_a_shift_q_t0(
  u_ibex_core.ex_block_i.\gen_multdiv_slow.multdiv_i .op_a_shift_q_t0),
.u_ibex_core__ex_block_i__gen_multdiv_slow__multdiv_i__op_b_shift_q(
  u_ibex_core.ex_block_i.\gen_multdiv_slow.multdiv_i .op_b_shift_q),
.u_ibex_core__ex_block_i__gen_multdiv_slow__multdiv_i__op_b_shift_q_t0(
  u_ibex_core.ex_block_i.\gen_multdiv_slow.multdiv_i .op_b_shift_q_t0),
.u_ibex_core__ex_block_i__gen_multdiv_slow__multdiv_i__op_numerator_d(
  u_ibex_core.ex_block_i.\gen_multdiv_slow.multdiv_i .op_numerator_d),
.u_ibex_core__ex_block_i__gen_multdiv_slow__multdiv_i__op_numerator_d_t0(
  u_ibex_core.ex_block_i.\gen_multdiv_slow.multdiv_i .op_numerator_d_t0),
.u_ibex_core__ex_block_i__gen_multdiv_slow__multdiv_i__rem_change_sign(
  u_ibex_core.ex_block_i.\gen_multdiv_slow.multdiv_i .rem_change_sign),
.u_ibex_core__ex_block_i__gen_multdiv_slow__multdiv_i__rem_change_sign_t0(
  u_ibex_core.ex_block_i.\gen_multdiv_slow.multdiv_i .rem_change_sign_t0),
.u_ibex_core__ex_block_i__gen_multdiv_slow__multdiv_i__sign_b(
  u_ibex_core.ex_block_i.\gen_multdiv_slow.multdiv_i .sign_b),
.u_ibex_core__ex_block_i__gen_multdiv_slow__multdiv_i__sign_b_t0(
  u_ibex_core.ex_block_i.\gen_multdiv_slow.multdiv_i .sign_b_t0),
.u_ibex_core__g_core_busy_secure__u_fetch_enable_buf__in_i(
  u_ibex_core.\g_core_busy_secure.u_fetch_enable_buf .in_i),
.u_ibex_core__g_core_busy_secure__u_fetch_enable_buf__out_o(
  u_ibex_core.\g_core_busy_secure.u_fetch_enable_buf .out_o),
.u_ibex_core__g_core_busy_secure__u_fetch_enable_buf__in_i_t0(
  u_ibex_core.\g_core_busy_secure.u_fetch_enable_buf .in_i_t0),
.u_ibex_core__g_core_busy_secure__u_fetch_enable_buf__out_o_t0(
  u_ibex_core.\g_core_busy_secure.u_fetch_enable_buf .out_o_t0),
.u_ibex_core__g_core_busy_secure__u_fetch_enable_buf__gen_generic__u_impl_generic__in_i(
  u_ibex_core.\g_core_busy_secure.u_fetch_enable_buf .\gen_generic.u_impl_generic .in_i),
.u_ibex_core__g_core_busy_secure__u_fetch_enable_buf__gen_generic__u_impl_generic__out_o(
  u_ibex_core.\g_core_busy_secure.u_fetch_enable_buf .\gen_generic.u_impl_generic .out_o),
.u_ibex_core__g_core_busy_secure__u_fetch_enable_buf__gen_generic__u_impl_generic__in_i_t0(
  u_ibex_core.\g_core_busy_secure.u_fetch_enable_buf .\gen_generic.u_impl_generic .in_i_t0),
.u_ibex_core__g_core_busy_secure__u_fetch_enable_buf__gen_generic__u_impl_generic__out_o_t0(
  u_ibex_core.\g_core_busy_secure.u_fetch_enable_buf .\gen_generic.u_impl_generic .out_o_t0),
.u_ibex_core__g_core_busy_secure__u_fetch_enable_buf__gen_generic__u_impl_generic__inv(
  u_ibex_core.\g_core_busy_secure.u_fetch_enable_buf .\gen_generic.u_impl_generic .inv),
.u_ibex_core__gen_regfile_ecc__regfile_ecc_dec_a__data_i(
  u_ibex_core.\gen_regfile_ecc.regfile_ecc_dec_a .data_i),
.u_ibex_core__gen_regfile_ecc__regfile_ecc_dec_a__data_o(
  u_ibex_core.\gen_regfile_ecc.regfile_ecc_dec_a .data_o),
.u_ibex_core__gen_regfile_ecc__regfile_ecc_dec_a__syndrome_o(
  u_ibex_core.\gen_regfile_ecc.regfile_ecc_dec_a .syndrome_o),
.u_ibex_core__gen_regfile_ecc__regfile_ecc_dec_a__err_o(
  u_ibex_core.\gen_regfile_ecc.regfile_ecc_dec_a .err_o),
.u_ibex_core__gen_regfile_ecc__regfile_ecc_dec_a__syndrome_o_t0(
  u_ibex_core.\gen_regfile_ecc.regfile_ecc_dec_a .syndrome_o_t0),
.u_ibex_core__gen_regfile_ecc__regfile_ecc_dec_a__err_o_t0(
  u_ibex_core.\gen_regfile_ecc.regfile_ecc_dec_a .err_o_t0),
.u_ibex_core__gen_regfile_ecc__regfile_ecc_dec_a__data_o_t0(
  u_ibex_core.\gen_regfile_ecc.regfile_ecc_dec_a .data_o_t0),
.u_ibex_core__gen_regfile_ecc__regfile_ecc_dec_a__data_i_t0(
  u_ibex_core.\gen_regfile_ecc.regfile_ecc_dec_a .data_i_t0),
.u_ibex_core__gen_regfile_ecc__regfile_ecc_dec_b__data_i(
  u_ibex_core.\gen_regfile_ecc.regfile_ecc_dec_b .data_i),
.u_ibex_core__gen_regfile_ecc__regfile_ecc_dec_b__data_o(
  u_ibex_core.\gen_regfile_ecc.regfile_ecc_dec_b .data_o),
.u_ibex_core__gen_regfile_ecc__regfile_ecc_dec_b__syndrome_o(
  u_ibex_core.\gen_regfile_ecc.regfile_ecc_dec_b .syndrome_o),
.u_ibex_core__gen_regfile_ecc__regfile_ecc_dec_b__err_o(
  u_ibex_core.\gen_regfile_ecc.regfile_ecc_dec_b .err_o),
.u_ibex_core__gen_regfile_ecc__regfile_ecc_dec_b__syndrome_o_t0(
  u_ibex_core.\gen_regfile_ecc.regfile_ecc_dec_b .syndrome_o_t0),
.u_ibex_core__gen_regfile_ecc__regfile_ecc_dec_b__err_o_t0(
  u_ibex_core.\gen_regfile_ecc.regfile_ecc_dec_b .err_o_t0),
.u_ibex_core__gen_regfile_ecc__regfile_ecc_dec_b__data_o_t0(
  u_ibex_core.\gen_regfile_ecc.regfile_ecc_dec_b .data_o_t0),
.u_ibex_core__gen_regfile_ecc__regfile_ecc_dec_b__data_i_t0(
  u_ibex_core.\gen_regfile_ecc.regfile_ecc_dec_b .data_i_t0),
.u_ibex_core__gen_regfile_ecc__regfile_ecc_enc__data_i(
  u_ibex_core.\gen_regfile_ecc.regfile_ecc_enc .data_i),
.u_ibex_core__gen_regfile_ecc__regfile_ecc_enc__data_o(
  u_ibex_core.\gen_regfile_ecc.regfile_ecc_enc .data_o),
.u_ibex_core__gen_regfile_ecc__regfile_ecc_enc__data_o_t0(
  u_ibex_core.\gen_regfile_ecc.regfile_ecc_enc .data_o_t0),
.u_ibex_core__gen_regfile_ecc__regfile_ecc_enc__data_i_t0(
  u_ibex_core.\gen_regfile_ecc.regfile_ecc_enc .data_i_t0),
.u_ibex_core__id_stage_i__clk_i(
  u_ibex_core.id_stage_i.clk_i),
.u_ibex_core__id_stage_i__rst_ni(
  u_ibex_core.id_stage_i.rst_ni),
.u_ibex_core__id_stage_i__ctrl_busy_o(
  u_ibex_core.id_stage_i.ctrl_busy_o),
.u_ibex_core__id_stage_i__illegal_insn_o(
  u_ibex_core.id_stage_i.illegal_insn_o),
.u_ibex_core__id_stage_i__instr_valid_i(
  u_ibex_core.id_stage_i.instr_valid_i),
.u_ibex_core__id_stage_i__instr_rdata_i(
  u_ibex_core.id_stage_i.instr_rdata_i),
.u_ibex_core__id_stage_i__instr_rdata_alu_i(
  u_ibex_core.id_stage_i.instr_rdata_alu_i),
.u_ibex_core__id_stage_i__instr_rdata_c_i(
  u_ibex_core.id_stage_i.instr_rdata_c_i),
.u_ibex_core__id_stage_i__instr_is_compressed_i(
  u_ibex_core.id_stage_i.instr_is_compressed_i),
.u_ibex_core__id_stage_i__instr_bp_taken_i(
  u_ibex_core.id_stage_i.instr_bp_taken_i),
.u_ibex_core__id_stage_i__instr_req_o(
  u_ibex_core.id_stage_i.instr_req_o),
.u_ibex_core__id_stage_i__instr_first_cycle_id_o(
  u_ibex_core.id_stage_i.instr_first_cycle_id_o),
.u_ibex_core__id_stage_i__instr_valid_clear_o(
  u_ibex_core.id_stage_i.instr_valid_clear_o),
.u_ibex_core__id_stage_i__id_in_ready_o(
  u_ibex_core.id_stage_i.id_in_ready_o),
.u_ibex_core__id_stage_i__instr_exec_i(
  u_ibex_core.id_stage_i.instr_exec_i),
.u_ibex_core__id_stage_i__icache_inval_o(
  u_ibex_core.id_stage_i.icache_inval_o),
.u_ibex_core__id_stage_i__branch_decision_i(
  u_ibex_core.id_stage_i.branch_decision_i),
.u_ibex_core__id_stage_i__pc_set_o(
  u_ibex_core.id_stage_i.pc_set_o),
.u_ibex_core__id_stage_i__pc_mux_o(
  u_ibex_core.id_stage_i.pc_mux_o),
.u_ibex_core__id_stage_i__nt_branch_mispredict_o(
  u_ibex_core.id_stage_i.nt_branch_mispredict_o),
.u_ibex_core__id_stage_i__nt_branch_addr_o(
  u_ibex_core.id_stage_i.nt_branch_addr_o),
.u_ibex_core__id_stage_i__exc_pc_mux_o(
  u_ibex_core.id_stage_i.exc_pc_mux_o),
.u_ibex_core__id_stage_i__exc_cause_o(
  u_ibex_core.id_stage_i.exc_cause_o),
.u_ibex_core__id_stage_i__illegal_c_insn_i(
  u_ibex_core.id_stage_i.illegal_c_insn_i),
.u_ibex_core__id_stage_i__instr_fetch_err_i(
  u_ibex_core.id_stage_i.instr_fetch_err_i),
.u_ibex_core__id_stage_i__instr_fetch_err_plus2_i(
  u_ibex_core.id_stage_i.instr_fetch_err_plus2_i),
.u_ibex_core__id_stage_i__pc_id_i(
  u_ibex_core.id_stage_i.pc_id_i),
.u_ibex_core__id_stage_i__ex_valid_i(
  u_ibex_core.id_stage_i.ex_valid_i),
.u_ibex_core__id_stage_i__lsu_resp_valid_i(
  u_ibex_core.id_stage_i.lsu_resp_valid_i),
.u_ibex_core__id_stage_i__alu_operator_ex_o(
  u_ibex_core.id_stage_i.alu_operator_ex_o),
.u_ibex_core__id_stage_i__alu_operand_a_ex_o(
  u_ibex_core.id_stage_i.alu_operand_a_ex_o),
.u_ibex_core__id_stage_i__alu_operand_b_ex_o(
  u_ibex_core.id_stage_i.alu_operand_b_ex_o),
.u_ibex_core__id_stage_i__imd_val_we_ex_i(
  u_ibex_core.id_stage_i.imd_val_we_ex_i),
.u_ibex_core__id_stage_i__imd_val_d_ex_i(
  u_ibex_core.id_stage_i.imd_val_d_ex_i),
.u_ibex_core__id_stage_i__imd_val_q_ex_o(
  u_ibex_core.id_stage_i.imd_val_q_ex_o),
.u_ibex_core__id_stage_i__bt_a_operand_o(
  u_ibex_core.id_stage_i.bt_a_operand_o),
.u_ibex_core__id_stage_i__bt_b_operand_o(
  u_ibex_core.id_stage_i.bt_b_operand_o),
.u_ibex_core__id_stage_i__mult_en_ex_o(
  u_ibex_core.id_stage_i.mult_en_ex_o),
.u_ibex_core__id_stage_i__div_en_ex_o(
  u_ibex_core.id_stage_i.div_en_ex_o),
.u_ibex_core__id_stage_i__mult_sel_ex_o(
  u_ibex_core.id_stage_i.mult_sel_ex_o),
.u_ibex_core__id_stage_i__div_sel_ex_o(
  u_ibex_core.id_stage_i.div_sel_ex_o),
.u_ibex_core__id_stage_i__multdiv_operator_ex_o(
  u_ibex_core.id_stage_i.multdiv_operator_ex_o),
.u_ibex_core__id_stage_i__multdiv_signed_mode_ex_o(
  u_ibex_core.id_stage_i.multdiv_signed_mode_ex_o),
.u_ibex_core__id_stage_i__multdiv_operand_a_ex_o(
  u_ibex_core.id_stage_i.multdiv_operand_a_ex_o),
.u_ibex_core__id_stage_i__multdiv_operand_b_ex_o(
  u_ibex_core.id_stage_i.multdiv_operand_b_ex_o),
.u_ibex_core__id_stage_i__multdiv_ready_id_o(
  u_ibex_core.id_stage_i.multdiv_ready_id_o),
.u_ibex_core__id_stage_i__csr_access_o(
  u_ibex_core.id_stage_i.csr_access_o),
.u_ibex_core__id_stage_i__csr_op_o(
  u_ibex_core.id_stage_i.csr_op_o),
.u_ibex_core__id_stage_i__csr_op_en_o(
  u_ibex_core.id_stage_i.csr_op_en_o),
.u_ibex_core__id_stage_i__csr_save_if_o(
  u_ibex_core.id_stage_i.csr_save_if_o),
.u_ibex_core__id_stage_i__csr_save_id_o(
  u_ibex_core.id_stage_i.csr_save_id_o),
.u_ibex_core__id_stage_i__csr_save_wb_o(
  u_ibex_core.id_stage_i.csr_save_wb_o),
.u_ibex_core__id_stage_i__csr_restore_mret_id_o(
  u_ibex_core.id_stage_i.csr_restore_mret_id_o),
.u_ibex_core__id_stage_i__csr_restore_dret_id_o(
  u_ibex_core.id_stage_i.csr_restore_dret_id_o),
.u_ibex_core__id_stage_i__csr_save_cause_o(
  u_ibex_core.id_stage_i.csr_save_cause_o),
.u_ibex_core__id_stage_i__csr_mtval_o(
  u_ibex_core.id_stage_i.csr_mtval_o),
.u_ibex_core__id_stage_i__priv_mode_i(
  u_ibex_core.id_stage_i.priv_mode_i),
.u_ibex_core__id_stage_i__csr_mstatus_tw_i(
  u_ibex_core.id_stage_i.csr_mstatus_tw_i),
.u_ibex_core__id_stage_i__illegal_csr_insn_i(
  u_ibex_core.id_stage_i.illegal_csr_insn_i),
.u_ibex_core__id_stage_i__data_ind_timing_i(
  u_ibex_core.id_stage_i.data_ind_timing_i),
.u_ibex_core__id_stage_i__lsu_req_o(
  u_ibex_core.id_stage_i.lsu_req_o),
.u_ibex_core__id_stage_i__lsu_we_o(
  u_ibex_core.id_stage_i.lsu_we_o),
.u_ibex_core__id_stage_i__lsu_type_o(
  u_ibex_core.id_stage_i.lsu_type_o),
.u_ibex_core__id_stage_i__lsu_sign_ext_o(
  u_ibex_core.id_stage_i.lsu_sign_ext_o),
.u_ibex_core__id_stage_i__lsu_wdata_o(
  u_ibex_core.id_stage_i.lsu_wdata_o),
.u_ibex_core__id_stage_i__lsu_req_done_i(
  u_ibex_core.id_stage_i.lsu_req_done_i),
.u_ibex_core__id_stage_i__lsu_addr_incr_req_i(
  u_ibex_core.id_stage_i.lsu_addr_incr_req_i),
.u_ibex_core__id_stage_i__lsu_addr_last_i(
  u_ibex_core.id_stage_i.lsu_addr_last_i),
.u_ibex_core__id_stage_i__csr_mstatus_mie_i(
  u_ibex_core.id_stage_i.csr_mstatus_mie_i),
.u_ibex_core__id_stage_i__irq_pending_i(
  u_ibex_core.id_stage_i.irq_pending_i),
.u_ibex_core__id_stage_i__irqs_i(
  u_ibex_core.id_stage_i.irqs_i),
.u_ibex_core__id_stage_i__irq_nm_i(
  u_ibex_core.id_stage_i.irq_nm_i),
.u_ibex_core__id_stage_i__nmi_mode_o(
  u_ibex_core.id_stage_i.nmi_mode_o),
.u_ibex_core__id_stage_i__lsu_load_err_i(
  u_ibex_core.id_stage_i.lsu_load_err_i),
.u_ibex_core__id_stage_i__lsu_load_resp_intg_err_i(
  u_ibex_core.id_stage_i.lsu_load_resp_intg_err_i),
.u_ibex_core__id_stage_i__lsu_store_err_i(
  u_ibex_core.id_stage_i.lsu_store_err_i),
.u_ibex_core__id_stage_i__lsu_store_resp_intg_err_i(
  u_ibex_core.id_stage_i.lsu_store_resp_intg_err_i),
.u_ibex_core__id_stage_i__debug_mode_o(
  u_ibex_core.id_stage_i.debug_mode_o),
.u_ibex_core__id_stage_i__debug_mode_entering_o(
  u_ibex_core.id_stage_i.debug_mode_entering_o),
.u_ibex_core__id_stage_i__debug_cause_o(
  u_ibex_core.id_stage_i.debug_cause_o),
.u_ibex_core__id_stage_i__debug_csr_save_o(
  u_ibex_core.id_stage_i.debug_csr_save_o),
.u_ibex_core__id_stage_i__debug_req_i(
  u_ibex_core.id_stage_i.debug_req_i),
.u_ibex_core__id_stage_i__debug_single_step_i(
  u_ibex_core.id_stage_i.debug_single_step_i),
.u_ibex_core__id_stage_i__debug_ebreakm_i(
  u_ibex_core.id_stage_i.debug_ebreakm_i),
.u_ibex_core__id_stage_i__debug_ebreaku_i(
  u_ibex_core.id_stage_i.debug_ebreaku_i),
.u_ibex_core__id_stage_i__trigger_match_i(
  u_ibex_core.id_stage_i.trigger_match_i),
.u_ibex_core__id_stage_i__result_ex_i(
  u_ibex_core.id_stage_i.result_ex_i),
.u_ibex_core__id_stage_i__csr_rdata_i(
  u_ibex_core.id_stage_i.csr_rdata_i),
.u_ibex_core__id_stage_i__rf_raddr_a_o(
  u_ibex_core.id_stage_i.rf_raddr_a_o),
.u_ibex_core__id_stage_i__rf_rdata_a_i(
  u_ibex_core.id_stage_i.rf_rdata_a_i),
.u_ibex_core__id_stage_i__rf_raddr_b_o(
  u_ibex_core.id_stage_i.rf_raddr_b_o),
.u_ibex_core__id_stage_i__rf_rdata_b_i(
  u_ibex_core.id_stage_i.rf_rdata_b_i),
.u_ibex_core__id_stage_i__rf_ren_a_o(
  u_ibex_core.id_stage_i.rf_ren_a_o),
.u_ibex_core__id_stage_i__rf_ren_b_o(
  u_ibex_core.id_stage_i.rf_ren_b_o),
.u_ibex_core__id_stage_i__rf_waddr_id_o(
  u_ibex_core.id_stage_i.rf_waddr_id_o),
.u_ibex_core__id_stage_i__rf_wdata_id_o(
  u_ibex_core.id_stage_i.rf_wdata_id_o),
.u_ibex_core__id_stage_i__rf_we_id_o(
  u_ibex_core.id_stage_i.rf_we_id_o),
.u_ibex_core__id_stage_i__rf_rd_a_wb_match_o(
  u_ibex_core.id_stage_i.rf_rd_a_wb_match_o),
.u_ibex_core__id_stage_i__rf_rd_b_wb_match_o(
  u_ibex_core.id_stage_i.rf_rd_b_wb_match_o),
.u_ibex_core__id_stage_i__rf_waddr_wb_i(
  u_ibex_core.id_stage_i.rf_waddr_wb_i),
.u_ibex_core__id_stage_i__rf_wdata_fwd_wb_i(
  u_ibex_core.id_stage_i.rf_wdata_fwd_wb_i),
.u_ibex_core__id_stage_i__rf_write_wb_i(
  u_ibex_core.id_stage_i.rf_write_wb_i),
.u_ibex_core__id_stage_i__en_wb_o(
  u_ibex_core.id_stage_i.en_wb_o),
.u_ibex_core__id_stage_i__instr_type_wb_o(
  u_ibex_core.id_stage_i.instr_type_wb_o),
.u_ibex_core__id_stage_i__instr_perf_count_id_o(
  u_ibex_core.id_stage_i.instr_perf_count_id_o),
.u_ibex_core__id_stage_i__ready_wb_i(
  u_ibex_core.id_stage_i.ready_wb_i),
.u_ibex_core__id_stage_i__outstanding_load_wb_i(
  u_ibex_core.id_stage_i.outstanding_load_wb_i),
.u_ibex_core__id_stage_i__outstanding_store_wb_i(
  u_ibex_core.id_stage_i.outstanding_store_wb_i),
.u_ibex_core__id_stage_i__perf_jump_o(
  u_ibex_core.id_stage_i.perf_jump_o),
.u_ibex_core__id_stage_i__perf_branch_o(
  u_ibex_core.id_stage_i.perf_branch_o),
.u_ibex_core__id_stage_i__perf_tbranch_o(
  u_ibex_core.id_stage_i.perf_tbranch_o),
.u_ibex_core__id_stage_i__perf_dside_wait_o(
  u_ibex_core.id_stage_i.perf_dside_wait_o),
.u_ibex_core__id_stage_i__perf_mul_wait_o(
  u_ibex_core.id_stage_i.perf_mul_wait_o),
.u_ibex_core__id_stage_i__perf_div_wait_o(
  u_ibex_core.id_stage_i.perf_div_wait_o),
.u_ibex_core__id_stage_i__instr_id_done_o(
  u_ibex_core.id_stage_i.instr_id_done_o),
.u_ibex_core__id_stage_i__instr_req_o_t0(
  u_ibex_core.id_stage_i.instr_req_o_t0),
.u_ibex_core__id_stage_i__instr_rdata_i_t0(
  u_ibex_core.id_stage_i.instr_rdata_i_t0),
.u_ibex_core__id_stage_i__csr_access_o_t0(
  u_ibex_core.id_stage_i.csr_access_o_t0),
.u_ibex_core__id_stage_i__csr_op_o_t0(
  u_ibex_core.id_stage_i.csr_op_o_t0),
.u_ibex_core__id_stage_i__icache_inval_o_t0(
  u_ibex_core.id_stage_i.icache_inval_o_t0),
.u_ibex_core__id_stage_i__illegal_c_insn_i_t0(
  u_ibex_core.id_stage_i.illegal_c_insn_i_t0),
.u_ibex_core__id_stage_i__illegal_insn_o_t0(
  u_ibex_core.id_stage_i.illegal_insn_o_t0),
.u_ibex_core__id_stage_i__instr_rdata_alu_i_t0(
  u_ibex_core.id_stage_i.instr_rdata_alu_i_t0),
.u_ibex_core__id_stage_i__rf_raddr_a_o_t0(
  u_ibex_core.id_stage_i.rf_raddr_a_o_t0),
.u_ibex_core__id_stage_i__rf_raddr_b_o_t0(
  u_ibex_core.id_stage_i.rf_raddr_b_o_t0),
.u_ibex_core__id_stage_i__rf_ren_a_o_t0(
  u_ibex_core.id_stage_i.rf_ren_a_o_t0),
.u_ibex_core__id_stage_i__rf_ren_b_o_t0(
  u_ibex_core.id_stage_i.rf_ren_b_o_t0),
.u_ibex_core__id_stage_i__csr_mstatus_mie_i_t0(
  u_ibex_core.id_stage_i.csr_mstatus_mie_i_t0),
.u_ibex_core__id_stage_i__csr_mtval_o_t0(
  u_ibex_core.id_stage_i.csr_mtval_o_t0),
.u_ibex_core__id_stage_i__csr_restore_dret_id_o_t0(
  u_ibex_core.id_stage_i.csr_restore_dret_id_o_t0),
.u_ibex_core__id_stage_i__csr_restore_mret_id_o_t0(
  u_ibex_core.id_stage_i.csr_restore_mret_id_o_t0),
.u_ibex_core__id_stage_i__csr_save_cause_o_t0(
  u_ibex_core.id_stage_i.csr_save_cause_o_t0),
.u_ibex_core__id_stage_i__csr_save_id_o_t0(
  u_ibex_core.id_stage_i.csr_save_id_o_t0),
.u_ibex_core__id_stage_i__csr_save_if_o_t0(
  u_ibex_core.id_stage_i.csr_save_if_o_t0),
.u_ibex_core__id_stage_i__csr_save_wb_o_t0(
  u_ibex_core.id_stage_i.csr_save_wb_o_t0),
.u_ibex_core__id_stage_i__ctrl_busy_o_t0(
  u_ibex_core.id_stage_i.ctrl_busy_o_t0),
.u_ibex_core__id_stage_i__debug_cause_o_t0(
  u_ibex_core.id_stage_i.debug_cause_o_t0),
.u_ibex_core__id_stage_i__debug_csr_save_o_t0(
  u_ibex_core.id_stage_i.debug_csr_save_o_t0),
.u_ibex_core__id_stage_i__debug_ebreakm_i_t0(
  u_ibex_core.id_stage_i.debug_ebreakm_i_t0),
.u_ibex_core__id_stage_i__debug_ebreaku_i_t0(
  u_ibex_core.id_stage_i.debug_ebreaku_i_t0),
.u_ibex_core__id_stage_i__debug_mode_entering_o_t0(
  u_ibex_core.id_stage_i.debug_mode_entering_o_t0),
.u_ibex_core__id_stage_i__debug_mode_o_t0(
  u_ibex_core.id_stage_i.debug_mode_o_t0),
.u_ibex_core__id_stage_i__debug_req_i_t0(
  u_ibex_core.id_stage_i.debug_req_i_t0),
.u_ibex_core__id_stage_i__debug_single_step_i_t0(
  u_ibex_core.id_stage_i.debug_single_step_i_t0),
.u_ibex_core__id_stage_i__exc_cause_o_t0(
  u_ibex_core.id_stage_i.exc_cause_o_t0),
.u_ibex_core__id_stage_i__exc_pc_mux_o_t0(
  u_ibex_core.id_stage_i.exc_pc_mux_o_t0),
.u_ibex_core__id_stage_i__id_in_ready_o_t0(
  u_ibex_core.id_stage_i.id_in_ready_o_t0),
.u_ibex_core__id_stage_i__instr_bp_taken_i_t0(
  u_ibex_core.id_stage_i.instr_bp_taken_i_t0),
.u_ibex_core__id_stage_i__instr_exec_i_t0(
  u_ibex_core.id_stage_i.instr_exec_i_t0),
.u_ibex_core__id_stage_i__instr_fetch_err_i_t0(
  u_ibex_core.id_stage_i.instr_fetch_err_i_t0),
.u_ibex_core__id_stage_i__instr_fetch_err_plus2_i_t0(
  u_ibex_core.id_stage_i.instr_fetch_err_plus2_i_t0),
.u_ibex_core__id_stage_i__instr_is_compressed_i_t0(
  u_ibex_core.id_stage_i.instr_is_compressed_i_t0),
.u_ibex_core__id_stage_i__instr_valid_clear_o_t0(
  u_ibex_core.id_stage_i.instr_valid_clear_o_t0),
.u_ibex_core__id_stage_i__instr_valid_i_t0(
  u_ibex_core.id_stage_i.instr_valid_i_t0),
.u_ibex_core__id_stage_i__irq_pending_i_t0(
  u_ibex_core.id_stage_i.irq_pending_i_t0),
.u_ibex_core__id_stage_i__irqs_i_t0(
  u_ibex_core.id_stage_i.irqs_i_t0),
.u_ibex_core__id_stage_i__lsu_addr_last_i_t0(
  u_ibex_core.id_stage_i.lsu_addr_last_i_t0),
.u_ibex_core__id_stage_i__nmi_mode_o_t0(
  u_ibex_core.id_stage_i.nmi_mode_o_t0),
.u_ibex_core__id_stage_i__nt_branch_mispredict_o_t0(
  u_ibex_core.id_stage_i.nt_branch_mispredict_o_t0),
.u_ibex_core__id_stage_i__pc_id_i_t0(
  u_ibex_core.id_stage_i.pc_id_i_t0),
.u_ibex_core__id_stage_i__pc_mux_o_t0(
  u_ibex_core.id_stage_i.pc_mux_o_t0),
.u_ibex_core__id_stage_i__pc_set_o_t0(
  u_ibex_core.id_stage_i.pc_set_o_t0),
.u_ibex_core__id_stage_i__perf_jump_o_t0(
  u_ibex_core.id_stage_i.perf_jump_o_t0),
.u_ibex_core__id_stage_i__perf_tbranch_o_t0(
  u_ibex_core.id_stage_i.perf_tbranch_o_t0),
.u_ibex_core__id_stage_i__priv_mode_i_t0(
  u_ibex_core.id_stage_i.priv_mode_i_t0),
.u_ibex_core__id_stage_i__ready_wb_i_t0(
  u_ibex_core.id_stage_i.ready_wb_i_t0),
.u_ibex_core__id_stage_i__trigger_match_i_t0(
  u_ibex_core.id_stage_i.trigger_match_i_t0),
.u_ibex_core__id_stage_i__alu_operand_a_ex_o_t0(
  u_ibex_core.id_stage_i.alu_operand_a_ex_o_t0),
.u_ibex_core__id_stage_i__alu_operand_b_ex_o_t0(
  u_ibex_core.id_stage_i.alu_operand_b_ex_o_t0),
.u_ibex_core__id_stage_i__alu_operator_ex_o_t0(
  u_ibex_core.id_stage_i.alu_operator_ex_o_t0),
.u_ibex_core__id_stage_i__branch_decision_i_t0(
  u_ibex_core.id_stage_i.branch_decision_i_t0),
.u_ibex_core__id_stage_i__bt_a_operand_o_t0(
  u_ibex_core.id_stage_i.bt_a_operand_o_t0),
.u_ibex_core__id_stage_i__bt_b_operand_o_t0(
  u_ibex_core.id_stage_i.bt_b_operand_o_t0),
.u_ibex_core__id_stage_i__csr_mstatus_tw_i_t0(
  u_ibex_core.id_stage_i.csr_mstatus_tw_i_t0),
.u_ibex_core__id_stage_i__csr_op_en_o_t0(
  u_ibex_core.id_stage_i.csr_op_en_o_t0),
.u_ibex_core__id_stage_i__csr_rdata_i_t0(
  u_ibex_core.id_stage_i.csr_rdata_i_t0),
.u_ibex_core__id_stage_i__data_ind_timing_i_t0(
  u_ibex_core.id_stage_i.data_ind_timing_i_t0),
.u_ibex_core__id_stage_i__div_en_ex_o_t0(
  u_ibex_core.id_stage_i.div_en_ex_o_t0),
.u_ibex_core__id_stage_i__div_sel_ex_o_t0(
  u_ibex_core.id_stage_i.div_sel_ex_o_t0),
.u_ibex_core__id_stage_i__en_wb_o_t0(
  u_ibex_core.id_stage_i.en_wb_o_t0),
.u_ibex_core__id_stage_i__ex_valid_i_t0(
  u_ibex_core.id_stage_i.ex_valid_i_t0),
.u_ibex_core__id_stage_i__illegal_csr_insn_i_t0(
  u_ibex_core.id_stage_i.illegal_csr_insn_i_t0),
.u_ibex_core__id_stage_i__imd_val_d_ex_i_t0(
  u_ibex_core.id_stage_i.imd_val_d_ex_i_t0),
.u_ibex_core__id_stage_i__imd_val_q_ex_o_t0(
  u_ibex_core.id_stage_i.imd_val_q_ex_o_t0),
.u_ibex_core__id_stage_i__imd_val_we_ex_i_t0(
  u_ibex_core.id_stage_i.imd_val_we_ex_i_t0),
.u_ibex_core__id_stage_i__instr_first_cycle_id_o_t0(
  u_ibex_core.id_stage_i.instr_first_cycle_id_o_t0),
.u_ibex_core__id_stage_i__instr_id_done_o_t0(
  u_ibex_core.id_stage_i.instr_id_done_o_t0),
.u_ibex_core__id_stage_i__instr_perf_count_id_o_t0(
  u_ibex_core.id_stage_i.instr_perf_count_id_o_t0),
.u_ibex_core__id_stage_i__instr_rdata_c_i_t0(
  u_ibex_core.id_stage_i.instr_rdata_c_i_t0),
.u_ibex_core__id_stage_i__instr_type_wb_o_t0(
  u_ibex_core.id_stage_i.instr_type_wb_o_t0),
.u_ibex_core__id_stage_i__irq_nm_i_t0(
  u_ibex_core.id_stage_i.irq_nm_i_t0),
.u_ibex_core__id_stage_i__lsu_addr_incr_req_i_t0(
  u_ibex_core.id_stage_i.lsu_addr_incr_req_i_t0),
.u_ibex_core__id_stage_i__lsu_load_err_i_t0(
  u_ibex_core.id_stage_i.lsu_load_err_i_t0),
.u_ibex_core__id_stage_i__lsu_load_resp_intg_err_i_t0(
  u_ibex_core.id_stage_i.lsu_load_resp_intg_err_i_t0),
.u_ibex_core__id_stage_i__lsu_req_done_i_t0(
  u_ibex_core.id_stage_i.lsu_req_done_i_t0),
.u_ibex_core__id_stage_i__lsu_req_o_t0(
  u_ibex_core.id_stage_i.lsu_req_o_t0),
.u_ibex_core__id_stage_i__lsu_resp_valid_i_t0(
  u_ibex_core.id_stage_i.lsu_resp_valid_i_t0),
.u_ibex_core__id_stage_i__lsu_sign_ext_o_t0(
  u_ibex_core.id_stage_i.lsu_sign_ext_o_t0),
.u_ibex_core__id_stage_i__lsu_store_err_i_t0(
  u_ibex_core.id_stage_i.lsu_store_err_i_t0),
.u_ibex_core__id_stage_i__lsu_store_resp_intg_err_i_t0(
  u_ibex_core.id_stage_i.lsu_store_resp_intg_err_i_t0),
.u_ibex_core__id_stage_i__lsu_type_o_t0(
  u_ibex_core.id_stage_i.lsu_type_o_t0),
.u_ibex_core__id_stage_i__lsu_wdata_o_t0(
  u_ibex_core.id_stage_i.lsu_wdata_o_t0),
.u_ibex_core__id_stage_i__lsu_we_o_t0(
  u_ibex_core.id_stage_i.lsu_we_o_t0),
.u_ibex_core__id_stage_i__mult_en_ex_o_t0(
  u_ibex_core.id_stage_i.mult_en_ex_o_t0),
.u_ibex_core__id_stage_i__mult_sel_ex_o_t0(
  u_ibex_core.id_stage_i.mult_sel_ex_o_t0),
.u_ibex_core__id_stage_i__multdiv_operand_a_ex_o_t0(
  u_ibex_core.id_stage_i.multdiv_operand_a_ex_o_t0),
.u_ibex_core__id_stage_i__multdiv_operand_b_ex_o_t0(
  u_ibex_core.id_stage_i.multdiv_operand_b_ex_o_t0),
.u_ibex_core__id_stage_i__multdiv_operator_ex_o_t0(
  u_ibex_core.id_stage_i.multdiv_operator_ex_o_t0),
.u_ibex_core__id_stage_i__multdiv_ready_id_o_t0(
  u_ibex_core.id_stage_i.multdiv_ready_id_o_t0),
.u_ibex_core__id_stage_i__multdiv_signed_mode_ex_o_t0(
  u_ibex_core.id_stage_i.multdiv_signed_mode_ex_o_t0),
.u_ibex_core__id_stage_i__nt_branch_addr_o_t0(
  u_ibex_core.id_stage_i.nt_branch_addr_o_t0),
.u_ibex_core__id_stage_i__outstanding_load_wb_i_t0(
  u_ibex_core.id_stage_i.outstanding_load_wb_i_t0),
.u_ibex_core__id_stage_i__outstanding_store_wb_i_t0(
  u_ibex_core.id_stage_i.outstanding_store_wb_i_t0),
.u_ibex_core__id_stage_i__perf_branch_o_t0(
  u_ibex_core.id_stage_i.perf_branch_o_t0),
.u_ibex_core__id_stage_i__perf_div_wait_o_t0(
  u_ibex_core.id_stage_i.perf_div_wait_o_t0),
.u_ibex_core__id_stage_i__perf_dside_wait_o_t0(
  u_ibex_core.id_stage_i.perf_dside_wait_o_t0),
.u_ibex_core__id_stage_i__perf_mul_wait_o_t0(
  u_ibex_core.id_stage_i.perf_mul_wait_o_t0),
.u_ibex_core__id_stage_i__result_ex_i_t0(
  u_ibex_core.id_stage_i.result_ex_i_t0),
.u_ibex_core__id_stage_i__rf_rd_a_wb_match_o_t0(
  u_ibex_core.id_stage_i.rf_rd_a_wb_match_o_t0),
.u_ibex_core__id_stage_i__rf_rd_b_wb_match_o_t0(
  u_ibex_core.id_stage_i.rf_rd_b_wb_match_o_t0),
.u_ibex_core__id_stage_i__rf_rdata_a_i_t0(
  u_ibex_core.id_stage_i.rf_rdata_a_i_t0),
.u_ibex_core__id_stage_i__rf_rdata_b_i_t0(
  u_ibex_core.id_stage_i.rf_rdata_b_i_t0),
.u_ibex_core__id_stage_i__rf_waddr_id_o_t0(
  u_ibex_core.id_stage_i.rf_waddr_id_o_t0),
.u_ibex_core__id_stage_i__rf_waddr_wb_i_t0(
  u_ibex_core.id_stage_i.rf_waddr_wb_i_t0),
.u_ibex_core__id_stage_i__rf_wdata_fwd_wb_i_t0(
  u_ibex_core.id_stage_i.rf_wdata_fwd_wb_i_t0),
.u_ibex_core__id_stage_i__rf_wdata_id_o_t0(
  u_ibex_core.id_stage_i.rf_wdata_id_o_t0),
.u_ibex_core__id_stage_i__rf_we_id_o_t0(
  u_ibex_core.id_stage_i.rf_we_id_o_t0),
.u_ibex_core__id_stage_i__rf_write_wb_i_t0(
  u_ibex_core.id_stage_i.rf_write_wb_i_t0),
.u_ibex_core__id_stage_i__alu_multicycle_dec(
  u_ibex_core.id_stage_i.alu_multicycle_dec),
.u_ibex_core__id_stage_i__alu_multicycle_dec_t0(
  u_ibex_core.id_stage_i.alu_multicycle_dec_t0),
.u_ibex_core__id_stage_i__alu_op_a_mux_sel(
  u_ibex_core.id_stage_i.alu_op_a_mux_sel),
.u_ibex_core__id_stage_i__alu_op_a_mux_sel_dec(
  u_ibex_core.id_stage_i.alu_op_a_mux_sel_dec),
.u_ibex_core__id_stage_i__alu_op_a_mux_sel_dec_t0(
  u_ibex_core.id_stage_i.alu_op_a_mux_sel_dec_t0),
.u_ibex_core__id_stage_i__alu_op_a_mux_sel_t0(
  u_ibex_core.id_stage_i.alu_op_a_mux_sel_t0),
.u_ibex_core__id_stage_i__alu_op_b_mux_sel(
  u_ibex_core.id_stage_i.alu_op_b_mux_sel),
.u_ibex_core__id_stage_i__alu_op_b_mux_sel_dec(
  u_ibex_core.id_stage_i.alu_op_b_mux_sel_dec),
.u_ibex_core__id_stage_i__alu_op_b_mux_sel_dec_t0(
  u_ibex_core.id_stage_i.alu_op_b_mux_sel_dec_t0),
.u_ibex_core__id_stage_i__alu_op_b_mux_sel_t0(
  u_ibex_core.id_stage_i.alu_op_b_mux_sel_t0),
.u_ibex_core__id_stage_i__branch_in_dec(
  u_ibex_core.id_stage_i.branch_in_dec),
.u_ibex_core__id_stage_i__branch_in_dec_t0(
  u_ibex_core.id_stage_i.branch_in_dec_t0),
.u_ibex_core__id_stage_i__branch_jump_set_done_d(
  u_ibex_core.id_stage_i.branch_jump_set_done_d),
.u_ibex_core__id_stage_i__branch_jump_set_done_d_t0(
  u_ibex_core.id_stage_i.branch_jump_set_done_d_t0),
.u_ibex_core__id_stage_i__branch_jump_set_done_q(
  u_ibex_core.id_stage_i.branch_jump_set_done_q),
.u_ibex_core__id_stage_i__branch_jump_set_done_q_t0(
  u_ibex_core.id_stage_i.branch_jump_set_done_q_t0),
.u_ibex_core__id_stage_i__branch_not_set(
  u_ibex_core.id_stage_i.branch_not_set),
.u_ibex_core__id_stage_i__branch_not_set_t0(
  u_ibex_core.id_stage_i.branch_not_set_t0),
.u_ibex_core__id_stage_i__branch_set(
  u_ibex_core.id_stage_i.branch_set),
.u_ibex_core__id_stage_i__branch_set_raw(
  u_ibex_core.id_stage_i.branch_set_raw),
.u_ibex_core__id_stage_i__branch_set_raw_d(
  u_ibex_core.id_stage_i.branch_set_raw_d),
.u_ibex_core__id_stage_i__branch_set_raw_d_t0(
  u_ibex_core.id_stage_i.branch_set_raw_d_t0),
.u_ibex_core__id_stage_i__branch_set_raw_t0(
  u_ibex_core.id_stage_i.branch_set_raw_t0),
.u_ibex_core__id_stage_i__branch_set_t0(
  u_ibex_core.id_stage_i.branch_set_t0),
.u_ibex_core__id_stage_i__branch_taken(
  u_ibex_core.id_stage_i.branch_taken),
.u_ibex_core__id_stage_i__branch_taken_t0(
  u_ibex_core.id_stage_i.branch_taken_t0),
.u_ibex_core__id_stage_i__bt_a_mux_sel(
  u_ibex_core.id_stage_i.bt_a_mux_sel),
.u_ibex_core__id_stage_i__bt_a_mux_sel_t0(
  u_ibex_core.id_stage_i.bt_a_mux_sel_t0),
.u_ibex_core__id_stage_i__bt_b_mux_sel(
  u_ibex_core.id_stage_i.bt_b_mux_sel),
.u_ibex_core__id_stage_i__bt_b_mux_sel_t0(
  u_ibex_core.id_stage_i.bt_b_mux_sel_t0),
.u_ibex_core__id_stage_i__controller_run(
  u_ibex_core.id_stage_i.controller_run),
.u_ibex_core__id_stage_i__controller_run_t0(
  u_ibex_core.id_stage_i.controller_run_t0),
.u_ibex_core__id_stage_i__csr_pipe_flush(
  u_ibex_core.id_stage_i.csr_pipe_flush),
.u_ibex_core__id_stage_i__csr_pipe_flush_t0(
  u_ibex_core.id_stage_i.csr_pipe_flush_t0),
.u_ibex_core__id_stage_i__data_req_allowed(
  u_ibex_core.id_stage_i.data_req_allowed),
.u_ibex_core__id_stage_i__data_req_allowed_t0(
  u_ibex_core.id_stage_i.data_req_allowed_t0),
.u_ibex_core__id_stage_i__div_en_dec(
  u_ibex_core.id_stage_i.div_en_dec),
.u_ibex_core__id_stage_i__div_en_dec_t0(
  u_ibex_core.id_stage_i.div_en_dec_t0),
.u_ibex_core__id_stage_i__dret_insn_dec(
  u_ibex_core.id_stage_i.dret_insn_dec),
.u_ibex_core__id_stage_i__dret_insn_dec_t0(
  u_ibex_core.id_stage_i.dret_insn_dec_t0),
.u_ibex_core__id_stage_i__ebrk_insn(
  u_ibex_core.id_stage_i.ebrk_insn),
.u_ibex_core__id_stage_i__ebrk_insn_t0(
  u_ibex_core.id_stage_i.ebrk_insn_t0),
.u_ibex_core__id_stage_i__ecall_insn_dec(
  u_ibex_core.id_stage_i.ecall_insn_dec),
.u_ibex_core__id_stage_i__ecall_insn_dec_t0(
  u_ibex_core.id_stage_i.ecall_insn_dec_t0),
.u_ibex_core__id_stage_i__flush_id(
  u_ibex_core.id_stage_i.flush_id),
.u_ibex_core__id_stage_i__flush_id_t0(
  u_ibex_core.id_stage_i.flush_id_t0),
.u_ibex_core__id_stage_i__g_sec_branch_taken__branch_taken_q(
  u_ibex_core.id_stage_i.\g_sec_branch_taken.branch_taken_q ),
.u_ibex_core__id_stage_i__g_sec_branch_taken__branch_taken_q_t0(
  u_ibex_core.id_stage_i.\g_sec_branch_taken.branch_taken_q_t0 ),
.u_ibex_core__id_stage_i__gen_stall_mem__instr_kill(
  u_ibex_core.id_stage_i.\gen_stall_mem.instr_kill ),
.u_ibex_core__id_stage_i__gen_stall_mem__instr_kill_t0(
  u_ibex_core.id_stage_i.\gen_stall_mem.instr_kill_t0 ),
.u_ibex_core__id_stage_i__gen_stall_mem__outstanding_memory_access(
  u_ibex_core.id_stage_i.\gen_stall_mem.outstanding_memory_access ),
.u_ibex_core__id_stage_i__gen_stall_mem__rf_rd_a_hz(
  u_ibex_core.id_stage_i.\gen_stall_mem.rf_rd_a_hz ),
.u_ibex_core__id_stage_i__gen_stall_mem__rf_rd_a_hz_t0(
  u_ibex_core.id_stage_i.\gen_stall_mem.rf_rd_a_hz_t0 ),
.u_ibex_core__id_stage_i__gen_stall_mem__rf_rd_b_hz(
  u_ibex_core.id_stage_i.\gen_stall_mem.rf_rd_b_hz ),
.u_ibex_core__id_stage_i__gen_stall_mem__rf_rd_b_hz_t0(
  u_ibex_core.id_stage_i.\gen_stall_mem.rf_rd_b_hz_t0 ),
.u_ibex_core__id_stage_i__id_exception(
  u_ibex_core.id_stage_i.id_exception),
.u_ibex_core__id_stage_i__id_exception_t0(
  u_ibex_core.id_stage_i.id_exception_t0),
.u_ibex_core__id_stage_i__id_fsm_q(
  u_ibex_core.id_stage_i.id_fsm_q),
.u_ibex_core__id_stage_i__id_fsm_q_t0(
  u_ibex_core.id_stage_i.id_fsm_q_t0),
.u_ibex_core__id_stage_i__illegal_dret_insn(
  u_ibex_core.id_stage_i.illegal_dret_insn),
.u_ibex_core__id_stage_i__illegal_dret_insn_t0(
  u_ibex_core.id_stage_i.illegal_dret_insn_t0),
.u_ibex_core__id_stage_i__illegal_insn_dec(
  u_ibex_core.id_stage_i.illegal_insn_dec),
.u_ibex_core__id_stage_i__illegal_insn_dec_t0(
  u_ibex_core.id_stage_i.illegal_insn_dec_t0),
.u_ibex_core__id_stage_i__illegal_umode_insn(
  u_ibex_core.id_stage_i.illegal_umode_insn),
.u_ibex_core__id_stage_i__illegal_umode_insn_t0(
  u_ibex_core.id_stage_i.illegal_umode_insn_t0),
.u_ibex_core__id_stage_i__imm_a(
  u_ibex_core.id_stage_i.imm_a),
.u_ibex_core__id_stage_i__imm_a_mux_sel(
  u_ibex_core.id_stage_i.imm_a_mux_sel),
.u_ibex_core__id_stage_i__imm_a_mux_sel_t0(
  u_ibex_core.id_stage_i.imm_a_mux_sel_t0),
.u_ibex_core__id_stage_i__imm_a_t0(
  u_ibex_core.id_stage_i.imm_a_t0),
.u_ibex_core__id_stage_i__imm_b(
  u_ibex_core.id_stage_i.imm_b),
.u_ibex_core__id_stage_i__imm_b_mux_sel(
  u_ibex_core.id_stage_i.imm_b_mux_sel),
.u_ibex_core__id_stage_i__imm_b_mux_sel_dec(
  u_ibex_core.id_stage_i.imm_b_mux_sel_dec),
.u_ibex_core__id_stage_i__imm_b_mux_sel_dec_t0(
  u_ibex_core.id_stage_i.imm_b_mux_sel_dec_t0),
.u_ibex_core__id_stage_i__imm_b_mux_sel_t0(
  u_ibex_core.id_stage_i.imm_b_mux_sel_t0),
.u_ibex_core__id_stage_i__imm_b_t0(
  u_ibex_core.id_stage_i.imm_b_t0),
.u_ibex_core__id_stage_i__imm_b_type(
  u_ibex_core.id_stage_i.imm_b_type),
.u_ibex_core__id_stage_i__imm_b_type_t0(
  u_ibex_core.id_stage_i.imm_b_type_t0),
.u_ibex_core__id_stage_i__imm_i_type(
  u_ibex_core.id_stage_i.imm_i_type),
.u_ibex_core__id_stage_i__imm_i_type_t0(
  u_ibex_core.id_stage_i.imm_i_type_t0),
.u_ibex_core__id_stage_i__imm_j_type(
  u_ibex_core.id_stage_i.imm_j_type),
.u_ibex_core__id_stage_i__imm_j_type_t0(
  u_ibex_core.id_stage_i.imm_j_type_t0),
.u_ibex_core__id_stage_i__imm_s_type(
  u_ibex_core.id_stage_i.imm_s_type),
.u_ibex_core__id_stage_i__imm_s_type_t0(
  u_ibex_core.id_stage_i.imm_s_type_t0),
.u_ibex_core__id_stage_i__imm_u_type(
  u_ibex_core.id_stage_i.imm_u_type),
.u_ibex_core__id_stage_i__imm_u_type_t0(
  u_ibex_core.id_stage_i.imm_u_type_t0),
.u_ibex_core__id_stage_i__instr_executing(
  u_ibex_core.id_stage_i.instr_executing),
.u_ibex_core__id_stage_i__instr_executing_spec(
  u_ibex_core.id_stage_i.instr_executing_spec),
.u_ibex_core__id_stage_i__instr_executing_spec_t0(
  u_ibex_core.id_stage_i.instr_executing_spec_t0),
.u_ibex_core__id_stage_i__instr_executing_t0(
  u_ibex_core.id_stage_i.instr_executing_t0),
.u_ibex_core__id_stage_i__jump_in_dec(
  u_ibex_core.id_stage_i.jump_in_dec),
.u_ibex_core__id_stage_i__jump_in_dec_t0(
  u_ibex_core.id_stage_i.jump_in_dec_t0),
.u_ibex_core__id_stage_i__jump_set(
  u_ibex_core.id_stage_i.jump_set),
.u_ibex_core__id_stage_i__jump_set_dec(
  u_ibex_core.id_stage_i.jump_set_dec),
.u_ibex_core__id_stage_i__jump_set_dec_t0(
  u_ibex_core.id_stage_i.jump_set_dec_t0),
.u_ibex_core__id_stage_i__jump_set_raw(
  u_ibex_core.id_stage_i.jump_set_raw),
.u_ibex_core__id_stage_i__jump_set_raw_t0(
  u_ibex_core.id_stage_i.jump_set_raw_t0),
.u_ibex_core__id_stage_i__jump_set_t0(
  u_ibex_core.id_stage_i.jump_set_t0),
.u_ibex_core__id_stage_i__lsu_req_dec(
  u_ibex_core.id_stage_i.lsu_req_dec),
.u_ibex_core__id_stage_i__lsu_req_dec_t0(
  u_ibex_core.id_stage_i.lsu_req_dec_t0),
.u_ibex_core__id_stage_i__mem_resp_intg_err(
  u_ibex_core.id_stage_i.mem_resp_intg_err),
.u_ibex_core__id_stage_i__mem_resp_intg_err_t0(
  u_ibex_core.id_stage_i.mem_resp_intg_err_t0),
.u_ibex_core__id_stage_i__mret_insn_dec(
  u_ibex_core.id_stage_i.mret_insn_dec),
.u_ibex_core__id_stage_i__mret_insn_dec_t0(
  u_ibex_core.id_stage_i.mret_insn_dec_t0),
.u_ibex_core__id_stage_i__mult_en_dec(
  u_ibex_core.id_stage_i.mult_en_dec),
.u_ibex_core__id_stage_i__mult_en_dec_t0(
  u_ibex_core.id_stage_i.mult_en_dec_t0),
.u_ibex_core__id_stage_i__multdiv_en_dec(
  u_ibex_core.id_stage_i.multdiv_en_dec),
.u_ibex_core__id_stage_i__multdiv_en_dec_t0(
  u_ibex_core.id_stage_i.multdiv_en_dec_t0),
.u_ibex_core__id_stage_i__multicycle_done(
  u_ibex_core.id_stage_i.multicycle_done),
.u_ibex_core__id_stage_i__multicycle_done_t0(
  u_ibex_core.id_stage_i.multicycle_done_t0),
.u_ibex_core__id_stage_i__rf_ren_a_dec(
  u_ibex_core.id_stage_i.rf_ren_a_dec),
.u_ibex_core__id_stage_i__rf_ren_a_dec_t0(
  u_ibex_core.id_stage_i.rf_ren_a_dec_t0),
.u_ibex_core__id_stage_i__rf_ren_b_dec(
  u_ibex_core.id_stage_i.rf_ren_b_dec),
.u_ibex_core__id_stage_i__rf_ren_b_dec_t0(
  u_ibex_core.id_stage_i.rf_ren_b_dec_t0),
.u_ibex_core__id_stage_i__rf_wdata_sel(
  u_ibex_core.id_stage_i.rf_wdata_sel),
.u_ibex_core__id_stage_i__rf_wdata_sel_t0(
  u_ibex_core.id_stage_i.rf_wdata_sel_t0),
.u_ibex_core__id_stage_i__rf_we_dec(
  u_ibex_core.id_stage_i.rf_we_dec),
.u_ibex_core__id_stage_i__rf_we_dec_t0(
  u_ibex_core.id_stage_i.rf_we_dec_t0),
.u_ibex_core__id_stage_i__rf_we_raw(
  u_ibex_core.id_stage_i.rf_we_raw),
.u_ibex_core__id_stage_i__rf_we_raw_t0(
  u_ibex_core.id_stage_i.rf_we_raw_t0),
.u_ibex_core__id_stage_i__stall_alu(
  u_ibex_core.id_stage_i.stall_alu),
.u_ibex_core__id_stage_i__stall_alu_t0(
  u_ibex_core.id_stage_i.stall_alu_t0),
.u_ibex_core__id_stage_i__stall_branch(
  u_ibex_core.id_stage_i.stall_branch),
.u_ibex_core__id_stage_i__stall_branch_t0(
  u_ibex_core.id_stage_i.stall_branch_t0),
.u_ibex_core__id_stage_i__stall_id(
  u_ibex_core.id_stage_i.stall_id),
.u_ibex_core__id_stage_i__stall_id_t0(
  u_ibex_core.id_stage_i.stall_id_t0),
.u_ibex_core__id_stage_i__stall_jump(
  u_ibex_core.id_stage_i.stall_jump),
.u_ibex_core__id_stage_i__stall_jump_t0(
  u_ibex_core.id_stage_i.stall_jump_t0),
.u_ibex_core__id_stage_i__stall_ld_hz(
  u_ibex_core.id_stage_i.stall_ld_hz),
.u_ibex_core__id_stage_i__stall_ld_hz_t0(
  u_ibex_core.id_stage_i.stall_ld_hz_t0),
.u_ibex_core__id_stage_i__stall_mem(
  u_ibex_core.id_stage_i.stall_mem),
.u_ibex_core__id_stage_i__stall_mem_t0(
  u_ibex_core.id_stage_i.stall_mem_t0),
.u_ibex_core__id_stage_i__stall_multdiv(
  u_ibex_core.id_stage_i.stall_multdiv),
.u_ibex_core__id_stage_i__stall_multdiv_t0(
  u_ibex_core.id_stage_i.stall_multdiv_t0),
.u_ibex_core__id_stage_i__stall_wb(
  u_ibex_core.id_stage_i.stall_wb),
.u_ibex_core__id_stage_i__stall_wb_t0(
  u_ibex_core.id_stage_i.stall_wb_t0),
.u_ibex_core__id_stage_i__wb_exception(
  u_ibex_core.id_stage_i.wb_exception),
.u_ibex_core__id_stage_i__wb_exception_t0(
  u_ibex_core.id_stage_i.wb_exception_t0),
.u_ibex_core__id_stage_i__wfi_insn_dec(
  u_ibex_core.id_stage_i.wfi_insn_dec),
.u_ibex_core__id_stage_i__wfi_insn_dec_t0(
  u_ibex_core.id_stage_i.wfi_insn_dec_t0),
.u_ibex_core__id_stage_i__zimm_rs1_type(
  u_ibex_core.id_stage_i.zimm_rs1_type),
.u_ibex_core__id_stage_i__zimm_rs1_type_t0(
  u_ibex_core.id_stage_i.zimm_rs1_type_t0),
.u_ibex_core__id_stage_i__controller_i__clk_i(
  u_ibex_core.id_stage_i.controller_i.clk_i),
.u_ibex_core__id_stage_i__controller_i__rst_ni(
  u_ibex_core.id_stage_i.controller_i.rst_ni),
.u_ibex_core__id_stage_i__controller_i__ctrl_busy_o(
  u_ibex_core.id_stage_i.controller_i.ctrl_busy_o),
.u_ibex_core__id_stage_i__controller_i__illegal_insn_i(
  u_ibex_core.id_stage_i.controller_i.illegal_insn_i),
.u_ibex_core__id_stage_i__controller_i__ecall_insn_i(
  u_ibex_core.id_stage_i.controller_i.ecall_insn_i),
.u_ibex_core__id_stage_i__controller_i__mret_insn_i(
  u_ibex_core.id_stage_i.controller_i.mret_insn_i),
.u_ibex_core__id_stage_i__controller_i__dret_insn_i(
  u_ibex_core.id_stage_i.controller_i.dret_insn_i),
.u_ibex_core__id_stage_i__controller_i__wfi_insn_i(
  u_ibex_core.id_stage_i.controller_i.wfi_insn_i),
.u_ibex_core__id_stage_i__controller_i__ebrk_insn_i(
  u_ibex_core.id_stage_i.controller_i.ebrk_insn_i),
.u_ibex_core__id_stage_i__controller_i__csr_pipe_flush_i(
  u_ibex_core.id_stage_i.controller_i.csr_pipe_flush_i),
.u_ibex_core__id_stage_i__controller_i__instr_valid_i(
  u_ibex_core.id_stage_i.controller_i.instr_valid_i),
.u_ibex_core__id_stage_i__controller_i__instr_i(
  u_ibex_core.id_stage_i.controller_i.instr_i),
.u_ibex_core__id_stage_i__controller_i__instr_compressed_i(
  u_ibex_core.id_stage_i.controller_i.instr_compressed_i),
.u_ibex_core__id_stage_i__controller_i__instr_is_compressed_i(
  u_ibex_core.id_stage_i.controller_i.instr_is_compressed_i),
.u_ibex_core__id_stage_i__controller_i__instr_bp_taken_i(
  u_ibex_core.id_stage_i.controller_i.instr_bp_taken_i),
.u_ibex_core__id_stage_i__controller_i__instr_fetch_err_i(
  u_ibex_core.id_stage_i.controller_i.instr_fetch_err_i),
.u_ibex_core__id_stage_i__controller_i__instr_fetch_err_plus2_i(
  u_ibex_core.id_stage_i.controller_i.instr_fetch_err_plus2_i),
.u_ibex_core__id_stage_i__controller_i__pc_id_i(
  u_ibex_core.id_stage_i.controller_i.pc_id_i),
.u_ibex_core__id_stage_i__controller_i__instr_valid_clear_o(
  u_ibex_core.id_stage_i.controller_i.instr_valid_clear_o),
.u_ibex_core__id_stage_i__controller_i__id_in_ready_o(
  u_ibex_core.id_stage_i.controller_i.id_in_ready_o),
.u_ibex_core__id_stage_i__controller_i__controller_run_o(
  u_ibex_core.id_stage_i.controller_i.controller_run_o),
.u_ibex_core__id_stage_i__controller_i__instr_exec_i(
  u_ibex_core.id_stage_i.controller_i.instr_exec_i),
.u_ibex_core__id_stage_i__controller_i__instr_req_o(
  u_ibex_core.id_stage_i.controller_i.instr_req_o),
.u_ibex_core__id_stage_i__controller_i__pc_set_o(
  u_ibex_core.id_stage_i.controller_i.pc_set_o),
.u_ibex_core__id_stage_i__controller_i__pc_mux_o(
  u_ibex_core.id_stage_i.controller_i.pc_mux_o),
.u_ibex_core__id_stage_i__controller_i__nt_branch_mispredict_o(
  u_ibex_core.id_stage_i.controller_i.nt_branch_mispredict_o),
.u_ibex_core__id_stage_i__controller_i__exc_pc_mux_o(
  u_ibex_core.id_stage_i.controller_i.exc_pc_mux_o),
.u_ibex_core__id_stage_i__controller_i__exc_cause_o(
  u_ibex_core.id_stage_i.controller_i.exc_cause_o),
.u_ibex_core__id_stage_i__controller_i__lsu_addr_last_i(
  u_ibex_core.id_stage_i.controller_i.lsu_addr_last_i),
.u_ibex_core__id_stage_i__controller_i__load_err_i(
  u_ibex_core.id_stage_i.controller_i.load_err_i),
.u_ibex_core__id_stage_i__controller_i__store_err_i(
  u_ibex_core.id_stage_i.controller_i.store_err_i),
.u_ibex_core__id_stage_i__controller_i__mem_resp_intg_err_i(
  u_ibex_core.id_stage_i.controller_i.mem_resp_intg_err_i),
.u_ibex_core__id_stage_i__controller_i__wb_exception_o(
  u_ibex_core.id_stage_i.controller_i.wb_exception_o),
.u_ibex_core__id_stage_i__controller_i__id_exception_o(
  u_ibex_core.id_stage_i.controller_i.id_exception_o),
.u_ibex_core__id_stage_i__controller_i__branch_set_i(
  u_ibex_core.id_stage_i.controller_i.branch_set_i),
.u_ibex_core__id_stage_i__controller_i__branch_not_set_i(
  u_ibex_core.id_stage_i.controller_i.branch_not_set_i),
.u_ibex_core__id_stage_i__controller_i__jump_set_i(
  u_ibex_core.id_stage_i.controller_i.jump_set_i),
.u_ibex_core__id_stage_i__controller_i__csr_mstatus_mie_i(
  u_ibex_core.id_stage_i.controller_i.csr_mstatus_mie_i),
.u_ibex_core__id_stage_i__controller_i__irq_pending_i(
  u_ibex_core.id_stage_i.controller_i.irq_pending_i),
.u_ibex_core__id_stage_i__controller_i__irqs_i(
  u_ibex_core.id_stage_i.controller_i.irqs_i),
.u_ibex_core__id_stage_i__controller_i__irq_nm_ext_i(
  u_ibex_core.id_stage_i.controller_i.irq_nm_ext_i),
.u_ibex_core__id_stage_i__controller_i__nmi_mode_o(
  u_ibex_core.id_stage_i.controller_i.nmi_mode_o),
.u_ibex_core__id_stage_i__controller_i__debug_req_i(
  u_ibex_core.id_stage_i.controller_i.debug_req_i),
.u_ibex_core__id_stage_i__controller_i__debug_cause_o(
  u_ibex_core.id_stage_i.controller_i.debug_cause_o),
.u_ibex_core__id_stage_i__controller_i__debug_csr_save_o(
  u_ibex_core.id_stage_i.controller_i.debug_csr_save_o),
.u_ibex_core__id_stage_i__controller_i__debug_mode_o(
  u_ibex_core.id_stage_i.controller_i.debug_mode_o),
.u_ibex_core__id_stage_i__controller_i__debug_mode_entering_o(
  u_ibex_core.id_stage_i.controller_i.debug_mode_entering_o),
.u_ibex_core__id_stage_i__controller_i__debug_single_step_i(
  u_ibex_core.id_stage_i.controller_i.debug_single_step_i),
.u_ibex_core__id_stage_i__controller_i__debug_ebreakm_i(
  u_ibex_core.id_stage_i.controller_i.debug_ebreakm_i),
.u_ibex_core__id_stage_i__controller_i__debug_ebreaku_i(
  u_ibex_core.id_stage_i.controller_i.debug_ebreaku_i),
.u_ibex_core__id_stage_i__controller_i__trigger_match_i(
  u_ibex_core.id_stage_i.controller_i.trigger_match_i),
.u_ibex_core__id_stage_i__controller_i__csr_save_if_o(
  u_ibex_core.id_stage_i.controller_i.csr_save_if_o),
.u_ibex_core__id_stage_i__controller_i__csr_save_id_o(
  u_ibex_core.id_stage_i.controller_i.csr_save_id_o),
.u_ibex_core__id_stage_i__controller_i__csr_save_wb_o(
  u_ibex_core.id_stage_i.controller_i.csr_save_wb_o),
.u_ibex_core__id_stage_i__controller_i__csr_restore_mret_id_o(
  u_ibex_core.id_stage_i.controller_i.csr_restore_mret_id_o),
.u_ibex_core__id_stage_i__controller_i__csr_restore_dret_id_o(
  u_ibex_core.id_stage_i.controller_i.csr_restore_dret_id_o),
.u_ibex_core__id_stage_i__controller_i__csr_save_cause_o(
  u_ibex_core.id_stage_i.controller_i.csr_save_cause_o),
.u_ibex_core__id_stage_i__controller_i__csr_mtval_o(
  u_ibex_core.id_stage_i.controller_i.csr_mtval_o),
.u_ibex_core__id_stage_i__controller_i__priv_mode_i(
  u_ibex_core.id_stage_i.controller_i.priv_mode_i),
.u_ibex_core__id_stage_i__controller_i__stall_id_i(
  u_ibex_core.id_stage_i.controller_i.stall_id_i),
.u_ibex_core__id_stage_i__controller_i__stall_wb_i(
  u_ibex_core.id_stage_i.controller_i.stall_wb_i),
.u_ibex_core__id_stage_i__controller_i__flush_id_o(
  u_ibex_core.id_stage_i.controller_i.flush_id_o),
.u_ibex_core__id_stage_i__controller_i__ready_wb_i(
  u_ibex_core.id_stage_i.controller_i.ready_wb_i),
.u_ibex_core__id_stage_i__controller_i__perf_jump_o(
  u_ibex_core.id_stage_i.controller_i.perf_jump_o),
.u_ibex_core__id_stage_i__controller_i__perf_tbranch_o(
  u_ibex_core.id_stage_i.controller_i.perf_tbranch_o),
.u_ibex_core__id_stage_i__controller_i__instr_i_t0(
  u_ibex_core.id_stage_i.controller_i.instr_i_t0),
.u_ibex_core__id_stage_i__controller_i__instr_req_o_t0(
  u_ibex_core.id_stage_i.controller_i.instr_req_o_t0),
.u_ibex_core__id_stage_i__controller_i__branch_not_set_i_t0(
  u_ibex_core.id_stage_i.controller_i.branch_not_set_i_t0),
.u_ibex_core__id_stage_i__controller_i__branch_set_i_t0(
  u_ibex_core.id_stage_i.controller_i.branch_set_i_t0),
.u_ibex_core__id_stage_i__controller_i__controller_run_o_t0(
  u_ibex_core.id_stage_i.controller_i.controller_run_o_t0),
.u_ibex_core__id_stage_i__controller_i__csr_mstatus_mie_i_t0(
  u_ibex_core.id_stage_i.controller_i.csr_mstatus_mie_i_t0),
.u_ibex_core__id_stage_i__controller_i__csr_mtval_o_t0(
  u_ibex_core.id_stage_i.controller_i.csr_mtval_o_t0),
.u_ibex_core__id_stage_i__controller_i__csr_pipe_flush_i_t0(
  u_ibex_core.id_stage_i.controller_i.csr_pipe_flush_i_t0),
.u_ibex_core__id_stage_i__controller_i__csr_restore_dret_id_o_t0(
  u_ibex_core.id_stage_i.controller_i.csr_restore_dret_id_o_t0),
.u_ibex_core__id_stage_i__controller_i__csr_restore_mret_id_o_t0(
  u_ibex_core.id_stage_i.controller_i.csr_restore_mret_id_o_t0),
.u_ibex_core__id_stage_i__controller_i__csr_save_cause_o_t0(
  u_ibex_core.id_stage_i.controller_i.csr_save_cause_o_t0),
.u_ibex_core__id_stage_i__controller_i__csr_save_id_o_t0(
  u_ibex_core.id_stage_i.controller_i.csr_save_id_o_t0),
.u_ibex_core__id_stage_i__controller_i__csr_save_if_o_t0(
  u_ibex_core.id_stage_i.controller_i.csr_save_if_o_t0),
.u_ibex_core__id_stage_i__controller_i__csr_save_wb_o_t0(
  u_ibex_core.id_stage_i.controller_i.csr_save_wb_o_t0),
.u_ibex_core__id_stage_i__controller_i__ctrl_busy_o_t0(
  u_ibex_core.id_stage_i.controller_i.ctrl_busy_o_t0),
.u_ibex_core__id_stage_i__controller_i__debug_cause_o_t0(
  u_ibex_core.id_stage_i.controller_i.debug_cause_o_t0),
.u_ibex_core__id_stage_i__controller_i__debug_csr_save_o_t0(
  u_ibex_core.id_stage_i.controller_i.debug_csr_save_o_t0),
.u_ibex_core__id_stage_i__controller_i__debug_ebreakm_i_t0(
  u_ibex_core.id_stage_i.controller_i.debug_ebreakm_i_t0),
.u_ibex_core__id_stage_i__controller_i__debug_ebreaku_i_t0(
  u_ibex_core.id_stage_i.controller_i.debug_ebreaku_i_t0),
.u_ibex_core__id_stage_i__controller_i__debug_mode_entering_o_t0(
  u_ibex_core.id_stage_i.controller_i.debug_mode_entering_o_t0),
.u_ibex_core__id_stage_i__controller_i__debug_mode_o_t0(
  u_ibex_core.id_stage_i.controller_i.debug_mode_o_t0),
.u_ibex_core__id_stage_i__controller_i__debug_req_i_t0(
  u_ibex_core.id_stage_i.controller_i.debug_req_i_t0),
.u_ibex_core__id_stage_i__controller_i__debug_single_step_i_t0(
  u_ibex_core.id_stage_i.controller_i.debug_single_step_i_t0),
.u_ibex_core__id_stage_i__controller_i__dret_insn_i_t0(
  u_ibex_core.id_stage_i.controller_i.dret_insn_i_t0),
.u_ibex_core__id_stage_i__controller_i__ebrk_insn_i_t0(
  u_ibex_core.id_stage_i.controller_i.ebrk_insn_i_t0),
.u_ibex_core__id_stage_i__controller_i__ecall_insn_i_t0(
  u_ibex_core.id_stage_i.controller_i.ecall_insn_i_t0),
.u_ibex_core__id_stage_i__controller_i__exc_cause_o_t0(
  u_ibex_core.id_stage_i.controller_i.exc_cause_o_t0),
.u_ibex_core__id_stage_i__controller_i__exc_pc_mux_o_t0(
  u_ibex_core.id_stage_i.controller_i.exc_pc_mux_o_t0),
.u_ibex_core__id_stage_i__controller_i__flush_id_o_t0(
  u_ibex_core.id_stage_i.controller_i.flush_id_o_t0),
.u_ibex_core__id_stage_i__controller_i__id_exception_o_t0(
  u_ibex_core.id_stage_i.controller_i.id_exception_o_t0),
.u_ibex_core__id_stage_i__controller_i__id_in_ready_o_t0(
  u_ibex_core.id_stage_i.controller_i.id_in_ready_o_t0),
.u_ibex_core__id_stage_i__controller_i__illegal_insn_i_t0(
  u_ibex_core.id_stage_i.controller_i.illegal_insn_i_t0),
.u_ibex_core__id_stage_i__controller_i__instr_bp_taken_i_t0(
  u_ibex_core.id_stage_i.controller_i.instr_bp_taken_i_t0),
.u_ibex_core__id_stage_i__controller_i__instr_compressed_i_t0(
  u_ibex_core.id_stage_i.controller_i.instr_compressed_i_t0),
.u_ibex_core__id_stage_i__controller_i__instr_exec_i_t0(
  u_ibex_core.id_stage_i.controller_i.instr_exec_i_t0),
.u_ibex_core__id_stage_i__controller_i__instr_fetch_err_i_t0(
  u_ibex_core.id_stage_i.controller_i.instr_fetch_err_i_t0),
.u_ibex_core__id_stage_i__controller_i__instr_fetch_err_plus2_i_t0(
  u_ibex_core.id_stage_i.controller_i.instr_fetch_err_plus2_i_t0),
.u_ibex_core__id_stage_i__controller_i__instr_is_compressed_i_t0(
  u_ibex_core.id_stage_i.controller_i.instr_is_compressed_i_t0),
.u_ibex_core__id_stage_i__controller_i__instr_valid_clear_o_t0(
  u_ibex_core.id_stage_i.controller_i.instr_valid_clear_o_t0),
.u_ibex_core__id_stage_i__controller_i__instr_valid_i_t0(
  u_ibex_core.id_stage_i.controller_i.instr_valid_i_t0),
.u_ibex_core__id_stage_i__controller_i__irq_nm_ext_i_t0(
  u_ibex_core.id_stage_i.controller_i.irq_nm_ext_i_t0),
.u_ibex_core__id_stage_i__controller_i__irq_pending_i_t0(
  u_ibex_core.id_stage_i.controller_i.irq_pending_i_t0),
.u_ibex_core__id_stage_i__controller_i__irqs_i_t0(
  u_ibex_core.id_stage_i.controller_i.irqs_i_t0),
.u_ibex_core__id_stage_i__controller_i__jump_set_i_t0(
  u_ibex_core.id_stage_i.controller_i.jump_set_i_t0),
.u_ibex_core__id_stage_i__controller_i__load_err_i_t0(
  u_ibex_core.id_stage_i.controller_i.load_err_i_t0),
.u_ibex_core__id_stage_i__controller_i__lsu_addr_last_i_t0(
  u_ibex_core.id_stage_i.controller_i.lsu_addr_last_i_t0),
.u_ibex_core__id_stage_i__controller_i__mem_resp_intg_err_i_t0(
  u_ibex_core.id_stage_i.controller_i.mem_resp_intg_err_i_t0),
.u_ibex_core__id_stage_i__controller_i__mret_insn_i_t0(
  u_ibex_core.id_stage_i.controller_i.mret_insn_i_t0),
.u_ibex_core__id_stage_i__controller_i__nmi_mode_o_t0(
  u_ibex_core.id_stage_i.controller_i.nmi_mode_o_t0),
.u_ibex_core__id_stage_i__controller_i__nt_branch_mispredict_o_t0(
  u_ibex_core.id_stage_i.controller_i.nt_branch_mispredict_o_t0),
.u_ibex_core__id_stage_i__controller_i__pc_id_i_t0(
  u_ibex_core.id_stage_i.controller_i.pc_id_i_t0),
.u_ibex_core__id_stage_i__controller_i__pc_mux_o_t0(
  u_ibex_core.id_stage_i.controller_i.pc_mux_o_t0),
.u_ibex_core__id_stage_i__controller_i__pc_set_o_t0(
  u_ibex_core.id_stage_i.controller_i.pc_set_o_t0),
.u_ibex_core__id_stage_i__controller_i__perf_jump_o_t0(
  u_ibex_core.id_stage_i.controller_i.perf_jump_o_t0),
.u_ibex_core__id_stage_i__controller_i__perf_tbranch_o_t0(
  u_ibex_core.id_stage_i.controller_i.perf_tbranch_o_t0),
.u_ibex_core__id_stage_i__controller_i__priv_mode_i_t0(
  u_ibex_core.id_stage_i.controller_i.priv_mode_i_t0),
.u_ibex_core__id_stage_i__controller_i__ready_wb_i_t0(
  u_ibex_core.id_stage_i.controller_i.ready_wb_i_t0),
.u_ibex_core__id_stage_i__controller_i__stall_id_i_t0(
  u_ibex_core.id_stage_i.controller_i.stall_id_i_t0),
.u_ibex_core__id_stage_i__controller_i__stall_wb_i_t0(
  u_ibex_core.id_stage_i.controller_i.stall_wb_i_t0),
.u_ibex_core__id_stage_i__controller_i__store_err_i_t0(
  u_ibex_core.id_stage_i.controller_i.store_err_i_t0),
.u_ibex_core__id_stage_i__controller_i__trigger_match_i_t0(
  u_ibex_core.id_stage_i.controller_i.trigger_match_i_t0),
.u_ibex_core__id_stage_i__controller_i__wb_exception_o_t0(
  u_ibex_core.id_stage_i.controller_i.wb_exception_o_t0),
.u_ibex_core__id_stage_i__controller_i__wfi_insn_i_t0(
  u_ibex_core.id_stage_i.controller_i.wfi_insn_i_t0),
.u_ibex_core__id_stage_i__controller_i__csr_pipe_flush(
  u_ibex_core.id_stage_i.controller_i.csr_pipe_flush),
.u_ibex_core__id_stage_i__controller_i__csr_pipe_flush_t0(
  u_ibex_core.id_stage_i.controller_i.csr_pipe_flush_t0),
.u_ibex_core__id_stage_i__controller_i__ctrl_fsm_cs(
  u_ibex_core.id_stage_i.controller_i.ctrl_fsm_cs),
.u_ibex_core__id_stage_i__controller_i__ctrl_fsm_cs_t0(
  u_ibex_core.id_stage_i.controller_i.ctrl_fsm_cs_t0),
.u_ibex_core__id_stage_i__controller_i__ctrl_fsm_ns(
  u_ibex_core.id_stage_i.controller_i.ctrl_fsm_ns),
.u_ibex_core__id_stage_i__controller_i__ctrl_fsm_ns_t0(
  u_ibex_core.id_stage_i.controller_i.ctrl_fsm_ns_t0),
.u_ibex_core__id_stage_i__controller_i__debug_cause_d(
  u_ibex_core.id_stage_i.controller_i.debug_cause_d),
.u_ibex_core__id_stage_i__controller_i__debug_cause_d_t0(
  u_ibex_core.id_stage_i.controller_i.debug_cause_d_t0),
.u_ibex_core__id_stage_i__controller_i__debug_mode_d(
  u_ibex_core.id_stage_i.controller_i.debug_mode_d),
.u_ibex_core__id_stage_i__controller_i__debug_mode_d_t0(
  u_ibex_core.id_stage_i.controller_i.debug_mode_d_t0),
.u_ibex_core__id_stage_i__controller_i__do_single_step_d(
  u_ibex_core.id_stage_i.controller_i.do_single_step_d),
.u_ibex_core__id_stage_i__controller_i__do_single_step_d_t0(
  u_ibex_core.id_stage_i.controller_i.do_single_step_d_t0),
.u_ibex_core__id_stage_i__controller_i__do_single_step_q(
  u_ibex_core.id_stage_i.controller_i.do_single_step_q),
.u_ibex_core__id_stage_i__controller_i__do_single_step_q_t0(
  u_ibex_core.id_stage_i.controller_i.do_single_step_q_t0),
.u_ibex_core__id_stage_i__controller_i__dret_insn(
  u_ibex_core.id_stage_i.controller_i.dret_insn),
.u_ibex_core__id_stage_i__controller_i__dret_insn_t0(
  u_ibex_core.id_stage_i.controller_i.dret_insn_t0),
.u_ibex_core__id_stage_i__controller_i__ebreak_into_debug(
  u_ibex_core.id_stage_i.controller_i.ebreak_into_debug),
.u_ibex_core__id_stage_i__controller_i__ebreak_into_debug_t0(
  u_ibex_core.id_stage_i.controller_i.ebreak_into_debug_t0),
.u_ibex_core__id_stage_i__controller_i__ebrk_insn(
  u_ibex_core.id_stage_i.controller_i.ebrk_insn),
.u_ibex_core__id_stage_i__controller_i__ebrk_insn_prio(
  u_ibex_core.id_stage_i.controller_i.ebrk_insn_prio),
.u_ibex_core__id_stage_i__controller_i__ebrk_insn_prio_t0(
  u_ibex_core.id_stage_i.controller_i.ebrk_insn_prio_t0),
.u_ibex_core__id_stage_i__controller_i__ebrk_insn_t0(
  u_ibex_core.id_stage_i.controller_i.ebrk_insn_t0),
.u_ibex_core__id_stage_i__controller_i__ecall_insn(
  u_ibex_core.id_stage_i.controller_i.ecall_insn),
.u_ibex_core__id_stage_i__controller_i__ecall_insn_prio(
  u_ibex_core.id_stage_i.controller_i.ecall_insn_prio),
.u_ibex_core__id_stage_i__controller_i__ecall_insn_prio_t0(
  u_ibex_core.id_stage_i.controller_i.ecall_insn_prio_t0),
.u_ibex_core__id_stage_i__controller_i__ecall_insn_t0(
  u_ibex_core.id_stage_i.controller_i.ecall_insn_t0),
.u_ibex_core__id_stage_i__controller_i__enter_debug_mode(
  u_ibex_core.id_stage_i.controller_i.enter_debug_mode),
.u_ibex_core__id_stage_i__controller_i__enter_debug_mode_prio_d(
  u_ibex_core.id_stage_i.controller_i.enter_debug_mode_prio_d),
.u_ibex_core__id_stage_i__controller_i__enter_debug_mode_prio_d_t0(
  u_ibex_core.id_stage_i.controller_i.enter_debug_mode_prio_d_t0),
.u_ibex_core__id_stage_i__controller_i__enter_debug_mode_prio_q(
  u_ibex_core.id_stage_i.controller_i.enter_debug_mode_prio_q),
.u_ibex_core__id_stage_i__controller_i__enter_debug_mode_prio_q_t0(
  u_ibex_core.id_stage_i.controller_i.enter_debug_mode_prio_q_t0),
.u_ibex_core__id_stage_i__controller_i__enter_debug_mode_t0(
  u_ibex_core.id_stage_i.controller_i.enter_debug_mode_t0),
.u_ibex_core__id_stage_i__controller_i__exc_req_d(
  u_ibex_core.id_stage_i.controller_i.exc_req_d),
.u_ibex_core__id_stage_i__controller_i__exc_req_d_t0(
  u_ibex_core.id_stage_i.controller_i.exc_req_d_t0),
.u_ibex_core__id_stage_i__controller_i__exc_req_lsu(
  u_ibex_core.id_stage_i.controller_i.exc_req_lsu),
.u_ibex_core__id_stage_i__controller_i__exc_req_lsu_t0(
  u_ibex_core.id_stage_i.controller_i.exc_req_lsu_t0),
.u_ibex_core__id_stage_i__controller_i__exc_req_q(
  u_ibex_core.id_stage_i.controller_i.exc_req_q),
.u_ibex_core__id_stage_i__controller_i__exc_req_q_t0(
  u_ibex_core.id_stage_i.controller_i.exc_req_q_t0),
.u_ibex_core__id_stage_i__controller_i__g_intg_irq_int__entering_nmi(
  u_ibex_core.id_stage_i.controller_i.\g_intg_irq_int.entering_nmi ),
.u_ibex_core__id_stage_i__controller_i__g_intg_irq_int__entering_nmi_t0(
  u_ibex_core.id_stage_i.controller_i.\g_intg_irq_int.entering_nmi_t0 ),
.u_ibex_core__id_stage_i__controller_i__g_intg_irq_int__mem_resp_intg_err_addr_q(
  u_ibex_core.id_stage_i.controller_i.\g_intg_irq_int.mem_resp_intg_err_addr_q ),
.u_ibex_core__id_stage_i__controller_i__g_intg_irq_int__mem_resp_intg_err_addr_q_t0(
  u_ibex_core.id_stage_i.controller_i.\g_intg_irq_int.mem_resp_intg_err_addr_q_t0 ),
.u_ibex_core__id_stage_i__controller_i__g_intg_irq_int__mem_resp_intg_err_irq_clear(
  u_ibex_core.id_stage_i.controller_i.\g_intg_irq_int.mem_resp_intg_err_irq_clear ),
.u_ibex_core__id_stage_i__controller_i__g_intg_irq_int__mem_resp_intg_err_irq_clear_t0(
  u_ibex_core.id_stage_i.controller_i.\g_intg_irq_int.mem_resp_intg_err_irq_clear_t0 ),
.u_ibex_core__id_stage_i__controller_i__g_intg_irq_int__mem_resp_intg_err_irq_pending_d(
  u_ibex_core.id_stage_i.controller_i.\g_intg_irq_int.mem_resp_intg_err_irq_pending_d ),
.u_ibex_core__id_stage_i__controller_i__g_intg_irq_int__mem_resp_intg_err_irq_pending_d_t0(
  u_ibex_core.id_stage_i.controller_i.\g_intg_irq_int.mem_resp_intg_err_irq_pending_d_t0 ),
.u_ibex_core__id_stage_i__controller_i__g_intg_irq_int__mem_resp_intg_err_irq_pending_q(
  u_ibex_core.id_stage_i.controller_i.\g_intg_irq_int.mem_resp_intg_err_irq_pending_q ),
.u_ibex_core__id_stage_i__controller_i__g_intg_irq_int__mem_resp_intg_err_irq_pending_q_t0(
  u_ibex_core.id_stage_i.controller_i.\g_intg_irq_int.mem_resp_intg_err_irq_pending_q_t0 ),
.u_ibex_core__id_stage_i__controller_i__g_intg_irq_int__mem_resp_intg_err_irq_set(
  u_ibex_core.id_stage_i.controller_i.\g_intg_irq_int.mem_resp_intg_err_irq_set ),
.u_ibex_core__id_stage_i__controller_i__g_intg_irq_int__mem_resp_intg_err_irq_set_t0(
  u_ibex_core.id_stage_i.controller_i.\g_intg_irq_int.mem_resp_intg_err_irq_set_t0 ),
.u_ibex_core__id_stage_i__controller_i__halt_if(
  u_ibex_core.id_stage_i.controller_i.halt_if),
.u_ibex_core__id_stage_i__controller_i__halt_if_t0(
  u_ibex_core.id_stage_i.controller_i.halt_if_t0),
.u_ibex_core__id_stage_i__controller_i__handle_irq(
  u_ibex_core.id_stage_i.controller_i.handle_irq),
.u_ibex_core__id_stage_i__controller_i__handle_irq_t0(
  u_ibex_core.id_stage_i.controller_i.handle_irq_t0),
.u_ibex_core__id_stage_i__controller_i__id_wb_pending(
  u_ibex_core.id_stage_i.controller_i.id_wb_pending),
.u_ibex_core__id_stage_i__controller_i__id_wb_pending_t0(
  u_ibex_core.id_stage_i.controller_i.id_wb_pending_t0),
.u_ibex_core__id_stage_i__controller_i__illegal_insn_d(
  u_ibex_core.id_stage_i.controller_i.illegal_insn_d),
.u_ibex_core__id_stage_i__controller_i__illegal_insn_d_t0(
  u_ibex_core.id_stage_i.controller_i.illegal_insn_d_t0),
.u_ibex_core__id_stage_i__controller_i__illegal_insn_prio(
  u_ibex_core.id_stage_i.controller_i.illegal_insn_prio),
.u_ibex_core__id_stage_i__controller_i__illegal_insn_prio_t0(
  u_ibex_core.id_stage_i.controller_i.illegal_insn_prio_t0),
.u_ibex_core__id_stage_i__controller_i__illegal_insn_q(
  u_ibex_core.id_stage_i.controller_i.illegal_insn_q),
.u_ibex_core__id_stage_i__controller_i__illegal_insn_q_t0(
  u_ibex_core.id_stage_i.controller_i.illegal_insn_q_t0),
.u_ibex_core__id_stage_i__controller_i__instr_fetch_err(
  u_ibex_core.id_stage_i.controller_i.instr_fetch_err),
.u_ibex_core__id_stage_i__controller_i__instr_fetch_err_prio(
  u_ibex_core.id_stage_i.controller_i.instr_fetch_err_prio),
.u_ibex_core__id_stage_i__controller_i__instr_fetch_err_prio_t0(
  u_ibex_core.id_stage_i.controller_i.instr_fetch_err_prio_t0),
.u_ibex_core__id_stage_i__controller_i__instr_fetch_err_t0(
  u_ibex_core.id_stage_i.controller_i.instr_fetch_err_t0),
.u_ibex_core__id_stage_i__controller_i__irq_enabled(
  u_ibex_core.id_stage_i.controller_i.irq_enabled),
.u_ibex_core__id_stage_i__controller_i__irq_enabled_t0(
  u_ibex_core.id_stage_i.controller_i.irq_enabled_t0),
.u_ibex_core__id_stage_i__controller_i__irq_nm(
  u_ibex_core.id_stage_i.controller_i.irq_nm),
.u_ibex_core__id_stage_i__controller_i__irq_nm_int(
  u_ibex_core.id_stage_i.controller_i.irq_nm_int),
.u_ibex_core__id_stage_i__controller_i__irq_nm_int_t0(
  u_ibex_core.id_stage_i.controller_i.irq_nm_int_t0),
.u_ibex_core__id_stage_i__controller_i__irq_nm_t0(
  u_ibex_core.id_stage_i.controller_i.irq_nm_t0),
.u_ibex_core__id_stage_i__controller_i__load_err_prio(
  u_ibex_core.id_stage_i.controller_i.load_err_prio),
.u_ibex_core__id_stage_i__controller_i__load_err_prio_t0(
  u_ibex_core.id_stage_i.controller_i.load_err_prio_t0),
.u_ibex_core__id_stage_i__controller_i__load_err_q(
  u_ibex_core.id_stage_i.controller_i.load_err_q),
.u_ibex_core__id_stage_i__controller_i__load_err_q_t0(
  u_ibex_core.id_stage_i.controller_i.load_err_q_t0),
.u_ibex_core__id_stage_i__controller_i__mfip_id(
  u_ibex_core.id_stage_i.controller_i.mfip_id),
.u_ibex_core__id_stage_i__controller_i__mfip_id_t0(
  u_ibex_core.id_stage_i.controller_i.mfip_id_t0),
.u_ibex_core__id_stage_i__controller_i__mret_insn(
  u_ibex_core.id_stage_i.controller_i.mret_insn),
.u_ibex_core__id_stage_i__controller_i__mret_insn_t0(
  u_ibex_core.id_stage_i.controller_i.mret_insn_t0),
.u_ibex_core__id_stage_i__controller_i__nmi_mode_d(
  u_ibex_core.id_stage_i.controller_i.nmi_mode_d),
.u_ibex_core__id_stage_i__controller_i__nmi_mode_d_t0(
  u_ibex_core.id_stage_i.controller_i.nmi_mode_d_t0),
.u_ibex_core__id_stage_i__controller_i__retain_id(
  u_ibex_core.id_stage_i.controller_i.retain_id),
.u_ibex_core__id_stage_i__controller_i__retain_id_t0(
  u_ibex_core.id_stage_i.controller_i.retain_id_t0),
.u_ibex_core__id_stage_i__controller_i__special_req(
  u_ibex_core.id_stage_i.controller_i.special_req),
.u_ibex_core__id_stage_i__controller_i__special_req_flush_only(
  u_ibex_core.id_stage_i.controller_i.special_req_flush_only),
.u_ibex_core__id_stage_i__controller_i__special_req_flush_only_t0(
  u_ibex_core.id_stage_i.controller_i.special_req_flush_only_t0),
.u_ibex_core__id_stage_i__controller_i__special_req_pc_change(
  u_ibex_core.id_stage_i.controller_i.special_req_pc_change),
.u_ibex_core__id_stage_i__controller_i__special_req_pc_change_t0(
  u_ibex_core.id_stage_i.controller_i.special_req_pc_change_t0),
.u_ibex_core__id_stage_i__controller_i__special_req_t0(
  u_ibex_core.id_stage_i.controller_i.special_req_t0),
.u_ibex_core__id_stage_i__controller_i__stall(
  u_ibex_core.id_stage_i.controller_i.stall),
.u_ibex_core__id_stage_i__controller_i__stall_t0(
  u_ibex_core.id_stage_i.controller_i.stall_t0),
.u_ibex_core__id_stage_i__controller_i__store_err_prio(
  u_ibex_core.id_stage_i.controller_i.store_err_prio),
.u_ibex_core__id_stage_i__controller_i__store_err_prio_t0(
  u_ibex_core.id_stage_i.controller_i.store_err_prio_t0),
.u_ibex_core__id_stage_i__controller_i__store_err_q(
  u_ibex_core.id_stage_i.controller_i.store_err_q),
.u_ibex_core__id_stage_i__controller_i__wfi_insn(
  u_ibex_core.id_stage_i.controller_i.wfi_insn),
.u_ibex_core__id_stage_i__controller_i__wfi_insn_t0(
  u_ibex_core.id_stage_i.controller_i.wfi_insn_t0),
.u_ibex_core__id_stage_i__decoder_i__clk_i(
  u_ibex_core.id_stage_i.decoder_i.clk_i),
.u_ibex_core__id_stage_i__decoder_i__rst_ni(
  u_ibex_core.id_stage_i.decoder_i.rst_ni),
.u_ibex_core__id_stage_i__decoder_i__illegal_insn_o(
  u_ibex_core.id_stage_i.decoder_i.illegal_insn_o),
.u_ibex_core__id_stage_i__decoder_i__ebrk_insn_o(
  u_ibex_core.id_stage_i.decoder_i.ebrk_insn_o),
.u_ibex_core__id_stage_i__decoder_i__mret_insn_o(
  u_ibex_core.id_stage_i.decoder_i.mret_insn_o),
.u_ibex_core__id_stage_i__decoder_i__dret_insn_o(
  u_ibex_core.id_stage_i.decoder_i.dret_insn_o),
.u_ibex_core__id_stage_i__decoder_i__ecall_insn_o(
  u_ibex_core.id_stage_i.decoder_i.ecall_insn_o),
.u_ibex_core__id_stage_i__decoder_i__wfi_insn_o(
  u_ibex_core.id_stage_i.decoder_i.wfi_insn_o),
.u_ibex_core__id_stage_i__decoder_i__jump_set_o(
  u_ibex_core.id_stage_i.decoder_i.jump_set_o),
.u_ibex_core__id_stage_i__decoder_i__branch_taken_i(
  u_ibex_core.id_stage_i.decoder_i.branch_taken_i),
.u_ibex_core__id_stage_i__decoder_i__icache_inval_o(
  u_ibex_core.id_stage_i.decoder_i.icache_inval_o),
.u_ibex_core__id_stage_i__decoder_i__instr_first_cycle_i(
  u_ibex_core.id_stage_i.decoder_i.instr_first_cycle_i),
.u_ibex_core__id_stage_i__decoder_i__instr_rdata_i(
  u_ibex_core.id_stage_i.decoder_i.instr_rdata_i),
.u_ibex_core__id_stage_i__decoder_i__instr_rdata_alu_i(
  u_ibex_core.id_stage_i.decoder_i.instr_rdata_alu_i),
.u_ibex_core__id_stage_i__decoder_i__illegal_c_insn_i(
  u_ibex_core.id_stage_i.decoder_i.illegal_c_insn_i),
.u_ibex_core__id_stage_i__decoder_i__imm_a_mux_sel_o(
  u_ibex_core.id_stage_i.decoder_i.imm_a_mux_sel_o),
.u_ibex_core__id_stage_i__decoder_i__imm_b_mux_sel_o(
  u_ibex_core.id_stage_i.decoder_i.imm_b_mux_sel_o),
.u_ibex_core__id_stage_i__decoder_i__bt_a_mux_sel_o(
  u_ibex_core.id_stage_i.decoder_i.bt_a_mux_sel_o),
.u_ibex_core__id_stage_i__decoder_i__bt_b_mux_sel_o(
  u_ibex_core.id_stage_i.decoder_i.bt_b_mux_sel_o),
.u_ibex_core__id_stage_i__decoder_i__imm_i_type_o(
  u_ibex_core.id_stage_i.decoder_i.imm_i_type_o),
.u_ibex_core__id_stage_i__decoder_i__imm_s_type_o(
  u_ibex_core.id_stage_i.decoder_i.imm_s_type_o),
.u_ibex_core__id_stage_i__decoder_i__imm_b_type_o(
  u_ibex_core.id_stage_i.decoder_i.imm_b_type_o),
.u_ibex_core__id_stage_i__decoder_i__imm_u_type_o(
  u_ibex_core.id_stage_i.decoder_i.imm_u_type_o),
.u_ibex_core__id_stage_i__decoder_i__imm_j_type_o(
  u_ibex_core.id_stage_i.decoder_i.imm_j_type_o),
.u_ibex_core__id_stage_i__decoder_i__zimm_rs1_type_o(
  u_ibex_core.id_stage_i.decoder_i.zimm_rs1_type_o),
.u_ibex_core__id_stage_i__decoder_i__rf_wdata_sel_o(
  u_ibex_core.id_stage_i.decoder_i.rf_wdata_sel_o),
.u_ibex_core__id_stage_i__decoder_i__rf_we_o(
  u_ibex_core.id_stage_i.decoder_i.rf_we_o),
.u_ibex_core__id_stage_i__decoder_i__rf_raddr_a_o(
  u_ibex_core.id_stage_i.decoder_i.rf_raddr_a_o),
.u_ibex_core__id_stage_i__decoder_i__rf_raddr_b_o(
  u_ibex_core.id_stage_i.decoder_i.rf_raddr_b_o),
.u_ibex_core__id_stage_i__decoder_i__rf_waddr_o(
  u_ibex_core.id_stage_i.decoder_i.rf_waddr_o),
.u_ibex_core__id_stage_i__decoder_i__rf_ren_a_o(
  u_ibex_core.id_stage_i.decoder_i.rf_ren_a_o),
.u_ibex_core__id_stage_i__decoder_i__rf_ren_b_o(
  u_ibex_core.id_stage_i.decoder_i.rf_ren_b_o),
.u_ibex_core__id_stage_i__decoder_i__alu_operator_o(
  u_ibex_core.id_stage_i.decoder_i.alu_operator_o),
.u_ibex_core__id_stage_i__decoder_i__alu_op_a_mux_sel_o(
  u_ibex_core.id_stage_i.decoder_i.alu_op_a_mux_sel_o),
.u_ibex_core__id_stage_i__decoder_i__alu_op_b_mux_sel_o(
  u_ibex_core.id_stage_i.decoder_i.alu_op_b_mux_sel_o),
.u_ibex_core__id_stage_i__decoder_i__alu_multicycle_o(
  u_ibex_core.id_stage_i.decoder_i.alu_multicycle_o),
.u_ibex_core__id_stage_i__decoder_i__mult_en_o(
  u_ibex_core.id_stage_i.decoder_i.mult_en_o),
.u_ibex_core__id_stage_i__decoder_i__div_en_o(
  u_ibex_core.id_stage_i.decoder_i.div_en_o),
.u_ibex_core__id_stage_i__decoder_i__mult_sel_o(
  u_ibex_core.id_stage_i.decoder_i.mult_sel_o),
.u_ibex_core__id_stage_i__decoder_i__div_sel_o(
  u_ibex_core.id_stage_i.decoder_i.div_sel_o),
.u_ibex_core__id_stage_i__decoder_i__multdiv_operator_o(
  u_ibex_core.id_stage_i.decoder_i.multdiv_operator_o),
.u_ibex_core__id_stage_i__decoder_i__multdiv_signed_mode_o(
  u_ibex_core.id_stage_i.decoder_i.multdiv_signed_mode_o),
.u_ibex_core__id_stage_i__decoder_i__csr_access_o(
  u_ibex_core.id_stage_i.decoder_i.csr_access_o),
.u_ibex_core__id_stage_i__decoder_i__csr_op_o(
  u_ibex_core.id_stage_i.decoder_i.csr_op_o),
.u_ibex_core__id_stage_i__decoder_i__data_req_o(
  u_ibex_core.id_stage_i.decoder_i.data_req_o),
.u_ibex_core__id_stage_i__decoder_i__data_we_o(
  u_ibex_core.id_stage_i.decoder_i.data_we_o),
.u_ibex_core__id_stage_i__decoder_i__data_type_o(
  u_ibex_core.id_stage_i.decoder_i.data_type_o),
.u_ibex_core__id_stage_i__decoder_i__data_sign_extension_o(
  u_ibex_core.id_stage_i.decoder_i.data_sign_extension_o),
.u_ibex_core__id_stage_i__decoder_i__jump_in_dec_o(
  u_ibex_core.id_stage_i.decoder_i.jump_in_dec_o),
.u_ibex_core__id_stage_i__decoder_i__branch_in_dec_o(
  u_ibex_core.id_stage_i.decoder_i.branch_in_dec_o),
.u_ibex_core__id_stage_i__decoder_i__instr_rdata_i_t0(
  u_ibex_core.id_stage_i.decoder_i.instr_rdata_i_t0),
.u_ibex_core__id_stage_i__decoder_i__alu_op_a_mux_sel_o_t0(
  u_ibex_core.id_stage_i.decoder_i.alu_op_a_mux_sel_o_t0),
.u_ibex_core__id_stage_i__decoder_i__alu_op_b_mux_sel_o_t0(
  u_ibex_core.id_stage_i.decoder_i.alu_op_b_mux_sel_o_t0),
.u_ibex_core__id_stage_i__decoder_i__alu_operator_o_t0(
  u_ibex_core.id_stage_i.decoder_i.alu_operator_o_t0),
.u_ibex_core__id_stage_i__decoder_i__branch_taken_i_t0(
  u_ibex_core.id_stage_i.decoder_i.branch_taken_i_t0),
.u_ibex_core__id_stage_i__decoder_i__bt_a_mux_sel_o_t0(
  u_ibex_core.id_stage_i.decoder_i.bt_a_mux_sel_o_t0),
.u_ibex_core__id_stage_i__decoder_i__bt_b_mux_sel_o_t0(
  u_ibex_core.id_stage_i.decoder_i.bt_b_mux_sel_o_t0),
.u_ibex_core__id_stage_i__decoder_i__csr_access_o_t0(
  u_ibex_core.id_stage_i.decoder_i.csr_access_o_t0),
.u_ibex_core__id_stage_i__decoder_i__csr_op_o_t0(
  u_ibex_core.id_stage_i.decoder_i.csr_op_o_t0),
.u_ibex_core__id_stage_i__decoder_i__data_req_o_t0(
  u_ibex_core.id_stage_i.decoder_i.data_req_o_t0),
.u_ibex_core__id_stage_i__decoder_i__data_sign_extension_o_t0(
  u_ibex_core.id_stage_i.decoder_i.data_sign_extension_o_t0),
.u_ibex_core__id_stage_i__decoder_i__data_type_o_t0(
  u_ibex_core.id_stage_i.decoder_i.data_type_o_t0),
.u_ibex_core__id_stage_i__decoder_i__data_we_o_t0(
  u_ibex_core.id_stage_i.decoder_i.data_we_o_t0),
.u_ibex_core__id_stage_i__decoder_i__div_en_o_t0(
  u_ibex_core.id_stage_i.decoder_i.div_en_o_t0),
.u_ibex_core__id_stage_i__decoder_i__dret_insn_o_t0(
  u_ibex_core.id_stage_i.decoder_i.dret_insn_o_t0),
.u_ibex_core__id_stage_i__decoder_i__ebrk_insn_o_t0(
  u_ibex_core.id_stage_i.decoder_i.ebrk_insn_o_t0),
.u_ibex_core__id_stage_i__decoder_i__ecall_insn_o_t0(
  u_ibex_core.id_stage_i.decoder_i.ecall_insn_o_t0),
.u_ibex_core__id_stage_i__decoder_i__icache_inval_o_t0(
  u_ibex_core.id_stage_i.decoder_i.icache_inval_o_t0),
.u_ibex_core__id_stage_i__decoder_i__illegal_c_insn_i_t0(
  u_ibex_core.id_stage_i.decoder_i.illegal_c_insn_i_t0),
.u_ibex_core__id_stage_i__decoder_i__illegal_insn_o_t0(
  u_ibex_core.id_stage_i.decoder_i.illegal_insn_o_t0),
.u_ibex_core__id_stage_i__decoder_i__imm_a_mux_sel_o_t0(
  u_ibex_core.id_stage_i.decoder_i.imm_a_mux_sel_o_t0),
.u_ibex_core__id_stage_i__decoder_i__imm_b_mux_sel_o_t0(
  u_ibex_core.id_stage_i.decoder_i.imm_b_mux_sel_o_t0),
.u_ibex_core__id_stage_i__decoder_i__imm_b_type_o_t0(
  u_ibex_core.id_stage_i.decoder_i.imm_b_type_o_t0),
.u_ibex_core__id_stage_i__decoder_i__imm_i_type_o_t0(
  u_ibex_core.id_stage_i.decoder_i.imm_i_type_o_t0),
.u_ibex_core__id_stage_i__decoder_i__imm_j_type_o_t0(
  u_ibex_core.id_stage_i.decoder_i.imm_j_type_o_t0),
.u_ibex_core__id_stage_i__decoder_i__imm_u_type_o_t0(
  u_ibex_core.id_stage_i.decoder_i.imm_u_type_o_t0),
.u_ibex_core__id_stage_i__decoder_i__instr_first_cycle_i_t0(
  u_ibex_core.id_stage_i.decoder_i.instr_first_cycle_i_t0),
.u_ibex_core__id_stage_i__decoder_i__instr_rdata_alu_i_t0(
  u_ibex_core.id_stage_i.decoder_i.instr_rdata_alu_i_t0),
.u_ibex_core__id_stage_i__decoder_i__jump_in_dec_o_t0(
  u_ibex_core.id_stage_i.decoder_i.jump_in_dec_o_t0),
.u_ibex_core__id_stage_i__decoder_i__jump_set_o_t0(
  u_ibex_core.id_stage_i.decoder_i.jump_set_o_t0),
.u_ibex_core__id_stage_i__decoder_i__mret_insn_o_t0(
  u_ibex_core.id_stage_i.decoder_i.mret_insn_o_t0),
.u_ibex_core__id_stage_i__decoder_i__mult_en_o_t0(
  u_ibex_core.id_stage_i.decoder_i.mult_en_o_t0),
.u_ibex_core__id_stage_i__decoder_i__multdiv_operator_o_t0(
  u_ibex_core.id_stage_i.decoder_i.multdiv_operator_o_t0),
.u_ibex_core__id_stage_i__decoder_i__multdiv_signed_mode_o_t0(
  u_ibex_core.id_stage_i.decoder_i.multdiv_signed_mode_o_t0),
.u_ibex_core__id_stage_i__decoder_i__rf_raddr_a_o_t0(
  u_ibex_core.id_stage_i.decoder_i.rf_raddr_a_o_t0),
.u_ibex_core__id_stage_i__decoder_i__rf_raddr_b_o_t0(
  u_ibex_core.id_stage_i.decoder_i.rf_raddr_b_o_t0),
.u_ibex_core__id_stage_i__decoder_i__rf_ren_a_o_t0(
  u_ibex_core.id_stage_i.decoder_i.rf_ren_a_o_t0),
.u_ibex_core__id_stage_i__decoder_i__rf_ren_b_o_t0(
  u_ibex_core.id_stage_i.decoder_i.rf_ren_b_o_t0),
.u_ibex_core__id_stage_i__decoder_i__rf_waddr_o_t0(
  u_ibex_core.id_stage_i.decoder_i.rf_waddr_o_t0),
.u_ibex_core__id_stage_i__decoder_i__rf_wdata_sel_o_t0(
  u_ibex_core.id_stage_i.decoder_i.rf_wdata_sel_o_t0),
.u_ibex_core__id_stage_i__decoder_i__wfi_insn_o_t0(
  u_ibex_core.id_stage_i.decoder_i.wfi_insn_o_t0),
.u_ibex_core__id_stage_i__decoder_i__zimm_rs1_type_o_t0(
  u_ibex_core.id_stage_i.decoder_i.zimm_rs1_type_o_t0),
.u_ibex_core__id_stage_i__decoder_i__alu_multicycle_o_t0(
  u_ibex_core.id_stage_i.decoder_i.alu_multicycle_o_t0),
.u_ibex_core__id_stage_i__decoder_i__branch_in_dec_o_t0(
  u_ibex_core.id_stage_i.decoder_i.branch_in_dec_o_t0),
.u_ibex_core__id_stage_i__decoder_i__div_sel_o_t0(
  u_ibex_core.id_stage_i.decoder_i.div_sel_o_t0),
.u_ibex_core__id_stage_i__decoder_i__imm_s_type_o_t0(
  u_ibex_core.id_stage_i.decoder_i.imm_s_type_o_t0),
.u_ibex_core__id_stage_i__decoder_i__mult_sel_o_t0(
  u_ibex_core.id_stage_i.decoder_i.mult_sel_o_t0),
.u_ibex_core__id_stage_i__decoder_i__rf_we_o_t0(
  u_ibex_core.id_stage_i.decoder_i.rf_we_o_t0),
.u_ibex_core__id_stage_i__decoder_i__csr_op(
  u_ibex_core.id_stage_i.decoder_i.csr_op),
.u_ibex_core__id_stage_i__decoder_i__csr_op_t0(
  u_ibex_core.id_stage_i.decoder_i.csr_op_t0),
.u_ibex_core__if_stage_i__clk_i(
  u_ibex_core.if_stage_i.clk_i),
.u_ibex_core__if_stage_i__rst_ni(
  u_ibex_core.if_stage_i.rst_ni),
.u_ibex_core__if_stage_i__boot_addr_i(
  u_ibex_core.if_stage_i.boot_addr_i),
.u_ibex_core__if_stage_i__req_i(
  u_ibex_core.if_stage_i.req_i),
.u_ibex_core__if_stage_i__instr_req_o(
  u_ibex_core.if_stage_i.instr_req_o),
.u_ibex_core__if_stage_i__instr_addr_o(
  u_ibex_core.if_stage_i.instr_addr_o),
.u_ibex_core__if_stage_i__instr_gnt_i(
  u_ibex_core.if_stage_i.instr_gnt_i),
.u_ibex_core__if_stage_i__instr_rvalid_i(
  u_ibex_core.if_stage_i.instr_rvalid_i),
.u_ibex_core__if_stage_i__instr_rdata_i(
  u_ibex_core.if_stage_i.instr_rdata_i),
.u_ibex_core__if_stage_i__instr_bus_err_i(
  u_ibex_core.if_stage_i.instr_bus_err_i),
.u_ibex_core__if_stage_i__instr_intg_err_o(
  u_ibex_core.if_stage_i.instr_intg_err_o),
.u_ibex_core__if_stage_i__ic_tag_req_o(
  u_ibex_core.if_stage_i.ic_tag_req_o),
.u_ibex_core__if_stage_i__ic_tag_write_o(
  u_ibex_core.if_stage_i.ic_tag_write_o),
.u_ibex_core__if_stage_i__ic_tag_addr_o(
  u_ibex_core.if_stage_i.ic_tag_addr_o),
.u_ibex_core__if_stage_i__ic_tag_wdata_o(
  u_ibex_core.if_stage_i.ic_tag_wdata_o),
.u_ibex_core__if_stage_i__ic_tag_rdata_i(
  u_ibex_core.if_stage_i.ic_tag_rdata_i),
.u_ibex_core__if_stage_i__ic_data_req_o(
  u_ibex_core.if_stage_i.ic_data_req_o),
.u_ibex_core__if_stage_i__ic_data_write_o(
  u_ibex_core.if_stage_i.ic_data_write_o),
.u_ibex_core__if_stage_i__ic_data_addr_o(
  u_ibex_core.if_stage_i.ic_data_addr_o),
.u_ibex_core__if_stage_i__ic_data_wdata_o(
  u_ibex_core.if_stage_i.ic_data_wdata_o),
.u_ibex_core__if_stage_i__ic_data_rdata_i(
  u_ibex_core.if_stage_i.ic_data_rdata_i),
.u_ibex_core__if_stage_i__ic_scr_key_valid_i(
  u_ibex_core.if_stage_i.ic_scr_key_valid_i),
.u_ibex_core__if_stage_i__ic_scr_key_req_o(
  u_ibex_core.if_stage_i.ic_scr_key_req_o),
.u_ibex_core__if_stage_i__instr_valid_id_o(
  u_ibex_core.if_stage_i.instr_valid_id_o),
.u_ibex_core__if_stage_i__instr_new_id_o(
  u_ibex_core.if_stage_i.instr_new_id_o),
.u_ibex_core__if_stage_i__instr_rdata_id_o(
  u_ibex_core.if_stage_i.instr_rdata_id_o),
.u_ibex_core__if_stage_i__instr_rdata_alu_id_o(
  u_ibex_core.if_stage_i.instr_rdata_alu_id_o),
.u_ibex_core__if_stage_i__instr_rdata_c_id_o(
  u_ibex_core.if_stage_i.instr_rdata_c_id_o),
.u_ibex_core__if_stage_i__instr_is_compressed_id_o(
  u_ibex_core.if_stage_i.instr_is_compressed_id_o),
.u_ibex_core__if_stage_i__instr_bp_taken_o(
  u_ibex_core.if_stage_i.instr_bp_taken_o),
.u_ibex_core__if_stage_i__instr_fetch_err_o(
  u_ibex_core.if_stage_i.instr_fetch_err_o),
.u_ibex_core__if_stage_i__instr_fetch_err_plus2_o(
  u_ibex_core.if_stage_i.instr_fetch_err_plus2_o),
.u_ibex_core__if_stage_i__illegal_c_insn_id_o(
  u_ibex_core.if_stage_i.illegal_c_insn_id_o),
.u_ibex_core__if_stage_i__dummy_instr_id_o(
  u_ibex_core.if_stage_i.dummy_instr_id_o),
.u_ibex_core__if_stage_i__pc_if_o(
  u_ibex_core.if_stage_i.pc_if_o),
.u_ibex_core__if_stage_i__pc_id_o(
  u_ibex_core.if_stage_i.pc_id_o),
.u_ibex_core__if_stage_i__pmp_err_if_i(
  u_ibex_core.if_stage_i.pmp_err_if_i),
.u_ibex_core__if_stage_i__pmp_err_if_plus2_i(
  u_ibex_core.if_stage_i.pmp_err_if_plus2_i),
.u_ibex_core__if_stage_i__instr_valid_clear_i(
  u_ibex_core.if_stage_i.instr_valid_clear_i),
.u_ibex_core__if_stage_i__pc_set_i(
  u_ibex_core.if_stage_i.pc_set_i),
.u_ibex_core__if_stage_i__pc_mux_i(
  u_ibex_core.if_stage_i.pc_mux_i),
.u_ibex_core__if_stage_i__nt_branch_mispredict_i(
  u_ibex_core.if_stage_i.nt_branch_mispredict_i),
.u_ibex_core__if_stage_i__nt_branch_addr_i(
  u_ibex_core.if_stage_i.nt_branch_addr_i),
.u_ibex_core__if_stage_i__exc_pc_mux_i(
  u_ibex_core.if_stage_i.exc_pc_mux_i),
.u_ibex_core__if_stage_i__exc_cause(
  u_ibex_core.if_stage_i.exc_cause),
.u_ibex_core__if_stage_i__dummy_instr_en_i(
  u_ibex_core.if_stage_i.dummy_instr_en_i),
.u_ibex_core__if_stage_i__dummy_instr_mask_i(
  u_ibex_core.if_stage_i.dummy_instr_mask_i),
.u_ibex_core__if_stage_i__dummy_instr_seed_en_i(
  u_ibex_core.if_stage_i.dummy_instr_seed_en_i),
.u_ibex_core__if_stage_i__dummy_instr_seed_i(
  u_ibex_core.if_stage_i.dummy_instr_seed_i),
.u_ibex_core__if_stage_i__icache_enable_i(
  u_ibex_core.if_stage_i.icache_enable_i),
.u_ibex_core__if_stage_i__icache_inval_i(
  u_ibex_core.if_stage_i.icache_inval_i),
.u_ibex_core__if_stage_i__icache_ecc_error_o(
  u_ibex_core.if_stage_i.icache_ecc_error_o),
.u_ibex_core__if_stage_i__branch_target_ex_i(
  u_ibex_core.if_stage_i.branch_target_ex_i),
.u_ibex_core__if_stage_i__csr_mepc_i(
  u_ibex_core.if_stage_i.csr_mepc_i),
.u_ibex_core__if_stage_i__csr_depc_i(
  u_ibex_core.if_stage_i.csr_depc_i),
.u_ibex_core__if_stage_i__csr_mtvec_i(
  u_ibex_core.if_stage_i.csr_mtvec_i),
.u_ibex_core__if_stage_i__csr_mtvec_init_o(
  u_ibex_core.if_stage_i.csr_mtvec_init_o),
.u_ibex_core__if_stage_i__id_in_ready_i(
  u_ibex_core.if_stage_i.id_in_ready_i),
.u_ibex_core__if_stage_i__pc_mismatch_alert_o(
  u_ibex_core.if_stage_i.pc_mismatch_alert_o),
.u_ibex_core__if_stage_i__if_busy_o(
  u_ibex_core.if_stage_i.if_busy_o),
.u_ibex_core__if_stage_i__pmp_err_if_plus2_i_t0(
  u_ibex_core.if_stage_i.pmp_err_if_plus2_i_t0),
.u_ibex_core__if_stage_i__instr_addr_o_t0(
  u_ibex_core.if_stage_i.instr_addr_o_t0),
.u_ibex_core__if_stage_i__instr_gnt_i_t0(
  u_ibex_core.if_stage_i.instr_gnt_i_t0),
.u_ibex_core__if_stage_i__req_i_t0(
  u_ibex_core.if_stage_i.req_i_t0),
.u_ibex_core__if_stage_i__instr_rvalid_i_t0(
  u_ibex_core.if_stage_i.instr_rvalid_i_t0),
.u_ibex_core__if_stage_i__pmp_err_if_i_t0(
  u_ibex_core.if_stage_i.pmp_err_if_i_t0),
.u_ibex_core__if_stage_i__pc_set_i_t0(
  u_ibex_core.if_stage_i.pc_set_i_t0),
.u_ibex_core__if_stage_i__pc_mux_i_t0(
  u_ibex_core.if_stage_i.pc_mux_i_t0),
.u_ibex_core__if_stage_i__pc_mismatch_alert_o_t0(
  u_ibex_core.if_stage_i.pc_mismatch_alert_o_t0),
.u_ibex_core__if_stage_i__pc_if_o_t0(
  u_ibex_core.if_stage_i.pc_if_o_t0),
.u_ibex_core__if_stage_i__pc_id_o_t0(
  u_ibex_core.if_stage_i.pc_id_o_t0),
.u_ibex_core__if_stage_i__nt_branch_mispredict_i_t0(
  u_ibex_core.if_stage_i.nt_branch_mispredict_i_t0),
.u_ibex_core__if_stage_i__nt_branch_addr_i_t0(
  u_ibex_core.if_stage_i.nt_branch_addr_i_t0),
.u_ibex_core__if_stage_i__instr_valid_id_o_t0(
  u_ibex_core.if_stage_i.instr_valid_id_o_t0),
.u_ibex_core__if_stage_i__instr_valid_clear_i_t0(
  u_ibex_core.if_stage_i.instr_valid_clear_i_t0),
.u_ibex_core__if_stage_i__instr_rdata_id_o_t0(
  u_ibex_core.if_stage_i.instr_rdata_id_o_t0),
.u_ibex_core__if_stage_i__instr_rdata_c_id_o_t0(
  u_ibex_core.if_stage_i.instr_rdata_c_id_o_t0),
.u_ibex_core__if_stage_i__instr_rdata_alu_id_o_t0(
  u_ibex_core.if_stage_i.instr_rdata_alu_id_o_t0),
.u_ibex_core__if_stage_i__instr_new_id_o_t0(
  u_ibex_core.if_stage_i.instr_new_id_o_t0),
.u_ibex_core__if_stage_i__instr_is_compressed_id_o_t0(
  u_ibex_core.if_stage_i.instr_is_compressed_id_o_t0),
.u_ibex_core__if_stage_i__instr_intg_err_o_t0(
  u_ibex_core.if_stage_i.instr_intg_err_o_t0),
.u_ibex_core__if_stage_i__instr_fetch_err_plus2_o_t0(
  u_ibex_core.if_stage_i.instr_fetch_err_plus2_o_t0),
.u_ibex_core__if_stage_i__instr_fetch_err_o_t0(
  u_ibex_core.if_stage_i.instr_fetch_err_o_t0),
.u_ibex_core__if_stage_i__instr_bus_err_i_t0(
  u_ibex_core.if_stage_i.instr_bus_err_i_t0),
.u_ibex_core__if_stage_i__instr_bp_taken_o_t0(
  u_ibex_core.if_stage_i.instr_bp_taken_o_t0),
.u_ibex_core__if_stage_i__illegal_c_insn_id_o_t0(
  u_ibex_core.if_stage_i.illegal_c_insn_id_o_t0),
.u_ibex_core__if_stage_i__if_busy_o_t0(
  u_ibex_core.if_stage_i.if_busy_o_t0),
.u_ibex_core__if_stage_i__icache_inval_i_t0(
  u_ibex_core.if_stage_i.icache_inval_i_t0),
.u_ibex_core__if_stage_i__icache_enable_i_t0(
  u_ibex_core.if_stage_i.icache_enable_i_t0),
.u_ibex_core__if_stage_i__icache_ecc_error_o_t0(
  u_ibex_core.if_stage_i.icache_ecc_error_o_t0),
.u_ibex_core__if_stage_i__ic_tag_write_o_t0(
  u_ibex_core.if_stage_i.ic_tag_write_o_t0),
.u_ibex_core__if_stage_i__ic_tag_wdata_o_t0(
  u_ibex_core.if_stage_i.ic_tag_wdata_o_t0),
.u_ibex_core__if_stage_i__ic_tag_req_o_t0(
  u_ibex_core.if_stage_i.ic_tag_req_o_t0),
.u_ibex_core__if_stage_i__ic_tag_rdata_i_t0(
  u_ibex_core.if_stage_i.ic_tag_rdata_i_t0),
.u_ibex_core__if_stage_i__ic_tag_addr_o_t0(
  u_ibex_core.if_stage_i.ic_tag_addr_o_t0),
.u_ibex_core__if_stage_i__ic_scr_key_valid_i_t0(
  u_ibex_core.if_stage_i.ic_scr_key_valid_i_t0),
.u_ibex_core__if_stage_i__ic_scr_key_req_o_t0(
  u_ibex_core.if_stage_i.ic_scr_key_req_o_t0),
.u_ibex_core__if_stage_i__ic_data_write_o_t0(
  u_ibex_core.if_stage_i.ic_data_write_o_t0),
.u_ibex_core__if_stage_i__ic_data_wdata_o_t0(
  u_ibex_core.if_stage_i.ic_data_wdata_o_t0),
.u_ibex_core__if_stage_i__ic_data_req_o_t0(
  u_ibex_core.if_stage_i.ic_data_req_o_t0),
.u_ibex_core__if_stage_i__ic_data_rdata_i_t0(
  u_ibex_core.if_stage_i.ic_data_rdata_i_t0),
.u_ibex_core__if_stage_i__ic_data_addr_o_t0(
  u_ibex_core.if_stage_i.ic_data_addr_o_t0),
.u_ibex_core__if_stage_i__exc_pc_mux_i_t0(
  u_ibex_core.if_stage_i.exc_pc_mux_i_t0),
.u_ibex_core__if_stage_i__exc_cause_t0(
  u_ibex_core.if_stage_i.exc_cause_t0),
.u_ibex_core__if_stage_i__dummy_instr_id_o_t0(
  u_ibex_core.if_stage_i.dummy_instr_id_o_t0),
.u_ibex_core__if_stage_i__csr_mtvec_init_o_t0(
  u_ibex_core.if_stage_i.csr_mtvec_init_o_t0),
.u_ibex_core__if_stage_i__csr_mtvec_i_t0(
  u_ibex_core.if_stage_i.csr_mtvec_i_t0),
.u_ibex_core__if_stage_i__csr_mepc_i_t0(
  u_ibex_core.if_stage_i.csr_mepc_i_t0),
.u_ibex_core__if_stage_i__csr_depc_i_t0(
  u_ibex_core.if_stage_i.csr_depc_i_t0),
.u_ibex_core__if_stage_i__branch_target_ex_i_t0(
  u_ibex_core.if_stage_i.branch_target_ex_i_t0),
.u_ibex_core__if_stage_i__boot_addr_i_t0(
  u_ibex_core.if_stage_i.boot_addr_i_t0),
.u_ibex_core__if_stage_i__id_in_ready_i_t0(
  u_ibex_core.if_stage_i.id_in_ready_i_t0),
.u_ibex_core__if_stage_i__dummy_instr_seed_i_t0(
  u_ibex_core.if_stage_i.dummy_instr_seed_i_t0),
.u_ibex_core__if_stage_i__dummy_instr_seed_en_i_t0(
  u_ibex_core.if_stage_i.dummy_instr_seed_en_i_t0),
.u_ibex_core__if_stage_i__dummy_instr_mask_i_t0(
  u_ibex_core.if_stage_i.dummy_instr_mask_i_t0),
.u_ibex_core__if_stage_i__dummy_instr_en_i_t0(
  u_ibex_core.if_stage_i.dummy_instr_en_i_t0),
.u_ibex_core__if_stage_i__instr_req_o_t0(
  u_ibex_core.if_stage_i.instr_req_o_t0),
.u_ibex_core__if_stage_i__instr_rdata_i_t0(
  u_ibex_core.if_stage_i.instr_rdata_i_t0),
.u_ibex_core__if_stage_i__branch_req(
  u_ibex_core.if_stage_i.branch_req),
.u_ibex_core__if_stage_i__branch_req_t0(
  u_ibex_core.if_stage_i.branch_req_t0),
.u_ibex_core__if_stage_i__exc_pc(
  u_ibex_core.if_stage_i.exc_pc),
.u_ibex_core__if_stage_i__exc_pc_t0(
  u_ibex_core.if_stage_i.exc_pc_t0),
.u_ibex_core__if_stage_i__fetch_addr(
  u_ibex_core.if_stage_i.fetch_addr),
.u_ibex_core__if_stage_i__fetch_addr_n(
  u_ibex_core.if_stage_i.fetch_addr_n),
.u_ibex_core__if_stage_i__fetch_addr_n_t0(
  u_ibex_core.if_stage_i.fetch_addr_n_t0),
.u_ibex_core__if_stage_i__fetch_addr_t0(
  u_ibex_core.if_stage_i.fetch_addr_t0),
.u_ibex_core__if_stage_i__fetch_err(
  u_ibex_core.if_stage_i.fetch_err),
.u_ibex_core__if_stage_i__fetch_err_plus2(
  u_ibex_core.if_stage_i.fetch_err_plus2),
.u_ibex_core__if_stage_i__fetch_err_plus2_t0(
  u_ibex_core.if_stage_i.fetch_err_plus2_t0),
.u_ibex_core__if_stage_i__fetch_err_t0(
  u_ibex_core.if_stage_i.fetch_err_t0),
.u_ibex_core__if_stage_i__fetch_rdata(
  u_ibex_core.if_stage_i.fetch_rdata),
.u_ibex_core__if_stage_i__fetch_rdata_t0(
  u_ibex_core.if_stage_i.fetch_rdata_t0),
.u_ibex_core__if_stage_i__fetch_ready(
  u_ibex_core.if_stage_i.fetch_ready),
.u_ibex_core__if_stage_i__fetch_ready_t0(
  u_ibex_core.if_stage_i.fetch_ready_t0),
.u_ibex_core__if_stage_i__fetch_valid(
  u_ibex_core.if_stage_i.fetch_valid),
.u_ibex_core__if_stage_i__fetch_valid_raw(
  u_ibex_core.if_stage_i.fetch_valid_raw),
.u_ibex_core__if_stage_i__fetch_valid_raw_t0(
  u_ibex_core.if_stage_i.fetch_valid_raw_t0),
.u_ibex_core__if_stage_i__fetch_valid_t0(
  u_ibex_core.if_stage_i.fetch_valid_t0),
.u_ibex_core__if_stage_i__g_branch_predictor__instr_bp_taken_d(
  u_ibex_core.if_stage_i.\g_branch_predictor.instr_bp_taken_d ),
.u_ibex_core__if_stage_i__g_branch_predictor__instr_bp_taken_d_t0(
  u_ibex_core.if_stage_i.\g_branch_predictor.instr_bp_taken_d_t0 ),
.u_ibex_core__if_stage_i__g_branch_predictor__instr_skid_addr_q(
  u_ibex_core.if_stage_i.\g_branch_predictor.instr_skid_addr_q ),
.u_ibex_core__if_stage_i__g_branch_predictor__instr_skid_addr_q_t0(
  u_ibex_core.if_stage_i.\g_branch_predictor.instr_skid_addr_q_t0 ),
.u_ibex_core__if_stage_i__g_branch_predictor__instr_skid_bp_taken_q(
  u_ibex_core.if_stage_i.\g_branch_predictor.instr_skid_bp_taken_q ),
.u_ibex_core__if_stage_i__g_branch_predictor__instr_skid_bp_taken_q_t0(
  u_ibex_core.if_stage_i.\g_branch_predictor.instr_skid_bp_taken_q_t0 ),
.u_ibex_core__if_stage_i__g_branch_predictor__instr_skid_data_q(
  u_ibex_core.if_stage_i.\g_branch_predictor.instr_skid_data_q ),
.u_ibex_core__if_stage_i__g_branch_predictor__instr_skid_data_q_t0(
  u_ibex_core.if_stage_i.\g_branch_predictor.instr_skid_data_q_t0 ),
.u_ibex_core__if_stage_i__g_branch_predictor__instr_skid_en(
  u_ibex_core.if_stage_i.\g_branch_predictor.instr_skid_en ),
.u_ibex_core__if_stage_i__g_branch_predictor__instr_skid_en_t0(
  u_ibex_core.if_stage_i.\g_branch_predictor.instr_skid_en_t0 ),
.u_ibex_core__if_stage_i__g_branch_predictor__instr_skid_valid_d(
  u_ibex_core.if_stage_i.\g_branch_predictor.instr_skid_valid_d ),
.u_ibex_core__if_stage_i__g_branch_predictor__instr_skid_valid_d_t0(
  u_ibex_core.if_stage_i.\g_branch_predictor.instr_skid_valid_d_t0 ),
.u_ibex_core__if_stage_i__g_branch_predictor__instr_skid_valid_q(
  u_ibex_core.if_stage_i.\g_branch_predictor.instr_skid_valid_q ),
.u_ibex_core__if_stage_i__g_branch_predictor__instr_skid_valid_q_t0(
  u_ibex_core.if_stage_i.\g_branch_predictor.instr_skid_valid_q_t0 ),
.u_ibex_core__if_stage_i__g_branch_predictor__predict_branch_taken_raw(
  u_ibex_core.if_stage_i.\g_branch_predictor.predict_branch_taken_raw ),
.u_ibex_core__if_stage_i__g_branch_predictor__predict_branch_taken_raw_t0(
  u_ibex_core.if_stage_i.\g_branch_predictor.predict_branch_taken_raw_t0 ),
.u_ibex_core__if_stage_i__g_mem_ecc__ecc_err(
  u_ibex_core.if_stage_i.\g_mem_ecc.ecc_err ),
.u_ibex_core__if_stage_i__g_mem_ecc__ecc_err_t0(
  u_ibex_core.if_stage_i.\g_mem_ecc.ecc_err_t0 ),
.u_ibex_core__if_stage_i__g_mem_ecc__instr_rdata_buf(
  u_ibex_core.if_stage_i.\g_mem_ecc.instr_rdata_buf ),
.u_ibex_core__if_stage_i__g_mem_ecc__instr_rdata_buf_t0(
  u_ibex_core.if_stage_i.\g_mem_ecc.instr_rdata_buf_t0 ),
.u_ibex_core__if_stage_i__g_secure_pc__prev_instr_addr_incr(
  u_ibex_core.if_stage_i.\g_secure_pc.prev_instr_addr_incr ),
.u_ibex_core__if_stage_i__g_secure_pc__prev_instr_addr_incr_buf(
  u_ibex_core.if_stage_i.\g_secure_pc.prev_instr_addr_incr_buf ),
.u_ibex_core__if_stage_i__g_secure_pc__prev_instr_addr_incr_buf_t0(
  u_ibex_core.if_stage_i.\g_secure_pc.prev_instr_addr_incr_buf_t0 ),
.u_ibex_core__if_stage_i__g_secure_pc__prev_instr_addr_incr_t0(
  u_ibex_core.if_stage_i.\g_secure_pc.prev_instr_addr_incr_t0 ),
.u_ibex_core__if_stage_i__g_secure_pc__prev_instr_seq_d(
  u_ibex_core.if_stage_i.\g_secure_pc.prev_instr_seq_d ),
.u_ibex_core__if_stage_i__g_secure_pc__prev_instr_seq_d_t0(
  u_ibex_core.if_stage_i.\g_secure_pc.prev_instr_seq_d_t0 ),
.u_ibex_core__if_stage_i__g_secure_pc__prev_instr_seq_q(
  u_ibex_core.if_stage_i.\g_secure_pc.prev_instr_seq_q ),
.u_ibex_core__if_stage_i__g_secure_pc__prev_instr_seq_q_t0(
  u_ibex_core.if_stage_i.\g_secure_pc.prev_instr_seq_q_t0 ),
.u_ibex_core__if_stage_i__gen_dummy_instr__dummy_instr_data(
  u_ibex_core.if_stage_i.\gen_dummy_instr.dummy_instr_data ),
.u_ibex_core__if_stage_i__gen_dummy_instr__dummy_instr_data_t0(
  u_ibex_core.if_stage_i.\gen_dummy_instr.dummy_instr_data_t0 ),
.u_ibex_core__if_stage_i__gen_dummy_instr__insert_dummy_instr(
  u_ibex_core.if_stage_i.\gen_dummy_instr.insert_dummy_instr ),
.u_ibex_core__if_stage_i__gen_dummy_instr__insert_dummy_instr_t0(
  u_ibex_core.if_stage_i.\gen_dummy_instr.insert_dummy_instr_t0 ),
.u_ibex_core__if_stage_i__if_id_pipe_reg_we(
  u_ibex_core.if_stage_i.if_id_pipe_reg_we),
.u_ibex_core__if_stage_i__if_id_pipe_reg_we_t0(
  u_ibex_core.if_stage_i.if_id_pipe_reg_we_t0),
.u_ibex_core__if_stage_i__if_instr_bus_err(
  u_ibex_core.if_stage_i.if_instr_bus_err),
.u_ibex_core__if_stage_i__if_instr_bus_err_t0(
  u_ibex_core.if_stage_i.if_instr_bus_err_t0),
.u_ibex_core__if_stage_i__if_instr_err(
  u_ibex_core.if_stage_i.if_instr_err),
.u_ibex_core__if_stage_i__if_instr_err_plus2(
  u_ibex_core.if_stage_i.if_instr_err_plus2),
.u_ibex_core__if_stage_i__if_instr_err_plus2_t0(
  u_ibex_core.if_stage_i.if_instr_err_plus2_t0),
.u_ibex_core__if_stage_i__if_instr_err_t0(
  u_ibex_core.if_stage_i.if_instr_err_t0),
.u_ibex_core__if_stage_i__if_instr_pmp_err(
  u_ibex_core.if_stage_i.if_instr_pmp_err),
.u_ibex_core__if_stage_i__if_instr_pmp_err_t0(
  u_ibex_core.if_stage_i.if_instr_pmp_err_t0),
.u_ibex_core__if_stage_i__if_instr_rdata(
  u_ibex_core.if_stage_i.if_instr_rdata),
.u_ibex_core__if_stage_i__if_instr_rdata_t0(
  u_ibex_core.if_stage_i.if_instr_rdata_t0),
.u_ibex_core__if_stage_i__if_instr_valid(
  u_ibex_core.if_stage_i.if_instr_valid),
.u_ibex_core__if_stage_i__if_instr_valid_t0(
  u_ibex_core.if_stage_i.if_instr_valid_t0),
.u_ibex_core__if_stage_i__illegal_c_insn(
  u_ibex_core.if_stage_i.illegal_c_insn),
.u_ibex_core__if_stage_i__illegal_c_insn_t0(
  u_ibex_core.if_stage_i.illegal_c_insn_t0),
.u_ibex_core__if_stage_i__illegal_c_instr_out(
  u_ibex_core.if_stage_i.illegal_c_instr_out),
.u_ibex_core__if_stage_i__illegal_c_instr_out_t0(
  u_ibex_core.if_stage_i.illegal_c_instr_out_t0),
.u_ibex_core__if_stage_i__instr_decompressed(
  u_ibex_core.if_stage_i.instr_decompressed),
.u_ibex_core__if_stage_i__instr_decompressed_t0(
  u_ibex_core.if_stage_i.instr_decompressed_t0),
.u_ibex_core__if_stage_i__instr_err(
  u_ibex_core.if_stage_i.instr_err),
.u_ibex_core__if_stage_i__instr_err_out(
  u_ibex_core.if_stage_i.instr_err_out),
.u_ibex_core__if_stage_i__instr_err_out_t0(
  u_ibex_core.if_stage_i.instr_err_out_t0),
.u_ibex_core__if_stage_i__instr_err_t0(
  u_ibex_core.if_stage_i.instr_err_t0),
.u_ibex_core__if_stage_i__instr_intg_err(
  u_ibex_core.if_stage_i.instr_intg_err),
.u_ibex_core__if_stage_i__instr_intg_err_t0(
  u_ibex_core.if_stage_i.instr_intg_err_t0),
.u_ibex_core__if_stage_i__instr_is_compressed(
  u_ibex_core.if_stage_i.instr_is_compressed),
.u_ibex_core__if_stage_i__instr_is_compressed_out(
  u_ibex_core.if_stage_i.instr_is_compressed_out),
.u_ibex_core__if_stage_i__instr_is_compressed_out_t0(
  u_ibex_core.if_stage_i.instr_is_compressed_out_t0),
.u_ibex_core__if_stage_i__instr_is_compressed_t0(
  u_ibex_core.if_stage_i.instr_is_compressed_t0),
.u_ibex_core__if_stage_i__instr_out(
  u_ibex_core.if_stage_i.instr_out),
.u_ibex_core__if_stage_i__instr_out_t0(
  u_ibex_core.if_stage_i.instr_out_t0),
.u_ibex_core__if_stage_i__instr_valid_id_d(
  u_ibex_core.if_stage_i.instr_valid_id_d),
.u_ibex_core__if_stage_i__instr_valid_id_d_t0(
  u_ibex_core.if_stage_i.instr_valid_id_d_t0),
.u_ibex_core__if_stage_i__irq_vec(
  u_ibex_core.if_stage_i.irq_vec),
.u_ibex_core__if_stage_i__irq_vec_t0(
  u_ibex_core.if_stage_i.irq_vec_t0),
.u_ibex_core__if_stage_i__pc_mux_internal(
  u_ibex_core.if_stage_i.pc_mux_internal),
.u_ibex_core__if_stage_i__pc_mux_internal_t0(
  u_ibex_core.if_stage_i.pc_mux_internal_t0),
.u_ibex_core__if_stage_i__predict_branch_pc(
  u_ibex_core.if_stage_i.predict_branch_pc),
.u_ibex_core__if_stage_i__predict_branch_pc_t0(
  u_ibex_core.if_stage_i.predict_branch_pc_t0),
.u_ibex_core__if_stage_i__predict_branch_taken(
  u_ibex_core.if_stage_i.predict_branch_taken),
.u_ibex_core__if_stage_i__predict_branch_taken_t0(
  u_ibex_core.if_stage_i.predict_branch_taken_t0),
.u_ibex_core__if_stage_i__prefetch_addr(
  u_ibex_core.if_stage_i.prefetch_addr),
.u_ibex_core__if_stage_i__prefetch_addr_t0(
  u_ibex_core.if_stage_i.prefetch_addr_t0),
.u_ibex_core__if_stage_i__prefetch_branch(
  u_ibex_core.if_stage_i.prefetch_branch),
.u_ibex_core__if_stage_i__prefetch_branch_t0(
  u_ibex_core.if_stage_i.prefetch_branch_t0),
.u_ibex_core__if_stage_i__compressed_decoder_i__clk_i(
  u_ibex_core.if_stage_i.compressed_decoder_i.clk_i),
.u_ibex_core__if_stage_i__compressed_decoder_i__rst_ni(
  u_ibex_core.if_stage_i.compressed_decoder_i.rst_ni),
.u_ibex_core__if_stage_i__compressed_decoder_i__valid_i(
  u_ibex_core.if_stage_i.compressed_decoder_i.valid_i),
.u_ibex_core__if_stage_i__compressed_decoder_i__instr_i(
  u_ibex_core.if_stage_i.compressed_decoder_i.instr_i),
.u_ibex_core__if_stage_i__compressed_decoder_i__instr_o(
  u_ibex_core.if_stage_i.compressed_decoder_i.instr_o),
.u_ibex_core__if_stage_i__compressed_decoder_i__is_compressed_o(
  u_ibex_core.if_stage_i.compressed_decoder_i.is_compressed_o),
.u_ibex_core__if_stage_i__compressed_decoder_i__illegal_instr_o(
  u_ibex_core.if_stage_i.compressed_decoder_i.illegal_instr_o),
.u_ibex_core__if_stage_i__compressed_decoder_i__valid_i_t0(
  u_ibex_core.if_stage_i.compressed_decoder_i.valid_i_t0),
.u_ibex_core__if_stage_i__compressed_decoder_i__is_compressed_o_t0(
  u_ibex_core.if_stage_i.compressed_decoder_i.is_compressed_o_t0),
.u_ibex_core__if_stage_i__compressed_decoder_i__instr_o_t0(
  u_ibex_core.if_stage_i.compressed_decoder_i.instr_o_t0),
.u_ibex_core__if_stage_i__compressed_decoder_i__instr_i_t0(
  u_ibex_core.if_stage_i.compressed_decoder_i.instr_i_t0),
.u_ibex_core__if_stage_i__compressed_decoder_i__illegal_instr_o_t0(
  u_ibex_core.if_stage_i.compressed_decoder_i.illegal_instr_o_t0),
.u_ibex_core__if_stage_i__g_branch_predictor__branch_predict_i__clk_i(
  u_ibex_core.if_stage_i.\g_branch_predictor.branch_predict_i .clk_i),
.u_ibex_core__if_stage_i__g_branch_predictor__branch_predict_i__rst_ni(
  u_ibex_core.if_stage_i.\g_branch_predictor.branch_predict_i .rst_ni),
.u_ibex_core__if_stage_i__g_branch_predictor__branch_predict_i__fetch_rdata_i(
  u_ibex_core.if_stage_i.\g_branch_predictor.branch_predict_i .fetch_rdata_i),
.u_ibex_core__if_stage_i__g_branch_predictor__branch_predict_i__fetch_pc_i(
  u_ibex_core.if_stage_i.\g_branch_predictor.branch_predict_i .fetch_pc_i),
.u_ibex_core__if_stage_i__g_branch_predictor__branch_predict_i__fetch_valid_i(
  u_ibex_core.if_stage_i.\g_branch_predictor.branch_predict_i .fetch_valid_i),
.u_ibex_core__if_stage_i__g_branch_predictor__branch_predict_i__predict_branch_taken_o(
  u_ibex_core.if_stage_i.\g_branch_predictor.branch_predict_i .predict_branch_taken_o),
.u_ibex_core__if_stage_i__g_branch_predictor__branch_predict_i__predict_branch_pc_o(
  u_ibex_core.if_stage_i.\g_branch_predictor.branch_predict_i .predict_branch_pc_o),
.u_ibex_core__if_stage_i__g_branch_predictor__branch_predict_i__predict_branch_taken_o_t0(
  u_ibex_core.if_stage_i.\g_branch_predictor.branch_predict_i .predict_branch_taken_o_t0),
.u_ibex_core__if_stage_i__g_branch_predictor__branch_predict_i__predict_branch_pc_o_t0(
  u_ibex_core.if_stage_i.\g_branch_predictor.branch_predict_i .predict_branch_pc_o_t0),
.u_ibex_core__if_stage_i__g_branch_predictor__branch_predict_i__fetch_valid_i_t0(
  u_ibex_core.if_stage_i.\g_branch_predictor.branch_predict_i .fetch_valid_i_t0),
.u_ibex_core__if_stage_i__g_branch_predictor__branch_predict_i__fetch_rdata_i_t0(
  u_ibex_core.if_stage_i.\g_branch_predictor.branch_predict_i .fetch_rdata_i_t0),
.u_ibex_core__if_stage_i__g_branch_predictor__branch_predict_i__fetch_pc_i_t0(
  u_ibex_core.if_stage_i.\g_branch_predictor.branch_predict_i .fetch_pc_i_t0),
.u_ibex_core__if_stage_i__g_branch_predictor__branch_predict_i__branch_imm(
  u_ibex_core.if_stage_i.\g_branch_predictor.branch_predict_i .branch_imm),
.u_ibex_core__if_stage_i__g_branch_predictor__branch_predict_i__branch_imm_t0(
  u_ibex_core.if_stage_i.\g_branch_predictor.branch_predict_i .branch_imm_t0),
.u_ibex_core__if_stage_i__g_branch_predictor__branch_predict_i__instr_b(
  u_ibex_core.if_stage_i.\g_branch_predictor.branch_predict_i .instr_b),
.u_ibex_core__if_stage_i__g_branch_predictor__branch_predict_i__instr_b_t0(
  u_ibex_core.if_stage_i.\g_branch_predictor.branch_predict_i .instr_b_t0),
.u_ibex_core__if_stage_i__g_branch_predictor__branch_predict_i__instr_b_taken(
  u_ibex_core.if_stage_i.\g_branch_predictor.branch_predict_i .instr_b_taken),
.u_ibex_core__if_stage_i__g_branch_predictor__branch_predict_i__instr_b_taken_t0(
  u_ibex_core.if_stage_i.\g_branch_predictor.branch_predict_i .instr_b_taken_t0),
.u_ibex_core__if_stage_i__g_branch_predictor__branch_predict_i__instr_cb(
  u_ibex_core.if_stage_i.\g_branch_predictor.branch_predict_i .instr_cb),
.u_ibex_core__if_stage_i__g_branch_predictor__branch_predict_i__instr_cb_t0(
  u_ibex_core.if_stage_i.\g_branch_predictor.branch_predict_i .instr_cb_t0),
.u_ibex_core__if_stage_i__g_branch_predictor__branch_predict_i__instr_cj(
  u_ibex_core.if_stage_i.\g_branch_predictor.branch_predict_i .instr_cj),
.u_ibex_core__if_stage_i__g_branch_predictor__branch_predict_i__instr_cj_t0(
  u_ibex_core.if_stage_i.\g_branch_predictor.branch_predict_i .instr_cj_t0),
.u_ibex_core__if_stage_i__g_branch_predictor__branch_predict_i__instr_j(
  u_ibex_core.if_stage_i.\g_branch_predictor.branch_predict_i .instr_j),
.u_ibex_core__if_stage_i__g_branch_predictor__branch_predict_i__instr_j_t0(
  u_ibex_core.if_stage_i.\g_branch_predictor.branch_predict_i .instr_j_t0),
.u_ibex_core__if_stage_i__g_mem_ecc__u_instr_intg_dec__data_i(
  u_ibex_core.if_stage_i.\g_mem_ecc.u_instr_intg_dec .data_i),
.u_ibex_core__if_stage_i__g_mem_ecc__u_instr_intg_dec__data_o(
  u_ibex_core.if_stage_i.\g_mem_ecc.u_instr_intg_dec .data_o),
.u_ibex_core__if_stage_i__g_mem_ecc__u_instr_intg_dec__syndrome_o(
  u_ibex_core.if_stage_i.\g_mem_ecc.u_instr_intg_dec .syndrome_o),
.u_ibex_core__if_stage_i__g_mem_ecc__u_instr_intg_dec__err_o(
  u_ibex_core.if_stage_i.\g_mem_ecc.u_instr_intg_dec .err_o),
.u_ibex_core__if_stage_i__g_mem_ecc__u_instr_intg_dec__syndrome_o_t0(
  u_ibex_core.if_stage_i.\g_mem_ecc.u_instr_intg_dec .syndrome_o_t0),
.u_ibex_core__if_stage_i__g_mem_ecc__u_instr_intg_dec__err_o_t0(
  u_ibex_core.if_stage_i.\g_mem_ecc.u_instr_intg_dec .err_o_t0),
.u_ibex_core__if_stage_i__g_mem_ecc__u_instr_intg_dec__data_o_t0(
  u_ibex_core.if_stage_i.\g_mem_ecc.u_instr_intg_dec .data_o_t0),
.u_ibex_core__if_stage_i__g_mem_ecc__u_instr_intg_dec__data_i_t0(
  u_ibex_core.if_stage_i.\g_mem_ecc.u_instr_intg_dec .data_i_t0),
.u_ibex_core__if_stage_i__g_mem_ecc__u_prim_buf_instr_rdata__in_i(
  u_ibex_core.if_stage_i.\g_mem_ecc.u_prim_buf_instr_rdata .in_i),
.u_ibex_core__if_stage_i__g_mem_ecc__u_prim_buf_instr_rdata__out_o(
  u_ibex_core.if_stage_i.\g_mem_ecc.u_prim_buf_instr_rdata .out_o),
.u_ibex_core__if_stage_i__g_mem_ecc__u_prim_buf_instr_rdata__in_i_t0(
  u_ibex_core.if_stage_i.\g_mem_ecc.u_prim_buf_instr_rdata .in_i_t0),
.u_ibex_core__if_stage_i__g_mem_ecc__u_prim_buf_instr_rdata__out_o_t0(
  u_ibex_core.if_stage_i.\g_mem_ecc.u_prim_buf_instr_rdata .out_o_t0),
.u_ibex_core__if_stage_i__g_mem_ecc__u_prim_buf_instr_rdata__gen_generic__u_impl_generic__in_i(
  u_ibex_core.if_stage_i.\g_mem_ecc.u_prim_buf_instr_rdata .\gen_generic.u_impl_generic .in_i),
.u_ibex_core__if_stage_i__g_mem_ecc__u_prim_buf_instr_rdata__gen_generic__u_impl_generic__out_o(
  u_ibex_core.if_stage_i.\g_mem_ecc.u_prim_buf_instr_rdata .\gen_generic.u_impl_generic .out_o),
.u_ibex_core__if_stage_i__g_mem_ecc__u_prim_buf_instr_rdata__gen_generic__u_impl_generic__in_i_t0(
  u_ibex_core.if_stage_i.\g_mem_ecc.u_prim_buf_instr_rdata .\gen_generic.u_impl_generic .in_i_t0),
.u_ibex_core__if_stage_i__g_mem_ecc__u_prim_buf_instr_rdata__gen_generic__u_impl_generic__out_o_t0(
  u_ibex_core.if_stage_i.\g_mem_ecc.u_prim_buf_instr_rdata .\gen_generic.u_impl_generic .out_o_t0),
.u_ibex_core__if_stage_i__g_mem_ecc__u_prim_buf_instr_rdata__gen_generic__u_impl_generic__inv(
  u_ibex_core.if_stage_i.\g_mem_ecc.u_prim_buf_instr_rdata .\gen_generic.u_impl_generic .inv),
.u_ibex_core__if_stage_i__g_secure_pc__u_prev_instr_addr_incr_buf__in_i(
  u_ibex_core.if_stage_i.\g_secure_pc.u_prev_instr_addr_incr_buf .in_i),
.u_ibex_core__if_stage_i__g_secure_pc__u_prev_instr_addr_incr_buf__out_o(
  u_ibex_core.if_stage_i.\g_secure_pc.u_prev_instr_addr_incr_buf .out_o),
.u_ibex_core__if_stage_i__g_secure_pc__u_prev_instr_addr_incr_buf__in_i_t0(
  u_ibex_core.if_stage_i.\g_secure_pc.u_prev_instr_addr_incr_buf .in_i_t0),
.u_ibex_core__if_stage_i__g_secure_pc__u_prev_instr_addr_incr_buf__out_o_t0(
  u_ibex_core.if_stage_i.\g_secure_pc.u_prev_instr_addr_incr_buf .out_o_t0),
.u_ibex_core__if_stage_i__g_secure_pc__u_prev_instr_addr_incr_buf__gen_generic__u_impl_generic__in_i(
  u_ibex_core.if_stage_i.\g_secure_pc.u_prev_instr_addr_incr_buf .\gen_generic.u_impl_generic .in_i),
.u_ibex_core__if_stage_i__g_secure_pc__u_prev_instr_addr_incr_buf__gen_generic__u_impl_generic__out_o(
  u_ibex_core.if_stage_i.\g_secure_pc.u_prev_instr_addr_incr_buf .\gen_generic.u_impl_generic .out_o),
.u_ibex_core__if_stage_i__g_secure_pc__u_prev_instr_addr_incr_buf__gen_generic__u_impl_generic__in_i_t0(
  u_ibex_core.if_stage_i.\g_secure_pc.u_prev_instr_addr_incr_buf .\gen_generic.u_impl_generic .in_i_t0),
.u_ibex_core__if_stage_i__g_secure_pc__u_prev_instr_addr_incr_buf__gen_generic__u_impl_generic__out_o_t0(
  u_ibex_core.if_stage_i.\g_secure_pc.u_prev_instr_addr_incr_buf .\gen_generic.u_impl_generic .out_o_t0),
.u_ibex_core__if_stage_i__g_secure_pc__u_prev_instr_addr_incr_buf__gen_generic__u_impl_generic__inv(
  u_ibex_core.if_stage_i.\g_secure_pc.u_prev_instr_addr_incr_buf .\gen_generic.u_impl_generic .inv),
.u_ibex_core__if_stage_i__gen_dummy_instr__dummy_instr_i__clk_i(
  u_ibex_core.if_stage_i.\gen_dummy_instr.dummy_instr_i .clk_i),
.u_ibex_core__if_stage_i__gen_dummy_instr__dummy_instr_i__rst_ni(
  u_ibex_core.if_stage_i.\gen_dummy_instr.dummy_instr_i .rst_ni),
.u_ibex_core__if_stage_i__gen_dummy_instr__dummy_instr_i__dummy_instr_en_i(
  u_ibex_core.if_stage_i.\gen_dummy_instr.dummy_instr_i .dummy_instr_en_i),
.u_ibex_core__if_stage_i__gen_dummy_instr__dummy_instr_i__dummy_instr_mask_i(
  u_ibex_core.if_stage_i.\gen_dummy_instr.dummy_instr_i .dummy_instr_mask_i),
.u_ibex_core__if_stage_i__gen_dummy_instr__dummy_instr_i__dummy_instr_seed_en_i(
  u_ibex_core.if_stage_i.\gen_dummy_instr.dummy_instr_i .dummy_instr_seed_en_i),
.u_ibex_core__if_stage_i__gen_dummy_instr__dummy_instr_i__dummy_instr_seed_i(
  u_ibex_core.if_stage_i.\gen_dummy_instr.dummy_instr_i .dummy_instr_seed_i),
.u_ibex_core__if_stage_i__gen_dummy_instr__dummy_instr_i__fetch_valid_i(
  u_ibex_core.if_stage_i.\gen_dummy_instr.dummy_instr_i .fetch_valid_i),
.u_ibex_core__if_stage_i__gen_dummy_instr__dummy_instr_i__id_in_ready_i(
  u_ibex_core.if_stage_i.\gen_dummy_instr.dummy_instr_i .id_in_ready_i),
.u_ibex_core__if_stage_i__gen_dummy_instr__dummy_instr_i__insert_dummy_instr_o(
  u_ibex_core.if_stage_i.\gen_dummy_instr.dummy_instr_i .insert_dummy_instr_o),
.u_ibex_core__if_stage_i__gen_dummy_instr__dummy_instr_i__dummy_instr_data_o(
  u_ibex_core.if_stage_i.\gen_dummy_instr.dummy_instr_i .dummy_instr_data_o),
.u_ibex_core__if_stage_i__gen_dummy_instr__dummy_instr_i__insert_dummy_instr_o_t0(
  u_ibex_core.if_stage_i.\gen_dummy_instr.dummy_instr_i .insert_dummy_instr_o_t0),
.u_ibex_core__if_stage_i__gen_dummy_instr__dummy_instr_i__id_in_ready_i_t0(
  u_ibex_core.if_stage_i.\gen_dummy_instr.dummy_instr_i .id_in_ready_i_t0),
.u_ibex_core__if_stage_i__gen_dummy_instr__dummy_instr_i__dummy_instr_seed_i_t0(
  u_ibex_core.if_stage_i.\gen_dummy_instr.dummy_instr_i .dummy_instr_seed_i_t0),
.u_ibex_core__if_stage_i__gen_dummy_instr__dummy_instr_i__dummy_instr_seed_en_i_t0(
  u_ibex_core.if_stage_i.\gen_dummy_instr.dummy_instr_i .dummy_instr_seed_en_i_t0),
.u_ibex_core__if_stage_i__gen_dummy_instr__dummy_instr_i__dummy_instr_mask_i_t0(
  u_ibex_core.if_stage_i.\gen_dummy_instr.dummy_instr_i .dummy_instr_mask_i_t0),
.u_ibex_core__if_stage_i__gen_dummy_instr__dummy_instr_i__dummy_instr_en_i_t0(
  u_ibex_core.if_stage_i.\gen_dummy_instr.dummy_instr_i .dummy_instr_en_i_t0),
.u_ibex_core__if_stage_i__gen_dummy_instr__dummy_instr_i__dummy_instr_data_o_t0(
  u_ibex_core.if_stage_i.\gen_dummy_instr.dummy_instr_i .dummy_instr_data_o_t0),
.u_ibex_core__if_stage_i__gen_dummy_instr__dummy_instr_i__fetch_valid_i_t0(
  u_ibex_core.if_stage_i.\gen_dummy_instr.dummy_instr_i .fetch_valid_i_t0),
.u_ibex_core__if_stage_i__gen_dummy_instr__dummy_instr_i__dummy_cnt_d(
  u_ibex_core.if_stage_i.\gen_dummy_instr.dummy_instr_i .dummy_cnt_d),
.u_ibex_core__if_stage_i__gen_dummy_instr__dummy_instr_i__dummy_cnt_d_t0(
  u_ibex_core.if_stage_i.\gen_dummy_instr.dummy_instr_i .dummy_cnt_d_t0),
.u_ibex_core__if_stage_i__gen_dummy_instr__dummy_instr_i__dummy_cnt_en(
  u_ibex_core.if_stage_i.\gen_dummy_instr.dummy_instr_i .dummy_cnt_en),
.u_ibex_core__if_stage_i__gen_dummy_instr__dummy_instr_i__dummy_cnt_en_t0(
  u_ibex_core.if_stage_i.\gen_dummy_instr.dummy_instr_i .dummy_cnt_en_t0),
.u_ibex_core__if_stage_i__gen_dummy_instr__dummy_instr_i__dummy_cnt_incr(
  u_ibex_core.if_stage_i.\gen_dummy_instr.dummy_instr_i .dummy_cnt_incr),
.u_ibex_core__if_stage_i__gen_dummy_instr__dummy_instr_i__dummy_cnt_incr_t0(
  u_ibex_core.if_stage_i.\gen_dummy_instr.dummy_instr_i .dummy_cnt_incr_t0),
.u_ibex_core__if_stage_i__gen_dummy_instr__dummy_instr_i__dummy_cnt_q(
  u_ibex_core.if_stage_i.\gen_dummy_instr.dummy_instr_i .dummy_cnt_q),
.u_ibex_core__if_stage_i__gen_dummy_instr__dummy_instr_i__dummy_cnt_q_t0(
  u_ibex_core.if_stage_i.\gen_dummy_instr.dummy_instr_i .dummy_cnt_q_t0),
.u_ibex_core__if_stage_i__gen_dummy_instr__dummy_instr_i__dummy_cnt_threshold(
  u_ibex_core.if_stage_i.\gen_dummy_instr.dummy_instr_i .dummy_cnt_threshold),
.u_ibex_core__if_stage_i__gen_dummy_instr__dummy_instr_i__dummy_cnt_threshold_t0(
  u_ibex_core.if_stage_i.\gen_dummy_instr.dummy_instr_i .dummy_cnt_threshold_t0),
.u_ibex_core__if_stage_i__gen_dummy_instr__dummy_instr_i__dummy_instr_seed_d(
  u_ibex_core.if_stage_i.\gen_dummy_instr.dummy_instr_i .dummy_instr_seed_d),
.u_ibex_core__if_stage_i__gen_dummy_instr__dummy_instr_i__dummy_instr_seed_d_t0(
  u_ibex_core.if_stage_i.\gen_dummy_instr.dummy_instr_i .dummy_instr_seed_d_t0),
.u_ibex_core__if_stage_i__gen_dummy_instr__dummy_instr_i__dummy_instr_seed_q(
  u_ibex_core.if_stage_i.\gen_dummy_instr.dummy_instr_i .dummy_instr_seed_q),
.u_ibex_core__if_stage_i__gen_dummy_instr__dummy_instr_i__dummy_instr_seed_q_t0(
  u_ibex_core.if_stage_i.\gen_dummy_instr.dummy_instr_i .dummy_instr_seed_q_t0),
.u_ibex_core__if_stage_i__gen_dummy_instr__dummy_instr_i__dummy_opcode(
  u_ibex_core.if_stage_i.\gen_dummy_instr.dummy_instr_i .dummy_opcode),
.u_ibex_core__if_stage_i__gen_dummy_instr__dummy_instr_i__dummy_opcode_t0(
  u_ibex_core.if_stage_i.\gen_dummy_instr.dummy_instr_i .dummy_opcode_t0),
.u_ibex_core__if_stage_i__gen_dummy_instr__dummy_instr_i__dummy_set(
  u_ibex_core.if_stage_i.\gen_dummy_instr.dummy_instr_i .dummy_set),
.u_ibex_core__if_stage_i__gen_dummy_instr__dummy_instr_i__lfsr_data(
  u_ibex_core.if_stage_i.\gen_dummy_instr.dummy_instr_i .lfsr_data),
.u_ibex_core__if_stage_i__gen_dummy_instr__dummy_instr_i__lfsr_data_t0(
  u_ibex_core.if_stage_i.\gen_dummy_instr.dummy_instr_i .lfsr_data_t0),
.u_ibex_core__if_stage_i__gen_dummy_instr__dummy_instr_i__lfsr_en(
  u_ibex_core.if_stage_i.\gen_dummy_instr.dummy_instr_i .lfsr_en),
.u_ibex_core__if_stage_i__gen_dummy_instr__dummy_instr_i__lfsr_en_t0(
  u_ibex_core.if_stage_i.\gen_dummy_instr.dummy_instr_i .lfsr_en_t0),
.u_ibex_core__if_stage_i__gen_dummy_instr__dummy_instr_i__lfsr_i__clk_i(
  u_ibex_core.if_stage_i.\gen_dummy_instr.dummy_instr_i .lfsr_i.clk_i),
.u_ibex_core__if_stage_i__gen_dummy_instr__dummy_instr_i__lfsr_i__rst_ni(
  u_ibex_core.if_stage_i.\gen_dummy_instr.dummy_instr_i .lfsr_i.rst_ni),
.u_ibex_core__if_stage_i__gen_dummy_instr__dummy_instr_i__lfsr_i__seed_en_i(
  u_ibex_core.if_stage_i.\gen_dummy_instr.dummy_instr_i .lfsr_i.seed_en_i),
.u_ibex_core__if_stage_i__gen_dummy_instr__dummy_instr_i__lfsr_i__seed_i(
  u_ibex_core.if_stage_i.\gen_dummy_instr.dummy_instr_i .lfsr_i.seed_i),
.u_ibex_core__if_stage_i__gen_dummy_instr__dummy_instr_i__lfsr_i__lfsr_en_i(
  u_ibex_core.if_stage_i.\gen_dummy_instr.dummy_instr_i .lfsr_i.lfsr_en_i),
.u_ibex_core__if_stage_i__gen_dummy_instr__dummy_instr_i__lfsr_i__entropy_i(
  u_ibex_core.if_stage_i.\gen_dummy_instr.dummy_instr_i .lfsr_i.entropy_i),
.u_ibex_core__if_stage_i__gen_dummy_instr__dummy_instr_i__lfsr_i__state_o(
  u_ibex_core.if_stage_i.\gen_dummy_instr.dummy_instr_i .lfsr_i.state_o),
.u_ibex_core__if_stage_i__gen_dummy_instr__dummy_instr_i__lfsr_i__state_o_t0(
  u_ibex_core.if_stage_i.\gen_dummy_instr.dummy_instr_i .lfsr_i.state_o_t0),
.u_ibex_core__if_stage_i__gen_dummy_instr__dummy_instr_i__lfsr_i__seed_i_t0(
  u_ibex_core.if_stage_i.\gen_dummy_instr.dummy_instr_i .lfsr_i.seed_i_t0),
.u_ibex_core__if_stage_i__gen_dummy_instr__dummy_instr_i__lfsr_i__seed_en_i_t0(
  u_ibex_core.if_stage_i.\gen_dummy_instr.dummy_instr_i .lfsr_i.seed_en_i_t0),
.u_ibex_core__if_stage_i__gen_dummy_instr__dummy_instr_i__lfsr_i__lfsr_en_i_t0(
  u_ibex_core.if_stage_i.\gen_dummy_instr.dummy_instr_i .lfsr_i.lfsr_en_i_t0),
.u_ibex_core__if_stage_i__gen_dummy_instr__dummy_instr_i__lfsr_i__entropy_i_t0(
  u_ibex_core.if_stage_i.\gen_dummy_instr.dummy_instr_i .lfsr_i.entropy_i_t0),
.u_ibex_core__if_stage_i__gen_dummy_instr__dummy_instr_i__lfsr_i__lfsr_d(
  u_ibex_core.if_stage_i.\gen_dummy_instr.dummy_instr_i .lfsr_i.lfsr_d),
.u_ibex_core__if_stage_i__gen_dummy_instr__dummy_instr_i__lfsr_i__lfsr_d_t0(
  u_ibex_core.if_stage_i.\gen_dummy_instr.dummy_instr_i .lfsr_i.lfsr_d_t0),
.u_ibex_core__if_stage_i__gen_dummy_instr__dummy_instr_i__lfsr_i__lfsr_q(
  u_ibex_core.if_stage_i.\gen_dummy_instr.dummy_instr_i .lfsr_i.lfsr_q),
.u_ibex_core__if_stage_i__gen_dummy_instr__dummy_instr_i__lfsr_i__lfsr_q_t0(
  u_ibex_core.if_stage_i.\gen_dummy_instr.dummy_instr_i .lfsr_i.lfsr_q_t0),
.u_ibex_core__if_stage_i__gen_dummy_instr__dummy_instr_i__lfsr_i__lockup(
  u_ibex_core.if_stage_i.\gen_dummy_instr.dummy_instr_i .lfsr_i.lockup),
.u_ibex_core__if_stage_i__gen_dummy_instr__dummy_instr_i__lfsr_i__lockup_t0(
  u_ibex_core.if_stage_i.\gen_dummy_instr.dummy_instr_i .lfsr_i.lockup_t0),
.u_ibex_core__if_stage_i__gen_dummy_instr__dummy_instr_i__lfsr_i__next_lfsr_state(
  u_ibex_core.if_stage_i.\gen_dummy_instr.dummy_instr_i .lfsr_i.next_lfsr_state),
.u_ibex_core__if_stage_i__gen_dummy_instr__dummy_instr_i__lfsr_i__next_lfsr_state_t0(
  u_ibex_core.if_stage_i.\gen_dummy_instr.dummy_instr_i .lfsr_i.next_lfsr_state_t0),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__clk_i(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .clk_i),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__rst_ni(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .rst_ni),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__req_i(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .req_i),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__branch_i(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .branch_i),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__addr_i(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .addr_i),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__ready_i(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .ready_i),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__valid_o(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .valid_o),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__rdata_o(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .rdata_o),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__addr_o(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .addr_o),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__err_o(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .err_o),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__err_plus2_o(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .err_plus2_o),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__instr_req_o(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .instr_req_o),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__instr_gnt_i(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .instr_gnt_i),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__instr_addr_o(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .instr_addr_o),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__instr_rdata_i(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .instr_rdata_i),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__instr_err_i(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .instr_err_i),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__instr_rvalid_i(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .instr_rvalid_i),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__busy_o(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .busy_o),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__addr_i_t0(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .addr_i_t0),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__instr_addr_o_t0(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .instr_addr_o_t0),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__instr_gnt_i_t0(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .instr_gnt_i_t0),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__err_plus2_o_t0(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .err_plus2_o_t0),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__rdata_o_t0(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .rdata_o_t0),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__req_i_t0(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .req_i_t0),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__instr_rvalid_i_t0(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .instr_rvalid_i_t0),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__valid_o_t0(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .valid_o_t0),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__instr_req_o_t0(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .instr_req_o_t0),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__instr_rdata_i_t0(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .instr_rdata_i_t0),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__ready_i_t0(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .ready_i_t0),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__branch_i_t0(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .branch_i_t0),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__addr_o_t0(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .addr_o_t0),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__instr_err_i_t0(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .instr_err_i_t0),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__busy_o_t0(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .busy_o_t0),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__err_o_t0(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .err_o_t0),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__branch_discard_n(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .branch_discard_n),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__branch_discard_n_t0(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .branch_discard_n_t0),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__branch_discard_q(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .branch_discard_q),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__branch_discard_q_t0(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .branch_discard_q_t0),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__branch_discard_s(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .branch_discard_s),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__branch_discard_s_t0(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .branch_discard_s_t0),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__discard_req_d(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .discard_req_d),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__discard_req_d_t0(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .discard_req_d_t0),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__discard_req_q(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .discard_req_q),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__discard_req_q_t0(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .discard_req_q_t0),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__fetch_addr_d(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .fetch_addr_d),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__fetch_addr_d_t0(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .fetch_addr_d_t0),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__fetch_addr_en(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .fetch_addr_en),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__fetch_addr_en_t0(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .fetch_addr_en_t0),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__fetch_addr_q(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .fetch_addr_q),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__fetch_addr_q_t0(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .fetch_addr_q_t0),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__fifo_busy(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .fifo_busy),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__fifo_busy_t0(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .fifo_busy_t0),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__fifo_ready(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .fifo_ready),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__fifo_ready_t0(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .fifo_ready_t0),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__fifo_valid(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .fifo_valid),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__fifo_valid_t0(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .fifo_valid_t0),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__instr_addr(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .instr_addr),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__instr_addr_t0(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .instr_addr_t0),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__rdata_outstanding_n(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .rdata_outstanding_n),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__rdata_outstanding_n_t0(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .rdata_outstanding_n_t0),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__rdata_outstanding_q(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .rdata_outstanding_q),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__rdata_outstanding_q_t0(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .rdata_outstanding_q_t0),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__rdata_outstanding_s(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .rdata_outstanding_s),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__rdata_outstanding_s_t0(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .rdata_outstanding_s_t0),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__stored_addr_en(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .stored_addr_en),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__stored_addr_en_t0(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .stored_addr_en_t0),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__stored_addr_q(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .stored_addr_q),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__stored_addr_q_t0(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .stored_addr_q_t0),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__valid_new_req(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .valid_new_req),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__valid_new_req_t0(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .valid_new_req_t0),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__valid_req_d(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .valid_req_d),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__valid_req_d_t0(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .valid_req_d_t0),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__valid_req_q(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .valid_req_q),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__valid_req_q_t0(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .valid_req_q_t0),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__fifo_i__clk_i(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .fifo_i.clk_i),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__fifo_i__rst_ni(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .fifo_i.rst_ni),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__fifo_i__clear_i(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .fifo_i.clear_i),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__fifo_i__busy_o(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .fifo_i.busy_o),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__fifo_i__in_valid_i(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .fifo_i.in_valid_i),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__fifo_i__in_addr_i(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .fifo_i.in_addr_i),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__fifo_i__in_rdata_i(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .fifo_i.in_rdata_i),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__fifo_i__in_err_i(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .fifo_i.in_err_i),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__fifo_i__out_valid_o(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .fifo_i.out_valid_o),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__fifo_i__out_ready_i(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .fifo_i.out_ready_i),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__fifo_i__out_addr_o(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .fifo_i.out_addr_o),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__fifo_i__out_rdata_o(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .fifo_i.out_rdata_o),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__fifo_i__out_err_o(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .fifo_i.out_err_o),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__fifo_i__out_err_plus2_o(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .fifo_i.out_err_plus2_o),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__fifo_i__out_valid_o_t0(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .fifo_i.out_valid_o_t0),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__fifo_i__out_ready_i_t0(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .fifo_i.out_ready_i_t0),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__fifo_i__out_rdata_o_t0(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .fifo_i.out_rdata_o_t0),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__fifo_i__out_err_plus2_o_t0(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .fifo_i.out_err_plus2_o_t0),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__fifo_i__out_err_o_t0(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .fifo_i.out_err_o_t0),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__fifo_i__out_addr_o_t0(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .fifo_i.out_addr_o_t0),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__fifo_i__in_valid_i_t0(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .fifo_i.in_valid_i_t0),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__fifo_i__in_rdata_i_t0(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .fifo_i.in_rdata_i_t0),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__fifo_i__in_err_i_t0(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .fifo_i.in_err_i_t0),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__fifo_i__in_addr_i_t0(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .fifo_i.in_addr_i_t0),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__fifo_i__clear_i_t0(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .fifo_i.clear_i_t0),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__fifo_i__busy_o_t0(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .fifo_i.busy_o_t0),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__fifo_i__addr_incr_two(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .fifo_i.addr_incr_two),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__fifo_i__addr_incr_two_t0(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .fifo_i.addr_incr_two_t0),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__fifo_i__aligned_is_compressed(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .fifo_i.aligned_is_compressed),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__fifo_i__aligned_is_compressed_t0(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .fifo_i.aligned_is_compressed_t0),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__fifo_i__entry_en(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .fifo_i.entry_en),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__fifo_i__entry_en_t0(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .fifo_i.entry_en_t0),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__fifo_i__err(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .fifo_i.err),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__fifo_i__err_d(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .fifo_i.err_d),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__fifo_i__err_d_t0(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .fifo_i.err_d_t0),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__fifo_i__err_plus2(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .fifo_i.err_plus2),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__fifo_i__err_plus2_t0(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .fifo_i.err_plus2_t0),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__fifo_i__err_q(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .fifo_i.err_q),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__fifo_i__err_q_t0(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .fifo_i.err_q_t0),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__fifo_i__err_t0(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .fifo_i.err_t0),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__fifo_i__err_unaligned(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .fifo_i.err_unaligned),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__fifo_i__err_unaligned_t0(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .fifo_i.err_unaligned_t0),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__fifo_i__instr_addr_d(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .fifo_i.instr_addr_d),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__fifo_i__instr_addr_d_t0(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .fifo_i.instr_addr_d_t0),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__fifo_i__instr_addr_en(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .fifo_i.instr_addr_en),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__fifo_i__instr_addr_en_t0(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .fifo_i.instr_addr_en_t0),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__fifo_i__instr_addr_next(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .fifo_i.instr_addr_next),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__fifo_i__instr_addr_next_t0(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .fifo_i.instr_addr_next_t0),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__fifo_i__instr_addr_q(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .fifo_i.instr_addr_q),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__fifo_i__instr_addr_q_t0(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .fifo_i.instr_addr_q_t0),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__fifo_i__lowest_free_entry(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .fifo_i.lowest_free_entry),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__fifo_i__lowest_free_entry_t0(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .fifo_i.lowest_free_entry_t0),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__fifo_i__pop_fifo(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .fifo_i.pop_fifo),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__fifo_i__pop_fifo_t0(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .fifo_i.pop_fifo_t0),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__fifo_i__rdata(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .fifo_i.rdata),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__fifo_i__rdata_d(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .fifo_i.rdata_d),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__fifo_i__rdata_d_t0(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .fifo_i.rdata_d_t0),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__fifo_i__rdata_q(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .fifo_i.rdata_q),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__fifo_i__rdata_q_t0(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .fifo_i.rdata_q_t0),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__fifo_i__rdata_t0(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .fifo_i.rdata_t0),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__fifo_i__rdata_unaligned(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .fifo_i.rdata_unaligned),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__fifo_i__rdata_unaligned_t0(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .fifo_i.rdata_unaligned_t0),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__fifo_i__unaligned_is_compressed(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .fifo_i.unaligned_is_compressed),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__fifo_i__unaligned_is_compressed_t0(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .fifo_i.unaligned_is_compressed_t0),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__fifo_i__valid(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .fifo_i.valid),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__fifo_i__valid_d(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .fifo_i.valid_d),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__fifo_i__valid_d_t0(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .fifo_i.valid_d_t0),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__fifo_i__valid_popped(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .fifo_i.valid_popped),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__fifo_i__valid_popped_t0(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .fifo_i.valid_popped_t0),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__fifo_i__valid_pushed(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .fifo_i.valid_pushed),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__fifo_i__valid_pushed_t0(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .fifo_i.valid_pushed_t0),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__fifo_i__valid_q(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .fifo_i.valid_q),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__fifo_i__valid_q_t0(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .fifo_i.valid_q_t0),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__fifo_i__valid_t0(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .fifo_i.valid_t0),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__fifo_i__valid_unaligned(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .fifo_i.valid_unaligned),
.u_ibex_core__if_stage_i__gen_prefetch_buffer__prefetch_buffer_i__fifo_i__valid_unaligned_t0(
  u_ibex_core.if_stage_i.\gen_prefetch_buffer.prefetch_buffer_i .fifo_i.valid_unaligned_t0),
.u_ibex_core__load_store_unit_i__clk_i(
  u_ibex_core.load_store_unit_i.clk_i),
.u_ibex_core__load_store_unit_i__rst_ni(
  u_ibex_core.load_store_unit_i.rst_ni),
.u_ibex_core__load_store_unit_i__data_req_o(
  u_ibex_core.load_store_unit_i.data_req_o),
.u_ibex_core__load_store_unit_i__data_gnt_i(
  u_ibex_core.load_store_unit_i.data_gnt_i),
.u_ibex_core__load_store_unit_i__data_rvalid_i(
  u_ibex_core.load_store_unit_i.data_rvalid_i),
.u_ibex_core__load_store_unit_i__data_bus_err_i(
  u_ibex_core.load_store_unit_i.data_bus_err_i),
.u_ibex_core__load_store_unit_i__data_pmp_err_i(
  u_ibex_core.load_store_unit_i.data_pmp_err_i),
.u_ibex_core__load_store_unit_i__data_addr_o(
  u_ibex_core.load_store_unit_i.data_addr_o),
.u_ibex_core__load_store_unit_i__data_we_o(
  u_ibex_core.load_store_unit_i.data_we_o),
.u_ibex_core__load_store_unit_i__data_be_o(
  u_ibex_core.load_store_unit_i.data_be_o),
.u_ibex_core__load_store_unit_i__data_wdata_o(
  u_ibex_core.load_store_unit_i.data_wdata_o),
.u_ibex_core__load_store_unit_i__data_rdata_i(
  u_ibex_core.load_store_unit_i.data_rdata_i),
.u_ibex_core__load_store_unit_i__lsu_we_i(
  u_ibex_core.load_store_unit_i.lsu_we_i),
.u_ibex_core__load_store_unit_i__lsu_type_i(
  u_ibex_core.load_store_unit_i.lsu_type_i),
.u_ibex_core__load_store_unit_i__lsu_wdata_i(
  u_ibex_core.load_store_unit_i.lsu_wdata_i),
.u_ibex_core__load_store_unit_i__lsu_sign_ext_i(
  u_ibex_core.load_store_unit_i.lsu_sign_ext_i),
.u_ibex_core__load_store_unit_i__lsu_rdata_o(
  u_ibex_core.load_store_unit_i.lsu_rdata_o),
.u_ibex_core__load_store_unit_i__lsu_rdata_valid_o(
  u_ibex_core.load_store_unit_i.lsu_rdata_valid_o),
.u_ibex_core__load_store_unit_i__lsu_req_i(
  u_ibex_core.load_store_unit_i.lsu_req_i),
.u_ibex_core__load_store_unit_i__adder_result_ex_i(
  u_ibex_core.load_store_unit_i.adder_result_ex_i),
.u_ibex_core__load_store_unit_i__addr_incr_req_o(
  u_ibex_core.load_store_unit_i.addr_incr_req_o),
.u_ibex_core__load_store_unit_i__addr_last_o(
  u_ibex_core.load_store_unit_i.addr_last_o),
.u_ibex_core__load_store_unit_i__lsu_req_done_o(
  u_ibex_core.load_store_unit_i.lsu_req_done_o),
.u_ibex_core__load_store_unit_i__lsu_resp_valid_o(
  u_ibex_core.load_store_unit_i.lsu_resp_valid_o),
.u_ibex_core__load_store_unit_i__load_err_o(
  u_ibex_core.load_store_unit_i.load_err_o),
.u_ibex_core__load_store_unit_i__load_resp_intg_err_o(
  u_ibex_core.load_store_unit_i.load_resp_intg_err_o),
.u_ibex_core__load_store_unit_i__store_err_o(
  u_ibex_core.load_store_unit_i.store_err_o),
.u_ibex_core__load_store_unit_i__store_resp_intg_err_o(
  u_ibex_core.load_store_unit_i.store_resp_intg_err_o),
.u_ibex_core__load_store_unit_i__busy_o(
  u_ibex_core.load_store_unit_i.busy_o),
.u_ibex_core__load_store_unit_i__perf_load_o(
  u_ibex_core.load_store_unit_i.perf_load_o),
.u_ibex_core__load_store_unit_i__perf_store_o(
  u_ibex_core.load_store_unit_i.perf_store_o),
.u_ibex_core__load_store_unit_i__busy_o_t0(
  u_ibex_core.load_store_unit_i.busy_o_t0),
.u_ibex_core__load_store_unit_i__data_req_o_t0(
  u_ibex_core.load_store_unit_i.data_req_o_t0),
.u_ibex_core__load_store_unit_i__data_we_o_t0(
  u_ibex_core.load_store_unit_i.data_we_o_t0),
.u_ibex_core__load_store_unit_i__adder_result_ex_i_t0(
  u_ibex_core.load_store_unit_i.adder_result_ex_i_t0),
.u_ibex_core__load_store_unit_i__addr_incr_req_o_t0(
  u_ibex_core.load_store_unit_i.addr_incr_req_o_t0),
.u_ibex_core__load_store_unit_i__addr_last_o_t0(
  u_ibex_core.load_store_unit_i.addr_last_o_t0),
.u_ibex_core__load_store_unit_i__data_addr_o_t0(
  u_ibex_core.load_store_unit_i.data_addr_o_t0),
.u_ibex_core__load_store_unit_i__data_be_o_t0(
  u_ibex_core.load_store_unit_i.data_be_o_t0),
.u_ibex_core__load_store_unit_i__data_bus_err_i_t0(
  u_ibex_core.load_store_unit_i.data_bus_err_i_t0),
.u_ibex_core__load_store_unit_i__data_gnt_i_t0(
  u_ibex_core.load_store_unit_i.data_gnt_i_t0),
.u_ibex_core__load_store_unit_i__data_pmp_err_i_t0(
  u_ibex_core.load_store_unit_i.data_pmp_err_i_t0),
.u_ibex_core__load_store_unit_i__data_rdata_i_t0(
  u_ibex_core.load_store_unit_i.data_rdata_i_t0),
.u_ibex_core__load_store_unit_i__data_rvalid_i_t0(
  u_ibex_core.load_store_unit_i.data_rvalid_i_t0),
.u_ibex_core__load_store_unit_i__data_wdata_o_t0(
  u_ibex_core.load_store_unit_i.data_wdata_o_t0),
.u_ibex_core__load_store_unit_i__load_err_o_t0(
  u_ibex_core.load_store_unit_i.load_err_o_t0),
.u_ibex_core__load_store_unit_i__load_resp_intg_err_o_t0(
  u_ibex_core.load_store_unit_i.load_resp_intg_err_o_t0),
.u_ibex_core__load_store_unit_i__lsu_rdata_o_t0(
  u_ibex_core.load_store_unit_i.lsu_rdata_o_t0),
.u_ibex_core__load_store_unit_i__lsu_rdata_valid_o_t0(
  u_ibex_core.load_store_unit_i.lsu_rdata_valid_o_t0),
.u_ibex_core__load_store_unit_i__lsu_req_done_o_t0(
  u_ibex_core.load_store_unit_i.lsu_req_done_o_t0),
.u_ibex_core__load_store_unit_i__lsu_req_i_t0(
  u_ibex_core.load_store_unit_i.lsu_req_i_t0),
.u_ibex_core__load_store_unit_i__lsu_resp_valid_o_t0(
  u_ibex_core.load_store_unit_i.lsu_resp_valid_o_t0),
.u_ibex_core__load_store_unit_i__lsu_sign_ext_i_t0(
  u_ibex_core.load_store_unit_i.lsu_sign_ext_i_t0),
.u_ibex_core__load_store_unit_i__lsu_type_i_t0(
  u_ibex_core.load_store_unit_i.lsu_type_i_t0),
.u_ibex_core__load_store_unit_i__lsu_wdata_i_t0(
  u_ibex_core.load_store_unit_i.lsu_wdata_i_t0),
.u_ibex_core__load_store_unit_i__lsu_we_i_t0(
  u_ibex_core.load_store_unit_i.lsu_we_i_t0),
.u_ibex_core__load_store_unit_i__perf_load_o_t0(
  u_ibex_core.load_store_unit_i.perf_load_o_t0),
.u_ibex_core__load_store_unit_i__perf_store_o_t0(
  u_ibex_core.load_store_unit_i.perf_store_o_t0),
.u_ibex_core__load_store_unit_i__store_err_o_t0(
  u_ibex_core.load_store_unit_i.store_err_o_t0),
.u_ibex_core__load_store_unit_i__store_resp_intg_err_o_t0(
  u_ibex_core.load_store_unit_i.store_resp_intg_err_o_t0),
.u_ibex_core__load_store_unit_i__addr_last_d(
  u_ibex_core.load_store_unit_i.addr_last_d),
.u_ibex_core__load_store_unit_i__addr_last_d_t0(
  u_ibex_core.load_store_unit_i.addr_last_d_t0),
.u_ibex_core__load_store_unit_i__addr_update(
  u_ibex_core.load_store_unit_i.addr_update),
.u_ibex_core__load_store_unit_i__addr_update_t0(
  u_ibex_core.load_store_unit_i.addr_update_t0),
.u_ibex_core__load_store_unit_i__ctrl_update(
  u_ibex_core.load_store_unit_i.ctrl_update),
.u_ibex_core__load_store_unit_i__ctrl_update_t0(
  u_ibex_core.load_store_unit_i.ctrl_update_t0),
.u_ibex_core__load_store_unit_i__data_intg_err(
  u_ibex_core.load_store_unit_i.data_intg_err),
.u_ibex_core__load_store_unit_i__data_intg_err_t0(
  u_ibex_core.load_store_unit_i.data_intg_err_t0),
.u_ibex_core__load_store_unit_i__data_or_pmp_err(
  u_ibex_core.load_store_unit_i.data_or_pmp_err),
.u_ibex_core__load_store_unit_i__data_or_pmp_err_t0(
  u_ibex_core.load_store_unit_i.data_or_pmp_err_t0),
.u_ibex_core__load_store_unit_i__data_sign_ext_q(
  u_ibex_core.load_store_unit_i.data_sign_ext_q),
.u_ibex_core__load_store_unit_i__data_sign_ext_q_t0(
  u_ibex_core.load_store_unit_i.data_sign_ext_q_t0),
.u_ibex_core__load_store_unit_i__data_type_q(
  u_ibex_core.load_store_unit_i.data_type_q),
.u_ibex_core__load_store_unit_i__data_type_q_t0(
  u_ibex_core.load_store_unit_i.data_type_q_t0),
.u_ibex_core__load_store_unit_i__data_wdata(
  u_ibex_core.load_store_unit_i.data_wdata),
.u_ibex_core__load_store_unit_i__data_wdata_t0(
  u_ibex_core.load_store_unit_i.data_wdata_t0),
.u_ibex_core__load_store_unit_i__data_we_q(
  u_ibex_core.load_store_unit_i.data_we_q),
.u_ibex_core__load_store_unit_i__data_we_q_t0(
  u_ibex_core.load_store_unit_i.data_we_q_t0),
.u_ibex_core__load_store_unit_i__g_mem_rdata_ecc__data_rdata_buf(
  u_ibex_core.load_store_unit_i.\g_mem_rdata_ecc.data_rdata_buf ),
.u_ibex_core__load_store_unit_i__g_mem_rdata_ecc__data_rdata_buf_t0(
  u_ibex_core.load_store_unit_i.\g_mem_rdata_ecc.data_rdata_buf_t0 ),
.u_ibex_core__load_store_unit_i__g_mem_rdata_ecc__ecc_err(
  u_ibex_core.load_store_unit_i.\g_mem_rdata_ecc.ecc_err ),
.u_ibex_core__load_store_unit_i__g_mem_rdata_ecc__ecc_err_t0(
  u_ibex_core.load_store_unit_i.\g_mem_rdata_ecc.ecc_err_t0 ),
.u_ibex_core__load_store_unit_i__handle_misaligned_d(
  u_ibex_core.load_store_unit_i.handle_misaligned_d),
.u_ibex_core__load_store_unit_i__handle_misaligned_d_t0(
  u_ibex_core.load_store_unit_i.handle_misaligned_d_t0),
.u_ibex_core__load_store_unit_i__handle_misaligned_q(
  u_ibex_core.load_store_unit_i.handle_misaligned_q),
.u_ibex_core__load_store_unit_i__handle_misaligned_q_t0(
  u_ibex_core.load_store_unit_i.handle_misaligned_q_t0),
.u_ibex_core__load_store_unit_i__ls_fsm_cs(
  u_ibex_core.load_store_unit_i.ls_fsm_cs),
.u_ibex_core__load_store_unit_i__ls_fsm_cs_t0(
  u_ibex_core.load_store_unit_i.ls_fsm_cs_t0),
.u_ibex_core__load_store_unit_i__ls_fsm_ns(
  u_ibex_core.load_store_unit_i.ls_fsm_ns),
.u_ibex_core__load_store_unit_i__ls_fsm_ns_t0(
  u_ibex_core.load_store_unit_i.ls_fsm_ns_t0),
.u_ibex_core__load_store_unit_i__lsu_err_d(
  u_ibex_core.load_store_unit_i.lsu_err_d),
.u_ibex_core__load_store_unit_i__lsu_err_d_t0(
  u_ibex_core.load_store_unit_i.lsu_err_d_t0),
.u_ibex_core__load_store_unit_i__lsu_err_q(
  u_ibex_core.load_store_unit_i.lsu_err_q),
.u_ibex_core__load_store_unit_i__lsu_err_q_t0(
  u_ibex_core.load_store_unit_i.lsu_err_q_t0),
.u_ibex_core__load_store_unit_i__pmp_err_d(
  u_ibex_core.load_store_unit_i.pmp_err_d),
.u_ibex_core__load_store_unit_i__pmp_err_d_t0(
  u_ibex_core.load_store_unit_i.pmp_err_d_t0),
.u_ibex_core__load_store_unit_i__pmp_err_q(
  u_ibex_core.load_store_unit_i.pmp_err_q),
.u_ibex_core__load_store_unit_i__pmp_err_q_t0(
  u_ibex_core.load_store_unit_i.pmp_err_q_t0),
.u_ibex_core__load_store_unit_i__rdata_b_ext(
  u_ibex_core.load_store_unit_i.rdata_b_ext),
.u_ibex_core__load_store_unit_i__rdata_b_ext_t0(
  u_ibex_core.load_store_unit_i.rdata_b_ext_t0),
.u_ibex_core__load_store_unit_i__rdata_h_ext(
  u_ibex_core.load_store_unit_i.rdata_h_ext),
.u_ibex_core__load_store_unit_i__rdata_h_ext_t0(
  u_ibex_core.load_store_unit_i.rdata_h_ext_t0),
.u_ibex_core__load_store_unit_i__rdata_offset_q(
  u_ibex_core.load_store_unit_i.rdata_offset_q),
.u_ibex_core__load_store_unit_i__rdata_offset_q_t0(
  u_ibex_core.load_store_unit_i.rdata_offset_q_t0),
.u_ibex_core__load_store_unit_i__rdata_q(
  u_ibex_core.load_store_unit_i.rdata_q),
.u_ibex_core__load_store_unit_i__rdata_q_t0(
  u_ibex_core.load_store_unit_i.rdata_q_t0),
.u_ibex_core__load_store_unit_i__rdata_update(
  u_ibex_core.load_store_unit_i.rdata_update),
.u_ibex_core__load_store_unit_i__rdata_update_t0(
  u_ibex_core.load_store_unit_i.rdata_update_t0),
.u_ibex_core__load_store_unit_i__rdata_w_ext(
  u_ibex_core.load_store_unit_i.rdata_w_ext),
.u_ibex_core__load_store_unit_i__rdata_w_ext_t0(
  u_ibex_core.load_store_unit_i.rdata_w_ext_t0),
.u_ibex_core__load_store_unit_i__split_misaligned_access(
  u_ibex_core.load_store_unit_i.split_misaligned_access),
.u_ibex_core__load_store_unit_i__split_misaligned_access_t0(
  u_ibex_core.load_store_unit_i.split_misaligned_access_t0),
.u_ibex_core__load_store_unit_i__g_mem_rdata_ecc__u_data_intg_dec__data_i(
  u_ibex_core.load_store_unit_i.\g_mem_rdata_ecc.u_data_intg_dec .data_i),
.u_ibex_core__load_store_unit_i__g_mem_rdata_ecc__u_data_intg_dec__data_o(
  u_ibex_core.load_store_unit_i.\g_mem_rdata_ecc.u_data_intg_dec .data_o),
.u_ibex_core__load_store_unit_i__g_mem_rdata_ecc__u_data_intg_dec__syndrome_o(
  u_ibex_core.load_store_unit_i.\g_mem_rdata_ecc.u_data_intg_dec .syndrome_o),
.u_ibex_core__load_store_unit_i__g_mem_rdata_ecc__u_data_intg_dec__err_o(
  u_ibex_core.load_store_unit_i.\g_mem_rdata_ecc.u_data_intg_dec .err_o),
.u_ibex_core__load_store_unit_i__g_mem_rdata_ecc__u_data_intg_dec__syndrome_o_t0(
  u_ibex_core.load_store_unit_i.\g_mem_rdata_ecc.u_data_intg_dec .syndrome_o_t0),
.u_ibex_core__load_store_unit_i__g_mem_rdata_ecc__u_data_intg_dec__err_o_t0(
  u_ibex_core.load_store_unit_i.\g_mem_rdata_ecc.u_data_intg_dec .err_o_t0),
.u_ibex_core__load_store_unit_i__g_mem_rdata_ecc__u_data_intg_dec__data_o_t0(
  u_ibex_core.load_store_unit_i.\g_mem_rdata_ecc.u_data_intg_dec .data_o_t0),
.u_ibex_core__load_store_unit_i__g_mem_rdata_ecc__u_data_intg_dec__data_i_t0(
  u_ibex_core.load_store_unit_i.\g_mem_rdata_ecc.u_data_intg_dec .data_i_t0),
.u_ibex_core__load_store_unit_i__g_mem_rdata_ecc__u_prim_buf_instr_rdata__in_i(
  u_ibex_core.load_store_unit_i.\g_mem_rdata_ecc.u_prim_buf_instr_rdata .in_i),
.u_ibex_core__load_store_unit_i__g_mem_rdata_ecc__u_prim_buf_instr_rdata__out_o(
  u_ibex_core.load_store_unit_i.\g_mem_rdata_ecc.u_prim_buf_instr_rdata .out_o),
.u_ibex_core__load_store_unit_i__g_mem_rdata_ecc__u_prim_buf_instr_rdata__in_i_t0(
  u_ibex_core.load_store_unit_i.\g_mem_rdata_ecc.u_prim_buf_instr_rdata .in_i_t0),
.u_ibex_core__load_store_unit_i__g_mem_rdata_ecc__u_prim_buf_instr_rdata__out_o_t0(
  u_ibex_core.load_store_unit_i.\g_mem_rdata_ecc.u_prim_buf_instr_rdata .out_o_t0),
.u_ibex_core__load_store_unit_i__g_mem_rdata_ecc__u_prim_buf_instr_rdata__gen_generic__u_impl_generic__in_i(
  u_ibex_core.load_store_unit_i.\g_mem_rdata_ecc.u_prim_buf_instr_rdata .\gen_generic.u_impl_generic .in_i),
.u_ibex_core__load_store_unit_i__g_mem_rdata_ecc__u_prim_buf_instr_rdata__gen_generic__u_impl_generic__out_o(
  u_ibex_core.load_store_unit_i.\g_mem_rdata_ecc.u_prim_buf_instr_rdata .\gen_generic.u_impl_generic .out_o),
.u_ibex_core__load_store_unit_i__g_mem_rdata_ecc__u_prim_buf_instr_rdata__gen_generic__u_impl_generic__in_i_t0(
  u_ibex_core.load_store_unit_i.\g_mem_rdata_ecc.u_prim_buf_instr_rdata .\gen_generic.u_impl_generic .in_i_t0),
.u_ibex_core__load_store_unit_i__g_mem_rdata_ecc__u_prim_buf_instr_rdata__gen_generic__u_impl_generic__out_o_t0(
  u_ibex_core.load_store_unit_i.\g_mem_rdata_ecc.u_prim_buf_instr_rdata .\gen_generic.u_impl_generic .out_o_t0),
.u_ibex_core__load_store_unit_i__g_mem_rdata_ecc__u_prim_buf_instr_rdata__gen_generic__u_impl_generic__inv(
  u_ibex_core.load_store_unit_i.\g_mem_rdata_ecc.u_prim_buf_instr_rdata .\gen_generic.u_impl_generic .inv),
.u_ibex_core__load_store_unit_i__g_mem_wdata_ecc__u_data_gen__data_i(
  u_ibex_core.load_store_unit_i.\g_mem_wdata_ecc.u_data_gen .data_i),
.u_ibex_core__load_store_unit_i__g_mem_wdata_ecc__u_data_gen__data_o(
  u_ibex_core.load_store_unit_i.\g_mem_wdata_ecc.u_data_gen .data_o),
.u_ibex_core__load_store_unit_i__g_mem_wdata_ecc__u_data_gen__data_o_t0(
  u_ibex_core.load_store_unit_i.\g_mem_wdata_ecc.u_data_gen .data_o_t0),
.u_ibex_core__load_store_unit_i__g_mem_wdata_ecc__u_data_gen__data_i_t0(
  u_ibex_core.load_store_unit_i.\g_mem_wdata_ecc.u_data_gen .data_i_t0),
.u_ibex_core__wb_stage_i__clk_i(
  u_ibex_core.wb_stage_i.clk_i),
.u_ibex_core__wb_stage_i__rst_ni(
  u_ibex_core.wb_stage_i.rst_ni),
.u_ibex_core__wb_stage_i__en_wb_i(
  u_ibex_core.wb_stage_i.en_wb_i),
.u_ibex_core__wb_stage_i__instr_type_wb_i(
  u_ibex_core.wb_stage_i.instr_type_wb_i),
.u_ibex_core__wb_stage_i__pc_id_i(
  u_ibex_core.wb_stage_i.pc_id_i),
.u_ibex_core__wb_stage_i__instr_is_compressed_id_i(
  u_ibex_core.wb_stage_i.instr_is_compressed_id_i),
.u_ibex_core__wb_stage_i__instr_perf_count_id_i(
  u_ibex_core.wb_stage_i.instr_perf_count_id_i),
.u_ibex_core__wb_stage_i__ready_wb_o(
  u_ibex_core.wb_stage_i.ready_wb_o),
.u_ibex_core__wb_stage_i__rf_write_wb_o(
  u_ibex_core.wb_stage_i.rf_write_wb_o),
.u_ibex_core__wb_stage_i__outstanding_load_wb_o(
  u_ibex_core.wb_stage_i.outstanding_load_wb_o),
.u_ibex_core__wb_stage_i__outstanding_store_wb_o(
  u_ibex_core.wb_stage_i.outstanding_store_wb_o),
.u_ibex_core__wb_stage_i__pc_wb_o(
  u_ibex_core.wb_stage_i.pc_wb_o),
.u_ibex_core__wb_stage_i__perf_instr_ret_wb_o(
  u_ibex_core.wb_stage_i.perf_instr_ret_wb_o),
.u_ibex_core__wb_stage_i__perf_instr_ret_compressed_wb_o(
  u_ibex_core.wb_stage_i.perf_instr_ret_compressed_wb_o),
.u_ibex_core__wb_stage_i__perf_instr_ret_wb_spec_o(
  u_ibex_core.wb_stage_i.perf_instr_ret_wb_spec_o),
.u_ibex_core__wb_stage_i__perf_instr_ret_compressed_wb_spec_o(
  u_ibex_core.wb_stage_i.perf_instr_ret_compressed_wb_spec_o),
.u_ibex_core__wb_stage_i__rf_waddr_id_i(
  u_ibex_core.wb_stage_i.rf_waddr_id_i),
.u_ibex_core__wb_stage_i__rf_wdata_id_i(
  u_ibex_core.wb_stage_i.rf_wdata_id_i),
.u_ibex_core__wb_stage_i__rf_we_id_i(
  u_ibex_core.wb_stage_i.rf_we_id_i),
.u_ibex_core__wb_stage_i__dummy_instr_id_i(
  u_ibex_core.wb_stage_i.dummy_instr_id_i),
.u_ibex_core__wb_stage_i__rf_wdata_lsu_i(
  u_ibex_core.wb_stage_i.rf_wdata_lsu_i),
.u_ibex_core__wb_stage_i__rf_we_lsu_i(
  u_ibex_core.wb_stage_i.rf_we_lsu_i),
.u_ibex_core__wb_stage_i__rf_wdata_fwd_wb_o(
  u_ibex_core.wb_stage_i.rf_wdata_fwd_wb_o),
.u_ibex_core__wb_stage_i__rf_waddr_wb_o(
  u_ibex_core.wb_stage_i.rf_waddr_wb_o),
.u_ibex_core__wb_stage_i__rf_wdata_wb_o(
  u_ibex_core.wb_stage_i.rf_wdata_wb_o),
.u_ibex_core__wb_stage_i__rf_we_wb_o(
  u_ibex_core.wb_stage_i.rf_we_wb_o),
.u_ibex_core__wb_stage_i__dummy_instr_wb_o(
  u_ibex_core.wb_stage_i.dummy_instr_wb_o),
.u_ibex_core__wb_stage_i__lsu_resp_valid_i(
  u_ibex_core.wb_stage_i.lsu_resp_valid_i),
.u_ibex_core__wb_stage_i__lsu_resp_err_i(
  u_ibex_core.wb_stage_i.lsu_resp_err_i),
.u_ibex_core__wb_stage_i__instr_done_wb_o(
  u_ibex_core.wb_stage_i.instr_done_wb_o),
.u_ibex_core__wb_stage_i__pc_id_i_t0(
  u_ibex_core.wb_stage_i.pc_id_i_t0),
.u_ibex_core__wb_stage_i__lsu_resp_valid_i_t0(
  u_ibex_core.wb_stage_i.lsu_resp_valid_i_t0),
.u_ibex_core__wb_stage_i__dummy_instr_id_i_t0(
  u_ibex_core.wb_stage_i.dummy_instr_id_i_t0),
.u_ibex_core__wb_stage_i__dummy_instr_wb_o_t0(
  u_ibex_core.wb_stage_i.dummy_instr_wb_o_t0),
.u_ibex_core__wb_stage_i__en_wb_i_t0(
  u_ibex_core.wb_stage_i.en_wb_i_t0),
.u_ibex_core__wb_stage_i__instr_done_wb_o_t0(
  u_ibex_core.wb_stage_i.instr_done_wb_o_t0),
.u_ibex_core__wb_stage_i__instr_is_compressed_id_i_t0(
  u_ibex_core.wb_stage_i.instr_is_compressed_id_i_t0),
.u_ibex_core__wb_stage_i__instr_perf_count_id_i_t0(
  u_ibex_core.wb_stage_i.instr_perf_count_id_i_t0),
.u_ibex_core__wb_stage_i__instr_type_wb_i_t0(
  u_ibex_core.wb_stage_i.instr_type_wb_i_t0),
.u_ibex_core__wb_stage_i__lsu_resp_err_i_t0(
  u_ibex_core.wb_stage_i.lsu_resp_err_i_t0),
.u_ibex_core__wb_stage_i__outstanding_load_wb_o_t0(
  u_ibex_core.wb_stage_i.outstanding_load_wb_o_t0),
.u_ibex_core__wb_stage_i__outstanding_store_wb_o_t0(
  u_ibex_core.wb_stage_i.outstanding_store_wb_o_t0),
.u_ibex_core__wb_stage_i__pc_wb_o_t0(
  u_ibex_core.wb_stage_i.pc_wb_o_t0),
.u_ibex_core__wb_stage_i__perf_instr_ret_compressed_wb_o_t0(
  u_ibex_core.wb_stage_i.perf_instr_ret_compressed_wb_o_t0),
.u_ibex_core__wb_stage_i__perf_instr_ret_compressed_wb_spec_o_t0(
  u_ibex_core.wb_stage_i.perf_instr_ret_compressed_wb_spec_o_t0),
.u_ibex_core__wb_stage_i__perf_instr_ret_wb_o_t0(
  u_ibex_core.wb_stage_i.perf_instr_ret_wb_o_t0),
.u_ibex_core__wb_stage_i__perf_instr_ret_wb_spec_o_t0(
  u_ibex_core.wb_stage_i.perf_instr_ret_wb_spec_o_t0),
.u_ibex_core__wb_stage_i__ready_wb_o_t0(
  u_ibex_core.wb_stage_i.ready_wb_o_t0),
.u_ibex_core__wb_stage_i__rf_waddr_id_i_t0(
  u_ibex_core.wb_stage_i.rf_waddr_id_i_t0),
.u_ibex_core__wb_stage_i__rf_waddr_wb_o_t0(
  u_ibex_core.wb_stage_i.rf_waddr_wb_o_t0),
.u_ibex_core__wb_stage_i__rf_wdata_fwd_wb_o_t0(
  u_ibex_core.wb_stage_i.rf_wdata_fwd_wb_o_t0),
.u_ibex_core__wb_stage_i__rf_wdata_id_i_t0(
  u_ibex_core.wb_stage_i.rf_wdata_id_i_t0),
.u_ibex_core__wb_stage_i__rf_wdata_lsu_i_t0(
  u_ibex_core.wb_stage_i.rf_wdata_lsu_i_t0),
.u_ibex_core__wb_stage_i__rf_wdata_wb_o_t0(
  u_ibex_core.wb_stage_i.rf_wdata_wb_o_t0),
.u_ibex_core__wb_stage_i__rf_we_id_i_t0(
  u_ibex_core.wb_stage_i.rf_we_id_i_t0),
.u_ibex_core__wb_stage_i__rf_we_lsu_i_t0(
  u_ibex_core.wb_stage_i.rf_we_lsu_i_t0),
.u_ibex_core__wb_stage_i__rf_we_wb_o_t0(
  u_ibex_core.wb_stage_i.rf_we_wb_o_t0),
.u_ibex_core__wb_stage_i__rf_write_wb_o_t0(
  u_ibex_core.wb_stage_i.rf_write_wb_o_t0),
.u_ibex_core__wb_stage_i__g_writeback_stage__rf_we_wb_q(
  u_ibex_core.wb_stage_i.\g_writeback_stage.rf_we_wb_q ),
.u_ibex_core__wb_stage_i__g_writeback_stage__rf_we_wb_q_t0(
  u_ibex_core.wb_stage_i.\g_writeback_stage.rf_we_wb_q_t0 ),
.u_ibex_core__wb_stage_i__g_writeback_stage__wb_compressed_q(
  u_ibex_core.wb_stage_i.\g_writeback_stage.wb_compressed_q ),
.u_ibex_core__wb_stage_i__g_writeback_stage__wb_compressed_q_t0(
  u_ibex_core.wb_stage_i.\g_writeback_stage.wb_compressed_q_t0 ),
.u_ibex_core__wb_stage_i__g_writeback_stage__wb_done(
  u_ibex_core.wb_stage_i.\g_writeback_stage.wb_done ),
.u_ibex_core__wb_stage_i__g_writeback_stage__wb_done_t0(
  u_ibex_core.wb_stage_i.\g_writeback_stage.wb_done_t0 ),
.u_ibex_core__wb_stage_i__g_writeback_stage__wb_instr_type_q(
  u_ibex_core.wb_stage_i.\g_writeback_stage.wb_instr_type_q ),
.u_ibex_core__wb_stage_i__g_writeback_stage__wb_instr_type_q_t0(
  u_ibex_core.wb_stage_i.\g_writeback_stage.wb_instr_type_q_t0 ),
.u_ibex_core__wb_stage_i__g_writeback_stage__wb_valid_d(
  u_ibex_core.wb_stage_i.\g_writeback_stage.wb_valid_d ),
.u_ibex_core__wb_stage_i__g_writeback_stage__wb_valid_d_t0(
  u_ibex_core.wb_stage_i.\g_writeback_stage.wb_valid_d_t0 ),
.u_ibex_core__wb_stage_i__g_writeback_stage__wb_valid_q(
  u_ibex_core.wb_stage_i.\g_writeback_stage.wb_valid_q ),
.u_ibex_core__wb_stage_i__g_writeback_stage__wb_valid_q_t0(
  u_ibex_core.wb_stage_i.\g_writeback_stage.wb_valid_q_t0 ),
.u_ibex_core__wb_stage_i__rf_wdata_wb_mux_we(
  u_ibex_core.wb_stage_i.rf_wdata_wb_mux_we),
.u_ibex_core__wb_stage_i__rf_wdata_wb_mux_we_t0(
  u_ibex_core.wb_stage_i.rf_wdata_wb_mux_we_t0),
.u_rf_rdata_a_ecc_buf__in_i(
  u_rf_rdata_a_ecc_buf.in_i),
.u_rf_rdata_a_ecc_buf__out_o(
  u_rf_rdata_a_ecc_buf.out_o),
.u_rf_rdata_a_ecc_buf__in_i_t0(
  u_rf_rdata_a_ecc_buf.in_i_t0),
.u_rf_rdata_a_ecc_buf__out_o_t0(
  u_rf_rdata_a_ecc_buf.out_o_t0),
.u_rf_rdata_a_ecc_buf__gen_generic__u_impl_generic__in_i(
  u_rf_rdata_a_ecc_buf.\gen_generic.u_impl_generic .in_i),
.u_rf_rdata_a_ecc_buf__gen_generic__u_impl_generic__out_o(
  u_rf_rdata_a_ecc_buf.\gen_generic.u_impl_generic .out_o),
.u_rf_rdata_a_ecc_buf__gen_generic__u_impl_generic__in_i_t0(
  u_rf_rdata_a_ecc_buf.\gen_generic.u_impl_generic .in_i_t0),
.u_rf_rdata_a_ecc_buf__gen_generic__u_impl_generic__out_o_t0(
  u_rf_rdata_a_ecc_buf.\gen_generic.u_impl_generic .out_o_t0),
.u_rf_rdata_a_ecc_buf__gen_generic__u_impl_generic__inv(
  u_rf_rdata_a_ecc_buf.\gen_generic.u_impl_generic .inv),
.u_rf_rdata_b_ecc_buf__in_i(
  u_rf_rdata_b_ecc_buf.in_i),
.u_rf_rdata_b_ecc_buf__out_o(
  u_rf_rdata_b_ecc_buf.out_o),
.u_rf_rdata_b_ecc_buf__in_i_t0(
  u_rf_rdata_b_ecc_buf.in_i_t0),
.u_rf_rdata_b_ecc_buf__out_o_t0(
  u_rf_rdata_b_ecc_buf.out_o_t0),
.u_rf_rdata_b_ecc_buf__gen_generic__u_impl_generic__in_i(
  u_rf_rdata_b_ecc_buf.\gen_generic.u_impl_generic .in_i),
.u_rf_rdata_b_ecc_buf__gen_generic__u_impl_generic__out_o(
  u_rf_rdata_b_ecc_buf.\gen_generic.u_impl_generic .out_o),
.u_rf_rdata_b_ecc_buf__gen_generic__u_impl_generic__in_i_t0(
  u_rf_rdata_b_ecc_buf.\gen_generic.u_impl_generic .in_i_t0),
.u_rf_rdata_b_ecc_buf__gen_generic__u_impl_generic__out_o_t0(
  u_rf_rdata_b_ecc_buf.\gen_generic.u_impl_generic .out_o_t0),
.u_rf_rdata_b_ecc_buf__gen_generic__u_impl_generic__inv(
  u_rf_rdata_b_ecc_buf.\gen_generic.u_impl_generic .inv),
.u_ibex_core__cs_registers_i___3299_(
  u_ibex_core.cs_registers_i._3299_)
);
