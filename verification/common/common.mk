
# Copyright 2024 Katharina Ceesay-Seitz, ETH Zurich.
# Licensed under the General Public License, Version 3.0, see LICENSE for details.
# SPDX-License-Identifier: GPL-3.0-only
# This file is supposed to be included after including a designname_config.mk file

# Include local configuration containing things like paths to other tools.
include ../common/local_config.mk

ifneq ("$(wildcard $(DESIGN_CONFIG))","")
include $(DESIGN_CONFIG)
endif

CURRENT_TIME = $(shell date +%Y%m%d_%H%M_%S)
CURRENT_EXPERIMENT_DIR = $(EXPERIMENT_DIR)/$(CURRENT_TIME)_$(TOP)$(CONFIG_STR)

TOOL_RUN_CMD_FLAG = -batch
PYTHON ?= python3

all: help
help: print_help

run_cmd: IS_CMD := 1
run_cmd: TOOL_CMD := $(TOOL_CMD) $(TOOL_RUN_CMD_FLAG)
run_cmd: run

run_gui: IS_CMD := 0
run_gui: run

IS_CMD = 0

run:
	mkdir -p $(EXPERIMENT_DIR)
	mkdir $(CURRENT_EXPERIMENT_DIR)
	cp $(CONFIG_DIR)/$(CURR_CONFIG_FILE) $(CURRENT_EXPERIMENT_DIR)
	cp formal/assumptions/$(TOP_MODULE)_di_asm.sv $(CURRENT_EXPERIMENT_DIR)
	git log -1 > $(CURRENT_EXPERIMENT_DIR)/git_commit.txt
	$(TOOL_CMD) -define isCmd $(IS_CMD)

CMD_FLAG =
START_RUN = 0

restore_run: $(EXPERIMENT_DIR_TO_RESTORE) $(CMD_FLAG)
	echo $(CMD_FLAG)
	cds_jasper jg ../common/formal/scripts/launchers/restore_run.tcl -define experimentDir $(EXPERIMENT_DIR_TO_RESTORE) -proj $(EXPERIMENT_DIR_TO_RESTORE)/jgproject $(CMD_FLAG) -define startRun $(START_RUN)

restore_cmd: CMD_FLAG := $(TOOL_RUN_CMD_FLAG)
restore_cmd: restore_run

restore_cmd_restart: START_RUN := 1
restore_cmd_restart: restore_cmd

print_design_statistics:
	cds_jasper jg ../common/formal/scripts/print_design_statistics.tcl -batch -define designFile $(DESIGN_FILE) -define top $(TOP) > design_stats_instrumented.txt
	cds_jasper jg ../common/formal/scripts/print_design_statistics.tcl -batch -define designFile $(DESIGN_FILE_VANILLA) -define top $(TOP) > design_stats_vanilla.txt

REPORT_FILE := jasper_report_final.txt
summarize_report_final: summarize_report

REPORT_FILE := jasper_report.txt
summarize_report: $(EXPERIMENT_DIR)
	python3 ../../automation/mucfi/report_analysis/report_analysis.py \
  --report_file=$(EXPERIMENT_DIR)/reports/$(REPORT_FILE) \
  --results_file_name=results \
	--out_dir=$(EXPERIMENT_DIR) \
  --result_to_csv=True \
  --csvs_to_result_latex_table=True \
  --csvs_to_time_latex_table=True > $(EXPERIMENT_DIR)/summary.txt
	cat $(EXPERIMENT_DIR)/jgproject/jg.log | grep "peak resident set memory" >> $(EXPERIMENT_DIR)/summary.txt

gen_taint_conditions:
	python3 ../../automation/mucfi/gen_taint_cond/mucfi_generate_taint_conditions.py --config_file $(DESIGN_CONFIG) --taint_tracking_method $(TAINT_TRACKING_METHOD)

setup_design: | gen_taint_conditions setup_formal

# For testing individual steps:
# setup_design: gen_taint_conditions
# setup_design: setup_formal

setup_formal:
	$(PYTHON) $(PATH_TO_PY_SCRIPTS)/mucfi/create_operand_file.py --config_file $(DESIGN_CONFIG) --operand_file_template $(OPERAND_FILE_TEMPLATE)
	$(PYTHON) $(PATH_TO_PY_SCRIPTS)/fpv_core_setup/fpv_core_setup.py --design_file $(DESIGN_FILE) --top_module $(TOP) --outdir $(OUT_DIR) --gen_bind_and_mod=True --regen_design_hier=True --gen_reset_seq=True --rst_sig=$(RESET_SIGNAL) --rst_polarity=$(RESET_POLARITY) --gen_input_no_taint_asm=True --target_tool=jasper
	cp templates/design_config.mk $(OUT_DIR)/design_config.mk
	mkdir -p $(OUT_DIR)/configurations
	cp templates/print_taint_states.mk $(OUT_DIR)/configurations/print_taint_states.mk
	echo '`include "formal/assumptions/$(TOP)_di_asm.sv"' > $(OUT_DIR)/formal/assumptions/$(TOP)_i_asm.sv
	echo '`include "formal/assumptions/$(TOP)_ti_asm.sv"' >> $(OUT_DIR)/formal/assumptions/$(TOP)_i_asm.sv
	touch $(OUT_DIR)/formal/assumptions/$(TOP)_di_asm.sv
	touch $(OUT_DIR)/formal/assumptions/$(TOP)_pc_taint_asm.sv
	mkdir -p $(OUT_DIR)/formal/scripts
	mkdir -p $(OUT_DIR)/formal/scripts/tasks
	$(PYTHON) $(PATH_TO_PY_SCRIPTS)/mucfi/create_declassification_files.py --config_file $(DESIGN_CONFIG)
	echo "clock $(CLOCK_SIGNAL)" > $(OUT_DIR)/formal/scripts/clock.tcl
	touch $(OUT_DIR)/formal/scripts/tasks/$(TOP)_symb_init_no_taint.tcl
	mkdir -p $(OUT_DIR)/formal/properties/taint_conditions
	$(JASPER_SERVER) "cd $(OUT_DIR); DESIGN_CONFIG=$(DESIGN_CONFIG) make run_cmd CONFIG=print_taint_states DESIGN_FILE=$(DESIGN_FILE) TOP=$(TOP)"
	$(PYTHON) $(PATH_TO_PY_SCRIPTS)/fpv_core_setup/fpv_core_setup.py --design_file $(DESIGN_FILE) --top_module $(TOP) --outdir $(OUT_DIR) --gen_symb_init=True --gen_taint_propagation_checker=True --target_tool=jasper --path_to_core=$(OUT_DIR) --gen_bind_and_mod=True
	cp templates/design_ct_to.mk $(OUT_DIR)/configurations/$(TOP)_ct_to.mk
	cp templates/design_ct_to_no_taint_states.mk $(OUT_DIR)/configurations/$(TOP)_ct_to_no_taint_states.mk
	$(PYTHON) $(PATH_TO_PY_SCRIPTS)/mucfi/gen_checker_inst.py  --isa_selection=$(ISA_SELECTION) --operand_assignments_file $(OUT_DIR)/formal/signal_defs/operand_assignments_first.sv --bind_file $(OUT_DIR)/formal/bind/$(TOP)_bind.sv --task_creation_dir $(OUT_DIR)/formal/scripts/tasks/

print_help:
	@echo ""
	@echo "Usage: make [target] CONFIG=your_config"
	@echo ""
	@echo "If your verification environement configuration file is called my_config.mk,"
	@echo "Example to run the tool: make run CONFIG=my_config"
	@echo "Configuration files need to be stored in ./configurations"
	@echo ""
	@echo "Available make targets - to be executed in the directory of a design:"
	@echo ""
	@echo "run/run_gui              ... Run the formal tool in GUI mode"
	@echo "run_cmd                  ... Run the formal tool in command line mode"
	@echo "restore_run EXPERIMENT_DIR_TO_RESTORE=experiments/<experiment_dir>. E.g.: make restore_run EXPERIMENT_DIR_TO_RESTORE=experiments/20240828_1355_35_cellift_picorv32"
	@echo "                                                             ... Restores the run in experiment_dir and runs it in GUI mode"
	@echo "restore_cmd EXPERIMENT_DIR_TO_RESTORE=experiments/<experiment_dir>. ... Restores the run in cmd mode, but does not continue running the proofs"
	@echo "restore_cmd_restart EXPERIMENT_DIR_TO_RESTORE=experiments/<experiment_dir> ... Restores the run in experiment_dir and runs it in batch mode"
	@echo "EXPERIMENT_DIR_TO_RESTORE=<your_dir> restore_run		... Restore the last run of the formal tool"
	@echo ""
	@echo "setup_design             ... Creates the setup for a new design."
	@echo "summarize_report	EXPERIMENT_DIR=experiments/<experiment_dir>	... Summarizes the latest report of run."
	@echo "summarize_report_final	EXPERIMENT_DIR=experiments/<experiment_dir>	... Summarizes the final report of a run."
	@echo "gen_taint_conditions     ... Generates the taint conditions for the design."
	@echo "print_design_statistics  ... Prints the design statistics of the design."