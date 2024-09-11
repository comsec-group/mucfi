##############################################################################################
# This configuration is used to print the list of design states. A python script then filters
# the taint states based on Yosys output.
##############################################################################################
# TOP=cellift_kronos
# GIT_COMMIT=9e4fa466

# DESIGN_FILE   = designs/$(TOP)_$(GIT_COMMIT).sv
BIND_FILE     = formal/bind/$(TOP)_bind.sv
PROPERTY_MODULE_FILE = formal/bind/$(TOP)_fpv.sv

INPUT_ASSUMPTIONS_FILE = '"formal/assumptions/$(TOP)_i_asm.sv"'
TAINT_ASSUMPTIONS_FILE = '"formal/assumptions/$(TOP)_pc_taint_asm.sv"' # not used
DECLASSIFICATION_ASSUMPTIONS_FILE = '"formal/assumptions/$(TOP)_declass_asm.sv"'
DECLASSIFICATION_SIGS_FILE = formal/scripts/declass.tcl
SYMB_INIT_ASM_FILE = formal/scripts/tasks/$(TOP)_symb_init_no_taint.tcl   # no "" when referring to tcl scripts!!

PROPERTIES_FILE = '"../common/formal/properties/empty_properties.sv"'

EXPERIMENT_DIR = experiments

VERIFICATION_TOOL = jasper

# "formal/reset_sequences/$(TOP)_no.rst"
VERIF_FILE = ../common/formal/scripts/launchers/verif_cadence.tcl
TASK_FILE = ../common/formal/scripts/tasks/print_taint_state_sigs.tcl

# Verification config
RESET_SEQUENCE_FILE = ""
NON_RESETTABLE_REGS_ZERO = 1

# Cadence tool config
CLEAR = 1

PATH_TO_CORE = ""
SYMB_INIT = 1
CHECK_ASM = 0

DUMP_VCD = 0

# Report interval in seconds
REPORT_INTERVAL = 60

RESTART_PROVES = 1
DUMP_RESULT_PER_PROPERTY = 0