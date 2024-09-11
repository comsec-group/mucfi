# Copyright 2022 Flavien Solt, ETH Zurich.
#           2024 Katharina Ceesay-Seitz, ETH Zurich.
# Licensed under the General Public License, Version 3.0, see LICENSE for details.
# SPDX-License-Identifier: GPL-3.0-only

yosys read_verilog -defer -sv /data/kceesay/workspace/mucfi/cpus/scarv/scarv_unclocked/cellift/generated/sv2v_out.v
yosys hierarchy -top frv_core -check
yosys proc
yosys opt -purge

yosys memory
yosys proc
yosys opt -purge

yosys pmuxtree

yosys opt -purge
yosys timestamp opt
yosys flatten

yosys update_condition -read-from-signals "i_pipeline.i_pipeline_s1_decode.s1_data" -signal_name "\\i_pipeline.i_pipeline_s1_decode.dec_rs1_32 " -verbose


# Important to simplify the update condition
yosys opt -purge

yosys write_verilog -sv -attr2comment /data/kceesay/workspace/mucfi/verification/scarv_dft/yosys_passes/design_uc_iw.v

yosys timestamp end
