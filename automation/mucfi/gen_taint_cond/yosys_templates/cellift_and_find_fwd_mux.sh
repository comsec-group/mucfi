#!/bin/bash

export VERILOG_INPUT=
export TOP_MODULE=
export VERILOG_OUTPUT=
export REGISTER_READ_SIGNALS=
export REGISTER_WRITE_SIGNALS=
export FORWARDING_OUTPUTS=
export PC_SIGNALS=
rm $VERILOG_OUTPUT
YOSYS_PATH -c cellift_and_find_fwd_mux.ys.tcl
python3 /data/kceesay/workspace/cellift-formal/automation/pc_taint_check/gen_taint_cond/gen_taint_cond.py --design_file $VERILOG_OUTPUT --module_name $TOP_MODULE

# ../../../../yosys -c uc.ys.tcl
