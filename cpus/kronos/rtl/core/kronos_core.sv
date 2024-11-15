// Copyright (c) 2020 Sonal Pinto
// SPDX-License-Identifier: Apache-2.0

/*
Kronos
  3-stage RISC-V RV32I_Zicsr_Zifencei Core
*/

module kronos_core
  import kronos_types::*;
#(
  parameter logic [31:0]  BOOT_ADDR = 32'h0,
  parameter FAST_BRANCH = 1,
  parameter EN_COUNTERS = 1,
  parameter EN_COUNTERS64B = 1,
  parameter CATCH_ILLEGAL_INSTR = 1,
  parameter CATCH_MISALIGNED_JMP = 1,
  parameter CATCH_MISALIGNED_LDST = 1
)(
  input  logic        clk,
  input  logic        rstz,
  // Instruction interface
  output logic [31:0] instr_addr,
  input  logic [31:0] instr_data,
  output logic        instr_req,
  input  logic        instr_ack,
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

logic [31:0] immediate;
logic [31:0] regrd_rs1;
logic [31:0] regrd_rs2;
logic regrd_rs1_en;
logic regrd_rs2_en;

logic [31:0] branch_target;
logic branch;

logic [31:0] regwr_data;
logic [4:0] regwr_sel;
logic regwr_en;

logic flush;

// struct fetch
logic [31:0] fetch_pc;
logic [31:0] fetch_ir;

// struct decode
logic [31:0] decode_pc;
logic [31:0] decode_ir;
logic [31:0] decode_op1;
logic [31:0] decode_op2;
logic [31:0] decode_addr;
logic        decode_basic;
logic [3:0]  decode_aluop;
logic        decode_regwr_alu;
logic        decode_jump;
logic        decode_branch;
logic        decode_load;
logic        decode_store;
logic [3:0]  decode_mask;
logic        decode_csr;
logic        decode_system;
logic [1:0]  decode_sysop;
logic        decode_illegal;
logic        decode_misaligned_jmp;
logic        decode_misaligned_ldst;

logic fetch_vld, fetch_rdy;
logic decode_vld, decode_rdy;

logic regwr_pending;

// ============================================================
// Fetch
// ============================================================
kronos_IF #(
  .BOOT_ADDR(BOOT_ADDR),
  .FAST_BRANCH(FAST_BRANCH)
) u_if (
  .clk          (clk          ),
  .rstz         (rstz         ),
  .instr_addr   (instr_addr   ),
  .instr_data   (instr_data   ),
  .instr_req    (instr_req    ),
  .instr_ack    (instr_ack    ),

  .fetch_pc              (fetch_pc),
  .fetch_ir              (fetch_ir),

  .immediate    (immediate    ),
  .regrd_rs1    (regrd_rs1    ),
  .regrd_rs2    (regrd_rs2    ),
  .regrd_rs1_en (regrd_rs1_en ),
  .regrd_rs2_en (regrd_rs2_en ),
  .fetch_vld    (fetch_vld    ),
  .fetch_rdy    (fetch_rdy    ),
  .branch_target(branch_target),
  .branch       (branch       ),
  .regwr_data   (regwr_data   ),
  .regwr_sel    (regwr_sel    ),
  .regwr_en     (regwr_en     )
);

// ============================================================
// Decode
// ============================================================
kronos_ID #(
  .CATCH_ILLEGAL_INSTR(CATCH_ILLEGAL_INSTR),
  .CATCH_MISALIGNED_JMP(CATCH_MISALIGNED_JMP),
  .CATCH_MISALIGNED_LDST(CATCH_MISALIGNED_LDST)
) u_id (
  .clk           (clk          ),
  .rstz          (rstz         ),
  .flush         (flush        ),

  .fetch_pc              (fetch_pc),
  .fetch_ir              (fetch_ir),

  .immediate     (immediate    ),
  .regrd_rs1     (regrd_rs1    ),
  .regrd_rs2     (regrd_rs2    ),
  .regrd_rs1_en  (regrd_rs1_en ),
  .regrd_rs2_en  (regrd_rs2_en ),
  .fetch_vld     (fetch_vld    ),
  .fetch_rdy     (fetch_rdy    ),

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

  .decode_vld    (decode_vld   ),
  .decode_rdy    (decode_rdy   ),
  .regwr_data    (regwr_data   ),
  .regwr_sel     (regwr_sel    ),
  .regwr_en      (regwr_en     ),
  .regwr_pending (regwr_pending)
);

// ============================================================
// Execute
// ============================================================
kronos_EX #(
  .BOOT_ADDR     (BOOT_ADDR),
  .EN_COUNTERS   (EN_COUNTERS),
  .EN_COUNTERS64B(EN_COUNTERS64B)
) u_ex (
  .clk               (clk               ),
  .rstz              (rstz              ),

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

  .decode_vld        (decode_vld        ),
  .decode_rdy        (decode_rdy        ),
  .regwr_data        (regwr_data        ),
  .regwr_sel         (regwr_sel         ),
  .regwr_en          (regwr_en          ),
  .regwr_pending     (regwr_pending     ),
  .branch_target     (branch_target     ),
  .branch            (branch            ),
  .data_addr         (data_addr         ),
  .data_rd_data      (data_rd_data      ),
  .data_wr_data      (data_wr_data      ),
  .data_mask         (data_mask         ),
  .data_wr_en        (data_wr_en        ),
  .data_req          (data_req          ),
  .data_ack          (data_ack          ),
  .software_interrupt(software_interrupt),
  .timer_interrupt   (timer_interrupt   ),
  .external_interrupt(external_interrupt)
);

// Flush pipeline on branch
assign flush = branch;

endmodule
