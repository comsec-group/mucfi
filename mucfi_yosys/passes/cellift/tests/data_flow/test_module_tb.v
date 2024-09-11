module test_module_tb;
  reg clk, rst;
  reg [31:0] d1, d2;
  reg c1, c2;
  reg [31:0] out1, out2;
  reg out1_valid, out2_valid;
  reg [31:0] out1_t0, d1_t0, c1_t0, c2_t0;
  reg out2_valid_t0, out2_t0, out1_valid_t0, d2_t0;

  test_module uut(clk, rst, d1, d2, c1, c2, out1, out1_valid, out2, out2_valid, out1_t0, rst_t0, out2_valid_t0, out2_t0, out1_valid_t0, d2_t0, d1_t0, c2_t0, c1_t0);

  initial begin
    clk <= 0;
    rst <= 0;
    d1 <= 0;
    d2 <= 0;
    c1 <= 0;
    c2 <= 0;
    d1_t0 <= 0;
    c1_t0 <= 0;
    c2_t0 <= 1;
    d2_t0 <= 0;
    #10 rst <= 0;
    #10 rst <= 1;
    #10 d1 <= 32'hdeadbeef;
    d1_t0 <= 32'hFFFFFFFF;
    #10 c1 <= 1;
    #10 d2 <= 32'hFFFFFFFF;
    #10 c2 <= 1;
    d1_t0 <= 0;
    #10
    c1_t0 <= 1;
    #10 c1 <= 0;
    #10 $finish;
  end

  always #5 clk <= ~clk;

endmodule