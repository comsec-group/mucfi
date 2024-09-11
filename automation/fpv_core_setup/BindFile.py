# Copyright 2024 Katharina Ceesay-Seitz, ETH Zurich.
# Licensed under the General Public License, Version 3.0, see LICENSE for details.
# SPDX-License-Identifier: GPL-3.0-only

from pathlib import Path
import sys

sys.path.append(str(Path(__file__).parents[1]))

from common.util_hier_paths import *

class BindFile:
    def __init__(self, outdir: Path, top_module):
        self.outdir = outdir
        self.top_module = top_module
        self.file_path = outdir / (top_module + "_bind.sv")
        self.ports = dict() # key: wire name in formal module, value: hierarchical path to sig in design

    def gen_port_connection_str(self):
        """
        Generates:
        ...
        .module_submodule__name(
          module.submodule.name
        ),
        ...
        no comma after last port connection
        """
        cons = list()
        for sig_name, sig_hier_path in self.ports.items():
            cons.append(
                "." + sig_name + "(\n" + \
                "  " + sig_hier_path + ")")
        return ",\n".join(cons) + "\n"

    def add_signal(self, sig_name, sig_hier_path):
        self.ports[sig_name] = sig_hier_path

    def gen_file(self):
        s = f"bind {self.top_module} {self.top_module}_fpv {self.top_module}_fpv_bind (\n"
        s += self.gen_port_connection_str()
        s += ");\n"
        with open(self.file_path, "w") as f:
            f.write(s)