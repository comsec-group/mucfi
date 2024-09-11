# Copyright 2022 Flavien Solt, ETH Zurich.
#           2023 Katharina Ceesay-Seitz, ETH Zurich.
# Licensed under the General Public License, Version 3.0, see LICENSE for details.
# SPDX-License-Identifier: GPL-3.0-only


yosys read_verilog -defer -sv /data/kceesay/workspace/mucfi/cpus/kronos/cellift/generated/sv2v_out.v
yosys hierarchy -top kronos_core -check
yosys proc
yosys opt -purge


yosys memory
yosys proc
yosys opt -purge


yosys pmuxtree
yosys opt -purge

yosys timestamp before_cellift
# These are the default 'exclude' signals used by cellift. They must contain the clock and reset signal of the design.
yosys cellift -exclude-signals clk,clk_i,rst_ni,clock,reset,reset_wire_reset,g_clk,g_resetn,resetn,rstz,vdd,vd,gnd,gd,vcs,vc -imprecise-shl-sshl -verbose -data-flow
yosys timestamp after_cellift

yosys find_fwd_mux_selects -register-read-signals "u_if.u_rf.regrd_rs1,u_if.u_rf.regrd_rs2" -forwarding-signals "u_ex.regwr_data" -register-write-signals "u_ex.regwr_data" -pc-signals "u_if.pc_last"

# Do we find an fwd mux before the operand register read signal?
yosys find_fwd_mux_selects -register-read-signals "u_if.u_rf.REG\[1\]" -forwarding-signals "u_ex.regwr_data" -register-write-signals "u_ex.regwr_data" -pc-signals "u_if.pc_last"

yosys timestamp after_find_fwd_mux_selects

yosys opt -purge
yosys list_state_elements -display-celltypes

yosys write_verilog -sv -attr2comment /data/kceesay/workspace/mucfi/verification/kronos_dft/designs/celldft.v

