################################ Configuration ################################

# Either include a configuration file here:
# source config.tcl
# or pass the variable values to Jasper via the command line: cds_jasper jg thisfile.tcl -define var1 val1 -define var2 val2
#
# The latter is done by our makefiles (see corename.mk in the core's directories)
###############################################################################

if {$configured == 0} {
  source ../common/formal/scripts/procs.tcl
  source ../common/formal/scripts/launchers/jasper_config.tcl
}

set configured 1

if {$clear == 0} {
    puts "CELLIFT-FORMAL ERROR: Restoring with this script alone is not supported. Use the restore make targets."
} else {

  clear -all

  ###  Analyze the design


  # Design files
  YOUR_FORMAL_TOOL_CMD laod the  $designFile

  # Verification files
  YOUR_FORMAL_TOOL_CMD load verification source files $propertyModuleFile \
          +define+DECLASSIFICATION_ASSUMPTIONS_FILE=$declassificationAssumptionsFile \
          +define+INPUT_ASSUMPTIONS_FILE=$inputAssumptionsFile \
          +define+TAINT_ASSUMPTIONS_FILE=$taintAssumptionsFile \
          +define+PROPERTIES_FILE=$propertiesFile

  # Bind files
  YOUR_FORMAL_TOOL_CMD load the $bindFile

  YOUR_FORMAL_TOOL_CMD elaborate/compile -top $top
  #-disable_auto_bbox
  # elaborate -top $top -disable_auto_bbox -bbox_m picorv32_pcpi_div


  YOUR_FORMAL_TOOL_CMD save  whatever you can for restore ${experimentDir}/last_elaborated_design

}



#### Formal setup


# Specify the global clocks and reset
if {$resetSequenceFile == ""} {
  YOUR_FORMAL_TOOL_CMD reset empty
} else {
  if {$nonResettableRegsZero == 1} {
     YOUR_FORMAL_TOOL_CMD use reset sequence $resetSequenceFile -non_resettable_regs 0
  } else {
     YOUR_FORMAL_TOOL_CMD use reset sequence $resetSequenceFile
  }
}

source formal/scripts/clock.tcl

#### Prove the properties (can be aborted with Ctrl+C. The following report and save commands will still be executed)

source $taskFile

#### Configure visualisation

# Save values for the full design


#### Create reports
YOUR_FORMAL_TOOL_CMD generate report -file ${experimentDir}/jasper_report.txt

puts $errorInfo