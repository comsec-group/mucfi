ifneq ("$(wildcard $(DESIGN_CONFIG))","")
include $(DESIGN_CONFIG)
endif

DESIGN_FILE=$(OUT_DIR)/designs/cell$(TAINT_TRACKING_METHOD).v

include ../common/templates/design_config.mk

include ../common/common.mk

setup_verif_dir:
	cd ../common; DESIGN_CONFIG=$(DESIGN_CONFIG) make setup_design DESIGN_FILE=$(DESIGN_FILE) TOP=$(TOP_MODULE) CLOCK_SIGNAL=$(CLOCK_SIGNAL) ISA_SELECTION=$(ISA_SELECTION) RESET_SIGNAL=$(RESET_SIGNAL) RESET_POLARITY=$(RESET_POLARITY); cd -;