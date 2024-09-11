set propertyLocation ${top}.${top}_fpv_bind
# -----------------------------------------------------------------------------
# Task instr_taint_base
# -----------------------------------------------------------------------------
# Base task for proofs related to the division instruction
# -----------------------------------------------------------------------------
# Add all no-taint assumptions for top level inputs (by default copied from environment task, which contains all assumptions,assertions etc.)
set taskName instr_taint_base

# Assumptions:
# ------------
# Add all assumptions that describe the input protocol (if any)
YOUR_FORMAL_TOOL_CMD create task/property group ${taskName} -copy ${propertyLocation}.asm_di.*
# Add all input no taint assumptions
YOUR_FORMAL_TOOL_CMD update task  ${taskName} -copy ${propertyLocation}.asm_no_taint_top.*

# Declassification:
# -----------------
# declassify data that goes back to the register file (different signal in ibex non-/secure)
#source "declass.tcl"
source ${declassificationSigsFile}


# Sanity checks:
# --------------
YOUR_FORMAL_TOOL_CMD update task  ${taskName} -copy ${propertyLocation}.c_.*
YOUR_FORMAL_TOOL_CMD update task  ${taskName} -copy ${propertyLocation}.as_sanity.*
YOUR_FORMAL_TOOL_CMD update task  ${taskName} -copy ${propertyLocation}.as_sup.*
# -----------------------------------------------------------------------------

source ../common/formal/scripts/tasks/task_creations.tcl