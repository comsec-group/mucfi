module cellift_data_flow_picorv32_fpv 
(
clk,
resetn,
trap,
mem_valid,
mem_instr,
mem_ready,
mem_addr,
mem_wdata,
mem_wstrb,
mem_rdata,
mem_la_read,
mem_la_write,
mem_la_addr,
mem_la_wdata,
mem_la_wstrb,
pcpi_valid,
pcpi_insn,
pcpi_rs1,
pcpi_rs2,
pcpi_wr,
pcpi_rd,
pcpi_wait,
pcpi_ready,
irq,
eoi,
rvfi_valid,
rvfi_order,
rvfi_insn,
rvfi_trap,
rvfi_halt,
rvfi_intr,
rvfi_mode,
rvfi_ixl,
rvfi_rs1_addr,
rvfi_rs2_addr,
rvfi_rs1_rdata,
rvfi_rs2_rdata,
rvfi_rd_addr,
rvfi_rd_wdata,
rvfi_pc_rdata,
rvfi_pc_wdata,
rvfi_mem_addr,
rvfi_mem_rmask,
rvfi_mem_wmask,
rvfi_mem_rdata,
rvfi_mem_wdata,
rvfi_csr_mcycle_rmask,
rvfi_csr_mcycle_wmask,
rvfi_csr_mcycle_rdata,
rvfi_csr_mcycle_wdata,
rvfi_csr_minstret_rmask,
rvfi_csr_minstret_wmask,
rvfi_csr_minstret_rdata,
rvfi_csr_minstret_wdata,
trace_valid,
trace_data,
trap_t0,
trace_valid_t0,
trace_data_t0,
rvfi_valid_t0,
rvfi_trap_t0,
rvfi_rs2_rdata_t0,
rvfi_rs2_addr_t0,
rvfi_rs1_rdata_t0,
rvfi_rs1_addr_t0,
rvfi_rd_wdata_t0,
rvfi_rd_addr_t0,
rvfi_pc_wdata_t0,
rvfi_pc_rdata_t0,
rvfi_order_t0,
rvfi_mode_t0,
rvfi_mem_wmask_t0,
rvfi_mem_wdata_t0,
rvfi_mem_rmask_t0,
rvfi_mem_rdata_t0,
rvfi_mem_addr_t0,
rvfi_ixl_t0,
rvfi_intr_t0,
rvfi_insn_t0,
rvfi_halt_t0,
rvfi_csr_minstret_wmask_t0,
rvfi_csr_minstret_wdata_t0,
rvfi_csr_minstret_rmask_t0,
rvfi_csr_minstret_rdata_t0,
rvfi_csr_mcycle_wmask_t0,
rvfi_csr_mcycle_wdata_t0,
rvfi_csr_mcycle_rmask_t0,
rvfi_csr_mcycle_rdata_t0,
mem_wstrb_t0,
mem_wdata_t0,
mem_valid_t0,
mem_ready_t0,
mem_rdata_t0,
mem_la_wstrb_t0,
mem_la_write_t0,
mem_la_wdata_t0,
mem_la_read_t0,
mem_la_addr_t0,
mem_instr_t0,
mem_addr_t0,
irq_t0,
eoi_t0,
pcpi_insn_t0,
pcpi_rd_t0,
pcpi_ready_t0,
pcpi_rs1_t0,
pcpi_rs2_t0,
pcpi_valid_t0,
pcpi_wait_t0,
pcpi_wr_t0,
alu_add_sub,
alu_add_sub_t0,
alu_eq,
alu_lts,
alu_ltu,
alu_out,
alu_out_0,
alu_out_q,
alu_out_q_t0,
alu_out_t0,
cached_insn_opcode,
cached_insn_opcode_t0,
cached_insn_rs1,
cached_insn_rs1_t0,
cached_insn_rs2,
cached_insn_rs2_t0,
clear_prefetched_high_word,
clear_prefetched_high_word_q,
compressed_instr,
count_cycle,
count_cycle_t0,
count_instr,
count_instr_t0,
cpu_state,
cpuregs_0_,
cpuregs_0__t0,
cpuregs_10_,
cpuregs_10__t0,
cpuregs_11_,
cpuregs_11__t0,
cpuregs_12_,
cpuregs_12__t0,
cpuregs_13_,
cpuregs_13__t0,
cpuregs_14_,
cpuregs_14__t0,
cpuregs_15_,
cpuregs_15__t0,
cpuregs_16_,
cpuregs_16__t0,
cpuregs_17_,
cpuregs_17__t0,
cpuregs_18_,
cpuregs_18__t0,
cpuregs_19_,
cpuregs_19__t0,
cpuregs_1_,
cpuregs_1__t0,
cpuregs_20_,
cpuregs_20__t0,
cpuregs_21_,
cpuregs_21__t0,
cpuregs_22_,
cpuregs_22__t0,
cpuregs_23_,
cpuregs_23__t0,
cpuregs_24_,
cpuregs_24__t0,
cpuregs_25_,
cpuregs_25__t0,
cpuregs_26_,
cpuregs_26__t0,
cpuregs_27_,
cpuregs_27__t0,
cpuregs_28_,
cpuregs_28__t0,
cpuregs_29_,
cpuregs_29__t0,
cpuregs_2_,
cpuregs_2__t0,
cpuregs_30_,
cpuregs_30__t0,
cpuregs_31_,
cpuregs_31__t0,
cpuregs_3_,
cpuregs_3__t0,
cpuregs_4_,
cpuregs_4__t0,
cpuregs_5_,
cpuregs_5__t0,
cpuregs_6_,
cpuregs_6__t0,
cpuregs_7_,
cpuregs_7__t0,
cpuregs_8_,
cpuregs_8__t0,
cpuregs_9_,
cpuregs_9__t0,
cpuregs_rs1,
cpuregs_rs1_t0,
cpuregs_rs2,
cpuregs_rs2_t0,
cpuregs_wrdata,
cpuregs_wrdata_t0,
cpuregs_write,
dbg_insn_opcode,
dbg_insn_opcode_t0,
dbg_insn_rs1,
dbg_insn_rs1_t0,
dbg_insn_rs2,
dbg_insn_rs2_t0,
dbg_next,
dbg_rs1val,
dbg_rs1val_t0,
dbg_rs1val_valid,
dbg_rs2val,
dbg_rs2val_t0,
dbg_rs2val_valid,
dbg_valid_insn,
decoded_imm,
decoded_imm_j,
decoded_imm_j_reg_10_,
decoded_imm_j_reg_11_,
decoded_imm_j_reg_4_,
decoded_imm_j_reg_5_,
decoded_imm_j_reg_6_,
decoded_imm_j_reg_7_,
decoded_imm_j_t0,
decoded_imm_j_t0_reg_10_,
decoded_imm_j_t0_reg_11_,
decoded_imm_j_t0_reg_4_,
decoded_imm_j_t0_reg_5_,
decoded_imm_j_t0_reg_6_,
decoded_imm_j_t0_reg_7_,
decoded_imm_t0,
decoded_rd,
decoded_rd_t0,
decoded_rs1,
decoded_rs1_t0,
decoded_rs2,
decoded_rs2_t0,
decoder_pseudo_trigger,
decoder_pseudo_trigger_q,
decoder_trigger,
decoder_trigger_q,
instr_add,
instr_addi,
instr_and,
instr_andi,
instr_auipc,
instr_beq,
instr_bge,
instr_bgeu,
instr_blt,
instr_bltu,
instr_bne,
instr_ecall_ebreak,
instr_fence,
instr_jal,
instr_jalr,
instr_lb,
instr_lbu,
instr_lh,
instr_lhu,
instr_lui,
instr_lw,
instr_or,
instr_ori,
instr_rdcycle,
instr_rdcycleh,
instr_rdinstr,
instr_rdinstrh,
instr_sb,
instr_sh,
instr_sll,
instr_slli,
instr_slt,
instr_slti,
instr_sltiu,
instr_sltu,
instr_sra,
instr_srai,
instr_srl,
instr_srli,
instr_sub,
instr_sw,
instr_trap,
instr_xor,
instr_xori,
is_alu_reg_imm,
is_alu_reg_reg,
is_beq_bne_blt_bge_bltu_bgeu,
is_compare,
is_jalr_addi_slti_sltiu_xori_ori_andi,
is_lb_lh_lw_lbu_lhu,
is_lui_auipc_jal,
is_rdcycle_rdcycleh_rdinstr_rdinstrh,
is_sb_sh_sw,
is_sll_srl_sra,
is_slli_srli_srai,
is_slti_blt_slt,
is_sltiu_bltu_sltu,
last_mem_valid,
latched_branch,
latched_compr,
latched_is_lb,
latched_is_lh,
latched_rd,
latched_rd_t0,
latched_stalu,
latched_store,
launch_next_insn,
mem_16bit_buffer,
mem_16bit_buffer_t0,
mem_do_prefetch,
mem_do_rdata,
mem_do_rinst,
mem_do_wdata,
mem_done,
mem_la_firstword,
mem_la_firstword_reg,
mem_la_firstword_xfer,
mem_la_secondword,
mem_la_use_prefetched_high_word,
mem_rdata_latched,
mem_rdata_latched_noshuffle,
mem_rdata_latched_noshuffle_t0,
mem_rdata_latched_t0,
mem_rdata_q,
mem_rdata_q_t0,
mem_rdata_word,
mem_rdata_word_t0,
mem_state,
mem_wordsize,
mem_xfer,
next_insn_opcode,
next_insn_opcode_t0,
next_pc,
next_pc_t0,
pcpi_div_rd,
pcpi_div_rd_t0,
pcpi_div_ready,
pcpi_div_ready_t0,
pcpi_div_wait,
pcpi_div_wait_t0,
pcpi_div_wr,
pcpi_div_wr_t0,
pcpi_int_rd,
pcpi_int_rd_t0,
pcpi_int_ready,
pcpi_int_wait,
pcpi_int_wr,
pcpi_mul_rd,
pcpi_mul_rd_t0,
pcpi_mul_ready,
pcpi_mul_ready_t0,
pcpi_mul_wait,
pcpi_mul_wait_t0,
pcpi_mul_wr,
pcpi_mul_wr_t0,
pcpi_timeout,
pcpi_timeout_counter,
prefetched_high_word,
q_insn_rs1,
q_insn_rs1_t0,
q_insn_rs2,
q_insn_rs2_t0,
reg_next_pc,
reg_next_pc_t0,
reg_out,
reg_out_t0,
reg_pc,
reg_pc_t0,
reg_sh,
genblk1__genblk1__pcpi_mul__clk,
genblk1__genblk1__pcpi_mul__resetn,
genblk1__genblk1__pcpi_mul__pcpi_valid,
genblk1__genblk1__pcpi_mul__pcpi_insn,
genblk1__genblk1__pcpi_mul__pcpi_rs1,
genblk1__genblk1__pcpi_mul__pcpi_rs2,
genblk1__genblk1__pcpi_mul__pcpi_wr,
genblk1__genblk1__pcpi_mul__pcpi_rd,
genblk1__genblk1__pcpi_mul__pcpi_wait,
genblk1__genblk1__pcpi_mul__pcpi_ready,
genblk1__genblk1__pcpi_mul__pcpi_insn_t0,
genblk1__genblk1__pcpi_mul__pcpi_rd_t0,
genblk1__genblk1__pcpi_mul__pcpi_ready_t0,
genblk1__genblk1__pcpi_mul__pcpi_rs1_t0,
genblk1__genblk1__pcpi_mul__pcpi_rs2_t0,
genblk1__genblk1__pcpi_mul__pcpi_valid_t0,
genblk1__genblk1__pcpi_mul__pcpi_wait_t0,
genblk1__genblk1__pcpi_mul__pcpi_wr_t0,
genblk1__genblk1__pcpi_mul__instr_any_mul,
genblk1__genblk1__pcpi_mul__instr_any_mulh,
genblk1__genblk1__pcpi_mul__instr_mul,
genblk1__genblk1__pcpi_mul__instr_mulh,
genblk1__genblk1__pcpi_mul__instr_mulhsu,
genblk1__genblk1__pcpi_mul__instr_mulhu,
genblk1__genblk1__pcpi_mul__instr_rs1_signed,
genblk1__genblk1__pcpi_mul__mul_counter,
genblk1__genblk1__pcpi_mul__mul_finish,
genblk1__genblk1__pcpi_mul__mul_start,
genblk1__genblk1__pcpi_mul__mul_waiting,
genblk1__genblk1__pcpi_mul__next_rd,
genblk1__genblk1__pcpi_mul__next_rd_t0,
genblk1__genblk1__pcpi_mul__next_rdt,
genblk1__genblk1__pcpi_mul__next_rdt_t0,
genblk1__genblk1__pcpi_mul__pcpi_wait_q,
genblk1__genblk1__pcpi_mul__rd,
genblk1__genblk1__pcpi_mul__rd_t0,
genblk1__genblk1__pcpi_mul__rdx,
genblk1__genblk1__pcpi_mul__rdx_t0,
genblk1__genblk1__pcpi_mul__rs1,
genblk1__genblk1__pcpi_mul__rs2,
genblk1__genblk1__pcpi_mul__rs2_t0,
genblk1__genblk1__pcpi_mul__this_rs2,
genblk1__genblk1__pcpi_mul__this_rs2_t0,
genblk2__pcpi_div__clk,
genblk2__pcpi_div__resetn,
genblk2__pcpi_div__pcpi_valid,
genblk2__pcpi_div__pcpi_insn,
genblk2__pcpi_div__pcpi_rs1,
genblk2__pcpi_div__pcpi_rs2,
genblk2__pcpi_div__pcpi_wr,
genblk2__pcpi_div__pcpi_rd,
genblk2__pcpi_div__pcpi_wait,
genblk2__pcpi_div__pcpi_ready,
genblk2__pcpi_div__pcpi_insn_t0,
genblk2__pcpi_div__pcpi_rd_t0,
genblk2__pcpi_div__pcpi_ready_t0,
genblk2__pcpi_div__pcpi_rs1_t0,
genblk2__pcpi_div__pcpi_rs2_t0,
genblk2__pcpi_div__pcpi_valid_t0,
genblk2__pcpi_div__pcpi_wait_t0,
genblk2__pcpi_div__pcpi_wr_t0,
genblk2__pcpi_div__dividend,
genblk2__pcpi_div__dividend_t0,
genblk2__pcpi_div__divisor,
genblk2__pcpi_div__divisor_t0,
genblk2__pcpi_div__instr_any_div_rem,
genblk2__pcpi_div__instr_div,
genblk2__pcpi_div__instr_divu,
genblk2__pcpi_div__instr_rem,
genblk2__pcpi_div__instr_remu,
genblk2__pcpi_div__outsign,
genblk2__pcpi_div__pcpi_wait_q,
genblk2__pcpi_div__quotient,
genblk2__pcpi_div__quotient_msk,
genblk2__pcpi_div__quotient_msk_t0,
genblk2__pcpi_div__quotient_t0,
genblk2__pcpi_div__running,
genblk2__pcpi_div__start,
_2568_,
_2828_,
_2830_,
_2831_,
_2834_,
_2846_,
genblk1__genblk1__pcpi_mul___820_);


input logic clk;
input logic resetn;
input logic trap;
input logic mem_valid;
input logic mem_instr;
input logic mem_ready;
input logic [31:0] mem_addr;
input logic [31:0] mem_wdata;
input logic [3:0] mem_wstrb;
input logic [31:0] mem_rdata;
input logic mem_la_read;
input logic mem_la_write;
input logic [31:0] mem_la_addr;
input logic [31:0] mem_la_wdata;
input logic [3:0] mem_la_wstrb;
input logic pcpi_valid;
input logic [31:0] pcpi_insn;
input logic [31:0] pcpi_rs1;
input logic [31:0] pcpi_rs2;
input logic pcpi_wr;
input logic [31:0] pcpi_rd;
input logic pcpi_wait;
input logic pcpi_ready;
input logic [31:0] irq;
input logic [31:0] eoi;
input logic rvfi_valid;
input logic [63:0] rvfi_order;
input logic [31:0] rvfi_insn;
input logic rvfi_trap;
input logic rvfi_halt;
input logic rvfi_intr;
input logic [1:0] rvfi_mode;
input logic [1:0] rvfi_ixl;
input logic [4:0] rvfi_rs1_addr;
input logic [4:0] rvfi_rs2_addr;
input logic [31:0] rvfi_rs1_rdata;
input logic [31:0] rvfi_rs2_rdata;
input logic [4:0] rvfi_rd_addr;
input logic [31:0] rvfi_rd_wdata;
input logic [31:0] rvfi_pc_rdata;
input logic [31:0] rvfi_pc_wdata;
input logic [31:0] rvfi_mem_addr;
input logic [3:0] rvfi_mem_rmask;
input logic [3:0] rvfi_mem_wmask;
input logic [31:0] rvfi_mem_rdata;
input logic [31:0] rvfi_mem_wdata;
input logic [63:0] rvfi_csr_mcycle_rmask;
input logic [63:0] rvfi_csr_mcycle_wmask;
input logic [63:0] rvfi_csr_mcycle_rdata;
input logic [63:0] rvfi_csr_mcycle_wdata;
input logic [63:0] rvfi_csr_minstret_rmask;
input logic [63:0] rvfi_csr_minstret_wmask;
input logic [63:0] rvfi_csr_minstret_rdata;
input logic [63:0] rvfi_csr_minstret_wdata;
input logic trace_valid;
input logic [35:0] trace_data;
input logic trap_t0;
input logic trace_valid_t0;
input logic [35:0] trace_data_t0;
input logic rvfi_valid_t0;
input logic rvfi_trap_t0;
input logic [31:0] rvfi_rs2_rdata_t0;
input logic [4:0] rvfi_rs2_addr_t0;
input logic [31:0] rvfi_rs1_rdata_t0;
input logic [4:0] rvfi_rs1_addr_t0;
input logic [31:0] rvfi_rd_wdata_t0;
input logic [4:0] rvfi_rd_addr_t0;
input logic [31:0] rvfi_pc_wdata_t0;
input logic [31:0] rvfi_pc_rdata_t0;
input logic [63:0] rvfi_order_t0;
input logic [1:0] rvfi_mode_t0;
input logic [3:0] rvfi_mem_wmask_t0;
input logic [31:0] rvfi_mem_wdata_t0;
input logic [3:0] rvfi_mem_rmask_t0;
input logic [31:0] rvfi_mem_rdata_t0;
input logic [31:0] rvfi_mem_addr_t0;
input logic [1:0] rvfi_ixl_t0;
input logic rvfi_intr_t0;
input logic [31:0] rvfi_insn_t0;
input logic rvfi_halt_t0;
input logic [63:0] rvfi_csr_minstret_wmask_t0;
input logic [63:0] rvfi_csr_minstret_wdata_t0;
input logic [63:0] rvfi_csr_minstret_rmask_t0;
input logic [63:0] rvfi_csr_minstret_rdata_t0;
input logic [63:0] rvfi_csr_mcycle_wmask_t0;
input logic [63:0] rvfi_csr_mcycle_wdata_t0;
input logic [63:0] rvfi_csr_mcycle_rmask_t0;
input logic [63:0] rvfi_csr_mcycle_rdata_t0;
input logic [3:0] mem_wstrb_t0;
input logic [31:0] mem_wdata_t0;
input logic mem_valid_t0;
input logic mem_ready_t0;
input logic [31:0] mem_rdata_t0;
input logic [3:0] mem_la_wstrb_t0;
input logic mem_la_write_t0;
input logic [31:0] mem_la_wdata_t0;
input logic mem_la_read_t0;
input logic [31:0] mem_la_addr_t0;
input logic mem_instr_t0;
input logic [31:0] mem_addr_t0;
input logic [31:0] irq_t0;
input logic [31:0] eoi_t0;
input logic [31:0] pcpi_insn_t0;
input logic [31:0] pcpi_rd_t0;
input logic pcpi_ready_t0;
input logic [31:0] pcpi_rs1_t0;
input logic [31:0] pcpi_rs2_t0;
input logic pcpi_valid_t0;
input logic pcpi_wait_t0;
input logic pcpi_wr_t0;
input logic [31:0] alu_add_sub;
input logic [31:0] alu_add_sub_t0;
input logic alu_eq;
input logic alu_lts;
input logic alu_ltu;
input logic [31:0] alu_out;
input logic alu_out_0;
input logic [31:0] alu_out_q;
input logic [31:0] alu_out_q_t0;
input logic [31:0] alu_out_t0;
input logic [31:0] cached_insn_opcode;
input logic [31:0] cached_insn_opcode_t0;
input logic [4:0] cached_insn_rs1;
input logic [4:0] cached_insn_rs1_t0;
input logic [4:0] cached_insn_rs2;
input logic [4:0] cached_insn_rs2_t0;
input logic clear_prefetched_high_word;
input logic clear_prefetched_high_word_q;
input logic compressed_instr;
input logic [63:0] count_cycle;
input logic [63:0] count_cycle_t0;
input logic [63:0] count_instr;
input logic [63:0] count_instr_t0;
input logic [7:0] cpu_state;
input logic [31:0] cpuregs_0_;
input logic [31:0] cpuregs_0__t0;
input logic [31:0] cpuregs_10_;
input logic [31:0] cpuregs_10__t0;
input logic [31:0] cpuregs_11_;
input logic [31:0] cpuregs_11__t0;
input logic [31:0] cpuregs_12_;
input logic [31:0] cpuregs_12__t0;
input logic [31:0] cpuregs_13_;
input logic [31:0] cpuregs_13__t0;
input logic [31:0] cpuregs_14_;
input logic [31:0] cpuregs_14__t0;
input logic [31:0] cpuregs_15_;
input logic [31:0] cpuregs_15__t0;
input logic [31:0] cpuregs_16_;
input logic [31:0] cpuregs_16__t0;
input logic [31:0] cpuregs_17_;
input logic [31:0] cpuregs_17__t0;
input logic [31:0] cpuregs_18_;
input logic [31:0] cpuregs_18__t0;
input logic [31:0] cpuregs_19_;
input logic [31:0] cpuregs_19__t0;
input logic [31:0] cpuregs_1_;
input logic [31:0] cpuregs_1__t0;
input logic [31:0] cpuregs_20_;
input logic [31:0] cpuregs_20__t0;
input logic [31:0] cpuregs_21_;
input logic [31:0] cpuregs_21__t0;
input logic [31:0] cpuregs_22_;
input logic [31:0] cpuregs_22__t0;
input logic [31:0] cpuregs_23_;
input logic [31:0] cpuregs_23__t0;
input logic [31:0] cpuregs_24_;
input logic [31:0] cpuregs_24__t0;
input logic [31:0] cpuregs_25_;
input logic [31:0] cpuregs_25__t0;
input logic [31:0] cpuregs_26_;
input logic [31:0] cpuregs_26__t0;
input logic [31:0] cpuregs_27_;
input logic [31:0] cpuregs_27__t0;
input logic [31:0] cpuregs_28_;
input logic [31:0] cpuregs_28__t0;
input logic [31:0] cpuregs_29_;
input logic [31:0] cpuregs_29__t0;
input logic [31:0] cpuregs_2_;
input logic [31:0] cpuregs_2__t0;
input logic [31:0] cpuregs_30_;
input logic [31:0] cpuregs_30__t0;
input logic [31:0] cpuregs_31_;
input logic [31:0] cpuregs_31__t0;
input logic [31:0] cpuregs_3_;
input logic [31:0] cpuregs_3__t0;
input logic [31:0] cpuregs_4_;
input logic [31:0] cpuregs_4__t0;
input logic [31:0] cpuregs_5_;
input logic [31:0] cpuregs_5__t0;
input logic [31:0] cpuregs_6_;
input logic [31:0] cpuregs_6__t0;
input logic [31:0] cpuregs_7_;
input logic [31:0] cpuregs_7__t0;
input logic [31:0] cpuregs_8_;
input logic [31:0] cpuregs_8__t0;
input logic [31:0] cpuregs_9_;
input logic [31:0] cpuregs_9__t0;
input logic [31:0] cpuregs_rs1;
input logic [31:0] cpuregs_rs1_t0;
input logic [31:0] cpuregs_rs2;
input logic [31:0] cpuregs_rs2_t0;
input logic [31:0] cpuregs_wrdata;
input logic [31:0] cpuregs_wrdata_t0;
input logic cpuregs_write;
input logic [31:0] dbg_insn_opcode;
input logic [31:0] dbg_insn_opcode_t0;
input logic [4:0] dbg_insn_rs1;
input logic [4:0] dbg_insn_rs1_t0;
input logic [4:0] dbg_insn_rs2;
input logic [4:0] dbg_insn_rs2_t0;
input logic dbg_next;
input logic [31:0] dbg_rs1val;
input logic [31:0] dbg_rs1val_t0;
input logic dbg_rs1val_valid;
input logic [31:0] dbg_rs2val;
input logic [31:0] dbg_rs2val_t0;
input logic dbg_rs2val_valid;
input logic dbg_valid_insn;
input logic [31:0] decoded_imm;
input logic [31:0] decoded_imm_j;
input logic decoded_imm_j_reg_10_;
input logic decoded_imm_j_reg_11_;
input logic decoded_imm_j_reg_4_;
input logic decoded_imm_j_reg_5_;
input logic decoded_imm_j_reg_6_;
input logic decoded_imm_j_reg_7_;
input logic [31:0] decoded_imm_j_t0;
input logic decoded_imm_j_t0_reg_10_;
input logic decoded_imm_j_t0_reg_11_;
input logic decoded_imm_j_t0_reg_4_;
input logic decoded_imm_j_t0_reg_5_;
input logic decoded_imm_j_t0_reg_6_;
input logic decoded_imm_j_t0_reg_7_;
input logic [31:0] decoded_imm_t0;
input logic [4:0] decoded_rd;
input logic [4:0] decoded_rd_t0;
input logic [4:0] decoded_rs1;
input logic [4:0] decoded_rs1_t0;
input logic [4:0] decoded_rs2;
input logic [4:0] decoded_rs2_t0;
input logic decoder_pseudo_trigger;
input logic decoder_pseudo_trigger_q;
input logic decoder_trigger;
input logic decoder_trigger_q;
input logic instr_add;
input logic instr_addi;
input logic instr_and;
input logic instr_andi;
input logic instr_auipc;
input logic instr_beq;
input logic instr_bge;
input logic instr_bgeu;
input logic instr_blt;
input logic instr_bltu;
input logic instr_bne;
input logic instr_ecall_ebreak;
input logic instr_fence;
input logic instr_jal;
input logic instr_jalr;
input logic instr_lb;
input logic instr_lbu;
input logic instr_lh;
input logic instr_lhu;
input logic instr_lui;
input logic instr_lw;
input logic instr_or;
input logic instr_ori;
input logic instr_rdcycle;
input logic instr_rdcycleh;
input logic instr_rdinstr;
input logic instr_rdinstrh;
input logic instr_sb;
input logic instr_sh;
input logic instr_sll;
input logic instr_slli;
input logic instr_slt;
input logic instr_slti;
input logic instr_sltiu;
input logic instr_sltu;
input logic instr_sra;
input logic instr_srai;
input logic instr_srl;
input logic instr_srli;
input logic instr_sub;
input logic instr_sw;
input logic instr_trap;
input logic instr_xor;
input logic instr_xori;
input logic is_alu_reg_imm;
input logic is_alu_reg_reg;
input logic is_beq_bne_blt_bge_bltu_bgeu;
input logic is_compare;
input logic is_jalr_addi_slti_sltiu_xori_ori_andi;
input logic is_lb_lh_lw_lbu_lhu;
input logic is_lui_auipc_jal;
input logic is_rdcycle_rdcycleh_rdinstr_rdinstrh;
input logic is_sb_sh_sw;
input logic is_sll_srl_sra;
input logic is_slli_srli_srai;
input logic is_slti_blt_slt;
input logic is_sltiu_bltu_sltu;
input logic last_mem_valid;
input logic latched_branch;
input logic latched_compr;
input logic latched_is_lb;
input logic latched_is_lh;
input logic [4:0] latched_rd;
input logic [4:0] latched_rd_t0;
input logic latched_stalu;
input logic latched_store;
input logic launch_next_insn;
input logic [15:0] mem_16bit_buffer;
input logic [15:0] mem_16bit_buffer_t0;
input logic mem_do_prefetch;
input logic mem_do_rdata;
input logic mem_do_rinst;
input logic mem_do_wdata;
input logic mem_done;
input logic mem_la_firstword;
input logic mem_la_firstword_reg;
input logic mem_la_firstword_xfer;
input logic mem_la_secondword;
input logic mem_la_use_prefetched_high_word;
input logic [31:0] mem_rdata_latched;
input logic [31:0] mem_rdata_latched_noshuffle;
input logic [31:0] mem_rdata_latched_noshuffle_t0;
input logic [31:0] mem_rdata_latched_t0;
input logic [31:0] mem_rdata_q;
input logic [31:0] mem_rdata_q_t0;
input logic [31:0] mem_rdata_word;
input logic [31:0] mem_rdata_word_t0;
input logic [1:0] mem_state;
input logic [1:0] mem_wordsize;
input logic mem_xfer;
input logic [31:0] next_insn_opcode;
input logic [31:0] next_insn_opcode_t0;
input logic [31:0] next_pc;
input logic [31:0] next_pc_t0;
input logic [31:0] pcpi_div_rd;
input logic [31:0] pcpi_div_rd_t0;
input logic pcpi_div_ready;
input logic pcpi_div_ready_t0;
input logic pcpi_div_wait;
input logic pcpi_div_wait_t0;
input logic pcpi_div_wr;
input logic pcpi_div_wr_t0;
input logic [31:0] pcpi_int_rd;
input logic [31:0] pcpi_int_rd_t0;
input logic pcpi_int_ready;
input logic pcpi_int_wait;
input logic pcpi_int_wr;
input logic [31:0] pcpi_mul_rd;
input logic [31:0] pcpi_mul_rd_t0;
input logic pcpi_mul_ready;
input logic pcpi_mul_ready_t0;
input logic pcpi_mul_wait;
input logic pcpi_mul_wait_t0;
input logic pcpi_mul_wr;
input logic pcpi_mul_wr_t0;
input logic pcpi_timeout;
input logic [3:0] pcpi_timeout_counter;
input logic prefetched_high_word;
input logic [4:0] q_insn_rs1;
input logic [4:0] q_insn_rs1_t0;
input logic [4:0] q_insn_rs2;
input logic [4:0] q_insn_rs2_t0;
input logic [31:0] reg_next_pc;
input logic [31:0] reg_next_pc_t0;
input logic [31:0] reg_out;
input logic [31:0] reg_out_t0;
input logic [31:0] reg_pc;
input logic [31:0] reg_pc_t0;
input logic [4:0] reg_sh;
input logic genblk1__genblk1__pcpi_mul__clk;
input logic genblk1__genblk1__pcpi_mul__resetn;
input logic genblk1__genblk1__pcpi_mul__pcpi_valid;
input logic [31:0] genblk1__genblk1__pcpi_mul__pcpi_insn;
input logic [31:0] genblk1__genblk1__pcpi_mul__pcpi_rs1;
input logic [31:0] genblk1__genblk1__pcpi_mul__pcpi_rs2;
input logic genblk1__genblk1__pcpi_mul__pcpi_wr;
input logic [31:0] genblk1__genblk1__pcpi_mul__pcpi_rd;
input logic genblk1__genblk1__pcpi_mul__pcpi_wait;
input logic genblk1__genblk1__pcpi_mul__pcpi_ready;
input logic [31:0] genblk1__genblk1__pcpi_mul__pcpi_insn_t0;
input logic [31:0] genblk1__genblk1__pcpi_mul__pcpi_rd_t0;
input logic genblk1__genblk1__pcpi_mul__pcpi_ready_t0;
input logic [31:0] genblk1__genblk1__pcpi_mul__pcpi_rs1_t0;
input logic [31:0] genblk1__genblk1__pcpi_mul__pcpi_rs2_t0;
input logic genblk1__genblk1__pcpi_mul__pcpi_valid_t0;
input logic genblk1__genblk1__pcpi_mul__pcpi_wait_t0;
input logic genblk1__genblk1__pcpi_mul__pcpi_wr_t0;
input logic genblk1__genblk1__pcpi_mul__instr_any_mul;
input logic genblk1__genblk1__pcpi_mul__instr_any_mulh;
input logic genblk1__genblk1__pcpi_mul__instr_mul;
input logic genblk1__genblk1__pcpi_mul__instr_mulh;
input logic genblk1__genblk1__pcpi_mul__instr_mulhsu;
input logic genblk1__genblk1__pcpi_mul__instr_mulhu;
input logic genblk1__genblk1__pcpi_mul__instr_rs1_signed;
input logic [6:0] genblk1__genblk1__pcpi_mul__mul_counter;
input logic genblk1__genblk1__pcpi_mul__mul_finish;
input logic genblk1__genblk1__pcpi_mul__mul_start;
input logic genblk1__genblk1__pcpi_mul__mul_waiting;
input logic [63:0] genblk1__genblk1__pcpi_mul__next_rd;
input logic [63:0] genblk1__genblk1__pcpi_mul__next_rd_t0;
input logic [63:0] genblk1__genblk1__pcpi_mul__next_rdt;
input logic [63:0] genblk1__genblk1__pcpi_mul__next_rdt_t0;
input logic genblk1__genblk1__pcpi_mul__pcpi_wait_q;
input logic [63:0] genblk1__genblk1__pcpi_mul__rd;
input logic [63:0] genblk1__genblk1__pcpi_mul__rd_t0;
input logic [63:0] genblk1__genblk1__pcpi_mul__rdx;
input logic [63:0] genblk1__genblk1__pcpi_mul__rdx_t0;
input logic [63:0] genblk1__genblk1__pcpi_mul__rs1;
input logic [63:0] genblk1__genblk1__pcpi_mul__rs2;
input logic [63:0] genblk1__genblk1__pcpi_mul__rs2_t0;
input logic [63:0] genblk1__genblk1__pcpi_mul__this_rs2;
input logic [63:0] genblk1__genblk1__pcpi_mul__this_rs2_t0;
input logic genblk2__pcpi_div__clk;
input logic genblk2__pcpi_div__resetn;
input logic genblk2__pcpi_div__pcpi_valid;
input logic [31:0] genblk2__pcpi_div__pcpi_insn;
input logic [31:0] genblk2__pcpi_div__pcpi_rs1;
input logic [31:0] genblk2__pcpi_div__pcpi_rs2;
input logic genblk2__pcpi_div__pcpi_wr;
input logic [31:0] genblk2__pcpi_div__pcpi_rd;
input logic genblk2__pcpi_div__pcpi_wait;
input logic genblk2__pcpi_div__pcpi_ready;
input logic [31:0] genblk2__pcpi_div__pcpi_insn_t0;
input logic [31:0] genblk2__pcpi_div__pcpi_rd_t0;
input logic genblk2__pcpi_div__pcpi_ready_t0;
input logic [31:0] genblk2__pcpi_div__pcpi_rs1_t0;
input logic [31:0] genblk2__pcpi_div__pcpi_rs2_t0;
input logic genblk2__pcpi_div__pcpi_valid_t0;
input logic genblk2__pcpi_div__pcpi_wait_t0;
input logic genblk2__pcpi_div__pcpi_wr_t0;
input logic [31:0] genblk2__pcpi_div__dividend;
input logic [31:0] genblk2__pcpi_div__dividend_t0;
input logic [62:0] genblk2__pcpi_div__divisor;
input logic [62:0] genblk2__pcpi_div__divisor_t0;
input logic genblk2__pcpi_div__instr_any_div_rem;
input logic genblk2__pcpi_div__instr_div;
input logic genblk2__pcpi_div__instr_divu;
input logic genblk2__pcpi_div__instr_rem;
input logic genblk2__pcpi_div__instr_remu;
input logic genblk2__pcpi_div__outsign;
input logic genblk2__pcpi_div__pcpi_wait_q;
input logic [31:0] genblk2__pcpi_div__quotient;
input logic [31:0] genblk2__pcpi_div__quotient_msk;
input logic [31:0] genblk2__pcpi_div__quotient_msk_t0;
input logic [31:0] genblk2__pcpi_div__quotient_t0;
input logic genblk2__pcpi_div__running;
input logic genblk2__pcpi_div__start;
input logic [23:0] _2568_;
input logic [2:0] _2828_;
input logic [1:0] _2830_;
input logic [11:0] _2831_;
input logic [7:0] _2834_;
input logic [7:0] _2846_;
input logic [14:0] genblk1__genblk1__pcpi_mul___820_;


`include `PROPERTIES_FILE

endmodule
