# Copyright 2024 Katharina Ceesay-Seitz, ETH Zurich.
# Licensed under the General Public License, Version 3.0, see LICENSE for details.
# SPDX-License-Identifier: GPL-3.0-only

from pathlib import Path

import sys
import re
sys.path.insert(0, str(Path(__file__).parents[2]))
from common.util_hier_paths import *
from yosys_v_replace_gen_names import *

range_pattern = r"(?P<range>\[(?P<msb>\d+)(?:\:(?P<lsb>\d+))?\])"
auto_name_pattern = r"(?:\W|\s)(?P<wire_name>_\d+_)\s*" + range_pattern + r"?"
wire_decl_pattern = re.compile(r"(?:\W|\s)*wire\s*" + range_pattern + r"*\s*" + auto_name_pattern)

def flatten_signal_names(expr):
    "super lazy implememtation. Does not work if we have instance.\\escaped_instance .signame"
    ret_expr = expr.replace(".", "__")
    return ret_expr.replace("\\", "")

def get_simplified_expr(design_file, module_name, signal_name):
    reconstructed_expr = replace_yosys_gen_names(design_file, module_name, signal_name)
    simplified_expr = simplify_reconstructed_expr(reconstructed_expr)
    flattened_hier_path_expr = flatten_signal_names(simplified_expr)
    print(flattened_hier_path_expr)
    return flattened_hier_path_expr

def gen_uc_cond(design_file, module_name, attribute_name):
    signal_name = None
    simplified_expr = ""
    with open(design_file, 'r') as f:
        design = f.read()
        in_module = False
        next_line_is_update_condition = False
        for line in design.split("\n"):
            if line.startswith("module " + module_name):
                in_module = True
            if in_module:
                if next_line_is_update_condition and not line.strip().startswith("/*"):
                    match = wire_decl_pattern.match(line)
                    if match:
                        signal_name = match.group("wire_name")
                        simplified_expr = simplified_expr + "\n\n" + get_simplified_expr(design_file, module_name, signal_name)
                    else:
                        print("Expected a wire declaration with attribute " + attribute_name + " in " + line)
                    next_line_is_update_condition = False
                if attribute_name in line:
                    next_line_is_update_condition = True
    if not signal_name:
        return None
    return simplified_expr

def write_uc_cond(outfile):
    with open(outfile, "w") as of:
        of.write(simplified_expr.replace("& ", "&\n"))

if __name__ == "__main__":

    parser = argparse.ArgumentParser(description='Replaces all Yosys generated names with its expression built from the original names.')
    parser.add_argument('--design_file', dest='design_file', type=str, required=True, help='Input (System)Verilog file - dumped by Yosys')
    parser.add_argument('--outfile', dest='outfile', type=str, required=False, default="gen_uc.sv", help='Output (System)Verilog file containting the update condition with flattened hierarchical paths.')
    # parser.add_argument('--signal_name', dest='signal_name', type=str, required=True, help='Signal name to be replaced' )
    parser.add_argument('--module_name', dest='module_name', type=str, required=True, help='Name of the module where signal is part of.' )
    parser.add_argument('--print_with_linebreaks', dest='print_with_linebreaks', type=str, required=False, help='Adds line breaks into the expression.' )
    parser.add_argument('--attribute_name', dest='attribute_name', type=str, required=False, default="update_condition", help='Adds line breaks into the expression.' )

    args = parser.parse_args()

    simplified_expr = gen_uc_cond(args.design_file, args.module_name, args.attribute_name)

    if not simplified_expr:
        print("Could not find attribute " + args.attribute_name + " in " + args.design_file)
        sys.exit(1)

    write_uc_cond(args.outfile)





