include scarv_config.mk

#default design file and dir
DESIGN_FILE ?= $(PATH_TO_CELLIFT_FORMAL)/pc_taint_check/scarv_clocked_crypto/designs/cellift_scarv_ea668297_clk.sv
DESIGN_DIR ?= $(PATH_TO_CELLIFT_FORMAL)/pc_taint_check/scarv_clocked_crypto/
TOP?=cellift_scarv
CLOCK_SIGNAL?=g_clk
RESET_SIGNAL?=g_resetn
RESET_POLARITY?=0
ISA_SELECTION?=i,m,zicsr,zifencei,crypto
# It can be configured as RV32E, RV32I, RV32IC, RV32IM, or RV32IMC core,

include ../common/common.mk

mkdirs:
	mkdir -p configurations

setup_scarv:
	cd ../common; make setup_design DESIGN_FILE=$(DESIGN_FILE) DESIGN_DIR=$(DESIGN_DIR) TOP=$(TOP) CLOCK_SIGNAL=$(CLOCK_SIGNAL) ISA_SELECTION=$(ISA_SELECTION) RESET_SIGNAL=$(RESET_SIGNAL) RESET_POLARITY=$(RESET_POLARITY); cd -;
