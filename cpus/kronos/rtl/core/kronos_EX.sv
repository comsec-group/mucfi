// Copyright (c) 2020 Sonal Pinto
// SPDX-License-Identifier: Apache-2.0

/*
Kronos Execution Unit
*/

module kronos_EX
  import kronos_types::*;
#(
  parameter logic [31:0]  BOOT_ADDR = 32'h0,
  parameter EN_COUNTERS = 1,
  parameter EN_COUNTERS64B = 1
)(
  input  logic        clk,
  input  logic        rstz,
  // ID/EX

  input logic [31:0]  decode_pc,
  input logic [31:0]  decode_ir,
  input logic [31:0]  decode_op1,
  input logic [31:0]  decode_op2,
  input logic [31:0]  decode_addr,
  input logic         decode_basic,
  input logic [3:0]   decode_aluop,
  input logic         decode_regwr_alu,
  input logic         decode_jump,
  input logic         decode_branch,
  input logic         decode_load,
  input logic         decode_store,
  input logic [3:0]   decode_mask,
  input logic         decode_csr,
  input logic         decode_system,
  input logic [1:0]   decode_sysop,
  input logic         decode_illegal,
  input logic         decode_misaligned_jmp,
  input logic         decode_misaligned_ldst,

  input  logic        decode_vld,
  output logic        decode_rdy,
  // REG Write
  output logic [31:0] regwr_data,
  output logic [4:0]  regwr_sel,
  output logic        regwr_en,
  output logic        regwr_pending,
  // Branch
  output logic [31:0] branch_target,
  output logic        branch,
  // Data interface
  output logic [31:0] data_addr,
  input  logic [31:0] data_rd_data,
  output logic [31:0] data_wr_data,
  output logic [3:0]  data_mask,
  output logic        data_wr_en,
  output logic        data_req,
  input  logic        data_ack,
  // Interrupt sources
  input  logic        software_interrupt,
  input  logic        timer_interrupt,
  input  logic        external_interrupt
);

logic [31:0] result;
logic [4:0] rd;

logic instr_vld;
logic instr_jump;
logic basic_rdy;

logic lsu_vld, lsu_rdy;
logic [31:0] load_data;
logic regwr_lsu;

logic csr_vld,csr_rdy;
logic [31:0] csr_data;
logic regwr_csr;
logic instret;
logic core_interrupt;
logic [3:0] core_interrupt_cause;

logic exception;

logic activate_trap, return_trap;
logic [31:0] trap_cause, trap_handle, trap_value;
logic trap_jump;

// Feedback for hazard detection
logic regwr_pending_firstcycle, regwr_pending_later;

enum logic [2:0] {
  STEADY,
  LSU,
  CSR,
  TRAP,
  RETURN,
  WFINTR,
  JUMP
} state, next_state;


// ============================================================
// IR Segments
assign rd  = decode_ir[11:7];

// ============================================================
// EX Sequencer
always_ff @(posedge clk) begin
  if (~rstz) state <= STEADY;
  else state <= next_state;
end

always_comb begin
  next_state = state;
  /* verilator lint_off CASEINCOMPLETE */
  unique case (state)
    STEADY: if (decode_vld) begin
      if (core_interrupt) next_state = TRAP;
      else if (exception) next_state = TRAP;
      else if (decode_system) begin
        unique case (decode_sysop)
          ECALL,
          EBREAK: next_state = TRAP;
          MRET  : next_state = RETURN;
          WFI   : next_state = WFINTR;
        endcase
      end
      else if (decode_load || decode_store) next_state = LSU;
      else if (decode_csr) next_state = CSR;
    end

    LSU: if (lsu_rdy) next_state = STEADY;

    CSR: if (csr_rdy) next_state = STEADY;

    WFINTR: if (core_interrupt) next_state = TRAP;

    TRAP: next_state = JUMP;

    RETURN: next_state = JUMP;

    JUMP: if (trap_jump) next_state = STEADY;

  endcase // state
  /* verilator lint_on CASEINCOMPLETE */
end

// Decoded instruction valid
assign instr_vld = decode_vld && state == STEADY && ~exception && ~core_interrupt;

// Basic instructions
assign basic_rdy = instr_vld && decode_basic;

// Next instructions
assign decode_rdy = |{basic_rdy, lsu_rdy, csr_rdy};

// ============================================================
// ALU
kronos_alu u_alu (
  .op1   (decode_op1  ),
  .op2   (decode_op2  ),
  .aluop (decode_aluop),
  .result(result      )
);

// ============================================================
// LSU
assign lsu_vld = instr_vld || state == LSU;

kronos_lsu u_lsu (
  .decode_pc              (decode_pc),
  .decode_ir              (decode_ir),
  .decode_op1             (decode_op1),
  .decode_op2             (decode_op2),
  .decode_addr            (decode_addr),
  .decode_basic           (decode_basic),
  .decode_aluop           (decode_aluop),
  .decode_regwr_alu       (decode_regwr_alu),
  .decode_jump            (decode_jump),
  .decode_branch          (decode_branch),
  .decode_load            (decode_load),
  .decode_store           (decode_store),
  .decode_mask            (decode_mask),
  .decode_csr             (decode_csr),
  .decode_system          (decode_system),
  .decode_sysop           (decode_sysop),
  .decode_illegal         (decode_illegal),
  .decode_misaligned_jmp  (decode_misaligned_jmp),
  .decode_misaligned_ldst (decode_misaligned_ldst),

  .lsu_vld     (lsu_vld     ),
  .lsu_rdy     (lsu_rdy     ),
  .load_data   (load_data   ),
  .regwr_lsu   (regwr_lsu   ),
  .data_addr   (data_addr   ),
  .data_rd_data(data_rd_data),
  .data_wr_data(data_wr_data),
  .data_mask   (data_mask   ),
  .data_wr_en  (data_wr_en  ),
  .data_req    (data_req    ),
  .data_ack    (data_ack    )
);

// ============================================================
// Hazard detection
assign regwr_pending_firstcycle = (decode_vld && decode_rdy) & (decode_regwr_alu | regwr_lsu | regwr_csr);
assign regwr_pending = regwr_pending_firstcycle | (~(decode_vld && decode_rdy) && regwr_pending_later);

// ============================================================
// Register Write Back

always_ff @(posedge clk) begin
  if (~rstz) begin
    regwr_en <= 1'b0;
    regwr_pending_later <= 1'b0;
  end
  else begin
    regwr_sel <= rd;

    if (decode_vld && decode_rdy)
      regwr_pending_later <= (regwr_lsu && ~lsu_rdy) | (regwr_csr && ~csr_rdy);

    if (instr_vld && decode_regwr_alu) begin
      // Write back ALU result
      regwr_en <= 1'b1;
      regwr_data <= result;
    end
    else if (lsu_rdy && regwr_lsu) begin
      // Write back Load Data
      regwr_pending_later <= 1'b0;
      regwr_en <= 1'b1;
      regwr_data <= load_data;
    end
    else if (csr_rdy && regwr_csr) begin
      // Write back CSR Read Data
      regwr_pending_later <= 1'b0;
      regwr_en <= 1'b1;
      regwr_data <= csr_data;
    end
    else begin
      regwr_en <= 1'b0;
    end
  end
end

// ============================================================
// Jump and Branch
assign branch_target = trap_jump ? trap_handle : decode_addr;
assign instr_jump =  decode_jump || decode_branch;
assign branch = (instr_vld && instr_jump) || trap_jump;

// ============================================================
// Trap Handling

assign exception = decode_illegal || decode_misaligned_ldst || (instr_jump && decode_misaligned_jmp);

// setup for trap
always_ff @(posedge clk) begin
  if (decode_vld && state == STEADY) begin
    if (core_interrupt) begin
      trap_cause <= {1'b1, 27'b0, core_interrupt_cause};
      trap_value <= '0;
    end
    else if (decode_illegal) begin
      trap_cause <= {28'b0, ILLEGAL_INSTR};
      trap_value <= decode_ir;
    end
    else if (decode_misaligned_jmp && instr_jump) begin
      trap_cause <= {28'b0, INSTR_ADDR_MISALIGNED};
      trap_value <= decode_addr;
    end
    else if (decode_misaligned_ldst && decode_load) begin
      trap_cause <= {28'b0, LOAD_ADDR_MISALIGNED};
      trap_value <= decode_addr;
    end
    else if (decode_misaligned_ldst && decode_store) begin
      trap_cause <= {28'b0, STORE_ADDR_MISALIGNED};
      trap_value <= decode_addr;
    end
    else if (decode_sysop == ECALL) begin
      trap_cause <= {28'b0, ECALL_MACHINE};
      trap_value <= '0;
    end
    else if (decode_sysop == EBREAK) begin
      trap_cause <= {28'b0, BREAKPOINT};
      trap_value <= decode_pc;
    end
  end
  else if (state == WFINTR) begin
    if (core_interrupt) begin
      trap_cause <= {1'b1, 27'b0, core_interrupt_cause};
      trap_value <= '0;
    end
  end
end

// ============================================================
// CSR
assign csr_vld = instr_vld || state == CSR;

kronos_csr #(
  .BOOT_ADDR     (BOOT_ADDR     ),
  .EN_COUNTERS   (EN_COUNTERS   ),
  .EN_COUNTERS64B(EN_COUNTERS64B)
) u_csr (
  .clk                 (clk                 ),
  .rstz                (rstz                ),

  .decode_pc              (decode_pc),
  .decode_ir              (decode_ir),
  .decode_op1             (decode_op1),
  .decode_op2             (decode_op2),
  .decode_addr            (decode_addr),
  .decode_basic           (decode_basic),
  .decode_aluop           (decode_aluop),
  .decode_regwr_alu       (decode_regwr_alu),
  .decode_jump            (decode_jump),
  .decode_branch          (decode_branch),
  .decode_load            (decode_load),
  .decode_store           (decode_store),
  .decode_mask            (decode_mask),
  .decode_csr             (decode_csr),
  .decode_system          (decode_system),
  .decode_sysop           (decode_sysop),
  .decode_illegal         (decode_illegal),
  .decode_misaligned_jmp  (decode_misaligned_jmp),
  .decode_misaligned_ldst (decode_misaligned_ldst),

  .csr_vld             (csr_vld             ),
  .csr_rdy             (csr_rdy             ),
  .csr_data            (csr_data            ),
  .regwr_csr           (regwr_csr           ),
  .instret             (instret             ),
  .activate_trap       (activate_trap       ),
  .return_trap         (return_trap         ),
  .trap_cause          (trap_cause          ),
  .trap_value          (trap_value          ),
  .trap_handle         (trap_handle         ),
  .trap_jump           (trap_jump           ),
  .software_interrupt  (software_interrupt  ),
  .timer_interrupt     (timer_interrupt     ),
  .external_interrupt  (external_interrupt  ),
  .core_interrupt      (core_interrupt      ),
  .core_interrupt_cause(core_interrupt_cause)
);

assign activate_trap = state == TRAP;
assign return_trap = state == RETURN;

// instruction retired event
always_ff @(posedge clk) begin
  if (~rstz) instret <= 1'b0;
  else instret <= (decode_vld && decode_rdy)
              || (decode_system && trap_jump);
end

endmodule
