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
yosys write_rtlil ${VERILOG_OUTPUT}_before_fwd.rtlil
yosys write_json ${VERILOG_OUTPUT}_before_fwd.json
# yosys flatten
# yosys write_rtlil ${VERILOG_OUTPUT}_flatten_before_uc.rtlil
# yosys write_verilog -sv ${VERILOG_OUTPUT}_flatten_before_uc.v

# Find the forwarding multiplexer selects:
yosys find_fwd_mux_selects -register-read-signals "\\gen_regfile_ff.register_file_i .rdata_a_o,\\gen_regfile_ff.register_file_i .rdata_b_o" -forwarding-signals "u_ibex_core.wb_stage_i.rf_wdata_fwd_wb_o" -register-write-signals "u_ibex_core.rf_wdata_wb_ecc_o" -pc-signals "u_ibex_core.id_stage_i.pc_id_i"
# yosys find_fwd_mux_selects -register-read-signals "\\gen_regfile_ff.register_file_i .rdata_b_o" -forwarding-signals "u_ibex_core.wb_stage_i.rf_wdata_fwd_wb_o" -register-write-signals "u_ibex_core.rf_wdata_wb_ecc_o" -pc-signals "u_ibex_core.id_stage_i.pc_id_i"

# yosys write_rtlil ${VERILOG_OUTPUT}_after_fwd.rtlil
#yosys cellift -exclude-signals clk,clk_i,rst_ni,clock,reset,reset_wire_reset,g_clk,g_resetn,resetn,rstz,vdd,vd,gnd,gd,vcs,vc -imprecise-shl-sshl -verbose

# Do we find an fwd mux before the operand register read signal?
# Expecting to only find the same ones as we find as when using the register read signal as register read signal
# yosys find_fwd_mux_selects -register-read-signals "\\gen_regfile_ff.register_file_i .\\g_rf_flops\[1\].rf_reg_q " -forwarding-signals "u_ibex_core.wb_stage_i.rf_wdata_fwd_wb_o" -register-write-signals "u_ibex_core.rf_wdata_wb_ecc_o" -pc-signals "u_ibex_core.id_stage_i.pc_id_i"



# yosys opt -purge
# yosys timestamp opt


# yosys write_rtlil ${VERILOG_OUTPUT}_after_cellift.rtlil

# yosys list_state_elements -display-celltypes
# yosys timestamp list_state_elements
# yosys write_verilog -sv -noattr $VERILOG_OUTPUT
# yosys write_verilog -sv -attr2comment $VERILOG_OUTPUT
# yosys write_verilog -sv -attr2comment -norename $VERILOG_OUTPUT
# yosys timestamp write_verilog
# yosys timestamp end
