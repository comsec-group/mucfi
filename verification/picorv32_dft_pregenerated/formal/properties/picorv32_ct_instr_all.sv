// Configure the design specific signals


logic[31:0] pc_t0; // length 64 bit works as well
assign pc_t0 = reg_pc_t0;

logic[31:0] pc; // length 64 bit works as well
assign pc = reg_pc;


logic fpv_clk;
assign fpv_clk = clk;
logic fpv_resetn;
assign fpv_resetn = resetn;

default clocking clk_verif @(posedge fpv_clk); endclocking
default disable iff (!resetn);

`include "formal/signal_defs/operand_assignments_first.sv"
  // Taint start and stop conditions per instruction
`include "../common/formal/signal_defs/start_cond_reg.sv"
`include "../common/formal/signal_defs/stop_cond_reg.sv"
`include "../common/formal/properties/prop_ct_instr.sv"


`include "formal/properties/picorv32_no_taint_ever_checker.sv"
`include "../common/formal/assumptions/asm_taint_inj_once.sv"


 `include "formal/properties/taint_conditions/generated_taint_conditions.sv"

  reg [31:0] instr_word;

  always @(posedge fpv_clk) begin
    if (gen_instr_word_sampling_cond)
      instr_word <= mem_rdata_latched;
  end


  bit cpuregs_rs1_start_cond;
  assign cpuregs_rs1_start_cond = gen_regrd_rs1;;


  bit cpuregs_rs2_start_cond;
  assign cpuregs_rs2_start_cond = gen_regrd_rs2;


  bit cpuregs_rs1_stop_cond;
  // assign cpuregs_rs1_stop_cond = cpuregs_rs1_start_cond;
  assign cpuregs_rs1_stop_cond = gen_uc_rs1;

  bit cpuregs_rs2_stop_cond;
  // assign cpuregs_rs2_stop_cond = cpuregs_rs2_start_cond;
  assign cpuregs_rs2_stop_cond = gen_uc_rs2;

  as_sup_may_change_rs1: assert property (
  ##1 $changed(cpuregs_rs1)
  |->
  cpuregs_rs1_stop_cond
  );

  as_sup_may_change_rs2: assert property (
    ##1 $changed(cpuregs_rs2)
    |->
    cpuregs_rs2_stop_cond
  );

