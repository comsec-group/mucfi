# Copyright 2024 Katharina Ceesay-Seitz, ETH Zurich.
# Licensed under the General Public License, Version 3.0, see LICENSE for details.
# SPDX-License-Identifier: GPL-3.0-only

CC = gcc

yosys:
# Build Yosys
	make -C mucfi_yosys config-$(CC)
	make -C mucfi_yosys -j$(shell nproc)

clean_yosys:
	rm -rf mucfi_yosys/abc
	make -C mucfi_yosys clean


all: yosys


clean: clean_yosys

copy_makefile:
	mkdir -p $(OUT_DIR)
	cp verification/common/templates/Makefile $(OUT_DIR)/Makefile

generate_verification_setup: copy_makefile
	sed -i 's|MUCFI_PATH|$(shell pwd)|g' $(DESIGN_CONFIG)
	DESIGN_CONFIG=$(DESIGN_CONFIG) make -C $(OUT_DIR) setup_verif_dir

####################################################################################################

### Make targets for the individual designs (can serve as example for new designs).

####################################################################################################

# Kronos

####################################################################################################

# Kronos: Prepare the sources
# bash -c "source /cellift-meta/env.sh && cd ./cpus/kronos/cellift/ && make generated/sv2v_out.v"

# Kronos IFT
kronos_ift: OUT_DIR = verification/kronos_ift
kronos_ift: DESIGN_CONFIG := $(shell pwd)/inputs/kronos/kronos_config_ift.mk
kronos_ift: generate_verification_setup

# Kronos DFT
kronos_dft: OUT_DIR = verification/kronos_dft
kronos_dft: DESIGN_CONFIG := $(shell pwd)/inputs/kronos/kronos_config_dft.mk
kronos_dft: generate_verification_setup
####################################################################################################

# Scarv

####################################################################################################

# Scarv: Prepare the sources
# bash -c "source /cellift-meta/env.sh && cd ./cpus/Scarv/cellift/ && make generated/sv2v_out.v"

# Scarv IFT
scarv_ift: OUT_DIR = verification/scarv_ift
scarv_ift: DESIGN_CONFIG := $(shell pwd)/inputs/scarv/scarv_config_ift.mk
scarv_ift: generate_verification_setup

# Scarv DFT
scarv_dft: OUT_DIR = verification/scarv_dft
scarv_dft: DESIGN_CONFIG := $(shell pwd)/inputs/scarv/scarv_config_dft.mk
scarv_dft: generate_verification_setup
####################################################################################################

####################################################################################################

# picorv32: Prepare the sources

# picorv32_prep:
# bash -c "source /cellift-meta/env.sh && make -C ./cpus/picorv32/cellift/ generated/sv2v_out.v"

# picorv32 IFT
picorv32_ift: OUT_DIR = verification/picorv32_ift
picorv32_ift: DESIGN_CONFIG := $(shell pwd)/inputs/picorv32/picorv32_config_ift.mk
picorv32_ift: generate_verification_setup

# picorv32 DFT
picorv32_dft: OUT_DIR = verification/picorv32_dft
picorv32_dft: DESIGN_CONFIG := $(shell pwd)/inputs/picorv32/picorv32_config_dft.mk
picorv32_dft: generate_verification_setup
####################################################################################################

####################################################################################################
# ibex_custom: Prepare the sources

# ibex_custom_prep:
# bash -c "source /cellift-meta/env.sh && cd ./cpus/ibex/cellift/ && source env.sh && make generated/sv2v_out.v"

# ibex_custom IFT
ibex_custom_ift: OUT_DIR = verification/ibex_top_opentitan_941315_rst_sec1_slow_no_ls_ift
ibex_custom_ift: DESIGN_CONFIG := $(shell pwd)/inputs/ibex/ibex_custom_config_ift.mk
ibex_custom_ift: generate_verification_setup

# ibex_custom DFT
ibex_custom_dft: OUT_DIR = verification/ibex_top_opentitan_941315_rst_sec1_slow_no_ls_dft
ibex_custom_dft: DESIGN_CONFIG := $(shell pwd)/inputs/ibex/ibex_custom_config_dft.mk
ibex_custom_dft: generate_verification_setup
####################################################################################################