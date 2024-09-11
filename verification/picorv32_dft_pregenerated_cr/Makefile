include ../common/templates/design_config.mk

#default design file and dir
DESIGN_FILE=$(PATH_TO_CELLIFT_FORMAL)/pc_taint_check/picorv32_data_flow_w_compressed/designs/picorv32_cellift_data_flow.sv
DESIGN_DIR=$(PATH_TO_CELLIFT_FORMAL)/pc_taint_check/picorv32_data_flow_w_compressed/
TOP=cellift_data_flow_picorv32
CLOCK_SIGNAL=clk
RESET_SIGNAL=resetn
RESET_POLARITY=0
ISA_SELECTION=i,m,zicsr,zifencei
# It can be configured as RV32E, RV32I, RV32IC, RV32IM, or RV32IMC core,

include ../common/common.mk

setup_design_dir:
	cd ../common; make setup_design DESIGN_FILE=$(DESIGN_FILE) DESIGN_DIR=$(DESIGN_DIR) TOP=$(TOP) CLOCK_SIGNAL=$(CLOCK_SIGNAL) ISA_SELECTION=$(ISA_SELECTION) RESET_SIGNAL=$(RESET_SIGNAL) RESET_POLARITY=$(RESET_POLARITY); cd -;
