# Copyright 2022 Flavien Solt, ETH Zurich.
#           2024 Katharina Ceesay-Seitz, ETH Zurich.
# Licensed under the General Public License, Version 3.0, see LICENSE for details.
# SPDX-License-Identifier: GPL-3.0-only

yosys read_verilog -defer -sv ${VERILOG_INPUT}
yosys hierarchy -top ${TOP_MODULE} -check
yosys proc
yosys opt -purge

yosys memory
yosys proc
yosys opt -purge

yosys pmuxtree

yosys opt -purge
yosys timestamp opt
yosys flatten

${CALL_UPDATE_CONDITION_PASS}

# Important to simplify the update condition
yosys opt -purge

yosys write_verilog -sv -attr2comment ${VERILOG_OUTPUT}

yosys timestamp end
