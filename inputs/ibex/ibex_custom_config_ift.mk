REGISTER_READ_SIGNALS="\\gen_regfile_ff.register_file_i .rdata_a_o,\\gen_regfile_ff.register_file_i .rdata_b_o"
REGISTER_WRITE_SIGNALS="u_ibex_core.rf_wdata_wb_ecc_o"
REGISTER_FILE="gen_regfile_ff.register_file_i.rf_reg"
REGISTER_RS1="\\gen_regfile_ff.register_file_i .\\g_rf_flops\[1\].rf_reg_q "
REG_ADDR="\\u_ibex_core.id_stage_i.decoder_i.rf_raddr_a_o "
INSTR_WORD="u_ibex_core.id_stage_i.decoder_i.instr_rdata_i"
FORWARDING_INPUT_BEFORE_REGREAD=
FORWARDING_OUTPUTS="u_ibex_core.wb_stage_i.rf_wdata_fwd_wb_o"
PC_SIGNAL="u_ibex_core.id_stage_i.pc_id_i"
CLOCK_SIGNAL=clk_i
RESET_SIGNAL=rst_ni
RESET_POLARITY=0
ISA_SELECTION=i,m,zicsr,zifencei
TOP_MODULE=ibex_top
DESIGN_DIR=MUCFI_PATH/cpus/ibex_custom_pregenerated
YOSYS_DIR=MUCFI_PATH/mucfi_yosys/
PATH_TO_PY_SCRIPTS=MUCFI_PATH/automation
OUT_DIR=MUCFI_PATH/verification/ibex_top_opentitan_941315_rst_sec1_slow_no_ls_ift
TAINT_TRACKING_METHOD=ift
CONFIG_FILE=MUCFI_PATH/inputs/ibex/ibex_custom_config_ift.mk
OPERAND_FILE_TEMPLATE=MUCFI_PATH/verification/common/templates/signal_defs/operand_assignments_first.sv
FWD_MUX_SELECTS=u_ibex_core.id_stage_i.and$MUCFI_PATH/cpus/ibex_custom_pregenerated/cellift/generated/sv2v_out.v:17714$917_Y,u_ibex_core.id_stage_i.and$MUCFI_PATH/cpus/ibex_custom_pregenerated/cellift/generated/sv2v_out.v:17715$919_Y