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

  reg [31:0] instr_word_d;

  // We sample the past instruction word, because the gen_instr_word_sampling condition also looks into the past.
  // Warning: This is a dangerous coding style that generates a latch.
  // Your formal verification tool may only reset registers and not latches, so instr_word_d has a random value in the first clock cycle.
  // A safer option is to remove the $past from the generated gen_instr_word_sampling_cond and sample mem_rdata_latched in an always block.
  // For our property, it does not matter.
  // The property may only fail 'unexpectedly' if there is a read happening before mem_rdata_latched was ever sampled, which is probably a bug (or some sort of speculation).
  assign instr_word = gen_instr_word_sampling_cond ? $past(mem_rdata_latched) : instr_word_d;

  always @(posedge fpv_clk) begin
    instr_word_d <= instr_word;
  end

  // If you remove the $past from the generated condition gen_instr_word_sampling_cond, you can use the following:

  // always @(posedge fpv_clk) begin
  //   if (!fpv_resetn) begin
  //     instr_word <= '0;
  //   else if (gen_instr_word_sampling_cond) begin
  //     instr_word <= mem_rdata_latched;
  //   end
  // end

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

