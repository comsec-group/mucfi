// Copyright 2021 ETH Zurich and University of Bologna.
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the "License"); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.
//
// Author: Flavien Solt, ETH Zurich

module picorv32_mem_top #(
  localparam type data_t = logic[31:0],
  localparam type strb_t = logic[ 3:0],
  localparam type addr_t = logic[31:0]
) (

	input clk, resetn,
	output reg trap,

  output logic  instr_mem_req,
  input  logic  instr_mem_gnt,
  output addr_t instr_mem_addr,
  output data_t instr_mem_wdata,
  output strb_t instr_mem_strb,
  output logic  instr_mem_we,
  input  data_t instr_mem_rdata,

  output logic  data_mem_req,
  input  logic  data_mem_gnt,
  output addr_t data_mem_addr,
  output data_t data_mem_wdata,
  output strb_t data_mem_strb,
  output logic  data_mem_we,
  input  data_t data_mem_rdata,

	// Look-Ahead Interface
	output            mem_la_read,
	output            mem_la_write,
	output     [31:0] mem_la_addr,
	output reg [31:0] mem_la_wdata,
	output reg [ 3:0] mem_la_wstrb,

	// Pico Co-Processor Interface (PCPI)
	output reg        pcpi_valid,
	output reg [31:0] pcpi_insn,
	output     [31:0] pcpi_rs1,
	output     [31:0] pcpi_rs2,
	input             pcpi_wr,
	input      [31:0] pcpi_rd,
	input             pcpi_wait,
	input             pcpi_ready,

	// IRQ Interface
	input      [31:0] irq,
	output reg [31:0] eoi,

	// Trace Interface
	output reg        trace_valid,
	output reg [35:0] trace_data
);

  logic mem_valid;
  logic mem_instr;
  logic mem_ready;
  logic [31:0] mem_addr;
  logic [31:0] mem_wdata;
  logic [ 3:0] mem_wstrb;
  logic [31:0] mem_rdata;

  // logic mem_ready_d, mem_ready_q;
  // always_ff @(posedge clk) begin
  //   if (~resetn)
  //     mem_ready_q <= 0;
  //   else
  //     mem_ready_q <= mem_ready_d;
  // end
  // assign mem_ready_d = mem_valid;
  assign mem_ready = mem_valid;// mem_ready_q; // Assume that memory requests will never stall.

  // Assert that the instruction memory is never being written.
  // (assertion is not synthesizable).
  assert property (
    !mem_instr || mem_wstrb != 0
  ) else $error("mem_instr && |mem_wstrb");


  always_comb begin
    instr_mem_req   = '0;
    instr_mem_addr  = '0;
    instr_mem_wdata = '0;
    instr_mem_strb  = '0;
    instr_mem_we    = '0;
    data_mem_req    = '0;
    data_mem_addr   = '0;
    data_mem_wdata  = '0;
    data_mem_strb   = '0;
    data_mem_we     = '0;

    mem_rdata = '0;

    if (mem_la_read) begin
      instr_mem_req = mem_la_read;
      instr_mem_addr = mem_la_addr;
      instr_mem_wdata = mem_la_wdata;
      instr_mem_strb = mem_la_wstrb;
      instr_mem_we = '0;

      data_mem_req = mem_la_read;
      data_mem_addr = mem_la_addr;
      data_mem_wdata = mem_la_wdata;
      data_mem_strb = mem_la_wstrb;
      data_mem_we = '0;
    end else if (mem_la_write) begin
      data_mem_req = mem_la_write;
      data_mem_addr = mem_la_addr;
      data_mem_wdata = mem_la_wdata;
      data_mem_strb = mem_la_wstrb;
      data_mem_we = mem_la_write;
    end else

    if (mem_valid) begin
      if (mem_instr)
        mem_rdata = instr_mem_rdata;
      else
        mem_rdata = data_mem_rdata;
    end
  end

  picorv32 #(
    .ENABLE_COUNTERS      (1),
    .ENABLE_COUNTERS64    (1),
    .ENABLE_REGS_16_31    (1),
    .ENABLE_REGS_DUALPORT (1),
    .LATCHED_MEM_RDATA    (0),
    .TWO_STAGE_SHIFT      (1),
    .BARREL_SHIFTER       (0),
    .TWO_CYCLE_COMPARE    (0),
    .TWO_CYCLE_ALU        (0),
    .COMPRESSED_ISA       (0),
    .CATCH_MISALIGN       (1),
    .CATCH_ILLINSN        (1),
    .ENABLE_PCPI          (0),
    .ENABLE_MUL           (1),
    .ENABLE_FAST_MUL      (0),
    .ENABLE_DIV           (1),
    .ENABLE_IRQ           (0),
    .ENABLE_IRQ_QREGS     (1),
    .ENABLE_IRQ_TIMER     (1),
    .ENABLE_TRACE         (0),
    .REGS_INIT_ZERO       (0),
    .MASKED_IRQ           (32'h 0000_0000),
    .LATCHED_IRQ          (32'h ffff_ffff),
    .PROGADDR_RESET       (32'h 8000_0000),
    .PROGADDR_IRQ         (32'h 0000_0010),
    .STACKADDR            (32'h ffff_ffff)
  ) i_picorv32 (
    .clk(clk),
    .resetn(resetn),
    .trap(trap),

    .mem_valid(mem_valid),
    .mem_instr(mem_instr),
    .mem_ready(mem_ready),

    .mem_addr(mem_addr),
    .mem_wdata(mem_wdata),
    .mem_wstrb(mem_wstrb),
    .mem_rdata(mem_rdata),

    // Look-Ahead Interface
    .mem_la_read(mem_la_read),
    .mem_la_write(mem_la_write),
    .mem_la_addr(mem_la_addr),
    .mem_la_wdata(mem_la_wdata),
    .mem_la_wstrb(mem_la_wstrb),

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
    .irq(irq),
    .eoi(eoi),

    // Trace Interface
    .trace_valid(trace_valid),
    .trace_data(trace_data)
  );

endmodule
