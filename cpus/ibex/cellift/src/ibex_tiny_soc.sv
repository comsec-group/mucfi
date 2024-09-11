// Copyright 2022 Flavien Solt, ETH Zurich.
// Licensed under the General Public License, Version 3.0, see LICENSE for details.
// SPDX-License-Identifier: GPL-3.0-only

module ibex_tiny_soc #(
    parameter int unsigned NumTaints = 1,

    // The two below must be equal.
    parameter int unsigned InstrMemDepth = 1 << 20, // 32-bit words
    parameter int unsigned DataMemDepth  = 1 << 20, // 32-bit words

    localparam type data_t = logic [31:0],
    localparam type strb_t = logic [31:0], // The strobe is bitwise.
    localparam type addr_t = logic [31:0]
) (
  input logic clk_i,
  input logic rst_ni,

  input  logic [1:0] esc_tx_i,

  output logic  instr_mem_req_o,
  output addr_t instr_mem_addr_o,
  output data_t instr_mem_wdata_o,
  output strb_t instr_mem_strb_o,
  output logic  instr_mem_we_o,
  output data_t instr_mem_rdata_o,

  output logic  data_mem_req_o,
  output addr_t data_mem_addr_o,
  output data_t data_mem_wdata_o,
  output strb_t data_mem_strb_o,
  output logic  data_mem_we_o,
  output data_t data_mem_rdata_o,

  input  logic [31:0] hart_id_i,
  input  logic [31:0] boot_addr_i
);

  logic instr_mem_gnt;
  logic data_mem_gnt;

  ///////////////////
  // Ibex instance //
  ///////////////////

  logic clk_esc;
  logic rst_esc;
  logic rst_cpu_n;
  prim_mubi_pkg::mubi4_t scanmode;
  prim_ram_1p_pkg::ram_1p_cfg_t ram_cfg;
  logic [31:0] hart_id;
  logic [31:0] boot_addr;
  logic irq_software;
  logic irq_timer;
  logic irq_external;
  logic nmi_wdog;
  prim_esc_pkg::esc_tx_t esc_tx;
  prim_esc_pkg::esc_rx_t esc_rx;
  logic debug_req;
  ibex_pkg::crash_dump_t crash_dump;
  lc_ctrl_pkg::lc_tx_t pwrmgr_cpu_en;
  lc_ctrl_pkg::lc_tx_t lc_cpu_en;
  pwrmgr_pkg::pwr_cpu_t pwrmgr_o;
  // peripheral interface access
  tlul_pkg::tl_h2d_t cfg_tl_d_i_;
  tlul_pkg::tl_d2h_t cfg_tl_d_o_;
  // connection to edn - Entropy Distribution Network
  edn_pkg::edn_req_t edn_o_;
  edn_pkg::edn_rsp_t edn_i_;
  // connection to otp scramble interface
  logic clk_otp;
  logic rst_otp;
  otp_ctrl_pkg::sram_otp_key_req_t icache_otp_key_o_;
  otp_ctrl_pkg::sram_otp_key_rsp_t icache_otp_key_i_;


  assign clk_esc = '0;
  assign rst_esc = '0;
  assign clk_edn = '0;
  assign rst_edn = '0;
  assign scanmode = prim_mubi_pkg::MuBi4False;
  assign ram_cfg = '0;
  assign hart_id = hart_id_i;
  assign boot_addr = boot_addr_i;
  assign irq_software = '0;
  assign irq_timer = '0;
  assign irq_external = '0;
  assign esc_tx = '0;
  assign nmi_wdog = '0;
  assign debug_req = '0;
  assign lc_cpu_en = lc_ctrl_pkg::On;
  assign pwrmgr_cpu_en = lc_ctrl_pkg::On;
  assign cfg_tl_d_i_ = '0;
  assign edn_i_ = '0;
  assign clk_otp = '0;
  assign rst_otp = '0;
  assign icache_otp_key_i_ = '0;
  assign fpga_info = '0;
  assign alert_rx = '0;

  cellift_cellift_rv_core_ibex_mem_top i_mem_top (
    // Regular signals
    .clk_i,
    .rst_ni,
    .clk_edn_i             (clk_edn),
    .rst_edn_ni            (rst_edn),
    .clk_esc_i             (clk_esc),
    .rst_esc_ni            (rst_esc),
    .rst_cpu_n_o           (rst_cpu_n),
    .ram_cfg_i             (ram_cfg),
    .hart_id_i             (hart_id),
    .boot_addr_i           (boot_addr),
    // Instruction memory interface
    .instr_mem_req_o       (instr_mem_req_o),
    .instr_mem_gnt_i       (instr_mem_gnt),
    .instr_mem_addr_o      (instr_mem_addr_o),
    .instr_mem_wdata_o     (instr_mem_wdata_o),
    .instr_mem_strb_o      (instr_mem_strb_o),
    .instr_mem_we_o        (instr_mem_we_o),
    .instr_mem_rdata_i     (instr_mem_rdata_o),
    // Data memory interface
    .data_mem_req_o        (data_mem_req_o),
    .data_mem_gnt_i        (data_mem_gnt),
    .data_mem_addr_o       (data_mem_addr_o),
    .data_mem_wdata_o      (data_mem_wdata_o),
    .data_mem_strb_o       (data_mem_strb_o),
    .data_mem_we_o         (data_mem_we_o),
    .data_mem_rdata_i      (data_mem_rdata_o),
    // Interrupt inputs
    .irq_software_i        (irq_software),
    .irq_timer_i           (irq_timer),
    .irq_external_i        (irq_external),
    // Escalation input for NMI
    .esc_tx_i              (esc_tx),
    .esc_rx_o              (esc_rx),
    .nmi_wdog_i            (nmi_wdog),
    // Debug Interface
    .debug_req_i           (debug_req),
    // Crash dump information
    .crash_dump_o          (crash_dump),
    .pwrmgr_cpu_en_i       (pwrmgr_cpu_en),
    .lc_cpu_en_i           (lc_cpu_en),

    .scanmode_i            (scanmode),
    .cfg_tl_d_i            (cfg_tl_d_i_),
    .edn_i                 (edn_i_),
    .edn_o                 (edn_o_),
    .clk_otp_i             (clk_otp),
    .rst_otp_ni            (rst_otp),
    .icache_otp_key_o      (icache_otp_key_o_),
    .icache_otp_key_i      (icache_otp_key_i_),
    .fpga_info_i           (fpga_info),
    .alert_rx_i            (alert_rx),
    .alert_tx_o            (alert_tx)
  );

  //////////////////////////////
  // Instruction ROM instance //
  //////////////////////////////

  noift_sram_mem #(
    .Width(32),
    .Depth(InstrMemDepth),
    .RelocateRequestUp(64'h10000000) // 80000000 >> 3
  ) i_instr_rom (
    .clk_i,
    .rst_ni,

    .req_i(instr_mem_req_o),
    .write_i(instr_mem_we_o),
    .addr_i(instr_mem_addr_o), // 32-bit words
    .wdata_i(instr_mem_wdata_o),
    .wmask_i(instr_mem_strb_o),
    .rdata_o(instr_mem_rdata_o)
  );

  assign instr_mem_gnt = '1;

  ////////////////////////
  // Data SRAM instance //
  ////////////////////////

  noift_sram_mem #(
    .Width(32),
    .Depth(DataMemDepth),
    .RelocateRequestUp(64'h10000000) // 80000000 >> 3
  ) i_data_sram (
    .clk_i,
    .rst_ni,

    .req_i(data_mem_req_o),
    .write_i(data_mem_we_o),
    .addr_i(data_mem_addr_o), // 32-bit words
    .wdata_i(data_mem_wdata_o),
    .wmask_i(data_mem_strb_o),
    .rdata_o(data_mem_rdata_o)
  );

  assign data_mem_gnt = '1;

endmodule
