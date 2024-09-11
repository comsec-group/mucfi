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

module kronos_mem_top #(
  localparam int unsigned InstrMemAw = $clog2(1 << 20),
  localparam int unsigned DataMemAw  = $clog2(1 << 20),
  localparam type data_t = logic[31:0],
  localparam type strb_t = logic[31:0],
  localparam type addr_t = logic[InstrMemAw-1:0]
) (
	input clk_i,
  input rst_ni,

  // Memory interface
  output logic  data_mem_req,
  input  logic  data_mem_gnt,
  output addr_t data_mem_addr,
  output data_t data_mem_wdata,
  output strb_t data_mem_strb,
  output logic  data_mem_we,
  input  data_t data_mem_rdata,

  output logic  instr_mem_req,
  input  logic  instr_mem_gnt,
  output addr_t instr_mem_addr,
  output data_t instr_mem_wdata,
  output strb_t instr_mem_strb,
  output logic  instr_mem_we,
  input  data_t instr_mem_rdata,

	// Kronos core interface
  input  logic        software_interrupt,
  input  logic        timer_interrupt,
  input  logic        external_interrupt
);

  /////////////////////
  // Core instance
  /////////////////////

  logic [31:0] instr_addr;
  logic [31:0] instr_data;
  logic        instr_req;
  logic        instr_ack;
  logic [31:0] data_addr;
  logic [31:0] data_rd_data;
  logic [31:0] data_wr_data;
  logic [3:0]  data_mask;
  logic        data_wr_en;
  logic        data_req;
  logic        data_ack;

  logic instr_ack_d, instr_ack_q;
  logic data_ack_d, data_ack_q;
  assign instr_ack_d = instr_mem_req;
  assign data_ack_d = data_mem_req;
  always_ff @(posedge clk_i, negedge rst_ni) begin
    if (~rst_ni) begin
      instr_ack_q <= '0;
      data_ack_q <= '0;
    end else begin
      instr_ack_q <= instr_ack_d;
      data_ack_q <= data_ack_d;
    end
  end

  assign instr_mem_req = instr_req;
  assign instr_ack = instr_ack_q;
  assign instr_mem_addr = instr_addr;
  assign instr_mem_wdata = '0;
  assign instr_mem_strb = '0;
  assign instr_mem_we = '0;
  assign instr_data = instr_mem_rdata;

  assign data_mem_req = data_req;
  // assign data_ack = data_ack_q;
  assign data_ack = 1'b1; // PC_TAINT bug debug
  assign data_mem_addr = data_addr;
  assign data_mem_wdata = data_wr_data;
  assign data_mem_strb = {{8{data_mask[3]}}, {8{data_mask[2]}}, {8{data_mask[1]}}, {8{data_mask[0]}}};
  assign data_mem_we = data_wr_en;
  assign data_rd_data = data_mem_rdata;

  kronos_core #(
    .BOOT_ADDR(32'h80000000),
    .FAST_BRANCH(1),
    .EN_COUNTERS(1),
    .EN_COUNTERS64B(1),
    .CATCH_ILLEGAL_INSTR(1),
    .CATCH_MISALIGNED_JMP(1),
    .CATCH_MISALIGNED_LDST(1)
  ) i_kronos_core (
    .clk(clk_i),
    .rstz(rst_ni),
    .instr_addr,
    .instr_data,
    .instr_req,
    .instr_ack,
    .data_addr,
    .data_rd_data,
    .data_wr_data,
    .data_mask,
    .data_wr_en,
    .data_req,
    .data_ack,
    .software_interrupt,
    .timer_interrupt,
    .external_interrupt
  );

endmodule
