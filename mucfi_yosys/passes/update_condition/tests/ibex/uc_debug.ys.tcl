# Copyright 2022 Flavien Solt, ETH Zurich.
#           2023 Katharina Ceesay-Seitz, ETH Zurich.
# Licensed under the General Public License, Version 3.0, see LICENSE for details.
# SPDX-License-Identifier: GPL-3.0-only
set FILEPATH YOUR_PATH/mucfi/mucfi_yosys/passes/update_condition/tests/ibex/
set VERILOG_INPUT $FILEPATH/ibex_sec1_uc.v
set VERILOG_OUTPUT $FILEPATH/ibex_uc.v
set TOP_MODULE ibex_top
set MUL_TO_ADDS 0
set DECOMPOSE_MEMORY 0
yosys tcl YOUR_PATH/mucfi/mucfi_yosys/passes/update_condition/tests/ibex/uc_exec.ys.tcl