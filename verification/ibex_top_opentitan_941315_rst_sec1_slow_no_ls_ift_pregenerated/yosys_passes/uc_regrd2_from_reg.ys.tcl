# Copyright 2022 Flavien Solt, ETH Zurich.
#           2024 Katharina Ceesay-Seitz, ETH Zurich.
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
yosys timestamp opt
yosys flatten

yosys update_condition -read-from-signals "gen_regfile_ff.register_file_i.rf_reg" -signal_name "\\gen_regfile_ff.register_file_i.rdata_b_o" -verbose


# Important to simplify the update condition
yosys opt -purge

yosys write_verilog -sv -attr2comment /data/kceesay/workspace/mucfi/verification/ibex_top_opentitan_941315_rst_sec1_slow_no_ls_ift/yosys_passes/design_uc_regrd2_from_reg.v

yosys timestamp end
