
set bind_inst [YOUR_FORMAL_TOOL_CMD static design info -instance ${top} -list bind_instance]
set allTaintRegs [list]

foreach inst [YOUR_FORMAL_TOOL_CMD static design info -instance ${top} -list instance -depth $] {
  if {$bind_inst ne $inst} {
    set allTaintRegs [concat $allTaintRegs [YOUR_FORMAL_TOOL_CMD static design info -instance $inst ]]
  }
}

set fp [open "all_states.txt" w]
puts $fp $allTaintRegs
close $fp
exit 0