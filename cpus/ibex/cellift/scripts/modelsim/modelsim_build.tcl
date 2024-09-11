# Modelsim script

# TRACE must be `notrace` or `trace` or `trace_fst`

if { [info exists ::env(CELLIFT_DIR)] }         { set CELLIFT_DIR $::env(CELLIFT_DIR)}                     else { puts "Please set CELLIFT_DIR environment variable"; exit 1 }
if { [info exists ::env(MODELSIM_WORKROOT)] }   { set MODELSIM_WORKROOT $::env(MODELSIM_WORKROOT)}         else { puts "Please set MODELSIM_WORKROOT environment variable"; exit 1 }
if { [info exists ::env(INSTRUMENTATION)] }     { set INSTRUMENTATION $::env(INSTRUMENTATION)}             else { puts "Please set INSTRUMENTATION environment variable"; exit 1 }
if { [info exists ::env(TRACE)] }               { set TRACE $::env(TRACE)}                                 else { puts "Please set TRACE environment variable"; exit 1 }
if { [info exists ::env(CELLIFT_META_COMMON)] } { set CELLIFT_META_COMMON $::env(CELLIFT_META_COMMON)}     else { puts "Please set CELLIFT_META_COMMON environment variable"; exit 1 }
if { [info exists ::env(SV_TOP)] }              { set SV_TOP $CELLIFT_DIR/$::env(SV_TOP) }                           else { puts "Please set SV_TOP environment variable"; exit 1 }
if { [info exists ::env(TOP_SOC)] }             { set TOP_SOC   $::env(TOP_SOC) }                          else { puts "Please set TOP_SOC environment variable"; exit 1 }
if { [info exists ::env(SV_MEM)] }              { set SV_MEM    $::env(SV_MEM) }                           else { puts "Please set SV_MEM environment variable"; exit 1 }
if { [info exists ::env(SV_TB)] }               { set SV_TB  $CELLIFT_DIR/$::env(SV_TB) }                            else { puts "Please set SV_TB environment variable"; exit 1 }
if { [info exists ::env(FUZZCOREID)] }          { set FUZZCOREID  $::env(FUZZCOREID) }                     else { puts "No FUZZCOREID specified. Defaulting to 0."; set FUZZCOREID 0 }

set LIB work_${INSTRUMENTATION}_${TRACE}

vlib $LIB

vlog -64 -suppress 7061 -sv -work $LIB -ccflags '-std=c++11' $CELLIFT_DIR/generated/sv_sources/top_pkg.sv \
$CELLIFT_DIR/generated/sv_sources/ibex_pkg.sv \
$CELLIFT_DIR/generated/sv_sources/prim_pkg.sv \
$CELLIFT_DIR/generated/sv_sources/prim_cipher_pkg.sv \
$CELLIFT_DIR/generated/sv_sources/prim_pad_wrapper_pkg.sv \
$CELLIFT_DIR/generated/sv_sources/prim_ram_1p_pkg.sv \
$CELLIFT_DIR/generated/sv_sources/alert_handler_reg_pkg.sv \
$CELLIFT_DIR/generated/sv_sources/prim_subreg_pkg.sv \
$CELLIFT_DIR/generated/sv_sources/prim_secded_pkg.sv \
$CELLIFT_DIR/generated/sv_sources/prim_util_pkg.sv \
$CELLIFT_DIR/generated/sv_sources/lc_ctrl_state_pkg.sv \
$CELLIFT_DIR/generated/sv_sources/prim_mubi_pkg.sv \
$CELLIFT_DIR/generated/sv_sources/tlul_pkg.sv \
$CELLIFT_DIR/generated/sv_sources/lc_ctrl_reg_pkg.sv \
$CELLIFT_DIR/generated/sv_sources/lc_ctrl_pkg.sv \
$CELLIFT_DIR/generated/sv_sources/prim_alert_pkg.sv \
$CELLIFT_DIR/generated/sv_sources/prim_esc_pkg.sv \
$CELLIFT_DIR/generated/sv_sources/pwrmgr_reg_pkg.sv \
$CELLIFT_DIR/generated/sv_sources/pwrmgr_pkg.sv \
$CELLIFT_DIR/generated/sv_sources/entropy_src_pkg.sv \
$CELLIFT_DIR/generated/sv_sources/edn_pkg.sv \
$CELLIFT_DIR/generated/sv_sources/otp_ctrl_reg_pkg.sv \
$CELLIFT_DIR/generated/sv_sources/otp_ctrl_pkg.sv \
$CELLIFT_DIR/generated/sv_sources/rv_core_ibex_reg_pkg.sv \
$CELLIFT_DIR/generated/sv_sources/rv_core_ibex_pkg.sv


quietly vlog -64 -suppress 7061 -sv -work $LIB +define+RANDOMIZE_INIT=1 -ccflags '-std=c++11' -sv $CELLIFT_DIR/generated/out/$INSTRUMENTATION.sv
quietly vlog -64 -suppress 7061 -sv -work $LIB $CELLIFT_META_COMMON/src/custom_irqgen.sv


vlog -64 -suppress 7061 -sv -work $LIB -ccflags '-std=c++11' -sv +incdir+$CELLIFT_DIR/generated/sv_sources/ $SV_TOP
vlog -64 -suppress 7061 -suppress 7034 +define+MODELSIM=1 -sv -work $LIB -ccflags '-std=c++11' -sv $SV_MEM
vlog -64 -suppress 7061 -sv -work $LIB -ccflags '-std=c++11' -sv $SV_TB

vlog -64 -ccflags '-std=c++11' -work $LIB -dpiheader $CELLIFT_META_COMMON/dv/elf.h $CELLIFT_META_COMMON/dv/elfloader.cc $CELLIFT_META_COMMON/dv/taintloader.cc $CELLIFT_META_COMMON/dv/common_functions.cc

vlog -64 -sv -work $LIB $CELLIFT_META_COMMON/dv/sv/rst_gen.sv $CELLIFT_META_COMMON/dv/sv/clk_rst_gen.sv $SV_TOP

quit -f
