proc create_ucfi_task {taskname checkername instr_taint_base top propertyLocation operand_sig declassify iuv_type } {
  global symbInit
  global declassifiedSigs

  source ../common/formal/scripts/instr_types.tcl

  set name_suffixes {}

  if {$declassify == 1} {
    lappend name_suffixes "_declassify"
  }

  set taskName ${taskname}
  foreach suffix $name_suffixes {
    set taskName ${taskName}${suffix}
  }

  YOUR_FORMAL_TOOL_CMD create task/group of properties  ${taskName} -copy_all -source_task ${instr_taint_base}

  # Taint injection point
  if {$operand_sig ne ""} {
    stopat -task ${taskName} "${operand_sig}"
  }

  # Declassification:
  if {$declassify == 1} {
    foreach sig $declassifiedSigs {
      stopat -task ${taskName} "${sig}"
    }
    YOUR_FORMAL_TOOL_CMD add to task: ${taskName} -copy ${propertyLocation}.asm_declass_.*
  }

  ###

  # Taint active and taint start and stop cond must be 0 for as long as the taint injection start condition has to look into the past.
  # E.g if we need to use instr_word = $past(mem_rdata_q, 2);, then we need 2 valid untainted cycles before the start condition may be true,
  # otherwise the injection assumptions becomes true based on an arbitrary non-existent value before formal anlaysis started

  # Any free signal that is derived from a past value has to be set to a known value for as many clock cycles as are needed to make
  # the past value available. E.g. taint_active depends on the value of $past(tainted_once, 1), so we must set it to a known value for 1
  # clock cycle (unless it is acceptable that it has a random value in the first clock cycle).
  # If a signal depends on a $past(sig, n) expression, we must control it for n clock cycles.

  set nrInitCyclesNoTaint 1

  YOUR_FORMAL_TOOL_CMD assume -bound $nrInitCyclesNoTaint "${top}_fpv_bind.${checkername}.taint_active == 0" -name ${taskName}::"${checkername}_taint_active_0"
  YOUR_FORMAL_TOOL_CMD assume -bound $nrInitCyclesNoTaint "${top}_fpv_bind.${checkername}.taint_start == 0" -name ${taskName}::"${checkername}_taint_start_0"
  YOUR_FORMAL_TOOL_CMD assume -bound $nrInitCyclesNoTaint "${top}_fpv_bind.${checkername}.tainted_once == 0" -name ${taskName}::"${checkername}_taint_once_0"


  YOUR_FORMAL_TOOL_CMD assume "${top}_fpv_bind.iuv_type == ${iuv_type}_TYPE"

  # Checker contains taint injection assumptions and property to check
  YOUR_FORMAL_TOOL_CMD add to task ${taskName} -copy ${propertyLocation}.${checkername}..* -regexp
}
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------