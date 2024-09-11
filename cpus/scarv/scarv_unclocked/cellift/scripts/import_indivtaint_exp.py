import json
import os
from pathlib import Path
import shutil
import subprocess
import sys

if "CELLIFT_ENV_SOURCED" not in os.environ:
    raise Exception("The CellIFT environment must be sourced prior to running the Python recipes.")

CELLIFT_META_ROOT = os.getenv("CELLIFT_META_ROOT")

metadata_path = os.path.join('meta', 'cfg.json')
with open(metadata_path, 'r') as f:
    design_name = json.load(f)['verilatorprefix']

SW_NAME = 'quicktest' # Can be a path such as quick/test/somesubdir

instruction_id     = sys.argv[1]
taintassignment_id = sys.argv[2]
experiment_id      = sys.argv[3]

path_to_sw_dir = os.path.join('sw', SW_NAME)
Path(path_to_sw_dir).mkdir(parents=True, exist_ok=True)

# Copy the source
shutil.copy(os.path.join(CELLIFT_META_ROOT, 'python-experiments', 'tmp', f"tempasm_{design_name}_{instruction_id}_{taintassignment_id}_{experiment_id}.S"), os.path.join(path_to_sw_dir, 'main.S'))

# Copy the linker script
shutil.copy(os.path.join(CELLIFT_META_ROOT, 'python-experiments', 'tmp', f"temp_{design_name}_{instruction_id}.ld"), os.path.join(path_to_sw_dir, 'link.ld'))

# Compile the binary
subprocess.run(['make', '-C', path_to_sw_dir], check=True)

# # Copy the binary
# print(os.path.join(CELLIFT_META_ROOT, 'python-experiments', 'tmp', f"tempbin_{design_name}_{instruction_id}_{taintassignment_id}_{experiment_id}"))
# shutil.copy(os.path.join(CELLIFT_META_ROOT, 'python-experiments', 'tmp', f"tempbin_{design_name}_{instruction_id}_{taintassignment_id}_{experiment_id}"), os.path.join(path_to_sw_dir, 'build', 'app.elf'))
# # Dump the binary
# subprocess.run(f"riscv32-unknown-elf-objdump -D {os.path.join(path_to_sw_dir, 'build', 'app.elf')} > {os.path.join(path_to_sw_dir, 'build', 'app.elf.dump')}", shell=True, check=True)

# Copy the taint file
shutil.copy(os.path.join(CELLIFT_META_ROOT, 'python-experiments', 'tmp', f"temptaint_{design_name}_{instruction_id}_{taintassignment_id}_{experiment_id}.txt"), os.path.join('taint_data', SW_NAME, 'taint_data.txt'))
