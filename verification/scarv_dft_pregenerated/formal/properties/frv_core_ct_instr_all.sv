

logic[31:0] pc_t0; // length 64 bit works as well
assign pc_t0 = i_pipeline__i_pipeline_s1_decode__program_counter_t0;

default clocking clk_verif @(posedge g_clk); endclocking
default disable iff (!g_resetn);

// Test bench internal name
bit fpv_resetn;
assign fpv_resetn = g_resetn;

bit fpv_clk;
assign fpv_clk = g_clk;



`define CRYPTO 1

`include "formal/signal_defs/operand_assignments_first.sv"

  // Taint start and stop conditions per instruction
`include "../common/formal/signal_defs/start_cond_reg.sv"
`include "../common/formal/signal_defs/stop_cond_reg.sv"

`include "../common/formal/properties/prop_ct_instr.sv"

// `include "formal/properties/cellift_kronos_taint_propagation_checker.sv"
`include "formal/properties/frv_core_no_taint_ever_checker.sv"
`include "../common/formal/assumptions/asm_taint_inj_once.sv"

// Configure the design specific signals

// We neet to keep track of how long we are looking into the past when injecting taint
// For this period we must set taint_active to 0 in the task's assumptions
`define MAX_PAST_VAL_TAINT_INJECTION 1

`include "formal/properties/taint_conditions/generated_taint_conditions.sv"


reg [31:0] instr_word;

reg [31:0] instr_word_d;

assign instr_word = gen_instr_word_sampling_cond ? i_pipeline__i_pipeline_s1_decode__s1_data : instr_word_d;

always @(posedge fpv_clk) begin
  instr_word_d <= instr_word;
end


bit rs1_reg_reading_cond;
bit rs2_reg_reading_cond;
assign rs1_reg_reading_cond = rs1_may_change;
assign rs2_reg_reading_cond = rs2_may_change;
  bit rs1_may_change;
  bit rs2_may_change;
  bit rs1_data_may_change;
  bit rs2_data_may_change;


bit cpuregs_rs1_start_cond;
assign cpuregs_rs1_start_cond = gen_regrd_rs1;

bit cpuregs_rs2_start_cond;
assign cpuregs_rs2_start_cond = gen_regrd_rs2;

bit cpuregs_rs1_stop_cond;
assign cpuregs_rs1_stop_cond = gen_uc_rs1;

bit cpuregs_rs2_stop_cond;
assign cpuregs_rs2_stop_cond = gen_uc_rs2;

as_sup_may_change_rs1: assert property (
  ##1 $changed(i_pipeline__i_gprs__rs1_data)
  |->
  gen_uc_rs1
);

as_sup_may_change_rs2: assert property (
  ##1 $changed(i_pipeline__i_gprs__rs2_data)
  |->
  gen_uc_rs2
);
