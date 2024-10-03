# 𝜇CFI - Formal Verification of Microarchitectural Control-flow Integrity

Welcome to the 𝜇CFI - Microarchitectural Control-flow Integrity - project.
𝜇CFI verifies whether instructions leak information about their operand data via timing side-channels, also known as constant time violation.
𝜇CFI further verfies whether instructions are manipulating the architectural control flow in a data-dependent way. Take a look at the paper [here](https://comsec.ethz.ch/wp-content/files/mucfi_ccs24.pdf).

This repository contains the Yosys passes and formal properties for verifying 𝜇CFI.
We also provide verification setup generation scripts and templates, as well as copies of the RISC-V CPUs that were verified to reproduce the results of our paper:

𝜇CFI - Formal Verification of Microarchitectural Control-flow Integrity.

Feel free to you re-use any part of our toolchain.
Please cite as:
```
@inproceedings{2024_ceesay-seitz_mucfi,
title="{𝜇}CFI: Formal Verification of Microarchitectural Control-flow Integrity",
author="Ceesay-Seitz, Katharina and Solt, Flavien and Razavi, Kaveh",
booktitle = {Proceedings of the 2024 ACM SIGSAC Conference on Computer and Communications Security},
year = {2024},
publisher = {Association for Computing Machinery},
address = {New York, NY, USA},
doi = {10.1145/3658644.3690344},
url = {https://doi.org/10.1145/3658644.3690344},
location = {Salt Lake City, UT, USA},
series = {CCS '24},
keywords = {Hardware security; formal hardware verification; side-channels}
}
```

# Artifact reproduction

## Setup

### Dependencies

#### Yosys
First, install the following dependencies:

For example on Ubuntu Linux 22.04.4 LTS the following commands will install all
prerequisites for building yosys and running our Python scripts:

	$ sudo apt-get install build-essential clang bison flex \
		libreadline-dev gawk tcl-dev libffi-dev git \
		graphviz xdot pkg-config python3.9 libboost-system-dev \
		libboost-python-dev libboost-filesystem-dev zlib1g-dev

#### Collecting CPU sources
Our verification setup generation flow expects a single Verilog source file where all the sources of the CPU are collected (e.g. cpus/<design_name>/cellift/generated/sv2v_out.v).
The easiest way to reproduce our results is to use the sv2v_out.v file from a pregenerated directory. In that case you do not need to install cellift-meta tools.

##### Instrumenting your own CPU
If you also want to generate this file (e.g., for verifying another CPU), install cellift-meta, following the instructions in `https://github.com/comsec-group/cellift-meta`.

Alternatively, for only installing the minimum necessary tools, replicate the instructions in our Dockerfile, section 'CellIFT meta and tools'. The docker file expects that mucfi directory is placed next to it and certain sub-directories are zipped.

If you use the original cellift-meta, we need to make some modifications in cellift-meta:
- Make sure that the cellift setup uses our Yosys version mucfi_yosys. Our version has a small modification in the Veriolog backend (write_verilog), that prints some needed information about taint states.
- In cellift-meta/design-processing/common/yosys/instrument.ys.tcl, replace the "yosys write_verilog ..." command with this one: "yosys write_verilog -sv -attr2comment $VERILOG_OUTPUT". This adds comments to the output Verilog file with information about module names and taint states.
- For CellDFT, you need to pass the -data-flow flag to the cellift Yosys command.

### Building from source
First, our Yosys version needs to be compiled (type `make yosys` in directory 'mucfi').

### Local configuration
Adapt the paths in verification/common/local_config.mk.

## Steps to reproduce the artifacts

There are two main parts to reproduce.
1. The formal setup generation, including taint condition generation.
2. Formal verification, which requires Jasper Gold (or any other formal property verification tool that can proof SystemVerilog Assertions).

### Preparation
First, we need to prepare the design sources in a format as the CellIFT Yosys pass supports, ie. we need to translate it to Verilog.
Enter a design directory, e.g. cpus/kronos/cellift.
Source `env.sh` in cellift-meta, then source `env.sh` in cpus/kronos/cellift (if it exists). Then run `make generated/sv2v_out.v`.

#### Ibex
For Ibex, you can choose between the version with or without the fix for our CVE-2024-28365 by selecting the LOWRISC_IBEX_LOCATION in cpus/ibex/cellift/Makefile.
You can further choose between different configurations by creating (or using) a specific configuration in e.g. cpus/ibex/opentitan/hw/vendor/lowrisc_ibex/rtl/ibex_top_opentitan_rst_slow_no_ls.sv and choosing TOP_MODULE ?= ibex_top_sec1_rst_slow_no_ls_custom in in cpus/ibex/cellift/Makefile.

## Experiment 1 and 2

We describe both experiments in the following. They are executed by a single make target. E.g. for the Kronos CPU with CellIFT instrumentation: `make kronos_ift` or `make kronos_dft`.
Examples are provided in Makefile.
Please use Kronos for the reproduction.
(The setup generation for the other CPUs should work, but there might be still some scripting errors here or there, we will improve them in the maintained github repo.)

### Experiment 1:
In Section 5.2 and 6.4 we describe how to declassify legal information flows. This involves abstracting the select signal of forwarding multiplexer.
This experiment is invoked by the make target `
1. automatically finds the forwarding multiplexers (based on the design and the definition of the following signals (in inputs/<design_name>_config.mk): forwarding outputs, register read signals),
2. stores the forwarding multiplexer select signals back into the config file
4. generates the declassification file for signal abstraction in the formal setup

#### Expected generated files:

- "FWD_MUX_SELECTS" added to inputs/<design_name>_config.mk
- verification/<design_name>/formal/scripts/declass.tcl (containing the mux selects)
- verification/<design_name>/formal/properties/taint_conditions

Note that the taint conditions may differ if the Yosys opt pass is called at different times (or not at all).

REPRODUCTION INSTRUCTIONS: delete the expected generated files
and run: `make <design>_ift` (see Makefile for the examples for all 4 CPUs studied in the paper and for the dft version).

#### Finding the forwarding multiplexer select signals
A Python script first instruments the design with the existing Yosys pass CellIFT or our newly developed option CellDFT (CellIFT with -data-flow option, sources located in mucfi_yosys/cellift).
Then it calls our Yosys pass 'find_fwd_mux_selects'.
This pass takes as input the forwarding outputs, declassified signals (register read signals, register write signal) and the PC signal.
It searches for potential forwarding multiplexers, and outputs their select signals if the declassification precondition is fulfilled.
It also indicates whether there are additional forwarding multiplexers before the


####  Forwarding multiplexers found between the register file and the register read signals:
If there are forwarding multiplexers found between the register file and the register reading signal, then the FORWARDING_INPUT_BEFORE_REGREAD config must be set and the experiment needs to be rerun (so that these additional forwarding inputs are considered in the taint conditions, as described in the last paragraph of section 6).

##### Kronos
We add the additional forwarding input "u_if.u_rf.regwr_data".

##### Scarv
In Scarv additional forwarding multiplexer selects are found: \hzd_rs3_s*. Since our setup does not include instructions that read from rs3 (some non-standard crypto instructions), we do not add rs3_data as additional input. The path outgoing of forwarding outputs and going through \hzd_rs3_s* leads into the register file. That's why the precondition check is satisified. Since register readings signals for rs1/rs2 are not reading from the multiplexers with \hzd_rs3_s*, there are no additional forwarding inputs that need to be considered in the taint condition, so we leave the FORWARDING_INPUT_BEFORE_REGREAD field empty.
As a check: If we add i_pipeline.i_gprs.rs3_data as additional input to the REGISTER_READ_SIGNALS, hzd_rs3_s4 is one of the multiplexer selects discovered for abstraction.

#### Taint condition generation

Next, the Python script calls our 'update_condition' Yosys pass several times to generate the taint conditions.

If the update condition Yosys pass is called with a signal-name that cannot be found in the design, then either the name was spelled wrong, or the signal was optimized out. In the latter case, the udpate condition is 1, indicating that the signal is continuously assigned. This is expected for the following CPUs: Scarv.
Our tool flow prints this warning, to let the user check for unintentional typos in the signal name:
WARNING: Since REG_ADDR "\\i_pipeline.i_pipeline_s1_decode.dec_rs1_32 " is not found in the design, the instruction word sampling condition is set to 1. Please make sure that there was no typo in the REG_ADDR signal name!!

### Experiment 2:
Generate the formal verification setup.
In section 7 we claim that only a few signal names are need to be manually extracted from the design. This experiment generates the remaining files of the formal verification setup, that e.g. instantiate the generic formal properties and connect them to the design (as described in section 6). This setup makes use of the generic taint condition assumptions described in section 6.

REPRODUCTION INSTRUCTIONS:
- Create a config file for a CPU (find examples for the studied CPUs in inputs/<design>/<design_name>_config*.mk)
- Enter signal names and further configurations like file paths into the config file.

#### Expected generated files:

(dv_dir stands for 'design specific verification directory', configured with key 'OUT_DIR')
mucfi/verification/<dv_dir>, containing:
- assumptions:
-- Since we verify unconstrained environments and instruction sequences, there are no design input assumptions (<design>_di_asm.sv)
-- assumptions ensuring that there is no taint on inputs (<design>_ti_asm.sv)
- SystemVerilog bind statement providing access to all internal signals
- Scripts that create verification tasks (using the common files)
-'no taint in state signals' assertions () mentioned in section 7, which are used as invariants to speed up verification in some cases)

The directories in verification/<design_version>_pregenerated are the output of the scripts in this repository. The ones ending in _cr were generated for the camera ready version of the paper with an earlier version of scripts.

#### Reproduction without access to Jasper
In verification/common/common.mk comment out the following two lines:
```
$(JASPER_SERVER) "cd $(OUT_DIR); DESIGN_CONFIG=$(DESIGN_CONFIG) make run_cmd CONFIG=print_taint_states DESIGN_FILE=$(DESIGN_FILE) TOP=$(TOP)"
$(PYTHON) $(PATH_TO_PY_SCRIPTS)/fpv_core_setup/fpv_core_setup.py --design_file $(DESIGN_FILE) --top_module $(TOP) --outdir $(OUT_DIR) --gen_symb_init=True --gen_taint_propagation_checker=True --target_tool=jasper --path_to_core=$(OUT_DIR) --gen_bind_and_mod=True
```

### Experiment 3:
For this experiment you can either use your generated formal verification setup from the previous experiments, or you use the pregenerated ones that we provide in verification/<design_name>_pregenerated.

We verify once with CellIFT instrumentation, and once with CellDFT instrumentations. Both need to be generated in their own directories.

There remains one manual step (that could be automated as well):
Create the property file based on the templates used by the pregenerated setups. E.g. copy verification/kronos_ift_pregenerated/formal/properties/kronos_core_ct_instr_all.sv to another CPU and adapt the signal names (ie. copy them over from the <design>_config.mk file). We provide this property file per CPU in the pregenrated verification directories (e.g. verification/kronos_ift_pregenerated).

Start a formal verification run as follows in e.g. `./verification/kronos_ift`:

`DESIGN_CONFIG=../../inputs/kronos/kronos_config_ift.mk make run CONFIG=kronos_core_ct_to_no_taint_states &`

Replace 'ift' with 'dft' for the CellDFT version.

Or e.g. in `./verification/ibex_top_opentitan_941315_rst_sec1_slow_no_ls_ift_pregenerated`:
`DESIGN_CONFIG=../../inputs/ibex/ibex_custom_config_ift.mk make run CONFIG=ibex_top_ct_to_no_taint_states &`

This experiment can be evaluted with the Jasper Gold specific tcl scripts uploaded during the artifact evaluation. Please place them into verification/common/formal/scripts.

Cadence licenses do not allow us to publish tool commands. Therefore, for reproduction by the public, we created a mock directory in verification/common/formal/scripts_public (instead of ....formal/scripts), where Jasper tool commands are replaced with YOUR_FORMAL_TOOL_CMD, together with a description of what action should be performed at this step. This allows also to use another formal verification tool by replacing YOUR_FORMAL_TOOL_CMD with similar commands of another formal tool.

Within Jasper, start a proof on a task (there is one per instruction and operand) and look for the main property, e.g.
`t_compare_taint_start_time_pc_taint_checker_to_anytime_no_taint_states_XOR_op2_declassify::kronos_core.kronos_core_fpv_bind.chk_pc_taint_checker_to_anytime_no_taint_states_XOR_op2.as_no_pc_taint_ever`.

#### Experiment 3.1 - Kronos
Kronos has 3 subexperiments: We verified Kronos with 3 different set of input assumtions (see verification/kronos_ift_pregenerated/assumptions/kronos_core_di_asm.sv).
Change the input assumptions and rerun to obtain the results desribed in section 7.

#### Experiment 3.2 - Scarv
Scarv additionally implements cryptographic instructions, which can be verified in clocked and non-clocked version. Note, that it might take over 24 hours to obtain results for all instructions (depends on how many cores your testbed has, and how much parallelisation your model checker supports/how you configure Jasper Gold FPV app)

#### Experiment 3.3 - Ibex
In Ibex we verified several different configurations. They can be chosen by choosing a specific 'ibex_top' file.
In [`Ibex Makefile`](cpus/ibex/cellift/Makefile) select a certain top module by changing `TOP_MODULE ?= ibex_top_sec1_rst_slow_no_ls_custom`. `LOWRISC_IBEX_LOCATION` can be changed to either use the version in which we found the bugs, or the version with cherry-picked fix for Pull Request (PR) 2166.
The results shown in Table 5 of the paper were produced with the top level configuration in `./cpus/ibex/opentitan/hw/vendor/lowrisc_ibex/rtl/ibex_top_sec1_rst_slow_no_ls_custom.sv` (use `TOP_MODULE ?= ibex_top_sec1_rst_slow_no_ls_custom`).

The setup automation adds the forwarding multiplexer select signals with their internal Yosys generated names to verification/ibex_top_opentitan_941315_rst_sec1_slow_no_ls_ift/formal/scripts/declass.tcl. These need to be manually replaced with the corresponding signals in the instrumented design, e.g., ./verification/ibex_top_opentitan_941315_rst_sec1_slow_no_ls_ift/designs/cellift.v. The signals are marked with the attribute FORMAL_ABSTRACT.

For Ibes non-secure versions, remove the data independent timing mode flag from the taint start condition in formal/properties/ibex_top_<config>_ct_instr_all.sv.

#### Experiment 3.4 - PicoRV32
This is the only CPU without forwarding paths. Therefore, our Yosys pass `find_fwd_mux_selects` should not be used.


## Reproducing for a new CPU
1. Create inputs/new_cpu/new_cpu_config.mk
2. Generate the sv2v_out.v file generated by the CellIFT setup
3. Copy a make target from the existing CPUs (e.g. kronos_ift in Makefile) and run.
4. Copy an example property instantiation file, e.g. /verification/scarv_ift_pregenerated/formal/properties/cellift_kronos_ct_instr_all.sv and adapt if necessary: You need to provide the clock and reset signal and adapt the instruction word sampling. It needs to be sampled in the same clock cycle in which the CPU reads the address from it. Therefore, if the generated gen_instr_word_sampling_cond (in e.g., /verification/kronos_ift_pregenerated/formal/properties/taint_conditions/) starts with $past, the instruction word signal also has to be sampled one clock cycle in the past (see Kronos or PicoRV32).

### Design configurations
REGISTER_READ_SIGNALS need to be supplied in ascending operand order: first the read signal for rs1 (operand 1) of an instruction.

REGISTER_WRITE_SIGNALS are the output ports through which the instruction result is written back to the register file.

REGISTER_FILE is the actual state element that stores the register values.

REGISTER_RS1 is a reference to the first element in the register file (do not use the 0th element, as this is the special RISC-V zero register). This is needed, because we use the Yosys memory pass to decompose memories (e.g. the register file) into individual registers. (This may be automated)

REG_ADDR is the signal that extracts the registre address from the instruction word.

INSTR_WORD should be the instruction word signal from which the register address is taken that is then used to access the register.

FORWARDING_INPUT_BEFORE_REGREAD may be empty initially (depends if you know the CPU). The find_fwd_mux_selects pass indicates whether you need to look for additional forwarding inputs. If this field is kept empty, no update condition for additional forwarding inputs will be generated.

FORWARDING_OUTPUTS="i_pipeline.gpr_wdata,i_pipeline.fwd_s3_wdata,i_pipeline.fwd_s2_wdata,i_pipeline.gpr_wdata_hi,i_pipeline.fwd_s3_wdata_hi,i_pipeline.fwd_s2_wdata_hi"

PC_SIGNAL should be the PC of the execution stage, ie. the PC signal that is used by the auipc instruction to read the PC. The reasoning behind this, is that any instruction sequence can be extended by an auipc instruction and thus if an instruction influences the microarchitectural control flow, it will always influence this PC.

ISA_SELECTION: select any of 'i,m,zicsr,zifencei,crypto'

TOP_MODULE is the top module of the CPU under test.

DESIGN_DIR is the path to a directory of a CPU. It should contain cellift/generated/sv2v_out.sv. This file is generated by the CellIFT toolchain. We have pregenerated the files for the studied CPUs.

YOSYS_DIR=./mucfi_yosys/

PATH_TO_PY_SCRIPTS=./automation

OUT_DIR is where the verification setup will be located. This is where you run the formal tool.

TAINT_TRACKING_METHOD: 'ift' or 'dft'

CONFIG_FILE is the path to this file

FWD_MUX_SELECTS will be filled by the Yosys pass find_fwd_mux_selects.


## FAQ

### Do I need a specific formal verification tool to prove 𝜇CFI?
Our works with any formal verification tool that can prove SystemVerilog Assertions. You only need to adapt tool-specific commands (replace the placeholder YOUR_FORMAL_TOOL_CMD in the scripts in verification/common/formal/scripts). Using open-source tools like SymbiYosys requires you to translate the main 𝜇CFI property into an immediate assertion.

To use the setup with Yosys, you would need to translate the concurrent SVA assertions into immediate ones.

### Setup troubleshooting

Here we collect a list of errors that you might encounter when regenerating the setup for a new CPU.

#### ssh: Could not resolve hostname your-server-with-jasper-installed: Name or service not known
Configure your server with the formal tool in verification/common/local_config.mk. If you only want to run the Yosys passes, see 'Reproduction without access to Jasper' above for which lines to comment out in verification/common.mk

#### ERROR: The file "MUCFI_PATH/verification/kronos_dft/designs/celldft.v" does not exist.
Make sure that MUCFI_PATH in the inputs/ configuration files is replaced with the actual absolut path where you cloned mucfi.

#### ERROR: Unable to find signal "kronos_core_fpv_bind.chk_pc_taint_checker_to_anytime_no_taint_states_SLTI_op1.taint_active".
Probably the main property file (<top_module>_ct_instr_all.sv is empty, or at least it does not include the checker definitions file. For an example see `mucfi/verification/kronos_dft_pregenerated/formal/properties/kronos_core_ct_instr_all.sv`

#### ERROR: Found control character or space (0x20) in string '\\\gen_regfile_ff.register_file_i ' which is not allowed in RTLIL identifiers
The find_fwd_mux_selects Yosys pass needs escaped signal names, while the update_condition pass flattens the designs and therefore usually the signal names are escaped names (starting with a backslash) and contain the whole pass. This can be sometimes simply solved by removing spaces from the names, like {regrd.replace(" ","")} in gen_uc_rs() in automation/mucfi/gen_taint_cond/mucfi_generate_taint_conditions.py. If not, we might have to have separate configs per pass, or write a translation function. Of course you could also write the Yosys scripts manually based on the templates in automation/mucfi/gen_taint_cond/yosys_templates.

#### ERROR: Can't open input file `mucfi/verification/scarv_ift/designs/cellift.v'
Likely, there was an error before when executing ../../automation/mucfi/gen_taint_cond/mucfi_generate_taint_conditions.py. Check the log that it produced. E.g. verification/scarv_ift/yosys_passes/cellift_find_fwd_mux.log

#### ERROR in Yosys pass: a signal name was not found
This is expected in some cases if the signal was optimized out (see experiment description).

#### ERROR in Jasper: formal/bind/core_fpv.sv(nr): syntax error near '/'
Likely, there was a special character within a signal name that is not yet in the list of special characters in function 'flatten_name' in automation/common/util_hier_paths.py.

#### ERROR in Jasper: Unable to find signal "a declassified forwaring mux select with Yosys generated name, e.g.,"u_ibex_core.id_stage_i.and$MUCFI_PATH/cpus/ibex/cellift/generated/sv2v_out.v:17741$922_Y".
We write out the instrumented design with Yosys option -norename. The update condition reconstruction Python script expects this format. Please search for signals with the attribute FORMAL_ABSTRACT in the instrumented design, e.g., MUCFI_PATH/verification/ibex_top_opentitan_941315_rst_sec1_slow_no_ls_ift/designs/cellift.v, and find the corresponding numbers (e.g. u_ibex_core.id_stage_i._123_ in Ibex ID stage module) and replace the Yosys generated names in the declassification file, e.g.: verification/ibex_top_opentitan_941315_rst_sec1_slow_no_ls_ift/formal/scripts/declass.tcl.

#### Properties are vacuously satisifed (ie., their antecedent can never be true)
The taint start condition cannot be true, so no taint can be injected. First check, whether all components (signal names, taint conditions, checker instantiations, ...) are used by the formal setup as expected. Check whether there is a mistake in signal names or in the taint injection conditions.

#### ERROR: Setup failed : Cannot find rtl/ibex_top.sv in :	../opentitan/hw/vendor/lowrisc_ibex_bug_old
Remove all temporary cpus/ibex/opentitan/hw/vendor/lowrisc_ibex_* directories.

#### ERROR in Jasper:  cannot open include file 'formal/properties/kronos_core_ct_instr_all.sv'
This file currently needs to be manually created and adapted.

#### A make target is not found.
Make sure that the OUT_DIR configured in the main Makefile matches the OUT_DIR in the input/<design>_config file.


