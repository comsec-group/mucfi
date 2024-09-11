// Author: Flavien Solt, 2023

module frv_mem_adapter #(
  localparam type data_t = logic[31:0],
  localparam type strb_t = logic[3:0],
  localparam type addr_t = logic[31:0]
) (
    input clk_i,
    input rst_ni,

    output logic  out_mem_req,
    input  logic  out_mem_gnt,
    output addr_t out_mem_addr,
    output data_t out_mem_wdata,
    output strb_t out_mem_strb,
    output logic  out_mem_we,
    input  data_t out_mem_rdata,

    input  wire         mem_req         , // Start memory request
    input  wire         mem_wen         , // Write enable
    input  wire [3:0]   mem_strb        , // Write strobe
    input  wire [31:0]  mem_wdata       , // Write data
    input  wire [31:0]  mem_addr        , // Read/Write address
    output wire         mem_gnt         , // request accepted
    output wire         mem_recv        , // Instruction memory recieve response.
    input  wire         mem_ack         , // Instruction memory ack response.
    output wire         mem_error       , // Error
    output wire [31:0]  mem_rdata         // Read data
);

logic is_data_in_store_d, is_data_in_store_q;
logic [31:0] stored_data_d, stored_data_q;

//
// Constant assignments.
assign out_mem_addr  = mem_addr;
assign out_mem_wdata = mem_wdata;
assign out_mem_strb  = {{8{mem_strb[3]}}, {8{mem_strb[2]}}, {8{mem_strb[1]}}, {8{mem_strb[0]}}};
assign out_mem_we    = mem_wen;

assign mem_error = '0;

//
// Request channels
// ============================================================

logic was_req_handshake_d, was_req_handshake_q;

// Ensure that there will not be another request that we cannot serve.
assign mem_gnt = mem_req && !(mem_recv && !mem_ack);
assign was_req_handshake_d = mem_gnt;

assign out_mem_req = mem_gnt;

//
// Response channels
// Assign mem_recv and mem_rdata.
// ============================================================

always_comb begin
    is_data_in_store_d = is_data_in_store_q;
    if (is_data_in_store_q) begin
        if (mem_ack) begin
            is_data_in_store_d = '0;
        end
    end

    // Not an else condition: data can be stored again in the same cycle.
    if (was_req_handshake_q) begin
        // Shortcut path when the receiver can already get the data
        if (mem_ack) begin
            is_data_in_store_d = 1'b0;
        end else begin
            is_data_in_store_d = 1'b1;
            stored_data_d = out_mem_rdata;
        end
    end
end

assign mem_recv = is_data_in_store_q || was_req_handshake_q;
assign mem_rdata = was_req_handshake_q ? out_mem_rdata : stored_data_d;

always_ff @(posedge clk_i) begin
    if (~rst_ni) begin
        stored_data_q <= '0;
        is_data_in_store_q <= '0;
        was_req_handshake_q <= '0;
    end else begin
        stored_data_q <= stored_data_d;
        is_data_in_store_q <= is_data_in_store_d;
        was_req_handshake_q <= was_req_handshake_d;
    end
end
endmodule
