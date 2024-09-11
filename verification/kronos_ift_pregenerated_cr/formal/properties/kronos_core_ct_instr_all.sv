
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

logic [31:0] instr_word;

always @(posedge fpv_clk) begin
  if (gen_instr_word_sampling_cond) begin
    instr_word <= u_if__next_instr;
  end
end

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