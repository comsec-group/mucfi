logic[31:0] pc_t0; // length 64 bit works as well
assign pc_t0 = u_ibex_core__id_stage_i__pc_id_i_t0;

default clocking clk_verif @(posedge clk_i); endclocking
default disable iff (!rst_ni);

// Test bench internal name
bit fpv_resetn;
assign fpv_resetn = rst_ni;

bit fpv_clk;
assign fpv_clk = clk_i;

// `define CRYPTO 1

`include "formal/signal_defs/operand_assignments_first.sv"

  // Taint start and stop conditions per instruction
`include "../common/formal/signal_defs/start_cond_reg.sv"
`include "../common/formal/signal_defs/stop_cond_reg.sv"

`include "../common/formal/properties/prop_ct_instr.sv"

// `include "formal/properties/cellift_kronos_taint_propagation_checker.sv"
`include "formal/properties/ibex_top_no_taint_ever_checker.sv"
`include "../common/formal/assumptions/asm_taint_inj_once.sv"

// Configure the design specific signals

// We neet to keep track of how long we are looking into the past when injecting taint
// For this period we must set taint_active to 0 in the task's assumptions
`define MAX_PAST_VAL_TAINT_INJECTION 1

// The time when we check instr_word has to be relative to the taint injection start condition

`include "formal/properties/taint_conditions/generated_taint_conditions.sv"

reg [31:0] instr_word;
reg [31:0] instr_word_d;

assign instr_word = gen_instr_word_sampling_cond ?                    u_ibex_core__id_stage_i__decoder_i__instr_rdata_i : instr_word_d;

always @(posedge fpv_clk) begin
  instr_word_d <= instr_word;
end

logic [4:0] rs1_addr1;
logic [4:0] rs2_addr1;
assign rs1_addr1 = instr_word[19:15];
assign rs2_addr1 = instr_word[24:20];

// TESTING:
// The condition in which the reg reader gets a new value, based on the register address
// unconditionally immediatly assigned from gprs[rs1_addr]
// so it is the same as the "may change" condition

// Adding data ind timing condition only to get more interesting counter examples.
// The generic version with and without that additional condition is the complete one, as descirbed in the paper and generated.
// The addition of the flag is part of CEX analysis.
bit cpuregs_rs1_start_cond;
assign cpuregs_rs1_start_cond = gen_regrd_rs1 && u_ibex_core__cs_registers_i__data_ind_timing_o; //rs1_reg_reading_cond && u_ibex_core__cs_registers_i__data_ind_timing_o;

bit cpuregs_rs2_start_cond;
assign cpuregs_rs2_start_cond = gen_regrd_rs2 && u_ibex_core__cs_registers_i__data_ind_timing_o; //rs2_reg_reading_cond && u_ibex_core__cs_registers_i__data_ind_timing_o;

bit cpuregs_rs1_stop_cond;
assign cpuregs_rs1_stop_cond = gen_uc_rs1;

bit cpuregs_rs2_stop_cond;
assign cpuregs_rs2_stop_cond = gen_uc_rs2;

as_sup_may_change_rs1: assert property (
  ##1 $changed(gen_regfile_ff__register_file_i__rdata_a_o)
  |->
  gen_uc_rs1
);

as_sup_may_change_rs2: assert property (
  ##1 $changed(gen_regfile_ff__register_file_i__rdata_b_o)
  |->
  gen_uc_rs2
);

// as_sanity_rs1_reg_reading_cond: assert property (
//   ##1 $changed(u_ibex_core__rf_rdata_a_ecc_i)
//   |->
//   rs1_reg_reading_cond
// );

// as_sanity_rs2_reg_reading_cond: assert property (
//   ##1 $changed(u_ibex_core__rf_rdata_b_ecc_i)
//   |->
//   rs2_reg_reading_cond
// );


// Prove, that the register input to the forwarding MUX with abstracted select
// always equals the operand that we taint
// --> proves that taint must reach there in both reg and forwarding select case (with unabstracted select)

as_sanity_reg1_taint_reaches_fwd_mux: assert property (
  u_ibex_core__id_stage_i__rf_rdata_a_i[31:0] == gen_regfile_ff__register_file_i__rdata_a_o[31:0]
);

as_sanity_reg2_taint_reaches_fwd_mux: assert property (
  u_ibex_core__id_stage_i__rf_rdata_b_i[31:0] == gen_regfile_ff__register_file_i__rdata_b_o[31:0]
);