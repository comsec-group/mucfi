#!/bin/bash

export VERILOG_INPUT=sv2v_out_sec1.v
export TOP_MODULE=ibex_top
export VERILOG_OUTPUT=ibex_sec1_uc.v

rm -rf $VERILOG_OUTPUT
/data/kceesay/workspace/cellift-yosys-connection-tree/yosys -c uc.ys.tcl
python3 /data/kceesay/workspace/cellift-formal/automation/pc_taint_check/gen_taint_cond/gen_taint_cond.py --design_file $VERILOG_OUTPUT --module_name $TOP_MODULE
# ../../../../yosys -c uc.ys.tcl