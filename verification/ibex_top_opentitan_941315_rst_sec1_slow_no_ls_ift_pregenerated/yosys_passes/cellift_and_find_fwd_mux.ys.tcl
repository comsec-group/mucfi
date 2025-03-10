# Copyright 2022 Flavien Solt, ETH Zurich.
#           2023 Katharina Ceesay-Seitz, ETH Zurich.
# Licensed under the General Public License, Version 3.0, see LICENSE for details.
# SPDX-License-Identifier: GPL-3.0-only


yosys read_verilog -defer -sv /data/kceesay/workspace/mucfi/cpus/ibex_custom/cellift/generated/sv2v_out.v
yosys hierarchy -top ibex_top -check
yosys proc
yosys opt -purge


yosys memory
yosys proc
yosys opt -purge


yosys pmuxtree
yosys opt -purge

yosys timestamp before_cellift
# These are the default 'exclude' signals used by cellift. They must contain the clock and reset signal of the design.
yosys cellift -exclude-signals clk,clk_i,rst_ni,clock,reset,reset_wire_reset,g_clk,g_resetn,resetn,rstz,vdd,vd,gnd,gd,vcs,vc -imprecise-shl-sshl -verbose 
yosys timestamp after_cellift

yosys find_fwd_mux_selects -register-read-signals "\\gen_regfile_ff.register_file_i .rdata_a_o,\\gen_regfile_ff.register_file_i .rdata_b_o" -forwarding-signals "u_ibex_core.wb_stage_i.rf_wdata_fwd_wb_o" -register-write-signals "u_ibex_core.rf_wdata_wb_ecc_o" -pc-signals "u_ibex_core.id_stage_i.pc_id_i"

yosys timestamp after_find_fwd_mux_selects

yosys opt -purge
yosys list_state_elements -display-celltypes

yosys write_verilog -sv -attr2comment /data/kceesay/workspace/mucfi/verification/ibex_top_opentitan_941315_rst_sec1_slow_no_ls_ift/designs/cellift.v

