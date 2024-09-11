# Copyright 2022 Flavien Solt, ETH Zurich.
#           2023 Katharina Ceesay-Seitz, ETH Zurich.
# Licensed under the General Public License, Version 3.0, see LICENSE for details.
# SPDX-License-Identifier: GPL-3.0-only


yosys read_verilog -defer -sv $VERILOG_INPUT
yosys hierarchy -top $TOP_MODULE -check
yosys timestamp hierarchy
yosys proc
yosys timestamp proc
# yosys opt -purge
yosys timestamp opt

set DECOMPOSE_MEMORY 1
if {$DECOMPOSE_MEMORY == 1} {
    yosys memory
    yosys timestamp memory
    yosys proc
    yosys timestamp proc
    # yosys opt -purge
    yosys timestamp opt
}

yosys pmuxtree
yosys timestamp pmuxtree

if {$MUL_TO_ADDS == 1} {
    yosys mul_to_adds
    yosys timestamp mul_to_adds
}

# yosys opt -purge
yosys timestamp opt
yosys write_rtlil ${VERILOG_OUTPUT}_before_uc.rtlil
yosys flatten
yosys write_rtlil ${VERILOG_OUTPUT}_flatten_before_uc.rtlil
yosys write_verilog -sv ${VERILOG_OUTPUT}_flatten_before_uc.v

# yosys update_condition -exclude-signals clk,clk_i,rst_ni,clock,reset,reset_wire_reset,g_clk,g_resetn,resetn,rstz -signal_name "\\gen_regfile_ff.register_file_i.rdata_a_o " -verbose


# Update condition
# yosys update_condition -signal_name "\\gen_regfile_ff.register_file_i.rdata_a_o " -verbose
# yosys update_condition -signal_name "\\gen_regfile_ff.register_file_i.rdata_b_o " -verbose

# Register reading condition
# yosys update_condition -read-from-signals "gen_regfile_ff.register_file_i.rf_reg" -signal_name "\\gen_regfile_ff.register_file_i.rdata_a_o " -verbose
# yosys update_condition -read-from-signals "gen_regfile_ff.register_file_i.rf_reg" -signal_name "\\gen_regfile_ff.register_file_i.rdata_b_o " -verbose

# Register address reading condition
# If the address signal is routed via multiple module wires, pick the one that is closest to the instruction word
yosys update_condition -read-from-signals "u_ibex_core.id_stage_i.decoder_i.instr_rdata_i" -signal_name "\\u_ibex_core.id_stage_i.decoder_i.rf_raddr_a_o " -verbose
# yosys update_condition -read-from-signals "u_ibex_core.id_stage_i.decoder_i.instr_rdata_i" -signal_name "\\u_ibex_core.id_stage_i.decoder_i.rf_raddr_b_o " -verbose

#####################3

# yosys update_condition -read-from-signals "u_ibex_core.id_stage_i.rf_wdata_fwd_wb_i" -signal_name "\\u_ibex_core.id_stage_i.rf_rdata_a_fwd " -verbose
# yosys update_condition -read-from-signals "u_ibex_core.id_stage_i.rf_rdata_a_i" -signal_name "\\u_ibex_core.id_stage_i.rf_rdata_a_fwd " -verbose

# yosys update_condition -exclude-signals "u_ibex_core.if_stage_i.instr_out" -signal_name "\\u_ibex_core.if_stage_i.instr_rdata_id_o " -verbose
# yosys update_condition -signal_name "\\u_ibex_core.if_stage_i.instr_rdata_id_o " -verbose
# yosys update_condition -exclude-signals clk,clk_i,rst_ni,clock,reset,reset_wire_reset,g_clk,g_resetn,resetn,rstz -signal_name "\\u_ibex_core.id_stage_i.rf_wdata_id_o " -verbose



yosys write_rtlil ${VERILOG_OUTPUT}_after_uc.rtlil
#yosys cellift -exclude-signals clk,clk_i,rst_ni,clock,reset,reset_wire_reset,g_clk,g_resetn,resetn,rstz,vdd,vd,gnd,gd,vcs,vc -imprecise-shl-sshl -verbose

yosys timestamp cellift
# yosys opt -purge
yosys timestamp opt


yosys write_rtlil ${VERILOG_OUTPUT}_after_cellift.rtlil

# yosys list_state_elements -display-celltypes
# yosys timestamp list_state_elements
# yosys write_verilog -sv -noattr $VERILOG_OUTPUT
yosys write_verilog -sv -attr2comment $VERILOG_OUTPUT
# yosys write_verilog -sv -attr2comment -norename $VERILOG_OUTPUT
yosys timestamp write_verilog
yosys timestamp end
