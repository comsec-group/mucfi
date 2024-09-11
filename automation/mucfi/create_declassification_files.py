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

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Based on the operands assignments templat, this script replaces the operand name placeholders with the operands of a specific CPU.')
    parser.add_argument('--config_file', dest='config_file', type=str, required=True, help='File containing signal names and other CPU-specific configs' )
    args = parser.parse_args()

    config = parse_config(args.config_file)

    # Create an entry per signal to be abstracted in declassifiedSigs
    # declassify: REGISTER_WRITE_SIGNALS and FORWARDING_OUTPUTS
    # abstract: FWD_MUX_SELECTS

    declass_script_dir = Path(config["OUT_DIR"]) / "formal" / "scripts"
    declass_script_dir.mkdir(parents=True, exist_ok=True)
    declass_sigs = []

    with open (declass_script_dir / "declass.tcl", "w") as f:
        f.write("set declassifiedSigs {\n")
        for sig in config["REGISTER_WRITE_SIGNALS"].replace('"', '').split(","):
            if not sig in declass_sigs: # avoid duplicates
                declass_sigs.append(sig)
        for sig in config["FORWARDING_OUTPUTS"].replace('"', '').split(","):
            if sig and (not sig in declass_sigs):
                declass_sigs.append(sig)
        for sig in declass_sigs:
            f.write(f"  \"{(sig)}_t0\"\n")

        # Only abstract the design! not the taint signal, and do not declassify anything
        for sig in config["FWD_MUX_SELECTS"].replace('"', '').split(","):
            f.write(f"  \"{(sig)}\"\n")
        f.write("}\n")

    # Create no taint assumptions for the signals in declassifiedSigs that need to be declassified
    declass_asm_dir = Path(config["OUT_DIR"]) / "formal" / "assumptions"
    with open(declass_asm_dir / (config["TOP_MODULE"] + "_declass_asm.sv"), "w") as f:
        for sig in declass_sigs:
            f.write(f"asm_declass_{get_expanded_path(sig)}_t0: assume property(!{get_expanded_path(sig)}_t0);\n")
