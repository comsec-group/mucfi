# Copyright 2022 Flavien Solt, ETH Zurich.
# Licensed under the General Public License, Version 3.0, see LICENSE for details.
# SPDX-License-Identifier: GPL-3.0-only

export TOP_SOC=ibex_tiny_soc

# example to instrument only the ibex core:
# export TOP_MODULE=cellift_ibex_core

export TRACEFILE=$PWD/traces/sim.vcd
export SIMSRAMELF=$PWD/sw/quicktest_mine/build/app.elf
# export SIMSRAMELF=$PWD/../../ibex-my-sw/20230414_div_taint_b/build/app.elf



export SIMSRAMTAINT=$PWD/taint_data/quicktest/taint_data.txt

export SIMLEN=200

export MODELSIM_WORKROOT=/tmp/kceesay/modelsim_opentitan
export OPENTITAN_ROOT=../opentitan


# Have we been sourced?
export CELLIFT_IBEX_SOURCED=yes

export PATH_TO_INSTANCELIMIT_PY=/data/kceesay/workspace/instancelimit/instancelimit.py

