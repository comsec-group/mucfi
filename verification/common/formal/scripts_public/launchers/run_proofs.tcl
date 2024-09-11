

# tasks are proven sequentially within one prove command. Therefore we start them all in the background with -bg, which
# runs proofs in parallel.
set allTasksToProve [get_all_tasks_to_prove]

if {$checkAsm == 1} {
  check_assumptions -task $allTasksToProve -conflict -minimize -bg
}

set reportDir "reports"
set vcdDir "vcds"
file mkdir $experimentDir/$vcdDir
file mkdir $experimentDir/$reportDir

set allPropsToProve {}
set allPropsToCover {}
set allProps {}
array set propsPerTask {}

foreach {currTask} $allTasksToProve {

  set allProvesCurrTask [get_task_elements $currTask "assert"]
  set allCoversCurrTask [get_task_elements $currTask "cover"]
  set allPropsCurrTask [concat $allProvesCurrTask $allCoversCurrTask]

  set allPropsToProve [concat $allPropsToProve $allProvesCurrTask]
  set allPropsToCover [concat $allPropsToCover $allCoversCurrTask]
  set allProps [concat $allProps $allPropsCurrTask]
  set propsPerTask($currTask) $allPropsCurrTask

  if {$isCmd == 1} {
   prove_task $currTask $dumpResultPerProperty $dumpVCD -bg
  }
}

if {$isCmd == 1} {
  prove_remaining_tasks $allProps $allTasksToProve $restartProves 1 $dumpResultPerProperty $dumpVCD
}

# Note in case there are properties that run very long, this part will only be reached if $dumpVCD is 0, because otherwise the prove command is run in the foreground
if {$isCmd == 1 && $dumpVCD == 0} {
  while {[all_props_determined [concat $allPropsToProve $allPropsToCover]] != 1} {
    YOUR_FORMAL_TOOL_CMD generate report -file ${experimentDir}/$reportDir/jasper_report.txt
    after [expr $reportInterval * 1000]
  }
}

YOUR_FORMAL_TOOL_CMD generate report -file ${experimentDir}/$reportDir/jasper_report_final.txt
