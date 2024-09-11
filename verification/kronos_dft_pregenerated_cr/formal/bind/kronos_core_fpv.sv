module kronos_core_fpv 
(
clk,
rstz,
instr_addr,
instr_data,
instr_req,
instr_ack,
data_addr,
data_rd_data,
data_wr_data,
data_mask,
data_wr_en,
data_req,
data_ack,
software_interrupt,
timer_interrupt,
external_interrupt,
instr_data_t0,
instr_ack_t0,
instr_addr_t0,
instr_req_t0,
data_ack_t0,
data_addr_t0,
data_mask_t0,
data_rd_data_t0,
data_req_t0,
data_wr_data_t0,
data_wr_en_t0,
external_interrupt_t0,
software_interrupt_t0,
timer_interrupt_t0,
branch,
branch_t0,
branch_target,
branch_target_t0,
decode_addr,
decode_addr_t0,
decode_aluop,
decode_aluop_t0,
decode_basic,
decode_basic_t0,
decode_branch,
decode_branch_t0,
decode_csr,
decode_csr_t0,
decode_illegal,
decode_illegal_t0,
decode_ir,
decode_ir_t0,
decode_jump,
decode_jump_t0,
decode_load,
decode_load_t0,
decode_mask,
decode_mask_t0,
decode_misaligned_jmp,
decode_misaligned_jmp_t0,
decode_misaligned_ldst,
decode_misaligned_ldst_t0,
decode_op1,
decode_op1_t0,
decode_op2,
decode_op2_t0,
decode_pc,
decode_pc_t0,
decode_rdy,
decode_rdy_t0,
decode_regwr_alu,
decode_regwr_alu_t0,
decode_store,
decode_store_t0,
decode_sysop,
decode_sysop_t0,
decode_system,
decode_system_t0,
decode_vld,
decode_vld_t0,
fetch_ir,
fetch_ir_t0,
fetch_pc,
fetch_pc_t0,
fetch_rdy,
fetch_rdy_t0,
fetch_vld,
fetch_vld_t0,
immediate,
immediate_t0,
regrd_rs1,
regrd_rs1_en,
regrd_rs1_en_t0,
regrd_rs1_t0,
regrd_rs2,
regrd_rs2_en,
regrd_rs2_en_t0,
regrd_rs2_t0,
regwr_data,
regwr_data_t0,
regwr_en,
regwr_en_t0,
regwr_pending,
regwr_pending_t0,
regwr_sel,
regwr_sel_t0,
u_ex__clk,
u_ex__rstz,
u_ex__decode_pc,
u_ex__decode_ir,
u_ex__decode_op1,
u_ex__decode_op2,
u_ex__decode_addr,
u_ex__decode_basic,
u_ex__decode_aluop,
u_ex__decode_regwr_alu,
u_ex__decode_jump,
u_ex__decode_branch,
u_ex__decode_load,
u_ex__decode_store,
u_ex__decode_mask,
u_ex__decode_csr,
u_ex__decode_system,
u_ex__decode_sysop,
u_ex__decode_illegal,
u_ex__decode_misaligned_jmp,
u_ex__decode_misaligned_ldst,
u_ex__decode_vld,
u_ex__decode_rdy,
u_ex__regwr_data,
u_ex__regwr_sel,
u_ex__regwr_en,
u_ex__regwr_pending,
u_ex__branch_target,
u_ex__branch,
u_ex__data_addr,
u_ex__data_rd_data,
u_ex__data_wr_data,
u_ex__data_mask,
u_ex__data_wr_en,
u_ex__data_req,
u_ex__data_ack,
u_ex__software_interrupt,
u_ex__timer_interrupt,
u_ex__external_interrupt,
u_ex__regwr_data_t0,
u_ex__regwr_en_t0,
u_ex__regwr_sel_t0,
u_ex__branch_t0,
u_ex__branch_target_t0,
u_ex__decode_rdy_t0,
u_ex__decode_vld_t0,
u_ex__regwr_pending_t0,
u_ex__decode_addr_t0,
u_ex__decode_aluop_t0,
u_ex__decode_basic_t0,
u_ex__decode_branch_t0,
u_ex__decode_csr_t0,
u_ex__decode_illegal_t0,
u_ex__decode_ir_t0,
u_ex__decode_jump_t0,
u_ex__decode_load_t0,
u_ex__decode_mask_t0,
u_ex__decode_misaligned_jmp_t0,
u_ex__decode_misaligned_ldst_t0,
u_ex__decode_op1_t0,
u_ex__decode_op2_t0,
u_ex__decode_pc_t0,
u_ex__decode_regwr_alu_t0,
u_ex__decode_store_t0,
u_ex__decode_sysop_t0,
u_ex__decode_system_t0,
u_ex__data_ack_t0,
u_ex__data_addr_t0,
u_ex__data_mask_t0,
u_ex__data_rd_data_t0,
u_ex__data_req_t0,
u_ex__data_wr_data_t0,
u_ex__data_wr_en_t0,
u_ex__external_interrupt_t0,
u_ex__software_interrupt_t0,
u_ex__timer_interrupt_t0,
u_ex__activate_trap,
u_ex__basic_rdy,
u_ex__core_interrupt,
u_ex__core_interrupt_cause,
u_ex__core_interrupt_cause_t0,
u_ex__core_interrupt_t0,
u_ex__csr_data,
u_ex__csr_data_t0,
u_ex__csr_rdy,
u_ex__csr_rdy_t0,
u_ex__csr_vld,
u_ex__exception,
u_ex__instr_jump,
u_ex__instr_vld,
u_ex__instret,
u_ex__load_data,
u_ex__load_data_t0,
u_ex__lsu_rdy,
u_ex__lsu_rdy_t0,
u_ex__lsu_vld,
u_ex__next_state,
u_ex__regwr_csr,
u_ex__regwr_csr_t0,
u_ex__regwr_lsu,
u_ex__regwr_lsu_t0,
u_ex__regwr_pending_firstcycle,
u_ex__regwr_pending_firstcycle_t0,
u_ex__regwr_pending_later,
u_ex__result,
u_ex__result_t0,
u_ex__return_trap,
u_ex__state,
u_ex__trap_cause,
u_ex__trap_cause_t0,
u_ex__trap_handle,
u_ex__trap_handle_t0,
u_ex__trap_jump,
u_ex__trap_jump_t0,
u_ex__trap_value,
u_ex__trap_value_t0,
u_ex__u_alu__op1,
u_ex__u_alu__op2,
u_ex__u_alu__aluop,
u_ex__u_alu__result,
u_ex__u_alu__aluop_t0,
u_ex__u_alu__op1_t0,
u_ex__u_alu__op2_t0,
u_ex__u_alu__result_t0,
u_ex__u_alu__R_sign,
u_ex__u_alu__R_sign_t0,
u_ex__u_alu__adder_B,
u_ex__u_alu__adder_B_t0,
u_ex__u_alu__cin,
u_ex__u_alu__cout,
u_ex__u_alu__cout_t0,
u_ex__u_alu__data,
u_ex__u_alu__data_t0,
u_ex__u_alu__p0,
u_ex__u_alu__p0_t0,
u_ex__u_alu__p1,
u_ex__u_alu__p1_t0,
u_ex__u_alu__p2,
u_ex__u_alu__p2_t0,
u_ex__u_alu__p3,
u_ex__u_alu__p3_t0,
u_ex__u_alu__p4,
u_ex__u_alu__p4_t0,
u_ex__u_alu__r_adder,
u_ex__u_alu__r_adder_t0,
u_ex__u_alu__r_and,
u_ex__u_alu__r_and_t0,
u_ex__u_alu__r_comp,
u_ex__u_alu__r_comp_t0,
u_ex__u_alu__r_lt,
u_ex__u_alu__r_lt_t0,
u_ex__u_alu__r_ltu,
u_ex__u_alu__r_or,
u_ex__u_alu__r_or_t0,
u_ex__u_alu__r_shift,
u_ex__u_alu__r_shift_t0,
u_ex__u_alu__r_xor,
u_ex__u_alu__r_xor_t0,
u_ex__u_alu__shift_in,
u_ex__u_alu__shift_in_t0,
u_ex__u_csr__clk,
u_ex__u_csr__rstz,
u_ex__u_csr__decode_pc,
u_ex__u_csr__decode_ir,
u_ex__u_csr__decode_op1,
u_ex__u_csr__decode_op2,
u_ex__u_csr__decode_addr,
u_ex__u_csr__decode_basic,
u_ex__u_csr__decode_aluop,
u_ex__u_csr__decode_regwr_alu,
u_ex__u_csr__decode_jump,
u_ex__u_csr__decode_branch,
u_ex__u_csr__decode_load,
u_ex__u_csr__decode_store,
u_ex__u_csr__decode_mask,
u_ex__u_csr__decode_csr,
u_ex__u_csr__decode_system,
u_ex__u_csr__decode_sysop,
u_ex__u_csr__decode_illegal,
u_ex__u_csr__decode_misaligned_jmp,
u_ex__u_csr__decode_misaligned_ldst,
u_ex__u_csr__csr_vld,
u_ex__u_csr__csr_rdy,
u_ex__u_csr__csr_data,
u_ex__u_csr__regwr_csr,
u_ex__u_csr__instret,
u_ex__u_csr__activate_trap,
u_ex__u_csr__return_trap,
u_ex__u_csr__trap_cause,
u_ex__u_csr__trap_value,
u_ex__u_csr__trap_handle,
u_ex__u_csr__trap_jump,
u_ex__u_csr__software_interrupt,
u_ex__u_csr__timer_interrupt,
u_ex__u_csr__external_interrupt,
u_ex__u_csr__core_interrupt,
u_ex__u_csr__core_interrupt_cause,
u_ex__u_csr__decode_addr_t0,
u_ex__u_csr__decode_aluop_t0,
u_ex__u_csr__decode_basic_t0,
u_ex__u_csr__decode_branch_t0,
u_ex__u_csr__decode_csr_t0,
u_ex__u_csr__decode_illegal_t0,
u_ex__u_csr__decode_ir_t0,
u_ex__u_csr__decode_jump_t0,
u_ex__u_csr__decode_load_t0,
u_ex__u_csr__decode_mask_t0,
u_ex__u_csr__decode_misaligned_jmp_t0,
u_ex__u_csr__decode_misaligned_ldst_t0,
u_ex__u_csr__decode_op1_t0,
u_ex__u_csr__decode_op2_t0,
u_ex__u_csr__decode_pc_t0,
u_ex__u_csr__decode_regwr_alu_t0,
u_ex__u_csr__decode_store_t0,
u_ex__u_csr__decode_sysop_t0,
u_ex__u_csr__decode_system_t0,
u_ex__u_csr__activate_trap_t0,
u_ex__u_csr__core_interrupt_t0,
u_ex__u_csr__core_interrupt_cause_t0,
u_ex__u_csr__csr_data_t0,
u_ex__u_csr__csr_rdy_t0,
u_ex__u_csr__csr_vld_t0,
u_ex__u_csr__external_interrupt_t0,
u_ex__u_csr__instret_t0,
u_ex__u_csr__regwr_csr_t0,
u_ex__u_csr__return_trap_t0,
u_ex__u_csr__software_interrupt_t0,
u_ex__u_csr__timer_interrupt_t0,
u_ex__u_csr__trap_cause_t0,
u_ex__u_csr__trap_handle_t0,
u_ex__u_csr__trap_jump_t0,
u_ex__u_csr__trap_value_t0,
u_ex__u_csr__core_interrupt_cause_reg_2_,
u_ex__u_csr__core_interrupt_cause_reg_3_,
u_ex__u_csr__core_interrupt_cause_t0_reg_2_,
u_ex__u_csr__core_interrupt_cause_t0_reg_3_,
u_ex__u_csr__csr_rd_data,
u_ex__u_csr__csr_rd_data_t0,
u_ex__u_csr__csr_rd_en,
u_ex__u_csr__csr_rd_vld,
u_ex__u_csr__csr_wr_data,
u_ex__u_csr__csr_wr_data_t0,
u_ex__u_csr__csr_wr_en,
u_ex__u_csr__csr_wr_vld,
u_ex__u_csr__mcause,
u_ex__u_csr__mcause_t0,
u_ex__u_csr__mcycle,
u_ex__u_csr__mcycle_rd_vld,
u_ex__u_csr__mcycle_rd_vld_t0,
u_ex__u_csr__mcycle_t0,
u_ex__u_csr__mcycle_wrenh,
u_ex__u_csr__mcycle_wrenl,
u_ex__u_csr__mepc,
u_ex__u_csr__mepc_t0,
u_ex__u_csr__mie,
u_ex__u_csr__mie_t0,
u_ex__u_csr__minstret,
u_ex__u_csr__minstret_rd_vld,
u_ex__u_csr__minstret_rd_vld_t0,
u_ex__u_csr__minstret_t0,
u_ex__u_csr__minstret_wrenh,
u_ex__u_csr__minstret_wrenl,
u_ex__u_csr__mip,
u_ex__u_csr__mip_t0,
u_ex__u_csr__mscratch,
u_ex__u_csr__mscratch_t0,
u_ex__u_csr__mstatus,
u_ex__u_csr__mstatus_t0,
u_ex__u_csr__mtval,
u_ex__u_csr__mtval_t0,
u_ex__u_csr__mtvec,
u_ex__u_csr__mtvec_t0,
u_ex__u_csr__next_state,
u_ex__u_csr__state,
u_ex__u_csr__wr_data,
u_ex__u_csr__wr_data_t0,
u_ex__u_csr__u_hpmcounter0__clk,
u_ex__u_csr__u_hpmcounter0__rstz,
u_ex__u_csr__u_hpmcounter0__incr,
u_ex__u_csr__u_hpmcounter0__load_data,
u_ex__u_csr__u_hpmcounter0__load_low,
u_ex__u_csr__u_hpmcounter0__load_high,
u_ex__u_csr__u_hpmcounter0__count,
u_ex__u_csr__u_hpmcounter0__count_vld,
u_ex__u_csr__u_hpmcounter0__load_data_t0,
u_ex__u_csr__u_hpmcounter0__count_t0,
u_ex__u_csr__u_hpmcounter0__count_vld_t0,
u_ex__u_csr__u_hpmcounter0__incr_t0,
u_ex__u_csr__u_hpmcounter0__load_high_t0,
u_ex__u_csr__u_hpmcounter0__load_low_t0,
u_ex__u_csr__u_hpmcounter0__count_high,
u_ex__u_csr__u_hpmcounter0__count_high_t0,
u_ex__u_csr__u_hpmcounter0__count_low,
u_ex__u_csr__u_hpmcounter0__count_low_t0,
u_ex__u_csr__u_hpmcounter0__incr_high,
u_ex__u_csr__u_hpmcounter1__clk,
u_ex__u_csr__u_hpmcounter1__rstz,
u_ex__u_csr__u_hpmcounter1__incr,
u_ex__u_csr__u_hpmcounter1__load_data,
u_ex__u_csr__u_hpmcounter1__load_low,
u_ex__u_csr__u_hpmcounter1__load_high,
u_ex__u_csr__u_hpmcounter1__count,
u_ex__u_csr__u_hpmcounter1__count_vld,
u_ex__u_csr__u_hpmcounter1__load_data_t0,
u_ex__u_csr__u_hpmcounter1__count_t0,
u_ex__u_csr__u_hpmcounter1__count_vld_t0,
u_ex__u_csr__u_hpmcounter1__incr_t0,
u_ex__u_csr__u_hpmcounter1__load_high_t0,
u_ex__u_csr__u_hpmcounter1__load_low_t0,
u_ex__u_csr__u_hpmcounter1__count_high,
u_ex__u_csr__u_hpmcounter1__count_high_t0,
u_ex__u_csr__u_hpmcounter1__count_low,
u_ex__u_csr__u_hpmcounter1__count_low_t0,
u_ex__u_csr__u_hpmcounter1__incr_high,
u_ex__u_lsu__decode_pc,
u_ex__u_lsu__decode_ir,
u_ex__u_lsu__decode_op1,
u_ex__u_lsu__decode_op2,
u_ex__u_lsu__decode_addr,
u_ex__u_lsu__decode_basic,
u_ex__u_lsu__decode_aluop,
u_ex__u_lsu__decode_regwr_alu,
u_ex__u_lsu__decode_jump,
u_ex__u_lsu__decode_branch,
u_ex__u_lsu__decode_load,
u_ex__u_lsu__decode_store,
u_ex__u_lsu__decode_mask,
u_ex__u_lsu__decode_csr,
u_ex__u_lsu__decode_system,
u_ex__u_lsu__decode_sysop,
u_ex__u_lsu__decode_illegal,
u_ex__u_lsu__decode_misaligned_jmp,
u_ex__u_lsu__decode_misaligned_ldst,
u_ex__u_lsu__lsu_vld,
u_ex__u_lsu__lsu_rdy,
u_ex__u_lsu__load_data,
u_ex__u_lsu__regwr_lsu,
u_ex__u_lsu__data_addr,
u_ex__u_lsu__data_rd_data,
u_ex__u_lsu__data_wr_data,
u_ex__u_lsu__data_mask,
u_ex__u_lsu__data_wr_en,
u_ex__u_lsu__data_req,
u_ex__u_lsu__data_ack,
u_ex__u_lsu__decode_addr_t0,
u_ex__u_lsu__decode_aluop_t0,
u_ex__u_lsu__decode_basic_t0,
u_ex__u_lsu__decode_branch_t0,
u_ex__u_lsu__decode_csr_t0,
u_ex__u_lsu__decode_illegal_t0,
u_ex__u_lsu__decode_ir_t0,
u_ex__u_lsu__decode_jump_t0,
u_ex__u_lsu__decode_load_t0,
u_ex__u_lsu__decode_mask_t0,
u_ex__u_lsu__decode_misaligned_jmp_t0,
u_ex__u_lsu__decode_misaligned_ldst_t0,
u_ex__u_lsu__decode_op1_t0,
u_ex__u_lsu__decode_op2_t0,
u_ex__u_lsu__decode_pc_t0,
u_ex__u_lsu__decode_regwr_alu_t0,
u_ex__u_lsu__decode_store_t0,
u_ex__u_lsu__decode_sysop_t0,
u_ex__u_lsu__decode_system_t0,
u_ex__u_lsu__data_ack_t0,
u_ex__u_lsu__data_addr_t0,
u_ex__u_lsu__data_mask_t0,
u_ex__u_lsu__data_rd_data_t0,
u_ex__u_lsu__data_req_t0,
u_ex__u_lsu__data_wr_data_t0,
u_ex__u_lsu__data_wr_en_t0,
u_ex__u_lsu__load_data_t0,
u_ex__u_lsu__lsu_rdy_t0,
u_ex__u_lsu__lsu_vld_t0,
u_ex__u_lsu__regwr_lsu_t0,
u_ex__u_lsu__byte_data,
u_ex__u_lsu__byte_data_t0,
u_ex__u_lsu__half_data,
u_ex__u_lsu__half_data_t0,
u_ex__u_lsu__word_data,
u_ex__u_lsu__word_data_t0,
u_id__clk,
u_id__rstz,
u_id__flush,
u_id__fetch_pc,
u_id__fetch_ir,
u_id__immediate,
u_id__regrd_rs1,
u_id__regrd_rs2,
u_id__regrd_rs1_en,
u_id__regrd_rs2_en,
u_id__fetch_vld,
u_id__fetch_rdy,
u_id__decode_pc,
u_id__decode_ir,
u_id__decode_op1,
u_id__decode_op2,
u_id__decode_addr,
u_id__decode_basic,
u_id__decode_aluop,
u_id__decode_regwr_alu,
u_id__decode_jump,
u_id__decode_branch,
u_id__decode_load,
u_id__decode_store,
u_id__decode_mask,
u_id__decode_csr,
u_id__decode_system,
u_id__decode_sysop,
u_id__decode_illegal,
u_id__decode_misaligned_jmp,
u_id__decode_misaligned_ldst,
u_id__decode_vld,
u_id__decode_rdy,
u_id__regwr_data,
u_id__regwr_sel,
u_id__regwr_en,
u_id__regwr_pending,
u_id__fetch_rdy_t0,
u_id__regrd_rs2_en_t0,
u_id__immediate_t0,
u_id__regrd_rs1_t0,
u_id__regrd_rs2_t0,
u_id__regrd_rs1_en_t0,
u_id__regwr_data_t0,
u_id__regwr_en_t0,
u_id__regwr_sel_t0,
u_id__fetch_ir_t0,
u_id__fetch_pc_t0,
u_id__fetch_vld_t0,
u_id__decode_rdy_t0,
u_id__decode_vld_t0,
u_id__flush_t0,
u_id__regwr_pending_t0,
u_id__decode_addr_t0,
u_id__decode_aluop_t0,
u_id__decode_basic_t0,
u_id__decode_branch_t0,
u_id__decode_csr_t0,
u_id__decode_illegal_t0,
u_id__decode_ir_t0,
u_id__decode_jump_t0,
u_id__decode_load_t0,
u_id__decode_mask_t0,
u_id__decode_misaligned_jmp_t0,
u_id__decode_misaligned_ldst_t0,
u_id__decode_op1_t0,
u_id__decode_op2_t0,
u_id__decode_pc_t0,
u_id__decode_regwr_alu_t0,
u_id__decode_store_t0,
u_id__decode_sysop_t0,
u_id__decode_system_t0,
u_id__addr,
u_id__addr_t0,
u_id__aluop,
u_id__aluop_t0,
u_id__base,
u_id__base_t0,
u_id__branch,
u_id__branch_t0,
u_id__csr,
u_id__illegal,
u_id__illegal_opcode,
u_id__instr_valid,
u_id__is_fencei,
u_id__misaligned_jmp,
u_id__misaligned_jmp_t0,
u_id__misaligned_ldst,
u_id__misaligned_ldst_t0,
u_id__offset,
u_id__offset_t0,
u_id__op1,
u_id__op1_t0,
u_id__op2,
u_id__op2_t0,
u_id__regwr_alu,
u_id__rs1_data,
u_id__rs1_data_t0,
u_id__rs1_forward,
u_id__rs2_data,
u_id__rs2_data_t0,
u_id__rs2_forward,
u_id__stall,
u_id__stall_t0,
u_id__store_data,
u_id__store_data_t0,
u_id__u_agu__instr,
u_id__u_agu__base,
u_id__u_agu__offset,
u_id__u_agu__addr,
u_id__u_agu__misaligned_jmp,
u_id__u_agu__misaligned_ldst,
u_id__u_agu__instr_t0,
u_id__u_agu__addr_t0,
u_id__u_agu__base_t0,
u_id__u_agu__misaligned_jmp_t0,
u_id__u_agu__misaligned_ldst_t0,
u_id__u_agu__offset_t0,
u_id__u_agu__addr_raw,
u_id__u_agu__addr_raw_t0,
u_id__u_agu__align,
u_id__u_branch__op,
u_id__u_branch__rs1,
u_id__u_branch__rs2,
u_id__u_branch__branch,
u_id__u_branch__branch_t0,
u_id__u_branch__op_t0,
u_id__u_branch__rs1_t0,
u_id__u_branch__rs2_t0,
u_id__u_branch__eq,
u_id__u_branch__lt,
u_id__u_hcu__clk,
u_id__u_hcu__rstz,
u_id__u_hcu__flush,
u_id__u_hcu__instr,
u_id__u_hcu__regrd_rs1_en,
u_id__u_hcu__regrd_rs2_en,
u_id__u_hcu__fetch_vld,
u_id__u_hcu__fetch_rdy,
u_id__u_hcu__decode_vld,
u_id__u_hcu__decode_rdy,
u_id__u_hcu__regwr_sel,
u_id__u_hcu__regwr_en,
u_id__u_hcu__regwr_pending,
u_id__u_hcu__stall,
u_id__u_hcu__fetch_rdy_t0,
u_id__u_hcu__regrd_rs2_en_t0,
u_id__u_hcu__regrd_rs1_en_t0,
u_id__u_hcu__regwr_en_t0,
u_id__u_hcu__regwr_sel_t0,
u_id__u_hcu__fetch_vld_t0,
u_id__u_hcu__decode_rdy_t0,
u_id__u_hcu__decode_vld_t0,
u_id__u_hcu__flush_t0,
u_id__u_hcu__instr_t0,
u_id__u_hcu__regwr_pending_t0,
u_id__u_hcu__stall_t0,
u_id__u_hcu__rpend,
u_id__u_hcu__rs1_hazard,
u_id__u_hcu__rs1_hazard_t0,
u_id__u_hcu__rs2_hazard,
u_id__u_hcu__rs2_hazard_t0,
u_if__clk,
u_if__rstz,
u_if__instr_addr,
u_if__instr_data,
u_if__instr_req,
u_if__instr_ack,
u_if__fetch_pc,
u_if__fetch_ir,
u_if__immediate,
u_if__regrd_rs1,
u_if__regrd_rs2,
u_if__regrd_rs1_en,
u_if__regrd_rs2_en,
u_if__fetch_vld,
u_if__fetch_rdy,
u_if__branch_target,
u_if__branch,
u_if__regwr_data,
u_if__regwr_sel,
u_if__regwr_en,
u_if__fetch_rdy_t0,
u_if__regrd_rs2_en_t0,
u_if__immediate_t0,
u_if__instr_data_t0,
u_if__regrd_rs1_t0,
u_if__regrd_rs2_t0,
u_if__regrd_rs1_en_t0,
u_if__regwr_data_t0,
u_if__regwr_en_t0,
u_if__regwr_sel_t0,
u_if__branch_t0,
u_if__branch_target_t0,
u_if__fetch_ir_t0,
u_if__fetch_pc_t0,
u_if__fetch_vld_t0,
u_if__instr_ack_t0,
u_if__instr_addr_t0,
u_if__instr_req_t0,
u_if__instr_vld,
u_if__next_instr,
u_if__next_instr_t0,
u_if__next_state,
u_if__pc,
u_if__pc_last,
u_if__pc_last_t0,
u_if__pc_t0,
u_if__pipe_rdy,
u_if__skid_buffer,
u_if__skid_buffer_t0,
u_if__state,
u_if__u_rf__clk,
u_if__u_rf__rstz,
u_if__u_rf__instr_data,
u_if__u_rf__instr_vld,
u_if__u_rf__fetch_rdy,
u_if__u_rf__immediate,
u_if__u_rf__regrd_rs1,
u_if__u_rf__regrd_rs2,
u_if__u_rf__regrd_rs1_en,
u_if__u_rf__regrd_rs2_en,
u_if__u_rf__regwr_data,
u_if__u_rf__regwr_sel,
u_if__u_rf__regwr_en,
u_if__u_rf__fetch_rdy_t0,
u_if__u_rf__instr_vld_t0,
u_if__u_rf__regrd_rs2_en_t0,
u_if__u_rf__immediate_t0,
u_if__u_rf__instr_data_t0,
u_if__u_rf__regrd_rs1_t0,
u_if__u_rf__regrd_rs2_t0,
u_if__u_rf__regrd_rs1_en_t0,
u_if__u_rf__regwr_data_t0,
u_if__u_rf__regwr_en_t0,
u_if__u_rf__regwr_sel_t0,
u_if__u_rf__ImmA,
u_if__u_rf__ImmA_t0,
u_if__u_rf__ImmE,
u_if__u_rf__ImmE_t0,
u_if__u_rf__ImmF,
u_if__u_rf__ImmF_t0,
u_if__u_rf__REG_0_,
u_if__u_rf__REG_0__t0,
u_if__u_rf__REG_10_,
u_if__u_rf__REG_10__t0,
u_if__u_rf__REG_11_,
u_if__u_rf__REG_11__t0,
u_if__u_rf__REG_12_,
u_if__u_rf__REG_12__t0,
u_if__u_rf__REG_13_,
u_if__u_rf__REG_13__t0,
u_if__u_rf__REG_14_,
u_if__u_rf__REG_14__t0,
u_if__u_rf__REG_15_,
u_if__u_rf__REG_15__t0,
u_if__u_rf__REG_16_,
u_if__u_rf__REG_16__t0,
u_if__u_rf__REG_17_,
u_if__u_rf__REG_17__t0,
u_if__u_rf__REG_18_,
u_if__u_rf__REG_18__t0,
u_if__u_rf__REG_19_,
u_if__u_rf__REG_19__t0,
u_if__u_rf__REG_1_,
u_if__u_rf__REG_1__t0,
u_if__u_rf__REG_20_,
u_if__u_rf__REG_20__t0,
u_if__u_rf__REG_21_,
u_if__u_rf__REG_21__t0,
u_if__u_rf__REG_22_,
u_if__u_rf__REG_22__t0,
u_if__u_rf__REG_23_,
u_if__u_rf__REG_23__t0,
u_if__u_rf__REG_24_,
u_if__u_rf__REG_24__t0,
u_if__u_rf__REG_25_,
u_if__u_rf__REG_25__t0,
u_if__u_rf__REG_26_,
u_if__u_rf__REG_26__t0,
u_if__u_rf__REG_27_,
u_if__u_rf__REG_27__t0,
u_if__u_rf__REG_28_,
u_if__u_rf__REG_28__t0,
u_if__u_rf__REG_29_,
u_if__u_rf__REG_29__t0,
u_if__u_rf__REG_2_,
u_if__u_rf__REG_2__t0,
u_if__u_rf__REG_30_,
u_if__u_rf__REG_30__t0,
u_if__u_rf__REG_31_,
u_if__u_rf__REG_31__t0,
u_if__u_rf__REG_3_,
u_if__u_rf__REG_3__t0,
u_if__u_rf__REG_4_,
u_if__u_rf__REG_4__t0,
u_if__u_rf__REG_5_,
u_if__u_rf__REG_5__t0,
u_if__u_rf__REG_6_,
u_if__u_rf__REG_6__t0,
u_if__u_rf__REG_7_,
u_if__u_rf__REG_7__t0,
u_if__u_rf__REG_8_,
u_if__u_rf__REG_8__t0,
u_if__u_rf__REG_9_,
u_if__u_rf__REG_9__t0,
u_if__u_rf__csr_regrd,
u_if__u_rf__format_B,
u_if__u_rf__format_I,
u_if__u_rf__format_J,
u_if__u_rf__format_S,
u_if__u_rf__format_U,
u_if__u_rf__instr_rdy,
u_if__u_rf__is_regrd_rs1_en,
u_if__u_rf__is_regrd_rs2_en,
u_if__u_rf__reg_rs1,
u_if__u_rf__reg_rs2,
u_if__u_rf__reg_vld,
u_ex__u_csr___1089_,
u_ex__u_csr___1093_,
u_if__u_rf___0742_,
u_if__u_rf___1126_);


input logic clk;
input logic rstz;
input logic [31:0] instr_addr;
input logic [31:0] instr_data;
input logic instr_req;
input logic instr_ack;
input logic [31:0] data_addr;
input logic [31:0] data_rd_data;
input logic [31:0] data_wr_data;
input logic [3:0] data_mask;
input logic data_wr_en;
input logic data_req;
input logic data_ack;
input logic software_interrupt;
input logic timer_interrupt;
input logic external_interrupt;
input logic [31:0] instr_data_t0;
input logic instr_ack_t0;
input logic [31:0] instr_addr_t0;
input logic instr_req_t0;
input logic data_ack_t0;
input logic [31:0] data_addr_t0;
input logic [3:0] data_mask_t0;
input logic [31:0] data_rd_data_t0;
input logic data_req_t0;
input logic [31:0] data_wr_data_t0;
input logic data_wr_en_t0;
input logic external_interrupt_t0;
input logic software_interrupt_t0;
input logic timer_interrupt_t0;
input logic branch;
input logic branch_t0;
input logic [31:0] branch_target;
input logic [31:0] branch_target_t0;
input logic [31:0] decode_addr;
input logic [31:0] decode_addr_t0;
input logic [3:0] decode_aluop;
input logic [3:0] decode_aluop_t0;
input logic decode_basic;
input logic decode_basic_t0;
input logic decode_branch;
input logic decode_branch_t0;
input logic decode_csr;
input logic decode_csr_t0;
input logic decode_illegal;
input logic decode_illegal_t0;
input logic [31:0] decode_ir;
input logic [31:0] decode_ir_t0;
input logic decode_jump;
input logic decode_jump_t0;
input logic decode_load;
input logic decode_load_t0;
input logic [3:0] decode_mask;
input logic [3:0] decode_mask_t0;
input logic decode_misaligned_jmp;
input logic decode_misaligned_jmp_t0;
input logic decode_misaligned_ldst;
input logic decode_misaligned_ldst_t0;
input logic [31:0] decode_op1;
input logic [31:0] decode_op1_t0;
input logic [31:0] decode_op2;
input logic [31:0] decode_op2_t0;
input logic [31:0] decode_pc;
input logic [31:0] decode_pc_t0;
input logic decode_rdy;
input logic decode_rdy_t0;
input logic decode_regwr_alu;
input logic decode_regwr_alu_t0;
input logic decode_store;
input logic decode_store_t0;
input logic [1:0] decode_sysop;
input logic [1:0] decode_sysop_t0;
input logic decode_system;
input logic decode_system_t0;
input logic decode_vld;
input logic decode_vld_t0;
input logic [31:0] fetch_ir;
input logic [31:0] fetch_ir_t0;
input logic [31:0] fetch_pc;
input logic [31:0] fetch_pc_t0;
input logic fetch_rdy;
input logic fetch_rdy_t0;
input logic fetch_vld;
input logic fetch_vld_t0;
input logic [31:0] immediate;
input logic [31:0] immediate_t0;
input logic [31:0] regrd_rs1;
input logic regrd_rs1_en;
input logic regrd_rs1_en_t0;
input logic [31:0] regrd_rs1_t0;
input logic [31:0] regrd_rs2;
input logic regrd_rs2_en;
input logic regrd_rs2_en_t0;
input logic [31:0] regrd_rs2_t0;
input logic [31:0] regwr_data;
input logic [31:0] regwr_data_t0;
input logic regwr_en;
input logic regwr_en_t0;
input logic regwr_pending;
input logic regwr_pending_t0;
input logic [4:0] regwr_sel;
input logic [4:0] regwr_sel_t0;
input logic u_ex__clk;
input logic u_ex__rstz;
input logic [31:0] u_ex__decode_pc;
input logic [31:0] u_ex__decode_ir;
input logic [31:0] u_ex__decode_op1;
input logic [31:0] u_ex__decode_op2;
input logic [31:0] u_ex__decode_addr;
input logic u_ex__decode_basic;
input logic [3:0] u_ex__decode_aluop;
input logic u_ex__decode_regwr_alu;
input logic u_ex__decode_jump;
input logic u_ex__decode_branch;
input logic u_ex__decode_load;
input logic u_ex__decode_store;
input logic [3:0] u_ex__decode_mask;
input logic u_ex__decode_csr;
input logic u_ex__decode_system;
input logic [1:0] u_ex__decode_sysop;
input logic u_ex__decode_illegal;
input logic u_ex__decode_misaligned_jmp;
input logic u_ex__decode_misaligned_ldst;
input logic u_ex__decode_vld;
input logic u_ex__decode_rdy;
input logic [31:0] u_ex__regwr_data;
input logic [4:0] u_ex__regwr_sel;
input logic u_ex__regwr_en;
input logic u_ex__regwr_pending;
input logic [31:0] u_ex__branch_target;
input logic u_ex__branch;
input logic [31:0] u_ex__data_addr;
input logic [31:0] u_ex__data_rd_data;
input logic [31:0] u_ex__data_wr_data;
input logic [3:0] u_ex__data_mask;
input logic u_ex__data_wr_en;
input logic u_ex__data_req;
input logic u_ex__data_ack;
input logic u_ex__software_interrupt;
input logic u_ex__timer_interrupt;
input logic u_ex__external_interrupt;
input logic [31:0] u_ex__regwr_data_t0;
input logic u_ex__regwr_en_t0;
input logic [4:0] u_ex__regwr_sel_t0;
input logic u_ex__branch_t0;
input logic [31:0] u_ex__branch_target_t0;
input logic u_ex__decode_rdy_t0;
input logic u_ex__decode_vld_t0;
input logic u_ex__regwr_pending_t0;
input logic [31:0] u_ex__decode_addr_t0;
input logic [3:0] u_ex__decode_aluop_t0;
input logic u_ex__decode_basic_t0;
input logic u_ex__decode_branch_t0;
input logic u_ex__decode_csr_t0;
input logic u_ex__decode_illegal_t0;
input logic [31:0] u_ex__decode_ir_t0;
input logic u_ex__decode_jump_t0;
input logic u_ex__decode_load_t0;
input logic [3:0] u_ex__decode_mask_t0;
input logic u_ex__decode_misaligned_jmp_t0;
input logic u_ex__decode_misaligned_ldst_t0;
input logic [31:0] u_ex__decode_op1_t0;
input logic [31:0] u_ex__decode_op2_t0;
input logic [31:0] u_ex__decode_pc_t0;
input logic u_ex__decode_regwr_alu_t0;
input logic u_ex__decode_store_t0;
input logic [1:0] u_ex__decode_sysop_t0;
input logic u_ex__decode_system_t0;
input logic u_ex__data_ack_t0;
input logic [31:0] u_ex__data_addr_t0;
input logic [3:0] u_ex__data_mask_t0;
input logic [31:0] u_ex__data_rd_data_t0;
input logic u_ex__data_req_t0;
input logic [31:0] u_ex__data_wr_data_t0;
input logic u_ex__data_wr_en_t0;
input logic u_ex__external_interrupt_t0;
input logic u_ex__software_interrupt_t0;
input logic u_ex__timer_interrupt_t0;
input logic u_ex__activate_trap;
input logic u_ex__basic_rdy;
input logic u_ex__core_interrupt;
input logic [3:0] u_ex__core_interrupt_cause;
input logic [3:0] u_ex__core_interrupt_cause_t0;
input logic u_ex__core_interrupt_t0;
input logic [31:0] u_ex__csr_data;
input logic [31:0] u_ex__csr_data_t0;
input logic u_ex__csr_rdy;
input logic u_ex__csr_rdy_t0;
input logic u_ex__csr_vld;
input logic u_ex__exception;
input logic u_ex__instr_jump;
input logic u_ex__instr_vld;
input logic u_ex__instret;
input logic [31:0] u_ex__load_data;
input logic [31:0] u_ex__load_data_t0;
input logic u_ex__lsu_rdy;
input logic u_ex__lsu_rdy_t0;
input logic u_ex__lsu_vld;
input logic [2:0] u_ex__next_state;
input logic u_ex__regwr_csr;
input logic u_ex__regwr_csr_t0;
input logic u_ex__regwr_lsu;
input logic u_ex__regwr_lsu_t0;
input logic u_ex__regwr_pending_firstcycle;
input logic u_ex__regwr_pending_firstcycle_t0;
input logic u_ex__regwr_pending_later;
input logic [31:0] u_ex__result;
input logic [31:0] u_ex__result_t0;
input logic u_ex__return_trap;
input logic [2:0] u_ex__state;
input logic [31:0] u_ex__trap_cause;
input logic [31:0] u_ex__trap_cause_t0;
input logic [31:0] u_ex__trap_handle;
input logic [31:0] u_ex__trap_handle_t0;
input logic u_ex__trap_jump;
input logic u_ex__trap_jump_t0;
input logic [31:0] u_ex__trap_value;
input logic [31:0] u_ex__trap_value_t0;
input logic [31:0] u_ex__u_alu__op1;
input logic [31:0] u_ex__u_alu__op2;
input logic [3:0] u_ex__u_alu__aluop;
input logic [31:0] u_ex__u_alu__result;
input logic [3:0] u_ex__u_alu__aluop_t0;
input logic [31:0] u_ex__u_alu__op1_t0;
input logic [31:0] u_ex__u_alu__op2_t0;
input logic [31:0] u_ex__u_alu__result_t0;
input logic u_ex__u_alu__R_sign;
input logic u_ex__u_alu__R_sign_t0;
input logic [31:0] u_ex__u_alu__adder_B;
input logic [31:0] u_ex__u_alu__adder_B_t0;
input logic u_ex__u_alu__cin;
input logic u_ex__u_alu__cout;
input logic u_ex__u_alu__cout_t0;
input logic [31:0] u_ex__u_alu__data;
input logic [31:0] u_ex__u_alu__data_t0;
input logic [31:0] u_ex__u_alu__p0;
input logic [31:0] u_ex__u_alu__p0_t0;
input logic [31:0] u_ex__u_alu__p1;
input logic [31:0] u_ex__u_alu__p1_t0;
input logic [31:0] u_ex__u_alu__p2;
input logic [31:0] u_ex__u_alu__p2_t0;
input logic [31:0] u_ex__u_alu__p3;
input logic [31:0] u_ex__u_alu__p3_t0;
input logic [31:0] u_ex__u_alu__p4;
input logic [31:0] u_ex__u_alu__p4_t0;
input logic [31:0] u_ex__u_alu__r_adder;
input logic [31:0] u_ex__u_alu__r_adder_t0;
input logic [31:0] u_ex__u_alu__r_and;
input logic [31:0] u_ex__u_alu__r_and_t0;
input logic u_ex__u_alu__r_comp;
input logic u_ex__u_alu__r_comp_t0;
input logic u_ex__u_alu__r_lt;
input logic u_ex__u_alu__r_lt_t0;
input logic u_ex__u_alu__r_ltu;
input logic [31:0] u_ex__u_alu__r_or;
input logic [31:0] u_ex__u_alu__r_or_t0;
input logic [31:0] u_ex__u_alu__r_shift;
input logic [31:0] u_ex__u_alu__r_shift_t0;
input logic [31:0] u_ex__u_alu__r_xor;
input logic [31:0] u_ex__u_alu__r_xor_t0;
input logic u_ex__u_alu__shift_in;
input logic u_ex__u_alu__shift_in_t0;
input logic u_ex__u_csr__clk;
input logic u_ex__u_csr__rstz;
input logic [31:0] u_ex__u_csr__decode_pc;
input logic [31:0] u_ex__u_csr__decode_ir;
input logic [31:0] u_ex__u_csr__decode_op1;
input logic [31:0] u_ex__u_csr__decode_op2;
input logic [31:0] u_ex__u_csr__decode_addr;
input logic u_ex__u_csr__decode_basic;
input logic [3:0] u_ex__u_csr__decode_aluop;
input logic u_ex__u_csr__decode_regwr_alu;
input logic u_ex__u_csr__decode_jump;
input logic u_ex__u_csr__decode_branch;
input logic u_ex__u_csr__decode_load;
input logic u_ex__u_csr__decode_store;
input logic [3:0] u_ex__u_csr__decode_mask;
input logic u_ex__u_csr__decode_csr;
input logic u_ex__u_csr__decode_system;
input logic [1:0] u_ex__u_csr__decode_sysop;
input logic u_ex__u_csr__decode_illegal;
input logic u_ex__u_csr__decode_misaligned_jmp;
input logic u_ex__u_csr__decode_misaligned_ldst;
input logic u_ex__u_csr__csr_vld;
input logic u_ex__u_csr__csr_rdy;
input logic [31:0] u_ex__u_csr__csr_data;
input logic u_ex__u_csr__regwr_csr;
input logic u_ex__u_csr__instret;
input logic u_ex__u_csr__activate_trap;
input logic u_ex__u_csr__return_trap;
input logic [31:0] u_ex__u_csr__trap_cause;
input logic [31:0] u_ex__u_csr__trap_value;
input logic [31:0] u_ex__u_csr__trap_handle;
input logic u_ex__u_csr__trap_jump;
input logic u_ex__u_csr__software_interrupt;
input logic u_ex__u_csr__timer_interrupt;
input logic u_ex__u_csr__external_interrupt;
input logic u_ex__u_csr__core_interrupt;
input logic [3:0] u_ex__u_csr__core_interrupt_cause;
input logic [31:0] u_ex__u_csr__decode_addr_t0;
input logic [3:0] u_ex__u_csr__decode_aluop_t0;
input logic u_ex__u_csr__decode_basic_t0;
input logic u_ex__u_csr__decode_branch_t0;
input logic u_ex__u_csr__decode_csr_t0;
input logic u_ex__u_csr__decode_illegal_t0;
input logic [31:0] u_ex__u_csr__decode_ir_t0;
input logic u_ex__u_csr__decode_jump_t0;
input logic u_ex__u_csr__decode_load_t0;
input logic [3:0] u_ex__u_csr__decode_mask_t0;
input logic u_ex__u_csr__decode_misaligned_jmp_t0;
input logic u_ex__u_csr__decode_misaligned_ldst_t0;
input logic [31:0] u_ex__u_csr__decode_op1_t0;
input logic [31:0] u_ex__u_csr__decode_op2_t0;
input logic [31:0] u_ex__u_csr__decode_pc_t0;
input logic u_ex__u_csr__decode_regwr_alu_t0;
input logic u_ex__u_csr__decode_store_t0;
input logic [1:0] u_ex__u_csr__decode_sysop_t0;
input logic u_ex__u_csr__decode_system_t0;
input logic u_ex__u_csr__activate_trap_t0;
input logic u_ex__u_csr__core_interrupt_t0;
input logic [3:0] u_ex__u_csr__core_interrupt_cause_t0;
input logic [31:0] u_ex__u_csr__csr_data_t0;
input logic u_ex__u_csr__csr_rdy_t0;
input logic u_ex__u_csr__csr_vld_t0;
input logic u_ex__u_csr__external_interrupt_t0;
input logic u_ex__u_csr__instret_t0;
input logic u_ex__u_csr__regwr_csr_t0;
input logic u_ex__u_csr__return_trap_t0;
input logic u_ex__u_csr__software_interrupt_t0;
input logic u_ex__u_csr__timer_interrupt_t0;
input logic [31:0] u_ex__u_csr__trap_cause_t0;
input logic [31:0] u_ex__u_csr__trap_handle_t0;
input logic u_ex__u_csr__trap_jump_t0;
input logic [31:0] u_ex__u_csr__trap_value_t0;
input logic u_ex__u_csr__core_interrupt_cause_reg_2_;
input logic u_ex__u_csr__core_interrupt_cause_reg_3_;
input logic u_ex__u_csr__core_interrupt_cause_t0_reg_2_;
input logic u_ex__u_csr__core_interrupt_cause_t0_reg_3_;
input logic [31:0] u_ex__u_csr__csr_rd_data;
input logic [31:0] u_ex__u_csr__csr_rd_data_t0;
input logic u_ex__u_csr__csr_rd_en;
input logic u_ex__u_csr__csr_rd_vld;
input logic [31:0] u_ex__u_csr__csr_wr_data;
input logic [31:0] u_ex__u_csr__csr_wr_data_t0;
input logic u_ex__u_csr__csr_wr_en;
input logic u_ex__u_csr__csr_wr_vld;
input logic [31:0] u_ex__u_csr__mcause;
input logic [31:0] u_ex__u_csr__mcause_t0;
input logic [63:0] u_ex__u_csr__mcycle;
input logic u_ex__u_csr__mcycle_rd_vld;
input logic u_ex__u_csr__mcycle_rd_vld_t0;
input logic [63:0] u_ex__u_csr__mcycle_t0;
input logic u_ex__u_csr__mcycle_wrenh;
input logic u_ex__u_csr__mcycle_wrenl;
input logic [31:0] u_ex__u_csr__mepc;
input logic [31:0] u_ex__u_csr__mepc_t0;
input logic [2:0] u_ex__u_csr__mie;
input logic [2:0] u_ex__u_csr__mie_t0;
input logic [63:0] u_ex__u_csr__minstret;
input logic u_ex__u_csr__minstret_rd_vld;
input logic u_ex__u_csr__minstret_rd_vld_t0;
input logic [63:0] u_ex__u_csr__minstret_t0;
input logic u_ex__u_csr__minstret_wrenh;
input logic u_ex__u_csr__minstret_wrenl;
input logic [2:0] u_ex__u_csr__mip;
input logic [2:0] u_ex__u_csr__mip_t0;
input logic [31:0] u_ex__u_csr__mscratch;
input logic [31:0] u_ex__u_csr__mscratch_t0;
input logic [3:0] u_ex__u_csr__mstatus;
input logic [3:0] u_ex__u_csr__mstatus_t0;
input logic [31:0] u_ex__u_csr__mtval;
input logic [31:0] u_ex__u_csr__mtval_t0;
input logic [31:0] u_ex__u_csr__mtvec;
input logic [31:0] u_ex__u_csr__mtvec_t0;
input logic [1:0] u_ex__u_csr__next_state;
input logic [1:0] u_ex__u_csr__state;
input logic [31:0] u_ex__u_csr__wr_data;
input logic [31:0] u_ex__u_csr__wr_data_t0;
input logic u_ex__u_csr__u_hpmcounter0__clk;
input logic u_ex__u_csr__u_hpmcounter0__rstz;
input logic u_ex__u_csr__u_hpmcounter0__incr;
input logic [31:0] u_ex__u_csr__u_hpmcounter0__load_data;
input logic u_ex__u_csr__u_hpmcounter0__load_low;
input logic u_ex__u_csr__u_hpmcounter0__load_high;
input logic [63:0] u_ex__u_csr__u_hpmcounter0__count;
input logic u_ex__u_csr__u_hpmcounter0__count_vld;
input logic [31:0] u_ex__u_csr__u_hpmcounter0__load_data_t0;
input logic [63:0] u_ex__u_csr__u_hpmcounter0__count_t0;
input logic u_ex__u_csr__u_hpmcounter0__count_vld_t0;
input logic u_ex__u_csr__u_hpmcounter0__incr_t0;
input logic u_ex__u_csr__u_hpmcounter0__load_high_t0;
input logic u_ex__u_csr__u_hpmcounter0__load_low_t0;
input logic [31:0] u_ex__u_csr__u_hpmcounter0__count_high;
input logic [31:0] u_ex__u_csr__u_hpmcounter0__count_high_t0;
input logic [31:0] u_ex__u_csr__u_hpmcounter0__count_low;
input logic [31:0] u_ex__u_csr__u_hpmcounter0__count_low_t0;
input logic u_ex__u_csr__u_hpmcounter0__incr_high;
input logic u_ex__u_csr__u_hpmcounter1__clk;
input logic u_ex__u_csr__u_hpmcounter1__rstz;
input logic u_ex__u_csr__u_hpmcounter1__incr;
input logic [31:0] u_ex__u_csr__u_hpmcounter1__load_data;
input logic u_ex__u_csr__u_hpmcounter1__load_low;
input logic u_ex__u_csr__u_hpmcounter1__load_high;
input logic [63:0] u_ex__u_csr__u_hpmcounter1__count;
input logic u_ex__u_csr__u_hpmcounter1__count_vld;
input logic [31:0] u_ex__u_csr__u_hpmcounter1__load_data_t0;
input logic [63:0] u_ex__u_csr__u_hpmcounter1__count_t0;
input logic u_ex__u_csr__u_hpmcounter1__count_vld_t0;
input logic u_ex__u_csr__u_hpmcounter1__incr_t0;
input logic u_ex__u_csr__u_hpmcounter1__load_high_t0;
input logic u_ex__u_csr__u_hpmcounter1__load_low_t0;
input logic [31:0] u_ex__u_csr__u_hpmcounter1__count_high;
input logic [31:0] u_ex__u_csr__u_hpmcounter1__count_high_t0;
input logic [31:0] u_ex__u_csr__u_hpmcounter1__count_low;
input logic [31:0] u_ex__u_csr__u_hpmcounter1__count_low_t0;
input logic u_ex__u_csr__u_hpmcounter1__incr_high;
input logic [31:0] u_ex__u_lsu__decode_pc;
input logic [31:0] u_ex__u_lsu__decode_ir;
input logic [31:0] u_ex__u_lsu__decode_op1;
input logic [31:0] u_ex__u_lsu__decode_op2;
input logic [31:0] u_ex__u_lsu__decode_addr;
input logic u_ex__u_lsu__decode_basic;
input logic [3:0] u_ex__u_lsu__decode_aluop;
input logic u_ex__u_lsu__decode_regwr_alu;
input logic u_ex__u_lsu__decode_jump;
input logic u_ex__u_lsu__decode_branch;
input logic u_ex__u_lsu__decode_load;
input logic u_ex__u_lsu__decode_store;
input logic [3:0] u_ex__u_lsu__decode_mask;
input logic u_ex__u_lsu__decode_csr;
input logic u_ex__u_lsu__decode_system;
input logic [1:0] u_ex__u_lsu__decode_sysop;
input logic u_ex__u_lsu__decode_illegal;
input logic u_ex__u_lsu__decode_misaligned_jmp;
input logic u_ex__u_lsu__decode_misaligned_ldst;
input logic u_ex__u_lsu__lsu_vld;
input logic u_ex__u_lsu__lsu_rdy;
input logic [31:0] u_ex__u_lsu__load_data;
input logic u_ex__u_lsu__regwr_lsu;
input logic [31:0] u_ex__u_lsu__data_addr;
input logic [31:0] u_ex__u_lsu__data_rd_data;
input logic [31:0] u_ex__u_lsu__data_wr_data;
input logic [3:0] u_ex__u_lsu__data_mask;
input logic u_ex__u_lsu__data_wr_en;
input logic u_ex__u_lsu__data_req;
input logic u_ex__u_lsu__data_ack;
input logic [31:0] u_ex__u_lsu__decode_addr_t0;
input logic [3:0] u_ex__u_lsu__decode_aluop_t0;
input logic u_ex__u_lsu__decode_basic_t0;
input logic u_ex__u_lsu__decode_branch_t0;
input logic u_ex__u_lsu__decode_csr_t0;
input logic u_ex__u_lsu__decode_illegal_t0;
input logic [31:0] u_ex__u_lsu__decode_ir_t0;
input logic u_ex__u_lsu__decode_jump_t0;
input logic u_ex__u_lsu__decode_load_t0;
input logic [3:0] u_ex__u_lsu__decode_mask_t0;
input logic u_ex__u_lsu__decode_misaligned_jmp_t0;
input logic u_ex__u_lsu__decode_misaligned_ldst_t0;
input logic [31:0] u_ex__u_lsu__decode_op1_t0;
input logic [31:0] u_ex__u_lsu__decode_op2_t0;
input logic [31:0] u_ex__u_lsu__decode_pc_t0;
input logic u_ex__u_lsu__decode_regwr_alu_t0;
input logic u_ex__u_lsu__decode_store_t0;
input logic [1:0] u_ex__u_lsu__decode_sysop_t0;
input logic u_ex__u_lsu__decode_system_t0;
input logic u_ex__u_lsu__data_ack_t0;
input logic [31:0] u_ex__u_lsu__data_addr_t0;
input logic [3:0] u_ex__u_lsu__data_mask_t0;
input logic [31:0] u_ex__u_lsu__data_rd_data_t0;
input logic u_ex__u_lsu__data_req_t0;
input logic [31:0] u_ex__u_lsu__data_wr_data_t0;
input logic u_ex__u_lsu__data_wr_en_t0;
input logic [31:0] u_ex__u_lsu__load_data_t0;
input logic u_ex__u_lsu__lsu_rdy_t0;
input logic u_ex__u_lsu__lsu_vld_t0;
input logic u_ex__u_lsu__regwr_lsu_t0;
input logic [31:0] u_ex__u_lsu__byte_data;
input logic [31:0] u_ex__u_lsu__byte_data_t0;
input logic [31:0] u_ex__u_lsu__half_data;
input logic [31:0] u_ex__u_lsu__half_data_t0;
input logic [31:0] u_ex__u_lsu__word_data;
input logic [31:0] u_ex__u_lsu__word_data_t0;
input logic u_id__clk;
input logic u_id__rstz;
input logic u_id__flush;
input logic [31:0] u_id__fetch_pc;
input logic [31:0] u_id__fetch_ir;
input logic [31:0] u_id__immediate;
input logic [31:0] u_id__regrd_rs1;
input logic [31:0] u_id__regrd_rs2;
input logic u_id__regrd_rs1_en;
input logic u_id__regrd_rs2_en;
input logic u_id__fetch_vld;
input logic u_id__fetch_rdy;
input logic [31:0] u_id__decode_pc;
input logic [31:0] u_id__decode_ir;
input logic [31:0] u_id__decode_op1;
input logic [31:0] u_id__decode_op2;
input logic [31:0] u_id__decode_addr;
input logic u_id__decode_basic;
input logic [3:0] u_id__decode_aluop;
input logic u_id__decode_regwr_alu;
input logic u_id__decode_jump;
input logic u_id__decode_branch;
input logic u_id__decode_load;
input logic u_id__decode_store;
input logic [3:0] u_id__decode_mask;
input logic u_id__decode_csr;
input logic u_id__decode_system;
input logic [1:0] u_id__decode_sysop;
input logic u_id__decode_illegal;
input logic u_id__decode_misaligned_jmp;
input logic u_id__decode_misaligned_ldst;
input logic u_id__decode_vld;
input logic u_id__decode_rdy;
input logic [31:0] u_id__regwr_data;
input logic [4:0] u_id__regwr_sel;
input logic u_id__regwr_en;
input logic u_id__regwr_pending;
input logic u_id__fetch_rdy_t0;
input logic u_id__regrd_rs2_en_t0;
input logic [31:0] u_id__immediate_t0;
input logic [31:0] u_id__regrd_rs1_t0;
input logic [31:0] u_id__regrd_rs2_t0;
input logic u_id__regrd_rs1_en_t0;
input logic [31:0] u_id__regwr_data_t0;
input logic u_id__regwr_en_t0;
input logic [4:0] u_id__regwr_sel_t0;
input logic [31:0] u_id__fetch_ir_t0;
input logic [31:0] u_id__fetch_pc_t0;
input logic u_id__fetch_vld_t0;
input logic u_id__decode_rdy_t0;
input logic u_id__decode_vld_t0;
input logic u_id__flush_t0;
input logic u_id__regwr_pending_t0;
input logic [31:0] u_id__decode_addr_t0;
input logic [3:0] u_id__decode_aluop_t0;
input logic u_id__decode_basic_t0;
input logic u_id__decode_branch_t0;
input logic u_id__decode_csr_t0;
input logic u_id__decode_illegal_t0;
input logic [31:0] u_id__decode_ir_t0;
input logic u_id__decode_jump_t0;
input logic u_id__decode_load_t0;
input logic [3:0] u_id__decode_mask_t0;
input logic u_id__decode_misaligned_jmp_t0;
input logic u_id__decode_misaligned_ldst_t0;
input logic [31:0] u_id__decode_op1_t0;
input logic [31:0] u_id__decode_op2_t0;
input logic [31:0] u_id__decode_pc_t0;
input logic u_id__decode_regwr_alu_t0;
input logic u_id__decode_store_t0;
input logic [1:0] u_id__decode_sysop_t0;
input logic u_id__decode_system_t0;
input logic [31:0] u_id__addr;
input logic [31:0] u_id__addr_t0;
input logic [3:0] u_id__aluop;
input logic [3:0] u_id__aluop_t0;
input logic [31:0] u_id__base;
input logic [31:0] u_id__base_t0;
input logic u_id__branch;
input logic u_id__branch_t0;
input logic u_id__csr;
input logic u_id__illegal;
input logic u_id__illegal_opcode;
input logic u_id__instr_valid;
input logic u_id__is_fencei;
input logic u_id__misaligned_jmp;
input logic u_id__misaligned_jmp_t0;
input logic u_id__misaligned_ldst;
input logic u_id__misaligned_ldst_t0;
input logic [31:0] u_id__offset;
input logic [31:0] u_id__offset_t0;
input logic [31:0] u_id__op1;
input logic [31:0] u_id__op1_t0;
input logic [31:0] u_id__op2;
input logic [31:0] u_id__op2_t0;
input logic u_id__regwr_alu;
input logic [31:0] u_id__rs1_data;
input logic [31:0] u_id__rs1_data_t0;
input logic u_id__rs1_forward;
input logic [31:0] u_id__rs2_data;
input logic [31:0] u_id__rs2_data_t0;
input logic u_id__rs2_forward;
input logic u_id__stall;
input logic u_id__stall_t0;
input logic [31:0] u_id__store_data;
input logic [31:0] u_id__store_data_t0;
input logic [31:0] u_id__u_agu__instr;
input logic [31:0] u_id__u_agu__base;
input logic [31:0] u_id__u_agu__offset;
input logic [31:0] u_id__u_agu__addr;
input logic u_id__u_agu__misaligned_jmp;
input logic u_id__u_agu__misaligned_ldst;
input logic [31:0] u_id__u_agu__instr_t0;
input logic [31:0] u_id__u_agu__addr_t0;
input logic [31:0] u_id__u_agu__base_t0;
input logic u_id__u_agu__misaligned_jmp_t0;
input logic u_id__u_agu__misaligned_ldst_t0;
input logic [31:0] u_id__u_agu__offset_t0;
input logic [31:0] u_id__u_agu__addr_raw;
input logic [31:0] u_id__u_agu__addr_raw_t0;
input logic u_id__u_agu__align;
input logic [2:0] u_id__u_branch__op;
input logic [31:0] u_id__u_branch__rs1;
input logic [31:0] u_id__u_branch__rs2;
input logic u_id__u_branch__branch;
input logic u_id__u_branch__branch_t0;
input logic [2:0] u_id__u_branch__op_t0;
input logic [31:0] u_id__u_branch__rs1_t0;
input logic [31:0] u_id__u_branch__rs2_t0;
input logic u_id__u_branch__eq;
input logic u_id__u_branch__lt;
input logic u_id__u_hcu__clk;
input logic u_id__u_hcu__rstz;
input logic u_id__u_hcu__flush;
input logic [31:0] u_id__u_hcu__instr;
input logic u_id__u_hcu__regrd_rs1_en;
input logic u_id__u_hcu__regrd_rs2_en;
input logic u_id__u_hcu__fetch_vld;
input logic u_id__u_hcu__fetch_rdy;
input logic u_id__u_hcu__decode_vld;
input logic u_id__u_hcu__decode_rdy;
input logic [4:0] u_id__u_hcu__regwr_sel;
input logic u_id__u_hcu__regwr_en;
input logic u_id__u_hcu__regwr_pending;
input logic u_id__u_hcu__stall;
input logic u_id__u_hcu__fetch_rdy_t0;
input logic u_id__u_hcu__regrd_rs2_en_t0;
input logic u_id__u_hcu__regrd_rs1_en_t0;
input logic u_id__u_hcu__regwr_en_t0;
input logic [4:0] u_id__u_hcu__regwr_sel_t0;
input logic u_id__u_hcu__fetch_vld_t0;
input logic u_id__u_hcu__decode_rdy_t0;
input logic u_id__u_hcu__decode_vld_t0;
input logic u_id__u_hcu__flush_t0;
input logic [31:0] u_id__u_hcu__instr_t0;
input logic u_id__u_hcu__regwr_pending_t0;
input logic u_id__u_hcu__stall_t0;
input logic [4:0] u_id__u_hcu__rpend;
input logic u_id__u_hcu__rs1_hazard;
input logic u_id__u_hcu__rs1_hazard_t0;
input logic u_id__u_hcu__rs2_hazard;
input logic u_id__u_hcu__rs2_hazard_t0;
input logic u_if__clk;
input logic u_if__rstz;
input logic [31:0] u_if__instr_addr;
input logic [31:0] u_if__instr_data;
input logic u_if__instr_req;
input logic u_if__instr_ack;
input logic [31:0] u_if__fetch_pc;
input logic [31:0] u_if__fetch_ir;
input logic [31:0] u_if__immediate;
input logic [31:0] u_if__regrd_rs1;
input logic [31:0] u_if__regrd_rs2;
input logic u_if__regrd_rs1_en;
input logic u_if__regrd_rs2_en;
input logic u_if__fetch_vld;
input logic u_if__fetch_rdy;
input logic [31:0] u_if__branch_target;
input logic u_if__branch;
input logic [31:0] u_if__regwr_data;
input logic [4:0] u_if__regwr_sel;
input logic u_if__regwr_en;
input logic u_if__fetch_rdy_t0;
input logic u_if__regrd_rs2_en_t0;
input logic [31:0] u_if__immediate_t0;
input logic [31:0] u_if__instr_data_t0;
input logic [31:0] u_if__regrd_rs1_t0;
input logic [31:0] u_if__regrd_rs2_t0;
input logic u_if__regrd_rs1_en_t0;
input logic [31:0] u_if__regwr_data_t0;
input logic u_if__regwr_en_t0;
input logic [4:0] u_if__regwr_sel_t0;
input logic u_if__branch_t0;
input logic [31:0] u_if__branch_target_t0;
input logic [31:0] u_if__fetch_ir_t0;
input logic [31:0] u_if__fetch_pc_t0;
input logic u_if__fetch_vld_t0;
input logic u_if__instr_ack_t0;
input logic [31:0] u_if__instr_addr_t0;
input logic u_if__instr_req_t0;
input logic u_if__instr_vld;
input logic [31:0] u_if__next_instr;
input logic [31:0] u_if__next_instr_t0;
input logic [1:0] u_if__next_state;
input logic [31:0] u_if__pc;
input logic [31:0] u_if__pc_last;
input logic [31:0] u_if__pc_last_t0;
input logic [31:0] u_if__pc_t0;
input logic u_if__pipe_rdy;
input logic [31:0] u_if__skid_buffer;
input logic [31:0] u_if__skid_buffer_t0;
input logic [1:0] u_if__state;
input logic u_if__u_rf__clk;
input logic u_if__u_rf__rstz;
input logic [31:0] u_if__u_rf__instr_data;
input logic u_if__u_rf__instr_vld;
input logic u_if__u_rf__fetch_rdy;
input logic [31:0] u_if__u_rf__immediate;
input logic [31:0] u_if__u_rf__regrd_rs1;
input logic [31:0] u_if__u_rf__regrd_rs2;
input logic u_if__u_rf__regrd_rs1_en;
input logic u_if__u_rf__regrd_rs2_en;
input logic [31:0] u_if__u_rf__regwr_data;
input logic [4:0] u_if__u_rf__regwr_sel;
input logic u_if__u_rf__regwr_en;
input logic u_if__u_rf__fetch_rdy_t0;
input logic u_if__u_rf__instr_vld_t0;
input logic u_if__u_rf__regrd_rs2_en_t0;
input logic [31:0] u_if__u_rf__immediate_t0;
input logic [31:0] u_if__u_rf__instr_data_t0;
input logic [31:0] u_if__u_rf__regrd_rs1_t0;
input logic [31:0] u_if__u_rf__regrd_rs2_t0;
input logic u_if__u_rf__regrd_rs1_en_t0;
input logic [31:0] u_if__u_rf__regwr_data_t0;
input logic u_if__u_rf__regwr_en_t0;
input logic [4:0] u_if__u_rf__regwr_sel_t0;
input logic u_if__u_rf__ImmA;
input logic u_if__u_rf__ImmA_t0;
input logic [7:0] u_if__u_rf__ImmE;
input logic [7:0] u_if__u_rf__ImmE_t0;
input logic [11:0] u_if__u_rf__ImmF;
input logic [11:0] u_if__u_rf__ImmF_t0;
input logic [31:0] u_if__u_rf__REG_0_;
input logic [31:0] u_if__u_rf__REG_0__t0;
input logic [31:0] u_if__u_rf__REG_10_;
input logic [31:0] u_if__u_rf__REG_10__t0;
input logic [31:0] u_if__u_rf__REG_11_;
input logic [31:0] u_if__u_rf__REG_11__t0;
input logic [31:0] u_if__u_rf__REG_12_;
input logic [31:0] u_if__u_rf__REG_12__t0;
input logic [31:0] u_if__u_rf__REG_13_;
input logic [31:0] u_if__u_rf__REG_13__t0;
input logic [31:0] u_if__u_rf__REG_14_;
input logic [31:0] u_if__u_rf__REG_14__t0;
input logic [31:0] u_if__u_rf__REG_15_;
input logic [31:0] u_if__u_rf__REG_15__t0;
input logic [31:0] u_if__u_rf__REG_16_;
input logic [31:0] u_if__u_rf__REG_16__t0;
input logic [31:0] u_if__u_rf__REG_17_;
input logic [31:0] u_if__u_rf__REG_17__t0;
input logic [31:0] u_if__u_rf__REG_18_;
input logic [31:0] u_if__u_rf__REG_18__t0;
input logic [31:0] u_if__u_rf__REG_19_;
input logic [31:0] u_if__u_rf__REG_19__t0;
input logic [31:0] u_if__u_rf__REG_1_;
input logic [31:0] u_if__u_rf__REG_1__t0;
input logic [31:0] u_if__u_rf__REG_20_;
input logic [31:0] u_if__u_rf__REG_20__t0;
input logic [31:0] u_if__u_rf__REG_21_;
input logic [31:0] u_if__u_rf__REG_21__t0;
input logic [31:0] u_if__u_rf__REG_22_;
input logic [31:0] u_if__u_rf__REG_22__t0;
input logic [31:0] u_if__u_rf__REG_23_;
input logic [31:0] u_if__u_rf__REG_23__t0;
input logic [31:0] u_if__u_rf__REG_24_;
input logic [31:0] u_if__u_rf__REG_24__t0;
input logic [31:0] u_if__u_rf__REG_25_;
input logic [31:0] u_if__u_rf__REG_25__t0;
input logic [31:0] u_if__u_rf__REG_26_;
input logic [31:0] u_if__u_rf__REG_26__t0;
input logic [31:0] u_if__u_rf__REG_27_;
input logic [31:0] u_if__u_rf__REG_27__t0;
input logic [31:0] u_if__u_rf__REG_28_;
input logic [31:0] u_if__u_rf__REG_28__t0;
input logic [31:0] u_if__u_rf__REG_29_;
input logic [31:0] u_if__u_rf__REG_29__t0;
input logic [31:0] u_if__u_rf__REG_2_;
input logic [31:0] u_if__u_rf__REG_2__t0;
input logic [31:0] u_if__u_rf__REG_30_;
input logic [31:0] u_if__u_rf__REG_30__t0;
input logic [31:0] u_if__u_rf__REG_31_;
input logic [31:0] u_if__u_rf__REG_31__t0;
input logic [31:0] u_if__u_rf__REG_3_;
input logic [31:0] u_if__u_rf__REG_3__t0;
input logic [31:0] u_if__u_rf__REG_4_;
input logic [31:0] u_if__u_rf__REG_4__t0;
input logic [31:0] u_if__u_rf__REG_5_;
input logic [31:0] u_if__u_rf__REG_5__t0;
input logic [31:0] u_if__u_rf__REG_6_;
input logic [31:0] u_if__u_rf__REG_6__t0;
input logic [31:0] u_if__u_rf__REG_7_;
input logic [31:0] u_if__u_rf__REG_7__t0;
input logic [31:0] u_if__u_rf__REG_8_;
input logic [31:0] u_if__u_rf__REG_8__t0;
input logic [31:0] u_if__u_rf__REG_9_;
input logic [31:0] u_if__u_rf__REG_9__t0;
input logic u_if__u_rf__csr_regrd;
input logic u_if__u_rf__format_B;
input logic u_if__u_rf__format_I;
input logic u_if__u_rf__format_J;
input logic u_if__u_rf__format_S;
input logic u_if__u_rf__format_U;
input logic u_if__u_rf__instr_rdy;
input logic u_if__u_rf__is_regrd_rs1_en;
input logic u_if__u_rf__is_regrd_rs2_en;
input logic [4:0] u_if__u_rf__reg_rs1;
input logic [4:0] u_if__u_rf__reg_rs2;
input logic u_if__u_rf__reg_vld;
input logic [1:0] u_ex__u_csr___1089_;
input logic [29:0] u_ex__u_csr___1093_;
input logic [20:0] u_if__u_rf___0742_;
input logic [10:0] u_if__u_rf___1126_;


`include `PROPERTIES_FILE

endmodule
