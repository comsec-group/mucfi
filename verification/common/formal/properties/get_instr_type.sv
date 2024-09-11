typedef enum {
CSRRS_TYPE = 0,
SRLI_TYPE,
BEQ_TYPE,
SLT_TYPE,
ADDI_TYPE,
ORI_TYPE,
SUB_TYPE,
AND_TYPE,
ADD_TYPE,
CSRRC_TYPE,
AUIPC_TYPE,
FENCE_TYPE,
LH_TYPE,
ANDI_TYPE,
SLLI_TYPE,
CSRRWI_TYPE,
SRA_TYPE,
JALR_TYPE,
OR_TYPE,
DIV_TYPE,
DIVU_TYPE,
MUL_TYPE,
MULH_TYPE,
MULHSU_TYPE,
MULHU_TYPE,
REM_TYPE,
REMU_TYPE,
FENCE_I_TYPE,
CSRRSI_TYPE,
SW_TYPE,
LUI_TYPE,
SLL_TYPE,
CSRRW_TYPE,
SH_TYPE,
SLTI_TYPE,
LBU_TYPE,
XOR_TYPE,
EBREAK_TYPE,
SRAI_TYPE,
JAL_TYPE,
LB_TYPE,
BLT_TYPE,
SLTIU_TYPE,
LHU_TYPE,
BGE_TYPE,
BNE_TYPE,
XORI_TYPE,
SRL_TYPE,
SB_TYPE,
BGEU_TYPE,
LW_TYPE,
CSRRCI_TYPE,
BLTU_TYPE,
SLTU_TYPE,
ECALL_TYPE,
UNKNOW_INSTR_TYPE
} INSTR_TYPE;

function INSTR_TYPE get_instr_type(bit[31:0] _instr_word);
  if (CSRRS(_instr_word)) begin
    return CSRRS_TYPE;
  end
  else if (SRLI(_instr_word)) begin
    return SRLI_TYPE;
  end
  else if (BEQ(_instr_word)) begin
    return BEQ_TYPE;
  end
  else if (SLT(_instr_word)) begin
    return SLT_TYPE;
  end
  else if (ADDI(_instr_word)) begin
    return ADDI_TYPE;
  end
  else if (ORI(_instr_word)) begin
    return ORI_TYPE;
  end
  else if (SUB(_instr_word)) begin
    return SUB_TYPE;
  end
  else if (AND(_instr_word)) begin
    return AND_TYPE;
  end
  else if (ADD(_instr_word)) begin
    return ADD_TYPE;
  end
  else if (CSRRC(_instr_word)) begin
    return CSRRC_TYPE;
  end
  else if (AUIPC(_instr_word)) begin
    return AUIPC_TYPE;
  end
  else if (FENCE(_instr_word)) begin
    return FENCE_TYPE;
  end
  else if (LH(_instr_word)) begin
    return LH_TYPE;
  end
  else if (ANDI(_instr_word)) begin
    return ANDI_TYPE;
  end
  else if (SLLI(_instr_word)) begin
    return SLLI_TYPE;
  end
  else if (CSRRWI(_instr_word)) begin
    return CSRRWI_TYPE;
  end
  else if (SRA(_instr_word)) begin
    return SRA_TYPE;
  end
  else if (JALR(_instr_word)) begin
    return JALR_TYPE;
  end
  else if (OR(_instr_word)) begin
    return OR_TYPE;
  end
  else if (DIV(_instr_word)) begin
    return DIV_TYPE;
  end
  else if (DIVU(_instr_word)) begin
    return DIVU_TYPE;
  end
  else if (MUL(_instr_word)) begin
    return MUL_TYPE;
  end
  else if (MULH(_instr_word)) begin
    return MULH_TYPE;
  end
  else if (MULHSU(_instr_word)) begin
    return MULHSU_TYPE;
  end
  else if (MULHU(_instr_word)) begin
    return MULHU_TYPE;
  end
  else if (REM(_instr_word)) begin
    return REM_TYPE;
  end
  else if (REMU(_instr_word)) begin
    return REMU_TYPE;
  end
  else if (FENCE_I(_instr_word)) begin
    return FENCE_I_TYPE;
  end
  else if (CSRRSI(_instr_word)) begin
    return CSRRSI_TYPE;
  end
  else if (SW(_instr_word)) begin
    return SW_TYPE;
  end
  else if (LUI(_instr_word)) begin
    return LUI_TYPE;
  end
  else if (SLL(_instr_word)) begin
    return SLL_TYPE;
  end
  else if (CSRRW(_instr_word)) begin
    return CSRRW_TYPE;
  end
  else if (SH(_instr_word)) begin
    return SH_TYPE;
  end
  else if (SLTI(_instr_word)) begin
    return SLTI_TYPE;
  end
  else if (LBU(_instr_word)) begin
    return LBU_TYPE;
  end
  else if (XOR(_instr_word)) begin
    return XOR_TYPE;
  end
  else if (EBREAK(_instr_word)) begin
    return EBREAK_TYPE;
  end
  else if (SRAI(_instr_word)) begin
    return SRAI_TYPE;
  end
  else if (JAL(_instr_word)) begin
    return JAL_TYPE;
  end
  else if (LB(_instr_word)) begin
    return LB_TYPE;
  end
  else if (BLT(_instr_word)) begin
    return BLT_TYPE;
  end
  else if (SLTIU(_instr_word)) begin
    return SLTIU_TYPE;
  end
  else if (LHU(_instr_word)) begin
    return LHU_TYPE;
  end
  else if (BGE(_instr_word)) begin
    return BGE_TYPE;
  end
  else if (BNE(_instr_word)) begin
    return BNE_TYPE;
  end
  else if (XORI(_instr_word)) begin
    return XORI_TYPE;
  end
  else if (SRL(_instr_word)) begin
    return SRL_TYPE;
  end
  else if (SB(_instr_word)) begin
    return SB_TYPE;
  end
  else if (BGEU(_instr_word)) begin
    return BGEU_TYPE;
  end
  else if (LW(_instr_word)) begin
    return LW_TYPE;
  end
  else if (CSRRCI(_instr_word)) begin
    return CSRRCI_TYPE;
  end
  else if (BLTU(_instr_word)) begin
    return BLTU_TYPE;
  end
  else if (SLTU(_instr_word)) begin
    return SLTU_TYPE;
  end
  else if (ECALL(_instr_word)) begin
    return ECALL_TYPE;
  end
  else begin
    return UNKNOW_INSTR_TYPE;
  end
endfunction