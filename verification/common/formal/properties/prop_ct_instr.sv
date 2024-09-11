

// Copyright 2024 Katharina Ceesay-Seitz, ETH Zurich.
// Licensed under the General Public License, Version 3.0, see LICENSE for details.
// SPDX-License-Identifier: GPL-3.0-only

  `include `INPUT_ASSUMPTIONS_FILE

  // Design configurations:

  /////////////////////// START - TAINT INJECTION MODELLING ///////////////////////

  `include `TAINT_ASSUMPTIONS_FILE

  /////////////////////// END - TAINT INJECTION MODELLING ///////////////////////

  `include `DECLASSIFICATION_ASSUMPTIONS_FILE

  /////////////////////// START - PROPERTIES                ///////////////////////

  // Signals for ease of debug and property writing
  logic [4:0] rs1_addr;
  logic [4:0] rs2_addr;

  assign rs1_addr = instr_word[19:15];
  assign rs2_addr = instr_word[24:20];

  bit is_rtype_instr, is_itype_instr, is_load_instr, is_store_instr, is_jmp_instr, is_mul_instr, is_div_instr, is_csr_instr;

  `include "prop_instr_types.sv"
  `include "../signal_defs/debug_insn_sigs.sv"
  `include "get_instr_type.sv"

  INSTR_TYPE iuv_type;

  assign is_rtype_instr = R_Type_Arithmetic_Instruction(instr_word);
  assign is_itype_instr = I_Type_Arithmetic_Instruction(instr_word);
  assign is_load_instr  = Load_Instruction(instr_word);
  assign is_store_instr = Store_Instruction(instr_word);
  assign is_jmp_instr   = Jump_Instruction(instr_word);
  assign is_mul_instr   = Mult_Instruction(instr_word);
  assign is_div_instr   = Div_Instruction(instr_word); // is_div_instr_mine;
  assign is_csr_instr   = CSR_Access_Instruction(instr_word);

  // Debug signals
  logic [6:0] debug_opcode;
  logic [2:0] debug_funct3;
  logic [6:0] debug_funct7;
  assign debug_opcode = Opcode(instr_word);
  assign debug_funct3 = Funct3(instr_word);
  assign debug_funct7 = Funct7(instr_word);


  // PC taint check property definitions
  `include "prop_pc_taint_check.sv"

  // PC taint check - checker per instruction - instantiations. Tasks select which ones to include in a proof run.
  `include "../common/formal/properties/checker_inst_pc_taint_checker_to_anytime.sv"
  `include "../common/formal/properties/checker_inst_pc_taint_checker_to_anytime_no_taint_states.sv"

  `ifdef CRYPTO
    `include "crypto_func_defs.sv"
    `include "../signal_defs/crypto_debug_insn_sigs.sv"
    `include "../common/formal/properties/crypto_checker_inst_pc_taint_checker_to_anytime.sv"
    `include "../common/formal/properties/crypto_checker_inst_pc_taint_checker_to_anytime_no_taint_states.sv"
  `endif
  // `include "../common/formal/properties/checker_inst_pc_taint_checker_tm.sv"

  /////////////////////// END - PROPERTIES                ///////////////////////



