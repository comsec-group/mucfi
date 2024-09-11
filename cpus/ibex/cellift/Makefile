# Copyright 2022 Flavien Solt, ETH Zurich.
# Licensed under the General Public License, Version 3.0, see LICENSE for details.
# SPDX-License-Identifier: GPL-3.0-only

ifeq "" "$(CELLIFT_ENV_SOURCED)"
$(error Please re-source the cellift-meta repo's env.sh first, in the meta repo, and run from there, not this repo. See README.md in the meta repo)
endif

ifeq "" "$(CELLIFT_IBEX_SOURCED)"
$(error Please re-source the local env.sh first, here in the same directory.)
endif

OPENTITAN_ROOT ?= ../opentitan
CURR_OPENTITAN_ROOT = $(OPENTITAN_ROOT)

IBEX_REPO_LOCATION ?= ../ibex

#
# 0. Install the Python requirements
#
installrequirements:
# $(CELLIFT_PYTHON_VENV)/bin/pip install -r $(CURR_OPENTITAN_ROOT)/python-requirements.txt
	pip install -r $(CURR_OPENTITAN_ROOT)/python-requirements.txt
	export PATH=~/.local/bin/:$PATH
# installed ./util/get-toolchain.py --install-dir ~/opentitan/tools/tools/riscv
	export TOOLCHAIN_PATH=~/opentitan/tools/riscv/
	export PATH=~/verilator/bin:$PATH
	pip install setuptools


PYTHON ?= python3
RESOURCEWRAPPER_TAG ?= ibex

#### Choose an Ibex version
# The version in which we found bugs
# IBEX_RTL_VERSION = lowrisc_ibex_bug
# This one contains the fix for one of our reported bugs (CVE-2024-28365)
IBEX_RTL_VERSION = lowrisc_ibex_pr2166

LOWRISC_IBEX_LOCATION = $(CURR_OPENTITAN_ROOT)/hw/vendor/$(IBEX_RTL_VERSION)

#### Choose an Ibex top module
# Uncomment one of the below
TOP_MODULE = ibex_top_sec1_rst_slow_no_ls_custom
# TOP_MODULE = ibex_top_sec1_small
####

TOP_SOC = ibex_tiny_soc
TOP_EXECUTABLE_NAME = V$(TOP_SOC)

CONFIGURED_IBEX_TOP_FILE = $(OPENTITAN_ROOT)/hw/vendor/lowrisc_ibex/rtl/$(TOP_MODULE).sv
TMP_IBEX_TOP_FILE = $(OPENTITAN_ROOT)/hw/vendor/lowrisc_ibex/rtl/ibex_top.sv

# The `passthrough` target is useful so that the log matches with the sv on the generated block names, typically for ideal taint experiments.
TARGET_NAMES = vanilla cellift glift passthrough

include $(CELLIFT_DESIGN_PROCESSING_ROOT)/common/design.mk

# This target makes the design until the Yosys instrumentation. From there on, the Makefile can run in parallel for the various instrumentation targets.
before_instrumentation: generated/sv2v_out.v

cleanup_syn:
	rm -rf $(CURR_OPENTITAN_ROOT)/hw/vendor/lowrisc_ibex_pr2166_old/syn
	rm -rf $(CURR_OPENTITAN_ROOT)/hw/vendor/lowrisc_ibex_old/syn

#
# 1. Gather the source code.
#

customize_ibex_top: cleanup_syn # and temporarily rename the rtl directory
	@if [ -e $(CURR_OPENTITAN_ROOT)/hw/vendor/lowrisc_ibex ]; then mv -fT $(CURR_OPENTITAN_ROOT)/hw/vendor/lowrisc_ibex $(CURR_OPENTITAN_ROOT)/hw/vendor/lowrisc_ibex_old ; fi
	rm -rf $(CURR_OPENTITAN_ROOT)/hw/vendor/lowrisc_ibex
	cp -r $(LOWRISC_IBEX_LOCATION) $(CURR_OPENTITAN_ROOT)/hw/vendor/lowrisc_ibex
	cp $(CONFIGURED_IBEX_TOP_FILE) $(TMP_IBEX_TOP_FILE)
	sed -i 's/$(TOP_MODULE)/ibex_top/g' $(TMP_IBEX_TOP_FILE)

generated/scattered/rv_core_ibex.v: | customize_ibex_top generated/sv_sources generated/scattered
	rm -f fusesoc.conf
	fusesoc library add ibex_cellift .
	fusesoc --cores-root=$(CURR_OPENTITAN_ROOT) run --build --target=synth ibex_cellift
	rm -rf generated/sv_sources/*
	find build/ibex_cellift_0.1 -name \*.sv  -exec cp {} generated/sv_sources \;
	find build/ibex_cellift_0.1 -name \*.svh -exec cp {} generated/sv_sources \;

#
# 2. Pickle the source code & apply sv2v.
#

generated/noprefix.v: generated/scattered/rv_core_ibex.v | generated
	rm -f generated/scattered/*.v
	$(PYTHON) scripts/gen_sv2v_out.py
	cat generated/scattered/*.v > $@

# Only for Vanilla
generated/noprefix_nosv2v.sv: generated/scattered/rv_core_ibex.v | generated
	rm -f generated/scattered/*.v
	$(PYTHON) scripts/gen_sv2v_out.py -nosv2v
	cat generated/scattered/*.v > $@

# Only for CellIFT
generated/sv2v_out.v: generated/noprefix.v | generated
# Can't use morty until https://github.com/pulp-platform/morty/issues/51 is fixed
#	morty $< -q -p cellift_ -o generated/beforesv2v.sv -v
	sv2v -E=UnbasedUnsized -D SYNTHESIS -Igenerated/sv_sources $< -w $@
# 	Replace occurrences of wor
	sed -i 's/\bwor\b/logic/g' $@
# Add newline in the end of the file because sv2v does not.
	echo  >> $@
	rm $(TMP_IBEX_TOP_FILE)
	mv -fT $(CURR_OPENTITAN_ROOT)/hw/vendor/lowrisc_ibex $(LOWRISC_IBEX_LOCATION)_old


# Add the cellift_ prefix everywhere.
generated/out/vanilla.sv: generated/noprefix_nosv2v.sv | generated/out
# 	Add prefixes to module names.
# Can't use morty until https://github.com/pulp-platform/morty/issues/61 is fixed
	morty -D SYNTHESIS -I $(CURR_OPENTITAN_ROOT)/hw/ip/prim/rtl \
	-I $(CURR_OPENTITAN_ROOT)/hw/dv/sv/dv_utils \
	-I generated/sv_sources $< -p cellift_ -o $@
#	-I $(LOWRISC_IBEX_LOCATION)/rtl $< -p cellift_ -o $@
	$(PYTHON) $(CELLIFT_PYTHON_COMMON)/remove_modules.py $@ $@ cellift_tlul_assert cellift_tlul_assert_multiple
# 	Replace occurrences of wor
	sed -i 's/\bwor\b/logic/g' $@

generated/out/vanilla.sv.log: | generated/out
	touch $@

generated/out/nosv2v.sv: generated/scattered/rv_core_ibex.v | generated/out
	find generated/sv_sources -type f -name "*.sv" -exec cat {} + > $@

#
# 3. Instrument using Yosys.
#

YOSYS_INSTRUMENTATION_TARGETS_SV=$(patsubst %,generated/out/%.sv, glift passthrough)

$(YOSYS_INSTRUMENTATION_TARGETS_SV): generated/out/%.sv: $(CELLIFT_YS)/instrument.ys.tcl generated/sv2v_out.v | generated/out logs
	DECOMPOSE_MEMORY=1 VERILOG_INPUT=$(word 2,$^) INSTRUMENTATION=$* VERILOG_OUTPUT=$@ TOP_MODULE=$(TOP_MODULE) $(CELLIFT_META_ROOT)/resourcewrapper $(RESOURCEWRAPPER_TAG) $* instr yosys -c $< -l $@.log

# Make CellIFT a special case as we need to make the PC public
generated/cellift_prepublic.sv: $(CELLIFT_YS)/instrument.ys.tcl generated/sv2v_out.v | generated/out logs
	DECOMPOSE_MEMORY=1 VERILOG_INPUT=$(word 2,$^) INSTRUMENTATION=cellift VERILOG_OUTPUT=$@ TOP_MODULE=$(TOP_MODULE) $(CELLIFT_META_ROOT)/resourcewrapper $(RESOURCEWRAPPER_TAG) cellift instr yosys -c $< -l $@.log

generated/out/cellift.sv: generated/cellift_prepublic.sv
	$(PYTHON) $(CELLIFT_PYTHON_COMMON)/make_pc_taint_public.py $< $@ pc_id_t0 pc_id
	$(PYTHON) $(CELLIFT_PYTHON_COMMON)/add_sim_initbegin.py $@ $@
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
IBEX_CONFIG ?= opentitan
FUSESOC_CONFIG_OPTS = $(shell ./util/ibex_config.py $(IBEX_CONFIG) fusesoc_opts)

BUILD_TARGETS_NOTRACE=$(patsubst %,build/run_%_notrace_0.1/default-verilator/$(TOP_EXECUTABLE_NAME), $(TARGET_NAMES))
BUILD_TARGETS_TRACE=$(patsubst %,build/run_%_trace_0.1/default-verilator/$(TOP_EXECUTABLE_NAME), $(TARGET_NAMES))
BUILD_TARGETS_TRACE_FST=$(patsubst %,build/run_%_trace_fst_0.1/default-verilator/$(TOP_EXECUTABLE_NAME), $(TARGET_NAMES))
BUILD_TARGETS = $(BUILD_TARGETS_NOTRACE) $(BUILD_TARGETS_TRACE) $(BUILD_TARGETS_TRACE_FST)

$(BUILD_TARGETS_NOTRACE): build/run_%_notrace_0.1/default-verilator/$(TOP_EXECUTABLE_NAME): generated/out/%.sv generated/out/%.sv.log
	rm -f fusesoc.conf
	fusesoc library add run_$*_notrace .
	$(CELLIFT_META_ROOT)/resourcewrapper $(RESOURCEWRAPPER_TAG) $*_notrace synth fusesoc --cores-root=$(CURR_OPENTITAN_ROOT) run --setup --build run_$*_notrace $(FUSESOC_CONFIG_OPTS)
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

# Generate the absolute path of the Modelsim build script
CELLIFT_DIR := ${shell dirname ${shell pwd}}/cellift
MODELSIM_PATH_TO_BUILD_TCL = $(CELLIFT_DIR)/scripts/modelsim/modelsim_build.tcl

include $(CELLIFT_DESIGN_PROCESSING_ROOT)/common/modelsim.mk
