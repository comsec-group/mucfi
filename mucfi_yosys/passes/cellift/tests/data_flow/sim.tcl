if { [info exists ::env(MODELSIM_WORKROOT)] }   { set MODELSIM_WORKROOT $::env(MODELSIM_WORKROOT)}         else { puts "Please set MODELSIM_WORKROOT environment variable"; exit 1 }

set LIB /tmp/kceesay/cellift_data_flow_test

set TRACE gui

if {[string equal $TRACE gui]} {
    set VOPTARGS "-voptargs=+acc"
    set DEBUGDBARG "-debugdb"
} elseif {[string equal $TRACE trace]} {
    set VOPTARGS "-voptargs=-debug"
    set DEBUGDBARG "-debugdb"
}

# GTKWave:
# set VOPTARGS "-voptargs=-debug"
# set DEBUGDBARG "-debugdb"

rm -rf $LIB

# vlog -64 -sv -work $LIB tb_top.sv ibex_top_opentitan_941315_rst_sec1_slow_mod_init.sv
# vlog -64 -sv -work $LIB tb_top_reg_val_bug.sv ibex_top_sec0_mod_taint.sv // Bug with this one

vlog -64 -sv -work $LIB test_module_cellift_data.v test_module_tb.v
vsim -64 -lib $LIB $DEBUGDBARG $VOPTARGS test_module_tb


if { [string equal $TRACE trace_fst] || [string equal $TRACE gui]} {
    log -r /*
} elseif {[string equal $TRACE trace]} {
  vcd file sim.vcd
  vcd add -r tb_top/*

}



do wave.do
restart
run 100ns

