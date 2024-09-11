
`ifdef CRYPTO
`include "../common/formal/signal_defs/crypto_stop_cond_reg.sv"
`endif

bit taint_stop_cond_ADD_op1;
assign taint_stop_cond_ADD_op1 = cpuregs_rs1_stop_cond;

bit taint_stop_cond_ADD_op2;
assign taint_stop_cond_ADD_op2 = cpuregs_rs2_stop_cond;

bit taint_stop_cond_ADDI_op1;
assign taint_stop_cond_ADDI_op1 = cpuregs_rs1_stop_cond;

bit taint_stop_cond_AND_op1;
assign taint_stop_cond_AND_op1 = cpuregs_rs1_stop_cond;

bit taint_stop_cond_AND_op2;
assign taint_stop_cond_AND_op2 = cpuregs_rs2_stop_cond;

bit taint_stop_cond_ANDI_op1;
assign taint_stop_cond_ANDI_op1 = cpuregs_rs1_stop_cond;

bit taint_stop_cond_BEQ_op1;
assign taint_stop_cond_BEQ_op1 = cpuregs_rs1_stop_cond;

bit taint_stop_cond_BEQ_op2;
assign taint_stop_cond_BEQ_op2 = cpuregs_rs2_stop_cond;

bit taint_stop_cond_BGE_op1;
assign taint_stop_cond_BGE_op1 = cpuregs_rs1_stop_cond;

bit taint_stop_cond_BGE_op2;
assign taint_stop_cond_BGE_op2 = cpuregs_rs2_stop_cond;

bit taint_stop_cond_BGEU_op1;
assign taint_stop_cond_BGEU_op1 = cpuregs_rs1_stop_cond;

bit taint_stop_cond_BGEU_op2;
assign taint_stop_cond_BGEU_op2 = cpuregs_rs2_stop_cond;

bit taint_stop_cond_BLT_op1;
assign taint_stop_cond_BLT_op1 = cpuregs_rs1_stop_cond;

bit taint_stop_cond_BLT_op2;
assign taint_stop_cond_BLT_op2 = cpuregs_rs2_stop_cond;

bit taint_stop_cond_BLTU_op1;
assign taint_stop_cond_BLTU_op1 = cpuregs_rs1_stop_cond;

bit taint_stop_cond_BLTU_op2;
assign taint_stop_cond_BLTU_op2 = cpuregs_rs2_stop_cond;

bit taint_stop_cond_BNE_op1;
assign taint_stop_cond_BNE_op1 = cpuregs_rs1_stop_cond;

bit taint_stop_cond_BNE_op2;
assign taint_stop_cond_BNE_op2 = cpuregs_rs2_stop_cond;

bit taint_stop_cond_DIV_op1;
assign taint_stop_cond_DIV_op1 = cpuregs_rs1_stop_cond;

bit taint_stop_cond_DIV_op2;
assign taint_stop_cond_DIV_op2 = cpuregs_rs2_stop_cond;

bit taint_stop_cond_DIVU_op1;
assign taint_stop_cond_DIVU_op1 = cpuregs_rs1_stop_cond;

bit taint_stop_cond_DIVU_op2;
assign taint_stop_cond_DIVU_op2 = cpuregs_rs2_stop_cond;

bit taint_stop_cond_JALR_op1;
assign taint_stop_cond_JALR_op1 = cpuregs_rs1_stop_cond;

bit taint_stop_cond_LB_op1;
assign taint_stop_cond_LB_op1 = cpuregs_rs1_stop_cond;

bit taint_stop_cond_LBU_op1;
assign taint_stop_cond_LBU_op1 = cpuregs_rs1_stop_cond;

bit taint_stop_cond_LH_op1;
assign taint_stop_cond_LH_op1 = cpuregs_rs1_stop_cond;

bit taint_stop_cond_LHU_op1;
assign taint_stop_cond_LHU_op1 = cpuregs_rs1_stop_cond;

bit taint_stop_cond_LW_op1;
assign taint_stop_cond_LW_op1 = cpuregs_rs1_stop_cond;

bit taint_stop_cond_MUL_op1;
assign taint_stop_cond_MUL_op1 = cpuregs_rs1_stop_cond;

bit taint_stop_cond_MUL_op2;
assign taint_stop_cond_MUL_op2 = cpuregs_rs2_stop_cond;

bit taint_stop_cond_MULH_op1;
assign taint_stop_cond_MULH_op1 = cpuregs_rs1_stop_cond;

bit taint_stop_cond_MULH_op2;
assign taint_stop_cond_MULH_op2 = cpuregs_rs2_stop_cond;

bit taint_stop_cond_MULHSU_op1;
assign taint_stop_cond_MULHSU_op1 = cpuregs_rs1_stop_cond;

bit taint_stop_cond_MULHSU_op2;
assign taint_stop_cond_MULHSU_op2 = cpuregs_rs2_stop_cond;

bit taint_stop_cond_MULHU_op1;
assign taint_stop_cond_MULHU_op1 = cpuregs_rs1_stop_cond;

bit taint_stop_cond_MULHU_op2;
assign taint_stop_cond_MULHU_op2 = cpuregs_rs2_stop_cond;

bit taint_stop_cond_OR_op1;
assign taint_stop_cond_OR_op1 = cpuregs_rs1_stop_cond;

bit taint_stop_cond_OR_op2;
assign taint_stop_cond_OR_op2 = cpuregs_rs2_stop_cond;

bit taint_stop_cond_ORI_op1;
assign taint_stop_cond_ORI_op1 = cpuregs_rs1_stop_cond;

bit taint_stop_cond_REM_op1;
assign taint_stop_cond_REM_op1 = cpuregs_rs1_stop_cond;

bit taint_stop_cond_REM_op2;
assign taint_stop_cond_REM_op2 = cpuregs_rs2_stop_cond;

bit taint_stop_cond_REMU_op1;
assign taint_stop_cond_REMU_op1 = cpuregs_rs1_stop_cond;

bit taint_stop_cond_REMU_op2;
assign taint_stop_cond_REMU_op2 = cpuregs_rs2_stop_cond;

bit taint_stop_cond_SB_op1;
assign taint_stop_cond_SB_op1 = cpuregs_rs1_stop_cond;

bit taint_stop_cond_SH_op1;
assign taint_stop_cond_SH_op1 = cpuregs_rs1_stop_cond;

bit taint_stop_cond_SLL_op1;
assign taint_stop_cond_SLL_op1 = cpuregs_rs1_stop_cond;

bit taint_stop_cond_SLL_op2;
assign taint_stop_cond_SLL_op2 = cpuregs_rs2_stop_cond;

bit taint_stop_cond_SLLI_op1;
assign taint_stop_cond_SLLI_op1 = cpuregs_rs1_stop_cond;

bit taint_stop_cond_SLT_op1;
assign taint_stop_cond_SLT_op1 = cpuregs_rs1_stop_cond;

bit taint_stop_cond_SLT_op2;
assign taint_stop_cond_SLT_op2 = cpuregs_rs2_stop_cond;

bit taint_stop_cond_SLTI_op1;
assign taint_stop_cond_SLTI_op1 = cpuregs_rs1_stop_cond;

bit taint_stop_cond_SLTIU_op1;
assign taint_stop_cond_SLTIU_op1 = cpuregs_rs1_stop_cond;

bit taint_stop_cond_SLTU_op1;
assign taint_stop_cond_SLTU_op1 = cpuregs_rs1_stop_cond;

bit taint_stop_cond_SLTU_op2;
assign taint_stop_cond_SLTU_op2 = cpuregs_rs2_stop_cond;

bit taint_stop_cond_SRA_op1;
assign taint_stop_cond_SRA_op1 = cpuregs_rs1_stop_cond;

bit taint_stop_cond_SRA_op2;
assign taint_stop_cond_SRA_op2 = cpuregs_rs2_stop_cond;

bit taint_stop_cond_SRAI_op1;
assign taint_stop_cond_SRAI_op1 = cpuregs_rs1_stop_cond;

bit taint_stop_cond_SRL_op1;
assign taint_stop_cond_SRL_op1 = cpuregs_rs1_stop_cond;

bit taint_stop_cond_SRL_op2;
assign taint_stop_cond_SRL_op2 = cpuregs_rs2_stop_cond;

bit taint_stop_cond_SRLI_op1;
assign taint_stop_cond_SRLI_op1 = cpuregs_rs1_stop_cond;

bit taint_stop_cond_SUB_op1;
assign taint_stop_cond_SUB_op1 = cpuregs_rs1_stop_cond;

bit taint_stop_cond_SUB_op2;
assign taint_stop_cond_SUB_op2 = cpuregs_rs2_stop_cond;

bit taint_stop_cond_SW_op1;
assign taint_stop_cond_SW_op1 = cpuregs_rs1_stop_cond;

bit taint_stop_cond_XOR_op1;
assign taint_stop_cond_XOR_op1 = cpuregs_rs1_stop_cond;

bit taint_stop_cond_XOR_op2;
assign taint_stop_cond_XOR_op2 = cpuregs_rs2_stop_cond;

bit taint_stop_cond_XORI_op1;
assign taint_stop_cond_XORI_op1 = cpuregs_rs1_stop_cond;

bit taint_stop_cond_CSRRS_op1;
assign taint_stop_cond_CSRRS_op1 = cpuregs_rs1_stop_cond;

bit taint_stop_cond_CSRRC_op1;
assign taint_stop_cond_CSRRC_op1 = cpuregs_rs1_stop_cond;

bit taint_stop_cond_FENCE_op1;
assign taint_stop_cond_FENCE_op1 = cpuregs_rs1_stop_cond;

bit taint_stop_cond_FENCE_I_op1;
assign taint_stop_cond_FENCE_I_op1 = cpuregs_rs1_stop_cond;

bit taint_stop_cond_CSRRWI_op1;
assign taint_stop_cond_CSRRWI_op1 = cpuregs_rs1_stop_cond;

bit taint_stop_cond_CSRRW_op1;
assign taint_stop_cond_CSRRW_op1 = cpuregs_rs1_stop_cond;


bit taint_stop_cond_CSRRSI_op1;
assign taint_stop_cond_CSRRSI_op1 = cpuregs_rs1_stop_cond;

bit taint_stop_cond_EBREAK_op1;
assign taint_stop_cond_EBREAK_op1 = cpuregs_rs1_stop_cond;

bit taint_stop_cond_ECALL_op1;
assign taint_stop_cond_ECALL_op1 = cpuregs_rs1_stop_cond;

bit taint_stop_cond_CSRRCI_op1;
assign taint_stop_cond_CSRRCI_op1 = cpuregs_rs1_stop_cond;



