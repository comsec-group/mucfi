# Copyright 2022 Flavien Solt, ETH Zurich.
#           2024 Katharina Ceesay-Seitz, ETH Zurich.
# Licensed under the General Public License, Version 3.0, see LICENSE for details.
# SPDX-License-Identifier: GPL-3.0-only

yosys read_verilog -defer -sv /data/kceesay/workspace/mucfi/cpus/picorv32/cellift/generated/sv2v_out.v
yosys hierarchy -top picorv32 -check
yosys proc
yosys opt -purge

yosys memory
yosys proc
yosys opt -purge

yosys pmuxtree

yosys opt -purge
yosys timestamp opt
yosys flatten

yosys update_condition -read-from-signals "mem_rdata_latched" -signal_name "decoded_rs1" -verbose


# Important to simplify the update condition
yosys opt -purge

yosys write_verilog -sv -attr2comment /data/kceesay/workspace/mucfi/verification/picorv32_dft/yosys_passes/design_uc_iw.v

yosys timestamp end
