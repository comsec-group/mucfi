# Copyright 2024 Katharina Ceesay-Seitz, ETH Zurich.
# Licensed under the General Public License, Version 3.0, see LICENSE for details.
# SPDX-License-Identifier: GPL-3.0-only


## Test this script by generating the bind file and re-executing the print_taint_states Jasper run for all the cores that we have



import argparse
from pathlib import Path
import os
import sys
import json
import re


# Parent must be inserted before the current directory for Python to recognize fpv_core_setup as package
sys.path.insert(0, str(Path(__file__).parents[1]))

from common.util import *
from fpv_core_setup.BindFile import BindFile
from fpv_core_setup.FormalModule import FormalModule
from common.util_hier_paths import *

auto_name_only_pattern = re.compile(r"(?P<wire_name>_\d+_)")

def add_sigs_to_bindfile():
  pass

def add_sigs_to_module():
  pass

def get_sig_bitwidth(design_data, signal_path: str, current_module = ""):
  """
  signal_path: "." separated hierarchical path to the design, starting with top module: top_module_name.sub_module_instance_name1.sub_mod_inst_name2.signal_name
  current_module: module name of the module in which the remainer of the path is searched. If its empty,
                  the string before the first "." is treated as top module
  """
  split_path = escaped_verilog_hierarchy_path_split(signal_path)
  if current_module == "":
    current_module = split_path[0] # works only for top module

  print(f'DEBUG: finding bitwidth of path {signal_path} in module {current_module}')

  if len(split_path) == 2:
    bw = len(design_data["modules"][current_module]["netnames"][split_path[1]]["bits"])
    print(f"Signame {split_path}, bw {bw}")
    return bw
  elif len(split_path) < 2:
    print(f"Hierarchical signal path is too short: {signal_path}")
    return 0
  else:
    next_instance_name = split_path[1]
    return get_sig_bitwidth(design_data, "".join(split_path[1:]), design_data["modules"][current_module]["cells"][next_instance_name]["type"])

def add_signal(bindfile, formal_module_file, design_file, top, signal_paths: list()):
  pass
  json_filepath = gen_design_hierarchy(design_file, top)
  design_data = load_design(json_filepath)

  signal_paths_with_bw = dict()
  for signal_path in signal_paths:
    if signal_path.split(".")[0] != top: # append top module in case user forgot.
      signal_path = top + "." + signal_path
    signal_paths_with_bw[signal_path] = get_sig_bitwidth(design_data, signal_path)

  add_sigs_to_bindfile()
  add_sigs_to_module()

def add_ports_to_bind_strs(desing_data, mod_type, hier_path, bind_file, formal_mod):
  pass

def add_netnames_to_bind_strs(desing_data, mod_type, binds, mod_ports, mod_wires):
  for wire in design_data["modules"][mod_type]["netnames"]:
    pass

def sanity_check_yosys_bits(yosys_bits, sig_name_dbg = ""):
  last_bit = 0
  for bit in yosys_bits:
    if type(bit) == str and bit.upper() == "X":
      print(f"INFO: Found X initialized signal: {sig_name_dbg}")
    elif type(bit) == str and bit != "0":
      print(f"INFO: Expecting that registers are represented by '0' strings per bit in Yosys json. Found {sig_name_dbg} with bits: {yosys_bits}")
    if not last_bit == 0 and not bit > last_bit:
      print(f"Expecitng yosys wire bits to be always ascending. Last bit {last_bit} was larger than or equal to current bit {bit}")
      return False
  return True

def add_signal_bind_connection(design_data, mod_type, hier_path_to_instance_flattened,
                               hier_path_to_instance, sig_type, wire, bind_file: BindFile, formal_mod: FormalModule):

    hier_path_to_wire_flattened = connect_hier_paths(hier_path_to_instance_flattened, flatten_name(wire))

    assert sanity_check_yosys_bits(design_data["modules"][mod_type][sig_type][wire]["bits"],sig_name_dbg=hier_path_to_wire_flattened), \
      f'Unexpected bit order in Yosys not supported: {design_data["modules"][mod_type][sig_type][wire]["bits"]}'

    formal_wire_name = get_expanded_path(hier_path_to_wire_flattened)
    bind_file.add_signal(formal_wire_name, connect_hier_paths(hier_path_to_instance, escape_name(wire)))
    formal_mod.add_signal(formal_wire_name, len(design_data["modules"][mod_type][sig_type][wire]["bits"]))

def gen_formal_mod_bind_connection(design_data, mod_type, hier_path_to_instance_flattened,
                                   hier_path_to_instance, bind_file: BindFile, formal_mod: FormalModule):
  for wire in design_data["modules"][mod_type]["ports"]:
    add_signal_bind_connection(design_data, mod_type, hier_path_to_instance_flattened,
                               hier_path_to_instance, "ports", wire, bind_file, formal_mod)

  for wire in design_data["modules"][mod_type]["netnames"]:
    if not re.fullmatch(auto_name_only_pattern, wire) and design_data["modules"][mod_type]["netnames"][wire]["hide_name"] == 0:
      add_signal_bind_connection(design_data, mod_type, hier_path_to_instance_flattened,
                                 hier_path_to_instance, "netnames", wire, bind_file, formal_mod)

  for inst_name in design_data["modules"][mod_type]["cells"]:
    inst_type = design_data["modules"][mod_type]["cells"][inst_name]["type"]
    if inst_type in design_data["modules"].keys():
      gen_formal_mod_bind_connection(design_data, inst_type, connect_hier_paths(hier_path_to_instance_flattened, flatten_name(inst_name)),
                                     connect_hier_paths(hier_path_to_instance, escape_name(inst_name)), bind_file, formal_mod)


def add_yosys_taint_states_to_bind_and_mod(design_data, top_module, bind_file, formal_mod, taint_states_with_paths):
  """Adds all taint states with Yosys auto-generated names like _123_ to the bind and module definition"""
  for taint_state_path in taint_states_with_paths:
    if not taint_state_path.endswith("_t0"):
      state_with_top = jasper_tcl_sig_add_top_module(top_module, taint_state_path)
      module_type = get_module_type(design_data, jasper_tcl_get_split_path_of_instance(state_with_top))
      wire_name = jasper_tcl_sig_extract_sig_name(taint_state_path)
      # Yosys generated signals are never ports, they are always of type "netnames"
      path_of_instance = ".".join(jasper_tcl_get_split_path_of_instance(taint_state_path))

      add_signal_bind_connection(design_data, module_type, flatten_signal_path(path_of_instance), path_of_instance, "netnames", wire_name, bind_file, formal_mod)

def gen_formal_bind(design_data, top_module, outdir, taint_states_with_paths=None):
  bind_file = BindFile(outdir, top_module)
  formal_mod = FormalModule(outdir, top_module)
  gen_formal_mod_bind_connection(design_data, top_module, "", "", bind_file, formal_mod)
  if taint_states_with_paths:
    add_yosys_taint_states_to_bind_and_mod(design_data, top_module, bind_file, formal_mod, taint_states_with_paths)
  bind_file.gen_file()
  formal_mod.gen_file()

if __name__ == "__main__":

  # design_json_path = gen_design_hierarchy("/data/kceesay/workspace/cellift-formal/jasper/pc_taint_check/picorv32/designs/cellift_picorv32.sv", "cellift_picorv32")
  design_json_path = "/data/kceesay/workspace/cellift-formal/formal_scripts/fpv_core_setup/generated/cellift_picorv32.json"
  design_data = load_design(design_json_path)
  gen_formal_bind(design_data, "cellift_picorv32", Path(__file__).parents[0] / "generated")


