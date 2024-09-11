#!/bin/bash

export VERILOG_INPUT=test_module.v
export TOP_MODULE=test_module
export VERILOG_OUTPUT=test_module_cellift_data.v

/data/kceesay/workspace/cellift-yosys-connection-tree/yosys -c instrument.ys

# ../../../../yosys -c uc.ys.tcl