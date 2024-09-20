
// Copyright 2024 Katharina Ceesay-Seitz, ETH Zurich.
// Licensed under the General Public License, Version 3.0, see LICENSE for details.
// SPDX-License-Identifier: GPL-3.0-only
logic[31:0] pc_t0; // length 64 bit works as well
assign pc_t0 = u_if__pc_last_t0;

default clocking clk_verif @(posedge fpv_clk); endclocking
default disable iff (!rstz);

// Test bench internal name
bit fpv_clk;
assign fpv_clk = clk;

bit fpv_resetn;
assign fpv_resetn = rstz;

`include "formal/signal_defs/operand_assignments_first.sv"

  // Taint start and stop conditions per instruction
`include "../common/formal/signal_defs/start_cond_reg.sv"
`include "../common/formal/signal_defs/stop_cond_reg.sv"

`include "../common/formal/properties/prop_ct_instr.sv"

`include "formal/properties/kronos_core_no_taint_ever_checker.sv"
`include "../common/formal/assumptions/asm_taint_inj_once.sv"

// Configure the design specific signals

// We neet to keep track of how long we are looking into the past when injecting taint
// For this period we must set taint_active to 0 in the task's assumptions
`define MAX_PAST_VAL_TAINT_INJECTION 1

`include "formal/properties/taint_conditions/generated_taint_conditions.sv"

// The time when we check instr_word has to be relative to the taint injection start condition
// We must "decode" it in the same clock cycle(s) as the CPU

reg [31:0] instr_word;

reg [31:0] instr_word_d;

// We sample the past instruction word, because the gen_instr_word_sampling condition also looks into the past.

// Warning: This is a dangerous coding style that generates a latch.
// Your formal verification tool may only reset registers and not latches, so instr_word_d has a random value in the first clock cycle.
// A safer option is to remove the $past from the generated gen_instr_word_sampling_cond and sample u_if__u_rf__instr_data in an always block.
// For this CPU and our property, it does not matter. But if you verify another CPU, use the safe approach.

// We need to use u_if__u_rf__instr_data, because "u_if.u_rf.instr_data" (as selected in the config) is optimized out. It is the same signal.
assign instr_word = gen_instr_word_sampling_cond ? $past(u_if__u_rf__instr_data) : instr_word_d;

always @(posedge fpv_clk) begin
  instr_word_d <= instr_word;
end

// If you remove the $past from the generated condition gen_instr_word_sampling_cond, you can use the following:

// always @(posedge fpv_clk) begin
//   if (!fpv_resetn) begin
//     instr_word <= '0;
//   else if (gen_instr_word_sampling_cond) begin
//     instr_word <= u_if__u_rf__instr_data;
//   end
// end

bit rs1_reg_reading_cond = gen_regrd_rs1 || gen_fwdrd_rs1;
bit rs2_reg_reading_cond = gen_regrd_rs2 || gen_fwdrd_rs2;

// If we use the following complete update condition of the reg readers, we need to use the instr word of the ID stage.
bit rs1_may_change = gen_uc_rs1;
bit rs2_may_change = gen_uc_rs2;

bit cpuregs_rs1_start_cond;
assign cpuregs_rs1_start_cond = rs1_reg_reading_cond;

bit cpuregs_rs1_stop_cond;
assign cpuregs_rs1_stop_cond = rs1_may_change;

//
bit cpuregs_rs2_start_cond;
assign cpuregs_rs2_start_cond = rs2_reg_reading_cond;

bit cpuregs_rs2_stop_cond;
assign cpuregs_rs2_stop_cond = rs2_may_change;

as_sup_may_change_rs1: assert property (
  ##1 $changed(u_if__u_rf__regrd_rs1)
  |->
  rs1_may_change
);

as_sup_may_change_rs2: assert property (
  ##1 $changed(u_if__u_rf__regrd_rs2)
  |->
  rs2_may_change
);