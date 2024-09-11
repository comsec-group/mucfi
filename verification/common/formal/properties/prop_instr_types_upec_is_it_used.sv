// Copyright 2024 Katharina Ceesay-Seitz, ETH Zurich.
// Licensed under the General Public License, Version 3.0, see LICENSE for details.
// SPDX-License-Identifier: GPL-3.0-only
// Provided by Lucas Deutschmann

  function automatic R_Type_Arithmetic_Instruction();
  R_Type_Arithmetic_Instruction = (
    ((Funct7() == 7'b0000000) && (Funct3() == 3'b000) && (Opcode() == 7'b0110011)) || // ADD
    ((Funct7() == 7'b0100000) && (Funct3() == 3'b000) && (Opcode() == 7'b0110011)) || // SUB
    ((Funct7() == 7'b0000000) && (Funct3() == 3'b001) && (Opcode() == 7'b0110011)) || // SLL
    ((Funct7() == 7'b0000000) && (Funct3() == 3'b010) && (Opcode() == 7'b0110011)) || // SLT
    ((Funct7() == 7'b0000000) && (Funct3() == 3'b011) && (Opcode() == 7'b0110011)) || // SLTU
    ((Funct7() == 7'b0000000) && (Funct3() == 3'b100) && (Opcode() == 7'b0110011)) || // XOR
    ((Funct7() == 7'b0000000) && (Funct3() == 3'b101) && (Opcode() == 7'b0110011)) || // SRL
    ((Funct7() == 7'b0100000) && (Funct3() == 3'b101) && (Opcode() == 7'b0110011)) || // SRA
    ((Funct7() == 7'b0000000) && (Funct3() == 3'b110) && (Opcode() == 7'b0110011)) || // OR
    ((Funct7() == 7'b0000000) && (Funct3() == 3'b111) && (Opcode() == 7'b0110011))    // AND
  );
  endfunction;

  function automatic I_Type_Arithmetic_Instruction();
  I_Type_Arithmetic_Instruction = (
    (                            (Funct3() == 3'b000) && (Opcode() == 7'b0010011)) || // ADDI
    (                            (Funct3() == 3'b010) && (Opcode() == 7'b0010011)) || // SLTI
    (                            (Funct3() == 3'b011) && (Opcode() == 7'b0010011)) || // SLTIU
    (                            (Funct3() == 3'b100) && (Opcode() == 7'b0010011)) || // XORI
    (                            (Funct3() == 3'b110) && (Opcode() == 7'b0010011)) || // ORI
    (                            (Funct3() == 3'b111) && (Opcode() == 7'b0010011)) || // ANDI
    ((Funct7() == 7'b0000000) && (Funct3() == 3'b001) && (Opcode() == 7'b0010011)) || // SLLI
    ((Funct7() == 7'b0000000) && (Funct3() == 3'b101) && (Opcode() == 7'b0010011)) || // SRLI
    ((Funct7() == 7'b0100000) && (Funct3() == 3'b101) && (Opcode() == 7'b0010011))    // SRAI
  );
  endfunction;

  function automatic Load_Instruction();
  Load_Instruction = (
    ((Funct3() == 3'b000) && (Opcode() == 7'b0000011)) || // LB
    ((Funct3() == 3'b001) && (Opcode() == 7'b0000011)) || // LH
    ((Funct3() == 3'b010) && (Opcode() == 7'b0000011)) || // LW
    ((Funct3() == 3'b100) && (Opcode() == 7'b0000011)) || // LBU
    ((Funct3() == 3'b101) && (Opcode() == 7'b0000011))    // LHU
  );
  endfunction;

  function automatic Store_Instruction();
  Store_Instruction = (
    ((Funct3() == 3'b000) && (Opcode() == 7'b0100011)) || // SB
    ((Funct3() == 3'b001) && (Opcode() == 7'b0100011)) || // SH
    ((Funct3() == 3'b010) && (Opcode() == 7'b0100011))    // SW
  );
  endfunction;

  function automatic Branch_Instruction();
  Branch_Instruction = (
    ((Funct3() == 3'b000) && (Opcode() == 7'b1100011)) || // BEQ
    ((Funct3() == 3'b001) && (Opcode() == 7'b1100011)) || // BNE
    ((Funct3() == 3'b100) && (Opcode() == 7'b1100011)) || // BLT
    ((Funct3() == 3'b101) && (Opcode() == 7'b1100011)) || // BGE
    ((Funct3() == 3'b110) && (Opcode() == 7'b1100011)) || // BLTU
    ((Funct3() == 3'b111) && (Opcode() == 7'b1100011))    // BGEU
  );
  endfunction;

  function automatic Jump_Instruction();
  Jump_Instruction = (
    (                        (Opcode() == 7'b1101111)) || // JAL
    ((Funct3() == 3'b000) && (Opcode() == 7'b1100111))    // JALR
  );
  endfunction;

  function automatic Mult_Instruction();
  Mult_Instruction = (
    ((Funct7() == 7'b0000001) && (Funct3() == 3'b000) && (Opcode() == 7'b0110011)) || // MUL
    ((Funct7() == 7'b0000001) && (Funct3() == 3'b001) && (Opcode() == 7'b0110011)) || // MULH
    ((Funct7() == 7'b0000001) && (Funct3() == 3'b010) && (Opcode() == 7'b0110011)) || // MULHSU
    ((Funct7() == 7'b0000001) && (Funct3() == 3'b011) && (Opcode() == 7'b0110011))    // MULHU
  );
  endfunction;

  function automatic Div_Instruction();
  Div_Instruction = (
    ((Funct7() == 7'b0000001) && (Funct3() == 3'b100) && (Opcode() == 7'b0110011)) || // DIV
    ((Funct7() == 7'b0000001) && (Funct3() == 3'b101) && (Opcode() == 7'b0110011)) || // DIVU
    ((Funct7() == 7'b0000001) && (Funct3() == 3'b110) && (Opcode() == 7'b0110011)) || // REM
    ((Funct7() == 7'b0000001) && (Funct3() == 3'b111) && (Opcode() == 7'b0110011))    // REMU
  );
  endfunction;

  function automatic CSR_Access_Instruction();
  CSR_Access_Instruction = (
    ((Funct3() == 3'b001) && (Opcode() == 7'b1110011)) || // CSRRW
    ((Funct3() == 3'b010) && (Opcode() == 7'b1110011)) || // CSRRS
    ((Funct3() == 3'b011) && (Opcode() == 7'b1110011)) || // CSRRC
    ((Funct3() == 3'b101) && (Opcode() == 7'b1110011)) || // CSRRWI
    ((Funct3() == 3'b110) && (Opcode() == 7'b1110011)) || // CSRRSI
    ((Funct3() == 3'b111) && (Opcode() == 7'b1110011))    // CSRRCI
  );
  endfunction;