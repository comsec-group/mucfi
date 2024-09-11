#!/bin/bash

export VERILOG_INPUT=sv2v_out_sec1.v
export TOP_MODULE=ibex_top
export VERILOG_OUTPUT=ibex_sec1_uc.v

rm -rf $VERILOG_OUTPUT
../../../../yosys -c uc.ys.tcl
