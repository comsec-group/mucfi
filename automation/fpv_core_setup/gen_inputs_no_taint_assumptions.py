# Copyright 2024 Katharina Ceesay-Seitz, ETH Zurich.
# Licensed under the General Public License, Version 3.0, see LICENSE for details.
# SPDX-License-Identifier: GPL-3.0-only

import argparse
import re
from pathlib import Path

def get_ports(in_module):

    found_module_def_end = False
    found_module_def = False
    portsline = ""
    for line in in_module:
        if not found_module_def:
            if line.strip().startswith("module"):
                found_module_def = True
                portsline = line.split("(", maxsplit=1)[1]
        elif not found_module_def_end:
            if line.strip().endswith(";"):
                found_module_def_end = True
                line = line.strip()[:-1] # remove ;
            portsline += line
        else:
            break

    ports = portsline.split(",")
    if ports[-1].endswith(")"): # can a port end with (..)?? This attemps to remove the closing bracket of the port list.
        ports[-1] = ports[-1][:-1]
    return [p.strip() for p in ports]

def get_input_ports(in_module, names_only):
    """
    Finds input port definitions in the following formats:
    input [n:m] current_priv_lvl_i;
    input signame;

    if names_only:
      returns their names
    else:
      returns their definitions
    """
    in_ports = list()
    for line in in_module:
        nr_inputs = line.count("input ")
        if nr_inputs > 1:
            raise Exception(f"ERROR: Cannot yet handle multiple input definitions in same line: {line}")
        if nr_inputs == 1:
            if names_only:
                line = line.replace("input","")
                line = line.replace(";","")
                line = re.sub("\[.*\]", "", line)
            in_ports.append(line.strip())
    return in_ports

def get_output_ports(in_module, names_only):
    """
    Finds output port definitions in the following format:
    output [n:m] current_priv_lvl_i;
    output signame;

    if names_only:
      returns their names
    else:
      returns their definitions
    """
    out_ports = list()
    for line in in_module:
        nr_output = line.count("output ")
        if nr_output > 1:
            raise Exception(f"ERROR: Cannot yet handle multiple output definitions in same line: {line}")
        if nr_output == 1:
            if names_only:
                line = line.replace("output","")
                line = line.replace(";","")
                line = re.sub("\[.*\]", "", line)
            out_ports.append(line.strip())
    return out_ports

def generate_no_taint_assumptions(ports):
    #assumptions = ["  always @(*)", "  begin"] # For Yosys
    assumptions = []
    for port in ports:
        if port.endswith("_t0"):
            assumptions.append("    asm_no_taint_top_" + port + ": assume property(" + port + " == 0);")
    #assumptions.append("  end")
    return assumptions

def generate_rst_seq_all_0(ports):
    """
    # TODO: Add reset port parameter, add reset polarity, write out a complete reset sequence file that keeps the reset
    # deactivated throughout formal verification.
    """
    rst_signal_defs = list()
    for port in ports:
        rst_signal_defs.append(port + " 1'b0")
    return rst_signal_defs

def write_rst_seq_all_0(ports, rst_sig, rst_polarity, outfile):
    rst_signal_defs = generate_rst_seq_all_0(ports)
    rst_file_str = '\n'.join(rst_signal_defs)
    rst_file_str += "\n3\n"
    rst_file_str += rst_sig + " 1'b" + ("1" if rst_polarity=="0" else "0") + "\n"
    rst_file_str += "$\n" # keep it at the same value

    with open(outfile, "w") as f:
            f.write(rst_file_str)
    print("Generated " + str(outfile))

def write_no_taint_assumptions(ports, outfile):
    """
        Generates input assumptions. Parses module definition, but does not check syntax completely.
    """
    assumptions = generate_no_taint_assumptions(ports)

    with open(outfile, "w") as f:
            f.write('\n'.join(assumptions))
    print("Generated " + str(outfile))

def write_bind_input_definitions_ports_only(all_port_definitions, outfile):
    """
        Prints all port definitons as inputs (outputs become inputs)
    """
    input_definitions = [x.replace("output", "input") for x in all_port_definitions]
    with open(outfile, "w") as f:
              f.write('\n'.join(input_definitions))
    print("Generated " + str(outfile))

def parse_module_definition(infile, name: str):
    """
    Finds first occurence of module definition with name 'name'.
    Returns the lines of this module as list.
    """
    with open(infile, "r") as f:
        lines = f.readlines()

        start_found = False
        in_module = list()
        for line in lines:
            if not start_found and "module" in line and not line.strip().startswith("//") and name in line:
                start_found = True
            if start_found:
                in_module.append(line)
                if "endmodule" in line:
                    break
        if not start_found:
            print("Could not find module " + name)
    return in_module

# TODO: put the functionality of this file into the FormalModule class, parse module only once
def gen_reset_seq_all_0(design_file, top_module, rst_sig, rst_polarity, outdir):
    module_lines = parse_module_definition(design_file, top_module)
    input_ports = get_input_ports(module_lines, names_only=True)

    write_rst_seq_all_0(input_ports, rst_sig, rst_polarity, outdir / (top_module + "_rst_seq_all_0.rst"))

def gen_inputs_no_taint_asm(design_file, top_module, outdir):
    module_lines = parse_module_definition(design_file, top_module)
    input_ports = get_input_ports(module_lines, names_only=True)

    write_no_taint_assumptions(input_ports, outdir / (top_module + "_ti_asm.sv"))


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Generates input assumptions or initial sequences for formal verification')
    parser.add_argument('--infile', dest='infile', type=str, required=True, help='Input SystemVerilog file')
    parser.add_argument('--outfile', dest='outfile', type=str, default="generated", help='Output SystemVerilog file')
    parser.add_argument('--target_tool', dest='target_tool', type=str, help='Select target tool: jasper, symbiyosys')
    parser.add_argument('--module_name', dest='module_name', type=str, required=True, help='Select module that shall be parsed.')
    args = parser.parse_args()

    outdir = Path(__file__).parents[0]

    module_lines = parse_module_definition(args.infile, args.module_name)
    input_ports = get_input_ports(module_lines, names_only=True)

    all_port_definitions = get_input_ports(module_lines, names_only=False)
    all_port_definitions.extend(get_output_ports(module_lines, names_only=False))

    write_bind_input_definitions_ports_only(all_port_definitions, outdir / args.outfile + "_bind_input_definitions.sv")

    write_no_taint_assumptions(input_ports, args.outfile + "_no_taint_assumptions.sv")

    if args.target_tool and args.target_tool == "jasper":
        write_rst_seq_all_0(input_ports, outdir / args.outfile + "_rst_seq_all_0.rst")