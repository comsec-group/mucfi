# Copyright 2024 Katharina Ceesay-Seitz, Flavien Solt, ETH Zurich.
# Licensed under the General Public License, Version 3.0, see LICENSE for details.
# SPDX-License-Identifier: GPL-3.0-only

import sys
from pathlib import Path
import os
import re

def __operands_toinstr_format(num_source_regs: int, num_dest_regs: int):
  if (num_source_regs, num_dest_regs) == (3, 1):
    return "R4"
  if (num_source_regs, num_dest_regs) == (2, 1):
    return "R"
  elif (num_source_regs, num_dest_regs) == (2, 0):
    return "S" # Equivalent to B
  elif (num_source_regs, num_dest_regs) == (1, 1):
    return "I"
  elif (num_source_regs, num_dest_regs) == (0, 1):
    return "U" # Equivalent to J
  else:
    raise ValueError(f"Unsupported number of source and destination registers: {num_source_regs}, {num_dest_regs}")

def parse_isa_scalar_crypto(crypto_spec_instr_root):
  isa = {}
  isa["instructions"] = {}

  for filename in os.listdir(crypto_spec_instr_root):
    if filename.endswith(".adoc"):
      insn_name = filename.replace(".adoc", "")
      with open(os.path.join(crypto_spec_instr_root, filename), "r") as file:
        lines = file.readlines()
        for line_id in range(len(lines)-1):
          # Looking for the start of the struct
          if lines[line_id].startswith("....") and lines[line_id + 1].startswith("{reg:["):
            num_source_regs = 0
            num_dest_regs = 0
            # Get the opcode
            assert lines[line_id+2].startswith("{bits: 7, name: "), f"Unexpected line for instruction `{insn_name}`: {lines[line_id+2]}"
            opcode_hexstr = lines[line_id+2].split("name: ")[1].split("}")[0].strip()
            opcode_bitstr = bin(int(opcode_hexstr, 16))[2:].zfill(7)
            for struct_line_id in range(line_id+2, len(lines)-1):

              # Number of operands
              if "name: 'rs" in lines[struct_line_id]:
                num_source_regs += 1
              elif "name: 'rd" in lines[struct_line_id]:
                num_dest_regs += 1

              if lines[struct_line_id].startswith("...."):
                break

            isa["instructions"][insn_name.upper()] = {
              "opcode": opcode_bitstr,
              "type": __operands_toinstr_format(num_source_regs, num_dest_regs)
            }

            # We're done for this instruction
            break

  return isa

# Generate the instruction identification functions for formal verification
def gen_isa_scalar_crypto_instr_def_sva_functions(crypto_spec_instr_root, output_file, instr_word_name="instr_word"):
  function_str = ""

  for filename in os.listdir(crypto_spec_instr_root):
    if filename.endswith(".adoc"):
      insn_name = filename.replace(".adoc", "")
      with open(os.path.join(crypto_spec_instr_root, filename), "r") as file:
        lines = file.readlines()
        for line_id in range(len(lines)-1):
          # Looking for the start of the struct
          if lines[line_id].startswith("....") and lines[line_id + 1].startswith("{reg:["):
            num_source_regs = 0
            num_dest_regs = 0

            function_str += f"function automatic {insn_name.upper()}();\n"
            function_str += "  return "
            # Get the opcode
            assert lines[line_id+2].startswith("{bits: 7, name: "), f"Unexpected line for instruction `{insn_name}`: {lines[line_id+2]}"

            instr_word_li = 0
            and_str = ""
            for struct_line_id in range(line_id+2, len(lines)-1):
              bits_start = lines[struct_line_id].find("bits: ") + len("bits: ")
              bits_end = lines[struct_line_id].find(", name: ")
              bits = lines[struct_line_id][bits_start:bits_end]
              name_start = bits_end + len(", name: ")
              name_end = lines[struct_line_id].find("}")
              name = lines[struct_line_id][name_start:name_end]
              if name and bits:
                if name.startswith("0x"):
                  instr_word_hi = instr_word_li + int(bits)
                  function_str += f"{and_str}{instr_word_name}[{instr_word_hi-1}:{instr_word_li}] == {int(bits)}'b{bin(int(name, 16))[2:].zfill(int(bits))} "
                  and_str = " && "
                # increase low bit index also if it is a register field
                instr_word_li += int(bits)

              if lines[struct_line_id].startswith("...."):
                function_str += ";\n endfunction\n\n"
                break

            # We're done for this instruction
            break

  with (open (output_file, "w")) as f:
    f.write(function_str)

def parse_isa_scalar_crypto_listing(crypto_spec_instr_root):
  isa_listing = []
  for filename in os.listdir(crypto_spec_instr_root):
    if filename.endswith(".adoc"):
      isa_listing.append(filename.replace(".adoc", ""))
  return isa_listing

def get_isa_scalar_crypto_listing_uncompressed(isa_scalar_crypto_listing):
  """
  See get_isa_listing_uncompressed
  """
  isa_listing_uncompressed = []
  for insn in isa_scalar_crypto_listing:
    assert '_' not in insn, f"Instruction name `{insn}` contains an underscore, which is not expected in scalar crypto."
    insn = insn.upper()
    if not insn in isa_listing_uncompressed:
      isa_listing_uncompressed.append(insn)
  return isa_listing_uncompressed

def get_isa_scalar_crypto_listing():
  isa_selectio = []
  if "crypto" in extension_list:
    crypto_isa_dir = (Path(__file__).parents[1] / "input" / "scalar_crypto_insns")
    for file in crypto_isa_dir.iterdir():
      isa_selections.append(file.replace(".adoc","").upper())
    return isa_selection


# def get_isa_listing_uncompressed(isa_listing):
#   """
#   Transforms isa names to upper case, removes c_ prefix if there is one and adds the uncompressed version of the instruction
#   to the list, if its not alread in there.
#   """
#   isa_listing_uncompressed = []
#   for insn in isa_listing:
#     if not insn.startswith("c_"):
#       insn_name = insn.replace("c_", "")
#     insn_name = insn_name.upper()
#     if not insn_name in isa_listing_uncompressed:
#       isa_listing_uncompressed.append(insn_name)
#   return isa_listing_uncompressed

if __name__ == "__main__":
  isa = parse_isa(Path(__file__).parents[0] / "input" / "scalar_crypto_insns")
  print(isa)