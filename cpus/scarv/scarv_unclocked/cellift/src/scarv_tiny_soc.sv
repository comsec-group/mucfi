// Copyright 2022 Flavien Solt, ETH Zurich.
// Licensed under the General Public License, Version 3.0, see LICENSE for details.
// SPDX-License-Identifier: GPL-3.0-only

module scarv_tiny_soc #(
    // The two below must be equal.
    parameter int unsigned InstrMemDepth = 1 << 20, // 32-bit words
    parameter int unsigned DataMemDepth  = 1 << 20, // 32-bit words

    localparam type data_t = logic [31:0],
    localparam type strb_t = logic [3:0], // The strobe is bitwise.
    localparam type addr_t = logic [31:0]
) (
  input logic clk_i,
  input logic rst_ni,

`ifndef INTERRUPT_HANDLER_IN_SOC
  input  logic         int_nmi_i         , // Non-maskable interrupt.
  input  logic         int_external_i    , // External interrupt trigger line.
  input  logic [ 3:0]  int_extern_cause_i, // External interrupt cause code.
  input  logic         int_software_i    , // Software interrupt trigger line.
`endif

  output logic [31:0]  trs_pc_o,
  output logic [31:0]  trs_instr_o,
  output logic         trs_valid_o,

  ////////////////////
  // Memory signals //
  ////////////////////

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
  output data_t data_mem_rdata_o
);

`ifdef INTERRUPT_HANDLER_IN_SOC
  logic         int_nmi_i         ; // Non-maskable interrupt.
  logic         int_external_i    ; // External interrupt trigger line.
  logic [ 3:0]  int_extern_cause_i; // External interrupt cause code.
  logic         int_software_i    ; // Software interrupt trigger line.
`endif

  /////////
  // CPU //
  /////////

  scarv_mem_top i_scarv_mem_top (
    .clk_i              (clk_i),
    .rst_ni             (rst_ni),
    .data_mem_req_o     (data_mem_req_o),
    .data_mem_addr_o    (data_mem_addr_o),
    .data_mem_wdata_o   (data_mem_wdata_o),
    .data_mem_strb_o    (data_mem_strb_o),
    .data_mem_we_o      (data_mem_we_o),
    .data_mem_rdata_i   (data_mem_rdata_o),
    .instr_mem_req_o    (instr_mem_req_o),
    .instr_mem_addr_o   (instr_mem_addr_o),
    .instr_mem_wdata_o  (instr_mem_wdata_o),
    .instr_mem_strb_o   (instr_mem_strb_o),
    .instr_mem_we_o     (instr_mem_we_o),
    .instr_mem_rdata_i  (instr_mem_rdata_o),
    .int_nmi_i          (int_nmi_i),
    .int_external_i     (int_external_i),
    .int_extern_cause_i (int_extern_cause_i),
    .int_software_i     (int_software_i),
    .trs_pc_o           (trs_pc_o),
    .trs_instr_o        (trs_instr_o),
    .trs_valid_o        (trs_valid_o)
  );

  //////////////////////////////
  // Instruction ROM instance //
  //////////////////////////////

  noift_sram_mem #(
    .Width(32),
    .Depth(InstrMemDepth)
  ) i_instr_rom (
    .clk_i,
    .rst_ni,

    .req_i(instr_mem_req_o),
    .write_i(instr_mem_we_o),
    .addr_i(instr_mem_addr_o >> 2), // 32-bit words
    .wdata_i(instr_mem_wdata_o),
    .wmask_i({{8{instr_mem_strb_o[3]}}, {8{instr_mem_strb_o[2]}}, {8{instr_mem_strb_o[1]}}, {8{instr_mem_strb_o[0]}}}),
    .rdata_o(instr_mem_rdata_o)
  );

  ////////////////////////
  // Data SRAM instance //
  ////////////////////////

  noift_sram_mem #(
    .Width(32),
    .Depth(DataMemDepth)
  ) i_data_sram (
    .clk_i,
    .rst_ni,

    .req_i(data_mem_req_o),
    .write_i(data_mem_we_o),
    .addr_i(data_mem_addr_o >> 2), // 32-bit words
    .wdata_i(data_mem_wdata_o),
    .wmask_i({{8{data_mem_strb_o[3]}}, {8{data_mem_strb_o[2]}}, {8{data_mem_strb_o[1]}}, {8{data_mem_strb_o[0]}}}),
    .rdata_o(data_mem_rdata_o)
  );

  /////////////////////////
  // Interrupt generator //
  /////////////////////////

`ifdef INTERRUPT_HANDLER_IN_SOC
  custom_irqgen #(
    .ADDRMAP_REG_IRQS       (32'h2000),
    .ADDRMAP_REG_IRQ_TAINTS (32'h2008),
    .ADDRMAP_REG_CAUSE      (32'h2010),
    .ADDRMAP_REG_CAUSE_TAINT(32'h2018),
    .ADDRMAP_REG_DELAY      (32'h2020),
    .ADDRMAP_REG_COMMIT     (32'h2028),
    .data_t(data_t),
    .strb_t(strb_t),
    .addr_t(addr_t)
  ) i_irqgen (
    .clk_i,
    .rst_ni,
    .data_mem_req_i(data_mem_req_o),
    .data_mem_gnt_o(),
    .data_mem_addr_i(data_mem_addr_o),
    .data_mem_wdata_i(data_mem_wdata_o),
    .data_mem_strb_i(data_mem_strb_o),
    .data_mem_we_i(data_mem_we_o),
    .data_mem_rdata_o(),
    .int_nmi_o(int_nmi_i),
    .int_external_o(int_external_i),
    .int_extern_cause_o(int_extern_cause_i),
    .int_software_o(int_software_i),
    .int_timer_o(),
    .int_nmi_o_t0(),
    .int_external_o_t0(),
    .int_extern_cause_o_t0(),
    .int_software_o_t0(),
    .int_timer_o_t0()
  );
`endif

endmodule
