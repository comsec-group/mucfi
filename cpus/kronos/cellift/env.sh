# Copyright Flavien Solt, ETH Zurich.
# Licensed under the General Public License, Version 3.0, see LICENSE for details.
# SPDX-License-Identifier: GPL-3.0-only

export TRACEFILE=$PWD/traces/sim.vcd
export SIMSRAMELF=$PWD/sw/quicktest/build/app.elf
export SIMSRAMTAINT=$PWD/taint_data/quicktest/taint_data.txt
export SIMLEN=10000
export DONTSTOP_TB_ON_TRAP=1


export PATH_TO_INSTANCELIMIT_PY=/data/kceesay/workspace/instancelimit/instancelimit.py

export MODELSIM_WORKROOT=/tmp/kceesay/modelsim_kronos
