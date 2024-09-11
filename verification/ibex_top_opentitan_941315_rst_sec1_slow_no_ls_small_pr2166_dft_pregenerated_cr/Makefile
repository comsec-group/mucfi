DESIGN_CONFIG_INCLUDE = design_config.mk

ifneq ("$(wildcard $(DESIGN_CONFIG_INCLUDE))","")
    include $(DESIGN_CONFIG_INCLUDE)
endif

DESIGN_DIR?=$(PATH_TO_CELLIFT_FORMAL)/pc_taint_check/ibex_top_opentitan_941315_rst_sec1_slow_no_ls_small_pr2166_dft/
DESIGN_FILE?=$(DESIGN_DIR)/designs/cellift.sv
TOP?=ibex_top
CLOCK_SIGNAL?=clk_i
RESET_SIGNAL?=rst_ni
RESET_POLARITY?=0
ISA_SELECTION?=i,zicsr,zifencei,m
#,b,Smepmp

include ../common/common.mk

mkdirs:
	mkdir -p configurations

setup_ibex: mkdirs
	cd ../common; make setup_design DESIGN_FILE=$(DESIGN_FILE) DESIGN_DIR=$(DESIGN_DIR) TOP=$(TOP) CLOCK_SIGNAL=$(CLOCK_SIGNAL) ISA_SELECTION=$(ISA_SELECTION) RESET_SIGNAL=$(RESET_SIGNAL) RESET_POLARITY=$(RESET_POLARITY); cd -;
