
# Copyright 2024 Katharina Ceesay-Seitz, ETH Zurich.
# Licensed under the General Public License, Version 3.0, see LICENSE for details.
# SPDX-License-Identifier: GPL-3.0-only
###########################################################################################


BIND_FILE     = formal/bind/$(TOP_MODULE)_bind.sv
PROPERTY_MODULE_FILE = formal/bind/$(TOP_MODULE)_fpv.sv

INPUT_ASSUMPTIONS_FILE = '"formal/assumptions/$(TOP_MODULE)_i_asm.sv"'
TAINT_ASSUMPTIONS_FILE = '"formal/assumptions/$(TOP_MODULE)_pc_taint_asm.sv"' # not used
DECLASSIFICATION_ASSUMPTIONS_FILE = '"formal/assumptions/$(TOP_MODULE)_declass_asm.sv"'
DECLASSIFICATION_SIGS_FILE = formal/scripts/declass.tcl
PROPERTIES_FILE = '"formal/properties/$(TOP_MODULE)_ct_instr_all.sv"'

EXPERIMENT_DIR = experiments

VERIFICATION_TOOL = jasper

VERIF_FILE = ../common/formal/scripts/launchers/verif_cadence.tcl
TASK_FILE = ../common/formal/scripts/tasks/ct_instr_all.tcl

# Verification config
RESET_SEQUENCE_FILE = formal/reset_sequences/$(TOP_MODULE)_rst_seq_all_0.rst
NON_RESETTABLE_REGS_ZERO = 1

# Cadence tool config
CLEAR = 1

PATH_TO_CORE = ""
CHECK_ASM = 0

DUMP_VCD = 0

# Report interval in seconds
REPORT_INTERVAL = 60

RESTART_PROVES = 1
DUMP_RESULT_PER_PROPERTY = 0