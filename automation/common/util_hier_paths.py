
import re
import json
import sys
import os
from pathlib import Path

# Parent must be inserted before the current directory for Python to recognize fpv_core_setup as package
sys.path.insert(0, str(Path(__file__).parents[1]))

from common.util import *

def get_design_data(design_file, top_module, regen_design_hier):
    design_json_path = Path(__file__).parents[0] / "generated" / "tmp" / (top_module + ".json")

    if not design_json_path.exists() or regen_design_hier:
        print("Re-generating design hierarchy for " + top_module)
        gen_design_hierarchy(design_file, top_module, design_json_path)

    design_data = load_design(design_json_path)
    return design_data

def gen_design_hierarchy(design_file, top, json_filename) -> Path:
  # gen_path = os.path.join(os.path.dirname(__file__), "generated")
  # tmp_path = os.path.join(gen_path, "tmp")
  gen_path = Path(__file__).parents[0] / "generated"
  tmp_path = Path(gen_path / "tmp")
  Path(tmp_path).mkdir(parents=True, exist_ok=True)
  ys_file_path = tmp_path / "tmp_get_design_hier.ys"

  with open(ys_file_path, "w") as f:
    s = (
      f"yosys read_verilog -sv {design_file}",
      f"yosys hierarchy -top {top}",
      "yosys proc",
      f"yosys write_json {json_filename}"
    )
    f.write("\n".join(s))
  run_cmd("yosys -c " + str(ys_file_path), print_stderr=True)

def load_design(json_filepath):
  with open (json_filepath, "r") as f:
    design = json.load(f)
  return design

def escaped_verilog_hierarchy_path_split(signal_path : str):
  """
  Splits a hierarchical signal path on the non escaped dots.
  Returns: List of the parts of the path
  """
  ret = []
  part = ""
  last_c = ""
  in_escaped_name = False
  for c in signal_path:
    if not in_escaped_name and c == ".":
      if part != "":
        ret.append(part)
      part = ""
    elif c == "\\":
      if not in_escaped_name and last_c not in ("", "."):
        raise Exception(f"ERROR: found a \\ character in the middle of a path name: {signal_path}")
      in_escaped_name = True
      part += c
    elif c == " ":
      if in_escaped_name:
        in_escaped_name = False
        part += c
        if part != " ":
          ret.append(part)
        part = ""
      else:
        raise Exception(f"ERROR: Found an unexpected space in the signal path: {signal_path}")
    else:
      part += c
    last_c = c
  if part.strip(" ") != "":
    ret.append(part)
  return ret

def trim_size_marker(signame):
    """signame may be escaped. In that case it is expected to end with a space as its defined by Verilog syntax."""
    if signame[-1] == "]":
        #Find the length marker like [32:0] to remove and remove it
        marker_start = signame.rfind("[")
        signame = signame[0:marker_start]
    return signame

def jasper_tcl_sig_list_split(signal_path : str):
  """Splits a list of signals on non-escaped spaces. E.g.
  {\genblk1.genblk1.pcpi_mul .instr_mul_t0} sig_name2
  is split on the space before sig_name2. Curly brackets are not removed
  Returns: List of the tcl+verilog escaped signal names
  """
  ret = []
  part = ""
  last_c = ""
  ignore_spaces = False
  for c in signal_path:
    if not ignore_spaces and c == " ":
      ret.append(part)
      part = ""
    elif c == "{": #assuming { only appear in the beginning of a name
      if last_c not in ("", " "):
        print(f"ERROR: found a {{ character in the middle of a signal name: {signal_path}\n")
      ignore_spaces = True
      part += c
    elif c == "}":
      if ignore_spaces:
        ignore_spaces = False
        part += c
      else:
        print(f"ERROR: Found an unexpected }} in the signal path: {signal_path}")
    else:
      part += c
    last_c = c
  ret.append(part.rstrip("\n"))
  return(ret)

def jasper_tcl_get_split_path_of_instance(tcl_sig_path):
  """
  tcl_sig_path example: {\genblk1.genblk1.pcpi_mul .instr_mul_t0}
  returns: ['genblk1', 'genblk1', 'pcpi_mul']
  """
  path = tcl_sig_path.lstrip("{")
  path = path.rstrip("}")
  split_inst_path = escaped_verilog_hierarchy_path_split(path)
  return(split_inst_path[0:-1])

def jasper_tcl_sig_extract_sig_name(tcl_sig_path):
  """
  tcl_sig_path example: {\genblk1.genblk1.pcpi_mul .instr_mul_t0}
  returns: instr_mul_t0
  """
  path = tcl_sig_path.lstrip("{")
  path = path.rstrip("}")
  split_inst_path = escaped_verilog_hierarchy_path_split(path)
  return(split_inst_path[-1])

def jasper_tcl_sig_add_top_module(top_module, tcl_sig_path, connector = "."):
  if tcl_sig_path.startswith("{"):
    return f"{tcl_sig_path[0]}{top_module}{connector}{tcl_sig_path[1:]}"
  else:
    return f"{top_module}{connector}{tcl_sig_path}"

def remove_curley_brackets(sig):
  """Removes leading and trailing curley brackets from a signal name"""
  if (len(sig) < 1):
    return sig
  new_sig = sig
  if sig[0] == "{":
    new_sig = sig[1:]
  if sig[-1] == "}":
    new_sig = new_sig[:-1]
  return new_sig

def flatten_signal_path(sig_path, connector = "__"):
  """Completely flattes a signal path like {\genblk1.genblk1.pcpi_mul ._1029_} to genblk1__genblk1__pcpi_mul___1029_"""
  flattened_path = remove_curley_brackets(sig_path)
  parts = escaped_verilog_hierarchy_path_split(flattened_path)
  unescaped_parts = []
  for part in parts:
    p_unesc = flatten_name(part)
    p_unesc = p_unesc.replace(".", connector)
    unescaped_parts.append(p_unesc)
  return connector.join(unescaped_parts)

def get_expanded_path(p, connector = "__") -> str:
    """
    Replaces . with the connector in signal name, unless a . was part of a name with special characters
    """
    parts = escaped_verilog_hierarchy_path_split(p)
    return connector.join(parts)

def get_hierarchical_path(p, connector_expanded = "__", connector_hier = ".") -> str:
  """Back-transforms an expanded path into an HDL hierarchical path"""
  parts = p.split(connector_expanded)
  return connector_hier.join(parts)

def escape_name(signame) -> str:
    special_chars = ["[", "]", "."] # There might be more special case, adding for now what we have seen in a design
    if any(special_char in signame for special_char in special_chars):
      return "\\" + signame + " "
    else:
      return signame

def flatten_name(signame, flattener="_") -> str:
    special_chars1 = ["[", "]", "$", ":", "/"] # There might be more special case, adding for now what we have seen in a design
    special_chars2 = ["."]
    signame = unescape_name(signame)
    for sc in special_chars1:
      signame = signame.replace(sc, flattener)
    for sc in special_chars2:
      signame = signame.replace(sc, flattener*2)
    return signame

def unescape_name(signame) -> str:
  if not (signame[0] == "\\" and signame[-1] == " "):
    # print(f"DEBUG: Expected a verilog style escaped signal starting with \\ and ending with a space, but got {signame}")
    return signame
  return signame[1:-1]

def connect_hier_paths(part1, part2, connector="."):
  if part1 == "":
    return part2
  else:
    return part1 + connector + part2

def get_module_type(design_data, split_inst_path):
  mod_type = split_inst_path[0]
  i = 1
  while i < len(split_inst_path):
    # print(f"DEBUG get_module_type - mod_type = {mod_type}, split_inst_path = {split_inst_path}")
    mod_type = design_data["modules"][mod_type]["cells"][unescape_name(split_inst_path[i])]["type"]
    i += 1
  return mod_type
