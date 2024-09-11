## Usage:
## Run this script to restore a saved session.
## Do not run it while a session is running in the background, as this may corrupt the database and all results will be lost.

# source ../common/formal/scripts/launchers/jasper_config.tcl

source ../common/formal/scripts/procs.tcl

YOUR_FORMAL_TOOL_CMD to restore session/database

set restartProves 1
set dumpResultPerProperty 1
set dumpVCD 1

if {$startRun} {
  set allTasksToProve [get_all_tasks_to_prove]
  set allProps [get_all_properties]
  prove_remaining_tasks $allProps $allTasksToProve $restartProves 1 $dumpResultPerProperty $dumpVCD
}