proc save_db_expdir {experimentDir} {
  upvar $experimentDir experimentDirLocal
  #### Save setup and property status
  YOUR_FORMAL_TOOL_CMD save database $experimentDirLocal/result.db
}

proc save_db {} {
  global experimentDir
  #### Save setup and property status
  YOUR_FORMAL_TOOL_CMD save database $experimentDirLocal/result.db

}

proc dump_result_per_prop {property_name} {
  global experimentDir
  global vcdDir
  global reportDir

  set statesWithViolation {"cex"}
  set statesWithWave {"covered"}
  set propState [get_status $property_name]
  set prop_name_wo_task [lindex [split ${property_name} "::" ] 2]

  # VCD = Value Change Dump
  if {[lsearch $statesWithViolation $propState] ne -1} {
    YOUR_FORMAL_TOOL_CMD generate VCD for  ${property_name}
    YOUR_FORMAL_TOOL_CMD and save it into $experimentDir/$vcdDir/$prop_name_wo_task.vcd
  }
  if {[lsearch $statesWithWave $propState] ne -1} {
    YOUR_FORMAL_TOOL_CMD generate VCD for ${property_name}
    YOUR_FORMAL_TOOL_CMD and save it into $experimentDir/$vcdDir/$prop_name_wo_task.vcd
  }

  YOUR_FORMAL_TOOL_CMD generate report ${experimentDir}/$reportDir/jasper_report_${prop_name_wo_task}.txt
  puts "Created report for property: $property_name"
}

proc print_report_per_prop {property_name} {
  global experimentDir
  global reportDir

  puts "Determined property: $property_name"
  set prop_name_wo_task [lindex [split ${property_name} "::" ] 2]
  YOUR_FORMAL_TOOL_CMD generate report ${experimentDir}/$reportDir/jasper_report_${prop_name_wo_task}.txt
  puts "Report done"
}

# procedures which are registered as -on_determined callbacks for a proof need to have the following fixed mandatory list of arguments
# omitting them silently fails
proc dump_result_per_prop_callback {event property_name thread_id} {
  puts "Determined property: $property_name"
  dump_result_per_prop $property_name
}

proc print_report_per_prop_callback {event property_name thread_id} {
  puts "Determined property: $property_name"
  print_report_per_prop $property_name
  puts "Report done"
}


set determinedKeysAsserts {"proven", "marked_proven", "cex", "ar_cex", "error"}
set determinedKeysCover {"unreachable", "covered", "ar_covered", "error"}

# Jasper is supposed to be able to print an aggregated result, but it doesn't work reliably
proc all_props_determined {props} {

  set undeterminedKeys {"undetermined" "unprocessed" "processing"}

  set determinationState 1
  foreach {prop} $props {
    set propState [get_status $prop]
    if {[lsearch $undeterminedKeys $propState] ne -1} {
      set determinationState 0
    }
  }
  puts "There are still undetermined properties"
  return $determinationState
}

set dumpInterval 3000

proc dump_results {dumpInterval} {
  global experimentDir
  global allTasksToProveRemaining
  global dumpInterval
  global allPropsToProve
  global allPropsToCover

  while {[[all_props_determined $allPropsToProve] ne 1] || [[all_props_determined $allPropsToCover] ne 1]} {
    save_db
    report -file ${experimentDir}/jasper_report.txt -force -all

    foreach {prop} $allPropsToProve {
      dump_result_per_prop $prop
    }

    foreach {prop} $allPropsToCover {
      dump_result_per_prop $prop
    }

    after $dumpInterval
  }
}

proc dump_results_callback {event property_name thread_id} {
  #dump_results

  while {1} {
    puts "DUMPING"
    after $dumpInterval
  }

}

proc get_task_elements {currTask element} {
  set assertions [list]
  foreach {assertion} [get_design_info -task $currTask -list $element] {
    lappend assertions "${currTask}::${assertion}"
  }
  return $assertions
}

proc prove_all_tasks {tasksToProve bg} {
  set bgFlag ""
  if {$bg eq 1} {
    set bgFlag "-bg"
  } else {
    set bgFlag ""
  }
  foreach {prop} $tasksToProve {
    YOUR_FORMAL_TOOL_CMD prove all propertyies in task: $prop $bgFlag
  }
}

# Note that it does not work to dump a vcd in the on_determined_callback function if the tool runs in -batch mode and the -bg switch is passed to the prove command
proc prove_all_props {propertyList on_determined_callback dumpVCD} {
  global experimentDir
  global reportDir
  global allPropsToProve
  global allPropsToCover

  if {$dumpVCD eq 0} {
    set bgFlag "-bg"
  } else {
    set bgFlag ""
  }

  foreach {prop} $propertyList {
    YOUR_FORMAL_TOOL_CMD generate report once the property result is determined $on_determined_callback $bgFlag
    YOUR_FORMAL_TOOL_CMD generate report -file ${experimentDir}/$reportDir/jasper_report.txt
  }
}

proc get_all_tasks_to_prove {} {
  set allTasks [task -list]
  set embInd [lsearch $allTasks "<embedded>"]
  set allTasksToProve [lreplace $allTasks $embInd $embInd]
  # OPTION: remove all tasks ending in _base
  set embInd [lsearch $allTasksToProve "instr_taint_base"]
  set allTasksToProve [lreplace $allTasksToProve $embInd $embInd]
  puts $allTasksToProve
  return $allTasksToProve
}

proc get_all_properties {} {
  set allPropsToProve {}
  set allPropsToCover {}
  set allProps {}

  foreach {currTask} $allTasksToProve {
    set allProvesCurrTask [get_task_elements $currTask "assert"]
    set allCoversCurrTask [get_task_elements $currTask "cover"]
    set allPropsCurrTask [concat $allProvesCurrTask $allCoversCurrTask]

    set allProps [concat $allProps $allPropsCurrTask]
  }
  return allProps
}

proc prove_task {currTask dumpResultPerProperty dumpVCD bg} {
  global propsPerTask
  global experimentDir
  global reportDir

  if {$dumpResultPerProperty == 0} {
    YOUR_FORMAL_TOOL_CMD prove task: $currTask $bg
    YOUR_FORMAL_TOOL_CMD to generate report -file ${experimentDir}/$reportDir/jasper_report.txt
  } else {
    prove_all_props $propsPerTask($currTask) dump_result_per_prop_callback $dumpVCD
  }
}

proc prove_remaining_tasks {allProps allTasksToProve restartProves manualEngineIteration dumpResultPerProperty dumpVCD} {
  global experimentDir
  global reportDir
  set autoN 2
  set currAutoCnt 0
  set engine_list {YOUR_FORMAL_TOOL_CMD all engines}
  set nrEngines [llength $engine_list]
  set currEngine 0

  # Prove status is typically either 0 {Running engine_names} or
  # 0 {Completed} if no proofs are running
  set proveStatus [lindex [prove -status -silent] 1]

  while {$restartProves == 1 && [all_props_determined $allProps] != 1 &&
    $proveStatus == "Completed"} {
    puts "DEBUG_PC_TAINT: Restarting remaining proves"
    foreach {currTask} $allTasksToProve {

      if {$manualEngineIteration == 1} {
        if {[expr $currAutoCnt % $autoN] == 0} {
          YOUR_FORMAL_TOOL_CMD configure engine mode to automatically choose
        } else {
          YOUR_FORMAL_TOOL_CMD configure engine mode to these engines: [lindex $engine_list $currEngine]

          if {$currEngine == [expr $nrEngines - 1]} {
            set currEngine 0
          } else {
            incr currEngine
          }
        }
        incr currAutoCnt
      }

      prove_task $currTask  $dumpResultPerProperty $dumpVCD
      YOUR_FORMAL_TOOL_CMD generate report -file ${experimentDir}/$reportDir/jasper_report.txt
    }
  }
}