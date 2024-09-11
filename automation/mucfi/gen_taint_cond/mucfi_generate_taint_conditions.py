
# Copyright 2024 Katharina Ceesay-Seitz, ETH Zurich.
# Licensed under the General Public License, Version 3.0, see LICENSE for details.
# SPDX-License-Identifier: GPL-3.0-only

import argparse
from pathlib import Path
import sys
import os
sys.path.insert(0, str(str(Path(os.path.realpath(__file__)).parents[2])))

from common.util import *
from gen_taint_cond import *

def get_config_str(config_str):
    empty_str = '""'
    if not config_str:
        return empty_str
    else:
        return config_str


def yosys_cellift_and_find_fwd_mux(config, y_log_dir, cellift_find_mux_log, taint_tracking_method, y_script, design_file):
    # Write the yosys script with correct signal names
    # run the yosys pass
    with open(Path(os.path.realpath(__file__)).parents[0] / "yosys_templates" / y_script, "r") as f:
        yscript = f.read()
        yscript = yscript.replace("${VERILOG_INPUT}", str(Path(config["DESIGN_DIR"]) / "cellift" / "generated" / "sv2v_out.v"))
        yscript = yscript.replace("${TOP_MODULE}", get_config_str(config["TOP_MODULE"]))
        yscript = yscript.replace("${REGISTER_READ_SIGNALS}", get_config_str(config["REGISTER_READ_SIGNALS"]))
        yscript = yscript.replace("${REGISTER_RS1}", get_config_str(config["REGISTER_RS1"]))
        yscript = yscript.replace("${REGISTER_WRITE_SIGNALS}", get_config_str(config["REGISTER_WRITE_SIGNALS"]))
        yscript = yscript.replace("${FORWARDING_OUTPUTS}", get_config_str(config["FORWARDING_OUTPUTS"]))
        yscript = yscript.replace("${PC_SIGNALS}", get_config_str(config["PC_SIGNAL"]))
        if taint_tracking_method == "dft":
            yscript = yscript.replace("${CELLIFT_YOSYS_FLAGS}", "-data-flow")
        else:
            yscript = yscript.replace("${CELLIFT_YOSYS_FLAGS}", "")

        yscript = yscript.replace("${VERILOG_OUTPUT}", design_file)

        yscript_mod = y_log_dir / y_script
        with open (yscript_mod, "w") as f:
            f.write(yscript)
        result = run_cmd(f"{str(Path(config["YOSYS_DIR"]) / "yosys")} -c {yscript_mod} > {cellift_find_mux_log}", print_stdout=False)
        return result.stderr

def check_fwd_muxes(config, y_log, y_log_extra_mux_check):
    '''
    # parse the output to get: mux select names, and whether there are additional muxes between the register read signal and the register file,
    # and whether the preconditions for declassification are met.
    # assumes that the find_fwd_mux_selects pass was called twice: once to find the fwd muxes, and once to check for additional fmuxes between the reg read signal and the reg file.
    Returns:
        precondition_satisfied: bool
        extra_muxes_between_regrd_and_reg: bool
    '''
    with open(y_log, "r") as f:
        y_out = f.read()

    with open(y_log_extra_mux_check, "r") as f:
        y_out_extra_mux_check = f.read()

    y_out = y_out + y_out_extra_mux_check
    config["FWD_MUX_SELECTS"] = ""
    precond_check_started = False
    precond_check_done = False
    mux_selects = []
    mux_between_regrd_and_reg = []
    extra_mux_selects = []
    find_fwd_mux_selects_pass_cnt = 0
    for line in y_out.split("\n"):
        if "Executing find_fwd_mux_selects pass" in line:
            find_fwd_mux_selects_pass_cnt += 1
        if "PRECONDITION UNSATISFIED" in line:
            print("PRECONDITION UNSATISFIED. Please consult the log file " + str(y_log))
            return
        if "FORMAL_ABSTRACT" in line:
            if find_fwd_mux_selects_pass_cnt == 1: # first run of the Yosys pass
                # Expecting the find_fwd_mux_selects pass to output:
                # "FORMAL_ABSTRACT: Mux %s with MUX_SELECT=%s.\n"
                mux_selects.append(line.split("MUX_SELECT=")[1])
            elif find_fwd_mux_selects_pass_cnt == 2: # second run of the Yosys pass
                # Expecting the find_fwd_mux_selects pass to output:
                # "FORMAL_ABSTRACT: Mux %s with MUX_SELECT=%s.\n"
                mux_between_regrd_and_reg.append(line.split("MUX_SELECT=")[1])
            else:
                print("ERROR: Unexpected number of find_fwd_mux_selects passes.")
                return False, False
        if not precond_check_done and "PRECONDITION_CHECK_EXTERNAL_START" in line:
            # When this keyword is found in the first call of find_fwd_mux_selects, then the following list of select signals needs to be checked against the ones marked with FORMAL_ABSTRACT
            # In the second run of the pass (checking for additional mux between reg read signal and reg file), it needs to be ignored.
            precond_check_started = True
        if precond_check_started and not "PRECONDITION_CHECK_EXTERNAL_END" in line:
            extra_mux_selects.append(line)
        if precond_check_started and "PRECONDITION_CHECK_EXTERNAL_END" in line:
            precond_check_started = False
            precond_check_done = True

        config["FWD_MUX_SELECTS"] = ",".join(mux_selects)

        if extra_mux_selects:
            for mux in extra_mux_selects:
                if mux not in mux_selects:
                    print("PRECONDITION UNSATISFIED: Found additional multiplexers between a forwarding multiplexer and a register read signal:")
                    for emux in extra_mux_selects:
                        print(emux)
                    return False, False

        if mux_between_regrd_and_reg:
            for mux in mux_between_regrd_and_reg:
                if mux not in mux_selects:
                    print("PRECONDITION CHECK: Found extra mux between regrd and reg: " + mux)
                    return True, True
    return True, False

def cellift_and_declassify(config, config_file, taint_tracking_method):
    '''
    First, cellift, then find forwarding multiplexers. Finally, check whether there are additional multiplexers between the register reading signal and the register file. In that case signal the update condition, that it needs to include the forwarding input signal.
    This function produces: cellift-ed design (cellift.v), yosys log file (cellift_find_fwd_mux.log), and appends the forwarding multiplexer select signals to the signal names file (e.g., signals.mk)
    '''
    y_log_dir = Path(config["OUT_DIR"]) / "yosys_passes"
    y_log_dir.mkdir(parents=True, exist_ok=True)
    y_log = Path(y_log_dir) / "cellift_find_fwd_mux.log"
    y_log_extra_mux_check = Path(y_log_dir) / "cellift_find_fwd_mux_extra_mux_check.log"

    d_out_dir = Path(config["OUT_DIR"]) / "designs"
    d_out_dir.mkdir(parents=True, exist_ok=True)
    design_file = str(d_out_dir / f"cell{config["TAINT_TRACKING_METHOD"]}.v")
    design_file_extra_mux = str(d_out_dir / f"cell{config["TAINT_TRACKING_METHOD"]}_extra_mux.v")

    y_err = yosys_cellift_and_find_fwd_mux(config, y_log_dir, y_log, taint_tracking_method, "cellift_and_find_fwd_mux.ys.tcl", design_file)
    y_err_extra_mux_check = yosys_cellift_and_find_fwd_mux(config, y_log_dir, y_log_extra_mux_check, taint_tracking_method, "find_extra_fwd_mux.ys.tcl", design_file_extra_mux)

    if y_err:
        print("ERROR in yosys cellift and find forwarding muxes. Please consult the log file " + str(y_log))
        return False, False

    if y_err_extra_mux_check:
        print("ERROR in yosys cellift and find forwarding muxes. Please consult the log file " + str(y_err_extra_mux_check))
        return False, False

    precondition_satisfied, fwd_mux_between_regrd_and_reg = check_fwd_muxes(config, y_log, y_log_extra_mux_check)
    if precondition_satisfied:
        write_back_config(config, config_file)

    return precondition_satisfied, fwd_mux_between_regrd_and_reg


def gen_taint_cond_file(design_with_uc, top_module, taint_cond_name, taint_cond_file, provided_taint_cond=None):
    '''
    call the reconstruction script that generates the update condition using design signal names
    '''

    if design_with_uc and provided_taint_cond:
        print("ERROR: Both a design file with update condition and a taint condition are provided to the taint condition file writing procedure. Unclear which one should be used. Please provide only one.")
        return

    if design_with_uc:
        print("Extracting UC from " + str(design_with_uc))
        simplified_expr = gen_uc_cond(design_with_uc, top_module, "update_condition")
        if simplified_expr:
            first_eq = simplified_expr.find("=")
            simplified_expr = simplified_expr[first_eq+1:]
        else:
            simplified_expr = "1'b1;"
    else:
        simplified_expr = provided_taint_cond
    if not simplified_expr[-1] == ";":
        simplified_expr += ";"
    with open (taint_cond_file, "w") as f:
        f.write(f"bit {taint_cond_name};\n")
        f.write(f"assign {taint_cond_name} = \n")
        f.write(simplified_expr.replace("& ", "&\n"))


def gen_uc_tcl(config, uc_out_file, uc_call, uc_tcl_file):
    # Generate and save the yosys script
    with open(Path(os.path.realpath(__file__)).parents[0] / "yosys_templates" / "uc_base.ys.tcl", "r") as f:
        yscript = f.read()
        yscript = yscript.replace("${VERILOG_INPUT}", str(Path(config["DESIGN_DIR"]) / "cellift/generated/sv2v_out.v"))
        yscript = yscript.replace("${TOP_MODULE}", config["TOP_MODULE"])
        yscript = yscript.replace("${VERILOG_OUTPUT}", str(uc_out_file))
        yscript = yscript.replace("${CALL_UPDATE_CONDITION_PASS}", uc_call)
    with open (uc_tcl_file, "w") as f:
        f.write(yscript)

def prep_signame_for_uc(signame):
    if signame.startswith("\\\\"):
        return signame.replace(" ","")
    else:
        return f"\\\\{signame}"

def gen_uc_rs(config, taint_cond_path):
    n = 1
    for regrd in config["REGISTER_READ_SIGNALS"].replace('"','').split(","):
        # uc_call = f"yosys update_condition -signal_name \"\\\\{regrd}\" -verbose\n" # Removing spaces because we flatten the design before
        uc_call = f"yosys update_condition -signal_name \"" + prep_signame_for_uc(regrd) + "\" -verbose\n" # Removing spaces because we flatten the design before
        design_with_uc = Path(config["OUT_DIR"]) / "yosys_passes" / f"design_uc_rs{n}.v"
        yosys_gen_uc(f"uc_rs{n}.ys.tcl", uc_call, design_with_uc, Path(config["OUT_DIR"]) / "yosys_passes" / f"uc_rs{n}.log")
        gen_taint_cond_file(design_with_uc, config["TOP_MODULE"], f"gen_uc_rs{n}", taint_cond_path / f"uc_rs{n}.sv")
        n += 1

def gen_uc_regrd_from_fwd(config, taint_cond_path):
    n = 1
    for regrd in config["REGISTER_READ_SIGNALS"].replace('"','').split(","):
        uc_call = f"yosys update_condition -read-from-signals {config["FORWARDING_INPUT_BEFORE_REGREAD"]} -signal_name \"" + prep_signame_for_uc(regrd) + "\" -verbose\n"
        design_with_uc = Path(config["OUT_DIR"]) / "yosys_passes" / f"design_uc_regrd{n}_from_fwd.v"
        yosys_gen_uc(f"uc_regrd{n}_from_fwd.ys.tcl", uc_call, design_with_uc, Path(config["OUT_DIR"]) / "yosys_passes" / f"uc_fwdrd_rs{n}.log")
        gen_taint_cond_file(design_with_uc, config["TOP_MODULE"], f"gen_fwdrd_rs{n}", taint_cond_path / f"uc_fwdrd_rs{n}.sv")
        n += 1

def gen_uc_regrd_from_reg(config, taint_cond_path):
    n = 1
    for regrd in config["REGISTER_READ_SIGNALS"].replace('"','').split(","):
        uc_call = f"yosys update_condition -read-from-signals {config["REGISTER_FILE"]} -signal_name \"" + prep_signame_for_uc(regrd) + "\" -verbose\n"
        design_with_uc = Path(config["OUT_DIR"]) / "yosys_passes" / f"design_uc_regrd{n}_from_reg.v"
        yosys_gen_uc(f"uc_regrd{n}_from_reg.ys.tcl", uc_call, design_with_uc, Path(config["OUT_DIR"]) / "yosys_passes" / f"uc_regrd_rs{n}.log")
        gen_taint_cond_file(design_with_uc, config["TOP_MODULE"], f"gen_regrd_rs{n}", taint_cond_path / f"uc_regrd_rs{n}.sv")
        n += 1

def gen_uc_iw(config, taint_cond_path):
    uc_call = f"yosys update_condition -read-from-signals {config["INSTR_WORD"]} -signal_name {config["REG_ADDR"]} -verbose\n"
    design_with_uc = Path(config["OUT_DIR"]) / "yosys_passes" / f"design_uc_iw.v"
    y_log = Path(config["OUT_DIR"]) / "yosys_passes" / f"uc_iw.log"
    yosys_gen_uc(f"uc_iw.ys.tcl", uc_call, design_with_uc, y_log)

    # If the register address signal name was correctly specified and it is not found in the design by Yosys, then it was optimized out, because it is a direct assignment from the instruction word.
    # In that case the instruction word sampling condition is 1.
    # (Do not copy this logic for the register reading signal. Since it must be able to read from all registers, it cannot be optimized out. If it did, something went wrong.)
    signal_not_found = False
    with open (y_log, "r") as f:
        iw_log = f.readlines()
        for line in iw_log:
            if config["REG_ADDR"].replace('"',"").replace("\\","") and "not found in module" in line:
                signal_not_found = True
        if signal_not_found:
            gen_taint_cond_file("", "", f"gen_instr_word_sampling_cond", taint_cond_path / f"uc_iw.sv", "1'b1")
            print(f"WARNING: Since REG_ADDR {config['REG_ADDR']} is not found in the design, the instruction word sampling condition is set to 1. Please make sure that there was no typo in the REG_ADDR signal name!!")
        else:
            gen_taint_cond_file(design_with_uc, config["TOP_MODULE"], f"gen_instr_word_sampling_cond", taint_cond_path / f"uc_iw.sv")

def yosys_gen_uc(tcl_name, uc_call, design_with_uc, uc_log):
    '''
    Generates the update condition for the register read signals.
    '''
    uc_tcl_file = Path(config["OUT_DIR"]) / "yosys_passes" / tcl_name
    gen_uc_tcl(config, design_with_uc, uc_call, uc_tcl_file)
    #call yosys pass, generate the output file with the update condition
    run_cmd(f"{str(Path(config["YOSYS_DIR"]) / "yosys")} -c {uc_tcl_file} > {uc_log}", print_stdout=False)

def yosys_gen_taint_cond(config, add_read_from_fwd_input_condition):
    '''
    Calls the yosys pass to generate the taint conditions for: register readig (taint start), additional reading from forwarding inputs (additional taint start) and update condition of register read signals (taint stop)
    This function produces: The directory taint_conditions with the taint condition files.
    '''

    taint_cond_path = Path(config["OUT_DIR"]) / "formal" / "properties" / "taint_conditions"
    taint_cond_path.mkdir(parents=True, exist_ok=True)
    taint_cond_includes = "`include \"formal/properties/taint_conditions/uc_iw.sv\"" + "\n" \
                        + "`include \"formal/properties/taint_conditions/uc_regrd_rs1.sv\"" + "\n" \
                        + "`include \"formal/properties/taint_conditions/uc_regrd_rs2.sv\"" + "\n" \
                        + "`include \"formal/properties/taint_conditions/uc_rs1.sv\"" + "\n" \
                        + "`include \"formal/properties/taint_conditions/uc_rs2.sv\"" + "\n"

    taint_cond_dir = Path(config["OUT_DIR"]) / "formal" / "properties" /  "taint_conditions"
    taint_cond_dir.mkdir(parents=True, exist_ok=True)

    gen_uc_regrd_from_reg(config, taint_cond_path)
    gen_uc_rs(config, taint_cond_path)
    if add_read_from_fwd_input_condition and config["FORWARDING_INPUT_BEFORE_REGREAD"]:
        taint_cond_includes += "`include \"formal/properties/taint_conditions/uc_fwdrd_rs1.sv\"" + "\n" \
                        + "`include \"formal/properties/taint_conditions/uc_fwdrd_rs2.sv\"" + "\n"
        gen_uc_regrd_from_fwd(config, taint_cond_path)

    gen_uc_iw(config, taint_cond_path)

    with open (taint_cond_dir / "generated_taint_conditions.sv", "w") as f:
        f.write(taint_cond_includes)

def gen_taint_conditions(config, config_file, taint_tracking_method):
    precondition_satisfied, fwd_mux_between_regrd_and_reg = \
        cellift_and_declassify(config, config_file, taint_tracking_method)
    if not precondition_satisfied:
        return False
    fwd_mux_between_regrd_and_reg = True
    yosys_gen_taint_cond(config, fwd_mux_between_regrd_and_reg)


if __name__ == "__main__":

    parser = argparse.ArgumentParser(description='Searches for forwarding multiplexers, checks declassification precondition and generates taint conditions for the given design.')
    # parser.add_argument('--design_file', dest='design_file', type=str, required=True, help='Verilog version of the design (e.g., generated by sv2v). This should be the same as the input to the cellift pass.')
    # parser.add_argument('--top_module', dest='top_module', type=str, required=True, help='Name of the top module.')
    parser.add_argument('--config_file', dest='config_file', type=str, required=True, help='File containing signal names and other CPU-specific configs' )
    parser.add_argument('--taint_tracking_method', dest='taint_tracking_method', type=str, required=True, help='ift = uses CellIFT, dft = uses CellDFT' )
    # parser.add_argument('--yosys_dir', dest='yosys_dir', type=str, required=True, help='Path to the yosys top directory that contains the update_condition and find_fwd_mux_selects passes.' )
    # parser.add_argument('--outdir', dest='outdir', type=str, default="", help='Output directory, usually the design\'s formal verification directory.')
    args = parser.parse_args()

    config = parse_config(args.config_file)

    gen_taint_conditions(config, args.config_file, args.taint_tracking_method)
