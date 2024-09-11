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

module scarv_mem_top #(
  localparam type data_t = logic[31:0],
  localparam type strb_t = logic[3:0],
  localparam type addr_t = logic[31:0]
) (
	input logic clk_i,
  input logic rst_ni,

  // Memory interface
  output logic  data_mem_req_o,
  output addr_t data_mem_addr_o,
  output data_t data_mem_wdata_o,
  output strb_t data_mem_strb_o,
  output logic  data_mem_we_o,
  input  data_t data_mem_rdata_i,

  output logic  instr_mem_req_o,
  output addr_t instr_mem_addr_o,
  output data_t instr_mem_wdata_o,
  output strb_t instr_mem_strb_o,
  output logic  instr_mem_we_o,
  input  data_t instr_mem_rdata_i,

  output logic [31:0] trs_pc_o,
  output logic [31:0] trs_instr_o,
  output logic        trs_valid_o,

	// scarv core interface
  input  logic         int_nmi_i         , // Non-maskable interrupt.
  input  logic         int_external_i    , // External interrupt trigger line.
  input  logic [ 3:0]  int_extern_cause_i, // External interrupt cause code.
  input  logic         int_software_i      // Software interrupt trigger line.
);

  /////////////////////
  // Core instance
  /////////////////////

  logic        imem_req;
  logic        imem_wen;
  logic [3:0]  imem_strb;
  logic [31:0] imem_wdata;
  logic [31:0] imem_addr;
  logic        imem_gnt;
  logic        imem_recv;
  logic        imem_ack;
  logic        imem_error;
  logic [31:0] imem_rdata;

  logic        dmem_req;
  logic        dmem_wen;
  logic [3:0]  dmem_strb;
  logic [31:0] dmem_wdata;
  logic [31:0] dmem_addr;
  logic        dmem_gnt;
  logic        dmem_recv;
  logic        dmem_ack;
  logic        dmem_error;
  logic [31:0] dmem_rdata;

  frv_core i_scarv_core (
    .g_clk(clk_i),
    .g_resetn(rst_ni),
    .trs_pc(trs_pc_o),
    .trs_instr(trs_instr_o),
    .trs_valid(trs_valid_o),
    .leak_prng(),
    .leak_fence_unc0(),
    .leak_fence_unc1(),
    .leak_fence_unc2(),
    .rng_req_valid(),
    .rng_req_op(),
    .rng_req_data(),
    .rng_req_ready('0),
    .rng_rsp_valid('0),
    .rng_rsp_status('0),
    .rng_rsp_data('0),
    .rng_rsp_ready(),
    .int_nmi(int_nmi_i),
    .int_external(int_external_i),
    .int_extern_cause(int_extern_cause_i),
    .int_software(int_software_i),
    .int_mtime(),

    .imem_req,
    .imem_wen,
    .imem_strb,
    .imem_wdata,
    .imem_addr,
    .imem_gnt,
    .imem_recv,
    .imem_ack,
    .imem_error,
    .imem_rdata,

    .dmem_req,
    .dmem_wen,
    .dmem_strb,
    .dmem_wdata,
    .dmem_addr,
    .dmem_gnt,
    .dmem_recv,
    .dmem_ack,
    .dmem_error,
    .dmem_rdata
  );

  //////
  // ScarV to AXI
  //////

  logic        imem_axi_awvalid, dmem_axi_awvalid;
  logic        imem_axi_awready, dmem_axi_awready;
  logic [31:0] imem_axi_awaddr,  dmem_axi_awaddr;
  logic [ 2:0] imem_axi_awprot,  dmem_axi_awprot;
  logic        imem_axi_wvalid,  dmem_axi_wvalid;
  logic        imem_axi_wready,  dmem_axi_wready;
  logic [31:0] imem_axi_wdata,   dmem_axi_wdata;
  logic [ 3:0] imem_axi_wstrb,   dmem_axi_wstrb;
  logic        imem_axi_bvalid,  dmem_axi_bvalid;
  logic        imem_axi_bready,  dmem_axi_bready;
  logic [ 1:0] imem_axi_bresp,   dmem_axi_bresp;
  logic        imem_axi_arvalid, dmem_axi_arvalid;
  logic        imem_axi_arready, dmem_axi_arready;
  logic [31:0] imem_axi_araddr,  dmem_axi_araddr;
  logic [ 2:0] imem_axi_arprot,  dmem_axi_arprot;
  logic        imem_axi_rvalid,  dmem_axi_rvalid;
  logic        imem_axi_rready,  dmem_axi_rready;
  logic [31:0] imem_axi_rdata,   dmem_axi_rdata;
  logic [ 1:0] imem_axi_rresp,   dmem_axi_rresp;

  assign imem_axi_bresp = '0;
  assign imem_axi_rresp = '0;
  assign dmem_axi_bresp = '0;
  assign dmem_axi_rresp = '0;

  frv_axi_adapter i_instr_frv_axi_adapter (
    .g_clk(clk_i),
    .g_resetn(rst_ni),
    
    .mem_axi_awvalid(imem_axi_awvalid),
    .mem_axi_awready(imem_axi_awready),
    .mem_axi_awaddr(imem_axi_awaddr),
    .mem_axi_awprot(imem_axi_awprot),
    .mem_axi_wvalid(imem_axi_wvalid),
    .mem_axi_wready(imem_axi_wready),
    .mem_axi_wdata(imem_axi_wdata),
    .mem_axi_wstrb(imem_axi_wstrb),
    .mem_axi_bvalid(imem_axi_bvalid),
    .mem_axi_bready(imem_axi_bready),
    .mem_axi_bresp(imem_axi_bresp),
    .mem_axi_arvalid(imem_axi_arvalid),
    .mem_axi_arready(imem_axi_arready),
    .mem_axi_araddr(imem_axi_araddr),
    .mem_axi_arprot(imem_axi_arprot),
    .mem_axi_rvalid(imem_axi_rvalid),
    .mem_axi_rready(imem_axi_rready),
    .mem_axi_rdata(imem_axi_rdata),
    .mem_axi_rresp(imem_axi_rresp),

    .mem_req(imem_req),
    .mem_wen(imem_wen),
    .mem_strb(imem_strb),
    .mem_wdata(imem_wdata),
    .mem_addr(imem_addr),
    .mem_gnt(imem_gnt),
    .mem_recv(imem_recv),
    .mem_ack(imem_ack),
    .mem_error(imem_error),
    .mem_rdata(imem_rdata)
  );

  frv_axi_adapter i_data_frv_axi_adapter (
    .g_clk(clk_i),
    .g_resetn(rst_ni),
    
    .mem_axi_awvalid(dmem_axi_awvalid),
    .mem_axi_awready(dmem_axi_awready),
    .mem_axi_awaddr(dmem_axi_awaddr),
    .mem_axi_awprot(dmem_axi_awprot),
    .mem_axi_wvalid(dmem_axi_wvalid),
    .mem_axi_wready(dmem_axi_wready),
    .mem_axi_wdata(dmem_axi_wdata),
    .mem_axi_wstrb(dmem_axi_wstrb),
    .mem_axi_bvalid(dmem_axi_bvalid),
    .mem_axi_bready(dmem_axi_bready),
    .mem_axi_bresp(dmem_axi_bresp),
    .mem_axi_arvalid(dmem_axi_arvalid),
    .mem_axi_arready(dmem_axi_arready),
    .mem_axi_araddr(dmem_axi_araddr),
    .mem_axi_arprot(dmem_axi_arprot),
    .mem_axi_rvalid(dmem_axi_rvalid),
    .mem_axi_rready(dmem_axi_rready),
    .mem_axi_rdata(dmem_axi_rdata),
    .mem_axi_rresp(dmem_axi_rresp),

    .mem_req(dmem_req),
    .mem_wen(dmem_wen),
    .mem_strb(dmem_strb),
    .mem_wdata(dmem_wdata),
    .mem_addr(dmem_addr),
    .mem_gnt(dmem_gnt),
    .mem_recv(dmem_recv),
    .mem_ack(dmem_ack),
    .mem_error(dmem_error),
    .mem_rdata(dmem_rdata)
  );

  //////
  // AXI to external mem interface
  //////

  axi_to_mem #(
    .AXI_ID_WIDTH(1),
    .AXI_ADDR_WIDTH(32),
    .AXI_DATA_WIDTH(32)
  ) i_instr_axi_to_mem (
    .axi4_mem_0_clock(clk_i),
    .axi4_mem_0_reset(~rst_ni),
    .axi4_mem_0_bits_aw_ready(imem_axi_awready),
    .axi4_mem_0_bits_aw_valid(imem_axi_awvalid),
    .axi4_mem_0_bits_aw_bits_id('0),
    .axi4_mem_0_bits_aw_bits_addr(imem_axi_awaddr),
    .axi4_mem_0_bits_aw_bits_len('0),
    .axi4_mem_0_bits_aw_bits_size('0),
    .axi4_mem_0_bits_aw_bits_burst('0),
    .axi4_mem_0_bits_aw_bits_lock('0),
    .axi4_mem_0_bits_aw_bits_cache('0),
    .axi4_mem_0_bits_aw_bits_prot('0),
    .axi4_mem_0_bits_aw_bits_qos('0),
    .axi4_mem_0_bits_w_ready(imem_axi_wready),
    .axi4_mem_0_bits_w_valid(imem_axi_wvalid),
    .axi4_mem_0_bits_w_bits_data(imem_axi_wdata),
    .axi4_mem_0_bits_w_bits_strb(imem_axi_wstrb),
    .axi4_mem_0_bits_w_bits_last(1'b1),
    .axi4_mem_0_bits_b_ready(imem_axi_bready),
    .axi4_mem_0_bits_b_valid(imem_axi_bvalid),
    .axi4_mem_0_bits_b_bits_id(),
    .axi4_mem_0_bits_b_bits_resp(),
    .axi4_mem_0_bits_ar_ready(imem_axi_arready),
    .axi4_mem_0_bits_ar_valid(imem_axi_arvalid),
    .axi4_mem_0_bits_ar_bits_id('0),
    .axi4_mem_0_bits_ar_bits_addr(imem_axi_araddr),
    .axi4_mem_0_bits_ar_bits_len('0),
    .axi4_mem_0_bits_ar_bits_size('0),
    .axi4_mem_0_bits_ar_bits_burst('0),
    .axi4_mem_0_bits_ar_bits_lock('0),
    .axi4_mem_0_bits_ar_bits_cache('0),
    .axi4_mem_0_bits_ar_bits_prot('0),
    .axi4_mem_0_bits_ar_bits_qos('0),
    .axi4_mem_0_bits_r_ready(imem_axi_rready),
    .axi4_mem_0_bits_r_valid(imem_axi_rvalid),
    .axi4_mem_0_bits_r_bits_id(),
    .axi4_mem_0_bits_r_bits_data(imem_axi_rdata),
    .axi4_mem_0_bits_r_bits_resp(),
    .axi4_mem_0_bits_r_bits_last(),
    .req_o(instr_mem_req_o),
    .we_o(instr_mem_we_o),
    .addr_o(instr_mem_addr_o),
    .be_o(instr_mem_strb_o),
    .data_o(instr_mem_wdata_o),
    .data_i(instr_mem_rdata_i)
  );

  axi_to_mem #(
    .AXI_ID_WIDTH(1),
    .AXI_ADDR_WIDTH(32),
    .AXI_DATA_WIDTH(32)
  ) i_data_axi_to_mem (
    .axi4_mem_0_clock(clk_i),
    .axi4_mem_0_reset(~rst_ni),
    .axi4_mem_0_bits_aw_ready(dmem_axi_awready),
    .axi4_mem_0_bits_aw_valid(dmem_axi_awvalid),
    .axi4_mem_0_bits_aw_bits_id('0),
    .axi4_mem_0_bits_aw_bits_addr(dmem_axi_awaddr),
    .axi4_mem_0_bits_aw_bits_len('0),
    .axi4_mem_0_bits_aw_bits_size('0),
    .axi4_mem_0_bits_aw_bits_burst('0),
    .axi4_mem_0_bits_aw_bits_lock('0),
    .axi4_mem_0_bits_aw_bits_cache('0),
    .axi4_mem_0_bits_aw_bits_prot('0),
    .axi4_mem_0_bits_aw_bits_qos('0),
    .axi4_mem_0_bits_w_ready(dmem_axi_wready),
    .axi4_mem_0_bits_w_valid(dmem_axi_wvalid),
    .axi4_mem_0_bits_w_bits_data(dmem_axi_wdata),
    .axi4_mem_0_bits_w_bits_strb(dmem_axi_wstrb),
    .axi4_mem_0_bits_w_bits_last(1'b1),
    .axi4_mem_0_bits_b_ready(dmem_axi_bready),
    .axi4_mem_0_bits_b_valid(dmem_axi_bvalid),
    .axi4_mem_0_bits_b_bits_id(),
    .axi4_mem_0_bits_b_bits_resp(),
    .axi4_mem_0_bits_ar_ready(dmem_axi_arready),
    .axi4_mem_0_bits_ar_valid(dmem_axi_arvalid),
    .axi4_mem_0_bits_ar_bits_id('0),
    .axi4_mem_0_bits_ar_bits_addr(dmem_axi_araddr),
    .axi4_mem_0_bits_ar_bits_len('0),
    .axi4_mem_0_bits_ar_bits_size('0),
    .axi4_mem_0_bits_ar_bits_burst('0),
    .axi4_mem_0_bits_ar_bits_lock('0),
    .axi4_mem_0_bits_ar_bits_cache('0),
    .axi4_mem_0_bits_ar_bits_prot('0),
    .axi4_mem_0_bits_ar_bits_qos('0),
    .axi4_mem_0_bits_r_ready(dmem_axi_rready),
    .axi4_mem_0_bits_r_valid(dmem_axi_rvalid),
    .axi4_mem_0_bits_r_bits_id(),
    .axi4_mem_0_bits_r_bits_data(dmem_axi_rdata),
    .axi4_mem_0_bits_r_bits_resp(),
    .axi4_mem_0_bits_r_bits_last(),
    .req_o(data_mem_req_o),
    .we_o(data_mem_we_o),
    .addr_o(data_mem_addr_o),
    .be_o(data_mem_strb_o),
    .data_o(data_mem_wdata_o),
    .data_i(data_mem_rdata_i)
  );

endmodule
