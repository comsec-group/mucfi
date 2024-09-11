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
RESOURCEWRAPPER_TAG ?= kronos

TOP_MODULE = kronos_mem_top
TOP_MODULE_NOMEM = kronos_core
TOP_SOC = kronos_tiny_soc
TOP_EXECUTABLE_NAME = V$(TOP_SOC)
TOP_EXECUTABLE_NAME_NOMEM = V$(TOP_MODULE_NOMEM)

# The `passthrough` target is useful so that the log matches with the sv on the generated block names, typically for ideal taint experiments.
TARGET_NAMES = vanilla cellift coverage rfuzz difuzzrtl difuzzrtlactive
TARGET_NAMES_NOMEM = difuzzrtlactive

include $(CELLIFT_DESIGN_PROCESSING_ROOT)/common/design.mk

# This target makes the design until the Yosys instrumentation. From there on, the Makefile can run in parallel for the various instrumentation targets.
before_instrumentation: generated/sv2v_out.v

KRONOS_SV = ../rtl/core/kronos_types.sv \
../rtl/core/kronos_alu.sv \
../rtl/core/kronos_branch.sv \
../rtl/core/kronos_core.sv \
../rtl/core/kronos_counter64.sv \
../rtl/core/kronos_csr.sv \
../rtl/core/kronos_EX.sv \
../rtl/core/kronos_hcu.sv \
../rtl/core/kronos_ID.sv \
../rtl/core/kronos_IF.sv \
../rtl/core/kronos_lsu.sv \
../rtl/core/kronos_RF.sv \
../rtl/core/kronos_agu.sv

generated/sv2v_out.v: generated/out/vanilla.sv
	sv2v $^ -w $@

generated/out/vanilla.sv: $(KRONOS_SV) src/kronos_mem_top.sv | generated/out
	morty $^ -o $@
	touch $@.log

# Make CellIFT a special case as we need to make the PC public
generated/cellift_prepublic.sv: $(CELLIFT_YS)/instrument.ys.tcl generated/sv2v_out.v | generated/out logs
	DECOMPOSE_MEMORY=1 VERILOG_INPUT=$(word 2,$^) INSTRUMENTATION=cellift VERILOG_OUTPUT=$@ TOP_MODULE=$(TOP_MODULE) $(CELLIFT_META_ROOT)/resourcewrapper $(RESOURCEWRAPPER_TAG) cellift instr yosys -c $< -l $@.log

generated/out/cellift.sv: generated/cellift_prepublic.sv
	$(PYTHON) $(CELLIFT_PYTHON_COMMON)/make_pc_taint_public.py $< generated/interm.sv pc_t0 pc
	$(PYTHON) $(CELLIFT_PYTHON_COMMON)/add_sim_initbegin.py generated/interm.sv generated/interm1.sv pc_t0 pc
	$(PYTHON) $(CELLIFT_PYTHON_COMMON)/simplify_yosysout.py generated/interm1.sv generated/interm2.sv pc_t0 pc
	$(PYTHON) $(CELLIFT_PYTHON_COMMON)/remove_explicitx.py generated/interm2.sv $@ pc_t0 pc
	cp $<.log $@.log

# rfuzz coverage metric
generated/out/rfuzz.sv: $(CELLIFT_YS)/rfuzz.ys.tcl generated/sv2v_out.v | generated/out logs
	DECOMPOSE_MEMORY=1 VERILOG_INPUT=$(word 2,$^) INSTRUMENTATION=cellift VERILOG_OUTPUT=$@ TOP_MODULE=$(TOP_MODULE) $(CELLIFT_META_ROOT)/resourcewrapper $(RESOURCEWRAPPER_TAG) cellift instr yosys -c $< -l $@.log
# difuzzrtl coverage metric
generated/out/difuzzrtl.sv: $(CELLIFT_YS)/difuzzrtl.ys.tcl generated/sv2v_out.v | generated/out logs
	DECOMPOSE_MEMORY=1 VERILOG_INPUT=$(word 2,$^) INSTRUMENTATION=cellift VERILOG_OUTPUT=$@ TOP_MODULE=$(TOP_MODULE) $(CELLIFT_META_ROOT)/resourcewrapper $(RESOURCEWRAPPER_TAG) cellift instr yosys -c $< -l $@.log
# difuzzrtl for fuzzing
generated/out/difuzzrtlactive.sv: $(CELLIFT_YS)/difuzzrtl.ys.tcl generated/sv2v_out.v | generated/out logs
	DECOMPOSE_MEMORY=1 VERILOG_INPUT=$(word 2,$^) INSTRUMENTATION=cellift VERILOG_OUTPUT=$@ TOP_MODULE=$(TOP_MODULE_NOMEM) $(CELLIFT_META_ROOT)/resourcewrapper $(RESOURCEWRAPPER_TAG) cellift instr yosys -c $< -l $@.log

# Coverage is the same as vanilla
generated/out/coverage.sv: generated/out/vanilla.sv
	cp $< $@
generated/out/coverage.sv.log: generated/out/vanilla.sv.log
	cp $< $@

#
# Verilator simulation
#

# Phony targets

PREPARE_TARGETS_NOTRACE=$(patsubst %,prepare_%_notrace, $(TARGET_NAMES) $(TARGET_NAMES_NOMEM))
PREPARE_TARGETS_TRACE=$(patsubst %,prepare_%_trace, $(TARGET_NAMES) $(TARGET_NAMES_NOMEM))
PREPARE_TARGETS_TRACE_FST=$(patsubst %,prepare_%_trace_fst, $(TARGET_NAMES) $(TARGET_NAMES_NOMEM))
PREPARE_TARGETS = $(PREPARE_TARGETS_NOTRACE) $(PREPARE_TARGETS_TRACE) $(PREPARE_TARGETS_TRACE)

.PHONY: $(PREPARE_TARGETS)
$(PREPARE_TARGETS): prepare_%: build/run_%_0.1/default-verilator/$(TOP_EXECUTABLE_NAME)

# Actual targets

BUILD_TARGETS_NOTRACE=$(patsubst %,build/run_%_notrace_0.1/default-verilator/$(TOP_EXECUTABLE_NAME), $(TARGET_NAMES) $(TARGET_NAMES_NOMEM))
BUILD_TARGETS_TRACE=$(patsubst %,build/run_%_trace_0.1/default-verilator/$(TOP_EXECUTABLE_NAME), $(TARGET_NAMES) $(TARGET_NAMES_NOMEM))
BUILD_TARGETS_TRACE_FST=$(patsubst %,build/run_%_trace_fst_0.1/default-verilator/$(TOP_EXECUTABLE_NAME), $(TARGET_NAMES) $(TARGET_NAMES_NOMEM))
BUILD_TARGETS = $(BUILD_TARGETS_NOTRACE) $(BUILD_TARGETS_TRACE) $(BUILD_TARGETS_TRACE_FST)

$(BUILD_TARGETS_NOTRACE): build/run_%_notrace_0.1/default-verilator/$(TOP_EXECUTABLE_NAME): generated/out/%.sv generated/out/%.sv.log
	rm -f fusesoc.conf
	fusesoc library add run_$*_notrace .
	$(CELLIFT_META_ROOT)/resourcewrapper $(RESOURCEWRAPPER_TAG) $*_notrace synth fusesoc --cores-root=$(CURR_OPENTITAN_ROOT) run --build run_$*_notrace
	cp $<.log $@.log
$(BUILD_TARGETS_TRACE): build/run_%_trace_0.1/default-verilator/$(TOP_EXECUTABLE_NAME): generated/out/%.sv generated/out/%.sv.log
	rm -f fusesoc.conf
	fusesoc library add run_$*_trace .
	$(CELLIFT_META_ROOT)/resourcewrapper $(RESOURCEWRAPPER_TAG) $*_trace synth fusesoc --cores-root=$(CURR_OPENTITAN_ROOT) run --build run_$*_trace
	cp $<.log $@.log
$(BUILD_TARGETS_TRACE_FST): build/run_%_trace_fst_0.1/default-verilator/$(TOP_EXECUTABLE_NAME): generated/out/%.sv generated/out/%.sv.log
	rm -f fusesoc.conf
	fusesoc library add run_$*_trace_fst .
	$(CELLIFT_META_ROOT)/resourcewrapper $(RESOURCEWRAPPER_TAG) $*_trace_fst synth fusesoc --cores-root=$(CURR_OPENTITAN_ROOT) run --build run_$*_trace_fst
	cp $<.log $@.log

#
# Recompile, if only the Verilator C++ testbench has changed
#

RECOMPILE_TARGETS_NOTRACE=$(patsubst %,recompile_%_notrace, $(TARGET_NAMES) $(TARGET_NAMES_NOMEM))
RECOMPILE_TARGETS_TRACE=$(patsubst %,recompile_%_trace, $(TARGET_NAMES) $(TARGET_NAMES_NOMEM))
RECOMPILE_TARGETS_TRACE_FST=$(patsubst %,recompile_%_trace_fst, $(TARGET_NAMES) $(TARGET_NAMES_NOMEM))
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

RERUN_TARGETS_NOTRACE_NOMEM=$(patsubst %,rerun_%_notrace, $(TARGET_NAMES_NOMEM))
RERUN_TARGETS_TRACE_NOMEM=$(patsubst %,rerun_%_trace, $(TARGET_NAMES_NOMEM))
RERUN_TARGETS_TRACE_FST_NOMEM=$(patsubst %,rerun_%_trace_fst, $(TARGET_NAMES_NOMEM))
RERUN_TARGETS_NOMEM = $(RERUN_TARGETS_NOTRACE_NOMEM) $(RERUN_TARGETS_TRACE_NOMEM) $(RERUN_TARGETS_TRACE_FST_NOMEM)

.PHONY: $(RERUN_TARGETS_NOMEM)
$(RERUN_TARGETS_TRACE_NOMEM) $(RERUN_TARGETS_TRACE_FST_NOMEM): | traces
$(RERUN_TARGETS_NOMEM): rerun_%: build/run_%_0.1/
	$</default-verilator/$(TOP_EXECUTABLE_NAME_NOMEM)


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

RUN_TARGETS_NOTRACE_NOMEM=$(patsubst %,run_%_notrace, $(TARGET_NAMES_NOMEM))
RUN_TARGETS_TRACE_NOMEM=$(patsubst %,run_%_trace, $(TARGET_NAMES_NOMEM))
RUN_TARGETS_TRACE_FST_NOMEM=$(patsubst %,run_%_trace_fst, $(TARGET_NAMES_NOMEM))
RUN_TARGETS_NOMEM = $(RUN_TARGETS_NOTRACE_NOMEM) $(RUN_TARGETS_TRACE_NOMEM) $(RUN_TARGETS_TRACE_FST_NOMEM)

$(RUN_TARGETS_TRACE_NOMEM) $(RUN_TARGETS_TRACE_FST_NOMEM): | traces
$(RUN_TARGETS_NOMEM): run_%: ./build/run_%_0.1/default-verilator/$(TOP_EXECUTABLE_NAME_NOMEM)
	cd build/run_$*_0.1/default-verilator && $(CELLIFT_META_ROOT)/resourcewrapper $(RESOURCEWRAPPER_TAG) $* run ./$(TOP_EXECUTABLE_NAME_NOMEM)

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

include $(CELLIFT_DESIGN_PROCESSING_ROOT)/common/modelsim.mk
