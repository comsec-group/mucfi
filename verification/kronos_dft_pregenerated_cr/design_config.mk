
############################### User Configuration ############################

#CONFIG ?= experiment_config.mk

CONFIG_DIR = configurations
CONFIG_ENDING = .mk

# Default config:
CONFIG ?=  print_taint_states
PROVE_CACHE ?= 0
CHECK_ASM ?= 1
DUMP_VCD ?= 0
REPORT_INTERVAL ?= 60
RESTART_PROVES ?= 1
TIME_LIMIT ?= 0
DUMP_RESULT_PER_PROPERTY ?= 0
EXPERIMENT_DIR ?= experiments

CURR_CONFIG_FILE = $(CONFIG)$(CONFIG_ENDING)
ifneq ("$(wildcard $(CONFIG_DIR)/$(CURR_CONFIG_FILE))","")
include $(CONFIG_DIR)/$(CURR_CONFIG_FILE)
endif

## A short human readable appendix to identify the currently tested config
CONFIG_STR =

ifeq ($(VERIFICATION_TOOL),jasper)
RESTORE_LAST_RUN = restore_last_run_jasper
endif

TOOL_CMD = cds_jasper-22.09.001-zr jg $(VERIF_FILE) -proj $(CURRENT_EXPERIMENT_DIR)/jgproject \
          -define experimentDir $(CURRENT_EXPERIMENT_DIR) \
          -define top $(TOP_MODULE) \
					-define designFile $(DESIGN_FILE) \
					-define bindFile $(BIND_FILE) \
          -define propertyModuleFile $(PROPERTY_MODULE_FILE) \
					-define propertiesFile $(PROPERTIES_FILE) \
          -define resetSequenceFile $(RESET_SEQUENCE_FILE) \
          -define taskFile $(TASK_FILE) \
					-define clear $(CLEAR) \
					-define proveCache $(PROVE_CACHE) \
          -define inputAssumptionsFile $(INPUT_ASSUMPTIONS_FILE) \
          -define taintAssumptionsFile $(TAINT_ASSUMPTIONS_FILE) \
          -define declassificationAssumptionsFile $(DECLASSIFICATION_ASSUMPTIONS_FILE) \
					-define declassificationSigsFile $(DECLASSIFICATION_SIGS_FILE) \
					-define pathToCore $(PATH_TO_CORE) \
					-define nonResettableRegsZero $(NON_RESETTABLE_REGS_ZERO) \
					-define configured 0 \
					-define checkAsm $(CHECK_ASM) \
					-define dumpVCD $(DUMP_VCD) \
					-define reportInterval $(REPORT_INTERVAL) \
					-define timeLimit $(TIME_LIMIT) \
					-define restartProves $(RESTART_PROVES) \
					-define dumpResultPerProperty $(DUMP_RESULT_PER_PROPERTY)

###############################################################################