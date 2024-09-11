// Copyright 2022 Flavien Solt, ETH Zurich.
// Licensed under the General Public License, Version 3.0, see LICENSE for details.
// SPDX-License-Identifier: GPL-3.0-only

module picorv32_tiny_soc #(
    // The two below must be equal.
    parameter int unsigned InstrMemDepth = 1 << 20, // 32-bit words
    parameter int unsigned DataMemDepth  = 1 << 20, // 32-bit words

    localparam type data_t = logic [31:0],
    localparam type strb_t = logic [ 3:0], // The strobe is bytewise.
    localparam type addr_t = logic [31:0]
) (
  input logic clk_i,
  input logic rst_ni,

  //////////////////
  // RFUZZ output //
  //////////////////

  output logic [171:0] auto_cover_out,
  // No assertion in this design

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

  input  logic [31:0] irq_i,
  output logic [31:0] eoi_o
);

  /////////////////
  // CPU signals //
  /////////////////

  logic trap;

  logic        pcpi_valid;
  logic [31:0] pcpi_insn;
  logic [31:0] pcpi_rs1;
  logic [31:0] pcpi_rs2;
  logic        pcpi_wr;
  logic [31:0] pcpi_rd;
  logic        pcpi_wait;
  logic        pcpi_ready;
  assign pcpi_wr = '0;
  assign pcpi_rd = '0;
  assign pcpi_wait = '0;
  assign pcpi_ready = '0;

  logic [31:0] irq;
  assign irq = '0;
  logic [31:0] eoi;
  assign eoi_o = eoi;

  logic trace_valid;
  logic [35:0] trace_data;

  /////////
  // CPU //
  /////////

  picorv32_mem_top i_picorv32_mem_top (
    .clk(clk_i),
    .resetn(rst_ni),
    .trap(trap),

    .instr_mem_req(instr_mem_req),
    .instr_mem_gnt(instr_mem_gnt),
    .instr_mem_addr(instr_mem_addr),
    .instr_mem_wdata(instr_mem_wdata),
    .instr_mem_strb(instr_mem_strb),
    .instr_mem_we(instr_mem_we),
    .instr_mem_rdata(instr_mem_rdata),
    .data_mem_req(data_mem_req),
    .data_mem_gnt(data_mem_gnt),
    .data_mem_addr(data_mem_addr),
    .data_mem_wdata(data_mem_wdata),
    .data_mem_strb(data_mem_strb),
    .data_mem_we(data_mem_we),
    .data_mem_rdata(data_mem_rdata),

    // Look-Ahead Interface
    .mem_la_read(),
    .mem_la_write(),
    .mem_la_addr(),
    .mem_la_wdata(),
    .mem_la_wstrb(),

    // Pico Co-Processor Interface (PCPI)
    .pcpi_valid(pcpi_valid),
    .pcpi_insn(pcpi_insn),
    .pcpi_rs1(pcpi_rs1),
    .pcpi_rs2(pcpi_rs2),
    .pcpi_wr(pcpi_wr),
    .pcpi_rd(pcpi_rd),
    .pcpi_wait(pcpi_wait),
    .pcpi_ready(pcpi_ready),

    // IRQ Interface
    .irq(irq_i),
    .eoi(eoi),

    // Trace Interface
    .trace_valid(trace_valid),
    .trace_data(trace_data),

    // RFUZZ output
    .auto_cover_out(auto_cover_out)
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

    .req_i(instr_mem_req),
    .write_i(instr_mem_we),
    .addr_i(instr_mem_addr >> 2), // 32-bit words
    .wdata_i(instr_mem_wdata),
    .wmask_i({{8{instr_mem_strb[3]}}, {8{instr_mem_strb[2]}}, {8{instr_mem_strb[1]}}, {8{instr_mem_strb[0]}}}),
    .rdata_o(instr_mem_rdata)
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

    .req_i(data_mem_req),
    .write_i(data_mem_we),
    .addr_i(data_mem_addr >> 2), // 32-bit words
    .wdata_i(data_mem_wdata),
    .wmask_i({{8{data_mem_strb[3]}}, {8{data_mem_strb[2]}}, {8{data_mem_strb[1]}}, {8{data_mem_strb[0]}}}),
    .rdata_o(data_mem_rdata)
  );

  assign data_mem_gnt = '1;

endmodule
