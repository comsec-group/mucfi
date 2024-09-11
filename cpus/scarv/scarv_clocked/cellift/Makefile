# Copyright 2022 Flavien Solt, ETH Zurich.
# Licensed under the General Public License, Version 3.0, see LICENSE for details.
# SPDX-License-Identifier: GPL-3.0-only

ifeq "" "$(CELLIFT_ENV_SOURCED)"
$(error Please re-source env.sh first, in the meta repo, and run from there, not this repo. See README.md in the meta repo)
endif

CURR_OPENTITAN_ROOT = $(OPENTITAN_ROOT) # `small` config

ifeq "" "$(CURR_OPENTITAN_ROOT)"
$(error CURR_OPENTITAN_ROOT env variable not set. Please re-source env.sh first, in the meta repo, and run from there, not this repo. See README.md in the meta repo)
endif

PYTHON ?= python3
RESOURCEWRAPPER_TAG ?= scarv

TOP_MODULE = scarv_mem_top
TOP_SOC = scarv_tiny_soc
TOP_EXECUTABLE_NAME = V$(TOP_SOC)

# The `passthrough` target is useful so that the log matches with the sv on the generated block names, typically for ideal taint experiments.
TARGET_NAMES = vanilla cellift

include $(CELLIFT_DESIGN_PROCESSING_ROOT)/common/design.mk

# This target makes the design until the Yosys instrumentation. From there on, the Makefile can run in parallel for the various instrumentation targets.
before_instrumentation: generated/sv2v_out.v

SCARV_SV = ../external/xcrypto/rtl/xc_sha3/xc_sha3.v \
../external/xcrypto/rtl/xc_sha256/xc_sha256.v \
../external/xcrypto/rtl/xc_aessub/xc_aessub_sbox.v \
../external/xcrypto/rtl/xc_aessub/xc_aessub.v \
../external/xcrypto/rtl/xc_aesmix/xc_aesmix.v \
../external/xcrypto/rtl/p_addsub/p_addsub.v \
../external/xcrypto/rtl/p_shfrot/p_shfrot.v \
../external/xcrypto/rtl/xc_malu/xc_malu_muldivrem.v \
../external/xcrypto/rtl/xc_malu/xc_malu_long.v \
../external/xcrypto/rtl/xc_malu/xc_malu_mul.v \
../external/xcrypto/rtl/xc_malu/xc_malu_divrem.v \
../external/xcrypto/rtl/xc_malu/xc_malu_pmul.v \
../external/xcrypto/rtl/xc_malu/xc_malu_long.v \
../external/xcrypto/rtl/xc_malu/xc_malu.v \
../external/xcrypto/rtl/b_lut/b_lut.v \
../external/xcrypto/rtl/b_bop/b_bop.v \
../rtl/core/frv_alu.v \
../rtl/core/frv_asi.v \
../rtl/core/frv_bitwise.v \
../rtl/core/frv_core_fetch_buffer.v \
../rtl/core/frv_core.v \
../rtl/core/frv_counters.v \
../rtl/core/frv_csrs.v \
../rtl/core/frv_gprs.v \
../rtl/core/frv_interrupts.v \
../rtl/core/frv_leak.v \
../rtl/core/frv_lsu.v \
../rtl/core/frv_pipeline_decode.v \
../rtl/core/frv_pipeline_execute.v \
../rtl/core/frv_pipeline_fetch.v \
../rtl/core/frv_pipeline_memory.v \
../rtl/core/frv_pipeline_register.v \
../rtl/core/frv_pipeline.v \
../rtl/core/frv_pipeline_writeback.v \
../rtl/core/frv_rngif.v \
../rtl/wrapper/frv_axi_adapter.v \
src/axi_to_mem.sv\
$(CELLIFT_DESIGN_PROCESSING_ROOT)/common/src/custom_irqgen.sv\
src/scarv_mem_adapter.sv

generated/sv2v_out.v: src/mypackage.sv generated/out/vanilla.sv
	sv2v -I ../rtl/core/ -E=UnbasedUnsized $^ -w $@

# Copy some header files into cellift/ since fusesoc does not like to rely on files that are not contained in the current directory.
generated/frv_common.vh:
	cp ../rtl/core/frv_common.vh $@
generated/frv_pipeline_decode.vh:
	cp ../rtl/core/frv_pipeline_decode.vh $@

generated/out/vanilla.sv: src/mypackage.sv $(SCARV_SV) src/scarv_mem_top.sv | generated/out
	cat $^ > $@
	touch $@.log

# Make CellIFT a special case as we need to make the PC public
generated/cellift_prepublic.sv: $(CELLIFT_YS)/instrument.ys.tcl generated/sv2v_out.v | generated/out logs
	DECOMPOSE_MEMORY=1 VERILOG_INPUT=$(word 2,$^) INSTRUMENTATION=cellift VERILOG_OUTPUT=$@ TOP_MODULE=$(TOP_MODULE) $(CELLIFT_META_ROOT)/resourcewrapper $(RESOURCEWRAPPER_TAG) cellift instr yosys -c $< -l $@.log

generated/out/cellift.sv: generated/cellift_prepublic.sv
	$(PYTHON) $(CELLIFT_PYTHON_COMMON)/make_pc_taint_public.py $< $@ n_imem_addr_t0 n_imem_addr
	cp $<.log $@.log

#
# Verilator simulation
#

# Phony targets

PREPARE_TARGETS_NOTRACE=$(patsubst %,prepare_%_notrace, $(TARGET_NAMES))
PREPARE_TARGETS_TRACE=$(patsubst %,prepare_%_trace, $(TARGET_NAMES))
PREPARE_TARGETS_TRACE_FST=$(patsubst %,prepare_%_trace_fst, $(TARGET_NAMES))
PREPARE_TARGETS = $(PREPARE_TARGETS_NOTRACE) $(PREPARE_TARGETS_TRACE) $(PREPARE_TARGETS_TRACE)

.PHONY: $(PREPARE_TARGETS)
$(PREPARE_TARGETS): prepare_%: build/run_%_0.1/default-verilator/$(TOP_EXECUTABLE_NAME)

# Actual targets

BUILD_TARGETS_NOTRACE=$(patsubst %,build/run_%_notrace_0.1/default-verilator/$(TOP_EXECUTABLE_NAME), $(TARGET_NAMES))
BUILD_TARGETS_TRACE=$(patsubst %,build/run_%_trace_0.1/default-verilator/$(TOP_EXECUTABLE_NAME), $(TARGET_NAMES))
BUILD_TARGETS_TRACE_FST=$(patsubst %,build/run_%_trace_fst_0.1/default-verilator/$(TOP_EXECUTABLE_NAME), $(TARGET_NAMES))
BUILD_TARGETS = $(BUILD_TARGETS_NOTRACE) $(BUILD_TARGETS_TRACE) $(BUILD_TARGETS_TRACE_FST)

$(BUILD_TARGETS_NOTRACE): build/run_%_notrace_0.1/default-verilator/$(TOP_EXECUTABLE_NAME): generated/out/%.sv generated/out/%.sv.log generated/frv_common.vh generated/frv_pipeline_decode.vh
	rm -f fusesoc.conf
	fusesoc library add run_$*_notrace .
	$(CELLIFT_META_ROOT)/resourcewrapper $(RESOURCEWRAPPER_TAG) $*_notrace synth fusesoc --cores-root=$(CURR_OPENTITAN_ROOT) run --build run_$*_notrace
	cp $<.log $@.log
$(BUILD_TARGETS_TRACE): build/run_%_trace_0.1/default-verilator/$(TOP_EXECUTABLE_NAME): generated/out/%.sv generated/out/%.sv.log generated/frv_common.vh generated/frv_pipeline_decode.vh
	rm -f fusesoc.conf
	fusesoc library add run_$*_trace .
	$(CELLIFT_META_ROOT)/resourcewrapper $(RESOURCEWRAPPER_TAG) $*_trace synth fusesoc --cores-root=$(CURR_OPENTITAN_ROOT) run --build run_$*_trace
	cp $<.log $@.log
$(BUILD_TARGETS_TRACE_FST): build/run_%_trace_fst_0.1/default-verilator/$(TOP_EXECUTABLE_NAME): generated/out/%.sv generated/out/%.sv.log generated/frv_common.vh generated/frv_pipeline_decode.vh
	rm -f fusesoc.conf
	fusesoc library add run_$*_trace_fst .
	$(CELLIFT_META_ROOT)/resourcewrapper $(RESOURCEWRAPPER_TAG) $*_trace_fst synth fusesoc --cores-root=$(CURR_OPENTITAN_ROOT) run --build run_$*_trace_fst
	cp $<.log $@.log

#
# Recompile, if only the Verilator C++ testbench has changed
#

RECOMPILE_TARGETS_NOTRACE=$(patsubst %,recompile_%_notrace, $(TARGET_NAMES))
RECOMPILE_TARGETS_TRACE=$(patsubst %,recompile_%_trace, $(TARGET_NAMES))
RECOMPILE_TARGETS_TRACE_FST=$(patsubst %,recompile_%_trace_fst, $(TARGET_NAMES))
RECOMPILE_TARGETS = $(RECOMPILE_TARGETS_NOTRACE) $(RECOMPILE_TARGETS_TRACE) $(RECOMPILE_TARGETS_TRACE_FST)

.PHONY: $(RECOMPILE_TARGETS)
$(RECOMPILE_TARGETS): recompile_%: build/run_%_0.1
	rm -f $</default-verilator/toplevel.o
	rm -f $</default-verilator/$(TOP_EXECUTABLE_NAME)
	rm -rf $</src/run_$*_0.1/dv
	rm -rf ./build/dv
	cp -r dv $</src/run_$*_0.1
	cp -r $(CELLIFT_DESIGN_PROCESSING_ROOT)/common/dv ./build
	make -C $</default-verilator


#
# Rerun, while making sure that nothing will be recompiled because of this call.
#

RERUN_TARGETS_NOTRACE=$(patsubst %,rerun_%_notrace, $(TARGET_NAMES))
RERUN_TARGETS_TRACE=$(patsubst %,rerun_%_trace, $(TARGET_NAMES))
RERUN_TARGETS_TRACE_FST=$(patsubst %,rerun_%_trace_fst, $(TARGET_NAMES))
RERUN_TARGETS = $(RERUN_TARGETS_NOTRACE) $(RERUN_TARGETS_TRACE) $(RERUN_TARGETS_TRACE_FST)

.PHONY: $(RERUN_TARGETS)
$(RERUN_TARGETS_TRACE) $(RERUN_TARGETS_TRACE_FST): | traces
$(RERUN_TARGETS): rerun_%: build/run_%_0.1/
	$</default-verilator/$(TOP_EXECUTABLE_NAME)

#
# Run, potentially after compiling.
#

RUN_TARGETS_NOTRACE=$(patsubst %,run_%_notrace, $(TARGET_NAMES))
RUN_TARGETS_TRACE=$(patsubst %,run_%_trace, $(TARGET_NAMES))
RUN_TARGETS_TRACE_FST=$(patsubst %,run_%_trace_fst, $(TARGET_NAMES))
RUN_TARGETS = $(RUN_TARGETS_NOTRACE) $(RUN_TARGETS_TRACE) $(RUN_TARGETS_TRACE_FST)

$(RUN_TARGETS_TRACE) $(RUN_TARGETS_TRACE_FST): | traces
$(RUN_TARGETS): run_%: ./build/run_%_0.1/default-verilator/$(TOP_EXECUTABLE_NAME)
	cd build/run_$*_0.1/default-verilator && $(CELLIFT_META_ROOT)/resourcewrapper $(RESOURCEWRAPPER_TAG) $* run ./$(TOP_EXECUTABLE_NAME)

#
# Extract Yosys cell statistics
#

STATISTICS_TARGETS=$(patsubst %,statistics/%.log, $(TARGET_NAMES))

$(STATISTICS_TARGETS): statistics/%.log: $(CELLIFT_YS)/statistics.ys.tcl generated/sv2v_out.v | statistics
	DECOMPOSE_MEMORY=1 VERILOG_INPUT=$(word 2,$^) INSTRUMENTATION=$* TOP_MODULE=$(TOP_MODULE) $(CELLIFT_META_ROOT)/resourcewrapper $(RESOURCEWRAPPER_TAG) $* stat yosys -c $< -l $@

#
# Modelsim
#

CELLIFT_DIR := ${shell dirname ${shell pwd}}/cellift
MODELSIM_PATH_TO_BUILD_TCL = $(CELLIFT_DESIGN_PROCESSING_ROOT)/common/modelsim/modelsim_build.tcl
MODELSIM_INCDIRSTR = +incdir+$(CELLIFT_DIR)/../rtl/core

include $(CELLIFT_DESIGN_PROCESSING_ROOT)/common/modelsim.mk
