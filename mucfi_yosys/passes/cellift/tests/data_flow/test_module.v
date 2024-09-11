module test_module(clk, rst, d1, d2, c1, c2, out1, out1_valid, out2, out2_valid);
  input wire clk, rst;
  input reg [31:0] d1, d2;
  input wire c1;
  input wire c2;
  output reg [31:0] out1, out2;
  output wire out1_valid, out2_valid;

  reg [15:0] d3;

  always @(posedge clk or negedge rst) begin
    if (!rst) begin
      out1 <= 0;
      out2 <= 0;
    end else begin
      if (c1) begin
        out1 <= d1;
      end
      if (d1) begin // Data signal turns into control
        out2 <= d2;
      end

      if (c2) begin
        d3 <= c2; // Control signal gets buffered
      end
    end
  end
  assign out2_valid = d3[0];
endmodule

