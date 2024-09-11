# Copyright 2024 Katharina Ceesay-Seitz, ETH Zurich.
# Licensed under the General Public License, Version 3.0, see LICENSE for details.
# SPDX-License-Identifier: GPL-3.0-only

import argparse
import os
from pathlib import Path
import sys

sys.path.insert(0, str(str(Path(os.path.realpath(__file__)).parents[1])))
from common.util import *
from common.util_hier_paths import *

op1_placeholder = "cpuregs_rs1"
op2_placeholder = "cpuregs_rs2"

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Based on the operands assignments templat, this script replaces the operand name placeholders with the operands of a specific CPU.')
    parser.add_argument('--config_file', dest='config_file', type=str, required=True, help='File containing signal names and other CPU-specific configs' )
    parser.add_argument('--operand_file_template', dest='operand_file_template', type=str, required=True, help='Template file containing the operand assignment placeholders' )
    args = parser.parse_args()

    config = parse_config(args.config_file)

    with open (args.operand_file_template, "r") as f:
        txt = f.read()
        operand1, operand2 = config["REGISTER_READ_SIGNALS"].replace('"', '').split(",")
        txt = txt.replace(op1_placeholder, flatten_signal_path(operand1).replace("\\", ""))
        txt = txt.replace(op2_placeholder, flatten_signal_path(operand2).replace("\\", ""))
    sig_dir = Path(config["OUT_DIR"]) / "formal" / "signal_defs"
    sig_dir.mkdir(parents=True, exist_ok=True)
    with open (sig_dir / "operand_assignments_first.sv", "w") as f:
        f.write(txt)

