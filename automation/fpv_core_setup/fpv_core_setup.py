# Copyright 2024 Katharina Ceesay-Seitz, ETH Zurich.
# Licensed under the General Public License, Version 3.0, see LICENSE for details.
# SPDX-License-Identifier: GPL-3.0-only

from pathlib import Path
import os
import shutil
import argparse
import sys

# Parent must be inserted before the current directory for Python to recognize fpv_core_setup as package
sys.path.insert(0, str(Path(__file__).parents[1]))

from fpv_core_setup.gen_bind_signals import *
from fpv_core_setup.taint_states import *
from gen_inputs_no_taint_assumptions import *
from common.util_hier_paths import *

def gen_subdirs(topdir: str, subdirs: list()):
    for dir in subdirs:
        if type(dir) == str:
            Path(os.path.join(topdir, dir)).mkdir(parents=True, exist_ok=True)
        elif type(dir) == dict:
            for k in dir.keys():
                gen_subdirs(os.path.join(topdir, k), dir[k])
        else:
            raise Exception(f"Unexpected type in directory name list: {dir}")

def gen_formal_dirs(outdir):
    dirs = {"outdir":
            ["configurations", "designs", "experiments",
             {"formal":
              ["assumptions", "bind", "modules", "properties", "reset_sequences", "scripts"]}]}
    gen_subdirs(outdir, dirs["outdir"])

def copy_design_file(outdir, infile):
    shutil.copy2(infile, os.path.join(outdir, "designs", os.path.basename(infile)))


if __name__ == "__main__":
    update_bind = False
    taint_states_with_paths = None

    parser = argparse.ArgumentParser(description='Generates setup for a new core for formal verification')
    parser.add_argument('--design_file', dest='design_file', type=str, required=True, help='Input SystemVerilog file')
    parser.add_argument('--path_to_core', dest='path_to_core', type=str, required=False, help='Path to core')
    parser.add_argument('--top_module', dest='top_module', type=str, required=True, help='Select top module.')
    parser.add_argument('--outdir', dest='outdir', type=str, default="", help='Output directory')
    parser.add_argument('--gen_bind_and_mod', dest='gen_bind_and_mod', type=bool, required=False, help='Generates the bind file and formal module, ' \
                        'making all internal signals visible for formal verification. If used together with gen_symb_init or gen_taint_propagation_checker, taint states with Yosys generated names will also be added.')
    parser.add_argument('--gen_symb_init', dest='gen_symb_init', type=bool, required=False, help='Generates no-taint assumptions for symbolic initial state.')
    parser.add_argument('--gen_taint_propagation_checker', dest='gen_taint_propagation_checker', type=bool, required=False, help='Generates taint_propagation_checker.sv')
    parser.add_argument('--regen_design_hier', dest='regen_design_hier', type=bool, default=False,
                        required=False, help='If true, design hierarchy json file is regenerated if it already exists.')
    parser.add_argument('--gen_reset_seq', dest='gen_reset_seq', type=bool, required=False, help='Generates the reset sequence file, setting all inputs to 0')
    parser.add_argument('--gen_input_no_taint_asm', dest='gen_input_no_taint_asm', type=bool, required=False, help='Generates the input assumptions that set all taint inputs to 0')
    parser.add_argument('--target_tool', dest='target_tool', type=str, help='Select target tool: jasper, symbiyosys')
    parser.add_argument('--top_module_orig', dest='top_module_orig', type=str, required=False, help='Original top module name.')
    parser.add_argument('--rename_top', dest='rename_top', type=bool, required=False, help='Original top module name.')
    parser.add_argument('--rst_signal', dest='rst_signal', type=str, required=False, help='Reset signal name.')
    parser.add_argument('--rst_polarity', dest='rst_polarity', type=str, required=False, help='Set 1 if high on reset.')

    args = parser.parse_args()

    if not args.outdir:
        args_outdir = Path(__file__).parents[0] / "generated"
    else:
        args_outdir = Path(args.outdir)

    design_data = get_design_data(args.design_file, args.top_module, args.regen_design_hier)

    path_to_core = ""
    if not args.path_to_core:
        path_to_core = Path(args.design_file).parents[0] / ".."
    else:
        path_to_core = args.path_to_core

    if any([args.gen_symb_init, args.gen_taint_propagation_checker]):
      taint_states_with_paths = get_taint_states_as_jasper_paths(design_data, path_to_core, "all_states.txt", args.design_file,
                                  args.top_module)

    if args.gen_bind_and_mod:
        outdir = args_outdir / "formal" / "bind"
        outdir.mkdir(parents=True, exist_ok=True)
        gen_formal_bind(design_data, args.top_module, outdir, taint_states_with_paths)

    if args.gen_symb_init:
        gen_symb_init_taint_states_asms(taint_states_with_paths,
        outfile = args_outdir / f"symb_init_asm_{args.top_module}.tcl")

    if args.gen_taint_propagation_checker:
        outfile = args_outdir / "formal" / "properties" / f"{args.top_module}_taint_propagation_checker.sv"
        outfile.parent.mkdir(parents=True, exist_ok=True)
        gen_taint_propagation_checker(taint_states_with_paths, outfile=outfile)

        outfile = args_outdir / "formal" / "properties" / f"{args.top_module}_no_taint_ever_checker.sv"
        outfile.parent.mkdir(parents=True, exist_ok=True)
        gen_no_taint_ever_props(taint_states_with_paths, outfile=outfile)

    if args.gen_reset_seq:
        if not args.rst_signal and not args.rst_polarity:
            raise Exception("Please provide rst_signal and rst_polarity arguments.")
        outdir = args_outdir / "formal" / "reset_sequences"
        outdir.mkdir(parents=True, exist_ok=True)
        gen_reset_seq_all_0(args.design_file, args.top_module, args.rst_signal, args.rst_polarity, outdir)

    if args.gen_input_no_taint_asm:
        outdir = args_outdir / "formal" / "assumptions"
        outdir.mkdir(parents=True, exist_ok=True)
        gen_inputs_no_taint_asm(args.design_file, args.top_module, outdir)


