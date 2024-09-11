module xc_sha3 (
	rs1,
	rs2,
	shamt,
	f_xy,
	f_x1,
	f_x2,
	f_x4,
	f_yx,
	result
);
	input wire [31:0] rs1;
	input wire [31:0] rs2;
	input wire [1:0] shamt;
	input wire f_xy;
	input wire f_x1;
	input wire f_x2;
	input wire f_x4;
	input wire f_yx;
	output wire [31:0] result;
	wire [2:0] in_x = rs1[2:0];
	wire [2:0] in_y = rs2[2:0];
	wire [4:0] in_x_plus = in_x + {f_x4, f_x2, f_x1};
	wire [6:0] in_y_plus = {in_x, 1'b0} + {{2'b00, in_y, 1'b0} + in_y};
	wire [4:0] lut_in_lhs = (f_yx ? in_y : in_x_plus);
	wire [6:0] lut_in_rhs = (f_yx ? in_y_plus : in_y);
	wire [2:0] lut_out_lhs = lut_in_lhs % 5;
	wire [2:0] lut_out_rhs = lut_in_rhs % 5;
	wire [4:0] sum_rhs = {lut_out_rhs, 2'b00} + lut_out_rhs;
	wire [4:0] result_sum = lut_out_lhs + sum_rhs;
	wire [5:0] shf_1 = (shamt[0] ? {result_sum, 1'b0} : {1'b0, result_sum});
	wire [7:0] shf_2 = (shamt[1] ? {shf_1, 2'b00} : {2'b00, shf_1});
	assign result = {24'b000000000000000000000000, shf_2};
endmodule
module xc_sha256 (
	rs1,
	ss,
	result
);
	input wire [31:0] rs1;
	input wire [1:0] ss;
	output wire [31:0] result;
	wire s0 = ss == 2'b00;
	wire s1 = ss == 2'b01;
	wire s2 = ss == 2'b10;
	wire s3 = ss == 2'b11;
	wire [31:0] s0_result = (((rs1 >> 7) | (rs1 << 25)) ^ ((rs1 >> 18) | (rs1 << 14))) ^ (rs1 >> 3);
	wire [31:0] s1_result = (((rs1 >> 17) | (rs1 << 15)) ^ ((rs1 >> 19) | (rs1 << 13))) ^ (rs1 >> 10);
	wire [31:0] s2_result = (((rs1 >> 2) | (rs1 << 30)) ^ ((rs1 >> 13) | (rs1 << 19))) ^ ((rs1 >> 22) | (rs1 << 10));
	wire [31:0] s3_result = (((rs1 >> 6) | (rs1 << 26)) ^ ((rs1 >> 11) | (rs1 << 21))) ^ ((rs1 >> 25) | (rs1 << 7));
	assign result = ((({32 {s0}} & s0_result) | ({32 {s1}} & s1_result)) | ({32 {s2}} & s2_result)) | ({32 {s3}} & s3_result);
endmodule
module xc_aessub_sbox (
	in,
	inv,
	out
);
	input wire [7:0] in;
	input wire inv;
	output wire [7:0] out;
	wire [7:0] out_fwd;
	wire [7:0] out_inv;
	assign out = (inv ? out_inv : out_fwd);
	xc_aessub_sbox_fwd i_sbox_fwd(
		.in(in),
		.out(out_fwd)
	);
	xc_aessub_sbox_inv i_sbox_inv(
		.in(in),
		.out(out_inv)
	);
endmodule
module xc_aessub_sbox_fwd (
	in,
	out
);
	input wire [7:0] in;
	output wire [7:0] out;
	wire u7;
	wire u6;
	wire u5;
	wire u4;
	wire u3;
	wire u2;
	wire u1;
	wire u0;
	wire s7;
	wire s6;
	wire s5;
	wire s4;
	wire s3;
	wire s2;
	wire s1;
	wire s0;
	assign out = {s0, s1, s2, s3, s4, s5, s6, s7};
	assign {u0, u1, u2, u3, u4, u5, u6, u7} = in;
	wire y14 = u3 ^ u5;
	wire y13 = u0 ^ u6;
	wire y9 = u0 ^ u3;
	wire y8 = u0 ^ u5;
	wire t0 = u1 ^ u2;
	wire y1 = t0 ^ u7;
	wire y4 = y1 ^ u3;
	wire y12 = y13 ^ y14;
	wire y2 = y1 ^ u0;
	wire y5 = y1 ^ u6;
	wire y3 = y5 ^ y8;
	wire t1 = u4 ^ y12;
	wire y15 = t1 ^ u5;
	wire y20 = t1 ^ u1;
	wire y6 = y15 ^ u7;
	wire y10 = y15 ^ t0;
	wire y11 = y20 ^ y9;
	wire y7 = u7 ^ y11;
	wire y17 = y10 ^ y11;
	wire y19 = y10 ^ y8;
	wire y16 = t0 ^ y11;
	wire y21 = y13 ^ y16;
	wire y18 = u0 ^ y16;
	wire t2 = y12 && y15;
	wire t3 = y3 && y6;
	wire t4 = t3 ^ t2;
	wire t5 = y4 && u7;
	wire t6 = t5 ^ t2;
	wire t7 = y13 && y16;
	wire t8 = y5 && y1;
	wire t9 = t8 ^ t7;
	wire t10 = y2 && y7;
	wire t11 = t10 ^ t7;
	wire t12 = y9 && y11;
	wire t13 = y14 && y17;
	wire t14 = t13 ^ t12;
	wire t15 = y8 && y10;
	wire t16 = t15 ^ t12;
	wire t17 = t4 ^ y20;
	wire t18 = t6 ^ t16;
	wire t19 = t9 ^ t14;
	wire t20 = t11 ^ t16;
	wire t21 = t17 ^ t14;
	wire t22 = t18 ^ y19;
	wire t23 = t19 ^ y21;
	wire t24 = t20 ^ y18;
	wire t25 = t21 ^ t22;
	wire t26 = t21 && t23;
	wire t27 = t24 ^ t26;
	wire t28 = t25 && t27;
	wire t29 = t28 ^ t22;
	wire t30 = t23 ^ t24;
	wire t31 = t22 ^ t26;
	wire t32 = t31 && t30;
	wire t33 = t32 ^ t24;
	wire t34 = t23 ^ t33;
	wire t35 = t27 ^ t33;
	wire t36 = t24 && t35;
	wire t37 = t36 ^ t34;
	wire t38 = t27 ^ t36;
	wire t39 = t29 && t38;
	wire t40 = t25 ^ t39;
	wire t41 = t40 ^ t37;
	wire t42 = t29 ^ t33;
	wire t43 = t29 ^ t40;
	wire t44 = t33 ^ t37;
	wire t45 = t42 ^ t41;
	wire z0 = t44 && y15;
	wire z1 = t37 && y6;
	wire z2 = t33 && u7;
	wire z3 = t43 && y16;
	wire z4 = t40 && y1;
	wire z5 = t29 && y7;
	wire z6 = t42 && y11;
	wire z7 = t45 && y17;
	wire z8 = t41 && y10;
	wire z9 = t44 && y12;
	wire z10 = t37 && y3;
	wire z11 = t33 && y4;
	wire z12 = t43 && y13;
	wire z13 = t40 && y5;
	wire z14 = t29 && y2;
	wire z15 = t42 && y9;
	wire z16 = t45 && y14;
	wire z17 = t41 && y8;
	wire tc1 = z15 ^ z16;
	wire tc2 = z10 ^ tc1;
	wire tc3 = z9 ^ tc2;
	wire tc4 = z0 ^ z2;
	wire tc5 = z1 ^ z0;
	wire tc6 = z3 ^ z4;
	wire tc7 = z12 ^ tc4;
	wire tc8 = z7 ^ tc6;
	wire tc9 = z8 ^ tc7;
	wire tc10 = tc8 ^ tc9;
	wire tc11 = tc6 ^ tc5;
	wire tc12 = z3 ^ z5;
	wire tc13 = z13 ^ tc1;
	wire tc14 = tc4 ^ tc12;
	assign s3 = tc3 ^ tc11;
	wire tc16 = z6 ^ tc8;
	wire tc17 = z14 ^ tc10;
	wire tc18 = tc13 ^ tc14;
	assign s7 = z12 ~^ tc18;
	wire tc20 = z15 ^ tc16;
	wire tc21 = tc2 ^ z11;
	assign s0 = tc3 ^ tc16;
	assign s6 = tc10 ~^ tc18;
	assign s4 = tc14 ^ s3;
	assign s1 = s3 ~^ tc16;
	wire tc26 = tc17 ^ tc20;
	assign s2 = tc26 ~^ z17;
	assign s5 = tc21 ^ tc17;
endmodule
module xc_aessub_sbox_inv (
	in,
	out
);
	input wire [7:0] in;
	output wire [7:0] out;
	wire u7;
	wire u6;
	wire u5;
	wire u4;
	wire u3;
	wire u2;
	wire u1;
	wire u0;
	wire s7;
	wire s6;
	wire s5;
	wire s4;
	wire s3;
	wire s2;
	wire s1;
	wire s0;
	assign out = {s0, s1, s2, s3, s4, s5, s6, s7};
	assign {u0, u1, u2, u3, u4, u5, u6, u7} = in;
	wire y0 = u0 ^ u3;
	wire y2 = u1 ~^ u3;
	wire y4 = u0 ^ y2;
	wire rtl0 = u6 ^ u7;
	wire y1 = y2 ^ rtl0;
	wire y7 = u2 ~^ y1;
	wire rtl1 = u3 ^ u4;
	wire y6 = u7 ~^ rtl1;
	wire y3 = y1 ^ rtl1;
	wire rtl2 = u0 ~^ u2;
	wire y5 = u5 ^ rtl2;
	wire sa1 = y0 ^ y2;
	wire sa0 = y1 ^ y3;
	wire sb1 = y4 ^ y6;
	wire sb0 = y5 ^ y7;
	wire ah = y0 ^ y1;
	wire al = y2 ^ y3;
	wire aa = sa0 ^ sa1;
	wire bh = y4 ^ y5;
	wire bl = y6 ^ y7;
	wire bb = sb0 ^ sb1;
	wire ab20 = sa0 ^ sb0;
	wire ab22 = al ^ bl;
	wire ab23 = y3 ^ y7;
	wire ab21 = sa1 ^ sb1;
	wire abcd1 = ah && bh;
	wire rr1 = y0 && y4;
	wire ph11 = ab20 ^ abcd1;
	wire t01 = y1 && y5;
	wire ph01 = t01 ^ abcd1;
	wire abcd2 = al && bl;
	wire r1 = y2 && y6;
	wire pl11 = ab22 ^ abcd2;
	wire r2 = y3 && y7;
	wire pl01 = r2 ^ abcd2;
	wire r3 = sa0 && sb0;
	wire vr1 = aa && bb;
	wire pr1 = vr1 ^ r3;
	wire wr1 = sa1 && sb1;
	wire qr1 = wr1 ^ r3;
	wire ab0 = ph11 ^ rr1;
	wire ab1 = ph01 ^ ab21;
	wire ab2 = pl11 ^ r1;
	wire ab3 = pl01 ^ qr1;
	wire cp1 = ab0 ^ pr1;
	wire cp2 = ab1 ^ qr1;
	wire cp3 = ab2 ^ pr1;
	wire cp4 = ab3 ^ ab23;
	wire tinv1 = cp3 ^ cp4;
	wire tinv2 = cp3 && cp1;
	wire tinv3 = cp2 ^ tinv2;
	wire tinv4 = cp1 ^ cp2;
	wire tinv5 = cp4 ^ tinv2;
	wire tinv6 = tinv5 && tinv4;
	wire tinv7 = tinv3 && tinv1;
	wire d2 = cp4 ^ tinv7;
	wire d0 = cp2 ^ tinv6;
	wire tinv8 = cp1 && cp4;
	wire tinv9 = tinv4 && tinv8;
	wire tinv10 = tinv4 ^ tinv2;
	wire d1 = tinv9 ^ tinv10;
	wire tinv11 = cp2 && cp3;
	wire tinv12 = tinv1 && tinv11;
	wire tinv13 = tinv1 ^ tinv2;
	wire d3 = tinv12 ^ tinv13;
	wire sd1 = d1 ^ d3;
	wire sd0 = d0 ^ d2;
	wire dl = d0 ^ d1;
	wire dh = d2 ^ d3;
	wire dd = sd0 ^ sd1;
	wire abcd3 = dh && bh;
	wire rr2 = d3 && y4;
	wire t02 = d2 && y5;
	wire abcd4 = dl && bl;
	wire r4 = d1 && y6;
	wire r5 = d0 && y7;
	wire r6 = sd0 && sb0;
	wire vr2 = dd && bb;
	wire wr2 = sd1 && sb1;
	wire abcd5 = dh && ah;
	wire r7 = d3 && y0;
	wire r8 = d2 && y1;
	wire abcd6 = dl && al;
	wire r9 = d1 && y2;
	wire r10 = d0 && y3;
	wire r11 = sd0 && sa0;
	wire vr3 = dd && aa;
	wire wr3 = sd1 && sa1;
	wire ph12 = rr2 ^ abcd3;
	wire ph02 = t02 ^ abcd3;
	wire pl12 = r4 ^ abcd4;
	wire pl02 = r5 ^ abcd4;
	wire pr2 = vr2 ^ r6;
	wire qr2 = wr2 ^ r6;
	wire p0 = ph12 ^ pr2;
	wire p1 = ph02 ^ qr2;
	wire p2 = pl12 ^ pr2;
	wire p3 = pl02 ^ qr2;
	wire ph13 = r7 ^ abcd5;
	wire ph03 = r8 ^ abcd5;
	wire pl13 = r9 ^ abcd6;
	wire pl03 = r10 ^ abcd6;
	wire pr3 = vr3 ^ r11;
	wire qr3 = wr3 ^ r11;
	wire p4 = ph13 ^ pr3;
	assign s7 = ph03 ^ qr3;
	wire p6 = pl13 ^ pr3;
	wire p7 = pl03 ^ qr3;
	assign s3 = p1 ^ p6;
	assign s6 = p2 ^ p6;
	assign s0 = p3 ^ p6;
	wire x11 = p0 ^ p2;
	assign s5 = s0 ^ x11;
	wire x13 = p4 ^ p7;
	wire x14 = x11 ^ x13;
	assign s1 = s3 ^ x14;
	wire x16 = p1 ^ s7;
	assign s2 = x14 ^ x16;
	wire x18 = p0 ^ p4;
	wire x19 = s5 ^ x16;
	assign s4 = x18 ^ x19;
endmodule
module xc_aessub (
	clock,
	reset,
	flush,
	flush_data,
	valid,
	rs1,
	rs2,
	enc,
	rot,
	ready,
	result
);
	input wire clock;
	input wire reset;
	input wire flush;
	input wire [31:0] flush_data;
	input wire valid;
	input wire [31:0] rs1;
	input wire [31:0] rs2;
	input wire enc;
	input wire rot;
	output wire ready;
	output wire [31:0] result;
	parameter FAST = 1'b0;
	generate
		if (FAST) begin : genblk1
			assign ready = valid;
			wire [7:0] sb_in_0 = rs1[7:0] & {8 {valid}};
			wire [7:0] sb_in_1 = rs2[15:8] & {8 {valid}};
			wire [7:0] sb_in_2 = rs1[23:16] & {8 {valid}};
			wire [7:0] sb_in_3 = rs2[31:24] & {8 {valid}};
			wire [7:0] sb_out_0;
			wire [7:0] sb_out_1;
			wire [7:0] sb_out_2;
			wire [7:0] sb_out_3;
			assign result = (rot ? {sb_out_2, sb_out_1, sb_out_0, sb_out_3} : {sb_out_3, sb_out_2, sb_out_1, sb_out_0});
			xc_aessub_sbox sbox_0(
				.in(sb_in_0),
				.inv(!enc),
				.out(sb_out_0)
			);
			xc_aessub_sbox sbox_1(
				.in(sb_in_1),
				.inv(!enc),
				.out(sb_out_1)
			);
			xc_aessub_sbox sbox_2(
				.in(sb_in_2),
				.inv(!enc),
				.out(sb_out_2)
			);
			xc_aessub_sbox sbox_3(
				.in(sb_in_3),
				.inv(!enc),
				.out(sb_out_3)
			);
		end
		else begin : genblk1
			reg [1:0] fsm;
			wire [1:0] n_fsm = fsm + 1;
			wire fsm_0 = fsm == 0;
			wire fsm_1 = fsm == 1;
			wire fsm_2 = fsm == 2;
			wire fsm_3 = fsm == 3;
			wire [7:0] sbox_in = ((({8 {valid && fsm_0}} & rs1[7:0]) | ({8 {valid && fsm_1}} & rs2[15:8])) | ({8 {valid && fsm_2}} & rs1[23:16])) | ({8 {valid && fsm_3}} & rs2[31:24]);
			wire [7:0] sbox_out;
			assign ready = fsm_3;
			reg [7:0] b_0;
			reg [7:0] b_1;
			reg [7:0] b_2;
			assign result = (rot ? {b_2, b_1, b_0, sbox_out} : {sbox_out, b_2, b_1, b_0});
			always @(posedge clock)
				if (reset || flush)
					b_0 <= flush_data[7:0];
				else if (fsm_0 && valid)
					b_0 <= sbox_out;
			always @(posedge clock)
				if (reset)
					b_1 <= flush_data[15:8];
				else if (fsm_1 && valid)
					b_1 <= sbox_out;
			always @(posedge clock)
				if (reset)
					b_2 <= flush_data[23:16];
				else if (fsm_2 && valid)
					b_2 <= sbox_out;
			always @(posedge clock)
				if (reset || flush)
					fsm <= 0;
				else if (valid || ready)
					fsm <= n_fsm;
			xc_aessub_sbox sbox_0(
				.in(sbox_in),
				.inv(!enc),
				.out(sbox_out)
			);
		end
	endgenerate
endmodule
module xc_aesmix (
	clock,
	reset,
	flush,
	flush_data,
	valid,
	rs1,
	rs2,
	enc,
	ready,
	result
);
	input wire clock;
	input wire reset;
	input wire flush;
	input wire [31:0] flush_data;
	input wire valid;
	input wire [31:0] rs1;
	input wire [31:0] rs2;
	input wire enc;
	output wire ready;
	output wire [31:0] result;
	parameter FAST = 1'b0;
	function [7:0] xtime2;
		input [7:0] a;
		xtime2 = (|((a >> 7) & 8'b00000001) ? (a << 1) ^ 8'h1b : a << 1);
	endfunction
	function [7:0] xtime3;
		input [7:0] a;
		xtime3 = xtime2(a) ^ a;
	endfunction
	function [7:0] xtimeN;
		input [7:0] a;
		input [3:0] b;
		xtimeN = (((b[0] ? a : 0) ^ (b[1] ? xtime2(a) : 0)) ^ (b[2] ? xtime2(xtime2(a)) : 0)) ^ (b[3] ? xtime2(xtime2(xtime2(a))) : 0);
	endfunction
	wire [7:0] e0 = rs1[7:0] & {8 {valid && enc}};
	wire [7:0] e1 = rs1[15:8] & {8 {valid && enc}};
	wire [7:0] e2 = rs2[23:16] & {8 {valid && enc}};
	wire [7:0] e3 = rs2[31:24] & {8 {valid && enc}};
	wire [7:0] d0 = rs1[7:0] & {8 {valid && !enc}};
	wire [7:0] d1 = rs1[15:8] & {8 {valid && !enc}};
	wire [7:0] d2 = rs2[23:16] & {8 {valid && !enc}};
	wire [7:0] d3 = rs2[31:24] & {8 {valid && !enc}};
	wire [31:0] result_enc;
	wire [31:0] result_dec;
	generate
		if (FAST == 1'b1) begin : genblk1
			assign ready = valid;
			wire [7:0] mix_enc_0 = ((xtime2(e0) ^ xtime3(e1)) ^ e2) ^ e3;
			wire [7:0] mix_enc_1 = ((xtime2(e1) ^ xtime3(e2)) ^ e0) ^ e3;
			wire [7:0] mix_enc_2 = ((xtime2(e2) ^ xtime3(e3)) ^ e0) ^ e1;
			wire [7:0] mix_enc_3 = ((xtime2(e3) ^ xtime3(e0)) ^ e1) ^ e2;
			assign result_enc = {mix_enc_3, mix_enc_2, mix_enc_1, mix_enc_0};
			wire [7:0] mix_dec_0 = ((xtimeN(d0, 4'he) ^ xtimeN(d1, 4'hb)) ^ xtimeN(d2, 4'hd)) ^ xtimeN(d3, 4'h9);
			wire [7:0] mix_dec_1 = ((xtimeN(d0, 4'h9) ^ xtimeN(d1, 4'he)) ^ xtimeN(d2, 4'hb)) ^ xtimeN(d3, 4'hd);
			wire [7:0] mix_dec_2 = ((xtimeN(d0, 4'hd) ^ xtimeN(d1, 4'h9)) ^ xtimeN(d2, 4'he)) ^ xtimeN(d3, 4'hb);
			wire [7:0] mix_dec_3 = ((xtimeN(d0, 4'hb) ^ xtimeN(d1, 4'hd)) ^ xtimeN(d2, 4'h9)) ^ xtimeN(d3, 4'he);
			assign result_dec = {mix_dec_3, mix_dec_2, mix_dec_1, mix_dec_0};
		end
		else begin : genblk1
			reg [1:0] fsm;
			wire [1:0] n_fsm = fsm + 1;
			wire fsm_0 = fsm == 0;
			wire fsm_1 = fsm == 1;
			wire fsm_2 = fsm == 2;
			wire fsm_3 = fsm == 3;
			assign ready = fsm_3;
			reg [7:0] b_0;
			reg [7:0] b_1;
			reg [7:0] b_2;
			wire [7:0] dec_0_lhs = ((({8 {fsm_0}} & d0) | ({8 {fsm_1}} & d1)) | ({8 {fsm_2}} & d2)) | ({8 {fsm_3}} & d3);
			wire [7:0] dec_0_out = xtimeN(dec_0_lhs, 4'he);
			wire [7:0] dec_1_lhs = ((({8 {fsm_0}} & d1) | ({8 {fsm_1}} & d2)) | ({8 {fsm_2}} & d3)) | ({8 {fsm_3}} & d0);
			wire [7:0] dec_1_out = xtimeN(dec_1_lhs, 4'hb);
			wire [7:0] dec_2_lhs = ((({8 {fsm_0}} & d2) | ({8 {fsm_1}} & d3)) | ({8 {fsm_2}} & d0)) | ({8 {fsm_3}} & d1);
			wire [7:0] dec_2_out = xtimeN(dec_2_lhs, 4'hd);
			wire [7:0] dec_3_lhs = ((({8 {fsm_0}} & d3) | ({8 {fsm_1}} & d0)) | ({8 {fsm_2}} & d1)) | ({8 {fsm_3}} & d2);
			wire [7:0] dec_3_out = xtimeN(dec_3_lhs, 4'h9);
			wire [7:0] dec_byte = ((dec_0_out ^ dec_1_out) ^ dec_2_out) ^ dec_3_out;
			wire [7:0] enc_x0_in = (({8 {fsm_0 || fsm_1}} & e3) | ({8 {fsm_2}} & e1)) | ({8 {fsm_3}} & e2);
			wire [7:0] enc_x1_in = (({8 {fsm_0}} & e2) | ({8 {fsm_1 || fsm_2}} & e0)) | ({8 {fsm_3}} & e1);
			wire [7:0] enc_x2_in = ((({8 {fsm_0}} & e0) | ({8 {fsm_1}} & e1)) | ({8 {fsm_2}} & e2)) | ({8 {fsm_3}} & e3);
			wire [7:0] enc_x2_out = xtime2(enc_x2_in);
			wire [7:0] enc_x3_in = ((({8 {fsm_0}} & e1) | ({8 {fsm_1}} & e2)) | ({8 {fsm_2}} & e3)) | ({8 {fsm_3}} & e0);
			wire [7:0] enc_x3_out = xtime3(enc_x3_in);
			wire [7:0] enc_byte = ((enc_x3_out ^ enc_x2_out) ^ enc_x1_in) ^ enc_x0_in;
			wire [7:0] step_out = (enc ? enc_byte : dec_byte);
			wire [7:0] b_3 = step_out;
			assign result_enc = {b_3, b_2, b_1, b_0};
			assign result_dec = {b_3, b_2, b_1, b_0};
			always @(posedge clock)
				if (reset || flush)
					b_0 <= flush_data[7:0];
				else if (fsm_0 && valid)
					b_0 <= step_out;
			always @(posedge clock)
				if (reset || flush)
					b_1 <= flush_data[15:8];
				else if (fsm_1 && valid)
					b_1 <= step_out;
			always @(posedge clock)
				if (reset || flush)
					b_2 <= flush_data[23:16];
				else if (fsm_2 && valid)
					b_2 <= step_out;
			always @(posedge clock)
				if (reset || flush)
					fsm <= 0;
				else if (valid || ready)
					fsm <= n_fsm;
		end
	endgenerate
	assign result = result_enc | result_dec;
endmodule
module p_addsub (
	lhs,
	rhs,
	pw,
	cin,
	sub,
	c_en,
	c_out,
	result
);
	input wire [31:0] lhs;
	input wire [31:0] rhs;
	input wire [4:0] pw;
	input wire [0:0] cin;
	input wire [0:0] sub;
	input wire c_en;
	output wire [32:0] c_out;
	output wire [31:0] result;
	wire pw_32 = pw[0];
	wire pw_16 = pw[1];
	wire pw_8 = pw[2];
	wire pw_4 = pw[3];
	wire pw_2 = pw[4];
	(* keep *) wire [31:0] carry_mask;
	wire [32:0] carry_chain;
	assign c_out[32] = carry_chain[32];
	assign carry_chain[0] = sub || cin;
	wire [31:0] rhs_m = (sub ? ~rhs : rhs);
	assign carry_mask[0] = c_en && 1'b1;
	assign carry_mask[1] = c_en && !pw_2;
	assign carry_mask[2] = c_en && 1'b1;
	assign carry_mask[3] = (c_en && !pw_2) && !pw_4;
	assign carry_mask[4] = c_en && 1'b1;
	assign carry_mask[5] = c_en && !pw_2;
	assign carry_mask[6] = c_en && 1'b1;
	assign carry_mask[7] = ((c_en && !pw_2) && !pw_4) && !pw_8;
	assign carry_mask[8] = c_en && 1'b1;
	assign carry_mask[9] = c_en && !pw_2;
	assign carry_mask[10] = c_en && 1'b1;
	assign carry_mask[11] = (c_en && !pw_2) && !pw_4;
	assign carry_mask[12] = c_en && 1'b1;
	assign carry_mask[13] = c_en && !pw_2;
	assign carry_mask[14] = c_en && 1'b1;
	assign carry_mask[15] = (((c_en && !pw_2) && !pw_4) && !pw_8) && !pw_16;
	assign carry_mask[16] = c_en && 1'b1;
	assign carry_mask[17] = c_en && !pw_2;
	assign carry_mask[18] = c_en && 1'b1;
	assign carry_mask[19] = (c_en && !pw_2) && !pw_4;
	assign carry_mask[20] = c_en && 1'b1;
	assign carry_mask[21] = c_en && !pw_2;
	assign carry_mask[22] = c_en && 1'b1;
	assign carry_mask[23] = ((c_en && !pw_2) && !pw_4) && !pw_8;
	assign carry_mask[24] = c_en && 1'b1;
	assign carry_mask[25] = c_en && !pw_2;
	assign carry_mask[26] = c_en && 1'b1;
	assign carry_mask[27] = (c_en && !pw_2) && !pw_4;
	assign carry_mask[28] = c_en && 1'b1;
	assign carry_mask[29] = c_en && !pw_2;
	assign carry_mask[30] = c_en && 1'b1;
	assign carry_mask[31] = (((c_en && !pw_2) && !pw_4) && !pw_8) && !pw_16;
	genvar i;
	generate
		for (i = 0; i < 32; i = i + 1) begin : genblk1
			wire c_in = carry_chain[i];
			wire carry = (lhs[i] && rhs_m[i]) || (c_in && (lhs[i] ^ rhs_m[i]));
			assign c_out[i] = carry;
			wire force_carry = sub && (((((((((((((((((((((((((((i == 15) && pw_16) || ((i == 7) && pw_8)) || ((i == 15) && pw_8)) || ((i == 23) && pw_8)) || ((i == 3) && pw_4)) || ((i == 7) && pw_4)) || ((i == 11) && pw_4)) || ((i == 15) && pw_4)) || ((i == 19) && pw_4)) || ((i == 23) && pw_4)) || ((i == 27) && pw_4)) || ((i == 1) && pw_2)) || ((i == 3) && pw_2)) || ((i == 5) && pw_2)) || ((i == 7) && pw_2)) || ((i == 9) && pw_2)) || ((i == 11) && pw_2)) || ((i == 13) && pw_2)) || ((i == 15) && pw_2)) || ((i == 17) && pw_2)) || ((i == 19) && pw_2)) || ((i == 21) && pw_2)) || ((i == 23) && pw_2)) || ((i == 25) && pw_2)) || ((i == 27) && pw_2)) || ((i == 29) && pw_2));
			assign carry_chain[i + 1] = (carry && carry_mask[i]) || force_carry;
			assign result[i] = (lhs[i] ^ rhs_m[i]) ^ c_in;
		end
	endgenerate
endmodule
module p_shfrot (
	crs1,
	shamt,
	pw,
	shift,
	rotate,
	left,
	right,
	result
);
	input [31:0] crs1;
	input [4:0] shamt;
	input [4:0] pw;
	input shift;
	input rotate;
	input left;
	input right;
	output wire [31:0] result;
	wire w_32 = pw[0];
	wire w_16 = pw[1];
	wire w_8 = pw[2];
	wire w_4 = pw[3];
	wire w_2 = pw[4];
	wire [31:0] l0 = crs1;
	wire [31:0] l1;
	wire [31:0] l2;
	wire [31:0] l4;
	wire [31:0] l8;
	wire [31:0] l16;
	wire [31:0] l1_32_left = {l0[30:0], rotate && l0[31]};
	wire [31:0] l1_32_right = {rotate && l0[0], l0[31:1]};
	wire [31:0] l1_16_left = {l0[30:16], rotate && l0[31], l0[14:0], rotate && l0[15]};
	wire [31:0] l1_16_right = {rotate && l0[16], l0[31:17], rotate && l0[0], l0[15:1]};
	wire [31:0] l1_8_left = {l0[30:24], rotate && l0[31], l0[22:16], rotate && l0[23], l0[14:8], rotate && l0[15], l0[6:0], rotate && l0[7]};
	wire [31:0] l1_8_right = {rotate && l0[24], l0[31:25], rotate && l0[16], l0[23:17], rotate && l0[8], l0[15:9], rotate && l0[0], l0[7:1]};
	wire [31:0] l1_4_left = {l0[30:28], rotate && l0[31], l0[26:24], rotate && l0[27], l0[22:20], rotate && l0[23], l0[18:16], rotate && l0[19], l0[14:12], rotate && l0[15], l0[10:8], rotate && l0[11], l0[6:4], rotate && l0[7], l0[2:0], rotate && l0[3]};
	wire [31:0] l1_4_right = {rotate && l0[28], l0[31:29], rotate && l0[24], l0[27:25], rotate && l0[20], l0[23:21], rotate && l0[16], l0[19:17], rotate && l0[12], l0[15:13], rotate && l0[8], l0[11:9], rotate && l0[4], l0[7:5], rotate && l0[0], l0[3:1]};
	wire [31:0] l1_2_left = {l0[30], rotate && l0[31], l0[28], rotate && l0[29], l0[26], rotate && l0[27], l0[24], rotate && l0[25], l0[22], rotate && l0[23], l0[20], rotate && l0[21], l0[18], rotate && l0[19], l0[16], rotate && l0[17], l0[14], rotate && l0[15], l0[12], rotate && l0[13], l0[10], rotate && l0[11], l0[8], rotate && l0[9], l0[6], rotate && l0[7], l0[4], rotate && l0[5], l0[2], rotate && l0[3], l0[0], rotate && l0[1]};
	wire [31:0] l1_2_right = {rotate && l0[30], l0[31], rotate && l0[28], l0[29], rotate && l0[26], l0[27], rotate && l0[24], l0[25], rotate && l0[22], l0[23], rotate && l0[20], l0[21], rotate && l0[18], l0[19], rotate && l0[16], l0[17], rotate && l0[14], l0[15], rotate && l0[12], l0[13], rotate && l0[10], l0[11], rotate && l0[8], l0[9], rotate && l0[6], l0[7], rotate && l0[4], l0[5], rotate && l0[2], l0[3], rotate && l0[0], l0[1]};
	wire ld_l1_l_32 = (left && w_32) && shamt[0];
	wire ld_l1_r_32 = (right && w_32) && shamt[0];
	wire ld_l1_l_16 = (left && w_16) && shamt[0];
	wire ld_l1_r_16 = (right && w_16) && shamt[0];
	wire ld_l1_l_8 = (left && w_8) && shamt[0];
	wire ld_l1_r_8 = (right && w_8) && shamt[0];
	wire ld_l1_l_4 = (left && w_4) && shamt[0];
	wire ld_l1_r_4 = (right && w_4) && shamt[0];
	wire ld_l1_l_2 = (left && w_2) && shamt[0];
	wire ld_l1_r_2 = (right && w_2) && shamt[0];
	wire ld_l1_n_n = !shamt[0];
	assign l1 = (((((((((({32 {ld_l1_l_32}} & l1_32_left) | ({32 {ld_l1_r_32}} & l1_32_right)) | ({32 {ld_l1_l_16}} & l1_16_left)) | ({32 {ld_l1_r_16}} & l1_16_right)) | ({32 {ld_l1_l_8}} & l1_8_left)) | ({32 {ld_l1_r_8}} & l1_8_right)) | ({32 {ld_l1_l_4}} & l1_4_left)) | ({32 {ld_l1_r_4}} & l1_4_right)) | ({32 {ld_l1_l_2}} & l1_2_left)) | ({32 {ld_l1_r_2}} & l1_2_right)) | ({32 {ld_l1_n_n}} & l0);
	wire [31:0] l2_32_left = {l1[29:0], {2 {rotate}} & l1[31:30]};
	wire [31:0] l2_32_right = {{2 {rotate}} & l1[1:0], l1[31:2]};
	wire [31:0] l2_16_left = {l1[29:16], {2 {rotate}} & l1[31:30], l1[13:0], {2 {rotate}} & l1[15:14]};
	wire [31:0] l2_16_right = {{2 {rotate}} & l1[17:16], l1[31:18], {2 {rotate}} & l1[1:0], l1[15:2]};
	wire [31:0] l2_8_left = {l1[29:24], {2 {rotate}} & l1[31:30], l1[21:16], {2 {rotate}} & l1[23:22], l1[13:8], {2 {rotate}} & l1[15:14], l1[5:0], {2 {rotate}} & l1[7:6]};
	wire [31:0] l2_8_right = {{2 {rotate}} & l1[25:24], l1[31:26], {2 {rotate}} & l1[17:16], l1[23:18], {2 {rotate}} & l1[9:8], l1[15:10], {2 {rotate}} & l1[1:0], l1[7:2]};
	wire [31:0] l2_4_left = {l1[29:28], {2 {rotate}} & l1[31:30], l1[25:24], {2 {rotate}} & l1[27:26], l1[21:20], {2 {rotate}} & l1[23:22], l1[17:16], {2 {rotate}} & l1[19:18], l1[13:12], {2 {rotate}} & l1[15:14], l1[9:8], {2 {rotate}} & l1[11:10], l1[5:4], {2 {rotate}} & l1[7:6], l1[1:0], {2 {rotate}} & l1[3:2]};
	wire [31:0] l2_4_right = {{2 {rotate}} & l1[29:28], l1[31:30], {2 {rotate}} & l1[25:24], l1[27:26], {2 {rotate}} & l1[21:20], l1[23:22], {2 {rotate}} & l1[17:16], l1[19:18], {2 {rotate}} & l1[13:12], l1[15:14], {2 {rotate}} & l1[9:8], l1[11:10], {2 {rotate}} & l1[5:4], l1[7:6], {2 {rotate}} & l1[1:0], l1[3:2]};
	wire [31:0] l2_2 = (rotate ? l1 : 32'b00000000000000000000000000000000);
	wire ld_l2_l_32 = (left && w_32) && shamt[1];
	wire ld_l2_r_32 = (right && w_32) && shamt[1];
	wire ld_l2_l_16 = (left && w_16) && shamt[1];
	wire ld_l2_r_16 = (right && w_16) && shamt[1];
	wire ld_l2_l_8 = (left && w_8) && shamt[1];
	wire ld_l2_r_8 = (right && w_8) && shamt[1];
	wire ld_l2_l_4 = (left && w_4) && shamt[1];
	wire ld_l2_r_4 = (right && w_4) && shamt[1];
	wire ld_l2_2 = w_2 && shamt[1];
	wire ld_l2_n_n = !shamt[1];
	assign l2 = ((((((((({32 {ld_l2_l_32}} & l2_32_left) | ({32 {ld_l2_r_32}} & l2_32_right)) | ({32 {ld_l2_l_16}} & l2_16_left)) | ({32 {ld_l2_r_16}} & l2_16_right)) | ({32 {ld_l2_l_8}} & l2_8_left)) | ({32 {ld_l2_r_8}} & l2_8_right)) | ({32 {ld_l2_l_4}} & l2_4_left)) | ({32 {ld_l2_r_4}} & l2_4_right)) | ({32 {ld_l2_2}} & l2_2)) | ({32 {ld_l2_n_n}} & l1);
	wire [31:0] l4_32_left = {l2[27:0], {4 {rotate}} & l2[31:28]};
	wire [31:0] l4_32_right = {{4 {rotate}} & l2[3:0], l2[31:4]};
	wire [31:0] l4_16_left = {l2[27:16], {4 {rotate}} & l2[31:28], l2[11:0], {4 {rotate}} & l2[15:12]};
	wire [31:0] l4_16_right = {{4 {rotate}} & l2[19:16], l2[31:20], {4 {rotate}} & l2[3:0], l2[15:4]};
	wire [31:0] l4_8_left = {l2[27:24], {4 {rotate}} & l2[31:28], l2[19:16], {4 {rotate}} & l2[23:20], l2[11:8], {4 {rotate}} & l2[15:12], l2[3:0], {4 {rotate}} & l2[7:4]};
	wire [31:0] l4_8_right = {{4 {rotate}} & l2[27:24], l2[31:28], {4 {rotate}} & l2[19:16], l2[23:20], {4 {rotate}} & l2[11:8], l2[15:12], {4 {rotate}} & l2[3:0], l2[7:4]};
	wire [31:0] l4_4 = (rotate ? l2 : 32'b00000000000000000000000000000000);
	wire [31:0] l4_2 = (rotate ? l2 : 32'b00000000000000000000000000000000);
	wire ld_l4_l_32 = (left && w_32) && shamt[2];
	wire ld_l4_r_32 = (right && w_32) && shamt[2];
	wire ld_l4_l_16 = (left && w_16) && shamt[2];
	wire ld_l4_r_16 = (right && w_16) && shamt[2];
	wire ld_l4_l_8 = (left && w_8) && shamt[2];
	wire ld_l4_r_8 = (right && w_8) && shamt[2];
	wire ld_l4_l_4 = (left && w_4) && shamt[2];
	wire ld_l4_r_4 = (right && w_4) && shamt[2];
	wire ld_l4_l_2 = (left && w_2) && shamt[2];
	wire ld_l4_r_2 = (right && w_2) && shamt[2];
	wire ld_l4_n_n = !shamt[2];
	assign l4 = (((((((((({32 {ld_l4_l_32}} & l4_32_left) | ({32 {ld_l4_r_32}} & l4_32_right)) | ({32 {ld_l4_l_16}} & l4_16_left)) | ({32 {ld_l4_r_16}} & l4_16_right)) | ({32 {ld_l4_l_8}} & l4_8_left)) | ({32 {ld_l4_r_8}} & l4_8_right)) | ({32 {ld_l4_l_4}} & l4_4)) | ({32 {ld_l4_r_4}} & l4_4)) | ({32 {ld_l4_l_2}} & l4_2)) | ({32 {ld_l4_r_2}} & l4_2)) | ({32 {ld_l4_n_n}} & l2);
	wire [31:0] l8_32_left = {l4[23:0], {8 {rotate}} & l4[31:24]};
	wire [31:0] l8_32_right = {{8 {rotate}} & l4[7:0], l4[31:8]};
	wire [31:0] l8_16_left = {l4[23:16], {8 {rotate}} & l4[31:24], l4[7:0], {8 {rotate}} & l4[15:8]};
	wire [31:0] l8_16_right = {{8 {rotate}} & l4[23:16], l4[31:24], {8 {rotate}} & l4[7:0], l4[15:8]};
	wire [31:0] l8_8 = (rotate ? l4 : 32'b00000000000000000000000000000000);
	wire [31:0] l8_4 = (rotate ? l4 : 32'b00000000000000000000000000000000);
	wire [31:0] l8_2 = (rotate ? l4 : 32'b00000000000000000000000000000000);
	wire ld_l8_l_32 = (left && w_32) && shamt[3];
	wire ld_l8_r_32 = (right && w_32) && shamt[3];
	wire ld_l8_l_16 = (left && w_16) && shamt[3];
	wire ld_l8_r_16 = (right && w_16) && shamt[3];
	wire ld_l8_l_8 = (left && w_8) && shamt[3];
	wire ld_l8_r_8 = (right && w_8) && shamt[3];
	wire ld_l8_l_4 = (left && w_4) && shamt[3];
	wire ld_l8_r_4 = (right && w_4) && shamt[3];
	wire ld_l8_l_2 = (left && w_2) && shamt[3];
	wire ld_l8_r_2 = (right && w_2) && shamt[3];
	wire ld_l8_n_n = !shamt[3];
	assign l8 = (((((((((({32 {ld_l8_l_32}} & l8_32_left) | ({32 {ld_l8_r_32}} & l8_32_right)) | ({32 {ld_l8_l_16}} & l8_16_left)) | ({32 {ld_l8_r_16}} & l8_16_right)) | ({32 {ld_l8_l_8}} & l8_8)) | ({32 {ld_l8_r_8}} & l8_8)) | ({32 {ld_l8_l_4}} & l8_4)) | ({32 {ld_l8_r_4}} & l8_4)) | ({32 {ld_l8_l_2}} & l8_2)) | ({32 {ld_l8_r_2}} & l8_2)) | ({32 {ld_l8_n_n}} & l4);
	wire [31:0] l16_32_left = {l8[15:0], {16 {rotate}} & l8[31:16]};
	wire [31:0] l16_32_right = {{16 {rotate}} & l8[15:0], l8[31:16]};
	wire [31:0] l16_16 = (rotate ? l8 : 32'b00000000000000000000000000000000);
	wire [31:0] l16_8 = (rotate ? l8 : 32'b00000000000000000000000000000000);
	wire [31:0] l16_4 = (rotate ? l8 : 32'b00000000000000000000000000000000);
	wire [31:0] l16_2 = (rotate ? l8 : 32'b00000000000000000000000000000000);
	wire ld_l16_l_32 = (left && w_32) && shamt[4];
	wire ld_l16_r_32 = (right && w_32) && shamt[4];
	wire ld_l16_l_16 = (left && w_16) && shamt[4];
	wire ld_l16_r_16 = (right && w_16) && shamt[4];
	wire ld_l16_l_8 = (left && w_8) && shamt[4];
	wire ld_l16_r_8 = (right && w_8) && shamt[4];
	wire ld_l16_l_4 = (left && w_4) && shamt[4];
	wire ld_l16_r_4 = (right && w_4) && shamt[4];
	wire ld_l16_l_2 = (left && w_2) && shamt[4];
	wire ld_l16_r_2 = (right && w_2) && shamt[4];
	wire ld_l16_n_n = !shamt[4];
	assign l16 = (((((((((({32 {ld_l16_l_32}} & l16_32_left) | ({32 {ld_l16_r_32}} & l16_32_right)) | ({32 {ld_l16_l_16}} & l16_16)) | ({32 {ld_l16_r_16}} & l16_16)) | ({32 {ld_l16_l_8}} & l16_8)) | ({32 {ld_l16_r_8}} & l16_8)) | ({32 {ld_l16_l_4}} & l16_4)) | ({32 {ld_l16_r_4}} & l16_4)) | ({32 {ld_l16_l_2}} & l16_2)) | ({32 {ld_l16_r_2}} & l16_2)) | ({32 {ld_l16_n_n}} & l8);
	assign result = l16;
endmodule
module xc_malu_muldivrem (
	clock,
	resetn,
	rs1,
	rs2,
	rs3,
	flush,
	valid,
	do_div,
	do_divu,
	do_rem,
	do_remu,
	do_mul,
	do_mulu,
	do_mulsu,
	do_clmul,
	do_pmul,
	do_pclmul,
	pw_32,
	pw_16,
	pw_8,
	pw_4,
	pw_2,
	count,
	acc,
	arg_0,
	arg_1,
	n_acc,
	n_arg_0,
	n_arg_1,
	padd_lhs,
	padd_rhs,
	padd_sub,
	padd_cin,
	padd_cen,
	padd_cout,
	padd_result,
	result,
	ready
);
	input wire clock;
	input wire resetn;
	input wire [31:0] rs1;
	input wire [31:0] rs2;
	input wire [31:0] rs3;
	input wire flush;
	input wire valid;
	input wire do_div;
	input wire do_divu;
	input wire do_rem;
	input wire do_remu;
	input wire do_mul;
	input wire do_mulu;
	input wire do_mulsu;
	input wire do_clmul;
	input wire do_pmul;
	input wire do_pclmul;
	input wire pw_32;
	input wire pw_16;
	input wire pw_8;
	input wire pw_4;
	input wire pw_2;
	input wire [5:0] count;
	input wire [63:0] acc;
	input wire [31:0] arg_0;
	input wire [31:0] arg_1;
	output wire [63:0] n_acc;
	output wire [31:0] n_arg_0;
	output wire [31:0] n_arg_1;
	output wire [31:0] padd_lhs;
	output wire [31:0] padd_rhs;
	output wire padd_sub;
	output wire padd_cin;
	output wire padd_cen;
	input wire [32:0] padd_cout;
	input wire [31:0] padd_result;
	output wire [63:0] result;
	output wire ready;
	wire route_div = ((do_div || do_divu) || do_rem) || do_remu;
	wire route_mul = ((do_mul || do_mulu) || do_mulsu) || do_clmul;
	wire route_pmul = do_pmul || do_pclmul;
	wire mul_carryless = do_clmul || do_pclmul;
	wire mul_lhs_sign = do_mul || do_mulsu;
	wire mul_rhs_sign = do_mul;
	wire [31:0] mul_padd_lhs;
	wire [31:0] mul_padd_rhs;
	wire mul_padd_sub;
	wire mul_padd_cin;
	wire mul_padd_cen;
	wire [63:0] mul_n_acc;
	wire [31:0] mul_n_arg_0;
	wire mul_ready;
	wire [63:0] mul_result = acc;
	wire div_outsign = (do_div && (rs1[31] != rs2[31])) && |rs2;
	wire rem_outsign = do_rem && rs1[31];
	wire result_div = do_div || do_divu;
	wire result_rem = do_rem || do_remu;
	wire div_signed = do_div || do_rem;
	wire [31:0] div_padd_lhs;
	wire [31:0] div_padd_rhs;
	wire [0:0] div_padd_sub;
	wire [63:0] div_n_acc;
	wire [31:0] div_n_arg_0;
	wire [31:0] div_n_arg_1;
	wire div_ready;
	wire [31:0] arg_sel = (result_div ? arg_1 : arg_0);
	wire arg_sel_neg = (div_outsign && result_div) || (rem_outsign && result_rem);
	wire [63:0] divrem_result = {32'b00000000000000000000000000000000, (arg_sel_neg ? -arg_sel : arg_sel)};
	wire [31:0] pmul_padd_lhs;
	wire [31:0] pmul_padd_rhs;
	wire [0:0] pmul_padd_sub;
	wire pmul_padd_cen;
	wire [63:0] pmul_n_acc;
	wire [31:0] pmul_n_arg_0;
	wire [31:0] pmul_n_arg_1;
	wire [63:0] pmul_result;
	wire pmul_ready;
	assign n_acc = (({64 {route_pmul}} & pmul_n_acc) | ({64 {route_mul}} & mul_n_acc)) | ({64 {route_div}} & div_n_acc);
	assign n_arg_0 = (({32 {route_pmul}} & pmul_n_arg_0) | ({32 {route_mul}} & mul_n_arg_0)) | ({32 {route_div}} & div_n_arg_0);
	assign n_arg_1 = div_n_arg_1;
	assign padd_lhs = ({32 {route_pmul}} & pmul_padd_lhs) | ({32 {route_mul}} & mul_padd_lhs);
	assign padd_rhs = ({32 {route_pmul}} & pmul_padd_rhs) | ({32 {route_mul}} & mul_padd_rhs);
	assign padd_sub = (route_pmul && pmul_padd_sub) || (route_mul && mul_padd_sub);
	assign padd_cin = (route_mul && mul_padd_cin) || (route_pmul && 1'b0);
	assign padd_cen = (route_mul && mul_padd_cen) || (route_pmul && pmul_padd_cen);
	assign result = (pmul_result | ({64 {route_mul}} & mul_result)) | ({64 {route_div}} & divrem_result);
	assign ready = ((route_pmul && pmul_ready) || (route_mul && mul_ready)) || (route_div && div_ready);
	xc_malu_mul i_xc_malu_mul(
		.rs1(rs1),
		.rs2(rs2),
		.count(count),
		.acc(acc),
		.arg_0(arg_0),
		.carryless(mul_carryless),
		.pw_32(pw_32),
		.pw_16(pw_16),
		.pw_8(pw_8),
		.pw_4(pw_4),
		.pw_2(pw_2),
		.lhs_sign(mul_lhs_sign),
		.rhs_sign(mul_rhs_sign),
		.padd_lhs(mul_padd_lhs),
		.padd_rhs(mul_padd_rhs),
		.padd_sub(mul_padd_sub),
		.padd_cin(mul_padd_cin),
		.padd_cen(mul_padd_cen),
		.padd_cout(padd_cout),
		.padd_result(padd_result),
		.n_acc(mul_n_acc),
		.n_arg_0(mul_n_arg_0),
		.ready(mul_ready)
	);
	xc_malu_divrem i_xc_malu_divrem(
		.clock(clock),
		.resetn(resetn),
		.rs1(rs1),
		.rs2(rs2),
		.valid(valid),
		.op_signed(div_signed),
		.flush(flush),
		.count(count),
		.acc(acc),
		.arg_0(arg_0),
		.arg_1(arg_1),
		.n_acc(div_n_acc),
		.n_arg_0(div_n_arg_0),
		.n_arg_1(div_n_arg_1),
		.ready(div_ready)
	);
	xc_malu_pmul i_malu_pmul(
		.rs1(rs1),
		.rs2(rs2),
		.count(count),
		.acc(acc),
		.arg_0(arg_0),
		.carryless(mul_carryless),
		.pw_16(pw_16),
		.pw_8(pw_8),
		.pw_4(pw_4),
		.pw_2(pw_2),
		.padd_lhs(pmul_padd_lhs),
		.padd_rhs(pmul_padd_rhs),
		.padd_sub(pmul_padd_sub),
		.padd_cen(pmul_padd_cen),
		.padd_cout(padd_cout),
		.padd_result(padd_result),
		.n_acc(pmul_n_acc),
		.n_arg_0(pmul_n_arg_0),
		.result(pmul_result),
		.ready(pmul_ready)
	);
endmodule
module xc_malu_long (
	rs1,
	rs2,
	rs3,
	fsm_init,
	fsm_mdr,
	fsm_msub_1,
	fsm_macc_1,
	fsm_mmul_1,
	fsm_mmul_2,
	fsm_done,
	acc,
	carry,
	count,
	padd_lhs,
	padd_rhs,
	padd_cin,
	padd_sub,
	padd_cout,
	padd_result,
	uop_madd,
	uop_msub,
	uop_macc,
	uop_mmul,
	n_carry,
	n_acc,
	result,
	ready
);
	input wire [31:0] rs1;
	input wire [31:0] rs2;
	input wire [31:0] rs3;
	input wire fsm_init;
	input wire fsm_mdr;
	input wire fsm_msub_1;
	input wire fsm_macc_1;
	input wire fsm_mmul_1;
	input wire fsm_mmul_2;
	input wire fsm_done;
	input wire [63:0] acc;
	input wire [0:0] carry;
	input wire [5:0] count;
	output wire [31:0] padd_lhs;
	output wire [31:0] padd_rhs;
	output wire padd_cin;
	output wire [0:0] padd_sub;
	input [32:0] padd_cout;
	input [31:0] padd_result;
	input wire uop_madd;
	input wire uop_msub;
	input wire uop_macc;
	input wire uop_mmul;
	output wire n_carry;
	output wire [63:0] n_acc;
	output wire [63:0] result;
	output wire ready;
	wire [32:0] msub_lhs_0 = {1'b0, rs1};
	wire [32:0] msub_lhs_1 = acc[32:0];
	wire [32:0] msub_rhs_0 = {1'b0, rs2};
	wire [32:0] msub_rhs_1 = {32'b00000000000000000000000000000000, rs3[0]};
	wire [32:0] msub_lhs = (fsm_msub_1 ? msub_lhs_1 : msub_lhs_0);
	wire [32:0] msub_rhs = (fsm_msub_1 ? msub_rhs_1 : msub_rhs_0);
	wire [32:0] sub_result = $unsigned(msub_lhs) - $unsigned(msub_rhs);
	wire [31:0] macc_lhs_0 = rs2;
	wire [31:0] macc_lhs_1 = rs1;
	wire [31:0] macc_rhs_0 = rs3;
	wire [31:0] macc_rhs_1 = {31'b0000000000000000000000000000000, carry};
	wire [31:0] macc_lhs = (fsm_init ? macc_lhs_0 : macc_lhs_1);
	wire [31:0] macc_rhs = (fsm_init ? macc_rhs_0 : macc_rhs_1);
	wire [63:0] macc_acc_0 = {acc[63:32], padd_result};
	wire [63:0] macc_acc_1 = {padd_result, acc[31:0]};
	wire [63:0] macc_n_acc = (fsm_macc_1 ? macc_acc_1 : macc_acc_0);
	wire [31:0] mmul_lhs_0 = rs3;
	wire [31:0] mmul_lhs_1 = acc[63:32];
	wire [31:0] mmul_rhs_0 = acc[31:0];
	wire [31:0] mmul_rhs_1 = {31'b0000000000000000000000000000000, carry};
	wire [31:0] mmul_lhs = (fsm_mmul_2 ? mmul_lhs_0 : mmul_lhs_1);
	wire [31:0] mmul_rhs = (fsm_mmul_2 ? mmul_rhs_0 : mmul_rhs_1);
	wire [63:0] mmul_acc_0 = {acc[63:32], padd_result};
	wire [63:0] mmul_acc_1 = {padd_result, acc[31:0]};
	wire [63:0] mmul_n_acc = (fsm_mmul_2 ? mmul_acc_0 : mmul_acc_1);
	assign padd_lhs = (({32 {uop_madd}} & rs1) | ({32 {uop_macc}} & macc_lhs)) | ({32 {uop_mmul}} & mmul_lhs);
	assign padd_rhs = (({32 {uop_madd}} & rs2) | ({32 {uop_macc}} & macc_rhs)) | ({32 {uop_mmul}} & mmul_rhs);
	assign padd_sub = 1'b0;
	assign padd_cin = uop_madd && rs3[0];
	assign n_carry = padd_cout[32];
	assign n_acc = ((({64 {uop_madd}} & {acc[63:32], padd_result}) | ({64 {uop_msub}} & {31'b0000000000000000000000000000000, sub_result})) | ({64 {uop_macc}} & {macc_n_acc})) | ({64 {uop_mmul}} & {mmul_n_acc});
	wire result_acc = (uop_msub || uop_macc) || uop_mmul;
	assign result = ({64 {uop_madd}} & {31'b0000000000000000000000000000000, padd_cout[31], padd_result}) | ({64 {result_acc}} & {acc});
	assign ready = uop_madd;
endmodule
module xc_malu_mul (
	rs1,
	rs2,
	count,
	acc,
	arg_0,
	carryless,
	pw_32,
	pw_16,
	pw_8,
	pw_4,
	pw_2,
	lhs_sign,
	rhs_sign,
	padd_lhs,
	padd_rhs,
	padd_sub,
	padd_cin,
	padd_cen,
	padd_cout,
	padd_result,
	n_acc,
	n_arg_0,
	ready
);
	input wire [31:0] rs1;
	input wire [31:0] rs2;
	input wire [5:0] count;
	input wire [63:0] acc;
	input wire [31:0] arg_0;
	input wire carryless;
	input wire pw_32;
	input wire pw_16;
	input wire pw_8;
	input wire pw_4;
	input wire pw_2;
	input wire lhs_sign;
	input wire rhs_sign;
	output wire [31:0] padd_lhs;
	output wire [31:0] padd_rhs;
	output wire padd_sub;
	output wire padd_cin;
	output wire padd_cen;
	input wire [32:0] padd_cout;
	input wire [31:0] padd_result;
	output wire [63:0] n_acc;
	output wire [31:0] n_arg_0;
	output wire ready;
	assign ready = count == {pw_32, pw_16, pw_8, pw_4, pw_2, 1'b0};
	wire add_en = arg_0[0];
	wire sub_last = ((rs2[31] && (count == 31)) && rhs_sign) && |rs1;
	wire [32:0] add_lhs = {lhs_sign && acc[63], acc[63:32]};
	wire [32:0] add_rhs = (add_en ? {lhs_sign && rs1[31], rs1} : 0);
	assign padd_lhs = add_lhs[31:0];
	assign padd_rhs = add_rhs[31:0];
	assign padd_sub = sub_last;
	assign padd_cin = 1'b0;
	assign padd_cen = !carryless;
	wire add_32 = (carryless ? 1'b0 : ((add_lhs[32] + add_rhs[32]) + sub_last) + padd_cout[31]);
	wire [32:0] add_result = {add_32, padd_result};
	assign n_acc = {add_result, acc[31:1]};
	assign n_arg_0 = {1'b0, arg_0[31:1]};
endmodule
module xc_malu_divrem (
	clock,
	resetn,
	rs1,
	rs2,
	valid,
	op_signed,
	flush,
	count,
	acc,
	arg_0,
	arg_1,
	n_acc,
	n_arg_0,
	n_arg_1,
	ready
);
	input wire clock;
	input wire resetn;
	input wire [31:0] rs1;
	input wire [31:0] rs2;
	input wire valid;
	input wire op_signed;
	input wire flush;
	input wire [5:0] count;
	input wire [63:0] acc;
	input wire [31:0] arg_0;
	input wire [31:0] arg_1;
	output wire [63:0] n_acc;
	output wire [31:0] n_arg_0;
	output wire [31:0] n_arg_1;
	output wire ready;
	reg div_run;
	wire div_finished = div_run && (count == 32);
	assign ready = div_finished;
	wire signed_lhs = op_signed && rs1[31];
	wire signed_rhs = op_signed && rs2[31];
	wire div_start = valid && !div_run;
	wire [31:0] qmask = (32'b00000000000000000000000000000001 << 31) >> count;
	wire div_less = acc <= {32'b00000000000000000000000000000000, arg_0};
	wire [31:0] sub_result = arg_0 - acc[31:0];
	wire [63:0] divisor_start = {(signed_rhs ? -{rs2[31], rs2} : {1'b0, rs2}), 31'b0000000000000000000000000000000};
	assign n_acc = (div_start ? divisor_start : acc >> 1);
	assign n_arg_0 = (div_start ? (signed_lhs ? -rs1 : rs1) : (div_less ? sub_result : arg_0));
	assign n_arg_1 = (div_start ? 0 : (div_run && div_less ? arg_1 | qmask : arg_1));
	always @(posedge clock)
		if (!resetn || flush)
			div_run <= 1'b0;
		else if (div_start)
			div_run <= 1'b1;
		else if (div_run)
			if (div_finished)
				div_run <= 1'b0;
endmodule
module xc_malu_pmul (
	rs1,
	rs2,
	count,
	acc,
	arg_0,
	carryless,
	pw_16,
	pw_8,
	pw_4,
	pw_2,
	padd_lhs,
	padd_rhs,
	padd_sub,
	padd_cen,
	padd_cout,
	padd_result,
	n_acc,
	n_arg_0,
	result,
	ready
);
	input wire [31:0] rs1;
	input wire [31:0] rs2;
	input wire [5:0] count;
	input wire [63:0] acc;
	input wire [31:0] arg_0;
	input wire carryless;
	input wire pw_16;
	input wire pw_8;
	input wire pw_4;
	input wire pw_2;
	output wire [31:0] padd_lhs;
	output wire [31:0] padd_rhs;
	output wire [0:0] padd_sub;
	output wire padd_cen;
	input [32:0] padd_cout;
	input [31:0] padd_result;
	output wire [63:0] n_acc;
	output wire [31:0] n_arg_0;
	output wire [63:0] result;
	output wire ready;
	wire [5:0] counter_finish = {1'b0, pw_16, pw_8, pw_4, pw_2, 1'b0};
	assign n_arg_0 = {1'b0, arg_0[31:1]};
	assign ready = count == counter_finish;
	assign padd_cen = !carryless;
	wire add_en_16_0 = arg_0[0];
	wire add_en_16_1 = arg_0[16];
	wire add_en_8_0 = arg_0[0];
	wire add_en_8_1 = arg_0[8];
	wire add_en_8_2 = arg_0[16];
	wire add_en_8_3 = arg_0[24];
	wire add_en_4_0 = arg_0[0];
	wire add_en_4_1 = arg_0[4];
	wire add_en_4_2 = arg_0[8];
	wire add_en_4_3 = arg_0[12];
	wire add_en_4_4 = arg_0[16];
	wire add_en_4_5 = arg_0[20];
	wire add_en_4_6 = arg_0[24];
	wire add_en_4_7 = arg_0[28];
	wire add_en_2_0 = arg_0[0];
	wire add_en_2_1 = arg_0[2];
	wire add_en_2_2 = arg_0[4];
	wire add_en_2_3 = arg_0[6];
	wire add_en_2_4 = arg_0[8];
	wire add_en_2_5 = arg_0[10];
	wire add_en_2_6 = arg_0[12];
	wire add_en_2_7 = arg_0[14];
	wire add_en_2_8 = arg_0[16];
	wire add_en_2_9 = arg_0[18];
	wire add_en_2_10 = arg_0[20];
	wire add_en_2_11 = arg_0[22];
	wire add_en_2_12 = arg_0[24];
	wire add_en_2_13 = arg_0[26];
	wire add_en_2_14 = arg_0[28];
	wire add_en_2_15 = arg_0[30];
	wire [15:0] addm_16_0 = {16 {add_en_16_0}};
	wire [15:0] addm_16_1 = {16 {add_en_16_1}};
	wire [31:0] addm_16 = {addm_16_1, addm_16_0};
	wire [7:0] addm_8_0 = {8 {add_en_8_0}};
	wire [7:0] addm_8_1 = {8 {add_en_8_1}};
	wire [7:0] addm_8_2 = {8 {add_en_8_2}};
	wire [7:0] addm_8_3 = {8 {add_en_8_3}};
	wire [31:0] addm_8 = {addm_8_3, addm_8_2, addm_8_1, addm_8_0};
	wire [3:0] addm_4_0 = {4 {add_en_4_0}};
	wire [3:0] addm_4_1 = {4 {add_en_4_1}};
	wire [3:0] addm_4_2 = {4 {add_en_4_2}};
	wire [3:0] addm_4_3 = {4 {add_en_4_3}};
	wire [3:0] addm_4_4 = {4 {add_en_4_4}};
	wire [3:0] addm_4_5 = {4 {add_en_4_5}};
	wire [3:0] addm_4_6 = {4 {add_en_4_6}};
	wire [3:0] addm_4_7 = {4 {add_en_4_7}};
	wire [31:0] addm_4 = {addm_4_7, addm_4_6, addm_4_5, addm_4_4, addm_4_3, addm_4_2, addm_4_1, addm_4_0};
	wire [1:0] addm_2_0 = {2 {add_en_2_0}};
	wire [1:0] addm_2_1 = {2 {add_en_2_1}};
	wire [1:0] addm_2_2 = {2 {add_en_2_2}};
	wire [1:0] addm_2_3 = {2 {add_en_2_3}};
	wire [1:0] addm_2_4 = {2 {add_en_2_4}};
	wire [1:0] addm_2_5 = {2 {add_en_2_5}};
	wire [1:0] addm_2_6 = {2 {add_en_2_6}};
	wire [1:0] addm_2_7 = {2 {add_en_2_7}};
	wire [1:0] addm_2_8 = {2 {add_en_2_8}};
	wire [1:0] addm_2_9 = {2 {add_en_2_9}};
	wire [1:0] addm_2_10 = {2 {add_en_2_10}};
	wire [1:0] addm_2_11 = {2 {add_en_2_11}};
	wire [1:0] addm_2_12 = {2 {add_en_2_12}};
	wire [1:0] addm_2_13 = {2 {add_en_2_13}};
	wire [1:0] addm_2_14 = {2 {add_en_2_14}};
	wire [1:0] addm_2_15 = {2 {add_en_2_15}};
	wire [31:0] addm_2 = {addm_2_15, addm_2_14, addm_2_13, addm_2_12, addm_2_11, addm_2_10, addm_2_9, addm_2_8, addm_2_7, addm_2_6, addm_2_5, addm_2_4, addm_2_3, addm_2_2, addm_2_1, addm_2_0};
	wire [31:0] padd_mask = ((({32 {pw_16}} & addm_16) | ({32 {pw_8}} & addm_8)) | ({32 {pw_4}} & addm_4)) | ({32 {pw_2}} & addm_2);
	wire [31:0] padd_lhs_16 = {acc[63:48], acc[31:16]};
	wire [31:0] padd_lhs_8 = {acc[63:56], acc[47:40], acc[31:24], acc[15:8]};
	wire [31:0] padd_lhs_4 = {acc[63:60], acc[55:52], acc[47:44], acc[39:36], acc[31:28], acc[23:20], acc[15:12], acc[7:4]};
	wire [31:0] padd_lhs_2 = {acc[63:62], acc[59:58], acc[55:54], acc[51:50], acc[47:46], acc[43:42], acc[39:38], acc[35:34], acc[31:30], acc[27:26], acc[23:22], acc[19:18], acc[15:14], acc[11:10], acc[7:6], acc[3:2]};
	assign padd_lhs = ((({32 {pw_16}} & padd_lhs_16) | ({32 {pw_8}} & padd_lhs_8)) | ({32 {pw_4}} & padd_lhs_4)) | ({32 {pw_2}} & padd_lhs_2);
	assign padd_rhs = rs1 & padd_mask;
	assign padd_sub = 1'b0;
	wire [31:0] cadd_carry = 32'b00000000000000000000000000000000;
	wire [31:0] add_result = padd_result;
	wire [31:0] add_carry = padd_cout[31:0];
	wire [63:0] n_acc_16 = {add_carry[31], add_result[31:16], acc[47:33], add_carry[15], add_result[15:0], acc[15:1]};
	wire [63:0] n_acc_8 = {add_carry[31], add_result[31:24], acc[55:49], add_carry[23], add_result[23:16], acc[39:33], add_carry[15], add_result[15:8], acc[23:17], add_carry[7], add_result[7:0], acc[7:1]};
	wire [63:0] n_acc_4 = {add_carry[31], add_result[31:28], acc[59:57], add_carry[27], add_result[27:24], acc[51:49], add_carry[23], add_result[23:20], acc[43:41], add_carry[19], add_result[19:16], acc[35:33], add_carry[15], add_result[15:12], acc[27:25], add_carry[11], add_result[11:8], acc[19:17], add_carry[7], add_result[7:4], acc[11:9], add_carry[3], add_result[3:0], acc[3:1]};
	wire [63:0] n_acc_2 = {add_carry[31], add_result[31:30], acc[61], add_carry[29], add_result[29:28], acc[57], add_carry[27], add_result[27:26], acc[53], add_carry[25], add_result[25:24], acc[49], add_carry[23], add_result[23:22], acc[45], add_carry[21], add_result[21:20], acc[41], add_carry[19], add_result[19:18], acc[37], add_carry[17], add_result[17:16], acc[33], add_carry[15], add_result[15:14], acc[29], add_carry[13], add_result[13:12], acc[25], add_carry[11], add_result[11:10], acc[21], add_carry[9], add_result[9:8], acc[17], add_carry[7], add_result[7:6], acc[13], add_carry[5], add_result[5:4], acc[9], add_carry[3], add_result[3:2], acc[5], add_carry[1], add_result[1:0], acc[1]};
	assign n_acc = ((({64 {pw_16}} & n_acc_16) | ({64 {pw_8}} & n_acc_8)) | ({64 {pw_4}} & n_acc_4)) | ({64 {pw_2}} & n_acc_2);
	wire [31:0] pmul_result_0_16 = {acc[32+:16], acc[0+:16]};
	wire [31:0] pmul_result_1_16 = {acc[48+:16], acc[16+:16]};
	wire [31:0] pmul_result_0_8 = {acc[48+:8], acc[32+:8], acc[16+:8], acc[0+:8]};
	wire [31:0] pmul_result_1_8 = {acc[56+:8], acc[40+:8], acc[24+:8], acc[8+:8]};
	wire [31:0] pmul_result_0_4 = {acc[56+:4], acc[48+:4], acc[40+:4], acc[32+:4], acc[24+:4], acc[16+:4], acc[8+:4], acc[0+:4]};
	wire [31:0] pmul_result_1_4 = {acc[60+:4], acc[52+:4], acc[44+:4], acc[36+:4], acc[28+:4], acc[20+:4], acc[12+:4], acc[4+:4]};
	wire [31:0] pmul_result_0_2 = {acc[60+:2], acc[56+:2], acc[52+:2], acc[48+:2], acc[44+:2], acc[40+:2], acc[36+:2], acc[32+:2], acc[28+:2], acc[24+:2], acc[20+:2], acc[16+:2], acc[12+:2], acc[8+:2], acc[4+:2], acc[0+:2]};
	wire [31:0] pmul_result_1_2 = {acc[62+:2], acc[58+:2], acc[54+:2], acc[50+:2], acc[46+:2], acc[42+:2], acc[38+:2], acc[34+:2], acc[30+:2], acc[26+:2], acc[22+:2], acc[18+:2], acc[14+:2], acc[10+:2], acc[6+:2], acc[2+:2]};
	wire [31:0] pmul_result_0 = ((({32 {pw_16}} & pmul_result_0_16) | ({32 {pw_8}} & pmul_result_0_8)) | ({32 {pw_4}} & pmul_result_0_4)) | ({32 {pw_2}} & pmul_result_0_2);
	wire [31:0] pmul_result_1 = ((({32 {pw_16}} & pmul_result_1_16) | ({32 {pw_8}} & pmul_result_1_8)) | ({32 {pw_4}} & pmul_result_1_4)) | ({32 {pw_2}} & pmul_result_1_2);
	assign result = {pmul_result_1, pmul_result_0};
endmodule
module xc_malu (
	clock,
	resetn,
	rs1,
	rs2,
	rs3,
	flush,
	flush_data,
	valid,
	uop_div,
	uop_divu,
	uop_rem,
	uop_remu,
	uop_mul,
	uop_mulu,
	uop_mulsu,
	uop_clmul,
	uop_pmul,
	uop_pclmul,
	uop_madd,
	uop_msub,
	uop_macc,
	uop_mmul,
	pw_32,
	pw_16,
	pw_8,
	pw_4,
	pw_2,
	result,
	ready
);
	input wire clock;
	input wire resetn;
	input wire [31:0] rs1;
	input wire [31:0] rs2;
	input wire [31:0] rs3;
	input wire flush;
	input wire [31:0] flush_data;
	input wire valid;
	input wire uop_div;
	input wire uop_divu;
	input wire uop_rem;
	input wire uop_remu;
	input wire uop_mul;
	input wire uop_mulu;
	input wire uop_mulsu;
	input wire uop_clmul;
	input wire uop_pmul;
	input wire uop_pclmul;
	input wire uop_madd;
	input wire uop_msub;
	input wire uop_macc;
	input wire uop_mmul;
	input wire pw_32;
	input wire pw_16;
	input wire pw_8;
	input wire pw_4;
	input wire pw_2;
	output wire [63:0] result;
	output wire ready;
	wire insn_divrem = ((uop_div || uop_divu) || uop_rem) || uop_remu;
	wire insn_mdr = (((((insn_divrem || uop_mul) || uop_mulu) || uop_mulsu) || uop_clmul) || uop_pmul) || uop_pclmul;
	wire insn_long = ((uop_madd || uop_msub) || uop_macc) || uop_mmul;
	wire do_div = uop_div;
	wire do_divu = uop_divu;
	wire do_rem = uop_rem;
	wire do_remu = uop_remu;
	wire do_mul = uop_mul;
	reg [7:0] fsm;
	wire fsm_init = fsm[0];
	wire fsm_mmul_1 = fsm[4];
	wire do_mulu = uop_mulu || ((uop_mmul && fsm_init) || fsm_mmul_1);
	wire do_mulsu = uop_mulsu;
	wire do_clmul = uop_clmul;
	wire do_pmul = uop_pmul;
	wire do_pclmul = uop_pclmul;
	wire [63:0] mdr_n_acc;
	wire [31:0] mdr_n_arg_0;
	wire [31:0] mdr_n_arg_1;
	wire [31:0] mdr_padd_lhs;
	wire [31:0] mdr_padd_rhs;
	wire mdr_padd_sub;
	wire mdr_padd_cin;
	wire mdr_padd_cen;
	wire [63:0] mdr_result;
	wire mdr_ready;
	wire [31:0] long_padd_lhs;
	wire [31:0] long_padd_rhs;
	wire long_padd_cin;
	wire [0:0] long_padd_sub;
	wire long_n_carry;
	wire [63:0] long_n_acc;
	wire [63:0] long_result;
	wire long_ready;
	assign result = mdr_result | long_result;
	wire ld_long = insn_long && !((fsm_init || fsm_mmul_1) && uop_mmul);
	wire [31:0] padd_lhs = mdr_padd_lhs | ({32 {ld_long}} & long_padd_lhs);
	wire [31:0] padd_rhs = mdr_padd_rhs | ({32 {ld_long}} & long_padd_rhs);
	wire padd_sub = mdr_padd_sub || (ld_long && long_padd_sub);
	wire padd_cin = mdr_padd_cin || (ld_long && long_padd_cin);
	wire padd_cen = mdr_padd_cen || (ld_long && 1'b1);
	wire [4:0] padd_pw = {pw_2, pw_4, pw_8, pw_16, pw_32};
	wire [32:0] padd_cout;
	wire [31:0] padd_result;
	reg [7:0] n_fsm;
	localparam FSM_INIT = 8'b00000001;
	localparam FSM_MDR = 8'b00000010;
	localparam FSM_MSUB_1 = 8'b00000100;
	localparam FSM_MACC_1 = 8'b00001000;
	localparam FSM_MMUL_1 = 8'b00010000;
	localparam FSM_MMUL_2 = 8'b00100000;
	localparam FSM_MMUL_3 = 8'b01000000;
	localparam FSM_DONE = 8'b10000000;
	wire fsm_mdr = fsm[1];
	wire fsm_msub_1 = fsm[2];
	wire fsm_macc_1 = fsm[3];
	wire fsm_mmul_2 = fsm[5];
	wire fsm_mmul_3 = fsm[6];
	wire fsm_done = fsm[7];
	always @(*) begin
		n_fsm = FSM_INIT;
		case (fsm)
			FSM_INIT:
				if (valid) begin
					if (insn_mdr && !uop_mmul)
						n_fsm = FSM_MDR;
					else if (uop_msub)
						n_fsm = FSM_MSUB_1;
					else if (uop_macc)
						n_fsm = FSM_MACC_1;
					else if (uop_mmul)
						n_fsm = FSM_MMUL_1;
				end
				else
					n_fsm = FSM_INIT;
			FSM_MDR:
				if (mdr_ready)
					n_fsm = FSM_DONE;
				else
					n_fsm = FSM_MDR;
			FSM_MSUB_1: n_fsm = FSM_DONE;
			FSM_MACC_1: n_fsm = FSM_DONE;
			FSM_MMUL_1:
				if (mdr_ready)
					n_fsm = FSM_MMUL_2;
				else
					n_fsm = FSM_MMUL_1;
			FSM_MMUL_2: n_fsm = FSM_MMUL_3;
			FSM_MMUL_3: n_fsm = FSM_DONE;
			FSM_DONE: n_fsm = FSM_DONE;
			default: n_fsm = FSM_INIT;
		endcase
	end
	always @(posedge clock)
		if (!resetn || flush)
			fsm <= FSM_INIT;
		else
			fsm <= n_fsm;
	reg [5:0] count;
	wire [5:0] n_count = count + 1;
	wire count_en = fsm_mdr || ((fsm_init && uop_mmul) && valid);
	reg [63:0] acc;
	wire ld_mdr = insn_mdr || ((fsm_init || fsm_mmul_1) && uop_mmul);
	wire [63:0] n_acc = ({64 {ld_mdr}} & mdr_n_acc) | ({64 {ld_long}} & long_n_acc);
	reg [31:0] arg_0;
	wire [31:0] n_arg_0 = {32 {ld_mdr}} & mdr_n_arg_0;
	reg [31:0] arg_1;
	wire [31:0] n_arg_1 = mdr_n_arg_1;
	reg carry;
	wire n_carry = insn_long && long_n_carry;
	wire ld_on_init = insn_divrem || (insn_long && !uop_mmul);
	wire reg_ld_en = count_en || insn_long;
	always @(posedge clock)
		if (!resetn || flush) begin
			count <= 0;
			acc <= {flush_data, flush_data};
			arg_0 <= flush_data;
			arg_1 <= flush_data;
			carry <= 0;
		end
		else if (fsm_init && valid) begin
			acc <= (ld_on_init ? n_acc : 0);
			arg_0 <= (ld_on_init ? n_arg_0 : rs2);
			arg_1 <= n_arg_1;
			carry <= n_carry;
			if (count_en)
				count <= n_count;
		end
		else if (((reg_ld_en && !ready) && !fsm_done) && valid) begin
			count <= n_count;
			acc <= n_acc;
			arg_0 <= n_arg_0;
			arg_1 <= n_arg_1;
			carry <= n_carry;
		end
	assign ready = ((insn_mdr && mdr_ready) || (insn_long && long_ready)) || fsm_done;
	p_addsub i_p_addsub(
		.lhs(padd_lhs),
		.rhs(padd_rhs),
		.pw(padd_pw),
		.cin(padd_cin),
		.sub(padd_sub),
		.c_en(padd_cen),
		.c_out(padd_cout),
		.result(padd_result)
	);
	xc_malu_muldivrem i_malu_muldivrem(
		.clock(clock),
		.resetn(resetn),
		.rs1(rs1),
		.rs2(rs2),
		.rs3(rs3),
		.flush(flush),
		.valid(valid),
		.do_div(do_div),
		.do_divu(do_divu),
		.do_rem(do_rem),
		.do_remu(do_remu),
		.do_mul(do_mul),
		.do_mulu(do_mulu),
		.do_mulsu(do_mulsu),
		.do_clmul(do_clmul),
		.do_pmul(do_pmul),
		.do_pclmul(do_pclmul),
		.pw_32(pw_32),
		.pw_16(pw_16),
		.pw_8(pw_8),
		.pw_4(pw_4),
		.pw_2(pw_2),
		.count(count),
		.acc(acc),
		.arg_0(arg_0),
		.arg_1(arg_1),
		.n_acc(mdr_n_acc),
		.n_arg_0(mdr_n_arg_0),
		.n_arg_1(mdr_n_arg_1),
		.padd_lhs(mdr_padd_lhs),
		.padd_rhs(mdr_padd_rhs),
		.padd_sub(mdr_padd_sub),
		.padd_cin(mdr_padd_cin),
		.padd_cen(mdr_padd_cen),
		.padd_cout(padd_cout),
		.padd_result(padd_result),
		.result(mdr_result),
		.ready(mdr_ready)
	);
	xc_malu_long i_xc_malu_long(
		.rs1(rs1),
		.rs2(rs2),
		.rs3(rs3),
		.fsm_init(fsm_init),
		.fsm_mdr(fsm_mdr),
		.fsm_msub_1(fsm_msub_1),
		.fsm_macc_1(fsm_macc_1),
		.fsm_mmul_1(fsm_mmul_1),
		.fsm_mmul_2(fsm_mmul_2),
		.fsm_done(fsm_done),
		.acc(acc),
		.carry(carry),
		.count(count),
		.padd_lhs(long_padd_lhs),
		.padd_rhs(long_padd_rhs),
		.padd_cin(long_padd_cin),
		.padd_sub(long_padd_sub),
		.padd_cout(padd_cout),
		.padd_result(padd_result),
		.uop_madd(uop_madd),
		.uop_msub(uop_msub),
		.uop_macc(uop_macc),
		.uop_mmul(uop_mmul),
		.n_carry(long_n_carry),
		.n_acc(long_n_acc),
		.result(long_result),
		.ready(long_ready)
	);
endmodule
module b_lut (
	crs1,
	crs2,
	crs3,
	result
);
	input wire [31:0] crs1;
	input wire [31:0] crs2;
	input wire [31:0] crs3;
	output wire [31:0] result;
	wire [3:0] lut_arr [15:0];
	wire [63:0] lut_con = {crs1, crs2};
	genvar i;
	generate
		for (i = 0; i < 16; i = i + 1) begin : genblk1
			assign lut_arr[i] = lut_con[(4 * i) + 3:4 * i];
		end
	endgenerate
	genvar j;
	generate
		for (j = 0; j < 8; j = j + 1) begin : genblk2
			assign result[(4 * j) + 3:4 * j] = lut_arr[crs3[(4 * j) + 3:4 * j]];
		end
	endgenerate
endmodule
module b_bop (
	rd,
	rs1,
	rs2,
	lut,
	result
);
	input wire [31:0] rd;
	input wire [31:0] rs1;
	input wire [31:0] rs2;
	input wire [7:0] lut;
	output wire [31:0] result;
	genvar i;
	generate
		for (i = 0; i < 32; i = i + 1) begin : genblk1
			wire [2:0] idx = {rd[i], rs2[i], rs1[i]};
			assign result[i] = lut[idx];
		end
	endgenerate
endmodule
module frv_alu (
	g_clk,
	g_resetn,
	alu_valid,
	alu_flush,
	alu_ready,
	alu_pw,
	alu_op_add,
	alu_op_sub,
	alu_op_xor,
	alu_op_or,
	alu_op_and,
	alu_op_shf,
	alu_op_rot,
	alu_op_shf_left,
	alu_op_shf_arith,
	alu_op_cmp,
	alu_op_unsigned,
	alu_lt,
	alu_eq,
	alu_add_result,
	alu_lhs,
	alu_rhs,
	alu_result
);
	input g_clk;
	input g_resetn;
	input alu_valid;
	input alu_flush;
	output wire alu_ready;
	localparam mypackage_PW = 2;
	input [mypackage_PW:0] alu_pw;
	input alu_op_add;
	input alu_op_sub;
	input alu_op_xor;
	input alu_op_or;
	input alu_op_and;
	input alu_op_shf;
	input alu_op_rot;
	input alu_op_shf_left;
	input alu_op_shf_arith;
	input alu_op_cmp;
	input alu_op_unsigned;
	output wire alu_lt;
	output wire alu_eq;
	localparam mypackage_XLEN = 32;
	localparam mypackage_XL = 31;
	output wire [mypackage_XL:0] alu_add_result;
	input [mypackage_XL:0] alu_lhs;
	input [mypackage_XL:0] alu_rhs;
	output wire [mypackage_XL:0] alu_result;
	assign alu_ready = alu_valid;
	localparam mypackage_PW_16 = 3'b011;
	localparam mypackage_PW_2 = 3'b000;
	localparam mypackage_PW_32 = 3'b100;
	localparam mypackage_PW_4 = 3'b001;
	localparam mypackage_PW_8 = 3'b010;
	wire [4:0] pw_d = {alu_pw == mypackage_PW_2, alu_pw == mypackage_PW_4, alu_pw == mypackage_PW_8, alu_pw == mypackage_PW_16, alu_pw == mypackage_PW_32};
	wire [mypackage_XL:0] adder_result;
	p_addsub i_p_addsub(
		.lhs(alu_lhs),
		.rhs(alu_rhs),
		.pw(pw_d),
		.sub(alu_op_sub),
		.cin(1'b0),
		.c_en(1'b1),
		.result(adder_result)
	);
	assign alu_add_result = adder_result[mypackage_XL:0];
	wire alu_lt_signed = $signed(alu_lhs) < $signed(alu_rhs);
	wire alu_lt_unsigned = $unsigned(alu_lhs) < $unsigned(alu_rhs);
	assign alu_lt = (alu_op_unsigned ? alu_lt_unsigned : alu_lt_signed);
	assign alu_eq = alu_lhs == alu_rhs;
	wire [31:0] shift_out;
	wire [4:0] shamt = alu_rhs[4:0];
	p_shfrot i_p_shfrot(
		.crs1(alu_lhs),
		.shamt(shamt),
		.pw(pw_d),
		.shift(alu_op_shf),
		.rotate(alu_op_rot),
		.left(alu_op_shf_left),
		.right(!alu_op_shf_left),
		.result(shift_out)
	);
	wire shift_arith = alu_op_shf_arith && alu_lhs[mypackage_XL];
	wire [mypackage_XL:0] shift_arith_mask = (shift_arith ? ~(32'hffffffff >> shamt) : 0);
	wire [mypackage_XL:0] shift_result = shift_out | shift_arith_mask;
	wire [mypackage_XL:0] bw_lhs = alu_lhs;
	wire [mypackage_XL:0] bw_rhs = alu_rhs;
	wire [mypackage_XL:0] bw_result = (({mypackage_XLEN {alu_op_xor}} & (bw_lhs ^ bw_rhs)) | ({mypackage_XLEN {alu_op_or}} & (bw_lhs | bw_rhs))) | ({mypackage_XLEN {alu_op_and}} & (bw_lhs & bw_rhs));
	wire out_adder = (alu_op_add || alu_op_sub) && !alu_op_cmp;
	wire out_shift = alu_op_shf || alu_op_rot;
	wire out_bw = (alu_op_xor || alu_op_or) || alu_op_and;
	wire out_cmp = alu_op_cmp;
	assign alu_result = (out_adder ? adder_result[mypackage_XL:0] : (({mypackage_XLEN {out_shift}} & shift_result[mypackage_XL:0]) | ({mypackage_XLEN {out_bw}} & bw_result)) | ({mypackage_XLEN {out_cmp}} & {31'b0000000000000000000000000000000, alu_lt}));
endmodule
module frv_asi (
	g_clk,
	g_resetn,
	asi_valid,
	asi_ready,
	asi_flush_aessub,
	asi_flush_aesmix,
	asi_flush_data,
	asi_uop,
	asi_rs1,
	asi_rs2,
	asi_shamt,
	asi_result
);
	input g_clk;
	input g_resetn;
	input asi_valid;
	output wire asi_ready;
	input wire asi_flush_aessub;
	input wire asi_flush_aesmix;
	input wire [31:0] asi_flush_data;
	localparam mypackage_OP = 4;
	input wire [mypackage_OP:0] asi_uop;
	localparam mypackage_XLEN = 32;
	localparam mypackage_XL = 31;
	input wire [mypackage_XL:0] asi_rs1;
	input wire [mypackage_XL:0] asi_rs2;
	input wire [1:0] asi_shamt;
	output wire [mypackage_XL:0] asi_result;
	parameter XC_CLASS_AES = 1'b1;
	parameter XC_CLASS_SHA2 = 1'b1;
	parameter XC_CLASS_SHA3 = 1'b1;
	parameter AES_SUB_FAST = 1'b0;
	parameter AES_MIX_FAST = 1'b0;
	localparam mypackage_ASI_AES = 2'b01;
	wire insn_aes = asi_valid && (asi_uop[mypackage_OP:3] == mypackage_ASI_AES);
	wire insn_aes_sub = (XC_CLASS_AES && insn_aes) && !asi_uop[2];
	wire insn_aes_mix = (XC_CLASS_AES && insn_aes) && asi_uop[2];
	localparam mypackage_ASI_SHA2 = 2'b10;
	wire insn_sha2 = (XC_CLASS_SHA2 && asi_valid) && (asi_uop[mypackage_OP:3] == mypackage_ASI_SHA2);
	localparam mypackage_ASI_SHA3 = 2'b11;
	wire insn_sha3 = (XC_CLASS_SHA3 && asi_valid) && (asi_uop[mypackage_OP:3] == mypackage_ASI_SHA3);
	localparam mypackage_ASI_AESSUB_ENC = {mypackage_ASI_AES, 3'b000};
	wire insn_aessub_enc = asi_valid && (asi_uop == mypackage_ASI_AESSUB_ENC);
	localparam mypackage_ASI_AESSUB_ENCROT = {mypackage_ASI_AES, 3'b010};
	wire insn_aessub_encrot = asi_valid && (asi_uop == mypackage_ASI_AESSUB_ENCROT);
	localparam mypackage_ASI_AESSUB_DEC = {mypackage_ASI_AES, 3'b001};
	wire insn_aessub_dec = asi_valid && (asi_uop == mypackage_ASI_AESSUB_DEC);
	localparam mypackage_ASI_AESSUB_DECROT = {mypackage_ASI_AES, 3'b011};
	wire insn_aessub_decrot = asi_valid && (asi_uop == mypackage_ASI_AESSUB_DECROT);
	localparam mypackage_ASI_AESMIX_ENC = {mypackage_ASI_AES, 3'b100};
	wire insn_aesmix_enc = asi_valid && (asi_uop == mypackage_ASI_AESMIX_ENC);
	localparam mypackage_ASI_AESMIX_DEC = {mypackage_ASI_AES, 3'b101};
	wire insn_aesmix_dec = asi_valid && (asi_uop == mypackage_ASI_AESMIX_DEC);
	localparam mypackage_ASI_SHA3_XY = {mypackage_ASI_SHA3, 3'b000};
	wire insn_sha3_xy = asi_valid && (asi_uop == mypackage_ASI_SHA3_XY);
	localparam mypackage_ASI_SHA3_X1 = {mypackage_ASI_SHA3, 3'b001};
	wire insn_sha3_x1 = asi_valid && (asi_uop == mypackage_ASI_SHA3_X1);
	localparam mypackage_ASI_SHA3_X2 = {mypackage_ASI_SHA3, 3'b010};
	wire insn_sha3_x2 = asi_valid && (asi_uop == mypackage_ASI_SHA3_X2);
	localparam mypackage_ASI_SHA3_X4 = {mypackage_ASI_SHA3, 3'b011};
	wire insn_sha3_x4 = asi_valid && (asi_uop == mypackage_ASI_SHA3_X4);
	localparam mypackage_ASI_SHA3_YX = {mypackage_ASI_SHA3, 3'b100};
	wire insn_sha3_yx = asi_valid && (asi_uop == mypackage_ASI_SHA3_YX);
	localparam mypackage_ASI_SHA256_S0 = {mypackage_ASI_SHA2, 3'b000};
	wire insn_sha256_s0 = asi_valid && (asi_uop == mypackage_ASI_SHA256_S0);
	localparam mypackage_ASI_SHA256_S1 = {mypackage_ASI_SHA2, 3'b001};
	wire insn_sha256_s1 = asi_valid && (asi_uop == mypackage_ASI_SHA256_S1);
	localparam mypackage_ASI_SHA256_S2 = {mypackage_ASI_SHA2, 3'b010};
	wire insn_sha256_s2 = asi_valid && (asi_uop == mypackage_ASI_SHA256_S2);
	localparam mypackage_ASI_SHA256_S3 = {mypackage_ASI_SHA2, 3'b011};
	wire insn_sha256_s3 = asi_valid && (asi_uop == mypackage_ASI_SHA256_S3);
	wire [mypackage_XL:0] sha2_rs1 = {mypackage_XLEN {insn_sha2}} & asi_rs1;
	wire [1:0] sha2_ss = asi_uop[1:0];
	wire [mypackage_XL:0] aes_sub_rs1 = {mypackage_XLEN {insn_aes_sub}} & asi_rs1;
	wire [mypackage_XL:0] aes_sub_rs2 = {mypackage_XLEN {insn_aes_sub}} & asi_rs2;
	wire aes_sub_enc = !asi_uop[0];
	wire aes_sub_rot = asi_uop[1];
	wire [mypackage_XL:0] aes_mix_rs1 = {mypackage_XLEN {insn_aes_mix}} & asi_rs1;
	wire [mypackage_XL:0] aes_mix_rs2 = {mypackage_XLEN {insn_aes_mix}} & asi_rs2;
	wire aes_mix_enc = !asi_uop[0];
	wire [mypackage_XL:0] result_aessub;
	wire [mypackage_XL:0] result_aesmix;
	wire [mypackage_XL:0] result_sha2;
	wire [mypackage_XL:0] result_sha3;
	assign asi_result = ((({32 {insn_aes_mix}} & result_aesmix) | ({32 {insn_aes_sub}} & result_aessub)) | ({32 {insn_sha2}} & result_sha2)) | ({32 {insn_sha3}} & result_sha3);
	wire aes_sub_ready;
	wire aes_mix_ready;
	assign asi_ready = ((insn_sha2 || insn_sha3) || (insn_aes_sub && aes_sub_ready)) || (insn_aes_mix && aes_mix_ready);
	xc_sha3 i_xc_sha3(
		.rs1(asi_rs1),
		.rs2(asi_rs2),
		.shamt(asi_shamt),
		.f_xy(insn_sha3_xy),
		.f_x1(insn_sha3_x1),
		.f_x2(insn_sha3_x2),
		.f_x4(insn_sha3_x4),
		.f_yx(insn_sha3_yx),
		.result(result_sha3)
	);
	xc_sha256 i_xc_sha256(
		.rs1(sha2_rs1),
		.ss(sha2_ss),
		.result(result_sha2)
	);
	xc_aessub #(.FAST(AES_SUB_FAST)) i_xc_aessub(
		.clock(g_clk),
		.reset(!g_resetn),
		.flush(asi_flush_aessub),
		.flush_data(asi_flush_data),
		.valid(insn_aes_sub),
		.rs1(aes_sub_rs1),
		.rs2(aes_sub_rs2),
		.enc(aes_sub_enc),
		.rot(aes_sub_rot),
		.ready(aes_sub_ready),
		.result(result_aessub)
	);
	xc_aesmix #(.FAST(AES_MIX_FAST)) i_xc_aesmix(
		.clock(g_clk),
		.reset(!g_resetn),
		.valid(insn_aes_mix),
		.flush(asi_flush_aesmix),
		.flush_data(asi_flush_data),
		.rs1(aes_mix_rs1),
		.rs2(aes_mix_rs2),
		.enc(aes_mix_enc),
		.ready(aes_mix_ready),
		.result(result_aesmix)
	);
endmodule
module frv_bitwise (
	rs1,
	rs2,
	rs3,
	bop_lut,
	flush,
	valid,
	uop_fsl,
	uop_fsr,
	uop_mror,
	uop_cmov,
	uop_lut,
	uop_bop,
	result,
	ready
);
	input wire [31:0] rs1;
	input wire [31:0] rs2;
	input wire [31:0] rs3;
	input wire [7:0] bop_lut;
	input wire flush;
	input wire valid;
	input wire uop_fsl;
	input wire uop_fsr;
	input wire uop_mror;
	input wire uop_cmov;
	input wire uop_lut;
	input wire uop_bop;
	output wire [63:0] result;
	output wire ready;
	parameter XC_CLASS_BIT = 1'b1;
	wire [31:0] result_cmov = (|rs2 ? rs1 : rs3);
	wire [5:0] ramt = (uop_mror ? rs3[5:0] : rs2[5:0]);
	wire [63:0] rword_r = {rs1, (uop_mror ? rs2 : rs3)};
	wire [63:0] rword_l;
	wire [63:0] r_in = (uop_fsl ? rword_l : rword_r);
	wire [63:0] rt_5 = (ramt[5] ? {r_in[31:0], r_in[63:32]} : r_in);
	wire [63:0] rt_4 = (ramt[4] ? {rt_5[15:0], rt_5[63:16]} : rt_5);
	wire [63:0] rt_3 = (ramt[3] ? {rt_4[7:0], rt_4[63:8]} : rt_4);
	wire [63:0] rt_2 = (ramt[2] ? {rt_3[3:0], rt_3[63:4]} : rt_3);
	wire [63:0] rt_1 = (ramt[1] ? {rt_2[1:0], rt_2[63:2]} : rt_2);
	wire [63:0] rt_0 = (ramt[0] ? {rt_1[0], rt_1[63:1]} : rt_1);
	wire [63:0] rout_l;
	wire [63:0] r_out = (uop_fsl ? rout_l : rt_0);
	genvar i;
	generate
		for (i = 0; i < 64; i = i + 1) begin : genblk1
			assign rword_l[i] = rword_r[63 - i];
			assign rout_l[i] = rt_0[63 - i];
		end
	endgenerate
	wire [31:0] result_lut;
	generate
		if (XC_CLASS_BIT) begin : genblk2
			b_lut i_b_lut(
				.crs1(rs1),
				.crs2(rs2),
				.crs3(rs3),
				.result(result_lut)
			);
		end
		else begin : genblk2
			assign result_lut = 0;
		end
	endgenerate
	wire [31:0] result_bop;
	generate
		if (XC_CLASS_BIT) begin : genblk3
			b_bop i_b_bop(
				.rs1(rs1),
				.rs2(rs2),
				.rd(rs3),
				.lut(bop_lut),
				.result(result_bop)
			);
		end
		else begin : genblk3
			assign result_bop = 0;
		end
	endgenerate
	wire result_fsl = uop_fsl || uop_fsr;
	assign result = (((({64 {result_fsl}} & {32'b00000000000000000000000000000000, r_out[63:32]}) | ({64 {uop_mror}} & {r_out})) | ({64 {uop_cmov}} & {32'b00000000000000000000000000000000, result_cmov})) | ({64 {uop_bop}} & {32'b00000000000000000000000000000000, result_bop})) | ({64 {uop_lut}} & {32'b00000000000000000000000000000000, result_lut});
	assign ready = valid;
endmodule
module frv_core_fetch_buffer (
	g_clk,
	g_resetn,
	flush,
	f_4byte,
	f_2byte,
	f_err,
	f_in,
	f_ready,
	buf_depth,
	buf_16,
	buf_32,
	buf_out,
	buf_out_2,
	buf_out_4,
	buf_err,
	buf_valid,
	buf_ready
);
	input g_clk;
	input g_resetn;
	input flush;
	input f_4byte;
	input f_2byte;
	input f_err;
	localparam mypackage_XLEN = 32;
	localparam mypackage_XL = 31;
	input [mypackage_XL:0] f_in;
	output wire f_ready;
	output wire [2:0] buf_depth;
	output wire buf_16;
	output wire buf_32;
	output wire [mypackage_XL:0] buf_out;
	output wire buf_out_2;
	output wire buf_out_4;
	output wire buf_err;
	output wire buf_valid;
	input buf_ready;
	reg [63:0] buffer;
	wire [63:0] n_buffer;
	reg [3:0] buffer_err;
	wire [3:0] n_buffer_err;
	reg [2:0] bdepth;
	wire [2:0] n_bdepth;
	wire eat_2;
	wire eat_4;
	assign f_ready = ((bdepth <= 2) || ((bdepth == 3) && (eat_2 || eat_4))) || ((bdepth == 4) && eat_4);
	assign buf_out = buffer[31:0];
	assign buf_err = |buffer_err[1:0];
	assign buf_16 = (buf_out[1:0] != 2'b11) && |bdepth;
	assign buf_32 = (buf_out[1:0] == 2'b11) && |bdepth;
	assign buf_depth = bdepth;
	assign buf_out_2 = (bdepth >= 3'd1) && buf_16;
	assign buf_out_4 = (bdepth >= 3'd2) && buf_32;
	assign eat_2 = buf_out_2 && buf_ready;
	assign eat_4 = buf_out_4 && buf_ready;
	assign buf_valid = buf_out_2 || buf_out_4;
	wire [2:0] bdepth_add = {1'b0, f_4byte, f_2byte};
	wire [2:0] bdepth_sub = {1'b0, eat_4, eat_2};
	wire [2:0] insert_at = bdepth - bdepth_sub;
	assign n_bdepth = (bdepth + bdepth_add) - bdepth_sub;
	wire [31:0] n_buffer_d = (f_2byte ? {16'b0000000000000000, f_in[31:16]} : (f_4byte ? f_in : 32'b00000000000000000000000000000000));
	wire [63:0] n_buffer_or_in = {32'b00000000000000000000000000000000, n_buffer_d} << (16 * insert_at);
	wire [63:0] n_buffer_shf_out = buffer >> (16 * bdepth_sub);
	assign n_buffer = n_buffer_or_in | n_buffer_shf_out;
	wire n_err_in = f_err && (f_2byte || f_4byte);
	wire [3:0] n_err_or_in = {2'b00, {2 {n_err_in}}} << insert_at;
	wire [3:0] n_err_shf_out = buffer_err >> insert_at;
	assign n_buffer_err = n_err_or_in | n_err_shf_out;
	wire update_buffer = (f_4byte || f_2byte) || buf_ready;
	always @(posedge g_clk)
		if (!g_resetn || flush) begin
			buffer <= 64'b0000000000000000000000000000000000000000000000000000000000000000;
			buffer_err <= 4'b0000;
			bdepth <= 3'd0;
		end
		else if (update_buffer) begin
			buffer <= n_buffer;
			buffer_err <= n_buffer_err;
			bdepth <= n_bdepth;
		end
endmodule
module cellift_scarv (
	g_clk,
	g_resetn,
	trs_pc,
	trs_instr,
	trs_valid,
	leak_prng,
	leak_fence_unc0,
	leak_fence_unc1,
	leak_fence_unc2,
	rng_req_valid,
	rng_req_op,
	rng_req_data,
	rng_req_ready,
	rng_rsp_valid,
	rng_rsp_status,
	rng_rsp_data,
	rng_rsp_ready,
	int_nmi,
	int_external,
	int_extern_cause,
	int_software,
	int_mtime,
	imem_req,
	imem_wen,
	imem_strb,
	imem_wdata,
	imem_addr,
	imem_gnt,
	imem_recv,
	imem_ack,
	imem_error,
	imem_rdata,
	dmem_req,
	dmem_wen,
	dmem_strb,
	dmem_wdata,
	dmem_addr,
	dmem_gnt,
	dmem_recv,
	dmem_ack,
	dmem_error,
	dmem_rdata
);
	input g_clk;
	input g_resetn;
	localparam mypackage_XLEN = 32;
	localparam mypackage_XL = 31;
	output wire [mypackage_XL:0] trs_pc;
	output wire [31:0] trs_instr;
	output wire trs_valid;
	output wire [mypackage_XL:0] leak_prng;
	output wire leak_fence_unc0;
	output wire leak_fence_unc1;
	output wire leak_fence_unc2;
	output wire rng_req_valid;
	output wire [2:0] rng_req_op;
	output wire [31:0] rng_req_data;
	input wire rng_req_ready;
	input wire rng_rsp_valid;
	input wire [2:0] rng_rsp_status;
	input wire [31:0] rng_rsp_data;
	output wire rng_rsp_ready;
	input wire int_nmi;
	input wire int_external;
	input wire [3:0] int_extern_cause;
	input wire int_software;
	output wire int_mtime;
	output wire imem_req;
	output wire imem_wen;
	output wire [3:0] imem_strb;
	output wire [mypackage_XL:0] imem_wdata;
	output wire [mypackage_XL:0] imem_addr;
	input wire imem_gnt;
	input wire imem_recv;
	output wire imem_ack;
	input wire imem_error;
	input wire [mypackage_XL:0] imem_rdata;
	output wire dmem_req;
	output wire dmem_wen;
	output wire [3:0] dmem_strb;
	output wire [mypackage_XL:0] dmem_wdata;
	output wire [mypackage_XL:0] dmem_addr;
	input wire dmem_gnt;
	input wire dmem_recv;
	output wire dmem_ack;
	input wire dmem_error;
	input wire [mypackage_XL:0] dmem_rdata;
	parameter MMIO_BASE_ADDR = 32'h00001000;
	parameter MMIO_BASE_MASK = 32'hfffff000;
	parameter FRV_PC_RESET_VALUE = 32'h80000000;
	parameter BRAM_REGFILE = 0;
	parameter TRACE_INSTR_WORD = 1'b1;
	parameter XC_CLASS_BASELINE = 1'b1;
	parameter XC_CLASS_RANDOMNESS = 1'b1 && XC_CLASS_BASELINE;
	parameter XC_CLASS_MEMORY = 1'b0 && XC_CLASS_BASELINE;
	parameter XC_CLASS_BIT = 1'b1 && XC_CLASS_BASELINE;
	parameter XC_CLASS_PACKED = 1'b1 && XC_CLASS_BASELINE;
	parameter XC_CLASS_MULTIARITH = 1'b1 && XC_CLASS_BASELINE;
	parameter XC_CLASS_AES = 1'b1 && XC_CLASS_BASELINE;
	parameter XC_CLASS_SHA2 = 1'b1 && XC_CLASS_BASELINE;
	parameter XC_CLASS_SHA3 = 1'b1 && XC_CLASS_BASELINE;
	parameter XC_CLASS_LEAK = 1'b1 && XC_CLASS_BASELINE;
	parameter XC_CLASS_LEAK_STRONG = 1'b1 && XC_CLASS_LEAK;
	parameter XC_CLASS_LEAK_BUBBLE = 1'b1 && XC_CLASS_LEAK;
	parameter AES_SUB_FAST = 1'b0;
	parameter AES_MIX_FAST = 1'b0;
	parameter BITMANIP_BASELINE = 1'b1;
	parameter CSR_MIMPID = 32'b00000000000000000000000000000000;
	wire instr_ret;
	wire [63:0] ctr_time;
	wire [63:0] ctr_cycle;
	wire [63:0] ctr_instret;
	wire mstatus_mie;
	wire mie_meie;
	wire mie_mtie;
	wire mie_msie;
	wire ti_pending;
	wire mip_meip;
	wire mip_mtip;
	wire mip_msip;
	assign int_mtime = mip_mtip;
	wire int_trap_req;
	wire [5:0] int_trap_cause;
	wire int_trap_ack;
	wire inhibit_cy;
	wire inhibit_tm;
	wire inhibit_ir;
	wire mmio_en;
	wire mmio_wen;
	wire [31:0] mmio_addr;
	wire [31:0] mmio_wdata;
	wire [31:0] mmio_rdata;
	wire mmio_error;
	frv_pipeline #(
		.FRV_PC_RESET_VALUE(FRV_PC_RESET_VALUE),
		.BRAM_REGFILE(BRAM_REGFILE),
		.TRACE_INSTR_WORD(TRACE_INSTR_WORD),
		.MMIO_BASE_ADDR(MMIO_BASE_ADDR),
		.MMIO_BASE_MASK(MMIO_BASE_MASK),
		.XC_CLASS_BASELINE(XC_CLASS_BASELINE),
		.XC_CLASS_RANDOMNESS(XC_CLASS_RANDOMNESS),
		.XC_CLASS_MEMORY(XC_CLASS_MEMORY),
		.XC_CLASS_BIT(XC_CLASS_BIT),
		.XC_CLASS_PACKED(XC_CLASS_PACKED),
		.XC_CLASS_MULTIARITH(XC_CLASS_MULTIARITH),
		.XC_CLASS_AES(XC_CLASS_AES),
		.XC_CLASS_SHA2(XC_CLASS_SHA2),
		.XC_CLASS_SHA3(XC_CLASS_SHA3),
		.XC_CLASS_LEAK(XC_CLASS_LEAK),
		.XC_CLASS_LEAK_STRONG(XC_CLASS_LEAK_STRONG),
		.XC_CLASS_LEAK_BUBBLE(XC_CLASS_LEAK_BUBBLE),
		.AES_SUB_FAST(AES_SUB_FAST),
		.AES_MIX_FAST(AES_MIX_FAST),
		.BITMANIP_BASELINE(BITMANIP_BASELINE),
		.CSR_MIMPID(CSR_MIMPID)
	) i_pipeline(
		.g_clk(g_clk),
		.g_resetn(g_resetn),
		.trs_pc(trs_pc),
		.trs_instr(trs_instr),
		.trs_valid(trs_valid),
		.leak_prng(leak_prng),
		.leak_fence_unc0(leak_fence_unc0),
		.leak_fence_unc1(leak_fence_unc1),
		.leak_fence_unc2(leak_fence_unc2),
		.rng_req_valid(rng_req_valid),
		.rng_req_op(rng_req_op),
		.rng_req_data(rng_req_data),
		.rng_req_ready(rng_req_ready),
		.rng_rsp_valid(rng_rsp_valid),
		.rng_rsp_status(rng_rsp_status),
		.rng_rsp_data(rng_rsp_data),
		.rng_rsp_ready(rng_rsp_ready),
		.instr_ret(instr_ret),
		.mstatus_mie(mstatus_mie),
		.mie_meie(mie_meie),
		.mie_mtie(mie_mtie),
		.mie_msie(mie_msie),
		.mip_meip(mip_meip),
		.mip_mtip(mip_mtip),
		.mip_msip(mip_msip),
		.int_trap_req(int_trap_req),
		.int_trap_cause(int_trap_cause),
		.int_trap_ack(int_trap_ack),
		.ctr_time(ctr_time),
		.ctr_cycle(ctr_cycle),
		.ctr_instret(ctr_instret),
		.inhibit_cy(inhibit_cy),
		.inhibit_tm(inhibit_tm),
		.inhibit_ir(inhibit_ir),
		.mmio_en(mmio_en),
		.mmio_wen(mmio_wen),
		.mmio_addr(mmio_addr),
		.mmio_wdata(mmio_wdata),
		.mmio_rdata(mmio_rdata),
		.mmio_error(mmio_error),
		.imem_req(imem_req),
		.imem_wen(imem_wen),
		.imem_strb(imem_strb),
		.imem_wdata(imem_wdata),
		.imem_addr(imem_addr),
		.imem_gnt(imem_gnt),
		.imem_recv(imem_recv),
		.imem_ack(imem_ack),
		.imem_error(imem_error),
		.imem_rdata(imem_rdata),
		.dmem_req(dmem_req),
		.dmem_wen(dmem_wen),
		.dmem_strb(dmem_strb),
		.dmem_wdata(dmem_wdata),
		.dmem_addr(dmem_addr),
		.dmem_gnt(dmem_gnt),
		.dmem_recv(dmem_recv),
		.dmem_ack(dmem_ack),
		.dmem_error(dmem_error),
		.dmem_rdata(dmem_rdata)
	);
	frv_interrupt i_interrupts(
		.g_clk(g_clk),
		.g_resetn(g_resetn),
		.mstatus_mie(mstatus_mie),
		.mie_meie(mie_meie),
		.mie_mtie(mie_mtie),
		.mie_msie(mie_msie),
		.nmi_pending(int_nmi),
		.ex_pending(int_external),
		.ex_cause(int_extern_cause),
		.ti_pending(ti_pending),
		.sw_pending(int_software),
		.mip_meip(mip_meip),
		.mip_mtip(mip_mtip),
		.mip_msip(mip_msip),
		.int_trap_req(int_trap_req),
		.int_trap_cause(int_trap_cause),
		.int_trap_ack(int_trap_ack)
	);
	frv_counters #(
		.MMIO_BASE_ADDR(MMIO_BASE_ADDR),
		.MMIO_BASE_MASK(MMIO_BASE_MASK)
	) i_counters(
		.g_clk(g_clk),
		.g_resetn(g_resetn),
		.instr_ret(instr_ret),
		.timer_interrupt(ti_pending),
		.ctr_time(ctr_time),
		.ctr_cycle(ctr_cycle),
		.ctr_instret(ctr_instret),
		.inhibit_cy(inhibit_cy),
		.inhibit_tm(inhibit_tm),
		.inhibit_ir(inhibit_ir),
		.mmio_en(mmio_en),
		.mmio_wen(mmio_wen),
		.mmio_addr(mmio_addr),
		.mmio_wdata(mmio_wdata),
		.mmio_rdata(mmio_rdata),
		.mmio_error(mmio_error)
	);
endmodule
module frv_counters (
	g_clk,
	g_resetn,
	instr_ret,
	timer_interrupt,
	ctr_time,
	ctr_cycle,
	ctr_instret,
	inhibit_cy,
	inhibit_tm,
	inhibit_ir,
	mmio_en,
	mmio_wen,
	mmio_addr,
	mmio_wdata,
	mmio_rdata,
	mmio_error
);
	input g_clk;
	input g_resetn;
	input instr_ret;
	output reg timer_interrupt;
	output wire [63:0] ctr_time;
	output reg [63:0] ctr_cycle;
	output reg [63:0] ctr_instret;
	input wire inhibit_cy;
	input wire inhibit_tm;
	input wire inhibit_ir;
	input wire mmio_en;
	input wire mmio_wen;
	input wire [31:0] mmio_addr;
	input wire [31:0] mmio_wdata;
	output reg [31:0] mmio_rdata;
	output reg mmio_error;
	parameter MMIO_BASE_ADDR = 32'h00001000;
	parameter MMIO_BASE_MASK = 32'hfffff000;
	localparam MMIO_MTIME_ADDR = MMIO_BASE_ADDR;
	localparam MMIO_MTIME_ADDR_HI = MMIO_MTIME_ADDR + 4;
	localparam MMIO_MTIMECMP_ADDR = MMIO_BASE_ADDR + 8;
	localparam MMIO_MTIMECMP_ADDR_HI = MMIO_MTIMECMP_ADDR + 4;
	parameter MMIO_MTIMECMP_RESET = -1;
	wire addr_mtime_lo = mmio_en && ((mmio_addr & ~MMIO_BASE_MASK) == (MMIO_MTIME_ADDR & ~MMIO_BASE_MASK));
	wire addr_mtime_hi = mmio_en && ((mmio_addr & ~MMIO_BASE_MASK) == (MMIO_MTIME_ADDR_HI & ~MMIO_BASE_MASK));
	wire addr_mtimecmp_lo = mmio_en && ((mmio_addr & ~MMIO_BASE_MASK) == (MMIO_MTIMECMP_ADDR & ~MMIO_BASE_MASK));
	wire addr_mtimecmp_hi = mmio_en && ((mmio_addr & ~MMIO_BASE_MASK) == (MMIO_MTIMECMP_ADDR_HI & ~MMIO_BASE_MASK));
	reg [63:0] mapped_mtime;
	reg [63:0] mapped_mtimecmp;
	wire [63:0] n_mapped_mtime = mapped_mtime + 1;
	wire n_timer_interrupt = mapped_mtime >= mapped_mtimecmp;
	wire wr_mtime_hi = addr_mtime_hi && mmio_wen;
	wire wr_mtime_lo = addr_mtime_lo && mmio_wen;
	always @(posedge g_clk)
		if (!g_resetn)
			mapped_mtime <= 0;
		else if (wr_mtime_hi)
			mapped_mtime <= {mmio_wdata, mapped_mtime[31:0]};
		else if (wr_mtime_lo)
			mapped_mtime <= {mapped_mtime[63:32], mmio_wdata};
		else if (!inhibit_tm)
			mapped_mtime <= n_mapped_mtime;
	always @(posedge g_clk)
		if (!g_resetn)
			timer_interrupt <= 0;
		else
			timer_interrupt <= n_timer_interrupt;
	wire wr_mtimecmp_hi = addr_mtimecmp_hi && mmio_wen;
	wire wr_mtimecmp_lo = addr_mtimecmp_lo && mmio_wen;
	always @(posedge g_clk)
		if (!g_resetn)
			mapped_mtimecmp <= MMIO_MTIMECMP_RESET;
		else if (wr_mtimecmp_hi)
			mapped_mtimecmp <= {mmio_wdata[31:0], mapped_mtimecmp[31:0]};
		else if (wr_mtimecmp_lo)
			mapped_mtimecmp <= {mapped_mtimecmp[63:32], mmio_wdata[31:0]};
	wire [31:0] n_mmio_rdata = ((({32 {addr_mtime_lo}} & mapped_mtime[31:0]) | ({32 {addr_mtime_hi}} & mapped_mtime[63:32])) | ({32 {addr_mtimecmp_lo}} & mapped_mtimecmp[31:0])) | ({32 {addr_mtimecmp_hi}} & mapped_mtimecmp[63:32]);
	wire n_mmio_error = mmio_en && !(((addr_mtime_lo || addr_mtime_hi) || addr_mtimecmp_lo) || addr_mtimecmp_hi);
	always @(posedge g_clk)
		if (!g_resetn) begin
			mmio_error <= 1'b0;
			mmio_rdata <= 32'b00000000000000000000000000000000;
		end
		else if (mmio_en) begin
			mmio_error <= n_mmio_error;
			mmio_rdata <= n_mmio_rdata;
		end
	assign ctr_time = mapped_mtime;
	wire [63:0] n_ctr_instret = ctr_instret + 1;
	always @(posedge g_clk)
		if (!g_resetn)
			ctr_instret <= 0;
		else if (instr_ret && !inhibit_ir)
			ctr_instret <= n_ctr_instret;
	wire [63:0] n_ctr_cycle = ctr_cycle + 1;
	always @(posedge g_clk)
		if (!g_resetn)
			ctr_cycle <= 0;
		else if (!inhibit_cy)
			ctr_cycle <= n_ctr_cycle;
endmodule
module frv_csrs (
	g_clk,
	g_resetn,
	csr_en,
	csr_wr,
	csr_wr_set,
	csr_wr_clr,
	csr_addr,
	csr_wdata,
	csr_rdata,
	csr_error,
	csr_mepc,
	csr_mtvec,
	vector_intrs,
	exec_mret,
	mstatus_mie,
	mie_meie,
	mie_mtie,
	mie_msie,
	mip_meip,
	mip_mtip,
	mip_msip,
	ctr_time,
	ctr_cycle,
	ctr_instret,
	inhibit_cy,
	inhibit_tm,
	inhibit_ir,
	uxcrypto_ct,
	uxcrypto_b0,
	uxcrypto_b1,
	leak_lkgcfg,
	trap_cpu,
	trap_int,
	trap_cause,
	trap_mtval,
	trap_pc
);
	input g_clk;
	input g_resetn;
	input csr_en;
	input csr_wr;
	input csr_wr_set;
	input csr_wr_clr;
	input [11:0] csr_addr;
	localparam mypackage_XLEN = 32;
	localparam mypackage_XL = 31;
	input [mypackage_XL:0] csr_wdata;
	output wire [mypackage_XL:0] csr_rdata;
	output wire csr_error;
	output wire [mypackage_XL:0] csr_mepc;
	output wire [mypackage_XL:0] csr_mtvec;
	output wire vector_intrs;
	input wire exec_mret;
	output wire mstatus_mie;
	output reg mie_meie;
	output reg mie_mtie;
	output reg mie_msie;
	input wire mip_meip;
	input wire mip_mtip;
	input wire mip_msip;
	input wire [63:0] ctr_time;
	input wire [63:0] ctr_cycle;
	input wire [63:0] ctr_instret;
	output wire inhibit_cy;
	output wire inhibit_tm;
	output wire inhibit_ir;
	output reg uxcrypto_ct;
	output reg [7:0] uxcrypto_b0;
	output reg [7:0] uxcrypto_b1;
	output wire [12:0] leak_lkgcfg;
	input wire trap_cpu;
	input wire trap_int;
	input wire [5:0] trap_cause;
	input wire [mypackage_XL:0] trap_mtval;
	input wire [mypackage_XL:0] trap_pc;
	parameter CSR_MTVEC_RESET_VALUE = 32'hc0000000;
	parameter CSR_MVENDORID = 32'b00000000000000000000000000000000;
	parameter CSR_MARCHID = 32'b00000000000000000000000000000000;
	parameter CSR_MIMPID = 32'b00000000000000000000000000000000;
	parameter CSR_MHARTID = 32'b00000000000000000000000000000000;
	localparam CSR_ADDR_CYCLE = 12'hc00;
	localparam CSR_ADDR_TIME = 12'hc01;
	localparam CSR_ADDR_INSTRET = 12'hc02;
	localparam CSR_ADDR_CYCLEH = 12'hc80;
	localparam CSR_ADDR_TIMEH = 12'hc81;
	localparam CSR_ADDR_INSTRETH = 12'hc82;
	localparam CSR_ADDR_MCYCLE = 12'hb00;
	localparam CSR_ADDR_MINSTRET = 12'hb02;
	localparam CSR_ADDR_MCYCLEH = 12'hb80;
	localparam CSR_ADDR_MINSTRETH = 12'hb82;
	localparam CSR_ADDR_MCOUNTIN = 12'h320;
	localparam CSR_ADDR_MSTATUS = 12'h300;
	localparam CSR_ADDR_MISA = 12'h301;
	localparam CSR_ADDR_MEDELEG = 12'h302;
	localparam CSR_ADDR_MIDELEG = 12'h303;
	localparam CSR_ADDR_MIE = 12'h304;
	localparam CSR_ADDR_MTVEC = 12'h305;
	localparam CSR_ADDR_MSCRATCH = 12'h340;
	localparam CSR_ADDR_MEPC = 12'h341;
	localparam CSR_ADDR_MCAUSE = 12'h342;
	localparam CSR_ADDR_MTVAL = 12'h343;
	localparam CSR_ADDR_MIP = 12'h344;
	localparam CSR_ADDR_MVENDORID = 12'hf11;
	localparam CSR_ADDR_MARCHID = 12'hf12;
	localparam CSR_ADDR_MIMPID = 12'hf13;
	localparam CSR_ADDR_MHARTID = 12'hf14;
	localparam CSR_ADDR_UXCRYPTO = 12'h800;
	localparam CSR_ADDR_LKGCFG = 12'h801;
	parameter XC_CLASS_BASELINE = 1'b1;
	parameter XC_CLASS_RANDOMNESS = 1'b1 && XC_CLASS_BASELINE;
	parameter XC_CLASS_MEMORY = 1'b1 && XC_CLASS_BASELINE;
	parameter XC_CLASS_BIT = 1'b1 && XC_CLASS_BASELINE;
	parameter XC_CLASS_PACKED = 1'b1 && XC_CLASS_BASELINE;
	parameter XC_CLASS_MULTIARITH = 1'b1 && XC_CLASS_BASELINE;
	parameter XC_CLASS_AES = 1'b1 && XC_CLASS_BASELINE;
	parameter XC_CLASS_SHA2 = 1'b1 && XC_CLASS_BASELINE;
	parameter XC_CLASS_SHA3 = 1'b1 && XC_CLASS_BASELINE;
	parameter XC_CLASS_LEAK = 1'b1 && XC_CLASS_BASELINE;
	parameter BITMANIP_BASELINE = 1'b1;
	reg p_trap_int;
	always @(posedge g_clk) p_trap_int <= (g_resetn ? trap_int : 1'b0);
	wire int_pulse = !p_trap_int && trap_int;
	wire [1:0] reg_misa_mxl = 2'b01;
	wire [25:0] reg_misa_extensions = {2'b00, XC_CLASS_BASELINE, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, BITMANIP_BASELINE, 1'b0};
	wire [31:0] reg_misa = {reg_misa_mxl, 4'b0000, reg_misa_extensions};
	wire [31:0] reg_mvendorid = CSR_MVENDORID;
	wire [31:0] reg_marchid = CSR_MARCHID;
	wire [31:0] reg_mimpid = CSR_MIMPID;
	wire [31:0] reg_mhartid = CSR_MHARTID;
	wire [31:0] reg_medeleg = 32'b00000000000000000000000000000000;
	wire [31:0] reg_mideleg = 32'b00000000000000000000000000000000;
	wire [31:0] reg_mip = {20'b00000000000000000000, mip_meip, 3'b000, mip_mtip, 3'b000, mip_msip, 3'b000};
	wire wen_mie = (csr_en && csr_wr) && (csr_addr == CSR_ADDR_MIE);
	wire [31:0] reg_mie = {20'b00000000000000000000, mie_meie, 3'b000, mie_mtie, 3'b000, mie_msie, 3'b000};
	wire [31:0] n_reg_mie = (csr_wr_set ? reg_mie | csr_wdata : (csr_wr_clr ? reg_mie & ~csr_wdata : csr_wdata));
	always @(posedge g_clk)
		if (!g_resetn) begin
			mie_meie <= 1'b0;
			mie_mtie <= 1'b0;
			mie_msie <= 1'b0;
		end
		else if (wen_mie) begin
			mie_meie <= n_reg_mie[11];
			mie_mtie <= n_reg_mie[7];
			mie_msie <= n_reg_mie[3];
		end
	wire reg_mstatus_sd = 0;
	reg [7:0] reg_mstatus_wpri1;
	wire reg_mstatus_tsr = 0;
	wire reg_mstatus_tw = 0;
	wire reg_mstatus_tvm = 0;
	wire reg_mstatus_mxr = 0;
	wire reg_mstatus_sum = 0;
	wire reg_mstatus_mprv = 0;
	wire [1:0] reg_mstatus_xs = 0;
	wire [1:0] reg_mstatus_fs = 0;
	wire [1:0] reg_mstatus_mpp = 0;
	reg [1:0] reg_mstatus_wpri2;
	wire reg_mstatus_spp = 0;
	reg reg_mstatus_mpie;
	reg reg_mstatus_wpri3;
	wire reg_mstatus_spie = 0;
	wire reg_mstatus_upie = 0;
	reg reg_mstatus_mie;
	reg reg_mstatus_wpri4;
	wire reg_mstatus_sie = 0;
	wire reg_mstatus_uie = 0;
	assign mstatus_mie = reg_mstatus_mie;
	wire [31:0] reg_mstatus = {reg_mstatus_sd, reg_mstatus_wpri1, reg_mstatus_tsr, reg_mstatus_tw, reg_mstatus_tvm, reg_mstatus_mxr, reg_mstatus_sum, reg_mstatus_mprv, reg_mstatus_xs, reg_mstatus_fs, reg_mstatus_mpp, reg_mstatus_wpri2, reg_mstatus_spp, reg_mstatus_mpie, reg_mstatus_wpri3, reg_mstatus_spie, reg_mstatus_upie, reg_mstatus_mie, reg_mstatus_wpri4, reg_mstatus_sie, reg_mstatus_uie};
	wire wen_mstatus = csr_wr && (csr_addr == CSR_ADDR_MSTATUS);
	wire wen_mstatus_mie = ((wen_mstatus || trap_cpu) || int_pulse) || exec_mret;
	wire wen_mstatus_mpie = ((wen_mstatus || trap_cpu) || int_pulse) || exec_mret;
	wire n_mstatus_mie = (int_pulse ? 1'b0 : (trap_cpu ? 1'b0 : (exec_mret ? reg_mstatus_mpie : (csr_wr_set ? reg_mstatus_mie | csr_wdata[3] : (csr_wr_clr ? reg_mstatus_mie & ~csr_wdata[3] : csr_wdata[3])))));
	wire n_mstatus_mpie = (int_pulse ? reg_mstatus_mie : (trap_cpu ? reg_mstatus_mie : (exec_mret ? 0 : (csr_wr_set ? reg_mstatus_mie | csr_wdata[7] : (csr_wr_clr ? reg_mstatus_mie & ~csr_wdata[7] : csr_wdata[7])))));
	wire n_mstatus_wpri4 = csr_wdata[2:2];
	wire n_mstatus_wpri3 = csr_wdata[6:6];
	wire [1:0] n_mstatus_wpri2 = csr_wdata[10:9];
	wire [7:0] n_mstatus_wpri1 = csr_wdata[30:23];
	always @(posedge g_clk)
		if (!g_resetn)
			reg_mstatus_mie <= 0;
		else if (wen_mstatus_mie)
			reg_mstatus_mie <= n_mstatus_mie;
	always @(posedge g_clk)
		if (!g_resetn)
			reg_mstatus_mpie <= 0;
		else if (wen_mstatus_mpie)
			reg_mstatus_mpie <= n_mstatus_mpie;
	always @(posedge g_clk)
		if (!g_resetn) begin
			reg_mstatus_wpri1 <= 0;
			reg_mstatus_wpri2 <= 0;
			reg_mstatus_wpri3 <= 0;
			reg_mstatus_wpri4 <= 0;
		end
		else if (wen_mstatus) begin
			reg_mstatus_wpri1 <= n_mstatus_wpri1;
			reg_mstatus_wpri2 <= n_mstatus_wpri2;
			reg_mstatus_wpri3 <= n_mstatus_wpri3;
			reg_mstatus_wpri4 <= n_mstatus_wpri4;
		end
	reg [29:0] reg_mtvec_base;
	reg [1:0] reg_mtvec_mode;
	wire [31:0] reg_mtvec = {reg_mtvec_base, reg_mtvec_mode};
	assign csr_mtvec = {reg_mtvec_base, 2'b00};
	assign vector_intrs = reg_mtvec_mode[0];
	wire wen_mtvec = csr_wr && (csr_addr == CSR_ADDR_MTVEC);
	wire [29:0] n_mtvec_base = (csr_wr_set ? csr_mtvec[31:2] | csr_wdata[31:2] : (csr_wr_clr ? csr_mtvec[31:2] & ~csr_wdata[31:2] : csr_wdata[31:2]));
	wire [1:0] n_mtvec_mode = (csr_wr_set ? csr_mtvec[1:0] | csr_wdata[1:0] : (csr_wr_clr ? csr_mtvec[1:0] & ~csr_wdata[1:0] : csr_wdata[1:0]));
	wire mtvec_bad_write = wen_mtvec && (n_mtvec_mode[1] || (n_mtvec_mode[0] && |n_mtvec_base[4:0]));
	always @(posedge g_clk)
		if (!g_resetn) begin
			reg_mtvec_base <= CSR_MTVEC_RESET_VALUE[31:2];
			reg_mtvec_mode <= 2'b00;
		end
		else if (wen_mtvec && !mtvec_bad_write) begin
			reg_mtvec_base <= n_mtvec_base;
			reg_mtvec_mode <= n_mtvec_mode;
		end
	reg [31:0] reg_mscratch;
	wire [31:0] n_reg_mscratch = (csr_wr_set ? reg_mscratch | csr_wdata : (csr_wr_clr ? reg_mscratch & ~csr_wdata : csr_wdata));
	wire wen_mscratch = csr_wr && (csr_addr == CSR_ADDR_MSCRATCH);
	always @(posedge g_clk)
		if (!g_resetn)
			reg_mscratch <= 0;
		else if (wen_mscratch)
			reg_mscratch <= n_reg_mscratch;
	reg [31:0] reg_mtval;
	wire [31:0] n_reg_mtval = (trap_cpu ? trap_mtval : (csr_wr_set ? reg_mtval | csr_wdata : (csr_wr_clr ? reg_mtval & ~csr_wdata : csr_wdata)));
	wire wen_mtval = csr_wr && (csr_addr == CSR_ADDR_MTVAL);
	always @(posedge g_clk)
		if (!g_resetn)
			reg_mtval <= 0;
		else if (wen_mtval || trap_cpu)
			reg_mtval <= n_reg_mtval;
	reg [30:0] reg_mepc_mepc;
	wire reg_mepc_warl = 1'b0;
	wire [31:0] reg_mepc = {reg_mepc_mepc, reg_mepc_warl};
	assign csr_mepc = {reg_mepc_mepc, 1'b0};
	wire wen_mepc = ((csr_wr && (csr_addr == CSR_ADDR_MEPC)) || trap_cpu) || int_pulse;
	wire [30:0] n_mepc = (int_pulse || trap_cpu ? trap_pc[31:1] : (csr_wr_set ? reg_mepc_mepc | csr_wdata[31:1] : (csr_wr_clr ? reg_mepc_mepc & ~csr_wdata[31:1] : csr_wdata[31:1])));
	always @(posedge g_clk)
		if (!g_resetn)
			reg_mepc_mepc <= 0;
		else if (wen_mepc)
			reg_mepc_mepc <= n_mepc;
	reg reg_mcause_interrupt;
	reg [30:0] reg_mcause_cause;
	wire [31:0] reg_mcause = {reg_mcause_interrupt, reg_mcause_cause};
	wire wen_mcause = ((csr_wr && (csr_addr == CSR_ADDR_MCAUSE)) || trap_cpu) || int_pulse;
	wire [30:0] n_mcause_cause = (int_pulse || trap_cpu ? {25'b0000000000000000000000000, trap_cause} : (csr_wr_set ? reg_mcause_cause | csr_wdata[30:0] : (csr_wr_clr ? reg_mcause_cause & ~csr_wdata[30:0] : csr_wdata[30:0])));
	localparam mypackage_TRAP_BREAKPT = 6'd3;
	localparam mypackage_TRAP_ECALLM = 6'd11;
	localparam mypackage_TRAP_IACCESS = 6'b000001;
	localparam mypackage_TRAP_IALIGN = 6'b000000;
	localparam mypackage_TRAP_IOPCODE = 6'd2;
	localparam mypackage_TRAP_LDACCESS = 6'd5;
	localparam mypackage_TRAP_LDALIGN = 6'd4;
	localparam mypackage_TRAP_STACCESS = 6'd7;
	localparam mypackage_TRAP_STALIGN = 6'd6;
	wire wen_valid_mcause = (((((((((csr_wdata == {26'b00000000000000000000000000, mypackage_TRAP_IALIGN}) || (csr_wdata == {26'b00000000000000000000000000, mypackage_TRAP_IACCESS})) || (csr_wdata == {26'b00000000000000000000000000, mypackage_TRAP_IOPCODE})) || (csr_wdata == {26'b00000000000000000000000000, mypackage_TRAP_BREAKPT})) || (csr_wdata == {26'b00000000000000000000000000, mypackage_TRAP_LDALIGN})) || (csr_wdata == {26'b00000000000000000000000000, mypackage_TRAP_LDACCESS})) || (csr_wdata == {26'b00000000000000000000000000, mypackage_TRAP_STALIGN})) || (csr_wdata == {26'b00000000000000000000000000, mypackage_TRAP_STACCESS})) || (csr_wdata == {26'b00000000000000000000000000, mypackage_TRAP_ECALLM})) || (csr_addr != CSR_ADDR_MCAUSE);
	always @(posedge g_clk)
		if (!g_resetn) begin
			reg_mcause_cause <= 0;
			reg_mcause_interrupt <= 0;
		end
		else if (wen_mcause && wen_valid_mcause) begin
			reg_mcause_cause <= n_mcause_cause;
			reg_mcause_interrupt <= int_pulse;
		end
	reg mcountin_ir;
	reg mcountin_tm;
	reg mcountin_cy;
	assign inhibit_ir = mcountin_ir;
	assign inhibit_tm = mcountin_tm;
	assign inhibit_cy = mcountin_cy;
	wire wen_mcountin = csr_wr && (csr_addr == CSR_ADDR_MCOUNTIN);
	always @(posedge g_clk)
		if (!g_resetn) begin
			mcountin_ir <= 1'b0;
			mcountin_tm <= 1'b0;
			mcountin_cy <= 1'b0;
		end
		else if (wen_mcountin) begin
			mcountin_ir <= csr_wdata[2];
			mcountin_tm <= csr_wdata[1];
			mcountin_cy <= csr_wdata[0];
		end
	wire [31:0] reg_mcountin = {29'b00000000000000000000000000000, mcountin_ir, mcountin_tm, mcountin_cy};
	wire [11:0] uxcrypto_features = {XC_CLASS_LEAK, XC_CLASS_BIT, XC_CLASS_MEMORY, XC_CLASS_RANDOMNESS, XC_CLASS_PACKED, XC_CLASS_PACKED, XC_CLASS_PACKED, XC_CLASS_PACKED, XC_CLASS_MULTIARITH, XC_CLASS_SHA3, XC_CLASS_SHA2, XC_CLASS_AES};
	wire [31:0] reg_uxcrypto = {uxcrypto_b1, uxcrypto_b0, 3'b000, uxcrypto_features, uxcrypto_ct};
	wire wen_uxcrypto = csr_wr && (csr_addr == CSR_ADDR_UXCRYPTO);
	wire n_uxcrypto_ct = (csr_wr_set ? uxcrypto_ct | csr_wdata[0] : (csr_wr_clr ? uxcrypto_ct & ~csr_wdata[0] : csr_wdata[0]));
	wire [7:0] n_uxcrypto_b0 = (csr_wr_set ? uxcrypto_b0 | csr_wdata[23:16] : (csr_wr_clr ? uxcrypto_b0 & ~csr_wdata[23:16] : csr_wdata[23:16]));
	wire [7:0] n_uxcrypto_b1 = (csr_wr_set ? uxcrypto_b1 | csr_wdata[31:24] : (csr_wr_clr ? uxcrypto_b1 & ~csr_wdata[31:24] : csr_wdata[31:24]));
	always @(posedge g_clk)
		if (!g_resetn) begin
			uxcrypto_ct <= 0;
			uxcrypto_b0 <= 0;
			uxcrypto_b1 <= 0;
		end
		else if (wen_uxcrypto) begin
			uxcrypto_ct <= n_uxcrypto_ct;
			uxcrypto_b0 <= n_uxcrypto_b0;
			uxcrypto_b1 <= n_uxcrypto_b1;
		end
	reg [12:0] reg_lkgcfg;
	assign leak_lkgcfg = reg_lkgcfg;
	wire [12:0] n_reg_lkgcfg = (csr_wr_set ? reg_lkgcfg | csr_wdata[12:0] : (csr_wr_clr ? reg_lkgcfg & ~csr_wdata[12:0] : csr_wdata[12:0]));
	wire wen_lkgcfg = csr_wr && (csr_addr == CSR_ADDR_LKGCFG);
	always @(posedge g_clk)
		if (!g_resetn)
			reg_lkgcfg <= 13'b0000000000000;
		else if (wen_lkgcfg)
			reg_lkgcfg <= n_reg_lkgcfg;
	wire read_mstatus = csr_en && (csr_addr == CSR_ADDR_MSTATUS);
	wire read_misa = csr_en && (csr_addr == CSR_ADDR_MISA);
	wire read_medeleg = csr_en && (csr_addr == CSR_ADDR_MEDELEG);
	wire read_mideleg = csr_en && (csr_addr == CSR_ADDR_MIDELEG);
	wire read_mie = csr_en && (csr_addr == CSR_ADDR_MIE);
	wire read_mtvec = csr_en && (csr_addr == CSR_ADDR_MTVEC);
	wire read_mscratch = csr_en && (csr_addr == CSR_ADDR_MSCRATCH);
	wire read_mepc = csr_en && (csr_addr == CSR_ADDR_MEPC);
	wire read_mcause = csr_en && (csr_addr == CSR_ADDR_MCAUSE);
	wire read_mtval = csr_en && (csr_addr == CSR_ADDR_MTVAL);
	wire read_mip = csr_en && (csr_addr == CSR_ADDR_MIP);
	wire read_mvendorid = csr_en && (csr_addr == CSR_ADDR_MVENDORID);
	wire read_marchid = csr_en && (csr_addr == CSR_ADDR_MARCHID);
	wire read_mimpid = csr_en && (csr_addr == CSR_ADDR_MIMPID);
	wire read_mhartid = csr_en && (csr_addr == CSR_ADDR_MHARTID);
	wire read_cycle = csr_en && (csr_addr == CSR_ADDR_CYCLE);
	wire read_time = csr_en && (csr_addr == CSR_ADDR_TIME);
	wire read_instret = csr_en && (csr_addr == CSR_ADDR_INSTRET);
	wire read_cycleh = csr_en && (csr_addr == CSR_ADDR_CYCLEH);
	wire read_timeh = csr_en && (csr_addr == CSR_ADDR_TIMEH);
	wire read_instreth = csr_en && (csr_addr == CSR_ADDR_INSTRETH);
	wire read_mcycle = csr_en && (csr_addr == CSR_ADDR_MCYCLE);
	wire read_minstret = csr_en && (csr_addr == CSR_ADDR_MINSTRET);
	wire read_mcycleh = csr_en && (csr_addr == CSR_ADDR_MCYCLEH);
	wire read_minstreth = csr_en && (csr_addr == CSR_ADDR_MINSTRETH);
	wire read_mcountin = csr_en && (csr_addr == CSR_ADDR_MCOUNTIN);
	wire read_uxcrypto = csr_en && (csr_addr == CSR_ADDR_UXCRYPTO);
	wire read_lkgcfg = csr_en && (csr_addr == CSR_ADDR_LKGCFG);
	wire valid_addr = ((((((((((((((((((((((((((read_mstatus || read_misa) || read_medeleg) || read_mideleg) || read_mie) || read_mtvec) || read_mscratch) || read_mepc) || read_mcause) || read_mtval) || read_mip) || read_mvendorid) || read_marchid) || read_mimpid) || read_mhartid) || read_cycle) || read_time) || read_instret) || read_cycleh) || read_timeh) || read_instreth) || read_mcycle) || read_minstret) || read_mcycleh) || read_minstreth) || read_mcountin) || read_uxcrypto) || read_lkgcfg;
	wire invalid_addr = !valid_addr;
	assign csr_error = csr_en && ((csr_wr && invalid_addr) || mtvec_bad_write);
	assign csr_rdata = ((((((((((((((((((((((((((({32 {read_mstatus}} & reg_mstatus) | ({32 {read_misa}} & reg_misa)) | ({32 {read_medeleg}} & reg_medeleg)) | ({32 {read_mideleg}} & reg_mideleg)) | ({32 {read_mie}} & reg_mie)) | ({32 {read_mtvec}} & reg_mtvec)) | ({32 {read_mscratch}} & reg_mscratch)) | ({32 {read_mepc}} & reg_mepc)) | ({32 {read_mcause}} & reg_mcause)) | ({32 {read_mtval}} & reg_mtval)) | ({32 {read_mip}} & reg_mip)) | ({32 {read_mvendorid}} & reg_mvendorid)) | ({32 {read_marchid}} & reg_marchid)) | ({32 {read_mimpid}} & reg_mimpid)) | ({32 {read_mhartid}} & reg_mhartid)) | ({32 {read_cycle}} & ctr_cycle[31:0])) | ({32 {read_time}} & ctr_time[31:0])) | ({32 {read_instret}} & ctr_instret[31:0])) | ({32 {read_cycleh}} & ctr_cycle[63:32])) | ({32 {read_timeh}} & ctr_time[63:32])) | ({32 {read_instreth}} & ctr_instret[63:32])) | ({32 {read_mcycle}} & ctr_cycle[31:0])) | ({32 {read_minstret}} & ctr_instret[31:0])) | ({32 {read_mcycleh}} & ctr_cycle[63:32])) | ({32 {read_minstreth}} & ctr_instret[63:32])) | ({32 {read_mcountin}} & reg_mcountin)) | ({32 {read_uxcrypto}} & reg_uxcrypto)) | ({32 {read_lkgcfg}} & {19'b0000000000000000000, reg_lkgcfg});
endmodule
module frv_gprs (
	g_clk,
	g_resetn,
	rs1_addr,
	rs1_data,
	rs2_addr,
	rs2_data,
	rs3_addr,
	rs3_data,
	rd_wen,
	rd_wide,
	rd_addr,
	rd_wdata,
	rd_wdata_hi
);
	input wire g_clk;
	input wire g_resetn;
	input wire [4:0] rs1_addr;
	output wire [31:0] rs1_data;
	input wire [4:0] rs2_addr;
	output wire [31:0] rs2_data;
	input wire [4:0] rs3_addr;
	output wire [31:0] rs3_data;
	input wire rd_wen;
	input wire rd_wide;
	input wire [4:0] rd_addr;
	input wire [31:0] rd_wdata;
	input wire [31:0] rd_wdata_hi;
	parameter BRAM_REGFILE = 0;
	reg [31:0] gprs_even [15:0];
	reg [31:0] gprs_odd [15:0];
	wire [31:0] gprs [31:0];
	assign rs1_data = gprs[rs1_addr];
	assign rs2_data = gprs[rs2_addr];
	assign rs3_data = gprs[rs3_addr];
	wire rd_odd = rd_addr[0];
	wire rd_even = !rd_addr[0];
	wire [3:0] rd_top = rd_addr[4:1];
	wire rd_wen_even = rd_even && rd_wen;
	wire rd_wen_odd = (rd_odd || rd_wide) && rd_wen;
	wire [31:0] rd_wdata_odd = (rd_wide ? rd_wdata_hi : rd_wdata);
	genvar i;
	generate
		for (i = 0; i < 16; i = i + 1) begin : genblk1
			if (i == 0) begin : genblk1
				always @(*) gprs_even[i] = 0;
				assign gprs[(2 * i) + 0] = 32'b00000000000000000000000000000000;
				assign gprs[(2 * i) + 1] = gprs_odd[i];
				always @(posedge g_clk)
					if (rd_wen_odd && (rd_top == i))
						gprs_odd[i] <= rd_wdata_odd;
			end
			else begin : genblk1
				assign gprs[(2 * i) + 0] = gprs_even[i];
				assign gprs[(2 * i) + 1] = gprs_odd[i];
				always @(posedge g_clk)
					if (rd_wen_even && (rd_top == i))
						gprs_even[i] <= rd_wdata;
				always @(posedge g_clk)
					if (rd_wen_odd && (rd_top == i))
						gprs_odd[i] <= rd_wdata_odd;
			end
		end
	endgenerate
endmodule
module frv_interrupt (
	g_clk,
	g_resetn,
	mstatus_mie,
	mie_meie,
	mie_mtie,
	mie_msie,
	nmi_pending,
	ex_pending,
	ex_cause,
	ti_pending,
	sw_pending,
	mip_meip,
	mip_mtip,
	mip_msip,
	int_trap_req,
	int_trap_cause,
	int_trap_ack
);
	input g_clk;
	input g_resetn;
	input mstatus_mie;
	input mie_meie;
	input mie_mtie;
	input mie_msie;
	input wire nmi_pending;
	input wire ex_pending;
	input wire [3:0] ex_cause;
	input wire ti_pending;
	input wire sw_pending;
	output reg mip_meip;
	output reg mip_mtip;
	output reg mip_msip;
	output wire int_trap_req;
	output reg [5:0] int_trap_cause;
	input wire int_trap_ack;
	reg mip_nmi;
	wire raise_mei = (mstatus_mie && mie_meie) && mip_meip;
	wire raise_mti = (mstatus_mie && mie_mtie) && mip_mtip;
	wire raise_msi = (mstatus_mie && mie_msie) && mip_msip;
	wire raise_nmi = mstatus_mie && mip_nmi;
	assign int_trap_req = ((raise_mei || raise_mti) || raise_msi) || raise_nmi;
	wire use_extern_cause = |ex_cause;
	localparam mypackage_TRAP_INT_MEI = 6'd11;
	localparam mypackage_TRAP_INT_NMI = 6'd16;
	wire [5:0] extern_cause = (raise_nmi ? mypackage_TRAP_INT_NMI : (use_extern_cause ? {2'b01, ex_cause} : mypackage_TRAP_INT_MEI));
	localparam mypackage_TRAP_INT_MSI = 6'd3;
	localparam mypackage_TRAP_INT_MTI = 6'd7;
	wire [5:0] n_int_trap_cause = (nmi_pending ? extern_cause : (ex_pending ? extern_cause : (ti_pending ? mypackage_TRAP_INT_MTI : (sw_pending ? mypackage_TRAP_INT_MSI : 0))));
	always @(posedge g_clk)
		if (!g_resetn) begin
			mip_meip <= 1'b0;
			mip_mtip <= 1'b0;
			mip_msip <= 1'b0;
			mip_nmi <= 1'b0;
			int_trap_cause <= 6'b000000;
		end
		else begin
			mip_meip <= ex_pending;
			mip_mtip <= ti_pending;
			mip_msip <= sw_pending;
			mip_nmi <= nmi_pending;
			int_trap_cause <= n_int_trap_cause;
		end
endmodule
module frv_leak (
	g_clk,
	g_resetn,
	leak_prng,
	leak_fence
);
	input wire g_clk;
	input wire g_resetn;
	localparam mypackage_XLEN = 32;
	localparam mypackage_XL = 31;
	output reg [mypackage_XL:0] leak_prng;
	input wire leak_fence;
	parameter XC_CLASS_LEAK = 1'b1;
	parameter XC_CLASS_LEAK_STRONG = 1'b1;
	parameter ALCFG_RESET_VALUE = 13'b0000000000000;
	parameter PRNG_RESET_VALUE = 32'habcdef37;
	generate
		if (XC_CLASS_LEAK) begin : genblk1
			if (XC_CLASS_LEAK_STRONG) begin : genblk1
				wire n_prng_lsb = ((leak_prng[31] ~^ leak_prng[21]) ~^ leak_prng[1]) ~^ leak_prng[0];
				wire [mypackage_XL:0] n_prng = {leak_prng[30:0], n_prng_lsb};
				always @(posedge g_clk)
					if (!g_resetn)
						leak_prng <= PRNG_RESET_VALUE;
					else if (leak_fence)
						leak_prng <= n_prng;
			end
			else begin : genblk1
				always @(*) leak_prng = 0;
			end
		end
		else begin : genblk1
			always @(*) leak_prng = {mypackage_XLEN {1'b0}};
		end
	endgenerate
endmodule
module frv_lsu (
	g_clk,
	g_resetn,
	lsu_valid,
	lsu_a_error,
	lsu_ready,
	lsu_mmio,
	pipe_prog,
	lsu_addr,
	lsu_wdata,
	lsu_load,
	lsu_store,
	lsu_byte,
	lsu_half,
	lsu_word,
	lsu_signed,
	hold_lsu_req,
	mmio_en,
	mmio_wen,
	mmio_addr,
	mmio_wdata,
	dmem_req,
	dmem_wen,
	dmem_strb,
	dmem_wdata,
	dmem_addr,
	dmem_gnt
);
	input wire g_clk;
	input wire g_resetn;
	input wire lsu_valid;
	output wire lsu_a_error;
	output wire lsu_ready;
	output wire lsu_mmio;
	input wire pipe_prog;
	localparam mypackage_XLEN = 32;
	localparam mypackage_XL = 31;
	input wire [mypackage_XL:0] lsu_addr;
	input wire [mypackage_XL:0] lsu_wdata;
	input wire lsu_load;
	input wire lsu_store;
	input wire lsu_byte;
	input wire lsu_half;
	input wire lsu_word;
	input wire lsu_signed;
	input wire hold_lsu_req;
	output wire mmio_en;
	output wire mmio_wen;
	output wire [31:0] mmio_addr;
	output wire [31:0] mmio_wdata;
	output wire dmem_req;
	output wire dmem_wen;
	output wire [3:0] dmem_strb;
	output wire [mypackage_XL:0] dmem_wdata;
	output wire [mypackage_XL:0] dmem_addr;
	input wire dmem_gnt;
	parameter MMIO_BASE_ADDR = 32'h00001000;
	parameter MMIO_BASE_MASK = 32'hfffff000;
	assign lsu_mmio = lsu_valid && ((lsu_addr & MMIO_BASE_MASK) == MMIO_BASE_ADDR);
	reg mmio_done;
	wire n_mmio_done = (mmio_done || mmio_en) && !pipe_prog;
	always @(posedge g_clk)
		if (!g_resetn)
			mmio_done <= 1'b0;
		else
			mmio_done <= n_mmio_done;
	assign mmio_en = (lsu_mmio && !mmio_done) && !hold_lsu_req;
	assign mmio_addr = lsu_addr;
	assign mmio_wen = lsu_store;
	assign mmio_wdata = lsu_wdata;
	wire dmem_txn_done = ((!lsu_mmio && dmem_req) && dmem_gnt) || (lsu_mmio && mmio_en);
	reg lsu_finished;
	wire n_lsu_finished = (lsu_finished || ((lsu_valid && dmem_txn_done) || lsu_a_error)) && !pipe_prog;
	assign lsu_ready = dmem_txn_done || lsu_finished;
	always @(posedge g_clk)
		if (!g_resetn)
			lsu_finished <= 1'b0;
		else
			lsu_finished <= n_lsu_finished;
	assign lsu_a_error = (lsu_half && lsu_addr[0]) || (lsu_word && |lsu_addr[1:0]);
	assign dmem_req = (((lsu_valid && !lsu_finished) && !lsu_a_error) && !hold_lsu_req) && !lsu_mmio;
	assign dmem_wen = lsu_store;
	assign dmem_addr = lsu_addr & 32'hfffffffc;
	assign dmem_wdata = (((((({32 {lsu_byte && (lsu_addr[1:0] == 2'b00)}} & {24'b000000000000000000000000, lsu_wdata[7:0]}) | ({32 {lsu_byte && (lsu_addr[1:0] == 2'b01)}} & {16'b0000000000000000, lsu_wdata[7:0], 8'b00000000})) | ({32 {lsu_byte && (lsu_addr[1:0] == 2'b10)}} & {8'b00000000, lsu_wdata[7:0], 16'b0000000000000000})) | ({32 {lsu_byte && (lsu_addr[1:0] == 2'b11)}} & {lsu_wdata[7:0], 24'b000000000000000000000000})) | ({32 {lsu_half && (lsu_addr[1] == 1'b1)}} & {lsu_wdata[15:0], 16'b0000000000000000})) | ({32 {lsu_half && (lsu_addr[1] == 1'b0)}} & {16'b0000000000000000, lsu_wdata[15:0]})) | ({32 {lsu_word}} & {lsu_wdata});
	assign dmem_strb[0] = ((lsu_byte && (lsu_addr[1:0] == 2'b00)) || (lsu_half && !lsu_addr[1])) || lsu_word;
	assign dmem_strb[1] = ((lsu_byte && (lsu_addr[1:0] == 2'b01)) || (lsu_half && !lsu_addr[1])) || lsu_word;
	assign dmem_strb[2] = ((lsu_byte && (lsu_addr[1:0] == 2'b10)) || (lsu_half && lsu_addr[1])) || lsu_word;
	assign dmem_strb[3] = ((lsu_byte && (lsu_addr[1:0] == 2'b11)) || (lsu_half && lsu_addr[1])) || lsu_word;
endmodule
module frv_pipeline_decode (
	g_clk,
	g_resetn,
	s1_valid,
	s1_busy,
	s1_data,
	s1_error,
	s1_flush,
	s1_bubble,
	s1_rs1_addr,
	s1_rs2_addr,
	s1_rs3_addr,
	s1_rs1_rdata,
	s1_rs2_rdata,
	s1_rs3_rdata,
	leak_prng,
	leak_lkgcfg,
	s1_leak_fence,
	cf_req,
	cf_target,
	cf_ack,
	s2_valid,
	s2_busy,
	s2_rd,
	s2_opr_a,
	s2_opr_b,
	s2_opr_c,
	s2_uop,
	s2_fu,
	s2_pw,
	s2_trap,
	s2_size,
	s2_instr
);
	input wire g_clk;
	input wire g_resetn;
	input wire s1_valid;
	output wire s1_busy;
	input wire [31:0] s1_data;
	input wire s1_error;
	input wire s1_flush;
	input wire s1_bubble;
	output wire [4:0] s1_rs1_addr;
	output wire [4:0] s1_rs2_addr;
	output wire [4:0] s1_rs3_addr;
	localparam mypackage_XLEN = 32;
	localparam mypackage_XL = 31;
	input wire [mypackage_XL:0] s1_rs1_rdata;
	input wire [mypackage_XL:0] s1_rs2_rdata;
	input wire [mypackage_XL:0] s1_rs3_rdata;
	output wire [mypackage_XL:0] leak_prng;
	input wire [12:0] leak_lkgcfg;
	output wire s1_leak_fence;
	input wire cf_req;
	input wire [mypackage_XL:0] cf_target;
	input wire cf_ack;
	output wire s2_valid;
	input wire s2_busy;
	output wire [4:0] s2_rd;
	output wire [mypackage_XL:0] s2_opr_a;
	output wire [mypackage_XL:0] s2_opr_b;
	output wire [mypackage_XL:0] s2_opr_c;
	localparam mypackage_OP = 4;
	output wire [mypackage_OP:0] s2_uop;
	localparam mypackage_FU = 7;
	output wire [mypackage_FU:0] s2_fu;
	localparam mypackage_PW = 2;
	output wire [mypackage_PW:0] s2_pw;
	output wire s2_trap;
	output wire [1:0] s2_size;
	output wire [31:0] s2_instr;
	parameter FRV_PC_RESET_VALUE = 32'h80000000;
	parameter TRACE_INSTR_WORD = 1'b1;
	parameter XC_CLASS_BASELINE = 1'b1;
	parameter XC_CLASS_RANDOMNESS = 1'b1 && XC_CLASS_BASELINE;
	parameter XC_CLASS_MEMORY = 1'b1 && XC_CLASS_BASELINE;
	parameter XC_CLASS_BIT = 1'b1 && XC_CLASS_BASELINE;
	parameter XC_CLASS_PACKED = 1'b1 && XC_CLASS_BASELINE;
	parameter XC_CLASS_MULTIARITH = 1'b1 && XC_CLASS_BASELINE;
	parameter XC_CLASS_AES = 1'b1 && XC_CLASS_BASELINE;
	parameter XC_CLASS_SHA2 = 1'b1 && XC_CLASS_BASELINE;
	parameter XC_CLASS_SHA3 = 1'b1 && XC_CLASS_BASELINE;
	parameter XC_CLASS_LEAK = 1'b1 && XC_CLASS_BASELINE;
	parameter XC_CLASS_LEAK_STRONG = 1'b1 && XC_CLASS_LEAK;
	parameter XC_CLASS_LEAK_BUBBLE = 1'b1 && XC_CLASS_LEAK;
	parameter BITMANIP_BASELINE = 1'b1;
	wire p_s2_busy;
	wire leak_stall;
	wire pipe_progress = s1_valid && !s1_busy;
	assign s1_busy = (p_s2_busy || s1_bubble) || leak_stall;
	wire n_s2_valid = s1_valid || s1_bubble;
	wire [4:0] n_s2_rd;
	wire [mypackage_XL:0] n_s2_opr_a;
	wire [mypackage_XL:0] n_s2_opr_b;
	wire [mypackage_XL:0] n_s2_opr_c;
	wire [mypackage_XL:0] n_s2_imm;
	wire [mypackage_XL:0] n_s2_pc_imm;
	wire [mypackage_OP:0] n_s2_uop;
	wire [mypackage_FU:0] n_s2_fu;
	wire [mypackage_PW:0] n_s2_pw;
	wire n_s2_trap;
	wire [1:0] n_s2_size;
	wire [31:0] n_s2_instr;
	wire [8:0] n_s2_opr_src;
	wire [mypackage_XL:0] d_data = s1_data;
	wire dec_lui = (d_data[6:2] == 5'h0d) && (d_data[1:0] == 2'd3);
	wire dec_auipc = (d_data[6:2] == 5'h05) && (d_data[1:0] == 2'd3);
	wire dec_jal = (d_data[6:2] == 5'h1b) && (d_data[1:0] == 2'd3);
	wire dec_jalr = ((d_data[14:12] == 3'd0) && (d_data[6:2] == 5'h19)) && (d_data[1:0] == 2'd3);
	wire dec_beq = ((d_data[14:12] == 3'd0) && (d_data[6:2] == 5'h18)) && (d_data[1:0] == 2'd3);
	wire dec_bne = ((d_data[14:12] == 3'd1) && (d_data[6:2] == 5'h18)) && (d_data[1:0] == 2'd3);
	wire dec_blt = ((d_data[14:12] == 3'd4) && (d_data[6:2] == 5'h18)) && (d_data[1:0] == 2'd3);
	wire dec_bge = ((d_data[14:12] == 3'd5) && (d_data[6:2] == 5'h18)) && (d_data[1:0] == 2'd3);
	wire dec_bltu = ((d_data[14:12] == 3'd6) && (d_data[6:2] == 5'h18)) && (d_data[1:0] == 2'd3);
	wire dec_bgeu = ((d_data[14:12] == 3'd7) && (d_data[6:2] == 5'h18)) && (d_data[1:0] == 2'd3);
	wire dec_lb = ((d_data[14:12] == 3'd0) && (d_data[6:2] == 5'h00)) && (d_data[1:0] == 2'd3);
	wire dec_lh = ((d_data[14:12] == 3'd1) && (d_data[6:2] == 5'h00)) && (d_data[1:0] == 2'd3);
	wire dec_lw = ((d_data[14:12] == 3'd2) && (d_data[6:2] == 5'h00)) && (d_data[1:0] == 2'd3);
	wire dec_lbu = ((d_data[14:12] == 3'd4) && (d_data[6:2] == 5'h00)) && (d_data[1:0] == 2'd3);
	wire dec_lhu = ((d_data[14:12] == 3'd5) && (d_data[6:2] == 5'h00)) && (d_data[1:0] == 2'd3);
	wire dec_sb = ((d_data[14:12] == 3'd0) && (d_data[6:2] == 5'h08)) && (d_data[1:0] == 2'd3);
	wire dec_sh = ((d_data[14:12] == 3'd1) && (d_data[6:2] == 5'h08)) && (d_data[1:0] == 2'd3);
	wire dec_sw = ((d_data[14:12] == 3'd2) && (d_data[6:2] == 5'h08)) && (d_data[1:0] == 2'd3);
	wire dec_addi = ((d_data[14:12] == 3'd0) && (d_data[6:2] == 5'h04)) && (d_data[1:0] == 2'd3);
	wire dec_slti = ((d_data[14:12] == 3'd2) && (d_data[6:2] == 5'h04)) && (d_data[1:0] == 2'd3);
	wire dec_sltiu = ((d_data[14:12] == 3'd3) && (d_data[6:2] == 5'h04)) && (d_data[1:0] == 2'd3);
	wire dec_xori = ((d_data[14:12] == 3'd4) && (d_data[6:2] == 5'h04)) && (d_data[1:0] == 2'd3);
	wire dec_ori = ((d_data[14:12] == 3'd6) && (d_data[6:2] == 5'h04)) && (d_data[1:0] == 2'd3);
	wire dec_andi = ((d_data[14:12] == 3'd7) && (d_data[6:2] == 5'h04)) && (d_data[1:0] == 2'd3);
	wire dec_slli = (((d_data[31:25] == 7'd0) && (d_data[14:12] == 3'd1)) && (d_data[6:2] == 5'h04)) && (d_data[1:0] == 2'd3);
	wire dec_srli = (((d_data[31:25] == 7'd0) && (d_data[14:12] == 3'd5)) && (d_data[6:2] == 5'h04)) && (d_data[1:0] == 2'd3);
	wire dec_srai = (((d_data[31:25] == 7'd32) && (d_data[14:12] == 3'd5)) && (d_data[6:2] == 5'h04)) && (d_data[1:0] == 2'd3);
	wire dec_add = (((d_data[31:25] == 7'd0) && (d_data[14:12] == 3'd0)) && (d_data[6:2] == 5'h0c)) && (d_data[1:0] == 2'd3);
	wire dec_sub = (((d_data[31:25] == 7'd32) && (d_data[14:12] == 3'd0)) && (d_data[6:2] == 5'h0c)) && (d_data[1:0] == 2'd3);
	wire dec_sll = (((d_data[31:25] == 7'd0) && (d_data[14:12] == 3'd1)) && (d_data[6:2] == 5'h0c)) && (d_data[1:0] == 2'd3);
	wire dec_slt = (((d_data[31:25] == 7'd0) && (d_data[14:12] == 3'd2)) && (d_data[6:2] == 5'h0c)) && (d_data[1:0] == 2'd3);
	wire dec_sltu = (((d_data[31:25] == 7'd0) && (d_data[14:12] == 3'd3)) && (d_data[6:2] == 5'h0c)) && (d_data[1:0] == 2'd3);
	wire dec_xor = (((d_data[31:25] == 7'd0) && (d_data[14:12] == 3'd4)) && (d_data[6:2] == 5'h0c)) && (d_data[1:0] == 2'd3);
	wire dec_srl = (((d_data[31:25] == 7'd0) && (d_data[14:12] == 3'd5)) && (d_data[6:2] == 5'h0c)) && (d_data[1:0] == 2'd3);
	wire dec_sra = (((d_data[31:25] == 7'd32) && (d_data[14:12] == 3'd5)) && (d_data[6:2] == 5'h0c)) && (d_data[1:0] == 2'd3);
	wire dec_or = (((d_data[31:25] == 7'd0) && (d_data[14:12] == 3'd6)) && (d_data[6:2] == 5'h0c)) && (d_data[1:0] == 2'd3);
	wire dec_and = (((d_data[31:25] == 7'd0) && (d_data[14:12] == 3'd7)) && (d_data[6:2] == 5'h0c)) && (d_data[1:0] == 2'd3);
	wire dec_fence = ((d_data[14:12] == 3'd0) && (d_data[6:2] == 5'h03)) && (d_data[1:0] == 2'd3);
	wire dec_fence_i = ((d_data[14:12] == 3'd1) && (d_data[6:2] == 5'h03)) && (d_data[1:0] == 2'd3);
	wire dec_mul = (((d_data[31:25] == 7'd1) && (d_data[14:12] == 3'd0)) && (d_data[6:2] == 5'h0c)) && (d_data[1:0] == 2'd3);
	wire dec_mulh = (((d_data[31:25] == 7'd1) && (d_data[14:12] == 3'd1)) && (d_data[6:2] == 5'h0c)) && (d_data[1:0] == 2'd3);
	wire dec_mulhsu = (((d_data[31:25] == 7'd1) && (d_data[14:12] == 3'd2)) && (d_data[6:2] == 5'h0c)) && (d_data[1:0] == 2'd3);
	wire dec_mulhu = (((d_data[31:25] == 7'd1) && (d_data[14:12] == 3'd3)) && (d_data[6:2] == 5'h0c)) && (d_data[1:0] == 2'd3);
	wire dec_div = (((d_data[31:25] == 7'd1) && (d_data[14:12] == 3'd4)) && (d_data[6:2] == 5'h0c)) && (d_data[1:0] == 2'd3);
	wire dec_divu = (((d_data[31:25] == 7'd1) && (d_data[14:12] == 3'd5)) && (d_data[6:2] == 5'h0c)) && (d_data[1:0] == 2'd3);
	wire dec_rem = (((d_data[31:25] == 7'd1) && (d_data[14:12] == 3'd6)) && (d_data[6:2] == 5'h0c)) && (d_data[1:0] == 2'd3);
	wire dec_remu = (((d_data[31:25] == 7'd1) && (d_data[14:12] == 3'd7)) && (d_data[6:2] == 5'h0c)) && (d_data[1:0] == 2'd3);
	wire dec_ecall = (((((d_data[11:7] == 5'd0) && (d_data[19:15] == 5'd0)) && (d_data[31:20] == 12'h000)) && (d_data[14:12] == 3'd0)) && (d_data[6:2] == 5'h1c)) && (d_data[1:0] == 2'd3);
	wire dec_ebreak = (((((d_data[11:7] == 5'd0) && (d_data[19:15] == 5'd0)) && (d_data[31:20] == 12'h001)) && (d_data[14:12] == 3'd0)) && (d_data[6:2] == 5'h1c)) && (d_data[1:0] == 2'd3);
	wire dec_mret = (((((d_data[11:7] == 5'd0) && (d_data[19:15] == 5'd0)) && (d_data[31:20] == 12'h302)) && (d_data[14:12] == 3'd0)) && (d_data[6:2] == 5'h1c)) && (d_data[1:0] == 2'd3);
	wire dec_wfi = (((((d_data[11:7] == 5'd0) && (d_data[19:15] == 5'd0)) && (d_data[31:20] == 12'h105)) && (d_data[14:12] == 3'd0)) && (d_data[6:2] == 5'h1c)) && (d_data[1:0] == 2'd3);
	wire dec_csrrw = ((d_data[14:12] == 3'd1) && (d_data[6:2] == 5'h1c)) && (d_data[1:0] == 2'd3);
	wire dec_csrrs = ((d_data[14:12] == 3'd2) && (d_data[6:2] == 5'h1c)) && (d_data[1:0] == 2'd3);
	wire dec_csrrc = ((d_data[14:12] == 3'd3) && (d_data[6:2] == 5'h1c)) && (d_data[1:0] == 2'd3);
	wire dec_csrrwi = ((d_data[14:12] == 3'd5) && (d_data[6:2] == 5'h1c)) && (d_data[1:0] == 2'd3);
	wire dec_csrrsi = ((d_data[14:12] == 3'd6) && (d_data[6:2] == 5'h1c)) && (d_data[1:0] == 2'd3);
	wire dec_csrrci = ((d_data[14:12] == 3'd7) && (d_data[6:2] == 5'h1c)) && (d_data[1:0] == 2'd3);
	wire dec_c_addi4spn = ((d_data[1:0] == 2'd0) && (d_data[15:13] == 3'd0)) && (d_data[12:5] != 0);
	wire dec_c_lw = (d_data[1:0] == 2'd0) && (d_data[15:13] == 3'd2);
	wire dec_c_sw = (d_data[1:0] == 2'd0) && (d_data[15:13] == 3'd6);
	wire dec_c_nop = ((((d_data[1:0] == 2'd1) && (d_data[15:13] == 3'd0)) && (d_data[12:12] == 1'd0)) && (d_data[11:7] == 5'd0)) && (d_data[6:2] == 5'd0);
	wire dec_c_addi = (d_data[1:0] == 2'd1) && (d_data[15:13] == 3'd0);
	wire dec_c_jal = (d_data[1:0] == 2'd1) && (d_data[15:13] == 3'd1);
	wire dec_c_li = (d_data[1:0] == 2'd1) && (d_data[15:13] == 3'd2);
	wire dec_c_addi16sp = ((d_data[1:0] == 2'd1) && (d_data[15:13] == 3'd3)) && (d_data[11:7] == 5'd2);
	wire dec_c_lui = (((d_data[1:0] == 2'd1) && (d_data[15:13] == 3'd3)) && (d_data[11:7] != 5'd2)) && ({d_data[12], d_data[6:2]} != 0);
	wire dec_c_srli = (((d_data[1:0] == 2'd1) && (d_data[15:13] == 3'd4)) && (d_data[11:10] == 2'd0)) && (d_data[12] == 1'b0);
	wire dec_c_srai = (((d_data[1:0] == 2'd1) && (d_data[15:13] == 3'd4)) && (d_data[11:10] == 2'd1)) && (d_data[12] == 1'b0);
	wire dec_c_andi = ((d_data[1:0] == 2'd1) && (d_data[15:13] == 3'd4)) && (d_data[11:10] == 2'd2);
	wire dec_c_sub = ((((d_data[1:0] == 2'd1) && (d_data[15:13] == 3'd4)) && (d_data[12:12] == 1'd0)) && (d_data[11:10] == 2'd3)) && (d_data[6:5] == 2'd0);
	wire dec_c_xor = ((((d_data[1:0] == 2'd1) && (d_data[15:13] == 3'd4)) && (d_data[12:12] == 1'd0)) && (d_data[11:10] == 2'd3)) && (d_data[6:5] == 2'd1);
	wire dec_c_or = ((((d_data[1:0] == 2'd1) && (d_data[15:13] == 3'd4)) && (d_data[12:12] == 1'd0)) && (d_data[11:10] == 2'd3)) && (d_data[6:5] == 2'd2);
	wire dec_c_and = ((((d_data[1:0] == 2'd1) && (d_data[15:13] == 3'd4)) && (d_data[12:12] == 1'd0)) && (d_data[11:10] == 2'd3)) && (d_data[6:5] == 2'd3);
	wire dec_c_j = (d_data[1:0] == 2'd1) && (d_data[15:13] == 3'd5);
	wire dec_c_beqz = (d_data[1:0] == 2'd1) && (d_data[15:13] == 3'd6);
	wire dec_c_bnez = (d_data[1:0] == 2'd1) && (d_data[15:13] == 3'd7);
	wire dec_c_slli = ((d_data[1:0] == 2'd2) && (d_data[15:13] == 3'd0)) && (d_data[12] == 0);
	wire dec_c_lwsp = ((d_data[1:0] == 2'd2) && (d_data[15:13] == 3'd2)) && (d_data[11:7] != 0);
	wire dec_c_jr = ((((d_data[1:0] == 2'd2) && (d_data[15:13] == 3'd4)) && (d_data[12:12] == 1'd0)) && (d_data[6:2] == 5'd0)) && (d_data[11:7] != 0);
	wire dec_c_mv = (((d_data[1:0] == 2'd2) && (d_data[15:13] == 3'd4)) && (d_data[12:12] == 1'd0)) && (d_data[6:2] != 0);
	wire dec_c_ebreak = ((((d_data[1:0] == 2'd2) && (d_data[15:13] == 3'd4)) && (d_data[12:12] == 1'd1)) && (d_data[11:7] == 5'd0)) && (d_data[6:2] == 5'd0);
	wire dec_c_jalr = ((((d_data[1:0] == 2'd2) && (d_data[15:13] == 3'd4)) && (d_data[12:12] == 1'd1)) && (d_data[6:2] == 5'd0)) && (d_data[11:7] != 0);
	wire dec_c_add = (((d_data[1:0] == 2'd2) && (d_data[15:13] == 3'd4)) && (d_data[12:12] == 1'd1)) && (d_data[6:2] != 5'd0);
	wire dec_c_swsp = (d_data[1:0] == 2'd2) && (d_data[15:13] == 3'd6);
	wire dec_xc_ldr_b = XC_CLASS_BASELINE && ((d_data & 32'hfe00707f) == 32'h00007003);
	wire dec_xc_ldr_h = XC_CLASS_BASELINE && ((d_data & 32'hfe00707f) == 32'h02007003);
	wire dec_xc_ldr_w = XC_CLASS_BASELINE && ((d_data & 32'hfe00707f) == 32'h04007003);
	wire dec_xc_ldr_bu = XC_CLASS_BASELINE && ((d_data & 32'hfe00707f) == 32'h08007003);
	wire dec_xc_ldr_hu = XC_CLASS_BASELINE && ((d_data & 32'hfe00707f) == 32'h0a007003);
	wire dec_xc_str_b = XC_CLASS_BASELINE && ((d_data & 32'h06007fff) == 32'h00004023);
	wire dec_xc_str_h = XC_CLASS_BASELINE && ((d_data & 32'h06007fff) == 32'h000040a3);
	wire dec_xc_str_w = XC_CLASS_BASELINE && ((d_data & 32'h06007fff) == 32'h00004123);
	wire dec_xc_mmul_3 = XC_CLASS_MULTIARITH && ((d_data & 32'h060070ff) == 32'h04004023);
	wire dec_xc_macc_1 = XC_CLASS_MULTIARITH && ((d_data & 32'h060070ff) == 32'h040040a3);
	wire dec_xc_madd_3 = XC_CLASS_MULTIARITH && ((d_data & 32'h060070ff) == 32'h06004023);
	wire dec_xc_msub_3 = XC_CLASS_MULTIARITH && ((d_data & 32'h060070ff) == 32'h060050a3);
	wire dec_xc_mror = XC_CLASS_MULTIARITH && ((d_data & 32'h060070ff) == 32'h00005023);
	wire dec_xc_lkgfence = XC_CLASS_LEAK && ((d_data & 32'hffffffff) == 32'h00308073);
	wire dec_xc_rngtest = XC_CLASS_RANDOMNESS && ((d_data & 32'hfffff07f) == 32'h00300073);
	wire dec_xc_rngsamp = XC_CLASS_RANDOMNESS && ((d_data & 32'hfffff07f) == 32'h00500073);
	wire dec_xc_rngseed = XC_CLASS_RANDOMNESS && ((d_data & 32'hfff07fff) == 32'h00700073);
	wire dec_xc_lut = XC_CLASS_BIT && ((d_data & 32'hfe00707f) == 32'h62006033);
	wire dec_xc_bop = XC_CLASS_BIT && ((d_data & 32'h7e00707f) == 32'h64006033);
	wire dec_xc_padd = XC_CLASS_PACKED && ((d_data & 32'h3e00707f) == 32'h02000073);
	wire dec_xc_psub = XC_CLASS_PACKED && ((d_data & 32'h3e00707f) == 32'h04000073);
	wire dec_xc_pror = XC_CLASS_PACKED && ((d_data & 32'h3e00707f) == 32'h06000073);
	wire dec_xc_psll = XC_CLASS_PACKED && ((d_data & 32'h3e00707f) == 32'h08000073);
	wire dec_xc_psrl = XC_CLASS_PACKED && ((d_data & 32'h3e00707f) == 32'h0a000073);
	wire dec_xc_pror_i = XC_CLASS_PACKED && ((d_data & 32'h3c00707f) == 32'h30007003);
	wire dec_xc_psll_i = XC_CLASS_PACKED && ((d_data & 32'h3c00707f) == 32'h2c007003);
	wire dec_xc_psrl_i = XC_CLASS_PACKED && ((d_data & 32'h3c00707f) == 32'h28007003);
	wire dec_xc_pmul_l = XC_CLASS_PACKED && ((d_data & 32'h3e00707f) == 32'h0c000073);
	wire dec_xc_pmul_h = XC_CLASS_PACKED && ((d_data & 32'h3e00707f) == 32'h0e000073);
	wire dec_xc_pclmul_l = XC_CLASS_PACKED && ((d_data & 32'h3e00707f) == 32'h10000033);
	wire dec_xc_pclmul_h = XC_CLASS_PACKED && ((d_data & 32'h3e00707f) == 32'h12000033);
	wire dec_xc_scatter_b = XC_CLASS_MEMORY && ((d_data & 32'h06007fff) == 32'h00004223);
	wire dec_xc_scatter_h = XC_CLASS_MEMORY && ((d_data & 32'h06007fff) == 32'h000042a3);
	wire dec_xc_gather_b = XC_CLASS_MEMORY && ((d_data & 32'hfe00707f) == 32'h3c001013);
	wire dec_xc_gather_h = XC_CLASS_MEMORY && ((d_data & 32'hfe00707f) == 32'h3e001013);
	wire dec_xc_aessub_enc = XC_CLASS_AES && ((d_data & 32'hfe00707f) == 32'h1a007003);
	wire dec_xc_aessub_encrot = XC_CLASS_AES && ((d_data & 32'hfe00707f) == 32'h1c007003);
	wire dec_xc_aessub_dec = XC_CLASS_AES && ((d_data & 32'hfe00707f) == 32'h1e007003);
	wire dec_xc_aessub_decrot = XC_CLASS_AES && ((d_data & 32'hfe00707f) == 32'h20007003);
	wire dec_xc_aesmix_enc = XC_CLASS_AES && ((d_data & 32'hfe00707f) == 32'h22007003);
	wire dec_xc_aesmix_dec = XC_CLASS_AES && ((d_data & 32'hfe00707f) == 32'h24007003);
	wire dec_xc_sha3_xy = XC_CLASS_SHA3 && ((d_data & 32'h3e00707f) == 32'h10007003);
	wire dec_xc_sha3_x1 = XC_CLASS_SHA3 && ((d_data & 32'h3e00707f) == 32'h12007003);
	wire dec_xc_sha3_x2 = XC_CLASS_SHA3 && ((d_data & 32'h3e00707f) == 32'h14007003);
	wire dec_xc_sha3_x4 = XC_CLASS_SHA3 && ((d_data & 32'h3e00707f) == 32'h16007003);
	wire dec_xc_sha3_yx = XC_CLASS_SHA3 && ((d_data & 32'h3e00707f) == 32'h18007003);
	wire dec_xc_sha256_s0 = XC_CLASS_SHA2 && ((d_data & 32'hfff0707f) == 32'h0e007003);
	wire dec_xc_sha256_s1 = XC_CLASS_SHA2 && ((d_data & 32'hfff0707f) == 32'h0e107003);
	wire dec_xc_sha256_s2 = XC_CLASS_SHA2 && ((d_data & 32'hfff0707f) == 32'h0e207003);
	wire dec_xc_sha256_s3 = XC_CLASS_SHA2 && ((d_data & 32'hfff0707f) == 32'h0e307003);
	wire dec_b_cmov = BITMANIP_BASELINE && ((d_data & 32'h0600707f) == 32'h06005033);
	wire dec_b_ror = BITMANIP_BASELINE && ((d_data & 32'hfe00707f) == 32'h60005033);
	wire dec_b_rori = BITMANIP_BASELINE && ((d_data & 32'hfc00707f) == 32'h60005013);
	wire dec_b_fsl = BITMANIP_BASELINE && ((d_data & 32'h0600707f) == 32'h04001033);
	wire dec_b_fsr = BITMANIP_BASELINE && ((d_data & 32'h0600707f) == 32'h04005033);
	wire dec_b_fsri = BITMANIP_BASELINE && ((d_data & 32'h0400707f) == 32'h04005013);
	wire dec_b_clmul = BITMANIP_BASELINE && ((d_data & 32'hfe00707f) == 32'h0a001033);
	wire dec_b_clmulr = BITMANIP_BASELINE && ((d_data & 32'hfe00707f) == 32'h0a002033);
	wire dec_b_clmulh = BITMANIP_BASELINE && ((d_data & 32'hfe00707f) == 32'h0a003033);
	wire dec_b_bdep = BITMANIP_BASELINE && ((d_data & 32'hfe00707f) == 32'h08002033);
	wire dec_b_bext = BITMANIP_BASELINE && ((d_data & 32'hfe00707f) == 32'h08006033);
	wire dec_b_grev = BITMANIP_BASELINE && ((d_data & 32'hfe00707f) == 32'h40001033);
	wire dec_b_grevi = BITMANIP_BASELINE && ((d_data & 32'hfc00707f) == 32'h40001013);
	wire invalid_instr = !((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((dec_lui || dec_auipc) || dec_jal) || dec_jalr) || dec_beq) || dec_bne) || dec_blt) || dec_bge) || dec_bltu) || dec_bgeu) || dec_lb) || dec_lh) || dec_lw) || dec_lbu) || dec_lhu) || dec_sb) || dec_sh) || dec_sw) || dec_addi) || dec_slti) || dec_sltiu) || dec_xori) || dec_ori) || dec_andi) || dec_slli) || dec_srli) || dec_srai) || dec_add) || dec_sub) || dec_sll) || dec_slt) || dec_sltu) || dec_xor) || dec_srl) || dec_sra) || dec_or) || dec_and) || dec_fence) || dec_fence_i) || dec_mul) || dec_mulh) || dec_mulhsu) || dec_mulhu) || dec_div) || dec_divu) || dec_rem) || dec_remu) || dec_ecall) || dec_ebreak) || dec_mret) || dec_wfi) || dec_csrrw) || dec_csrrs) || dec_csrrc) || dec_csrrwi) || dec_csrrsi) || dec_csrrci) || dec_c_addi4spn) || dec_c_lw) || dec_c_sw) || dec_c_nop) || dec_c_addi) || dec_c_jal) || dec_c_li) || dec_c_addi16sp) || dec_c_lui) || dec_c_srli) || dec_c_srai) || dec_c_andi) || dec_c_sub) || dec_c_xor) || dec_c_or) || dec_c_and) || dec_c_j) || dec_c_beqz) || dec_c_bnez) || dec_c_slli) || dec_c_lwsp) || dec_c_jr) || dec_c_mv) || dec_c_ebreak) || dec_c_jalr) || dec_c_add) || dec_c_swsp) || dec_b_bdep) || dec_b_bext) || dec_b_clmul) || dec_b_clmulh) || dec_b_clmulr) || dec_b_cmov) || dec_b_grev) || dec_b_grevi) || dec_b_fsl) || dec_b_fsr) || dec_b_fsri) || dec_b_ror) || dec_b_rori) || dec_xc_aesmix_dec) || dec_xc_aesmix_enc) || dec_xc_aessub_dec) || dec_xc_aessub_decrot) || dec_xc_aessub_enc) || dec_xc_aessub_encrot) || dec_xc_bop) || dec_xc_gather_b) || dec_xc_gather_h) || dec_xc_ldr_b) || dec_xc_ldr_bu) || dec_xc_ldr_h) || dec_xc_ldr_hu) || dec_xc_ldr_w) || dec_xc_lut) || dec_xc_macc_1) || dec_xc_madd_3) || dec_xc_mmul_3) || dec_xc_mror) || dec_xc_msub_3) || dec_xc_padd) || dec_xc_pclmul_h) || dec_xc_pclmul_l) || dec_xc_pmul_h) || dec_xc_pmul_l) || dec_xc_pror) || dec_xc_pror_i) || dec_xc_psll) || dec_xc_psll_i) || dec_xc_psrl) || dec_xc_psrl_i) || dec_xc_psub) || dec_xc_rngsamp) || dec_xc_rngseed) || dec_xc_rngtest) || dec_xc_scatter_b) || dec_xc_scatter_h) || dec_xc_sha256_s0) || dec_xc_sha256_s1) || dec_xc_sha256_s2) || dec_xc_sha256_s3) || dec_xc_sha3_x1) || dec_xc_sha3_x2) || dec_xc_sha3_x4) || dec_xc_sha3_xy) || dec_xc_sha3_yx) || dec_xc_str_b) || dec_xc_str_h) || dec_xc_str_w) || dec_xc_lkgfence);
	localparam mypackage_P_FU_ALU = 0;
	assign n_s2_fu[mypackage_P_FU_ALU] = (((((((((((((((((((((((((((((((((((((((((((((dec_add || dec_addi) || dec_c_add) || dec_c_addi) || dec_c_addi16sp) || dec_c_addi4spn) || dec_c_mv) || dec_auipc) || dec_c_sub) || dec_sub) || dec_and) || dec_andi) || dec_c_and) || dec_c_andi) || dec_lui) || dec_c_li) || dec_c_lui) || dec_c_nop) || dec_or) || dec_ori) || dec_c_or) || dec_c_xor) || dec_xor) || dec_xori) || dec_slt) || dec_slti) || dec_sltu) || dec_sltiu) || dec_sra) || dec_srai) || dec_c_srai) || dec_c_srli) || dec_srl) || dec_srli) || dec_sll) || dec_slli) || dec_c_slli) || dec_xc_padd) || dec_xc_psub) || dec_xc_psrl) || dec_xc_psrl_i) || dec_xc_psll) || dec_xc_psll_i) || dec_xc_pror) || dec_xc_pror_i) || dec_b_ror) || dec_b_rori;
	localparam mypackage_P_FU_MUL = 1;
	assign n_s2_fu[mypackage_P_FU_MUL] = (((((((((((((((((dec_div || dec_divu) || dec_mul) || dec_mulh) || dec_mulhsu) || dec_mulhu) || dec_rem) || dec_remu) || dec_xc_pmul_l) || dec_xc_pmul_h) || dec_xc_pclmul_l) || dec_xc_pclmul_h) || dec_b_clmul) || dec_b_clmulr) || dec_b_clmulh) || dec_xc_mmul_3) || dec_xc_madd_3) || dec_xc_msub_3) || dec_xc_macc_1;
	localparam mypackage_P_FU_CFU = 3;
	assign n_s2_fu[mypackage_P_FU_CFU] = ((((((((((((((((dec_beq || dec_c_beqz) || dec_bge) || dec_bgeu) || dec_blt) || dec_bltu) || dec_bne) || dec_c_bnez) || dec_c_ebreak) || dec_ebreak) || dec_ecall) || dec_c_j) || dec_c_jr) || dec_c_jal) || dec_jal) || dec_c_jalr) || dec_jalr) || dec_mret;
	localparam mypackage_P_FU_LSU = 2;
	assign n_s2_fu[mypackage_P_FU_LSU] = ((((((((((((((((((((((dec_lb || dec_lbu) || dec_lh) || dec_lhu) || dec_lw) || dec_c_lw) || dec_c_lwsp) || dec_c_sw) || dec_c_swsp) || dec_sb) || dec_sh) || dec_sw) || dec_xc_ldr_b) || dec_xc_ldr_h) || dec_xc_ldr_w) || dec_xc_ldr_bu) || dec_xc_ldr_hu) || dec_xc_str_b) || dec_xc_str_h) || dec_xc_str_w) || dec_xc_scatter_b) || dec_xc_scatter_h) || dec_xc_gather_b) || dec_xc_gather_h;
	localparam mypackage_P_FU_CSR = 4;
	assign n_s2_fu[mypackage_P_FU_CSR] = ((((dec_csrrc || dec_csrrci) || dec_csrrs) || dec_csrrsi) || dec_csrrw) || dec_csrrwi;
	localparam mypackage_P_FU_BIT = 5;
	assign n_s2_fu[mypackage_P_FU_BIT] = (((((((((dec_b_bdep || dec_b_bext) || dec_b_grev) || dec_b_grevi) || dec_xc_lut) || dec_xc_bop) || dec_b_fsl) || dec_b_fsr) || dec_b_fsri) || dec_b_cmov) || dec_xc_mror;
	localparam mypackage_P_FU_ASI = 6;
	assign n_s2_fu[mypackage_P_FU_ASI] = (((((((((((((dec_xc_aessub_enc || dec_xc_aessub_encrot) || dec_xc_aessub_dec) || dec_xc_aessub_decrot) || dec_xc_aesmix_enc) || dec_xc_aesmix_dec) || dec_xc_sha3_xy) || dec_xc_sha3_x1) || dec_xc_sha3_x2) || dec_xc_sha3_x4) || dec_xc_sha3_yx) || dec_xc_sha256_s0) || dec_xc_sha256_s1) || dec_xc_sha256_s2) || dec_xc_sha256_s3;
	localparam mypackage_P_FU_RNG = 7;
	assign n_s2_fu[mypackage_P_FU_RNG] = ((dec_xc_rngtest || dec_xc_rngseed) || dec_xc_rngsamp) || dec_xc_lkgfence;
	wire [4:0] dec_rs1_32 = s1_data[19:15];
	wire [4:0] dec_rs2_32 = s1_data[24:20];
	wire [4:0] dec_rs3_32 = s1_data[31:27];
	wire clr_rd_lsb = (((dec_xc_mror || dec_xc_madd_3) || dec_xc_msub_3) || dec_xc_mmul_3) || dec_xc_macc_1;
	wire [4:0] dec_rd_32 = {s1_data[11:8], (clr_rd_lsb ? 1'b0 : s1_data[7])};
	wire instr_16bit = s1_data[1:0] != 2'b11;
	wire instr_32bit = s1_data[1:0] == 2'b11;
	assign n_s2_size[0] = instr_16bit;
	assign n_s2_size[1] = instr_32bit;
	generate
		if (TRACE_INSTR_WORD) begin : genblk1
			assign n_s2_instr = (instr_16bit ? {16'b0000000000000000, s1_data[15:0]} : s1_data);
		end
		else begin : genblk1
			assign n_s2_instr = 32'b00000000000000000000000000000000;
		end
	endgenerate
	localparam mypackage_ALU_ADD = 5'b00001;
	localparam mypackage_ALU_AND = 5'b01001;
	localparam mypackage_ALU_OR = 5'b01010;
	localparam mypackage_ALU_ROR = 5'b11110;
	localparam mypackage_ALU_SLL = 5'b11100;
	localparam mypackage_ALU_SLT = 5'b10001;
	localparam mypackage_ALU_SLTU = 5'b10010;
	localparam mypackage_ALU_SRA = 5'b11001;
	localparam mypackage_ALU_SRL = 5'b11010;
	localparam mypackage_ALU_SUB = 5'b00000;
	localparam mypackage_ALU_XOR = 5'b01100;
	wire [mypackage_OP:0] uop_alu = (((((((((((((((((((((((((((((((((((((((((((((({5 {dec_add}} & mypackage_ALU_ADD) | ({5 {dec_xc_padd}} & mypackage_ALU_ADD)) | ({5 {dec_addi}} & mypackage_ALU_ADD)) | ({5 {dec_c_add}} & mypackage_ALU_ADD)) | ({5 {dec_c_addi}} & mypackage_ALU_ADD)) | ({5 {dec_c_addi16sp}} & mypackage_ALU_ADD)) | ({5 {dec_c_addi4spn}} & mypackage_ALU_ADD)) | ({5 {dec_c_mv}} & mypackage_ALU_ADD)) | ({5 {dec_auipc}} & mypackage_ALU_ADD)) | ({5 {dec_c_sub}} & mypackage_ALU_SUB)) | ({5 {dec_sub}} & mypackage_ALU_SUB)) | ({5 {dec_xc_psub}} & mypackage_ALU_SUB)) | ({5 {dec_and}} & mypackage_ALU_AND)) | ({5 {dec_andi}} & mypackage_ALU_AND)) | ({5 {dec_c_and}} & mypackage_ALU_AND)) | ({5 {dec_c_andi}} & mypackage_ALU_AND)) | ({5 {dec_lui}} & mypackage_ALU_OR)) | ({5 {dec_c_li}} & mypackage_ALU_OR)) | ({5 {dec_c_lui}} & mypackage_ALU_OR)) | ({5 {dec_c_nop}} & mypackage_ALU_OR)) | ({5 {dec_or}} & mypackage_ALU_OR)) | ({5 {dec_ori}} & mypackage_ALU_OR)) | ({5 {dec_c_or}} & mypackage_ALU_OR)) | ({5 {dec_c_xor}} & mypackage_ALU_XOR)) | ({5 {dec_xor}} & mypackage_ALU_XOR)) | ({5 {dec_xori}} & mypackage_ALU_XOR)) | ({5 {dec_slt}} & mypackage_ALU_SLT)) | ({5 {dec_slti}} & mypackage_ALU_SLT)) | ({5 {dec_sltu}} & mypackage_ALU_SLTU)) | ({5 {dec_sltiu}} & mypackage_ALU_SLTU)) | ({5 {dec_sra}} & mypackage_ALU_SRA)) | ({5 {dec_srai}} & mypackage_ALU_SRA)) | ({5 {dec_c_srai}} & mypackage_ALU_SRA)) | ({5 {dec_c_srli}} & mypackage_ALU_SRL)) | ({5 {dec_srl}} & mypackage_ALU_SRL)) | ({5 {dec_srli}} & mypackage_ALU_SRL)) | ({5 {dec_xc_psrl}} & mypackage_ALU_SRL)) | ({5 {dec_xc_psrl_i}} & mypackage_ALU_SRL)) | ({5 {dec_sll}} & mypackage_ALU_SLL)) | ({5 {dec_slli}} & mypackage_ALU_SLL)) | ({5 {dec_c_slli}} & mypackage_ALU_SLL)) | ({5 {dec_xc_psll}} & mypackage_ALU_SLL)) | ({5 {dec_xc_psll_i}} & mypackage_ALU_SLL)) | ({5 {dec_b_ror}} & mypackage_ALU_ROR)) | ({5 {dec_b_rori}} & mypackage_ALU_ROR)) | ({5 {dec_xc_pror}} & mypackage_ALU_ROR)) | ({5 {dec_xc_pror_i}} & mypackage_ALU_ROR);
	localparam mypackage_CFU_BEQ = 5'b00001;
	localparam mypackage_CFU_BGE = 5'b00010;
	localparam mypackage_CFU_BGEU = 5'b00011;
	localparam mypackage_CFU_BLT = 5'b00100;
	localparam mypackage_CFU_BLTU = 5'b00101;
	localparam mypackage_CFU_BNE = 5'b00110;
	localparam mypackage_CFU_EBREAK = 5'b01001;
	localparam mypackage_CFU_ECALL = 5'b01010;
	localparam mypackage_CFU_JALI = 5'b10010;
	localparam mypackage_CFU_JALR = 5'b10100;
	localparam mypackage_CFU_MRET = 5'b01100;
	wire [mypackage_OP:0] uop_cfu = ((((((((((((((((({5 {dec_beq}} & mypackage_CFU_BEQ) | ({5 {dec_c_beqz}} & mypackage_CFU_BEQ)) | ({5 {dec_bge}} & mypackage_CFU_BGE)) | ({5 {dec_bgeu}} & mypackage_CFU_BGEU)) | ({5 {dec_blt}} & mypackage_CFU_BLT)) | ({5 {dec_bltu}} & mypackage_CFU_BLTU)) | ({5 {dec_bne}} & mypackage_CFU_BNE)) | ({5 {dec_c_bnez}} & mypackage_CFU_BNE)) | ({5 {dec_c_ebreak}} & mypackage_CFU_EBREAK)) | ({5 {dec_ebreak}} & mypackage_CFU_EBREAK)) | ({5 {dec_ecall}} & mypackage_CFU_ECALL)) | ({5 {dec_c_j}} & mypackage_CFU_JALI)) | ({5 {dec_c_jr}} & mypackage_CFU_JALR)) | ({5 {dec_c_jal}} & mypackage_CFU_JALI)) | ({5 {dec_jal}} & mypackage_CFU_JALI)) | ({5 {dec_c_jalr}} & mypackage_CFU_JALR)) | ({5 {dec_jalr}} & mypackage_CFU_JALR)) | ({5 {dec_mret}} & mypackage_CFU_MRET);
	localparam mypackage_LSU_BYTE = 2'b01;
	localparam mypackage_LSU_HALF = 2'b10;
	localparam mypackage_LSU_WORD = 2'b11;
	wire [1:0] lsu_width = ((((((((((((((((((({2 {dec_lb}} & mypackage_LSU_BYTE) | ({2 {dec_lbu}} & mypackage_LSU_BYTE)) | ({2 {dec_xc_ldr_b}} & mypackage_LSU_BYTE)) | ({2 {dec_xc_ldr_bu}} & mypackage_LSU_BYTE)) | ({2 {dec_sb}} & mypackage_LSU_BYTE)) | ({2 {dec_xc_str_b}} & mypackage_LSU_BYTE)) | ({2 {dec_lh}} & mypackage_LSU_HALF)) | ({2 {dec_lhu}} & mypackage_LSU_HALF)) | ({2 {dec_xc_ldr_h}} & mypackage_LSU_HALF)) | ({2 {dec_xc_ldr_hu}} & mypackage_LSU_HALF)) | ({2 {dec_sh}} & mypackage_LSU_HALF)) | ({2 {dec_xc_str_h}} & mypackage_LSU_HALF)) | ({2 {dec_lw}} & mypackage_LSU_WORD)) | ({2 {dec_xc_ldr_w}} & mypackage_LSU_WORD)) | ({2 {dec_c_lw}} & mypackage_LSU_WORD)) | ({2 {dec_c_lwsp}} & mypackage_LSU_WORD)) | ({2 {dec_c_sw}} & mypackage_LSU_WORD)) | ({2 {dec_c_swsp}} & mypackage_LSU_WORD)) | ({2 {dec_sw}} & mypackage_LSU_WORD)) | ({2 {dec_xc_str_w}} & mypackage_LSU_WORD);
	wire [mypackage_OP:0] uop_lsu;
	assign uop_lsu[2:1] = lsu_width;
	localparam mypackage_LSU_LOAD = 3;
	assign uop_lsu[mypackage_LSU_LOAD] = ((((((((((dec_lb || dec_lbu) || dec_xc_ldr_b) || dec_xc_ldr_bu) || dec_lh) || dec_lhu) || dec_xc_ldr_h) || dec_xc_ldr_hu) || dec_lw) || dec_xc_ldr_w) || dec_c_lw) || dec_c_lwsp;
	localparam mypackage_LSU_STORE = 4;
	assign uop_lsu[mypackage_LSU_STORE] = ((((((dec_sb || dec_sh) || dec_sw) || dec_xc_str_b) || dec_xc_str_h) || dec_xc_str_w) || dec_c_sw) || dec_c_swsp;
	localparam mypackage_LSU_SIGNED = 0;
	assign uop_lsu[mypackage_LSU_SIGNED] = ((dec_lb || dec_xc_ldr_b) || dec_lh) || dec_xc_ldr_h;
	localparam mypackage_MUL_CLMUL_H = 5'b00010;
	localparam mypackage_MUL_CLMUL_L = 5'b00001;
	localparam mypackage_MUL_CLMUL_R = 5'b00100;
	localparam mypackage_MUL_DIV = 5'b11000;
	localparam mypackage_MUL_DIVU = 5'b11001;
	localparam mypackage_MUL_MACC = 5'b10100;
	localparam mypackage_MUL_MADD = 5'b10001;
	localparam mypackage_MUL_MMUL = 5'b10000;
	localparam mypackage_MUL_MSUB = 5'b10010;
	localparam mypackage_MUL_MUL = 5'b01100;
	localparam mypackage_MUL_MULH = 5'b01110;
	localparam mypackage_MUL_MULHSU = 5'b01111;
	localparam mypackage_MUL_MULHU = 5'b01101;
	localparam mypackage_MUL_PMUL_H = 5'b01001;
	localparam mypackage_MUL_PMUL_L = 5'b01000;
	localparam mypackage_MUL_REM = 5'b11100;
	localparam mypackage_MUL_REMU = 5'b11101;
	wire [mypackage_OP:0] uop_mul = (((((((((((((((((({5 {dec_div}} & mypackage_MUL_DIV) | ({5 {dec_divu}} & mypackage_MUL_DIVU)) | ({5 {dec_rem}} & mypackage_MUL_REM)) | ({5 {dec_remu}} & mypackage_MUL_REMU)) | ({5 {dec_mul}} & mypackage_MUL_MUL)) | ({5 {dec_xc_pmul_l}} & mypackage_MUL_PMUL_L)) | ({5 {dec_mulh}} & mypackage_MUL_MULH)) | ({5 {dec_xc_pmul_h}} & mypackage_MUL_PMUL_H)) | ({5 {dec_mulhsu}} & mypackage_MUL_MULHSU)) | ({5 {dec_mulhu}} & mypackage_MUL_MULHU)) | ({5 {dec_xc_mmul_3}} & mypackage_MUL_MMUL)) | ({5 {dec_xc_madd_3}} & mypackage_MUL_MADD)) | ({5 {dec_xc_msub_3}} & mypackage_MUL_MSUB)) | ({5 {dec_xc_macc_1}} & mypackage_MUL_MACC)) | ({5 {dec_xc_pclmul_l}} & mypackage_MUL_CLMUL_L)) | ({5 {dec_b_clmul}} & mypackage_MUL_CLMUL_L)) | ({5 {dec_xc_pclmul_h}} & mypackage_MUL_CLMUL_H)) | ({5 {dec_b_clmulh}} & mypackage_MUL_CLMUL_H)) | ({5 {dec_b_clmulr}} & mypackage_MUL_CLMUL_R);
	wire [mypackage_OP:0] uop_csr;
	wire csr_op = ((((dec_csrrc || dec_csrrci) || dec_csrrs) || dec_csrrsi) || dec_csrrw) || dec_csrrwi;
	wire csr_no_write = ((dec_csrrs || dec_csrrc) && (dec_rs1_32 == 0)) || ((dec_csrrsi || dec_csrrci) && (dec_rs1_32 == 0));
	wire csr_no_read = (dec_csrrw || dec_csrrwi) && (dec_rd_32 == 0);
	localparam mypackage_CSR_READ = 4;
	assign uop_csr[mypackage_CSR_READ] = csr_op && !csr_no_read;
	localparam mypackage_CSR_WRITE = 3;
	assign uop_csr[mypackage_CSR_WRITE] = csr_op && !csr_no_write;
	localparam mypackage_CSR_SET = 2;
	assign uop_csr[mypackage_CSR_SET] = dec_csrrs || dec_csrrsi;
	localparam mypackage_CSR_CLEAR = 1;
	assign uop_csr[mypackage_CSR_CLEAR] = dec_csrrc || dec_csrrci;
	localparam mypackage_CSR_SWAP = 0;
	assign uop_csr[mypackage_CSR_SWAP] = dec_csrrw || dec_csrrwi;
	localparam mypackage_BIT_BDEP = 5'b01000;
	localparam mypackage_BIT_BEXT = 5'b01001;
	localparam mypackage_BIT_BOP = 5'b11001;
	localparam mypackage_BIT_CMOV = 5'b11100;
	localparam mypackage_BIT_FSL = 5'b00000;
	localparam mypackage_BIT_FSR = 5'b00001;
	localparam mypackage_BIT_GREV = 5'b10000;
	localparam mypackage_BIT_GREVI = 5'b10001;
	localparam mypackage_BIT_LUT = 5'b11000;
	localparam mypackage_BIT_RORW = 5'b00011;
	wire [mypackage_OP:0] uop_bit = (((((((((({5 {dec_b_cmov}} & mypackage_BIT_CMOV) | ({5 {dec_b_bdep}} & mypackage_BIT_BDEP)) | ({5 {dec_b_bext}} & mypackage_BIT_BEXT)) | ({5 {dec_b_grev}} & mypackage_BIT_GREV)) | ({5 {dec_b_grevi}} & mypackage_BIT_GREVI)) | ({5 {dec_xc_lut}} & mypackage_BIT_LUT)) | ({5 {dec_xc_bop}} & mypackage_BIT_BOP)) | ({5 {dec_b_fsl}} & mypackage_BIT_FSL)) | ({5 {dec_b_fsr}} & mypackage_BIT_FSR)) | ({5 {dec_b_fsri}} & mypackage_BIT_FSR)) | ({5 {dec_xc_mror}} & mypackage_BIT_RORW);
	localparam mypackage_ASI_AES = 2'b01;
	localparam mypackage_ASI_AESMIX_DEC = {mypackage_ASI_AES, 3'b101};
	localparam mypackage_ASI_AESMIX_ENC = {mypackage_ASI_AES, 3'b100};
	localparam mypackage_ASI_AESSUB_DEC = {mypackage_ASI_AES, 3'b001};
	localparam mypackage_ASI_AESSUB_DECROT = {mypackage_ASI_AES, 3'b011};
	localparam mypackage_ASI_AESSUB_ENC = {mypackage_ASI_AES, 3'b000};
	localparam mypackage_ASI_AESSUB_ENCROT = {mypackage_ASI_AES, 3'b010};
	localparam mypackage_ASI_SHA2 = 2'b10;
	localparam mypackage_ASI_SHA256_S0 = {mypackage_ASI_SHA2, 3'b000};
	localparam mypackage_ASI_SHA256_S1 = {mypackage_ASI_SHA2, 3'b001};
	localparam mypackage_ASI_SHA256_S2 = {mypackage_ASI_SHA2, 3'b010};
	localparam mypackage_ASI_SHA256_S3 = {mypackage_ASI_SHA2, 3'b011};
	localparam mypackage_ASI_SHA3 = 2'b11;
	localparam mypackage_ASI_SHA3_X1 = {mypackage_ASI_SHA3, 3'b001};
	localparam mypackage_ASI_SHA3_X2 = {mypackage_ASI_SHA3, 3'b010};
	localparam mypackage_ASI_SHA3_X4 = {mypackage_ASI_SHA3, 3'b011};
	localparam mypackage_ASI_SHA3_XY = {mypackage_ASI_SHA3, 3'b000};
	localparam mypackage_ASI_SHA3_YX = {mypackage_ASI_SHA3, 3'b100};
	wire [mypackage_OP:0] uop_asi = (((((((((((((({5 {dec_xc_aessub_enc}} & mypackage_ASI_AESSUB_ENC) | ({5 {dec_xc_aessub_encrot}} & mypackage_ASI_AESSUB_ENCROT)) | ({5 {dec_xc_aessub_dec}} & mypackage_ASI_AESSUB_DEC)) | ({5 {dec_xc_aessub_decrot}} & mypackage_ASI_AESSUB_DECROT)) | ({5 {dec_xc_aesmix_enc}} & mypackage_ASI_AESMIX_ENC)) | ({5 {dec_xc_aesmix_dec}} & mypackage_ASI_AESMIX_DEC)) | ({5 {dec_xc_sha3_xy}} & mypackage_ASI_SHA3_XY)) | ({5 {dec_xc_sha3_x1}} & mypackage_ASI_SHA3_X1)) | ({5 {dec_xc_sha3_x2}} & mypackage_ASI_SHA3_X2)) | ({5 {dec_xc_sha3_x4}} & mypackage_ASI_SHA3_X4)) | ({5 {dec_xc_sha3_yx}} & mypackage_ASI_SHA3_YX)) | ({5 {dec_xc_sha256_s0}} & mypackage_ASI_SHA256_S0)) | ({5 {dec_xc_sha256_s1}} & mypackage_ASI_SHA256_S1)) | ({5 {dec_xc_sha256_s2}} & mypackage_ASI_SHA256_S2)) | ({5 {dec_xc_sha256_s3}} & mypackage_ASI_SHA256_S3);
	localparam mypackage_RNG_ALFENCE = 5'b11010;
	localparam mypackage_RNG_RNGSAMP = 5'b00010;
	localparam mypackage_RNG_RNGSEED = 5'b00001;
	localparam mypackage_RNG_RNGTEST = 5'b00100;
	wire [mypackage_OP:0] uop_rng = ((({5 {dec_xc_rngtest}} & mypackage_RNG_RNGTEST) | ({5 {dec_xc_rngseed}} & mypackage_RNG_RNGSEED)) | ({5 {dec_xc_rngsamp}} & mypackage_RNG_RNGSAMP)) | ({5 {dec_xc_lkgfence}} & mypackage_RNG_ALFENCE);
	assign n_s2_uop = ((((((uop_alu | uop_cfu) | uop_lsu) | uop_mul) | uop_csr) | uop_bit) | uop_asi) | uop_rng;
	localparam mypackage_REG_SP = 5'd2;
	wire [4:0] dec_rs1_16 = ((((((((((((((((((({5 {dec_c_add}} & {s1_data[11:7]}) | ({5 {dec_c_addi}} & {s1_data[11:7]})) | ({5 {dec_c_jalr}} & {s1_data[11:7]})) | ({5 {dec_c_jr}} & {s1_data[11:7]})) | ({5 {dec_c_slli}} & {s1_data[11:7]})) | ({5 {dec_c_swsp}} & {mypackage_REG_SP})) | ({5 {dec_c_addi16sp}} & {mypackage_REG_SP})) | ({5 {dec_c_addi4spn}} & {mypackage_REG_SP})) | ({5 {dec_c_lwsp}} & {mypackage_REG_SP})) | ({5 {dec_c_and}} & {2'b01, s1_data[9:7]})) | ({5 {dec_c_andi}} & {2'b01, s1_data[9:7]})) | ({5 {dec_c_beqz}} & {2'b01, s1_data[9:7]})) | ({5 {dec_c_bnez}} & {2'b01, s1_data[9:7]})) | ({5 {dec_c_lw}} & {2'b01, s1_data[9:7]})) | ({5 {dec_c_or}} & {2'b01, s1_data[9:7]})) | ({5 {dec_c_srai}} & {2'b01, s1_data[9:7]})) | ({5 {dec_c_srli}} & {2'b01, s1_data[9:7]})) | ({5 {dec_c_sub}} & {2'b01, s1_data[9:7]})) | ({5 {dec_c_sw}} & {2'b01, s1_data[9:7]})) | ({5 {dec_c_xor}} & {2'b01, s1_data[9:7]});
	localparam mypackage_REG_ZERO = 5'd0;
	wire [4:0] dec_rs2_16 = ((((((((({5 {dec_c_beqz}} & {mypackage_REG_ZERO}) | ({5 {dec_c_bnez}} & {mypackage_REG_ZERO})) | ({5 {dec_c_add}} & {s1_data[6:2]})) | ({5 {dec_c_mv}} & {s1_data[6:2]})) | ({5 {dec_c_swsp}} & {s1_data[6:2]})) | ({5 {dec_c_and}} & {2'b01, s1_data[4:2]})) | ({5 {dec_c_or}} & {2'b01, s1_data[4:2]})) | ({5 {dec_c_sub}} & {2'b01, s1_data[4:2]})) | ({5 {dec_c_sw}} & {2'b01, s1_data[4:2]})) | ({5 {dec_c_xor}} & {2'b01, s1_data[4:2]});
	localparam mypackage_REG_RA = 5'd1;
	wire [4:0] dec_rd_16 = (((((((((((((((((({5 {dec_c_addi16sp}} & {mypackage_REG_SP}) | ({5 {dec_c_addi4spn}} & {2'b01, s1_data[4:2]})) | ({5 {dec_c_and}} & {2'b01, s1_data[9:7]})) | ({5 {dec_c_andi}} & {2'b01, s1_data[9:7]})) | ({5 {dec_c_jal}} & {mypackage_REG_RA})) | ({5 {dec_c_jalr}} & {mypackage_REG_RA})) | ({5 {dec_c_add}} & {s1_data[11:7]})) | ({5 {dec_c_addi}} & {s1_data[11:7]})) | ({5 {dec_c_li}} & {s1_data[11:7]})) | ({5 {dec_c_lui}} & {s1_data[11:7]})) | ({5 {dec_c_lwsp}} & {s1_data[11:7]})) | ({5 {dec_c_mv}} & {s1_data[11:7]})) | ({5 {dec_c_slli}} & {s1_data[11:7]})) | ({5 {dec_c_lw}} & {2'b01, s1_data[4:2]})) | ({5 {dec_c_or}} & {2'b01, s1_data[9:7]})) | ({5 {dec_c_srai}} & {2'b01, s1_data[9:7]})) | ({5 {dec_c_srli}} & {2'b01, s1_data[9:7]})) | ({5 {dec_c_sub}} & {2'b01, s1_data[9:7]})) | ({5 {dec_c_xor}} & {2'b01, s1_data[9:7]});
	wire opra_src_rs1;
	wire oprb_src_rs2;
	wire oprc_src_rs2;
	wire oprc_src_rs3;
	wire no_rs1 = !opra_src_rs1;
	wire no_rs2 = !(oprb_src_rs2 || oprc_src_rs2);
	wire no_rs3 = !oprc_src_rs3 || !(((XC_CLASS_MULTIARITH || XC_CLASS_BIT) || XC_CLASS_MEMORY) || XC_CLASS_BASELINE);
	assign s1_rs1_addr = (no_rs1 ? 5'b00000 : (instr_16bit ? dec_rs1_16 : dec_rs1_32));
	assign s1_rs2_addr = (no_rs2 ? 5'b00000 : (instr_16bit ? dec_rs2_16 : dec_rs2_32));
	wire rd_as_rs3 = dec_xc_bop;
	assign s1_rs3_addr = (no_rs3 ? 5'b00000 : (rd_as_rs3 ? dec_rd_32 : dec_rs3_32));
	wire lsu_no_rd = uop_lsu[mypackage_LSU_STORE] && n_s2_fu[mypackage_P_FU_LSU];
	wire cfu_no_rd = ((uop_cfu != mypackage_CFU_JALI) && (uop_cfu != mypackage_CFU_JALR)) && n_s2_fu[mypackage_P_FU_CFU];
	wire [5:0] trap_cause;
	assign n_s2_rd = (n_s2_trap ? trap_cause[4:0] : (lsu_no_rd || cfu_no_rd ? 0 : ({5 {instr_16bit && |n_s2_fu}} & dec_rd_16) | ({5 {instr_32bit && |n_s2_fu}} & dec_rd_32)));
	wire [31:0] imm32_i = {{20 {s1_data[31]}}, s1_data[31:20]};
	wire [11:0] imm_csr_a = s1_data[31:20];
	wire [31:0] imm32_s = {{20 {s1_data[31]}}, s1_data[31:25], s1_data[11:7]};
	wire [31:0] imm32_b = {{19 {s1_data[31]}}, s1_data[31], s1_data[7], s1_data[30:25], s1_data[11:8], 1'b0};
	wire [31:0] imm32_u = {s1_data[31:12], 12'b000000000000};
	wire [31:0] imm32_j = {{11 {s1_data[31]}}, s1_data[31], s1_data[19:12], s1_data[20], s1_data[30:21], 1'b0};
	wire [31:0] imm_addi16sp = {{23 {s1_data[12]}}, s1_data[4:3], s1_data[5], s1_data[2], s1_data[6], 4'b0000};
	wire [31:0] imm_addi4spn = {22'b0000000000000000000000, s1_data[10:7], s1_data[12:11], s1_data[5], s1_data[6], 2'b00};
	wire [31:0] imm_c_lsw = {25'b0000000000000000000000000, s1_data[5], s1_data[12:10], s1_data[6], 2'b00};
	wire [31:0] imm_c_addi = {{27 {s1_data[12]}}, s1_data[6:2]};
	wire [31:0] imm_c_lui = {{15 {s1_data[12]}}, s1_data[6:2], 12'b000000000000};
	wire [31:0] imm_c_shamt = {27'b000000000000000000000000000, s1_data[6:2]};
	wire [31:0] imm_c_lwsp = {24'b000000000000000000000000, s1_data[3:2], s1_data[12], s1_data[6:4], 2'b00};
	wire [31:0] imm_c_swsp = {24'b000000000000000000000000, s1_data[8:7], s1_data[12:9], 2'b00};
	wire [31:0] imm_c_j = {{21 {s1_data[12]}}, s1_data[8], s1_data[10:9], s1_data[6], s1_data[7], s1_data[2], s1_data[11], s1_data[5:3], 1'b0};
	wire [31:0] imm_c_bz = {{24 {s1_data[12]}}, s1_data[6:5], s1_data[2], s1_data[11:10], s1_data[4:3], 1'b0};
	wire use_imm32_i = ((((((((((dec_andi || dec_slti) || dec_jalr) || dec_lb) || dec_lbu) || dec_lh) || dec_lhu) || dec_lw) || dec_ori) || dec_sltiu) || dec_xori) || dec_addi;
	wire use_imm32_j = dec_jal;
	wire use_imm32_s = (dec_sb || dec_sh) || dec_sw;
	wire use_imm32_u = dec_auipc || dec_lui;
	wire use_imm32_b = ((((dec_beq || dec_bge) || dec_bgeu) || dec_blt) || dec_bltu) || dec_bne;
	wire use_imm_csr = (dec_csrrc || dec_csrrs) || dec_csrrw;
	wire use_imm_csri = (dec_csrrci || dec_csrrsi) || dec_csrrwi;
	wire use_imm_shfi = (((((dec_slli || dec_srli) || dec_srai) || dec_xc_psll_i) || dec_xc_psrl_i) || dec_xc_pror_i) || dec_b_rori;
	wire use_imm_wshf = dec_b_fsri;
	wire use_pc_imm = ((((use_imm32_b || use_imm32_j) || dec_c_beqz) || dec_c_bnez) || dec_c_j) || dec_c_jal;
	wire use_imm_sha3 = (((dec_xc_sha3_xy || dec_xc_sha3_x1) || dec_xc_sha3_x2) || dec_xc_sha3_x4) || dec_xc_sha3_yx;
	wire [31:0] n_s2_imm_pc = (((((({32 {use_imm32_b}} & imm32_b) | ({32 {use_imm32_j}} & imm32_j)) | ({32 {use_imm32_u}} & imm32_u)) | ({32 {dec_c_beqz}} & imm_c_bz)) | ({32 {dec_c_bnez}} & imm_c_bz)) | ({32 {dec_c_j}} & imm_c_j)) | ({32 {dec_c_jal}} & imm_c_j);
	assign n_s2_imm = ((((((((((((((((((((n_s2_imm_pc | ({32 {use_imm_sha3}} & {30'b000000000000000000000000000000, d_data[31:30]})) | ({32 {use_imm32_i}} & imm32_i)) | ({32 {use_imm32_s}} & imm32_s)) | ({32 {dec_c_addi}} & imm_c_addi)) | ({32 {dec_c_addi16sp}} & imm_addi16sp)) | ({32 {dec_c_addi4spn}} & imm_addi4spn)) | ({32 {dec_c_andi}} & imm_c_addi)) | ({32 {dec_c_li}} & imm_c_addi)) | ({32 {dec_c_lui}} & imm_c_lui)) | ({32 {dec_c_lw}} & imm_c_lsw)) | ({32 {dec_c_lwsp}} & imm_c_lwsp)) | ({32 {dec_c_slli}} & imm_c_shamt)) | ({32 {dec_c_srli}} & imm_c_shamt)) | ({32 {dec_c_srai}} & imm_c_shamt)) | ({32 {dec_c_sw}} & imm_c_lsw)) | ({32 {dec_c_swsp}} & imm_c_swsp)) | ({32 {use_imm_csri}} & {imm_csr_a, 15'b000000000000000, s1_data[19:15]})) | ({32 {use_imm_csr}} & {imm_csr_a, 20'b00000000000000000000})) | ({32 {dec_fence_i}} & 32'd4)) | ({32 {use_imm_shfi}} & {27'b000000000000000000000000000, s1_data[24:20]})) | ({32 {use_imm_wshf}} & {26'b00000000000000000000000000, s1_data[25:20]});
	wire packed_instruction = ((((((((((dec_xc_padd || dec_xc_psub) || dec_xc_pror) || dec_xc_psll) || dec_xc_psrl) || dec_xc_pror_i) || dec_xc_psll_i) || dec_xc_psrl_i) || dec_xc_pmul_l) || dec_xc_pmul_h) || dec_xc_pclmul_l) || dec_xc_pclmul_h;
	wire bop_lut_sel = d_data[31];
	localparam mypackage_PW_32 = 3'b100;
	assign n_s2_pw = (packed_instruction ? {1'b0, d_data[31:30]} : (dec_xc_bop ? {2'b00, bop_lut_sel} : mypackage_PW_32));
	localparam mypackage_DIS_OPRA_RS1 = 0;
	assign n_s2_opr_src[mypackage_DIS_OPRA_RS1] = ((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((dec_add || dec_addi) || dec_c_add) || dec_c_addi) || dec_c_addi16sp) || dec_c_addi4spn) || dec_c_mv) || dec_c_sub) || dec_sub) || dec_and) || dec_andi) || dec_c_and) || dec_c_andi) || dec_or) || dec_ori) || dec_c_or) || dec_c_xor) || dec_xor) || dec_xori) || dec_slt) || dec_slti) || dec_sltu) || dec_sltiu) || dec_sra) || dec_srai) || dec_c_srai) || dec_c_srli) || dec_srl) || dec_srli) || dec_sll) || dec_slli) || dec_c_slli) || dec_beq) || dec_c_beqz) || dec_bge) || dec_bgeu) || dec_blt) || dec_bltu) || dec_bne) || dec_c_bnez) || dec_c_jr) || dec_c_jalr) || dec_jalr) || dec_lb) || dec_lbu) || dec_lh) || dec_lhu) || dec_lw) || dec_c_lw) || dec_c_lwsp) || dec_c_sw) || dec_c_swsp) || dec_sb) || dec_sh) || dec_sw) || dec_csrrc) || dec_csrrs) || dec_csrrw) || dec_div) || dec_divu) || dec_mul) || dec_mulh) || dec_mulhsu) || dec_mulhu) || dec_rem) || dec_remu) || dec_b_ror) || dec_b_rori) || dec_xc_padd) || dec_xc_psub) || dec_xc_psrl) || dec_xc_psrl_i) || dec_xc_psll) || dec_xc_psll_i) || dec_xc_pror) || dec_xc_pror_i) || dec_xc_ldr_b) || dec_xc_ldr_bu) || dec_xc_ldr_h) || dec_xc_ldr_hu) || dec_xc_ldr_w) || dec_xc_str_b) || dec_xc_str_h) || dec_xc_str_w) || dec_xc_pmul_l) || dec_xc_pmul_h) || dec_xc_pclmul_l) || dec_xc_pclmul_h) || dec_b_bdep) || dec_b_bext) || dec_b_grev) || dec_b_grevi) || dec_xc_lut) || dec_xc_bop) || dec_b_fsl) || dec_b_fsr) || dec_b_fsri) || dec_b_cmov) || dec_b_clmul) || dec_b_clmulr) || dec_b_clmulh) || dec_xc_aessub_enc) || dec_xc_aessub_encrot) || dec_xc_aessub_dec) || dec_xc_aessub_decrot) || dec_xc_aesmix_enc) || dec_xc_aesmix_dec) || dec_xc_sha3_xy) || dec_xc_sha3_x1) || dec_xc_sha3_x2) || dec_xc_sha3_x4) || dec_xc_sha3_yx) || dec_xc_sha256_s0) || dec_xc_sha256_s1) || dec_xc_sha256_s2) || dec_xc_sha256_s3) || dec_xc_mmul_3) || dec_xc_madd_3) || dec_xc_msub_3) || dec_xc_macc_1) || dec_xc_mror) || dec_xc_rngseed) || dec_xc_gather_b) || dec_xc_scatter_b) || dec_xc_gather_h) || dec_xc_scatter_h;
	localparam mypackage_DIS_OPRA_PCIM = 1;
	assign n_s2_opr_src[mypackage_DIS_OPRA_PCIM] = dec_auipc;
	localparam mypackage_DIS_OPRA_CSRI = 2;
	assign n_s2_opr_src[mypackage_DIS_OPRA_CSRI] = (dec_csrrci || dec_csrrsi) || dec_csrrwi;
	wire opra_src_zero = (dec_lui || dec_c_li) || dec_c_lui;
	localparam mypackage_DIS_OPRB_RS2 = 3;
	assign n_s2_opr_src[mypackage_DIS_OPRB_RS2] = ((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((dec_add || dec_c_add) || dec_c_sub) || dec_sub) || dec_and) || dec_c_and) || dec_or) || dec_c_or) || dec_c_xor) || dec_xor) || dec_slt) || dec_sltu) || dec_sra) || dec_srl) || dec_sll) || dec_beq) || dec_c_beqz) || dec_bge) || dec_bgeu) || dec_blt) || dec_bltu) || dec_bne) || dec_c_bnez) || dec_div) || dec_divu) || dec_mul) || dec_mulh) || dec_mulhsu) || dec_mulhu) || dec_rem) || dec_remu) || dec_c_mv) || dec_xc_padd) || dec_xc_psub) || dec_xc_psrl) || dec_xc_psll) || dec_xc_pror) || dec_b_cmov) || dec_xc_ldr_b) || dec_xc_ldr_bu) || dec_xc_ldr_h) || dec_xc_ldr_hu) || dec_xc_ldr_w) || dec_xc_str_b) || dec_xc_str_h) || dec_xc_str_w) || dec_xc_pmul_l) || dec_xc_pmul_h) || dec_xc_pclmul_l) || dec_xc_pclmul_h) || dec_b_bdep) || dec_b_bext) || dec_b_grev) || dec_b_ror) || dec_xc_lut) || dec_xc_bop) || dec_b_fsl) || dec_b_fsr) || dec_b_clmul) || dec_b_clmulr) || dec_b_clmulh) || dec_xc_mmul_3) || dec_xc_madd_3) || dec_xc_msub_3) || dec_xc_macc_1) || dec_xc_mror) || dec_xc_gather_b) || dec_xc_scatter_b) || dec_xc_gather_h) || dec_xc_scatter_h;
	localparam mypackage_DIS_OPRB_IMM = 4;
	assign n_s2_opr_src[mypackage_DIS_OPRB_IMM] = (((((((((((((((((((((((((((((((((((((((((dec_addi || dec_c_addi) || dec_andi) || dec_c_andi) || dec_lui) || dec_c_li) || dec_c_lui) || dec_ori) || dec_xori) || dec_slti) || dec_sltiu) || dec_srai) || dec_c_srai) || dec_c_srli) || dec_srli) || dec_slli) || dec_c_slli) || dec_jalr) || dec_lb) || dec_lbu) || dec_lh) || dec_lhu) || dec_lw) || dec_c_lw) || dec_c_lwsp) || dec_c_sw) || dec_c_swsp) || dec_sb) || dec_sh) || dec_sw) || dec_c_addi16sp) || dec_c_addi4spn) || dec_xc_sha3_xy) || dec_xc_sha3_x1) || dec_xc_sha3_x2) || dec_xc_sha3_x4) || dec_xc_sha3_yx) || dec_xc_psrl_i) || dec_xc_psll_i) || dec_xc_pror_i) || dec_b_grevi) || dec_b_rori) || dec_b_fsri;
	wire oprb_src_zero = (((dec_c_mv || dec_auipc) || dec_c_jr) || dec_c_jalr) || dec_jal;
	localparam mypackage_DIS_OPRC_RS2 = 5;
	assign n_s2_opr_src[mypackage_DIS_OPRC_RS2] = ((((((((((((((((((dec_c_sw || dec_c_swsp) || dec_sb) || dec_sh) || dec_sw) || dec_xc_aessub_enc) || dec_xc_aessub_encrot) || dec_xc_aessub_dec) || dec_xc_aessub_decrot) || dec_xc_aesmix_enc) || dec_xc_aesmix_dec) || dec_xc_sha3_xy) || dec_xc_sha3_x1) || dec_xc_sha3_x2) || dec_xc_sha3_x4) || dec_xc_sha3_yx) || dec_xc_sha256_s0) || dec_xc_sha256_s1) || dec_xc_sha256_s2) || dec_xc_sha256_s3;
	localparam mypackage_DIS_OPRC_RS3 = 8;
	assign n_s2_opr_src[mypackage_DIS_OPRC_RS3] = ((((((((((((((((dec_xc_str_b || dec_xc_str_h) || dec_xc_str_w) || dec_xc_mmul_3) || dec_xc_madd_3) || dec_xc_msub_3) || dec_xc_macc_1) || dec_xc_mror) || dec_b_fsl) || dec_b_fsr) || dec_b_fsri) || dec_xc_lut) || dec_xc_bop) || dec_b_cmov) || dec_xc_gather_b) || dec_xc_scatter_b) || dec_xc_gather_h) || dec_xc_scatter_h;
	localparam mypackage_DIS_OPRC_CSRA = 6;
	assign n_s2_opr_src[mypackage_DIS_OPRC_CSRA] = ((((dec_csrrc || dec_csrrci) || dec_csrrs) || dec_csrrsi) || dec_csrrw) || dec_csrrwi;
	localparam mypackage_DIS_OPRC_PCIM = 7;
	assign n_s2_opr_src[mypackage_DIS_OPRC_PCIM] = (((((((((dec_beq || dec_c_beqz) || dec_bge) || dec_bgeu) || dec_blt) || dec_bltu) || dec_bne) || dec_c_bnez) || dec_c_j) || dec_c_jal) || dec_jal;
	localparam mypackage_TRAP_IACCESS = 6'b000001;
	localparam mypackage_TRAP_IOPCODE = 6'd2;
	assign trap_cause = (s1_error ? mypackage_TRAP_IACCESS : (invalid_instr ? mypackage_TRAP_IOPCODE : 0));
	assign n_s2_trap = s1_valid && (s1_error || invalid_instr);
	wire [31:0] csr_addr = {20'b00000000000000000000, n_s2_imm[31:20]};
	wire [31:0] csr_imm = {27'b000000000000000000000000000, dec_rs1_32};
	reg [mypackage_XL:0] program_counter;
	wire [mypackage_XL:0] n_program_counter = program_counter + {29'b00000000000000000000000000000, n_s2_size, 1'b0};
	always @(posedge g_clk)
		if (!g_resetn)
			program_counter <= FRV_PC_RESET_VALUE;
		else if (cf_req && cf_ack)
			program_counter <= cf_target;
		else if (s1_valid && !s1_busy)
			program_counter <= n_program_counter;
	wire [mypackage_XL:0] pc_plus_imm;
	assign pc_plus_imm = program_counter + n_s2_imm_pc;
	wire leak_fence = dec_xc_lkgfence && s1_valid;
	assign s1_leak_fence = leak_fence;
	reg [1:0] lf_count;
	wire [1:0] n_lf_count = lf_count + 1;
	assign leak_stall = (leak_fence && (lf_count < 3)) && XC_CLASS_LEAK_BUBBLE;
	wire lf_count_ld = (leak_fence && !p_s2_busy) && XC_CLASS_LEAK_BUBBLE;
	always @(posedge g_clk)
		if (!g_resetn)
			lf_count <= 0;
		else if (lf_count_ld)
			lf_count <= n_lf_count;
	frv_leak #(
		.XC_CLASS_LEAK(XC_CLASS_LEAK),
		.XC_CLASS_LEAK_STRONG(XC_CLASS_LEAK_STRONG)
	) i_frv_leak(
		.g_clk(g_clk),
		.g_resetn(g_resetn),
		.leak_prng(leak_prng),
		.leak_fence(leak_fence)
	);
	localparam mypackage_LEAK_CFG_S2_OPR_A = 0;
	wire opra_flush = (pipe_progress && leak_fence) && leak_lkgcfg[mypackage_LEAK_CFG_S2_OPR_A];
	localparam mypackage_LEAK_CFG_S2_OPR_B = 1;
	wire oprb_flush = (pipe_progress && leak_fence) && leak_lkgcfg[mypackage_LEAK_CFG_S2_OPR_B];
	localparam mypackage_LEAK_CFG_S2_OPR_C = 2;
	wire oprc_flush = (pipe_progress && leak_fence) && leak_lkgcfg[mypackage_LEAK_CFG_S2_OPR_C];
	assign opra_src_rs1 = n_s2_opr_src[mypackage_DIS_OPRA_RS1];
	wire opra_src_pcim = n_s2_opr_src[mypackage_DIS_OPRA_PCIM];
	wire opra_src_csri = n_s2_opr_src[mypackage_DIS_OPRA_CSRI];
	wire opra_ld_en = n_s2_valid && (((opra_src_rs1 || opra_src_pcim) || opra_src_csri) || opra_src_zero);
	assign n_s2_opr_a = ((({mypackage_XLEN {opra_src_zero}} & 32'b00000000000000000000000000000000) | ({mypackage_XLEN {opra_src_rs1}} & s1_rs1_rdata)) | ({mypackage_XLEN {opra_src_pcim}} & pc_plus_imm)) | ({mypackage_XLEN {opra_src_csri}} & csr_imm);
	wire oprb_rs2_shf_1 = (((dec_xc_ldr_h || dec_xc_ldr_hu) || dec_xc_str_h) || dec_xc_scatter_h) || dec_xc_gather_h;
	wire oprb_rs2_shf_2 = dec_xc_ldr_w || dec_xc_str_w;
	wire [mypackage_XL:0] s1_rs2_shf = (oprb_rs2_shf_1 ? {s1_rs2_rdata[30:0], 1'b0} : (oprb_rs2_shf_2 ? {s1_rs2_rdata[29:0], 2'b00} : s1_rs2_rdata));
	assign oprb_src_rs2 = n_s2_opr_src[mypackage_DIS_OPRB_RS2];
	wire oprb_src_imm = n_s2_opr_src[mypackage_DIS_OPRB_IMM];
	wire oprb_ld_en = n_s2_valid && ((oprb_src_rs2 || oprb_src_imm) || oprb_src_zero);
	assign n_s2_opr_b = (({mypackage_XLEN {oprb_src_zero}} & {mypackage_XLEN {1'b0}}) | ({mypackage_XLEN {oprb_src_rs2}} & s1_rs2_shf)) | ({mypackage_XLEN {oprb_src_imm}} & n_s2_imm);
	assign oprc_src_rs2 = n_s2_opr_src[mypackage_DIS_OPRC_RS2];
	assign oprc_src_rs3 = n_s2_opr_src[mypackage_DIS_OPRC_RS3];
	wire oprc_src_csra = n_s2_opr_src[mypackage_DIS_OPRC_CSRA];
	wire oprc_src_pcim = n_s2_opr_src[mypackage_DIS_OPRC_PCIM];
	wire oprc_ld_en = n_s2_valid && (((oprc_src_rs2 || oprc_src_rs3) || oprc_src_csra) || oprc_src_pcim);
	assign n_s2_opr_c = ((({mypackage_XLEN {oprc_src_rs2}} & s1_rs2_rdata) | ({mypackage_XLEN {oprc_src_rs3}} & s1_rs3_rdata)) | ({mypackage_XLEN {oprc_src_csra}} & csr_addr)) | ({mypackage_XLEN {oprc_src_pcim}} & pc_plus_imm);
	localparam RL = 56;
	wire [55:0] p_mr;
	wire [mypackage_OP:0] bubble_uop = (leak_fence ? mypackage_RNG_ALFENCE : {5 {1'b0}});
	wire [mypackage_FU:0] bubble_fu = (leak_fence ? 8'b00000001 << mypackage_P_FU_RNG : {8 {1'b0}});
	wire [55:0] p_in = {(s1_bubble ? 5'b00000 : n_s2_rd), (s1_bubble ? bubble_uop : n_s2_uop), (s1_bubble ? bubble_fu : n_s2_fu), (s1_bubble ? {3 {1'b0}} : n_s2_pw), (s1_bubble ? 1'b0 : n_s2_trap), (leak_stall || s1_bubble ? 2'b00 : n_s2_size), (s1_bubble ? 32'b00000000000000000000000000000000 : n_s2_instr)};
	wire [55:0] p_out;
	assign {s2_rd, s2_uop, s2_fu, s2_pw, s2_trap, s2_size, s2_instr} = p_out;
	frv_pipeline_register #(
		.BUFFER_HANDSHAKE(1'b0),
		.RLEN(RL)
	) i_decode_pipereg(
		.g_clk(g_clk),
		.g_resetn(g_resetn),
		.i_data(p_in),
		.i_valid(n_s2_valid),
		.o_busy(p_s2_busy),
		.mr_data(p_mr),
		.flush(s1_flush),
		.flush_dat({RL {1'b0}}),
		.o_data(p_out),
		.o_valid(s2_valid),
		.i_busy(s2_busy)
	);
	frv_pipeline_register #(
		.BUFFER_HANDSHAKE(1'b0),
		.RLEN(32)
	) i_decode_pipereg_opr_a(
		.g_clk(g_clk),
		.g_resetn(g_resetn),
		.i_data(n_s2_opr_a),
		.i_valid(opra_ld_en),
		.flush(opra_flush),
		.flush_dat(leak_prng),
		.o_data(s2_opr_a),
		.i_busy(s2_busy)
	);
	frv_pipeline_register #(
		.BUFFER_HANDSHAKE(1'b0),
		.RLEN(32)
	) i_decode_pipereg_opr_b(
		.g_clk(g_clk),
		.g_resetn(g_resetn),
		.i_data(n_s2_opr_b),
		.i_valid(oprb_ld_en),
		.flush(oprb_flush),
		.flush_dat(leak_prng),
		.o_data(s2_opr_b),
		.i_busy(s2_busy)
	);
	frv_pipeline_register #(
		.BUFFER_HANDSHAKE(1'b0),
		.RLEN(32)
	) i_decode_pipereg_opr_c(
		.g_clk(g_clk),
		.g_resetn(g_resetn),
		.i_data(n_s2_opr_c),
		.i_valid(oprc_ld_en),
		.flush(oprc_flush),
		.flush_dat(leak_prng),
		.o_data(s2_opr_c),
		.i_busy(s2_busy)
	);
endmodule
module frv_pipeline_execute (
	g_clk,
	g_resetn,
	s2_rd,
	s2_opr_a,
	s2_opr_b,
	s2_opr_c,
	s2_uop,
	s2_fu,
	s2_pw,
	s2_trap,
	s2_size,
	s2_instr,
	s2_busy,
	s2_valid,
	leak_prng,
	leak_lkgcfg,
	rng_req_valid,
	rng_req_op,
	rng_req_data,
	rng_req_ready,
	rng_rsp_valid,
	rng_rsp_status,
	rng_rsp_data,
	rng_rsp_ready,
	uxcrypto_ct,
	uxcrypto_b0,
	uxcrypto_b1,
	flush,
	fwd_s2_rd,
	fwd_s2_wide,
	fwd_s2_wdata,
	fwd_s2_wdata_hi,
	fwd_s2_load,
	fwd_s2_csr,
	s3_rd,
	s3_opr_a,
	s3_opr_b,
	s3_uop,
	s3_fu,
	s3_trap,
	s3_size,
	s3_instr,
	s3_busy,
	s3_valid
);
	input g_clk;
	input g_resetn;
	input wire [4:0] s2_rd;
	localparam mypackage_XLEN = 32;
	localparam mypackage_XL = 31;
	input wire [mypackage_XL:0] s2_opr_a;
	input wire [mypackage_XL:0] s2_opr_b;
	input wire [mypackage_XL:0] s2_opr_c;
	localparam mypackage_OP = 4;
	input wire [mypackage_OP:0] s2_uop;
	localparam mypackage_FU = 7;
	input wire [mypackage_FU:0] s2_fu;
	localparam mypackage_PW = 2;
	input wire [mypackage_PW:0] s2_pw;
	input wire s2_trap;
	input wire [1:0] s2_size;
	input wire [31:0] s2_instr;
	output wire s2_busy;
	input wire s2_valid;
	input wire [mypackage_XL:0] leak_prng;
	input wire [12:0] leak_lkgcfg;
	output wire rng_req_valid;
	output wire [2:0] rng_req_op;
	output wire [31:0] rng_req_data;
	input wire rng_req_ready;
	input wire rng_rsp_valid;
	input wire [2:0] rng_rsp_status;
	input wire [31:0] rng_rsp_data;
	output wire rng_rsp_ready;
	input wire uxcrypto_ct;
	input wire [7:0] uxcrypto_b0;
	input wire [7:0] uxcrypto_b1;
	input wire flush;
	output wire [4:0] fwd_s2_rd;
	output wire fwd_s2_wide;
	output wire [mypackage_XL:0] fwd_s2_wdata;
	output wire [mypackage_XL:0] fwd_s2_wdata_hi;
	output wire fwd_s2_load;
	output wire fwd_s2_csr;
	output wire [4:0] s3_rd;
	output wire [mypackage_XL:0] s3_opr_a;
	output wire [mypackage_XL:0] s3_opr_b;
	output wire [mypackage_OP:0] s3_uop;
	output wire [mypackage_FU:0] s3_fu;
	output wire s3_trap;
	output wire [1:0] s3_size;
	output wire [31:0] s3_instr;
	input wire s3_busy;
	output wire s3_valid;
	wire cfu_cond;
	wire cond_beq;
	wire cond_bge;
	wire cond_bgeu;
	wire cond_blt;
	wire cond_bltu;
	wire cond_bne;
	wire leak_fence;
	wire p_busy;
	wire pipe_progress = !s2_busy && s2_valid;
	parameter XC_CLASS_RANDOMNESS = 1'b1;
	parameter XC_CLASS_MEMORY = 1'b1;
	parameter XC_CLASS_BIT = 1'b1;
	parameter XC_CLASS_PACKED = 1'b1;
	parameter XC_CLASS_MULTIARITH = 1'b1;
	parameter XC_CLASS_AES = 1'b1;
	parameter XC_CLASS_SHA2 = 1'b1;
	parameter XC_CLASS_SHA3 = 1'b1;
	parameter AES_SUB_FAST = 1'b0;
	parameter AES_MIX_FAST = 1'b0;
	parameter BITMANIP_BASELINE = 1'b1;
	localparam mypackage_P_FU_ALU = 0;
	wire fu_alu = s2_fu[mypackage_P_FU_ALU];
	localparam mypackage_P_FU_MUL = 1;
	wire fu_mul = s2_fu[mypackage_P_FU_MUL];
	localparam mypackage_P_FU_LSU = 2;
	wire fu_lsu = s2_fu[mypackage_P_FU_LSU];
	localparam mypackage_P_FU_CFU = 3;
	wire fu_cfu = s2_fu[mypackage_P_FU_CFU];
	localparam mypackage_P_FU_CSR = 4;
	wire fu_csr = s2_fu[mypackage_P_FU_CSR];
	localparam mypackage_P_FU_ASI = 6;
	wire fu_asi = s2_fu[mypackage_P_FU_ASI];
	localparam mypackage_P_FU_BIT = 5;
	wire fu_bit = s2_fu[mypackage_P_FU_BIT];
	localparam mypackage_P_FU_RNG = 7;
	wire fu_rng = s2_fu[mypackage_P_FU_RNG];
	wire alu_valid = fu_alu;
	wire alu_flush = flush;
	wire alu_ready;
	localparam mypackage_ALU_ADD = 5'b00001;
	wire alu_op_add = fu_alu && (s2_uop == mypackage_ALU_ADD);
	localparam mypackage_ALU_SUB = 5'b00000;
	wire alu_op_sub = fu_alu && (s2_uop == mypackage_ALU_SUB);
	localparam mypackage_ALU_XOR = 5'b01100;
	wire alu_op_xor = fu_alu && (s2_uop == mypackage_ALU_XOR);
	localparam mypackage_ALU_OR = 5'b01010;
	wire alu_op_or = fu_alu && (s2_uop == mypackage_ALU_OR);
	localparam mypackage_ALU_AND = 5'b01001;
	wire alu_op_and = fu_alu && (s2_uop == mypackage_ALU_AND);
	localparam mypackage_ALU_SLL = 5'b11100;
	localparam mypackage_ALU_SRA = 5'b11001;
	localparam mypackage_ALU_SRL = 5'b11010;
	wire alu_op_shf = fu_alu && (((s2_uop == mypackage_ALU_SLL) || (s2_uop == mypackage_ALU_SRL)) || (s2_uop == mypackage_ALU_SRA));
	localparam mypackage_ALU_ROR = 5'b11110;
	wire alu_op_rot = fu_alu && (s2_uop == mypackage_ALU_ROR);
	wire alu_op_shf_left = fu_alu && (s2_uop == mypackage_ALU_SLL);
	wire alu_op_shf_arith = fu_alu && (s2_uop == mypackage_ALU_SRA);
	localparam mypackage_ALU_SLT = 5'b10001;
	localparam mypackage_ALU_SLTU = 5'b10010;
	wire alu_op_cmp = (fu_alu && ((s2_uop == mypackage_ALU_SLT) || (s2_uop == mypackage_ALU_SLTU))) || cfu_cond;
	wire alu_op_unsigned = ((fu_alu && (s2_uop == mypackage_ALU_SLTU)) || cond_bgeu) || cond_bltu;
	wire alu_lt;
	wire alu_eq;
	wire [mypackage_XL:0] alu_add_result;
	localparam mypackage_PW_32 = 3'b100;
	wire [mypackage_PW:0] alu_pw = (XC_CLASS_PACKED ? s2_pw : mypackage_PW_32);
	wire [mypackage_XL:0] alu_lhs = s2_opr_a;
	wire [mypackage_XL:0] alu_rhs = s2_opr_b;
	wire [mypackage_XL:0] alu_result;
	wire [mypackage_XL:0] n_s3_opr_a_alu = alu_result;
	wire [mypackage_XL:0] n_s3_opr_b_alu = 32'b00000000000000000000000000000000;
	wire imul_valid = fu_mul;
	localparam mypackage_MUL_DIV = 5'b11000;
	wire imul_div = s2_uop == mypackage_MUL_DIV;
	localparam mypackage_MUL_DIVU = 5'b11001;
	wire imul_divu = s2_uop == mypackage_MUL_DIVU;
	localparam mypackage_MUL_MUL = 5'b01100;
	localparam mypackage_MUL_MULH = 5'b01110;
	wire imul_mul = (s2_uop == mypackage_MUL_MUL) || (s2_uop == mypackage_MUL_MULH);
	localparam mypackage_MUL_MULHSU = 5'b01111;
	wire imul_mulhsu = s2_uop == mypackage_MUL_MULHSU;
	localparam mypackage_MUL_MULHU = 5'b01101;
	wire imul_mulhu = s2_uop == mypackage_MUL_MULHU;
	localparam mypackage_MUL_REM = 5'b11100;
	wire imul_rem = s2_uop == mypackage_MUL_REM;
	localparam mypackage_MUL_REMU = 5'b11101;
	wire imul_remu = s2_uop == mypackage_MUL_REMU;
	localparam mypackage_MUL_PMUL_H = 5'b01001;
	localparam mypackage_MUL_PMUL_L = 5'b01000;
	wire imul_pmul = ((s2_uop == mypackage_MUL_PMUL_L) || (s2_uop == mypackage_MUL_PMUL_H)) && XC_CLASS_PACKED;
	localparam mypackage_MUL_PCLMUL_H = 5'b00111;
	localparam mypackage_MUL_PCLMUL_L = 5'b00101;
	wire imul_pclmul = ((s2_uop == mypackage_MUL_PCLMUL_L) || (s2_uop == mypackage_MUL_PCLMUL_H)) && XC_CLASS_PACKED;
	localparam mypackage_MUL_CLMUL_R = 5'b00100;
	wire imul_clmul_r = s2_uop == mypackage_MUL_CLMUL_R;
	localparam mypackage_MUL_CLMUL_H = 5'b00010;
	localparam mypackage_MUL_CLMUL_L = 5'b00001;
	wire imul_clmul = ((s2_uop == mypackage_MUL_CLMUL_L) || (s2_uop == mypackage_MUL_CLMUL_H)) || imul_clmul_r;
	localparam mypackage_MUL_MADD = 5'b10001;
	wire imul_madd = XC_CLASS_MULTIARITH && (s2_uop == mypackage_MUL_MADD);
	localparam mypackage_MUL_MSUB = 5'b10010;
	wire imul_msub = XC_CLASS_MULTIARITH && (s2_uop == mypackage_MUL_MSUB);
	localparam mypackage_MUL_MACC = 5'b10100;
	wire imul_macc = XC_CLASS_MULTIARITH && (s2_uop == mypackage_MUL_MACC);
	localparam mypackage_MUL_MMUL = 5'b10000;
	wire imul_mmul = XC_CLASS_MULTIARITH && (s2_uop == mypackage_MUL_MMUL);
	wire [31:0] imul_rs1 = s2_opr_a;
	wire [31:0] imul_rs2 = s2_opr_b;
	wire [31:0] imul_rs3 = s2_opr_c;
	localparam mypackage_LEAK_CFG_FU_MULT = 5;
	wire imul_flush = (pipe_progress || flush) || (leak_fence && leak_lkgcfg[mypackage_LEAK_CFG_FU_MULT]);
	localparam mypackage_PW_2 = 3'b000;
	wire imul_pw_2 = XC_CLASS_PACKED && (s2_pw == mypackage_PW_2);
	localparam mypackage_PW_4 = 3'b001;
	wire imul_pw_4 = XC_CLASS_PACKED && (s2_pw == mypackage_PW_4);
	localparam mypackage_PW_8 = 3'b010;
	wire imul_pw_8 = XC_CLASS_PACKED && (s2_pw == mypackage_PW_8);
	localparam mypackage_PW_16 = 3'b011;
	wire imul_pw_16 = XC_CLASS_PACKED && (s2_pw == mypackage_PW_16);
	wire imul_pw_32 = s2_pw == mypackage_PW_32;
	wire imul_ready;
	wire [63:0] imul_result_wide;
	wire imul_result_hi = (((((imul_mulhu || imul_mulhsu) || (s2_uop == mypackage_MUL_PMUL_H)) || (s2_uop == mypackage_MUL_MULH)) || (s2_uop == mypackage_MUL_PCLMUL_H)) || (s2_uop == mypackage_MUL_CLMUL_H)) || (s2_uop == mypackage_MUL_CLMUL_R);
	wire [31:0] imul_result = (imul_result_hi ? imul_result_wide[63:32] : imul_result_wide[31:0]);
	wire imul_gpr_wide = ((imul_madd || imul_msub) || imul_macc) || imul_mmul;
	wire [mypackage_XL:0] n_s3_opr_a_mul = (imul_clmul_r ? {1'b0, imul_result_wide[63:33]} : imul_result);
	wire [mypackage_XL:0] n_s3_opr_b_mul = imul_result_wide[63:32];
	wire lsu_valid = fu_lsu;
	wire lsu_a_error = 1'b0;
	wire lsu_ready = lsu_valid;
	localparam mypackage_LSU_LOAD = 3;
	wire lsu_load = fu_lsu && s2_uop[mypackage_LSU_LOAD];
	localparam mypackage_LSU_STORE = 4;
	wire lsu_store = fu_lsu && s2_uop[mypackage_LSU_STORE];
	wire [mypackage_XL:0] n_s3_opr_a_lsu = alu_add_result;
	wire [mypackage_XL:0] n_s3_opr_b_lsu = s2_opr_c;
	wire cfu_valid = fu_cfu;
	wire cfu_ready = cfu_valid;
	assign cfu_cond = cfu_valid && (s2_uop[4:3] == 2'b00);
	wire cfu_uncond = cfu_valid && (s2_uop[4:3] == 2'b10);
	localparam mypackage_CFU_JMP = 5'b10001;
	wire cfu_jmp = cfu_valid && (s2_uop == mypackage_CFU_JMP);
	localparam mypackage_CFU_JALI = 5'b10010;
	wire cfu_jali = cfu_valid && (s2_uop == mypackage_CFU_JALI);
	localparam mypackage_CFU_JALR = 5'b10100;
	wire cfu_jalr = cfu_valid && (s2_uop == mypackage_CFU_JALR);
	localparam mypackage_CFU_BEQ = 5'b00001;
	assign cond_beq = cfu_valid && (s2_uop == mypackage_CFU_BEQ);
	localparam mypackage_CFU_BGE = 5'b00010;
	assign cond_bge = cfu_valid && (s2_uop == mypackage_CFU_BGE);
	localparam mypackage_CFU_BGEU = 5'b00011;
	assign cond_bgeu = cfu_valid && (s2_uop == mypackage_CFU_BGEU);
	localparam mypackage_CFU_BLT = 5'b00100;
	assign cond_blt = cfu_valid && (s2_uop == mypackage_CFU_BLT);
	localparam mypackage_CFU_BLTU = 5'b00101;
	assign cond_bltu = cfu_valid && (s2_uop == mypackage_CFU_BLTU);
	localparam mypackage_CFU_BNE = 5'b00110;
	assign cond_bne = cfu_valid && (s2_uop == mypackage_CFU_BNE);
	wire cfu_cond_taken = (((((cond_beq && alu_eq) || (cond_bge && !alu_lt)) || (cond_bgeu && !alu_lt)) || (cond_blt && alu_lt)) || (cond_bltu && alu_lt)) || (cond_bne && !alu_eq);
	wire cfu_always_take = (cfu_jalr || cfu_jali) || cfu_jalr;
	localparam mypackage_CFU_NOT_TAKEN = 5'b11000;
	localparam mypackage_CFU_TAKEN = 5'b11001;
	wire [4:0] n_s3_uop_cfu = (cfu_cond ? (cfu_cond_taken ? mypackage_CFU_TAKEN : mypackage_CFU_NOT_TAKEN) : (cfu_always_take ? s2_uop : s2_uop));
	wire [mypackage_XL:0] n_s3_opr_a_cfu = (cfu_jalr ? {alu_add_result[mypackage_XL:1], 1'b0} : {s2_opr_c[mypackage_XL:1], 1'b0});
	wire [mypackage_XL:0] n_s3_opr_b_cfu = 32'b00000000000000000000000000000000;
	wire csr_valid = fu_csr;
	wire csr_ready = csr_valid;
	wire [mypackage_XL:0] n_s3_opr_a_csr = s2_opr_a;
	wire [mypackage_XL:0] n_s3_opr_b_csr = s2_opr_c;
	wire asi_valid = fu_asi;
	wire asi_ready;
	wire [mypackage_XL:0] asi_result;
	reg asi_done;
	wire asi_finished = (asi_valid && asi_ready) || asi_done;
	always @(posedge g_clk)
		if (!g_resetn)
			asi_done <= 1'b0;
		else
			asi_done <= (asi_done || (asi_valid && asi_ready)) && !pipe_progress;
	localparam mypackage_LEAK_CFG_FU_AESSUB = 6;
	wire asi_flush_aessub = leak_fence && leak_lkgcfg[mypackage_LEAK_CFG_FU_AESSUB];
	localparam mypackage_LEAK_CFG_FU_AESMIX = 7;
	wire asi_flush_aesmix = leak_fence && leak_lkgcfg[mypackage_LEAK_CFG_FU_AESMIX];
	wire [31:0] asi_flush_data = leak_prng;
	wire [mypackage_XL:0] n_s3_opr_a_asi = asi_result;
	wire [31:0] bitw_rs1 = s2_opr_a;
	wire [31:0] bitw_rs2 = s2_opr_b;
	wire [31:0] bitw_rs3 = s2_opr_c;
	wire [7:0] bitw_bop_lut = (s2_pw[0] ? uxcrypto_b1 : uxcrypto_b0);
	wire bitw_flush = flush || pipe_progress;
	wire bitw_valid = fu_bit;
	localparam mypackage_BIT_FSL = 5'b00000;
	wire bitw_fsl = fu_bit && (s2_uop == mypackage_BIT_FSL);
	localparam mypackage_BIT_FSR = 5'b00001;
	wire bitw_fsr = fu_bit && (s2_uop == mypackage_BIT_FSR);
	localparam mypackage_BIT_RORW = 5'b00011;
	wire bitw_mror = fu_bit && (s2_uop == mypackage_BIT_RORW);
	localparam mypackage_BIT_CMOV = 5'b11100;
	wire bitw_cmov = fu_bit && (s2_uop == mypackage_BIT_CMOV);
	localparam mypackage_BIT_LUT = 5'b11000;
	wire bitw_lut = (XC_CLASS_BIT && fu_bit) && (s2_uop == mypackage_BIT_LUT);
	localparam mypackage_BIT_BOP = 5'b11001;
	wire bitw_bop = (XC_CLASS_BIT && fu_bit) && (s2_uop == mypackage_BIT_BOP);
	wire [63:0] bitw_result_wide;
	wire bitw_ready;
	wire [31:0] n_s3_opr_a_bit = bitw_result_wide[31:0];
	wire [31:0] n_s3_opr_b_bit = bitw_result_wide[63:32];
	wire bitw_gpr_wide = bitw_mror;
	wire [mypackage_XL:0] rng_rs1 = s2_opr_a;
	localparam mypackage_RNG_ALFENCE = 5'b11010;
	wire rng_valid = (XC_CLASS_RANDOMNESS && fu_rng) && (s2_uop != mypackage_RNG_ALFENCE);
	localparam mypackage_RNG_RNGTEST = 5'b00100;
	wire rng_uop_test = (XC_CLASS_RANDOMNESS && fu_rng) && (s2_uop == mypackage_RNG_RNGTEST);
	localparam mypackage_RNG_RNGSEED = 5'b00001;
	wire rng_uop_seed = (XC_CLASS_RANDOMNESS && fu_rng) && (s2_uop == mypackage_RNG_RNGSEED);
	localparam mypackage_RNG_RNGSAMP = 5'b00010;
	wire rng_uop_samp = (XC_CLASS_RANDOMNESS && fu_rng) && (s2_uop == mypackage_RNG_RNGSAMP);
	wire rng_if_ready;
	wire rng_ready = rng_if_ready || leak_fence;
	wire [mypackage_XL:0] rng_result;
	wire [mypackage_XL:0] n_s3_opr_a_rng = rng_result;
	wire p_valid = s2_valid && !s2_busy;
	assign s2_busy = ((((p_busy || (asi_valid && !asi_finished)) || (lsu_valid && !lsu_ready)) || (rng_valid && !rng_ready)) || (imul_valid && !imul_ready)) || (bitw_valid && !bitw_ready);
	frv_asi #(
		.AES_SUB_FAST(AES_SUB_FAST),
		.AES_MIX_FAST(AES_MIX_FAST),
		.XC_CLASS_AES(XC_CLASS_AES),
		.XC_CLASS_SHA2(XC_CLASS_SHA2),
		.XC_CLASS_SHA3(XC_CLASS_SHA3)
	) i_asi(
		.g_clk(g_clk),
		.g_resetn(g_resetn),
		.asi_valid(asi_valid),
		.asi_ready(asi_ready),
		.asi_flush_aessub(asi_flush_aessub),
		.asi_flush_aesmix(asi_flush_aesmix),
		.asi_flush_data(asi_flush_data),
		.asi_uop(s2_uop),
		.asi_rs1(s2_opr_a),
		.asi_rs2(s2_opr_c),
		.asi_shamt(s2_opr_b[1:0]),
		.asi_result(asi_result)
	);
	frv_alu i_alu(
		.g_clk(g_clk),
		.g_resetn(g_resetn),
		.alu_valid(alu_valid),
		.alu_flush(alu_flush),
		.alu_ready(alu_ready),
		.alu_pw(alu_pw),
		.alu_op_add(alu_op_add),
		.alu_op_sub(alu_op_sub),
		.alu_op_xor(alu_op_xor),
		.alu_op_or(alu_op_or),
		.alu_op_and(alu_op_and),
		.alu_op_shf(alu_op_shf),
		.alu_op_rot(alu_op_rot),
		.alu_op_shf_left(alu_op_shf_left),
		.alu_op_shf_arith(alu_op_shf_arith),
		.alu_op_cmp(alu_op_cmp),
		.alu_op_unsigned(alu_op_unsigned),
		.alu_lt(alu_lt),
		.alu_eq(alu_eq),
		.alu_add_result(alu_add_result),
		.alu_lhs(alu_lhs),
		.alu_rhs(alu_rhs),
		.alu_result(alu_result)
	);
	xc_malu i_xc_malu(
		.clock(g_clk),
		.resetn(g_resetn),
		.rs1(imul_rs1),
		.rs2(imul_rs2),
		.rs3(imul_rs3),
		.flush(imul_flush),
		.flush_data(leak_prng),
		.valid(imul_valid),
		.uop_div(imul_div),
		.uop_divu(imul_divu),
		.uop_rem(imul_rem),
		.uop_remu(imul_remu),
		.uop_mul(imul_mul),
		.uop_mulu(imul_mulhu),
		.uop_mulsu(imul_mulhsu),
		.uop_clmul(imul_clmul),
		.uop_pmul(imul_pmul),
		.uop_pclmul(imul_pclmul),
		.uop_madd(imul_madd),
		.uop_msub(imul_msub),
		.uop_macc(imul_macc),
		.uop_mmul(imul_mmul),
		.pw_32(imul_pw_32),
		.pw_16(imul_pw_16),
		.pw_8(imul_pw_8),
		.pw_4(imul_pw_4),
		.pw_2(imul_pw_2),
		.result(imul_result_wide),
		.ready(imul_ready)
	);
	frv_bitwise #(.XC_CLASS_BIT(XC_CLASS_BIT)) i_frv_bitwise(
		.rs1(bitw_rs1),
		.rs2(bitw_rs2),
		.rs3(bitw_rs3),
		.bop_lut(bitw_bop_lut),
		.flush(bitw_flush),
		.valid(bitw_valid),
		.uop_fsl(bitw_fsl),
		.uop_fsr(bitw_fsr),
		.uop_mror(bitw_mror),
		.uop_cmov(bitw_cmov),
		.uop_lut(bitw_lut),
		.uop_bop(bitw_bop),
		.result(bitw_result_wide),
		.ready(bitw_ready)
	);
	frv_rngif i_frv_rngif(
		.g_clk(g_clk),
		.g_resetn(g_resetn),
		.flush(flush),
		.pipeline_progress(pipe_progress),
		.valid(rng_valid),
		.rs1(rng_rs1),
		.rng_req_valid(rng_req_valid),
		.rng_req_op(rng_req_op),
		.rng_req_data(rng_req_data),
		.rng_req_ready(rng_req_ready),
		.rng_rsp_valid(rng_rsp_valid),
		.rng_rsp_status(rng_rsp_status),
		.rng_rsp_data(rng_rsp_data),
		.rng_rsp_ready(rng_rsp_ready),
		.uop_test(rng_uop_test),
		.uop_seed(rng_uop_seed),
		.uop_samp(rng_uop_samp),
		.result(rng_result),
		.ready(rng_if_ready)
	);
	localparam RL = 53;
	assign leak_fence = fu_rng && (s2_uop == mypackage_RNG_ALFENCE);
	localparam mypackage_LEAK_CFG_S3_OPR_A = 3;
	wire opra_flush = (pipe_progress && leak_fence) && leak_lkgcfg[mypackage_LEAK_CFG_S3_OPR_A];
	localparam mypackage_LEAK_CFG_S3_OPR_B = 4;
	wire oprb_flush = (pipe_progress && leak_fence) && leak_lkgcfg[mypackage_LEAK_CFG_S3_OPR_B];
	wire [4:0] n_s3_rd = s2_rd;
	wire [mypackage_FU:0] n_s3_fu = s2_fu;
	wire [1:0] n_s3_size = s2_size;
	wire [31:0] n_s3_instr = s2_instr;
	wire [4:0] n_s3_uop = (cfu_valid ? n_s3_uop_cfu : s2_uop);
	wire n_s3_trap = s2_trap || (fu_lsu && lsu_a_error);
	localparam mypackage_TRAP_LDALIGN = 6'd4;
	localparam mypackage_TRAP_STALIGN = 6'd6;
	wire [5:0] n_trap_cause = (s2_trap ? {1'b0, s2_rd} : ((fu_lsu && lsu_a_error) && lsu_load ? mypackage_TRAP_LDALIGN : ((fu_lsu && lsu_a_error) && lsu_store ? mypackage_TRAP_STALIGN : 6'b000000)));
	wire [mypackage_XL:0] n_s3_opr_a = ((((((({mypackage_XLEN {fu_asi}} & n_s3_opr_a_asi) | ({mypackage_XLEN {fu_rng}} & n_s3_opr_a_rng)) | ({mypackage_XLEN {fu_alu}} & n_s3_opr_a_alu)) | ({mypackage_XLEN {fu_bit}} & n_s3_opr_a_bit)) | ({mypackage_XLEN {fu_mul}} & n_s3_opr_a_mul)) | ({mypackage_XLEN {fu_lsu}} & n_s3_opr_a_lsu)) | ({mypackage_XLEN {fu_cfu}} & n_s3_opr_a_cfu)) | ({mypackage_XLEN {fu_csr}} & n_s3_opr_a_csr);
	wire [mypackage_XL:0] n_s3_opr_b = (n_s3_trap ? {26'b00000000000000000000000000, n_trap_cause} : ((((({mypackage_XLEN {fu_alu}} & n_s3_opr_b_alu) | ({mypackage_XLEN {fu_bit}} & n_s3_opr_b_bit)) | ({mypackage_XLEN {fu_mul}} & n_s3_opr_b_mul)) | ({mypackage_XLEN {fu_lsu}} & n_s3_opr_b_lsu)) | ({mypackage_XLEN {fu_cfu}} & n_s3_opr_b_cfu)) | ({mypackage_XLEN {fu_csr}} & n_s3_opr_b_csr));
	wire opra_ld_en = p_valid && (((((((fu_alu || fu_mul) || fu_lsu) || fu_cfu) || fu_csr) || fu_asi) || fu_bit) || fu_rng);
	wire oprb_ld_en = p_valid && ((((fu_mul && imul_gpr_wide) || (fu_lsu && lsu_store)) || fu_csr) || (fu_bit && bitw_gpr_wide));
	assign fwd_s2_rd = s2_rd;
	assign fwd_s2_wdata = n_s3_opr_a;
	assign fwd_s2_wdata_hi = (fu_mul ? imul_result_wide[63:32] : n_s3_opr_b_bit);
	assign fwd_s2_wide = (fu_mul && imul_gpr_wide) || (fu_bit && bitw_gpr_wide);
	assign fwd_s2_load = fu_lsu && lsu_load;
	assign fwd_s2_csr = fu_csr;
	wire [52:0] pipe_reg_out;
	wire [52:0] pipe_reg_in = {n_s3_rd, n_s3_uop, n_s3_fu, n_s3_trap, n_s3_size, n_s3_instr};
	assign {s3_rd, s3_uop, s3_fu, s3_trap, s3_size, s3_instr} = pipe_reg_out;
	frv_pipeline_register #(
		.RLEN(RL),
		.BUFFER_HANDSHAKE(1'b0)
	) i_execute_pipe_reg(
		.g_clk(g_clk),
		.g_resetn(g_resetn),
		.i_data(pipe_reg_in),
		.i_valid(p_valid),
		.o_busy(p_busy),
		.flush(flush),
		.flush_dat({RL {1'b0}}),
		.o_data(pipe_reg_out),
		.o_valid(s3_valid),
		.i_busy(s3_busy)
	);
	frv_pipeline_register #(
		.RLEN(mypackage_XLEN),
		.BUFFER_HANDSHAKE(1'b0)
	) i_execute_pipe_reg_opr_a(
		.g_clk(g_clk),
		.g_resetn(g_resetn),
		.i_data(n_s3_opr_a),
		.i_valid(opra_ld_en),
		.flush(opra_flush),
		.flush_dat(leak_prng),
		.o_data(s3_opr_a),
		.i_busy(s3_busy)
	);
	frv_pipeline_register #(
		.RLEN(mypackage_XLEN),
		.BUFFER_HANDSHAKE(1'b0)
	) i_execute_pipe_reg_opr_b(
		.g_clk(g_clk),
		.g_resetn(g_resetn),
		.i_data(n_s3_opr_b),
		.i_valid(oprb_ld_en),
		.flush(oprb_flush),
		.flush_dat(leak_prng),
		.o_data(s3_opr_b),
		.i_busy(s3_busy)
	);
endmodule
module frv_pipeline_fetch (
	g_clk,
	g_resetn,
	cf_req,
	cf_target,
	cf_ack,
	imem_req,
	imem_wen,
	imem_strb,
	imem_wdata,
	imem_addr,
	imem_gnt,
	imem_ack,
	imem_recv,
	imem_error,
	imem_rdata,
	s0_flush,
	s1_busy,
	s1_valid,
	s1_data,
	s1_error
);
	input g_clk;
	input g_resetn;
	input wire cf_req;
	localparam mypackage_XLEN = 32;
	localparam mypackage_XL = 31;
	input wire [mypackage_XL:0] cf_target;
	output wire cf_ack;
	output reg imem_req;
	output wire imem_wen;
	output wire [3:0] imem_strb;
	output wire [mypackage_XL:0] imem_wdata;
	output reg [mypackage_XL:0] imem_addr;
	input wire imem_gnt;
	output wire imem_ack;
	input wire imem_recv;
	input wire imem_error;
	input wire [mypackage_XL:0] imem_rdata;
	input wire s0_flush;
	input wire s1_busy;
	output wire s1_valid;
	output wire [mypackage_XL:0] s1_data;
	output wire s1_error;
	parameter FRV_PC_RESET_VALUE = 32'h80000000;
	parameter FRV_MAX_REQS_OUTSTANDING = 1;
	wire buf_out_2;
	wire buf_out_4;
	wire buf_valid;
	wire buf_ready;
	assign s1_valid = buf_valid;
	assign cf_ack = !imem_req || (imem_req && imem_gnt);
	wire f_ready;
	wire f_4byte;
	wire f_2byte;
	wire buf_16;
	wire buf_32;
	wire [2:0] buf_depth;
	assign buf_ready = s1_valid && !s1_busy;
	wire rsp_recv;
	reg [2:0] ignore_rsps;
	wire [2:0] n_ignore_rsps;
	assign n_ignore_rsps = ignore_rsps - {2'b00, rsp_recv};
	wire drop_response = |ignore_rsps;
	reg [2:0] reqs_outstanding;
	wire [2:0] reqs_outstanding_add = {2'b00, imem_req && imem_gnt};
	wire [2:0] reqs_outstanding_sub = {2'b00, rsp_recv};
	wire [2:0] n_reqs_outstanding = (reqs_outstanding + reqs_outstanding_add) - reqs_outstanding_sub;
	wire cf_change = cf_req && cf_ack;
	wire progress_imem_addr = imem_req && imem_gnt;
	wire [mypackage_XL:0] n_imem_addr = imem_addr + 4;
	wire incomplete_instr = buf_32 && (buf_depth == 1);
	wire allow_new_mem_req = ((reqs_outstanding < FRV_MAX_REQS_OUTSTANDING) || (n_reqs_outstanding == 0)) || ((reqs_outstanding == FRV_MAX_REQS_OUTSTANDING) && (n_reqs_outstanding == FRV_MAX_REQS_OUTSTANDING));
	wire new_mem_req = f_ready || cf_change;
	wire n_imem_req = ((new_mem_req && allow_new_mem_req) || incomplete_instr) || (imem_req && !imem_gnt);
	always @(posedge g_clk)
		if (!g_resetn)
			imem_addr <= FRV_PC_RESET_VALUE;
		else if (cf_change)
			imem_addr <= {cf_target[31:2], 2'b00};
		else if (progress_imem_addr)
			imem_addr <= n_imem_addr;
	always @(posedge g_clk)
		if (!g_resetn)
			imem_req <= 1'b0;
		else
			imem_req <= n_imem_req;
	always @(posedge g_clk)
		if (!g_resetn)
			reqs_outstanding <= 3'b000;
		else
			reqs_outstanding <= n_reqs_outstanding;
	always @(posedge g_clk)
		if (!g_resetn)
			ignore_rsps <= 3'b000;
		else if (cf_change)
			ignore_rsps <= n_reqs_outstanding;
		else if (|ignore_rsps)
			ignore_rsps <= n_ignore_rsps;
	reg fetch_misaligned;
	wire n_fetch_misaligned = (cf_change ? cf_target[1] : fetch_misaligned && !f_2byte);
	always @(posedge g_clk)
		if (!g_resetn)
			fetch_misaligned <= 1'b0;
		else
			fetch_misaligned <= n_fetch_misaligned;
	assign rsp_recv = imem_recv && imem_ack;
	assign f_4byte = (rsp_recv && !fetch_misaligned) && !drop_response;
	assign f_2byte = (rsp_recv && fetch_misaligned) && !drop_response;
	assign imem_ack = f_ready;
	assign imem_wdata = 0;
	assign imem_strb = 0;
	assign imem_wen = 0;
	frv_core_fetch_buffer i_core_fetch_buffer(
		.g_clk(g_clk),
		.g_resetn(g_resetn),
		.flush(s0_flush),
		.f_ready(f_ready),
		.f_4byte(f_4byte),
		.f_2byte(f_2byte),
		.f_err(imem_error),
		.f_in(imem_rdata),
		.buf_depth(buf_depth),
		.buf_out(s1_data),
		.buf_16(buf_16),
		.buf_32(buf_32),
		.buf_out_2(buf_out_2),
		.buf_out_4(buf_out_4),
		.buf_err(s1_error),
		.buf_valid(buf_valid),
		.buf_ready(buf_ready)
	);
endmodule
module frv_pipeline_memory (
	g_clk,
	g_resetn,
	flush,
	s3_rd,
	s3_opr_a,
	s3_opr_b,
	s3_uop,
	s3_fu,
	s3_trap,
	s3_size,
	s3_instr,
	s3_busy,
	s3_valid,
	leak_prng,
	leak_lkgcfg,
	leak_fence_unc0,
	leak_fence_unc1,
	leak_fence_unc2,
	fwd_s3_rd,
	fwd_s3_wide,
	fwd_s3_wdata,
	fwd_s3_wdata_hi,
	fwd_s3_load,
	fwd_s3_csr,
	hold_lsu_req,
	mmio_en,
	mmio_wen,
	mmio_addr,
	mmio_wdata,
	dmem_req,
	dmem_wen,
	dmem_strb,
	dmem_wdata,
	dmem_addr,
	dmem_gnt,
	s4_rd,
	s4_opr_a,
	s4_opr_b,
	s4_uop,
	s4_fu,
	s4_trap,
	s4_size,
	s4_instr,
	s4_busy,
	s4_valid
);
	input g_clk;
	input g_resetn;
	input wire flush;
	input wire [4:0] s3_rd;
	localparam mypackage_XLEN = 32;
	localparam mypackage_XL = 31;
	input wire [mypackage_XL:0] s3_opr_a;
	input wire [mypackage_XL:0] s3_opr_b;
	localparam mypackage_OP = 4;
	input wire [mypackage_OP:0] s3_uop;
	localparam mypackage_FU = 7;
	input wire [mypackage_FU:0] s3_fu;
	input wire s3_trap;
	input wire [1:0] s3_size;
	input wire [31:0] s3_instr;
	output wire s3_busy;
	input wire s3_valid;
	input wire [mypackage_XL:0] leak_prng;
	input wire [12:0] leak_lkgcfg;
	output wire leak_fence_unc0;
	output wire leak_fence_unc1;
	output wire leak_fence_unc2;
	output wire [4:0] fwd_s3_rd;
	output wire fwd_s3_wide;
	output wire [mypackage_XL:0] fwd_s3_wdata;
	output wire [mypackage_XL:0] fwd_s3_wdata_hi;
	output wire fwd_s3_load;
	output wire fwd_s3_csr;
	input wire hold_lsu_req;
	output wire mmio_en;
	output wire mmio_wen;
	output wire [31:0] mmio_addr;
	output wire [31:0] mmio_wdata;
	output wire dmem_req;
	output wire dmem_wen;
	output wire [3:0] dmem_strb;
	output wire [mypackage_XL:0] dmem_wdata;
	output wire [mypackage_XL:0] dmem_addr;
	input wire dmem_gnt;
	output wire [4:0] s4_rd;
	output wire [mypackage_XL:0] s4_opr_a;
	output wire [mypackage_XL:0] s4_opr_b;
	output wire [mypackage_OP:0] s4_uop;
	output wire [mypackage_FU:0] s4_fu;
	output wire s4_trap;
	output wire [1:0] s4_size;
	output wire [31:0] s4_instr;
	input wire s4_busy;
	output wire s4_valid;
	parameter MMIO_BASE_ADDR = 32'h00001000;
	parameter MMIO_BASE_MASK = 32'hfffff000;
	wire p_busy;
	wire lsu_valid;
	wire lsu_a_error;
	wire lsu_ready;
	wire lsu_mmio;
	wire leak_fence;
	wire p_valid = s3_valid && !s3_busy;
	assign s3_busy = p_busy || (lsu_valid && !lsu_ready);
	wire pipe_progress = !s3_busy && s3_valid;
	localparam mypackage_P_FU_ALU = 0;
	wire fu_alu = s3_fu[mypackage_P_FU_ALU];
	localparam mypackage_P_FU_MUL = 1;
	wire fu_mul = s3_fu[mypackage_P_FU_MUL];
	localparam mypackage_P_FU_LSU = 2;
	wire fu_lsu = s3_fu[mypackage_P_FU_LSU];
	localparam mypackage_P_FU_CFU = 3;
	wire fu_cfu = s3_fu[mypackage_P_FU_CFU];
	localparam mypackage_P_FU_CSR = 4;
	wire fu_csr = s3_fu[mypackage_P_FU_CSR];
	localparam mypackage_P_FU_ASI = 6;
	wire fu_asi = s3_fu[mypackage_P_FU_ASI];
	localparam mypackage_P_FU_BIT = 5;
	wire fu_bit = s3_fu[mypackage_P_FU_BIT];
	localparam mypackage_P_FU_RNG = 7;
	wire fu_rng = s3_fu[mypackage_P_FU_RNG];
	localparam mypackage_LEAK_CFG_UNCORE_0 = 10;
	assign leak_fence_unc0 = (!hold_lsu_req && leak_fence) && leak_lkgcfg[mypackage_LEAK_CFG_UNCORE_0];
	localparam mypackage_LEAK_CFG_UNCORE_1 = 11;
	assign leak_fence_unc1 = (!hold_lsu_req && leak_fence) && leak_lkgcfg[mypackage_LEAK_CFG_UNCORE_1];
	localparam mypackage_LEAK_CFG_UNCORE_2 = 12;
	assign leak_fence_unc2 = (!hold_lsu_req && leak_fence) && leak_lkgcfg[mypackage_LEAK_CFG_UNCORE_2];
	assign lsu_valid = fu_lsu;
	localparam mypackage_LSU_LOAD = 3;
	wire lsu_load = s3_uop[mypackage_LSU_LOAD];
	localparam mypackage_LSU_STORE = 4;
	wire lsu_store = s3_uop[mypackage_LSU_STORE];
	wire [mypackage_XL:0] lsu_addr = s3_opr_a;
	wire [mypackage_XL:0] lsu_wdata = s3_opr_b;
	localparam mypackage_LSU_BYTE = 2'b01;
	wire lsu_byte = s3_uop[2:1] == mypackage_LSU_BYTE;
	localparam mypackage_LSU_HALF = 2'b10;
	wire lsu_half = s3_uop[2:1] == mypackage_LSU_HALF;
	localparam mypackage_LSU_WORD = 2'b11;
	wire lsu_word = s3_uop[2:1] == mypackage_LSU_WORD;
	localparam mypackage_LSU_SIGNED = 0;
	wire lsu_signed = s3_uop[mypackage_LSU_SIGNED];
	localparam mypackage_TRAP_LDALIGN = 6'd4;
	localparam mypackage_TRAP_STALIGN = 6'd6;
	wire [5:0] lsu_cause = (lsu_load && lsu_a_error ? mypackage_TRAP_LDALIGN : (lsu_store && lsu_a_error ? mypackage_TRAP_STALIGN : 0));
	wire [mypackage_XL:0] n_s4_opr_a_lsu = {27'b000000000000000000000000000, lsu_mmio, dmem_strb};
	wire [mypackage_XL:0] n_s4_opr_b_lsu = lsu_addr;
	wire n_s4_trap = s3_trap || (fu_lsu && lsu_a_error);
	wire [4:0] n_s4_rd = (s3_trap ? s3_rd : (fu_lsu && lsu_a_error ? lsu_cause[4:0] : s3_rd));
	localparam mypackage_MUL_MACC = 5'b10100;
	localparam mypackage_MUL_MADD = 5'b10001;
	localparam mypackage_MUL_MMUL = 5'b10000;
	localparam mypackage_MUL_MSUB = 5'b10010;
	wire imul_gpr_wide = fu_mul && ((((s3_uop == mypackage_MUL_MADD) || (s3_uop == mypackage_MUL_MSUB)) || (s3_uop == mypackage_MUL_MACC)) || (s3_uop == mypackage_MUL_MMUL));
	localparam mypackage_BIT_RORW = 5'b00011;
	wire bitw_gpr_wide = fu_bit && (s3_uop == mypackage_BIT_RORW);
	wire opra_ld_en = p_valid && (((((((fu_alu || fu_mul) || fu_lsu) || fu_cfu) || fu_csr) || fu_asi) || fu_bit) || fu_rng);
	wire oprb_ld_en = p_valid && ((fu_lsu || fu_csr) || fwd_s3_wide);
	wire [mypackage_XL:0] n_s4_opr_a = (lsu_valid ? n_s4_opr_a_lsu : s3_opr_a);
	wire [mypackage_XL:0] n_s4_opr_b = (lsu_valid ? n_s4_opr_b_lsu : s3_opr_b);
	wire [mypackage_OP:0] n_s4_uop = s3_uop;
	wire [mypackage_FU:0] n_s4_fu = s3_fu;
	wire [1:0] n_s4_size = s3_size;
	wire [31:0] n_s4_instr = s3_instr;
	assign fwd_s3_rd = s3_rd;
	assign fwd_s3_wdata = s3_opr_a;
	assign fwd_s3_wdata_hi = s3_opr_b;
	assign fwd_s3_wide = imul_gpr_wide || bitw_gpr_wide;
	assign fwd_s3_load = fu_lsu && lsu_load;
	assign fwd_s3_csr = fu_csr;
	frv_lsu #(
		.MMIO_BASE_ADDR(MMIO_BASE_ADDR),
		.MMIO_BASE_MASK(MMIO_BASE_MASK)
	) i_lsu(
		.g_clk(g_clk),
		.g_resetn(g_resetn),
		.lsu_valid(lsu_valid),
		.lsu_a_error(lsu_a_error),
		.lsu_ready(lsu_ready),
		.lsu_mmio(lsu_mmio),
		.pipe_prog(pipe_progress),
		.lsu_addr(lsu_addr),
		.lsu_wdata(lsu_wdata),
		.lsu_load(lsu_load),
		.lsu_store(lsu_store),
		.lsu_byte(lsu_byte),
		.lsu_half(lsu_half),
		.lsu_word(lsu_word),
		.lsu_signed(lsu_signed),
		.hold_lsu_req(hold_lsu_req),
		.mmio_en(mmio_en),
		.mmio_wen(mmio_wen),
		.mmio_addr(mmio_addr),
		.mmio_wdata(mmio_wdata),
		.dmem_req(dmem_req),
		.dmem_wen(dmem_wen),
		.dmem_strb(dmem_strb),
		.dmem_wdata(dmem_wdata),
		.dmem_addr(dmem_addr),
		.dmem_gnt(dmem_gnt)
	);
	localparam RL = 53;
	localparam mypackage_RNG_ALFENCE = 5'b11010;
	assign leak_fence = fu_rng && (s3_uop == mypackage_RNG_ALFENCE);
	localparam mypackage_LEAK_CFG_S4_OPR_A = 8;
	wire opra_flush = (pipe_progress && leak_fence) && leak_lkgcfg[mypackage_LEAK_CFG_S4_OPR_A];
	localparam mypackage_LEAK_CFG_S4_OPR_B = 9;
	wire oprb_flush = (pipe_progress && leak_fence) && leak_lkgcfg[mypackage_LEAK_CFG_S4_OPR_B];
	wire [52:0] pipe_reg_out;
	wire [52:0] pipe_reg_in = {n_s4_rd, n_s4_uop, n_s4_fu, n_s4_trap, n_s4_size, n_s4_instr};
	assign {s4_rd, s4_uop, s4_fu, s4_trap, s4_size, s4_instr} = pipe_reg_out;
	frv_pipeline_register #(
		.RLEN(RL),
		.BUFFER_HANDSHAKE(1'b0)
	) i_mem_pipereg(
		.g_clk(g_clk),
		.g_resetn(g_resetn),
		.i_data(pipe_reg_in),
		.i_valid(p_valid),
		.o_busy(p_busy),
		.flush(flush),
		.flush_dat({RL {1'b0}}),
		.o_data(pipe_reg_out),
		.o_valid(s4_valid),
		.i_busy(s4_busy)
	);
	frv_pipeline_register #(
		.RLEN(mypackage_XLEN),
		.BUFFER_HANDSHAKE(1'b0)
	) i_mem_pipereg_opr_a(
		.g_clk(g_clk),
		.g_resetn(g_resetn),
		.i_data(n_s4_opr_a),
		.i_valid(opra_ld_en),
		.flush(opra_flush),
		.flush_dat(leak_prng),
		.o_data(s4_opr_a),
		.i_busy(s4_busy)
	);
	frv_pipeline_register #(
		.RLEN(mypackage_XLEN),
		.BUFFER_HANDSHAKE(1'b0)
	) i_mem_pipereg_opr_b(
		.g_clk(g_clk),
		.g_resetn(g_resetn),
		.i_data(n_s4_opr_b),
		.i_valid(oprb_ld_en),
		.flush(oprb_flush),
		.flush_dat(leak_prng),
		.o_data(s4_opr_b),
		.i_busy(s4_busy)
	);
endmodule
module frv_pipeline_register (
	g_clk,
	g_resetn,
	i_data,
	i_valid,
	o_busy,
	mr_data,
	flush,
	flush_dat,
	o_data,
	o_valid,
	i_busy
);
	parameter RLEN = 8;
	parameter BUFFER_HANDSHAKE = 0;
	input wire g_clk;
	input wire g_resetn;
	input wire [RLEN - 1:0] i_data;
	input wire i_valid;
	output wire o_busy;
	output wire [RLEN - 1:0] mr_data;
	input wire flush;
	input wire [RLEN - 1:0] flush_dat;
	output reg [RLEN - 1:0] o_data;
	output wire o_valid;
	input wire i_busy;
	generate
		if (BUFFER_HANDSHAKE == 0) begin : genblk1
			assign o_busy = i_busy;
			assign o_valid = i_valid;
			assign mr_data = o_data;
			wire progress = i_valid && !i_busy;
			always @(posedge g_clk)
				if (!g_resetn)
					o_data <= {RLEN {1'b0}};
				else if (flush)
					o_data <= flush_dat;
				else if (progress)
					o_data <= i_data;
		end
		else begin : genblk1
			reg [RLEN - 1:0] b_data;
			reg b_full;
			reg ro_busy;
			reg ro_valid;
			assign o_busy = ro_busy;
			assign o_valid = ro_valid;
			assign mr_data = (b_full ? b_data : o_data);
			always @(posedge g_clk)
				if (!g_resetn) begin
					b_full <= 0;
					ro_busy <= 0;
					ro_valid <= 0;
					o_data <= 0;
				end
				else if (flush) begin
					b_full <= 0;
					ro_busy <= 0;
					ro_valid <= 0;
					b_data <= flush_dat;
					o_data <= flush_dat;
				end
				else if (!i_busy) begin
					if (!b_full) begin
						ro_valid <= i_valid;
						o_data <= i_data;
					end
					else begin
						ro_valid <= 1'b1;
						o_data <= b_data;
					end
					ro_busy <= 1'b0;
					b_full <= 1'b0;
				end
				else if (!ro_valid) begin
					ro_busy <= 1'b0;
					ro_valid <= i_valid;
					o_data <= i_data;
					b_full <= 1'b0;
				end
				else if (i_valid && !ro_busy) begin
					b_full <= i_valid && ro_valid;
					ro_busy <= i_valid && ro_valid;
				end
			always @(posedge g_clk)
				if (!g_resetn)
					b_data <= 0;
				else if (!o_busy)
					b_data <= i_data;
		end
	endgenerate
endmodule
module frv_pipeline (
	g_clk,
	g_resetn,
	trs_pc,
	trs_instr,
	trs_valid,
	leak_prng,
	leak_fence_unc0,
	leak_fence_unc1,
	leak_fence_unc2,
	rng_req_valid,
	rng_req_op,
	rng_req_data,
	rng_req_ready,
	rng_rsp_valid,
	rng_rsp_status,
	rng_rsp_data,
	rng_rsp_ready,
	instr_ret,
	mstatus_mie,
	mie_meie,
	mie_mtie,
	mie_msie,
	mip_meip,
	mip_mtip,
	mip_msip,
	ctr_time,
	ctr_cycle,
	ctr_instret,
	int_trap_req,
	int_trap_cause,
	int_trap_ack,
	inhibit_cy,
	inhibit_tm,
	inhibit_ir,
	mmio_en,
	mmio_wen,
	mmio_addr,
	mmio_wdata,
	mmio_rdata,
	mmio_error,
	imem_req,
	imem_wen,
	imem_strb,
	imem_wdata,
	imem_addr,
	imem_gnt,
	imem_recv,
	imem_ack,
	imem_error,
	imem_rdata,
	dmem_req,
	dmem_wen,
	dmem_strb,
	dmem_wdata,
	dmem_addr,
	dmem_gnt,
	dmem_recv,
	dmem_ack,
	dmem_error,
	dmem_rdata
);
	input g_clk;
	input g_resetn;
	localparam mypackage_XLEN = 32;
	localparam mypackage_XL = 31;
	output wire [mypackage_XL:0] trs_pc;
	output wire [31:0] trs_instr;
	output wire trs_valid;
	output wire [mypackage_XL:0] leak_prng;
	output wire leak_fence_unc0;
	output wire leak_fence_unc1;
	output wire leak_fence_unc2;
	output wire rng_req_valid;
	output wire [2:0] rng_req_op;
	output wire [31:0] rng_req_data;
	input wire rng_req_ready;
	input wire rng_rsp_valid;
	input wire [2:0] rng_rsp_status;
	input wire [31:0] rng_rsp_data;
	output wire rng_rsp_ready;
	output wire instr_ret;
	output wire mstatus_mie;
	output wire mie_meie;
	output wire mie_mtie;
	output wire mie_msie;
	input wire mip_meip;
	input wire mip_mtip;
	input wire mip_msip;
	input wire [63:0] ctr_time;
	input wire [63:0] ctr_cycle;
	input wire [63:0] ctr_instret;
	input wire int_trap_req;
	input wire [5:0] int_trap_cause;
	output wire int_trap_ack;
	output wire inhibit_cy;
	output wire inhibit_tm;
	output wire inhibit_ir;
	output wire mmio_en;
	output wire mmio_wen;
	output wire [31:0] mmio_addr;
	output wire [31:0] mmio_wdata;
	input wire [31:0] mmio_rdata;
	input wire mmio_error;
	output wire imem_req;
	output wire imem_wen;
	output wire [3:0] imem_strb;
	output wire [mypackage_XL:0] imem_wdata;
	output wire [mypackage_XL:0] imem_addr;
	input wire imem_gnt;
	input wire imem_recv;
	output wire imem_ack;
	input wire imem_error;
	input wire [mypackage_XL:0] imem_rdata;
	output wire dmem_req;
	output wire dmem_wen;
	output wire [3:0] dmem_strb;
	output wire [mypackage_XL:0] dmem_wdata;
	output wire [mypackage_XL:0] dmem_addr;
	input wire dmem_gnt;
	input wire dmem_recv;
	output wire dmem_ack;
	input wire dmem_error;
	input wire [mypackage_XL:0] dmem_rdata;
	parameter FRV_PC_RESET_VALUE = 32'h80000000;
	parameter BRAM_REGFILE = 0;
	parameter MMIO_BASE_ADDR = 32'h00001000;
	parameter MMIO_BASE_MASK = 32'hfffff000;
	parameter TRACE_INSTR_WORD = 1'b1;
	parameter XC_CLASS_BASELINE = 1'b1;
	parameter XC_CLASS_RANDOMNESS = 1'b1 && XC_CLASS_BASELINE;
	parameter XC_CLASS_MEMORY = 1'b1 && XC_CLASS_BASELINE;
	parameter XC_CLASS_BIT = 1'b1 && XC_CLASS_BASELINE;
	parameter XC_CLASS_PACKED = 1'b1 && XC_CLASS_BASELINE;
	parameter XC_CLASS_MULTIARITH = 1'b1 && XC_CLASS_BASELINE;
	parameter XC_CLASS_AES = 1'b1 && XC_CLASS_BASELINE;
	parameter XC_CLASS_SHA2 = 1'b1 && XC_CLASS_BASELINE;
	parameter XC_CLASS_SHA3 = 1'b1 && XC_CLASS_BASELINE;
	parameter XC_CLASS_LEAK = 1'b1 && XC_CLASS_BASELINE;
	parameter XC_CLASS_LEAK_STRONG = 1'b1 && XC_CLASS_LEAK;
	parameter XC_CLASS_LEAK_BUBBLE = 1'b1 && XC_CLASS_LEAK;
	parameter AES_SUB_FAST = 1'b0;
	parameter AES_MIX_FAST = 1'b0;
	parameter BITMANIP_BASELINE = 1'b1;
	parameter CSR_MIMPID = 32'b00000000000000000000000000000000;
	wire uxcrypto_ct;
	wire [7:0] uxcrypto_b0;
	wire [7:0] uxcrypto_b1;
	assign instr_ret = trs_valid;
	wire cf_req;
	wire [mypackage_XL:0] cf_target;
	wire cf_ack;
	wire [12:0] leak_lkgcfg;
	wire s1_leak_fence;
	wire csr_en;
	wire csr_wr;
	wire csr_wr_set;
	wire csr_wr_clr;
	wire [11:0] csr_addr;
	wire [mypackage_XL:0] csr_wdata;
	wire [mypackage_XL:0] csr_rdata;
	wire csr_error;
	wire [mypackage_XL:0] csr_mepc;
	wire [mypackage_XL:0] csr_mtvec;
	wire vector_intrs;
	wire exec_mret;
	wire trap_cpu;
	wire trap_int;
	wire [5:0] trap_cause;
	wire [mypackage_XL:0] trap_mtval;
	wire [mypackage_XL:0] trap_pc;
	wire s0_flush = cf_req && cf_ack;
	wire s1_flush = cf_req && cf_ack;
	wire s2_flush = cf_req && cf_ack;
	wire s3_flush = cf_req && cf_ack;
	wire s4_flush = cf_req && cf_ack;
	wire s0_busy;
	wire s1_valid;
	wire s1_busy;
	wire [mypackage_XL:0] s1_data;
	wire s1_error;
	wire [4:0] s1_rs1_addr;
	wire [4:0] s1_rs2_addr;
	wire [4:0] s1_rs3_addr;
	wire [mypackage_XL:0] s1_rs1_rdata;
	wire [mypackage_XL:0] s1_rs2_rdata;
	wire [mypackage_XL:0] s1_rs3_rdata;
	wire s2_valid;
	wire s2_busy;
	wire [4:0] s2_rd;
	wire [mypackage_XL:0] s2_opr_a;
	wire [mypackage_XL:0] s2_opr_b;
	wire [mypackage_XL:0] s2_opr_c;
	localparam mypackage_OP = 4;
	wire [mypackage_OP:0] s2_uop;
	localparam mypackage_FU = 7;
	wire [mypackage_FU:0] s2_fu;
	localparam mypackage_PW = 2;
	wire [mypackage_PW:0] s2_pw;
	wire s2_trap;
	wire [1:0] s2_size;
	wire [31:0] s2_instr;
	wire [4:0] fwd_s2_rd;
	wire fwd_s2_wide;
	wire [mypackage_XL:0] fwd_s2_wdata;
	wire [mypackage_XL:0] fwd_s2_wdata_hi;
	wire fwd_s2_load;
	wire fwd_s2_csr;
	wire [4:0] s3_rd;
	wire [mypackage_XL:0] s3_opr_a;
	wire [mypackage_XL:0] s3_opr_b;
	wire [mypackage_OP:0] s3_uop;
	wire [mypackage_FU:0] s3_fu;
	wire s3_trap;
	wire [1:0] s3_size;
	wire [31:0] s3_instr;
	wire s3_busy;
	wire s3_valid;
	wire [4:0] fwd_s3_rd;
	wire fwd_s3_wide;
	wire [mypackage_XL:0] fwd_s3_wdata;
	wire [mypackage_XL:0] fwd_s3_wdata_hi;
	wire fwd_s3_load;
	wire fwd_s3_csr;
	wire [4:0] s4_rd;
	wire [mypackage_XL:0] s4_opr_a;
	wire [mypackage_XL:0] s4_opr_b;
	wire [mypackage_OP:0] s4_uop;
	wire [mypackage_FU:0] s4_fu;
	wire s4_trap;
	wire [1:0] s4_size;
	wire [31:0] s4_instr;
	wire s4_busy;
	wire s4_valid;
	wire [4:0] fwd_s4_rd;
	wire [mypackage_XL:0] fwd_s4_wdata;
	wire fwd_s4_load;
	wire fwd_s4_csr;
	wire gpr_wen;
	wire gpr_wide;
	wire [4:0] gpr_rd;
	wire [mypackage_XL:0] gpr_wdata;
	wire [mypackage_XL:0] gpr_wdata_hi;
	wire hold_lsu_req;
	wire nz_s1_rs1 = |s1_rs1_addr;
	wire nz_s1_rs2 = |s1_rs2_addr;
	wire nz_s1_rs3 = |s1_rs3_addr;
	wire hzd_rs1_s4 = ((s1_rs1_addr[4:1] == fwd_s4_rd[4:1]) && (nz_s1_rs1 || (((!nz_s1_rs1 && s1_rs1_addr[0]) && !fwd_s4_rd[0]) && gpr_wide))) && ((s1_rs1_addr[0] == fwd_s4_rd[0]) || ((s1_rs1_addr[0] && !fwd_s4_rd[0]) && gpr_wide));
	wire hzd_rs1_s3 = ((s1_rs1_addr[4:1] == fwd_s3_rd[4:1]) && (nz_s1_rs1 || (((!nz_s1_rs1 && s1_rs1_addr[0]) && !fwd_s3_rd[0]) && fwd_s3_wide))) && ((s1_rs1_addr[0] == fwd_s3_rd[0]) || ((s1_rs1_addr[0] && !fwd_s3_rd[0]) && fwd_s3_wide));
	wire hzd_rs1_s2 = ((s1_rs1_addr[4:1] == fwd_s2_rd[4:1]) && (nz_s1_rs1 || (((!nz_s1_rs1 && s1_rs1_addr[0]) && !fwd_s2_rd[0]) && fwd_s2_wide))) && ((s1_rs1_addr[0] == fwd_s2_rd[0]) || ((s1_rs1_addr[0] && !fwd_s2_rd[0]) && fwd_s2_wide));
	wire hzd_rs2_s4 = ((s1_rs2_addr[4:1] == fwd_s4_rd[4:1]) && (nz_s1_rs2 || (((!nz_s1_rs2 && s1_rs2_addr[0]) && !fwd_s4_rd[0]) && gpr_wide))) && ((s1_rs2_addr[0] == fwd_s4_rd[0]) || ((s1_rs2_addr[0] && !fwd_s4_rd[0]) && gpr_wide));
	wire hzd_rs2_s3 = ((s1_rs2_addr[4:1] == fwd_s3_rd[4:1]) && (nz_s1_rs2 || (((!nz_s1_rs2 && s1_rs2_addr[0]) && !fwd_s3_rd[0]) && fwd_s3_wide))) && ((s1_rs2_addr[0] == fwd_s3_rd[0]) || ((s1_rs2_addr[0] && !fwd_s3_rd[0]) && fwd_s3_wide));
	wire hzd_rs2_s2 = ((s1_rs2_addr[4:1] == fwd_s2_rd[4:1]) && (nz_s1_rs2 || (((!nz_s1_rs2 && s1_rs2_addr[0]) && !fwd_s2_rd[0]) && fwd_s2_wide))) && ((s1_rs2_addr[0] == fwd_s2_rd[0]) || ((s1_rs2_addr[0] && !fwd_s2_rd[0]) && fwd_s2_wide));
	wire hzd_rs3_s4 = ((s1_rs3_addr[4:1] == fwd_s4_rd[4:1]) && (nz_s1_rs3 || (((!nz_s1_rs3 && s1_rs3_addr[0]) && !fwd_s4_rd[0]) && gpr_wide))) && ((s1_rs3_addr[0] == fwd_s4_rd[0]) || ((s1_rs3_addr[0] && !fwd_s4_rd[0]) && gpr_wide));
	wire hzd_rs3_s3 = ((s1_rs3_addr[4:1] == fwd_s3_rd[4:1]) && (nz_s1_rs3 || (((!nz_s1_rs3 && s1_rs3_addr[0]) && !fwd_s3_rd[0]) && fwd_s3_wide))) && ((s1_rs3_addr[0] == fwd_s3_rd[0]) || ((s1_rs3_addr[0] && !fwd_s3_rd[0]) && fwd_s3_wide));
	wire hzd_rs3_s2 = ((s1_rs3_addr[4:1] == fwd_s2_rd[4:1]) && (nz_s1_rs3 || (((!nz_s1_rs3 && s1_rs3_addr[0]) && !fwd_s2_rd[0]) && fwd_s2_wide))) && ((s1_rs3_addr[0] == fwd_s2_rd[0]) || ((s1_rs3_addr[0] && !fwd_s2_rd[0]) && fwd_s2_wide));
	wire fwd_s2_rs1_hi = s1_rs1_addr[0] && fwd_s2_wide;
	wire fwd_s3_rs1_hi = s1_rs1_addr[0] && fwd_s3_wide;
	wire fwd_s4_rs1_hi = s1_rs1_addr[0] && gpr_wide;
	wire fwd_s2_rs2_hi = s1_rs2_addr[0] && fwd_s2_wide;
	wire fwd_s3_rs2_hi = s1_rs2_addr[0] && fwd_s3_wide;
	wire fwd_s4_rs2_hi = s1_rs2_addr[0] && gpr_wide;
	wire fwd_s2_rs3_hi = s1_rs3_addr[0] && fwd_s2_wide;
	wire fwd_s3_rs3_hi = s1_rs3_addr[0] && fwd_s3_wide;
	wire fwd_s4_rs3_hi = s1_rs3_addr[0] && gpr_wide;
	wire s1_bubble_no_instr = !s1_valid && !s2_busy;
	wire s1_bubble_from_s4 = fwd_s4_csr || (fwd_s4_load && ((hzd_rs1_s4 || hzd_rs2_s4) || hzd_rs3_s4));
	wire s1_bubble_from_s3 = fwd_s3_csr || (fwd_s3_load && ((hzd_rs1_s3 || hzd_rs2_s3) || hzd_rs3_s3));
	wire s1_bubble_from_s2 = fwd_s2_csr || (fwd_s2_load && ((hzd_rs1_s2 || hzd_rs2_s2) || hzd_rs3_s2));
	wire s1_bubble = ((s1_bubble_no_instr || s1_bubble_from_s4) || s1_bubble_from_s3) || s1_bubble_from_s2;
	wire [mypackage_XL:0] fwd_rs1_rdata = (hzd_rs1_s2 ? (fwd_s2_rs1_hi ? fwd_s2_wdata_hi : fwd_s2_wdata) : (hzd_rs1_s3 ? (fwd_s3_rs1_hi ? fwd_s3_wdata_hi : fwd_s3_wdata) : (hzd_rs1_s4 ? (fwd_s4_rs1_hi ? gpr_wdata_hi : gpr_wdata) : s1_rs1_rdata)));
	wire [mypackage_XL:0] fwd_rs2_rdata = (hzd_rs2_s2 ? (fwd_s2_rs2_hi ? fwd_s2_wdata_hi : fwd_s2_wdata) : (hzd_rs2_s3 ? (fwd_s3_rs2_hi ? fwd_s3_wdata_hi : fwd_s3_wdata) : (hzd_rs2_s4 ? (fwd_s4_rs2_hi ? gpr_wdata_hi : gpr_wdata) : s1_rs2_rdata)));
	wire [mypackage_XL:0] fwd_rs3_rdata = (hzd_rs3_s2 ? (fwd_s2_rs3_hi ? fwd_s2_wdata_hi : fwd_s2_wdata) : (hzd_rs3_s3 ? (fwd_s3_rs3_hi ? fwd_s3_wdata_hi : fwd_s3_wdata) : (hzd_rs3_s4 ? (fwd_s4_rs3_hi ? gpr_wdata_hi : gpr_wdata) : s1_rs3_rdata)));
	frv_pipeline_fetch #(.FRV_PC_RESET_VALUE(FRV_PC_RESET_VALUE)) i_pipeline_s0_fetch(
		.g_clk(g_clk),
		.g_resetn(g_resetn),
		.cf_req(cf_req),
		.cf_target(cf_target),
		.cf_ack(cf_ack),
		.imem_req(imem_req),
		.imem_wen(imem_wen),
		.imem_strb(imem_strb),
		.imem_wdata(imem_wdata),
		.imem_addr(imem_addr),
		.imem_gnt(imem_gnt),
		.imem_ack(imem_ack),
		.imem_recv(imem_recv),
		.imem_error(imem_error),
		.imem_rdata(imem_rdata),
		.s0_flush(s0_flush),
		.s1_busy(s1_busy),
		.s1_valid(s1_valid),
		.s1_data(s1_data),
		.s1_error(s1_error)
	);
	frv_pipeline_decode #(
		.FRV_PC_RESET_VALUE(FRV_PC_RESET_VALUE),
		.TRACE_INSTR_WORD(TRACE_INSTR_WORD),
		.XC_CLASS_BASELINE(XC_CLASS_BASELINE),
		.XC_CLASS_RANDOMNESS(XC_CLASS_RANDOMNESS),
		.XC_CLASS_MEMORY(XC_CLASS_MEMORY),
		.XC_CLASS_BIT(XC_CLASS_BIT),
		.XC_CLASS_PACKED(XC_CLASS_PACKED),
		.XC_CLASS_MULTIARITH(XC_CLASS_MULTIARITH),
		.XC_CLASS_AES(XC_CLASS_AES),
		.XC_CLASS_SHA2(XC_CLASS_SHA2),
		.XC_CLASS_SHA3(XC_CLASS_SHA3),
		.XC_CLASS_LEAK(XC_CLASS_LEAK),
		.XC_CLASS_LEAK_STRONG(XC_CLASS_LEAK_STRONG),
		.XC_CLASS_LEAK_BUBBLE(XC_CLASS_LEAK_BUBBLE),
		.BITMANIP_BASELINE(BITMANIP_BASELINE)
	) i_pipeline_s1_decode(
		.g_clk(g_clk),
		.g_resetn(g_resetn),
		.s1_valid(s1_valid),
		.s1_busy(s1_busy),
		.s1_data(s1_data),
		.s1_error(s1_error),
		.s1_flush(s1_flush),
		.s1_bubble(s1_bubble),
		.s1_rs1_addr(s1_rs1_addr),
		.s1_rs2_addr(s1_rs2_addr),
		.s1_rs3_addr(s1_rs3_addr),
		.s1_rs1_rdata(fwd_rs1_rdata),
		.s1_rs2_rdata(fwd_rs2_rdata),
		.s1_rs3_rdata(fwd_rs3_rdata),
		.leak_prng(leak_prng),
		.leak_lkgcfg(leak_lkgcfg),
		.s1_leak_fence(s1_leak_fence),
		.cf_req(cf_req),
		.cf_target(cf_target),
		.cf_ack(cf_ack),
		.s2_valid(s2_valid),
		.s2_busy(s2_busy),
		.s2_rd(s2_rd),
		.s2_opr_a(s2_opr_a),
		.s2_opr_b(s2_opr_b),
		.s2_opr_c(s2_opr_c),
		.s2_uop(s2_uop),
		.s2_fu(s2_fu),
		.s2_pw(s2_pw),
		.s2_trap(s2_trap),
		.s2_size(s2_size),
		.s2_instr(s2_instr)
	);
	frv_pipeline_execute #(
		.XC_CLASS_RANDOMNESS(XC_CLASS_RANDOMNESS),
		.XC_CLASS_MEMORY(XC_CLASS_MEMORY),
		.XC_CLASS_BIT(XC_CLASS_BIT),
		.XC_CLASS_PACKED(XC_CLASS_PACKED),
		.XC_CLASS_MULTIARITH(XC_CLASS_MULTIARITH),
		.XC_CLASS_AES(XC_CLASS_AES),
		.XC_CLASS_SHA2(XC_CLASS_SHA2),
		.XC_CLASS_SHA3(XC_CLASS_SHA3),
		.AES_SUB_FAST(AES_SUB_FAST),
		.AES_MIX_FAST(AES_MIX_FAST),
		.BITMANIP_BASELINE(BITMANIP_BASELINE)
	) i_pipeline_s2_execute(
		.g_clk(g_clk),
		.g_resetn(g_resetn),
		.s2_rd(s2_rd),
		.s2_opr_a(s2_opr_a),
		.s2_opr_b(s2_opr_b),
		.s2_opr_c(s2_opr_c),
		.s2_uop(s2_uop),
		.s2_fu(s2_fu),
		.s2_pw(s2_pw),
		.s2_trap(s2_trap),
		.s2_size(s2_size),
		.s2_instr(s2_instr),
		.s2_busy(s2_busy),
		.s2_valid(s2_valid),
		.leak_prng(leak_prng),
		.leak_lkgcfg(leak_lkgcfg),
		.rng_req_valid(rng_req_valid),
		.rng_req_op(rng_req_op),
		.rng_req_data(rng_req_data),
		.rng_req_ready(rng_req_ready),
		.rng_rsp_valid(rng_rsp_valid),
		.rng_rsp_status(rng_rsp_status),
		.rng_rsp_data(rng_rsp_data),
		.rng_rsp_ready(rng_rsp_ready),
		.uxcrypto_ct(uxcrypto_ct),
		.uxcrypto_b0(uxcrypto_b0),
		.uxcrypto_b1(uxcrypto_b1),
		.flush(s2_flush),
		.fwd_s2_rd(fwd_s2_rd),
		.fwd_s2_wide(fwd_s2_wide),
		.fwd_s2_wdata(fwd_s2_wdata),
		.fwd_s2_wdata_hi(fwd_s2_wdata_hi),
		.fwd_s2_load(fwd_s2_load),
		.fwd_s2_csr(fwd_s2_csr),
		.s3_rd(s3_rd),
		.s3_opr_a(s3_opr_a),
		.s3_opr_b(s3_opr_b),
		.s3_uop(s3_uop),
		.s3_fu(s3_fu),
		.s3_trap(s3_trap),
		.s3_size(s3_size),
		.s3_instr(s3_instr),
		.s3_busy(s3_busy),
		.s3_valid(s3_valid)
	);
	frv_pipeline_memory #(
		.MMIO_BASE_ADDR(MMIO_BASE_ADDR),
		.MMIO_BASE_MASK(MMIO_BASE_MASK)
	) i_pipeline_s3_memory(
		.g_clk(g_clk),
		.g_resetn(g_resetn),
		.flush(s3_flush),
		.s3_rd(s3_rd),
		.s3_opr_a(s3_opr_a),
		.s3_opr_b(s3_opr_b),
		.s3_uop(s3_uop),
		.s3_fu(s3_fu),
		.s3_trap(s3_trap),
		.s3_size(s3_size),
		.s3_instr(s3_instr),
		.s3_busy(s3_busy),
		.s3_valid(s3_valid),
		.leak_prng(leak_prng),
		.leak_lkgcfg(leak_lkgcfg),
		.leak_fence_unc0(leak_fence_unc0),
		.leak_fence_unc1(leak_fence_unc1),
		.leak_fence_unc2(leak_fence_unc2),
		.fwd_s3_rd(fwd_s3_rd),
		.fwd_s3_wide(fwd_s3_wide),
		.fwd_s3_wdata(fwd_s3_wdata),
		.fwd_s3_wdata_hi(fwd_s3_wdata_hi),
		.fwd_s3_load(fwd_s3_load),
		.fwd_s3_csr(fwd_s3_csr),
		.hold_lsu_req(hold_lsu_req),
		.mmio_en(mmio_en),
		.mmio_wen(mmio_wen),
		.mmio_addr(mmio_addr),
		.mmio_wdata(mmio_wdata),
		.dmem_req(dmem_req),
		.dmem_wen(dmem_wen),
		.dmem_strb(dmem_strb),
		.dmem_wdata(dmem_wdata),
		.dmem_addr(dmem_addr),
		.dmem_gnt(dmem_gnt),
		.s4_rd(s4_rd),
		.s4_opr_a(s4_opr_a),
		.s4_opr_b(s4_opr_b),
		.s4_uop(s4_uop),
		.s4_fu(s4_fu),
		.s4_trap(s4_trap),
		.s4_size(s4_size),
		.s4_instr(s4_instr),
		.s4_busy(s4_busy),
		.s4_valid(s4_valid)
	);
	frv_pipeline_writeback #(.FRV_PC_RESET_VALUE(FRV_PC_RESET_VALUE)) i_pipeline_s4_writeback(
		.g_clk(g_clk),
		.g_resetn(g_resetn),
		.s4_rd(s4_rd),
		.s4_opr_a(s4_opr_a),
		.s4_opr_b(s4_opr_b),
		.s4_uop(s4_uop),
		.s4_fu(s4_fu),
		.s4_trap(s4_trap),
		.s4_size(s4_size),
		.s4_instr(s4_instr),
		.s4_busy(s4_busy),
		.s4_valid(s4_valid),
		.fwd_s4_rd(fwd_s4_rd),
		.fwd_s4_wdata(fwd_s4_wdata),
		.fwd_s4_load(fwd_s4_load),
		.fwd_s4_csr(fwd_s4_csr),
		.gpr_wen(gpr_wen),
		.gpr_wide(gpr_wide),
		.gpr_rd(gpr_rd),
		.gpr_wdata(gpr_wdata),
		.gpr_wdata_hi(gpr_wdata_hi),
		.int_trap_req(int_trap_req),
		.int_trap_cause(int_trap_cause),
		.int_trap_ack(int_trap_ack),
		.trap_cpu(trap_cpu),
		.trap_int(trap_int),
		.trap_cause(trap_cause),
		.trap_mtval(trap_mtval),
		.trap_pc(trap_pc),
		.exec_mret(exec_mret),
		.csr_mepc(csr_mepc),
		.csr_mtvec(csr_mtvec),
		.vector_intrs(vector_intrs),
		.trs_pc(trs_pc),
		.trs_instr(trs_instr),
		.trs_valid(trs_valid),
		.csr_en(csr_en),
		.csr_wr(csr_wr),
		.csr_wr_set(csr_wr_set),
		.csr_wr_clr(csr_wr_clr),
		.csr_addr(csr_addr),
		.csr_wdata(csr_wdata),
		.csr_rdata(csr_rdata),
		.csr_error(csr_error),
		.cf_req(cf_req),
		.cf_target(cf_target),
		.cf_ack(cf_ack),
		.hold_lsu_req(hold_lsu_req),
		.mmio_rdata(mmio_rdata),
		.mmio_error(mmio_error),
		.dmem_recv(dmem_recv),
		.dmem_ack(dmem_ack),
		.dmem_error(dmem_error),
		.dmem_rdata(dmem_rdata)
	);
	frv_csrs #(
		.XC_CLASS_BASELINE(XC_CLASS_BASELINE),
		.XC_CLASS_RANDOMNESS(XC_CLASS_RANDOMNESS),
		.XC_CLASS_MEMORY(XC_CLASS_MEMORY),
		.XC_CLASS_BIT(XC_CLASS_BIT),
		.XC_CLASS_PACKED(XC_CLASS_PACKED),
		.XC_CLASS_MULTIARITH(XC_CLASS_MULTIARITH),
		.XC_CLASS_AES(XC_CLASS_AES),
		.XC_CLASS_SHA2(XC_CLASS_SHA2),
		.XC_CLASS_SHA3(XC_CLASS_SHA3),
		.XC_CLASS_LEAK(XC_CLASS_LEAK),
		.BITMANIP_BASELINE(BITMANIP_BASELINE),
		.CSR_MIMPID(CSR_MIMPID)
	) i_csrs(
		.g_clk(g_clk),
		.g_resetn(g_resetn),
		.csr_en(csr_en),
		.csr_wr(csr_wr),
		.csr_wr_set(csr_wr_set),
		.csr_wr_clr(csr_wr_clr),
		.csr_addr(csr_addr),
		.csr_wdata(csr_wdata),
		.csr_rdata(csr_rdata),
		.csr_error(csr_error),
		.csr_mepc(csr_mepc),
		.csr_mtvec(csr_mtvec),
		.vector_intrs(vector_intrs),
		.exec_mret(exec_mret),
		.mstatus_mie(mstatus_mie),
		.mie_meie(mie_meie),
		.mie_mtie(mie_mtie),
		.mie_msie(mie_msie),
		.mip_meip(mip_meip),
		.mip_mtip(mip_mtip),
		.mip_msip(mip_msip),
		.ctr_time(ctr_time),
		.ctr_cycle(ctr_cycle),
		.ctr_instret(ctr_instret),
		.inhibit_cy(inhibit_cy),
		.inhibit_tm(inhibit_tm),
		.inhibit_ir(inhibit_ir),
		.uxcrypto_ct(uxcrypto_ct),
		.uxcrypto_b0(uxcrypto_b0),
		.uxcrypto_b1(uxcrypto_b1),
		.leak_lkgcfg(leak_lkgcfg),
		.trap_cpu(trap_cpu),
		.trap_int(trap_int),
		.trap_cause(trap_cause),
		.trap_mtval(trap_mtval),
		.trap_pc(trap_pc)
	);
	frv_gprs #(.BRAM_REGFILE(BRAM_REGFILE)) i_gprs(
		.g_clk(g_clk),
		.g_resetn(g_resetn),
		.rs1_addr(s1_rs1_addr),
		.rs1_data(s1_rs1_rdata),
		.rs2_addr(s1_rs2_addr),
		.rs2_data(s1_rs2_rdata),
		.rs3_addr(s1_rs3_addr),
		.rs3_data(s1_rs3_rdata),
		.rd_wen(gpr_wen),
		.rd_wide(gpr_wide),
		.rd_addr(gpr_rd),
		.rd_wdata(gpr_wdata),
		.rd_wdata_hi(gpr_wdata_hi)
	);
endmodule
module frv_pipeline_writeback (
	g_clk,
	g_resetn,
	s4_rd,
	s4_opr_a,
	s4_opr_b,
	s4_uop,
	s4_fu,
	s4_trap,
	s4_size,
	s4_instr,
	s4_busy,
	s4_valid,
	fwd_s4_rd,
	fwd_s4_wdata,
	fwd_s4_load,
	fwd_s4_csr,
	gpr_wen,
	gpr_wide,
	gpr_rd,
	gpr_wdata,
	gpr_wdata_hi,
	int_trap_req,
	int_trap_cause,
	int_trap_ack,
	trap_cpu,
	trap_int,
	trap_cause,
	trap_mtval,
	trap_pc,
	exec_mret,
	csr_mepc,
	csr_mtvec,
	vector_intrs,
	trs_pc,
	trs_instr,
	trs_valid,
	csr_en,
	csr_wr,
	csr_wr_set,
	csr_wr_clr,
	csr_addr,
	csr_wdata,
	csr_rdata,
	csr_error,
	cf_req,
	cf_target,
	cf_ack,
	hold_lsu_req,
	mmio_rdata,
	mmio_error,
	dmem_recv,
	dmem_ack,
	dmem_error,
	dmem_rdata
);
	input g_clk;
	input g_resetn;
	input wire [4:0] s4_rd;
	localparam mypackage_XLEN = 32;
	localparam mypackage_XL = 31;
	input wire [mypackage_XL:0] s4_opr_a;
	input wire [mypackage_XL:0] s4_opr_b;
	localparam mypackage_OP = 4;
	input wire [mypackage_OP:0] s4_uop;
	localparam mypackage_FU = 7;
	input wire [mypackage_FU:0] s4_fu;
	input wire s4_trap;
	input wire [1:0] s4_size;
	input wire [31:0] s4_instr;
	output wire s4_busy;
	input wire s4_valid;
	output wire [4:0] fwd_s4_rd;
	output wire [mypackage_XL:0] fwd_s4_wdata;
	output wire fwd_s4_load;
	output wire fwd_s4_csr;
	output wire gpr_wen;
	output wire gpr_wide;
	output wire [4:0] gpr_rd;
	output wire [mypackage_XL:0] gpr_wdata;
	output wire [mypackage_XL:0] gpr_wdata_hi;
	input wire int_trap_req;
	input wire [5:0] int_trap_cause;
	output wire int_trap_ack;
	output wire trap_cpu;
	output wire trap_int;
	output wire [5:0] trap_cause;
	output wire [mypackage_XL:0] trap_mtval;
	output wire [mypackage_XL:0] trap_pc;
	output wire exec_mret;
	input wire [mypackage_XL:0] csr_mepc;
	input wire [mypackage_XL:0] csr_mtvec;
	input wire vector_intrs;
	output wire [mypackage_XL:0] trs_pc;
	output wire [31:0] trs_instr;
	output wire trs_valid;
	output wire csr_en;
	output wire csr_wr;
	output wire csr_wr_set;
	output wire csr_wr_clr;
	output wire [11:0] csr_addr;
	output wire [mypackage_XL:0] csr_wdata;
	input wire [mypackage_XL:0] csr_rdata;
	input wire csr_error;
	output wire cf_req;
	output wire [mypackage_XL:0] cf_target;
	input wire cf_ack;
	output wire hold_lsu_req;
	input wire [31:0] mmio_rdata;
	input wire mmio_error;
	input wire dmem_recv;
	output wire dmem_ack;
	input wire dmem_error;
	input wire [mypackage_XL:0] dmem_rdata;
	wire fu_alu;
	wire fu_mul;
	wire fu_lsu;
	wire fu_cfu;
	wire fu_csr;
	wire fu_asi;
	wire fu_bit;
	wire fu_rng;
	wire cfu_busy;
	wire lsu_busy;
	wire lsu_trap;
	wire lsu_load;
	wire lsu_rsp_expected;
	wire [mypackage_XL:0] lsu_rdata;
	reg lsu_rsp_seen;
	parameter FRV_PC_RESET_VALUE = 32'h80000000;
	wire pipe_progress = s4_valid && !s4_busy;
	assign s4_busy = ((fu_cfu && cfu_busy) || (cf_req && !cf_ack)) || (fu_lsu && lsu_busy);
	assign hold_lsu_req = (cf_req || lsu_busy) || trap_int;
	reg [mypackage_XL:0] s4_pc;
	wire [mypackage_XL:0] n_s4_pc = s4_pc + {29'b00000000000000000000000000000, s4_size, 1'b0};
	always @(posedge g_clk)
		if (!g_resetn)
			s4_pc <= FRV_PC_RESET_VALUE;
		else if (cf_req && cf_ack)
			s4_pc <= cf_target;
		else if (pipe_progress)
			s4_pc <= n_s4_pc;
	localparam mypackage_P_FU_ALU = 0;
	assign fu_alu = s4_fu[mypackage_P_FU_ALU];
	localparam mypackage_P_FU_MUL = 1;
	assign fu_mul = s4_fu[mypackage_P_FU_MUL];
	localparam mypackage_P_FU_LSU = 2;
	assign fu_lsu = s4_fu[mypackage_P_FU_LSU];
	localparam mypackage_P_FU_CFU = 3;
	assign fu_cfu = s4_fu[mypackage_P_FU_CFU];
	localparam mypackage_P_FU_CSR = 4;
	assign fu_csr = s4_fu[mypackage_P_FU_CSR];
	localparam mypackage_P_FU_ASI = 6;
	assign fu_asi = s4_fu[mypackage_P_FU_ASI];
	localparam mypackage_P_FU_BIT = 5;
	assign fu_bit = s4_fu[mypackage_P_FU_BIT];
	localparam mypackage_P_FU_RNG = 7;
	assign fu_rng = s4_fu[mypackage_P_FU_RNG];
	wire alu_gpr_wen = fu_alu;
	wire [mypackage_XL:0] alu_gpr_wdata = s4_opr_a;
	wire mul_gpr_wen = fu_mul;
	wire [mypackage_XL:0] mul_gpr_wdata = s4_opr_a;
	wire asi_gpr_wen = fu_asi;
	wire [mypackage_XL:0] asi_gpr_wdata = s4_opr_a;
	wire bit_gpr_wen = fu_bit;
	wire [mypackage_XL:0] bit_gpr_wdata = s4_opr_a;
	localparam mypackage_RNG_RNGSAMP = 5'b00010;
	localparam mypackage_RNG_RNGTEST = 5'b00100;
	wire rng_gpr_wen = fu_rng && ((s4_uop == mypackage_RNG_RNGSAMP) || (s4_uop == mypackage_RNG_RNGTEST));
	wire [mypackage_XL:0] rng_gpr_wdata = s4_opr_a;
	reg csr_done;
	wire n_csr_done = !pipe_progress && (csr_done || csr_en);
	always @(posedge g_clk)
		if (!g_resetn)
			csr_done <= 1'b0;
		else
			csr_done <= n_csr_done;
	assign csr_en = fu_csr && !csr_done;
	localparam mypackage_CSR_WRITE = 3;
	assign csr_wr = fu_csr && s4_uop[mypackage_CSR_WRITE];
	localparam mypackage_CSR_SET = 2;
	assign csr_wr_set = fu_csr && s4_uop[mypackage_CSR_SET];
	localparam mypackage_CSR_CLEAR = 1;
	assign csr_wr_clr = fu_csr && s4_uop[mypackage_CSR_CLEAR];
	assign csr_addr = s4_opr_b[11:0];
	assign csr_wdata = s4_opr_a;
	localparam mypackage_CSR_READ = 4;
	wire csr_read = fu_csr && s4_uop[mypackage_CSR_READ];
	wire csr_trap = csr_error;
	wire csr_gpr_wen = csr_read && !csr_done;
	wire [mypackage_XL:0] csr_gpr_wdata = csr_rdata;
	localparam mypackage_CFU_JALI = 5'b10010;
	localparam mypackage_CFU_JALR = 5'b10100;
	localparam mypackage_CFU_TAKEN = 5'b11001;
	wire cfu_cf_taken = fu_cfu && (((s4_uop == mypackage_CFU_TAKEN) || (s4_uop == mypackage_CFU_JALI)) || (s4_uop == mypackage_CFU_JALR));
	localparam mypackage_CFU_EBREAK = 5'b01001;
	wire cfu_ebreak = fu_cfu && (s4_uop == mypackage_CFU_EBREAK);
	localparam mypackage_CFU_ECALL = 5'b01010;
	wire cfu_ecall = fu_cfu && (s4_uop == mypackage_CFU_ECALL);
	wire cfu_trap = cfu_ebreak || cfu_ecall;
	localparam mypackage_CFU_MRET = 5'b01100;
	wire cfu_mret = fu_cfu && (s4_uop == mypackage_CFU_MRET);
	assign exec_mret = cfu_mret && pipe_progress;
	wire cfu_tgt_trap = (((cfu_trap || s4_trap) || lsu_trap) || trap_int) || csr_trap;
	wire cfu_link = fu_cfu && ((s4_uop == mypackage_CFU_JALI) || (s4_uop == mypackage_CFU_JALR));
	wire cf_req_noint = ((((cfu_cf_taken || cfu_trap) || cfu_mret) || s4_trap) || lsu_trap) || csr_trap;
	assign cf_req = cf_req_noint || trap_int;
	wire cfu_finish_now = cf_req && cf_ack;
	wire [31:0] cf_target_noint = ({mypackage_XLEN {cfu_cf_taken}} & s4_opr_a) | ({mypackage_XLEN {cfu_mret}} & csr_mepc);
	wire [7:0] trap_vector_offset = (vector_intrs && trap_int ? {2'b00, int_trap_cause} << 2 : 8'b00000000);
	wire [mypackage_XL:0] trap_target_addr = {24'b000000000000000000000000, trap_vector_offset} | csr_mtvec;
	assign cf_target = (cfu_tgt_trap ? trap_target_addr : cf_target_noint);
	reg cfu_done;
	wire n_cfu_done = !pipe_progress && (cfu_done || cfu_finish_now);
	assign cfu_busy = (fu_cfu && !(cfu_done || cfu_finish_now)) && ((cfu_cf_taken || cfu_trap) || cfu_mret);
	always @(posedge g_clk)
		if (!g_resetn)
			cfu_done <= 1'b0;
		else
			cfu_done <= n_cfu_done;
	wire cfu_gpr_wen = cfu_link;
	wire [mypackage_XL:0] cfu_gpr_wdata = n_s4_pc;
	wire lsu_mmio = fu_lsu && s4_opr_a[4];
	wire lsu_txn_recv = ((lsu_load && dmem_recv) && dmem_ack) && lsu_rsp_expected;
	wire n_lsu_rsp_seen = !pipe_progress && ((lsu_rsp_seen || lsu_mmio) || (dmem_recv && dmem_ack));
	assign lsu_rsp_expected = (fu_lsu && !lsu_rsp_seen) && !lsu_mmio;
	assign dmem_ack = lsu_rsp_expected;
	wire lsu_gpr_wen = (((lsu_txn_recv && !dmem_error) || (lsu_mmio && !mmio_error)) && !lsu_rsp_seen) && lsu_load;
	wire [mypackage_XL:0] lsu_gpr_wdata = lsu_rdata;
	localparam mypackage_LSU_LOAD = 3;
	assign lsu_load = fu_lsu && s4_uop[mypackage_LSU_LOAD];
	localparam mypackage_LSU_STORE = 4;
	wire lsu_store = fu_lsu && s4_uop[mypackage_LSU_STORE];
	localparam mypackage_LSU_BYTE = 2'b01;
	wire lsu_byte = s4_uop[2:1] == mypackage_LSU_BYTE;
	localparam mypackage_LSU_HALF = 2'b10;
	wire lsu_half = s4_uop[2:1] == mypackage_LSU_HALF;
	localparam mypackage_LSU_WORD = 2'b11;
	wire lsu_word = s4_uop[2:1] == mypackage_LSU_WORD;
	localparam mypackage_LSU_SIGNED = 0;
	wire lsu_signed = s4_uop[mypackage_LSU_SIGNED];
	wire [mypackage_XL:0] lsu_addr = s4_opr_b;
	wire [3:0] lsu_strb = s4_opr_a[3:0];
	assign lsu_busy = fu_lsu && !((lsu_rsp_seen || (dmem_recv && dmem_ack)) || lsu_mmio);
	wire [31:0] mem_rdata = (lsu_mmio ? mmio_rdata : dmem_rdata);
	wire [7:0] rdata_b0 = (((({8 {lsu_strb[0]}} & mem_rdata[7:0]) | ({8 {lsu_byte && (lsu_addr[1:0] == 2'b01)}} & mem_rdata[15:8])) | ({8 {lsu_byte && (lsu_addr[1:0] == 2'b10)}} & mem_rdata[23:16])) | ({8 {lsu_half && (lsu_addr[1] == 1'b1)}} & mem_rdata[23:16])) | ({8 {lsu_byte && (lsu_addr[1:0] == 2'b11)}} & mem_rdata[31:24]);
	wire [7:0] rdata_b1 = ((({8 {lsu_byte && lsu_signed}} & {8 {rdata_b0[7]}}) | ({8 {lsu_half && (lsu_addr[1] == 1'b0)}} & mem_rdata[15:8])) | ({8 {lsu_word}} & mem_rdata[15:8])) | ({8 {lsu_half && (lsu_addr[1] == 1'b1)}} & mem_rdata[31:24]);
	wire [15:0] rdata_h1 = (({16 {lsu_byte && lsu_signed}} & {16 {rdata_b1[7]}}) | ({16 {lsu_half && lsu_signed}} & {16 {rdata_b1[7]}})) | ({16 {lsu_word}} & mem_rdata[31:16]);
	assign lsu_rdata = {rdata_h1, rdata_b1, rdata_b0};
	reg dmem_error_seen;
	wire n_dmem_error_seen = dmem_error_seen || ((lsu_rsp_expected && dmem_error) && dmem_recv);
	always @(posedge g_clk)
		if (!g_resetn)
			dmem_error_seen <= 1'b0;
		else if (pipe_progress)
			dmem_error_seen <= 1'b0;
		else
			dmem_error_seen <= n_dmem_error_seen;
	wire lsu_b_error = n_dmem_error_seen || (lsu_mmio && mmio_error);
	assign lsu_trap = lsu_b_error;
	always @(posedge g_clk)
		if (!g_resetn)
			lsu_rsp_seen <= 1'b0;
		else
			lsu_rsp_seen <= n_lsu_rsp_seen;
	assign gpr_rd = s4_rd;
	localparam mypackage_BIT_RORW = 5'b00011;
	localparam mypackage_MUL_MACC = 5'b10100;
	localparam mypackage_MUL_MADD = 5'b10001;
	localparam mypackage_MUL_MMUL = 5'b10000;
	localparam mypackage_MUL_MSUB = 5'b10010;
	assign gpr_wide = (fu_mul && ((((s4_uop == mypackage_MUL_MMUL) || (s4_uop == mypackage_MUL_MADD)) || (s4_uop == mypackage_MUL_MSUB)) || (s4_uop == mypackage_MUL_MACC))) || (fu_bit && (s4_uop == mypackage_BIT_RORW));
	assign gpr_wen = (!s4_trap && !trap_int) && (((((((csr_gpr_wen || alu_gpr_wen) || lsu_gpr_wen) || cfu_gpr_wen) || mul_gpr_wen) || asi_gpr_wen) || bit_gpr_wen) || rng_gpr_wen);
	assign gpr_wdata = ((((((({32 {csr_gpr_wen}} & csr_gpr_wdata) | ({32 {alu_gpr_wen}} & alu_gpr_wdata)) | ({32 {bit_gpr_wen}} & bit_gpr_wdata)) | ({32 {rng_gpr_wen}} & rng_gpr_wdata)) | ({32 {lsu_gpr_wen}} & lsu_gpr_wdata)) | ({32 {cfu_gpr_wen}} & cfu_gpr_wdata)) | ({32 {mul_gpr_wen}} & mul_gpr_wdata)) | ({32 {asi_gpr_wen}} & asi_gpr_wdata);
	assign gpr_wdata_hi = s4_opr_b;
	assign fwd_s4_rd = gpr_rd;
	assign fwd_s4_wdata = gpr_wdata;
	assign fwd_s4_load = fu_lsu && lsu_load;
	assign fwd_s4_csr = fu_csr;
	reg trap_int_pending;
	always @(posedge g_clk)
		if (!g_resetn)
			trap_int_pending <= 1'b0;
		else if (trap_int_pending)
			trap_int_pending <= !(cf_req && cf_ack);
		else
			trap_int_pending <= int_trap_req && !pipe_progress;
	assign int_trap_ack = 1'b0;
	assign trap_cpu = ((cfu_trap || lsu_trap) || s4_trap) || csr_trap;
	assign trap_int = ((int_trap_req || trap_int_pending) && !trap_cpu) && !lsu_rsp_expected;
	localparam mypackage_TRAP_BREAKPT = 6'd3;
	localparam mypackage_TRAP_ECALLM = 6'd11;
	localparam mypackage_TRAP_IOPCODE = 6'd2;
	localparam mypackage_TRAP_LDACCESS = 6'd5;
	localparam mypackage_TRAP_STACCESS = 6'd7;
	assign trap_cause = (lsu_b_error && lsu_load ? mypackage_TRAP_LDACCESS : (lsu_b_error && lsu_store ? mypackage_TRAP_STACCESS : (cfu_ebreak ? mypackage_TRAP_BREAKPT : (cfu_ecall ? mypackage_TRAP_ECALLM : (csr_error ? mypackage_TRAP_IOPCODE : (trap_int ? int_trap_cause : {1'b0, s4_rd}))))));
	assign trap_mtval = 32'b00000000000000000000000000000000;
	assign trap_pc = s4_pc;
	assign trs_pc = s4_pc;
	assign trs_instr = s4_instr;
	assign trs_valid = |s4_size && ((s4_valid && !s4_busy) || ((cf_req && cf_ack) && !cfu_done));
endmodule
module frv_rngif (
	g_clk,
	g_resetn,
	flush,
	pipeline_progress,
	valid,
	rs1,
	rng_req_valid,
	rng_req_op,
	rng_req_data,
	rng_req_ready,
	rng_rsp_valid,
	rng_rsp_status,
	rng_rsp_data,
	rng_rsp_ready,
	uop_test,
	uop_seed,
	uop_samp,
	result,
	ready
);
	input g_clk;
	input g_resetn;
	input wire flush;
	input wire pipeline_progress;
	input wire valid;
	localparam mypackage_XLEN = 32;
	localparam mypackage_XL = 31;
	input wire [mypackage_XL:0] rs1;
	output wire rng_req_valid;
	output wire [2:0] rng_req_op;
	output wire [31:0] rng_req_data;
	input wire rng_req_ready;
	input wire rng_rsp_valid;
	input wire [2:0] rng_rsp_status;
	input wire [31:0] rng_rsp_data;
	output wire rng_rsp_ready;
	input wire uop_test;
	input wire uop_seed;
	input wire uop_samp;
	output wire [mypackage_XL:0] result;
	output wire ready;
	assign rng_req_op = {uop_test, uop_samp, uop_seed};
	assign rng_req_data = rs1;
	reg req_done;
	wire n_req_done = (req_done || (rng_req_valid && rng_req_ready)) && !(flush || pipeline_progress);
	assign rng_req_valid = valid && !req_done;
	always @(posedge g_clk)
		if (!g_resetn)
			req_done <= 1'b0;
		else
			req_done <= n_req_done;
	assign ready = (valid && rng_rsp_valid) || req_done;
	assign rng_rsp_ready = pipeline_progress;
	localparam mypackage_RNG_IF_INIT_HEALTHY = 3'b101;
	wire status_healthy = rng_rsp_status == mypackage_RNG_IF_INIT_HEALTHY;
	assign result = (uop_samp ? rng_rsp_data : (uop_test ? {31'b0000000000000000000000000000000, status_healthy} : 32'b00000000000000000000000000000000));
endmodule
module frv_axi_adapter (
	g_clk,
	g_resetn,
	mem_axi_awvalid,
	mem_axi_awready,
	mem_axi_awaddr,
	mem_axi_awprot,
	mem_axi_wvalid,
	mem_axi_wready,
	mem_axi_wdata,
	mem_axi_wstrb,
	mem_axi_bvalid,
	mem_axi_bready,
	mem_axi_bresp,
	mem_axi_arvalid,
	mem_axi_arready,
	mem_axi_araddr,
	mem_axi_arprot,
	mem_axi_rvalid,
	mem_axi_rready,
	mem_axi_rdata,
	mem_axi_rresp,
	mem_req,
	mem_wen,
	mem_strb,
	mem_wdata,
	mem_addr,
	mem_gnt,
	mem_recv,
	mem_ack,
	mem_error,
	mem_rdata
);
	input g_clk;
	input g_resetn;
	output wire mem_axi_awvalid;
	input wire mem_axi_awready;
	output wire [31:0] mem_axi_awaddr;
	output wire [2:0] mem_axi_awprot;
	output wire mem_axi_wvalid;
	input wire mem_axi_wready;
	output wire [31:0] mem_axi_wdata;
	output wire [3:0] mem_axi_wstrb;
	input wire mem_axi_bvalid;
	output wire mem_axi_bready;
	input wire [1:0] mem_axi_bresp;
	output wire mem_axi_arvalid;
	input wire mem_axi_arready;
	output wire [31:0] mem_axi_araddr;
	output wire [2:0] mem_axi_arprot;
	input wire mem_axi_rvalid;
	output wire mem_axi_rready;
	input wire [31:0] mem_axi_rdata;
	input wire [1:0] mem_axi_rresp;
	input wire mem_req;
	input wire mem_wen;
	input wire [3:0] mem_strb;
	input wire [31:0] mem_wdata;
	input wire [31:0] mem_addr;
	output wire mem_gnt;
	output wire mem_recv;
	input wire mem_ack;
	output wire mem_error;
	output wire [31:0] mem_rdata;
	parameter INSTR_INTERFACE = 1'b0;
	parameter RSP_PRIORITY_WR = 1;
	assign mem_axi_awaddr = mem_addr;
	assign mem_axi_araddr = mem_addr;
	assign mem_axi_wdata = mem_wdata;
	assign mem_axi_wstrb = mem_strb;
	assign mem_axi_awprot = {INSTR_INTERFACE, 1'b0, 1'b0};
	assign mem_axi_arprot = {INSTR_INTERFACE, 1'b0, 1'b0};
	wire axi_write_req_done;
	wire axi_read_req_done;
	assign mem_gnt = ((mem_req && mem_wen) && axi_write_req_done) || ((mem_req && !mem_wen) && axi_read_req_done);
	reg aw_done;
	reg w_done;
	assign axi_write_req_done = (aw_done || (mem_axi_awvalid && mem_axi_awready)) && (w_done || (mem_axi_wvalid && mem_axi_wready));
	wire n_aw_done = !axi_write_req_done && (aw_done || (mem_axi_awvalid && mem_axi_awready));
	assign mem_axi_awvalid = (!aw_done && mem_req) && mem_wen;
	always @(posedge g_clk)
		if (!g_resetn)
			aw_done <= 1'b0;
		else
			aw_done <= n_aw_done;
	wire n_w_done = !axi_write_req_done && (w_done || (mem_axi_wvalid && mem_axi_wready));
	assign mem_axi_wvalid = (!w_done && mem_req) && mem_wen;
	always @(posedge g_clk)
		if (!g_resetn)
			w_done <= 1'b0;
		else
			w_done <= n_w_done;
	assign axi_read_req_done = mem_axi_arvalid && mem_axi_arready;
	assign mem_axi_arvalid = mem_req && !mem_wen;
	wire rsp_b_error = |mem_axi_bresp;
	wire rsp_r_error = |mem_axi_rresp;
	wire rsp_valid = (RSP_PRIORITY_WR ? (mem_axi_bvalid ? 1'b1 : (mem_axi_rvalid ? 1'b1 : 1'b0)) : (mem_axi_rvalid ? 1'b1 : (mem_axi_bvalid ? 1'b1 : 1'b0)));
	wire rsp_error = (RSP_PRIORITY_WR ? (mem_axi_bvalid ? rsp_b_error : (mem_axi_rvalid ? rsp_r_error : 1'b0)) : (mem_axi_rvalid ? rsp_r_error : (mem_axi_bvalid ? rsp_b_error : 1'b0)));
	assign mem_axi_bready = mem_ack;
	assign mem_axi_rready = mem_ack;
	assign mem_recv = rsp_valid;
	assign mem_error = rsp_error;
	assign mem_rdata = mem_axi_rdata;
endmodule
module axi_to_mem (
	axi4_mem_0_clock,
	axi4_mem_0_reset,
	axi4_mem_0_bits_aw_ready,
	axi4_mem_0_bits_aw_valid,
	axi4_mem_0_bits_aw_bits_id,
	axi4_mem_0_bits_aw_bits_addr,
	axi4_mem_0_bits_aw_bits_len,
	axi4_mem_0_bits_aw_bits_size,
	axi4_mem_0_bits_aw_bits_burst,
	axi4_mem_0_bits_aw_bits_lock,
	axi4_mem_0_bits_aw_bits_cache,
	axi4_mem_0_bits_aw_bits_prot,
	axi4_mem_0_bits_aw_bits_qos,
	axi4_mem_0_bits_w_ready,
	axi4_mem_0_bits_w_valid,
	axi4_mem_0_bits_w_bits_data,
	axi4_mem_0_bits_w_bits_strb,
	axi4_mem_0_bits_w_bits_last,
	axi4_mem_0_bits_b_ready,
	axi4_mem_0_bits_b_valid,
	axi4_mem_0_bits_b_bits_id,
	axi4_mem_0_bits_b_bits_resp,
	axi4_mem_0_bits_ar_ready,
	axi4_mem_0_bits_ar_valid,
	axi4_mem_0_bits_ar_bits_id,
	axi4_mem_0_bits_ar_bits_addr,
	axi4_mem_0_bits_ar_bits_len,
	axi4_mem_0_bits_ar_bits_size,
	axi4_mem_0_bits_ar_bits_burst,
	axi4_mem_0_bits_ar_bits_lock,
	axi4_mem_0_bits_ar_bits_cache,
	axi4_mem_0_bits_ar_bits_prot,
	axi4_mem_0_bits_ar_bits_qos,
	axi4_mem_0_bits_r_ready,
	axi4_mem_0_bits_r_valid,
	axi4_mem_0_bits_r_bits_id,
	axi4_mem_0_bits_r_bits_data,
	axi4_mem_0_bits_r_bits_resp,
	axi4_mem_0_bits_r_bits_last,
	req_o,
	we_o,
	addr_o,
	be_o,
	data_o,
	data_i
);
	parameter [31:0] AXI_ID_WIDTH = 4;
	parameter [31:0] AXI_ADDR_WIDTH = 32;
	parameter [31:0] AXI_DATA_WIDTH = 64;
	localparam [31:0] AXI_STRB_WIDTH = AXI_DATA_WIDTH >> 3;
	input wire axi4_mem_0_clock;
	input wire axi4_mem_0_reset;
	output reg axi4_mem_0_bits_aw_ready;
	input wire axi4_mem_0_bits_aw_valid;
	input wire [AXI_ID_WIDTH - 1:0] axi4_mem_0_bits_aw_bits_id;
	input wire [AXI_ADDR_WIDTH - 1:0] axi4_mem_0_bits_aw_bits_addr;
	input wire [7:0] axi4_mem_0_bits_aw_bits_len;
	input wire [2:0] axi4_mem_0_bits_aw_bits_size;
	input wire [1:0] axi4_mem_0_bits_aw_bits_burst;
	input wire axi4_mem_0_bits_aw_bits_lock;
	input wire [3:0] axi4_mem_0_bits_aw_bits_cache;
	input wire [2:0] axi4_mem_0_bits_aw_bits_prot;
	input wire [3:0] axi4_mem_0_bits_aw_bits_qos;
	output reg axi4_mem_0_bits_w_ready;
	input wire axi4_mem_0_bits_w_valid;
	input wire [AXI_DATA_WIDTH - 1:0] axi4_mem_0_bits_w_bits_data;
	input wire [AXI_STRB_WIDTH - 1:0] axi4_mem_0_bits_w_bits_strb;
	input wire axi4_mem_0_bits_w_bits_last;
	input wire axi4_mem_0_bits_b_ready;
	output reg axi4_mem_0_bits_b_valid;
	output reg [AXI_ID_WIDTH - 1:0] axi4_mem_0_bits_b_bits_id;
	output reg [1:0] axi4_mem_0_bits_b_bits_resp;
	output reg axi4_mem_0_bits_ar_ready;
	input wire axi4_mem_0_bits_ar_valid;
	input wire [AXI_ID_WIDTH - 1:0] axi4_mem_0_bits_ar_bits_id;
	input wire [AXI_ADDR_WIDTH - 1:0] axi4_mem_0_bits_ar_bits_addr;
	input wire [7:0] axi4_mem_0_bits_ar_bits_len;
	input wire [2:0] axi4_mem_0_bits_ar_bits_size;
	input wire [1:0] axi4_mem_0_bits_ar_bits_burst;
	input wire axi4_mem_0_bits_ar_bits_lock;
	input wire [3:0] axi4_mem_0_bits_ar_bits_cache;
	input wire [2:0] axi4_mem_0_bits_ar_bits_prot;
	input wire [3:0] axi4_mem_0_bits_ar_bits_qos;
	input wire axi4_mem_0_bits_r_ready;
	output reg axi4_mem_0_bits_r_valid;
	output reg [AXI_ID_WIDTH - 1:0] axi4_mem_0_bits_r_bits_id;
	output reg [AXI_DATA_WIDTH - 1:0] axi4_mem_0_bits_r_bits_data;
	output reg [1:0] axi4_mem_0_bits_r_bits_resp;
	output reg axi4_mem_0_bits_r_bits_last;
	output reg req_o;
	output reg we_o;
	output reg [AXI_ADDR_WIDTH - 1:0] addr_o;
	output reg [AXI_STRB_WIDTH - 1:0] be_o;
	output reg [AXI_DATA_WIDTH - 1:0] data_o;
	input wire [AXI_DATA_WIDTH - 1:0] data_i;
	wire clk_i;
	wire rst_ni;
	assign clk_i = axi4_mem_0_clock;
	assign rst_ni = ~axi4_mem_0_reset;
	localparam LOG_NR_BYTES = $clog2(AXI_DATA_WIDTH / 8);
	reg [2:0] state_d;
	reg [2:0] state_q;
	reg [(AXI_ID_WIDTH + AXI_ADDR_WIDTH) + 12:0] ax_req_d;
	reg [(AXI_ID_WIDTH + AXI_ADDR_WIDTH) + 12:0] ax_req_q;
	reg [AXI_ADDR_WIDTH - 1:0] req_addr_d;
	reg [AXI_ADDR_WIDTH - 1:0] req_addr_q;
	reg [7:0] cnt_d;
	reg [7:0] cnt_q;
	function automatic [AXI_ADDR_WIDTH - 1:0] get_wrap_boundary;
		input reg [AXI_ADDR_WIDTH - 1:0] unaligned_address;
		input reg [7:0] len;
		reg [AXI_ADDR_WIDTH - 1:0] warp_address;
		begin
			warp_address = '0;
			if (len == 4'b0001)
				warp_address[AXI_ADDR_WIDTH - 1:1 + LOG_NR_BYTES] = unaligned_address[AXI_ADDR_WIDTH - 1:1 + LOG_NR_BYTES];
			else if (len == 4'b0011)
				warp_address[AXI_ADDR_WIDTH - 1:2 + LOG_NR_BYTES] = unaligned_address[AXI_ADDR_WIDTH - 1:2 + LOG_NR_BYTES];
			else if (len == 4'b0111)
				warp_address[AXI_ADDR_WIDTH - 1:3 + LOG_NR_BYTES] = unaligned_address[AXI_ADDR_WIDTH - 3:2 + LOG_NR_BYTES];
			else if (len == 4'b1111)
				warp_address[AXI_ADDR_WIDTH - 1:4 + LOG_NR_BYTES] = unaligned_address[AXI_ADDR_WIDTH - 3:4 + LOG_NR_BYTES];
			get_wrap_boundary = warp_address;
		end
	endfunction
	reg [AXI_ADDR_WIDTH - 1:0] aligned_address;
	reg [AXI_ADDR_WIDTH - 1:0] wrap_boundary;
	reg [AXI_ADDR_WIDTH - 1:0] upper_wrap_boundary;
	reg [AXI_ADDR_WIDTH - 1:0] cons_addr;
	always @(*) begin
		aligned_address = {ax_req_q[(AXI_ADDR_WIDTH + 12) - ((AXI_ADDR_WIDTH - 1) - (AXI_ADDR_WIDTH - 1)):(AXI_ADDR_WIDTH + 12) - ((AXI_ADDR_WIDTH - 1) - LOG_NR_BYTES)], {{LOG_NR_BYTES} {1'b0}}};
		wrap_boundary = get_wrap_boundary(ax_req_q[AXI_ADDR_WIDTH + 12-:((AXI_ADDR_WIDTH + 12) >= 13 ? AXI_ADDR_WIDTH + 0 : 14 - (AXI_ADDR_WIDTH + 12))], ax_req_q[12-:8]);
		upper_wrap_boundary = wrap_boundary + ((ax_req_q[12-:8] + 1) << LOG_NR_BYTES);
		cons_addr = aligned_address + (cnt_q << LOG_NR_BYTES);
		state_d = state_q;
		ax_req_d = ax_req_q;
		req_addr_d = req_addr_q;
		cnt_d = cnt_q;
		data_o = axi4_mem_0_bits_w_bits_data;
		be_o = axi4_mem_0_bits_w_bits_strb;
		we_o = 1'b0;
		req_o = 1'b0;
		addr_o = '0;
		axi4_mem_0_bits_aw_ready = 1'b0;
		axi4_mem_0_bits_ar_ready = 1'b0;
		axi4_mem_0_bits_r_valid = 1'b0;
		axi4_mem_0_bits_r_bits_data = data_i;
		axi4_mem_0_bits_r_bits_resp = '0;
		axi4_mem_0_bits_r_bits_last = '0;
		axi4_mem_0_bits_r_bits_id = ax_req_q[AXI_ID_WIDTH + (AXI_ADDR_WIDTH + 12)-:((AXI_ID_WIDTH + (AXI_ADDR_WIDTH + 12)) >= (AXI_ADDR_WIDTH + 13) ? ((AXI_ID_WIDTH + (AXI_ADDR_WIDTH + 12)) - (AXI_ADDR_WIDTH + 13)) + 1 : ((AXI_ADDR_WIDTH + 13) - (AXI_ID_WIDTH + (AXI_ADDR_WIDTH + 12))) + 1)];
		axi4_mem_0_bits_w_ready = 1'b0;
		axi4_mem_0_bits_b_valid = 1'b0;
		axi4_mem_0_bits_b_bits_resp = 1'b0;
		axi4_mem_0_bits_b_bits_id = 1'b0;
		case (state_q)
			3'd0:
				if (axi4_mem_0_bits_ar_valid) begin
					axi4_mem_0_bits_ar_ready = 1'b1;
					ax_req_d = {axi4_mem_0_bits_ar_bits_id, axi4_mem_0_bits_ar_bits_addr, axi4_mem_0_bits_ar_bits_len, axi4_mem_0_bits_ar_bits_size, axi4_mem_0_bits_ar_bits_burst};
					state_d = 3'd1;
					req_o = 1'b1;
					addr_o = axi4_mem_0_bits_ar_bits_addr;
					req_addr_d = axi4_mem_0_bits_ar_bits_addr;
					cnt_d = 1;
				end
				else if (axi4_mem_0_bits_aw_valid) begin
					axi4_mem_0_bits_aw_ready = 1'b1;
					axi4_mem_0_bits_w_ready = 1'b1;
					addr_o = axi4_mem_0_bits_aw_bits_addr;
					ax_req_d = {axi4_mem_0_bits_aw_bits_id, axi4_mem_0_bits_aw_bits_addr, axi4_mem_0_bits_aw_bits_len, axi4_mem_0_bits_aw_bits_size, axi4_mem_0_bits_aw_bits_burst};
					if (axi4_mem_0_bits_w_valid) begin
						req_o = 1'b1;
						we_o = 1'b1;
						state_d = (axi4_mem_0_bits_w_bits_last ? 3'd3 : 3'd2);
						cnt_d = 1;
					end
					else
						state_d = 3'd4;
				end
			3'd4: begin
				axi4_mem_0_bits_w_ready = 1'b1;
				addr_o = ax_req_q[AXI_ADDR_WIDTH + 12-:((AXI_ADDR_WIDTH + 12) >= 13 ? AXI_ADDR_WIDTH + 0 : 14 - (AXI_ADDR_WIDTH + 12))];
				if (axi4_mem_0_bits_w_valid) begin
					req_o = 1'b1;
					we_o = 1'b1;
					state_d = (axi4_mem_0_bits_w_bits_last ? 3'd3 : 3'd2);
					cnt_d = 1;
				end
			end
			3'd1: begin
				req_o = 1'b1;
				addr_o = req_addr_q;
				axi4_mem_0_bits_r_valid = 1'b1;
				axi4_mem_0_bits_r_bits_data = data_i;
				axi4_mem_0_bits_r_bits_id = ax_req_q[AXI_ID_WIDTH + (AXI_ADDR_WIDTH + 12)-:((AXI_ID_WIDTH + (AXI_ADDR_WIDTH + 12)) >= (AXI_ADDR_WIDTH + 13) ? ((AXI_ID_WIDTH + (AXI_ADDR_WIDTH + 12)) - (AXI_ADDR_WIDTH + 13)) + 1 : ((AXI_ADDR_WIDTH + 13) - (AXI_ID_WIDTH + (AXI_ADDR_WIDTH + 12))) + 1)];
				axi4_mem_0_bits_r_bits_last = cnt_q == (ax_req_q[12-:8] + 1);
				if (axi4_mem_0_bits_r_ready) begin
					case (ax_req_q[1-:2])
						2'b00, 2'b01: addr_o = cons_addr;
						2'b10:
							if (cons_addr == upper_wrap_boundary)
								addr_o = wrap_boundary;
							else if (cons_addr > upper_wrap_boundary)
								addr_o = ax_req_q[AXI_ADDR_WIDTH + 12-:((AXI_ADDR_WIDTH + 12) >= 13 ? AXI_ADDR_WIDTH + 0 : 14 - (AXI_ADDR_WIDTH + 12))] + ((cnt_q - ax_req_q[12-:8]) << LOG_NR_BYTES);
							else
								addr_o = cons_addr;
					endcase
					if (axi4_mem_0_bits_r_bits_last) begin
						state_d = 3'd0;
						req_o = 1'b0;
					end
					req_addr_d = addr_o;
					cnt_d = cnt_q + 1;
				end
			end
			3'd2: begin
				axi4_mem_0_bits_w_ready = 1'b1;
				if (axi4_mem_0_bits_w_valid) begin
					req_o = 1'b1;
					we_o = 1'b1;
					case (ax_req_q[1-:2])
						2'b00, 2'b01: addr_o = cons_addr;
						2'b10:
							if (cons_addr == upper_wrap_boundary)
								addr_o = wrap_boundary;
							else if (cons_addr > upper_wrap_boundary)
								addr_o = ax_req_q[AXI_ADDR_WIDTH + 12-:((AXI_ADDR_WIDTH + 12) >= 13 ? AXI_ADDR_WIDTH + 0 : 14 - (AXI_ADDR_WIDTH + 12))] + ((cnt_q - ax_req_q[12-:8]) << LOG_NR_BYTES);
							else
								addr_o = cons_addr;
					endcase
					req_addr_d = addr_o;
					cnt_d = cnt_q + 1;
					if (axi4_mem_0_bits_w_bits_last)
						state_d = 3'd3;
				end
			end
			3'd3: begin
				axi4_mem_0_bits_b_valid = 1'b1;
				axi4_mem_0_bits_b_bits_id = ax_req_q[AXI_ID_WIDTH + (AXI_ADDR_WIDTH + 12)-:((AXI_ID_WIDTH + (AXI_ADDR_WIDTH + 12)) >= (AXI_ADDR_WIDTH + 13) ? ((AXI_ID_WIDTH + (AXI_ADDR_WIDTH + 12)) - (AXI_ADDR_WIDTH + 13)) + 1 : ((AXI_ADDR_WIDTH + 13) - (AXI_ID_WIDTH + (AXI_ADDR_WIDTH + 12))) + 1)];
				if (axi4_mem_0_bits_b_ready)
					state_d = 3'd0;
			end
		endcase
	end
	always @(posedge clk_i or negedge rst_ni)
		if (~rst_ni) begin
			state_q <= 3'd0;
			ax_req_q <= '0;
			req_addr_q <= '0;
			cnt_q <= '0;
		end
		else begin
			state_q <= state_d;
			ax_req_q <= ax_req_d;
			req_addr_q <= req_addr_d;
			cnt_q <= cnt_d;
		end
endmodule
module frv_mem_adapter (
	clk_i,
	rst_ni,
	out_mem_req,
	out_mem_gnt,
	out_mem_addr,
	out_mem_wdata,
	out_mem_strb,
	out_mem_we,
	out_mem_rdata,
	mem_req,
	mem_wen,
	mem_strb,
	mem_wdata,
	mem_addr,
	mem_gnt,
	mem_recv,
	mem_ack,
	mem_error,
	mem_rdata
);
	input clk_i;
	input rst_ni;
	output wire out_mem_req;
	input wire out_mem_gnt;
	output wire [31:0] out_mem_addr;
	output wire [31:0] out_mem_wdata;
	output wire [3:0] out_mem_strb;
	output wire out_mem_we;
	input wire [31:0] out_mem_rdata;
	input wire mem_req;
	input wire mem_wen;
	input wire [3:0] mem_strb;
	input wire [31:0] mem_wdata;
	input wire [31:0] mem_addr;
	output wire mem_gnt;
	output wire mem_recv;
	input wire mem_ack;
	output wire mem_error;
	output wire [31:0] mem_rdata;
	reg is_data_in_store_d;
	reg is_data_in_store_q;
	reg [31:0] stored_data_d;
	reg [31:0] stored_data_q;
	assign out_mem_addr = mem_addr;
	assign out_mem_wdata = mem_wdata;
	assign out_mem_strb = {{8 {mem_strb[3]}}, {8 {mem_strb[2]}}, {8 {mem_strb[1]}}, {8 {mem_strb[0]}}};
	assign out_mem_we = mem_wen;
	assign mem_error = '0;
	wire was_req_handshake_d;
	reg was_req_handshake_q;
	assign mem_gnt = mem_req && !(mem_recv && !mem_ack);
	assign was_req_handshake_d = mem_gnt;
	assign out_mem_req = mem_gnt;
	always @(*) begin
		is_data_in_store_d = is_data_in_store_q;
		if (is_data_in_store_q)
			if (mem_ack)
				is_data_in_store_d = '0;
		if (was_req_handshake_q)
			if (mem_ack)
				is_data_in_store_d = 1'b0;
			else begin
				is_data_in_store_d = 1'b1;
				stored_data_d = out_mem_rdata;
			end
	end
	assign mem_recv = is_data_in_store_q || was_req_handshake_q;
	assign mem_rdata = (was_req_handshake_q ? out_mem_rdata : stored_data_d);
	always @(posedge clk_i)
		if (~rst_ni) begin
			stored_data_q <= '0;
			is_data_in_store_q <= '0;
			was_req_handshake_q <= '0;
		end
		else begin
			stored_data_q <= stored_data_d;
			is_data_in_store_q <= is_data_in_store_d;
			was_req_handshake_q <= was_req_handshake_d;
		end
endmodule
module scarv_mem_top (
	clk_i,
	rst_ni,
	data_mem_req_o,
	data_mem_addr_o,
	data_mem_wdata_o,
	data_mem_strb_o,
	data_mem_we_o,
	data_mem_rdata_i,
	instr_mem_req_o,
	instr_mem_addr_o,
	instr_mem_wdata_o,
	instr_mem_strb_o,
	instr_mem_we_o,
	instr_mem_rdata_i,
	trs_pc_o,
	trs_instr_o,
	trs_valid_o,
	int_nmi_i,
	int_external_i,
	int_extern_cause_i,
	int_software_i
);
	input wire clk_i;
	input wire rst_ni;
	output wire data_mem_req_o;
	output wire [31:0] data_mem_addr_o;
	output wire [31:0] data_mem_wdata_o;
	output wire [3:0] data_mem_strb_o;
	output wire data_mem_we_o;
	input wire [31:0] data_mem_rdata_i;
	output wire instr_mem_req_o;
	output wire [31:0] instr_mem_addr_o;
	output wire [31:0] instr_mem_wdata_o;
	output wire [3:0] instr_mem_strb_o;
	output wire instr_mem_we_o;
	input wire [31:0] instr_mem_rdata_i;
	output wire [31:0] trs_pc_o;
	output wire [31:0] trs_instr_o;
	output wire trs_valid_o;
	input wire int_nmi_i;
	input wire int_external_i;
	input wire [3:0] int_extern_cause_i;
	input wire int_software_i;
	wire imem_req;
	wire imem_wen;
	wire [3:0] imem_strb;
	wire [31:0] imem_wdata;
	wire [31:0] imem_addr;
	wire imem_gnt;
	wire imem_recv;
	wire imem_ack;
	wire imem_error;
	wire [31:0] imem_rdata;
	wire dmem_req;
	wire dmem_wen;
	wire [3:0] dmem_strb;
	wire [31:0] dmem_wdata;
	wire [31:0] dmem_addr;
	wire dmem_gnt;
	wire dmem_recv;
	wire dmem_ack;
	wire dmem_error;
	wire [31:0] dmem_rdata;
	cellift_scarv i_scarv_core(
		.g_clk(clk_i),
		.g_resetn(rst_ni),
		.trs_pc(trs_pc_o),
		.trs_instr(trs_instr_o),
		.trs_valid(trs_valid_o),
		.rng_req_ready('0),
		.rng_rsp_valid('0),
		.rng_rsp_status('0),
		.rng_rsp_data('0),
		.int_nmi(int_nmi_i),
		.int_external(int_external_i),
		.int_extern_cause(int_extern_cause_i),
		.int_software(int_software_i),
		.imem_req(imem_req),
		.imem_wen(imem_wen),
		.imem_strb(imem_strb),
		.imem_wdata(imem_wdata),
		.imem_addr(imem_addr),
		.imem_gnt(imem_gnt),
		.imem_recv(imem_recv),
		.imem_ack(imem_ack),
		.imem_error(imem_error),
		.imem_rdata(imem_rdata),
		.dmem_req(dmem_req),
		.dmem_wen(dmem_wen),
		.dmem_strb(dmem_strb),
		.dmem_wdata(dmem_wdata),
		.dmem_addr(dmem_addr),
		.dmem_gnt(dmem_gnt),
		.dmem_recv(dmem_recv),
		.dmem_ack(dmem_ack),
		.dmem_error(dmem_error),
		.dmem_rdata(dmem_rdata)
	);
	wire imem_axi_awvalid;
	wire dmem_axi_awvalid;
	wire imem_axi_awready;
	wire dmem_axi_awready;
	wire [31:0] imem_axi_awaddr;
	wire [31:0] dmem_axi_awaddr;
	wire [2:0] imem_axi_awprot;
	wire [2:0] dmem_axi_awprot;
	wire imem_axi_wvalid;
	wire dmem_axi_wvalid;
	wire imem_axi_wready;
	wire dmem_axi_wready;
	wire [31:0] imem_axi_wdata;
	wire [31:0] dmem_axi_wdata;
	wire [3:0] imem_axi_wstrb;
	wire [3:0] dmem_axi_wstrb;
	wire imem_axi_bvalid;
	wire dmem_axi_bvalid;
	wire imem_axi_bready;
	wire dmem_axi_bready;
	wire [1:0] imem_axi_bresp;
	wire [1:0] dmem_axi_bresp;
	wire imem_axi_arvalid;
	wire dmem_axi_arvalid;
	wire imem_axi_arready;
	wire dmem_axi_arready;
	wire [31:0] imem_axi_araddr;
	wire [31:0] dmem_axi_araddr;
	wire [2:0] imem_axi_arprot;
	wire [2:0] dmem_axi_arprot;
	wire imem_axi_rvalid;
	wire dmem_axi_rvalid;
	wire imem_axi_rready;
	wire dmem_axi_rready;
	wire [31:0] imem_axi_rdata;
	wire [31:0] dmem_axi_rdata;
	wire [1:0] imem_axi_rresp;
	wire [1:0] dmem_axi_rresp;
	assign imem_axi_bresp = '0;
	assign imem_axi_rresp = '0;
	assign dmem_axi_bresp = '0;
	assign dmem_axi_rresp = '0;
	frv_axi_adapter i_instr_frv_axi_adapter(
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
	frv_axi_adapter i_data_frv_axi_adapter(
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
	axi_to_mem #(
		.AXI_ID_WIDTH(1),
		.AXI_ADDR_WIDTH(32),
		.AXI_DATA_WIDTH(32)
	) i_instr_axi_to_mem(
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
		.axi4_mem_0_bits_r_bits_data(imem_axi_rdata),
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
	) i_data_axi_to_mem(
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
		.axi4_mem_0_bits_r_bits_data(dmem_axi_rdata),
		.req_o(data_mem_req_o),
		.we_o(data_mem_we_o),
		.addr_o(data_mem_addr_o),
		.be_o(data_mem_strb_o),
		.data_o(data_mem_wdata_o),
		.data_i(data_mem_rdata_i)
	);
endmodule