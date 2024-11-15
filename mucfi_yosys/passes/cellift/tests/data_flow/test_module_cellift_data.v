/* Generated by Yosys 0.29+11 (git sha1 eb3eaeb79, gcc 11.4.0-1ubuntu1~22.04 -Og -fPIC) */

/* cellift =  1  */
/* hdlname = "\\test_module" */
/* top =  1  */
/* src = "test_module.v:1.1-29.10" */
module test_module(clk, rst, d1, d2, c1, c2, out1, out1_valid, out2, out2_valid, out1_t0, rst_t0, out2_valid_t0, out2_t0, out1_valid_t0, d2_t0, d1_t0, c2_t0, c1_t0);
  /* src = "test_module.v:11.3-27.6" */
  wire [15:0] _00_;
  /* cellift = 32'd1 */
  /* src = "test_module.v:11.3-27.6" */
  wire [15:0] _01_;
  /* src = "test_module.v:11.3-27.6" */
  wire [31:0] _02_;
  /* cellift = 32'd1 */
  /* src = "test_module.v:11.3-27.6" */
  wire [31:0] _03_;
  /* src = "test_module.v:11.3-27.6" */
  wire [31:0] _04_;
  /* cellift = 32'd1 */
  /* src = "test_module.v:11.3-27.6" */
  wire [31:0] _05_;
  wire [15:0] _06_;
  wire [15:0] _07_;
  wire [31:0] _08_;
  wire [31:0] _09_;
  wire [15:0] _10_;
  wire [15:0] _11_;
  wire [15:0] _12_;
  wire [15:0] _13_;
  wire [31:0] _14_;
  wire [31:0] _15_;
  wire [31:0] _16_;
  wire [31:0] _17_;
  wire [15:0] _18_;
  /* cellift = 32'd1 */
  wire [15:0] _19_;
  wire _20_;
  /* cellift = 32'd1 */
  wire _21_;
  /* src = "test_module.v:4.14-4.16" */
  input c1;
  wire c1;
  /* cellift = 32'd1 */
  input c1_t0;
  wire c1_t0;
  /* src = "test_module.v:5.14-5.16" */
  input c2;
  wire c2;
  /* cellift = 32'd1 */
  input c2_t0;
  wire c2_t0;
  /* src = "test_module.v:2.14-2.17" */
  input clk;
  wire clk;
  /* src = "test_module.v:3.20-3.22" */
  input [31:0] d1;
  wire [31:0] d1;
  /* cellift = 32'd1 */
  input [31:0] d1_t0;
  wire [31:0] d1_t0;
  /* src = "test_module.v:3.24-3.26" */
  input [31:0] d2;
  wire [31:0] d2;
  /* cellift = 32'd1 */
  input [31:0] d2_t0;
  wire [31:0] d2_t0;
  /* src = "test_module.v:9.14-9.16" */
  reg [15:0] d3;
  /* cellift = 32'd1 */
  /* src = "test_module.v:9.14-9.16" */
  reg [15:0] d3_t0;
  /* src = "test_module.v:6.21-6.25" */
  output [31:0] out1;
  reg [31:0] out1;
  /* cellift = 32'd1 */
  output [31:0] out1_t0;
  reg [31:0] out1_t0;
  /* src = "test_module.v:7.15-7.25" */
  output out1_valid;
  wire out1_valid;
  /* cellift = 32'd1 */
  output out1_valid_t0;
  wire out1_valid_t0;
  /* src = "test_module.v:6.27-6.31" */
  output [31:0] out2;
  reg [31:0] out2;
  /* cellift = 32'd1 */
  output [31:0] out2_t0;
  reg [31:0] out2_t0;
  /* src = "test_module.v:7.27-7.37" */
  output out2_valid;
  wire out2_valid;
  /* cellift = 32'd1 */
  output out2_valid_t0;
  wire out2_valid_t0;
  /* src = "test_module.v:2.19-2.22" */
  input rst;
  wire rst;
  /* cellift = 32'd1 */
  input rst_t0;
  wire rst_t0;
  /* taint_ff = 32'd1 */
/* PC_TAINT_INFO MODULE_NAME test_module */
/* PC_TAINT_INFO STATE_NAME out1_t0 */
  always_ff @(posedge clk, negedge rst)
    if (!rst) out1_t0 <= 32'd0;
    else out1_t0 <= _03_;
  /* taint_ff = 32'd1 */
/* PC_TAINT_INFO MODULE_NAME test_module */
/* PC_TAINT_INFO STATE_NAME out2_t0 */
  always_ff @(posedge clk, negedge rst)
    if (!rst) out2_t0 <= 32'd0;
    else out2_t0 <= _05_;
  /* taint_ff = 32'd1 */
/* PC_TAINT_INFO MODULE_NAME test_module */
/* PC_TAINT_INFO STATE_NAME d3_t0 */
  always_ff @(posedge clk)
    d3_t0 <= _19_;
  assign _06_ = ~ { rst, rst, rst, rst, rst, rst, rst, rst, rst, rst, rst, rst, rst, rst, rst, rst };
  assign _07_ = ~ { c2, c2, c2, c2, c2, c2, c2, c2, c2, c2, c2, c2, c2, c2, c2, c2 };
  assign _08_ = ~ { _20_, _20_, _20_, _20_, _20_, _20_, _20_, _20_, _20_, _20_, _20_, _20_, _20_, _20_, _20_, _20_, _20_, _20_, _20_, _20_, _20_, _20_, _20_, _20_, _20_, _20_, _20_, _20_, _20_, _20_, _20_, _20_ };
  assign _09_ = ~ { c1, c1, c1, c1, c1, c1, c1, c1, c1, c1, c1, c1, c1, c1, c1, c1, c1, c1, c1, c1, c1, c1, c1, c1, c1, c1, c1, c1, c1, c1, c1, c1 };
  assign _10_ = _06_ & d3_t0;
  assign _12_ = _07_ & d3_t0;
  assign _14_ = _08_ & out2_t0;
  assign _16_ = _09_ & out1_t0;
  assign _11_ = { rst, rst, rst, rst, rst, rst, rst, rst, rst, rst, rst, rst, rst, rst, rst, rst } & _01_;
  assign _13_ = { c2, c2, c2, c2, c2, c2, c2, c2, c2, c2, c2, c2, c2, c2, c2, c2 } & { 15'h0000, c2_t0 };
  assign _15_ = { _20_, _20_, _20_, _20_, _20_, _20_, _20_, _20_, _20_, _20_, _20_, _20_, _20_, _20_, _20_, _20_, _20_, _20_, _20_, _20_, _20_, _20_, _20_, _20_, _20_, _20_, _20_, _20_, _20_, _20_, _20_, _20_ } & d2_t0;
  assign _17_ = { c1, c1, c1, c1, c1, c1, c1, c1, c1, c1, c1, c1, c1, c1, c1, c1, c1, c1, c1, c1, c1, c1, c1, c1, c1, c1, c1, c1, c1, c1, c1, c1 } & d1_t0;
  assign _19_ = _10_ | _11_;
  assign _01_ = _12_ | _13_;
  assign _05_ = _14_ | _15_;
  assign _03_ = _16_ | _17_;
  assign _18_ = rst ? _00_ : d3;
  /* src = "test_module.v:11.3-27.6" */
/* PC_TAINT_INFO MODULE_NAME test_module */
/* PC_TAINT_INFO STATE_NAME out1 */
  always_ff @(posedge clk, negedge rst)
    if (!rst) out1 <= 32'd0;
    else out1 <= _02_;
  /* src = "test_module.v:11.3-27.6" */
/* PC_TAINT_INFO MODULE_NAME test_module */
/* PC_TAINT_INFO STATE_NAME out2 */
  always_ff @(posedge clk, negedge rst)
    if (!rst) out2 <= 32'd0;
    else out2 <= _04_;
  /* src = "test_module.v:11.3-27.6" */
/* PC_TAINT_INFO MODULE_NAME test_module */
/* PC_TAINT_INFO STATE_NAME d3 */
  always_ff @(posedge clk)
    d3 <= _18_;
  assign _00_ = c2 ? /* src = "test_module.v:23.11-23.13|test_module.v:23.7-25.10" */ { 15'h0000, c2 } : d3;
  assign _04_ = _20_ ? /* src = "test_module.v:19.11-19.13|test_module.v:19.7-21.10" */ d2 : out2;
  assign _02_ = c1 ? /* src = "test_module.v:16.11-16.13|test_module.v:16.7-18.10" */ d1 : out1;
  assign _20_ = | /* src = "test_module.v:0.0-0.0" */ d1;
  assign out2_valid = d3[0];
  assign _21_ = 1'h0;
  assign out2_valid_t0 = d3_t0[0];
endmodule
