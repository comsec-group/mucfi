// Copyright 2024 Katharina Ceesay-Seitz, ETH Zurich.
// Licensed under the General Public License, Version 3.0, see LICENSE for details.
// SPDX-License-Identifier: GPL-3.0-only
//Based from a file received from: Lucas Deutschmann (UPEC)

function logic [6:0] Opcode(bit[31:0] _instr_word);
Opcode = (
  _instr_word[6:0]
);
endfunction;

function logic [2:0] Funct3(bit[31:0] _instr_word);
Funct3 = (
  _instr_word[14:12]
);
endfunction;

function logic [6:0] Funct7(bit[31:0] _instr_word);
Funct7 = (
  _instr_word[31:25]
);
endfunction;

function logic [4:0] Rs1(bit[31:0] _instr_word);
  return _instr_word[19:15];
endfunction

function logic [4:0] Rs2(bit[31:0] _instr_word);
  return _instr_word[24:20];
endfunction

function logic [4:0] Rd(bit[31:0] _instr_word);
  return _instr_word[11:7];
endfunction

function automatic AUIPC(bit[31:0] _instr_word);
  return Opcode(_instr_word) == 7'b0010111;
endfunction

function automatic LUI(bit[31:0] _instr_word);
  return Opcode(_instr_word) == 7'b0110111;
endfunction

function automatic ADD(bit[31:0] _instr_word);
  return ((Funct7(_instr_word) == 7'b0000000) && (Funct3(_instr_word) == 3'b000) && (Opcode(_instr_word) == 7'b0110011));
endfunction

function automatic SUB(bit[31:0] _instr_word);
  return ((Funct7(_instr_word) == 7'b0100000) && (Funct3(_instr_word) == 3'b000) && (Opcode(_instr_word) == 7'b0110011));
endfunction

function automatic SLL(bit[31:0] _instr_word);
  return ((Funct7(_instr_word) == 7'b0000000) && (Funct3(_instr_word) == 3'b001) && (Opcode(_instr_word) == 7'b0110011));
endfunction

function automatic SLT(bit[31:0] _instr_word);
  return ((Funct7(_instr_word) == 7'b0000000) && (Funct3(_instr_word) == 3'b010) && (Opcode(_instr_word) == 7'b0110011));
endfunction

function automatic SLTU(bit[31:0] _instr_word);
  return ((Funct7(_instr_word) == 7'b0000000) && (Funct3(_instr_word) == 3'b011) && (Opcode(_instr_word) == 7'b0110011));
endfunction

function automatic XOR(bit[31:0] _instr_word);
  return ((Funct7(_instr_word) == 7'b0000000) && (Funct3(_instr_word) == 3'b100) && (Opcode(_instr_word) == 7'b0110011));
endfunction

function automatic SRL(bit[31:0] _instr_word);
  return ((Funct7(_instr_word) == 7'b0000000) && (Funct3(_instr_word) == 3'b101) && (Opcode(_instr_word) == 7'b0110011));
endfunction

function automatic SRA(bit[31:0] _instr_word);
  return ((Funct7(_instr_word) == 7'b0100000) && (Funct3(_instr_word) == 3'b101) && (Opcode(_instr_word) == 7'b0110011));
endfunction

function automatic OR(bit[31:0] _instr_word);
  return ((Funct7(_instr_word) == 7'b0000000) && (Funct3(_instr_word) == 3'b110) && (Opcode(_instr_word) == 7'b0110011));
endfunction

function automatic AND(bit[31:0] _instr_word);
  return ((Funct7(_instr_word) == 7'b0000000) && (Funct3(_instr_word) == 3'b111) && (Opcode(_instr_word) == 7'b0110011));
endfunction

function automatic ADDI(bit[31:0] _instr_word);
  return (                            (Funct3(_instr_word) == 3'b000) && (Opcode(_instr_word) == 7'b0010011));
endfunction

function automatic SLTI(bit[31:0] _instr_word);
  return (                            (Funct3(_instr_word) == 3'b010) && (Opcode(_instr_word) == 7'b0010011));
endfunction

function automatic SLTIU(bit[31:0] _instr_word);
  return (                            (Funct3(_instr_word) == 3'b011) && (Opcode(_instr_word) == 7'b0010011));
endfunction

function automatic XORI(bit[31:0] _instr_word);
  return (                            (Funct3(_instr_word) == 3'b100) && (Opcode(_instr_word) == 7'b0010011));
endfunction

function automatic ORI(bit[31:0] _instr_word);
  return (                            (Funct3(_instr_word) == 3'b110) && (Opcode(_instr_word) == 7'b0010011));
endfunction

function automatic ANDI(bit[31:0] _instr_word);
  return (                            (Funct3(_instr_word) == 3'b111) && (Opcode(_instr_word) == 7'b0010011));
endfunction

function automatic SLLI(bit[31:0] _instr_word);
  return ((Funct7(_instr_word) == 7'b0000000) && (Funct3(_instr_word) == 3'b001) && (Opcode(_instr_word) == 7'b0010011));
endfunction

function automatic SRLI(bit[31:0] _instr_word);
  return ((Funct7(_instr_word) == 7'b0000000) && (Funct3(_instr_word) == 3'b101) && (Opcode(_instr_word) == 7'b0010011));
endfunction

function automatic SRAI(bit[31:0] _instr_word);
  return ((Funct7(_instr_word) == 7'b0100000) && (Funct3(_instr_word) == 3'b101) && (Opcode(_instr_word) == 7'b0010011));
endfunction

function automatic LB(bit[31:0] _instr_word);
  return ((Funct3(_instr_word) == 3'b000) && (Opcode(_instr_word) == 7'b0000011));
endfunction

function automatic LH(bit[31:0] _instr_word);
  return ((Funct3(_instr_word) == 3'b001) && (Opcode(_instr_word) == 7'b0000011));
endfunction

function automatic LW(bit[31:0] _instr_word);
  return ((Funct3(_instr_word) == 3'b010) && (Opcode(_instr_word) == 7'b0000011));
endfunction

function automatic LBU(bit[31:0] _instr_word);
  return ((Funct3(_instr_word) == 3'b100) && (Opcode(_instr_word) == 7'b0000011));
endfunction

function automatic LHU(bit[31:0] _instr_word);
  return ((Funct3(_instr_word) == 3'b101) && (Opcode(_instr_word) == 7'b0000011));
endfunction

function automatic SB(bit[31:0] _instr_word);
  return ((Funct3(_instr_word) == 3'b000) && (Opcode(_instr_word) == 7'b0100011));
endfunction

function automatic SH(bit[31:0] _instr_word);
  return ((Funct3(_instr_word) == 3'b001) && (Opcode(_instr_word) == 7'b0100011));
endfunction

function automatic SW(bit[31:0] _instr_word);
  return ((Funct3(_instr_word) == 3'b010) && (Opcode(_instr_word) == 7'b0100011));
endfunction

function automatic BEQ(bit[31:0] _instr_word);
  return ((Funct3(_instr_word) == 3'b000) && (Opcode(_instr_word) == 7'b1100011));
endfunction

function automatic BNE(bit[31:0] _instr_word);
  return ((Funct3(_instr_word) == 3'b001) && (Opcode(_instr_word) == 7'b1100011));
endfunction

function automatic BLT(bit[31:0] _instr_word);
  return ((Funct3(_instr_word) == 3'b100) && (Opcode(_instr_word) == 7'b1100011));
endfunction

function automatic BGE(bit[31:0] _instr_word);
  return ((Funct3(_instr_word) == 3'b101) && (Opcode(_instr_word) == 7'b1100011));
endfunction

function automatic BLTU(bit[31:0] _instr_word);
  return ((Funct3(_instr_word) == 3'b110) && (Opcode(_instr_word) == 7'b1100011));
endfunction

function automatic BGEU(bit[31:0] _instr_word);
  return ((Funct3(_instr_word) == 3'b111) && (Opcode(_instr_word) == 7'b1100011));
endfunction

function automatic JAL(bit[31:0] _instr_word);
  return (                        (Opcode(_instr_word) == 7'b1101111));
endfunction

function automatic JALR(bit[31:0] _instr_word);
  return ((Funct3(_instr_word) == 3'b000) && (Opcode(_instr_word) == 7'b1100111));
endfunction

function automatic MUL(bit[31:0] _instr_word);
  return ((Funct7(_instr_word) == 7'b0000001) && (Funct3(_instr_word) == 3'b000) && (Opcode(_instr_word) == 7'b0110011));
endfunction

function automatic MULH(bit[31:0] _instr_word);
  return ((Funct7(_instr_word) == 7'b0000001) && (Funct3(_instr_word) == 3'b001) && (Opcode(_instr_word) == 7'b0110011));
endfunction

function automatic MULHSU(bit[31:0] _instr_word);
  return ((Funct7(_instr_word) == 7'b0000001) && (Funct3(_instr_word) == 3'b010) && (Opcode(_instr_word) == 7'b0110011));
endfunction

function automatic MULHU(bit[31:0] _instr_word);
  return ((Funct7(_instr_word) == 7'b0000001) && (Funct3(_instr_word) == 3'b011) && (Opcode(_instr_word) == 7'b0110011));
endfunction

function automatic DIV(bit[31:0] _instr_word);
  return ((Funct7(_instr_word) == 7'b0000001) && (Funct3(_instr_word) == 3'b100) && (Opcode(_instr_word) == 7'b0110011));
endfunction

function automatic DIVU(bit[31:0] _instr_word);
  return ((Funct7(_instr_word) == 7'b0000001) && (Funct3(_instr_word) == 3'b101) && (Opcode(_instr_word) == 7'b0110011));
endfunction

function automatic REM(bit[31:0] _instr_word);
  return ((Funct7(_instr_word) == 7'b0000001) && (Funct3(_instr_word) == 3'b110) && (Opcode(_instr_word) == 7'b0110011));
endfunction

function automatic REMU(bit[31:0] _instr_word);
  return ((Funct7(_instr_word) == 7'b0000001) && (Funct3(_instr_word) == 3'b111) && (Opcode(_instr_word) == 7'b0110011));
endfunction

function automatic CSRRW(bit[31:0] _instr_word);
  return ((Funct3(_instr_word) == 3'b001) && (Opcode(_instr_word) == 7'b1110011));
endfunction

function automatic CSRRS(bit[31:0] _instr_word);
  return ((Funct3(_instr_word) == 3'b010) && (Opcode(_instr_word) == 7'b1110011));
endfunction

function automatic CSRRC(bit[31:0] _instr_word);
  return ((Funct3(_instr_word) == 3'b011) && (Opcode(_instr_word) == 7'b1110011));
endfunction

function automatic CSRRWI(bit[31:0] _instr_word);
  return ((Funct3(_instr_word) == 3'b101) && (Opcode(_instr_word) == 7'b1110011));
endfunction

function automatic CSRRSI(bit[31:0] _instr_word);
  return ((Funct3(_instr_word) == 3'b110) && (Opcode(_instr_word) == 7'b1110011));
endfunction

function automatic CSRRCI(bit[31:0] _instr_word);
  return ((Funct3(_instr_word) == 3'b111) && (Opcode(_instr_word) == 7'b1110011));
endfunction

function automatic FENCE(bit[31:0] _instr_word);
  return ((Funct3(_instr_word) == 3'b000) && (Opcode(_instr_word) == 7'b0001111));
endfunction

function automatic FENCE_I(bit[31:0] _instr_word);
  return ((Funct3(_instr_word) == 3'b001) && (Opcode(_instr_word) == 7'b0001111));
endfunction

function automatic EBREAK(bit[31:0] _instr_word);
  return (_instr_word[31:20] == 000000000001 &&(Funct3(_instr_word) == 3'b000) && (Opcode(_instr_word) == 7'b1110011));
endfunction

function automatic ECALL(bit[31:0] _instr_word);
  return (_instr_word[31:20] == 000000000000 && (Funct3(_instr_word) == 3'b000) && (Opcode(_instr_word) == 7'b1110011));
endfunction



function automatic R_Type_Arithmetic_Instruction(bit[31:0] _instr_word);
  return
    ADD(_instr_word) ||
    SUB(_instr_word) ||
    SLL(_instr_word) ||
    SLT(_instr_word) ||
    SLTU(_instr_word) ||
    XOR(_instr_word) ||
    SRL(_instr_word) ||
    SRA(_instr_word) ||
    OR(_instr_word) ||
    AND(_instr_word) ;
endfunction

function automatic I_Type_Arithmetic_Instruction(bit[31:0] _instr_word);
  return
    ADDI(_instr_word) ||
    SLTI(_instr_word) ||
    SLTIU(_instr_word) ||
    XORI(_instr_word) ||
    ORI(_instr_word) ||
    ANDI(_instr_word) ||
    SLLI(_instr_word) ||
    SRLI(_instr_word) ||
    SRAI(_instr_word) ;
endfunction

function automatic Load_Instruction(bit[31:0] _instr_word);
  return
    LB(_instr_word) ||
    LH(_instr_word) ||
    LW(_instr_word) ||
    LBU(_instr_word) ||
    LHU(_instr_word) ;
endfunction

function automatic Store_Instruction(bit[31:0] _instr_word);
  return
    SB(_instr_word) ||
    SH(_instr_word) ||
    SW(_instr_word) ;
endfunction

function automatic Branch_Instruction(bit[31:0] _instr_word);
  return
    BEQ(_instr_word) ||
    BNE(_instr_word) ||
    BLT(_instr_word) ||
    BGE(_instr_word) ||
    BLTU(_instr_word) ||
    BGEU(_instr_word) ;
endfunction

function automatic Jump_Instruction(bit[31:0] _instr_word);
  return
    JAL(_instr_word) ||
    JALR(_instr_word) ;
endfunction

function automatic Mult_Instruction(bit[31:0] _instr_word);
  return
    MUL(_instr_word) ||
    MULH(_instr_word) ||
    MULHSU(_instr_word) ||
    MULHU(_instr_word) ;
endfunction

function automatic Div_Instruction(bit[31:0] _instr_word);
  return
    DIV(_instr_word) ||
    DIVU(_instr_word) ||
    REM(_instr_word) ||
    REMU(_instr_word) ;
endfunction

function automatic CSR_Access_Instruction(bit[31:0] _instr_word);
  return
    CSRRW(_instr_word) ||
    CSRRS(_instr_word) ||
    CSRRC(_instr_word) ||
    CSRRWI(_instr_word) ||
    CSRRSI(_instr_word) ||
    CSRRCI(_instr_word) ;
endfunction

