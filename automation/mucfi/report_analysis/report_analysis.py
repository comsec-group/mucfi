# Copyright 2024 Katharina Ceesay-Seitz, ETH Zurich.
# Licensed under the General Public License, Version 3.0, see LICENSE for details.
# SPDX-License-Identifier: GPL-3.0-only

from pathlib import Path
import os
import shutil
import argparse
import sys
import pandas as pd
import csv
from collections import OrderedDict
import datetime

# Parent must be inserted before the current directory for Python to recognize fpv_core_setup as package
sys.path.insert(0, str(Path(__file__).parents[1]))
from riscv_isa_spec_parser import *
from riscv_isa_scalar_crypto_spec_parser import parse_isa_scalar_crypto, parse_isa_scalar_crypto_listing, get_isa_scalar_crypto_listing_uncompressed, gen_isa_scalar_crypto_instr_def_sva_functions

def get_instr_name(prop_name):
  # better filter for known instr names
  # for now we search for upper case letters and op1/2
  ind_op = prop_name.find("_op")
  if ind_op == -1:
    raise Exception(f"Could not find op in prop_name {prop_name}")
  ind_instr = prop_name[:ind_op].rfind("_")
  instr_name = prop_name[ind_instr+1:ind_op]
  return instr_name


def result_to_csv(report_file, out_file):
  """
  instr, op, result, time, engine,
  """
  results = []
  with open(report_file, 'r') as f:
    for line in f:
      if "as_no_pc_taint_ever" in line and ("proven" in line or "cex" in line):
        result = []
        split_line = line.split()
        prop_name = split_line[1]
        instr_name = get_instr_name(prop_name)
        result.append(instr_name)
        print(instr_name)
        print("op" + prop_name[prop_name.find("_op")+3])
        result.append("op" + prop_name[prop_name.find("_op")+3])
        for i in range(2, 6):
          result.append(split_line[i])
        results.append(result)
    df = pd.DataFrame(results, columns=["instr", "op", "result", "engine", "bound", "seconds"])
    df.to_csv(out_file, index=False)


def all_results(csv_name_list, isa, isa_selection,results_file_name):

  # Create an empty results table
  results = OrderedDict()
  for instr in isa_selection:
    if not instr in results.keys():
        results[instr] = OrderedDict()
    nr_ops = get_nr_operands(isa[instr]["type"])
    for n in range(0,nr_ops):
      if not n in results[instr].keys():
        results[instr][n] = []

  for i in range(0, len(csv_name_list)):
    df = pd.read_csv(csv_name_list[i])
    for instr in isa_selection:
      df_instr = df[df["instr"] == instr]
      if len(df_instr) == 0:
        for n in results[instr].keys():
          results[instr][n].append("-")
      else:
        assert len(df_instr) == len(results[instr].keys()), f"ERROR: {instr} has {len(results[instr].keys())} operands but csv {csv_name_list[i]} has {len(df_instr)} entries for this instruction: {df_instr}"
        for n in results[instr].keys():
          row = df_instr.iloc[n]
          results[instr][n].append(row["result"])

  results_file_name, results_per_instr = gen_result_csv_per_instr_op(results, csv_name_list, group_ops_with_same_results=True, isa_selection=isa_selection,results_file_name=results_file_name)

  gen_latex_table(results_per_instr)


def extract_runtimes(csv_name_list):

  results = []
  cex_avg = []
  proof_avg = []
  proof_max = []
  total = []
  for i in range(0, len(csv_name_list)):
    df = pd.read_csv(csv_name_list[i])
    print(df)
    cex = df.loc[df["result"] == "cex", "seconds"].apply(pd.to_numeric, errors='coerce')
    # cex =pd.to_numeric(df_cex, errors='coerce')
    #proof =pd.to_numeric(df.loc[df["result"] == "Infinite"], errors='coerce')
    proof = df.loc[df["result"] == "proven", "seconds"].apply(pd.to_numeric, errors='coerce')
    total_secs = pd.to_numeric(df["seconds"], errors='coerce')
    # cex_avg.append(cex[:, "seconds"].mean())
    # proof_avg.append(proof[:, "seconds"].mean())
    # proof_max.append(proof[:, "seconds"].max())
    # df_seconds = pd.to_numeric(df[:, "seconds"], errors='coerce')
    # total.append(df_seconds.sum())
    cex_avg.append(cex.mean())
    proof_avg.append(proof.mean())
    proof_max.append(proof.max())
    total.append(total_secs.sum())

  print("Design & " + " & ".join([csv.name for csv in csv_name_list]) + "\\\\\n")
  print("Mean time to FAIL & " + " & ".join(  [str(datetime.timedelta(seconds=ca)).split(".")[0]  for ca in cex_avg]) + "\\\\\n")
  print("Mean time to PROVE & " + " & ".join([str(datetime.timedelta(seconds=pa)).split(".")[0]  for pa in proof_avg]) + "\\\\\n")
  print("Max. time to PROVE & " + " & ".join([str(datetime.timedelta(seconds=pm)).split(".")[0]  for pm in proof_max]) + "\\\\\n")
  print("Total & " + " & ".join(             [str(datetime.timedelta(seconds=t) ).split(".")[0]for t in total]) + "\\\\\n")



def gen_result_csv_per_instr_op(results, csv_name_list, group_ops_with_same_results, isa_selection, results_file_name='results.csv'):
  header = ["INSTR", "OP"]
  header.extend([Path(name).name for name in csv_name_list])
  row_list = [header]
  for instr in isa_selection:
    row_list_ops = []
    last_row_results = []
    different_results_per_op = False
    for op in results[instr]:
      row = []
      row.extend([instr, f"rs{op+1}"])
      row.extend(results[instr][op])
      if last_row_results and last_row_results != results[instr][op]:
        different_results_per_op = True
      row_list_ops.append(row)
    if row_list_ops:
      if group_ops_with_same_results:
        if not different_results_per_op:
          op_grouped_result = row_list_ops[0]
          op_grouped_result[1] = "rs1-2"
          row_list.append(op_grouped_result)
      else:
        row_list.extend(row_list_ops)

  with open(results_file_name, 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerows(row_list)
  return results_file_name, row_list

def gen_latex_table(results):
  latex_str = ""
  for row in results:
    row_str = " & ".join([s.replace("_", "\_") for s in row])
    row_str += "\\\\"
    latex_str += row_str + "\n"
  print(latex_str)




if __name__ == "__main__":
  parser = argparse.ArgumentParser(description='Analzes Jasper Gold reports of the PC taint property')
  parser.add_argument('--report_file', dest='report_file', type=str, required=False, help='Input report file')
  parser.add_argument('--results_file_name', dest='results_file_name', default="results.csv", type=str, required=False, help='Output file')
  parser.add_argument('--result_to_csv', dest="result_to_csv", type=bool, required=False, help='Print as_no_pc_taint_ever result per instruction, print taint state results per instr')
  # parser.add_argument('--timing_to_csv', dest="timing_to_csv", type=bool, required=False, help='Print as_no_pc_taint_ever result per instruction, print taint state results per instr')
  parser.add_argument('--csvs_to_time_latex_table', dest="csvs_to_time_latex_table", type=bool, required=False, help='Transform csv data from csv_name_list into a latex table')
  parser.add_argument('--csvs_to_result_latex_table', dest="csvs_to_result_latex_table", type=bool, required=False, help='Transform csv data from csv_name_list into a latex table')
  parser.add_argument('--csv_name_list', dest="csv_name_list", type=str, required=False, help='Print as_no_pc_taint_ever result per instruction, print taint state results per instr')
  parser.add_argument('--csv_dir', dest="csv_dir", type=str, required=False, help='A directory that stores CSVs generated with the result_to_csv flag, which should be combined into one Latex table (probably you want a sub dir of dir input)')
  parser.add_argument('--out_dir', dest="out_dir", type=str, required=False, help='Output directory where the result CSVs shall be stored.')

  args = parser.parse_args()

  print("Analyzing report file: " + args.report_file)

  out_file_name = ""
  if (args.result_to_csv):
    outdir = ""
    if not args.out_dir:
      outdir = Path(__file__).parents[0] / "generated"
    else:
      outdir = Path(args.out_dir)
    outdir.mkdir(parents=True, exist_ok=True)
    if (args.results_file_name):
      results_file_name = args.results_file_name
    else:
      results_file_name = "results"
    out_file_name = outdir / (results_file_name + ".csv")
    result_to_csv(args.report_file, out_file_name)

  csv_names = []
  if args.csv_dir:
    csv_dir = Path(args.csv_dir)
    for file in csv_dir.iterdir():
      csv_names.append(file)

  if (args.csvs_to_result_latex_table):
    # rv_extensions = "i,m,zicsr,zifencei,crypto"
    rv_extensions = "i,m,zicsr,zifencei"
    isa, isa_selection = get_isa_spec_and_listing(rv_extensions.split(","))

    if csv_names:
      all_results(csv_names, isa["instructions"], sorted(isa_selection), args.results_file_name)
    elif args.results_file_name:
      all_results([out_file_name], isa["instructions"], sorted(isa_selection), args.results_file_name)

    # if args.csv_name_list:
    #   csvs_to_latex_table(args.csv_name_list.split(","), "i,m,zicsr,zifencei,crypto")
    # else:
    #   print("arg csv_name_list missing")

  if(args.csvs_to_time_latex_table):
    if not csv_names:
      extract_runtimes([out_file_name])
    extract_runtimes(csv_names)
