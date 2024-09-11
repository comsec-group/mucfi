# Copyright Flavien Solt, ETH Zurich.
# Licensed under the General Public License, Version 3.0, see LICENSE for details.
# SPDX-License-Identifier: GPL-3.0-only

export TRACEFILE=$PWD/traces/sim.vcd
export SIMSRAMELF=$PWD/sw/taint_src_finder_manual/build/app.elf
export SIMSRAMTAINT=$PWD/taint_data/taint_str_finder/taint_data.txt
export SIMLEN=10000
export DONTSTOP_TB_ON_TRAP=1
export MODELSIM_VLOG_COVERFLAG=+cover
export MODELSIM_VSIM_COVERFLAG=-coverage
export MODELSIM_VSIM_COVERPATH=cover.ucdb

#export PATH_TO_INSTANCELIMIT_PY=/data/kceesay/workspace/instancelimit/instancelimit.py
export RISCVDV_ROOT=/data/kceesay/workspace/riscv-dv

export MAIN_TAINT_SRC_FINDER=/data/kceesay/workspace/cellift-formal/formal_scripts/ibex_simple_system_analysis/sw/ibex_find_sigs/asm/find_decode.S
