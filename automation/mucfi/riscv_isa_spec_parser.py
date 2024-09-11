# Copyright 2024 Katharina Ceesay-Seitz, Flavien Solt, ETH Zurich.
# Licensed under the General Public License, Version 3.0, see LICENSE for details.
# SPDX-License-Identifier: GPL-3.0-only

import sys
from pathlib import Path
import re
from riscv_isa_scalar_crypto_spec_parser import parse_isa_scalar_crypto, parse_isa_scalar_crypto_listing, get_isa_scalar_crypto_listing_uncompressed, gen_isa_scalar_crypto_instr_def_sva_functions

sys.path.insert(0, str(Path(__file__).parents[1]))

def get_insn_type(line: str):
  insn_def = line.split("|")
  if len(insn_def) == 5 + 2:
    return "I"
  elif all(s in line for s in ["rs1", "rd"]) and not "rs2" in line:
    return "I"
  elif all(s in line for s in ["rs1", "rs2", "rd"]):
    return "R"
  elif all(s in line for s in ["rs1", "rs2", "rs3"]):
    return "R4"
  elif "imm[11:5]" in line:
    return "S"
  elif "imm[12\|10:5]" in line:
    return "B"
  elif "imm[31:12]" in line:
    return "U"
  elif "imm[20\|10:1\|11\|19:12]" in line:
    return "J"
  else:
    print(f"WARNING: Unsupported instruction type : {insn_def}")
    return "unknown"

def get_nr_operands(insn_type) -> int:
  if insn_type == "I":
    return 1
  elif insn_type == "R":
    return 2
  elif insn_type == "R4":
    return 3
  elif insn_type == "S":
    return 1
  elif insn_type == "B":
    return 2
  elif insn_type == "U":
    return 0
  elif insn_type == "J":
    return 0
  else:
    print(f"WARNING: Unsupported instruction type {insn_type}")
    return -1

def parse_isa(isa_file):
  isa = {}
  isa["instructions"] = {}
  with open(isa_file, "r") as f:
    lines = f.readlines()
    parsing = False
    for line in lines:
      if any(heading in line for heading in ["RV32I Base Instruction Set", "Extension"]):
        parsing = True
      elif line.strip() == "|===":
        parsing = False
      elif parsing:
        insn_def = line.split("|")
        opcode = insn_def[-2].replace("<","").strip()
        try:
          opcode_int = int(opcode, 2)
        except ValueError:
          # print(f"DEBUG: Skipping non-instr line: {line}")
          continue
        if opcode_int == 0:
          # print(f"DEBUG: Skipping non-instr line: {line}")
          continue
        insn_name = insn_def[-1].strip().replace(".", "_")
        insn_type = get_insn_type(line)
        isa["instructions"][insn_name] = {"opcode": opcode, "type": insn_type}
  return isa

def print_isa(isa):
  for insn_name, insn_info in isa["instructions"].items():
    print(f"{insn_name}: {insn_info}")


def parse_isa_listing(isa_listing_file):
  isa_listing = []
  with open(isa_listing_file, "r") as f:
    lines = f.readlines()
    for line in lines:
      if line.strip().startswith("//"):
        continue
      else:
        isa_listing.append(line.strip())
  return isa_listing

def get_isa_listing_uncompressed(isa_listing):
  """
  Transforms isa names to upper case, removes c_ prefix if there is one and adds the uncompressed version of the instruction
  to the list, if its not alread in there.
  """
  isa_listing_uncompressed = []
  for insn in isa_listing:
    if not insn.startswith("c_"):
      insn_name = insn.replace("c_", "")
    insn_name = insn_name.upper()
    if not insn_name in isa_listing_uncompressed:
      isa_listing_uncompressed.append(insn_name)
  return isa_listing_uncompressed

if __name__ == "__main__":
  isa = parse_isa(Path(__file__).parents[0] / "input" / "rv-32-64g.adoc")
  print_isa(isa)

def get_isa(isa_spec_file, isa_selection_files, crypto_spec_instr_root):
  """Parses the isa from the raw isa spec file and returns a list of instructions to use based on the isa listing file.
  The isa listing file is a list of instructions that are supported by the processor, one per line.
  Compressed instructions are replaced with their uncompressed version, if it does not already exist in the list."""
  isa = parse_isa(isa_spec_file)

  isa_selection = set()
  for isa_selection_file in isa_selection_files:
    isa_selection.update(get_isa_listing_uncompressed(parse_isa_listing(isa_selection_file)))
  isa_selection = list(isa_selection)

  if crypto_spec_instr_root is not None:
    isa_scalar_crypto = parse_isa_scalar_crypto(crypto_spec_instr_root)
    assert set(isa["instructions"].keys()).isdisjoint(isa_scalar_crypto["instructions"].keys()), f"ISA listings have common keys: {set(isa.keys()).intersection(isa_scalar_crypto.keys())}"
    isa["instructions"].update(isa_scalar_crypto["instructions"])

  return (isa, isa_selection)

def get_isa_spec_and_listing(rv_extensions):
  has_scalar_crypto = True
  bitwidth = 32

  isa_spec = Path(__file__).parents[0] / "input" / "rv-32-64g.adoc"

  isa_selections =  [(Path(__file__).parents[0] / "input" / f"isa_rv32{extension}.txt") for extension in rv_extensions]
  if bitwidth == 64:
    # No additions for 64-bit for the zifencei and zicsr extensions
    isa_selections += [(Path(__file__).parents[0] / "input" / f"isa_rv64{extension}.txt") for extension in rv_extensions if extension not in ("zifencei", "zicsr")]

  crypto_spec_instr_root = (Path(__file__).parents[0] / "input" / "scalar_crypto_insns") if has_scalar_crypto else None

  # to get a listing of all crypt instructions in the spec:
  # isa_scalar_crypto_listing = get_isa_scalar_crypto_listing_uncompressed(parse_isa_scalar_crypto_listing(crypto_spec_instr_root))

  return get_isa(isa_spec, isa_selections, crypto_spec_instr_root)