
##############################################################################################
# Instruction taint
##############################################################################################


BIND_FILE     = formal/bind/$(TOP)_bind.sv
PROPERTY_MODULE_FILE = formal/bind/$(TOP)_fpv.sv

INPUT_ASSUMPTIONS_FILE = '"formal/assumptions/$(TOP)_i_asm.sv"'
TAINT_ASSUMPTIONS_FILE = '"formal/assumptions/$(TOP)_pc_taint_asm.sv"' # not used
DECLASSIFICATION_ASSUMPTIONS_FILE = '"formal/assumptions/$(TOP)_declass_asm.sv"'
DECLASSIFICATION_SIGS_FILE = formal/scripts/declass.tcl
SYMB_INIT_ASM_FILE = formal/scripts/tasks/kronos_symb_init_no_taint.tcl

PROPERTIES_FILE = '"formal/properties/$(TOP)_ct_instr_all.sv"'

# Design config
MUL_FAST = 0

EXPERIMENT_DIR = experiments

VERIFICATION_TOOL = jasper

VERIF_FILE = ../common/formal/scripts/launchers/verif_cadence.tcl
TASK_FILE = ../common/formal/scripts/tasks/ct_instr_all.tcl

# Verification config
RESET_SEQUENCE_FILE = formal/reset_sequences/$(TOP)_rst_seq_all_0.rst
NON_RESETTABLE_REGS_ZERO = 1

# Cadence tool config
CLEAR = 1

PATH_TO_CORE = ""
SYMB_INIT = 0
CHECK_ASM = 0

DUMP_VCD = 0

# Report interval in seconds
REPORT_INTERVAL = 60

RESTART_PROVES = 1
DUMP_RESULT_PER_PROPERTY = 0