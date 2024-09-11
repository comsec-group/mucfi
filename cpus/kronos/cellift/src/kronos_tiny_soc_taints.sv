// Copyright 2022 Flavien Solt, ETH Zurich.
// Licensed under the General Public License, Version 3.0, see LICENSE for details.
// SPDX-License-Identifier: GPL-3.0-only

module kronos_tiny_soc #(
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

  ////////////////////
  // Memory signals //
  ////////////////////

  output logic  instr_mem_req,
  output logic  instr_mem_gnt,
  output addr_t instr_mem_addr,
  output data_t instr_mem_wdata,
  output strb_t instr_mem_strb,
  output logic  instr_mem_we,
  output data_t instr_mem_rdata,

  output logic  data_mem_req,
  output logic  data_mem_gnt,
  output addr_t data_mem_addr,
  output data_t data_mem_wdata,
  output strb_t data_mem_strb,
  output logic  data_mem_we,
  output data_t data_mem_rdata,

  output logic  instr_mem_req_t0,
  output logic  instr_mem_gnt_t0,
  output addr_t instr_mem_addr_t0,
  output data_t instr_mem_wdata_t0,
  output strb_t instr_mem_strb_t0,
  output logic  instr_mem_we_t0,
  output data_t instr_mem_rdata_t0,

  output logic  data_mem_req_t0,
  output logic  data_mem_gnt_t0,
  output addr_t data_mem_addr_t0,
  output data_t data_mem_wdata_t0,
  output strb_t data_mem_strb_t0,
  output logic  data_mem_we_t0,
  output data_t data_mem_rdata_t0
);

  /////////////////
  // CPU signals //
  /////////////////

  logic software_interrupt;
  logic timer_interrupt;
  logic external_interrupt;

  logic software_interrupt_t0;
  logic timer_interrupt_t0;
  logic external_interrupt_t0;

  /////////
  // CPU //
  /////////

  kronos_mem_top i_kronos_mem_top (
    .clk_i              (clk_i),
    .rst_ni             (rst_ni),
    .data_mem_req       (data_mem_req),
    .data_mem_gnt       (data_mem_gnt),
    .data_mem_addr      (data_mem_addr),
    .data_mem_wdata     (data_mem_wdata),
    .data_mem_strb      (data_mem_strb),
    .data_mem_we        (data_mem_we),
    .data_mem_rdata     (data_mem_rdata),
    .instr_mem_req      (instr_mem_req),
    .instr_mem_gnt      (instr_mem_gnt),
    .instr_mem_addr     (instr_mem_addr),
    .instr_mem_wdata    (instr_mem_wdata),
    .instr_mem_strb     (instr_mem_strb),
    .instr_mem_we       (instr_mem_we),
    .instr_mem_rdata    (instr_mem_rdata),
    .software_interrupt (software_interrupt),
    .timer_interrupt    (timer_interrupt),
    .external_interrupt (external_interrupt),

    .data_mem_req_t0       (data_mem_req_t0),
    .data_mem_gnt_t0       (data_mem_gnt_t0),
    .data_mem_addr_t0      (data_mem_addr_t0),
    .data_mem_wdata_t0     (data_mem_wdata_t0),
    .data_mem_strb_t0      (data_mem_strb_t0),
    .data_mem_we_t0        (data_mem_we_t0),
    .data_mem_rdata_t0     (data_mem_rdata_t0),
    .instr_mem_req_t0      (instr_mem_req_t0),
    .instr_mem_gnt_t0      (instr_mem_gnt_t0),
    .instr_mem_addr_t0     (instr_mem_addr_t0),
    .instr_mem_wdata_t0    (instr_mem_wdata_t0),
    .instr_mem_strb_t0     (instr_mem_strb_t0),
    .instr_mem_we_t0       (instr_mem_we_t0),
    .instr_mem_rdata_t0    (instr_mem_rdata_t0),
    .software_interrupt_t0 (software_interrupt_t0),
    .timer_interrupt_t0    (timer_interrupt_t0),
    .external_interrupt_t0 (external_interrupt_t0)
  );

  //////////////////////////////
  // Instruction ROM instance //
  //////////////////////////////

  ift_sram_mem #(
    .Width(32),
    .Depth(InstrMemDepth),
    .NumTaints(NumTaints),
    .RelocateRequestUp(64'h10000000) // 80000000 >> 3
  ) i_instr_rom (
    .clk_i,
    .rst_ni,

    .req_i(instr_mem_req),
    .write_i(instr_mem_we),
    .addr_i(instr_mem_addr >> 2), // 32-bit words
    .wdata_i(instr_mem_wdata),
    .wmask_i(instr_mem_strb),
    .rdata_o(instr_mem_rdata),

    .req_i_taint(instr_mem_req_t0),
    .write_i_taint(instr_mem_we_t0),
    .addr_i_taint(instr_mem_addr_t0),
    .wdata_i_taint(instr_mem_wdata_t0),
    .wmask_i_taint(instr_mem_strb_t0),
    .rdata_o_taint(instr_mem_rdata_t0)
  );

  assign instr_mem_gnt = '1;
  assign instr_mem_gnt_t0 = '0;

  ////////////////////////
  // Data SRAM instance //
  ////////////////////////

  ift_sram_mem #(
    .Width(32),
    .Depth(DataMemDepth),
    .NumTaints(NumTaints),
    .RelocateRequestUp(64'h10000000) // 80000000 >> 3
  ) i_data_sram (
    .clk_i,
    .rst_ni,

    .req_i(data_mem_req),
    .write_i(data_mem_we),
    .addr_i(data_mem_addr >> 2), // 32-bit words
    .wdata_i(data_mem_wdata),
    .wmask_i(data_mem_strb),
    .rdata_o(data_mem_rdata),

    .req_i_taint(data_mem_req_t0),
    .write_i_taint(data_mem_we_t0),
    .addr_i_taint(data_mem_addr_t0),
    .wdata_i_taint(data_mem_wdata_t0),
    .wmask_i_taint(data_mem_strb_t0),
    .rdata_o_taint(data_mem_rdata_t0)
  );

  assign data_mem_gnt = '1;
  assign data_mem_gnt_t0 = '0;

  /////////////////////////
  // Interrupt generator //
  /////////////////////////

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
    .data_mem_req_i(data_mem_req),
    .data_mem_gnt_o(),
    .data_mem_addr_i(data_mem_addr),
    .data_mem_wdata_i(data_mem_wdata),
    .data_mem_strb_i(data_mem_strb),
    .data_mem_we_i(data_mem_we),
    .data_mem_rdata_o(),
    .int_nmi_o(),
    .int_external_o(external_interrupt),
    .int_extern_cause_o(),
    .int_software_o(software_interrupt),
    .int_timer_o(timer_interrupt),
    .int_nmi_o_t0(),
    .int_external_o_t0(external_interrupt_t0),
    .int_extern_cause_o_t0(),
    .int_software_o_t0(software_interrupt_t0),
    .int_timer_o_t0(timer_interrupt_t0)
  );

endmodule
