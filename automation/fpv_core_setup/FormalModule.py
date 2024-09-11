# Copyright 2024 Katharina Ceesay-Seitz, ETH Zurich.
# Licensed under the General Public License, Version 3.0, see LICENSE for details.
# SPDX-License-Identifier: GPL-3.0-only

from pathlib import Path

class FormalModule:
    def __init__(self, outdir: Path, top_module):
        self.outdir = outdir
        self.top_module = top_module
        self.file_path = outdir / (top_module + "_fpv.sv")
        self.ports = dict() # key: wire name in formal module, value: bitwidth

    def gen_module_header_port_str(self):
        """
        Generates:
        (portname, portname, portname, ...)
        """
        s = "(\n"
        s += ",\n".join(self.ports.keys())
        s += ")"
        return s

    def gen_signal_declarations(self):
        """
        Generates:
        input logic [bitwidth:0] sig_name;
        input logic sig_name;
        TODO: what about arrays or enums etc? does Yosys always relsove these? Input here is a Yoysys generated file
              Array case may be solved by escaping sigs if yosys alywas generates individual sigs per element: signame[pos]. Not verified.
        ...
        """
        s = ""
        for sig_name, bitwidth in self.ports.items():
            s += "input logic "
            if bitwidth > 1:
                s += f"[{bitwidth-1}:0] "
            s += sig_name + ";\n"
        return s

    def gen_file(self):
        module_header_port_str = self.gen_module_header_port_str()
        sig_declarations = self.gen_signal_declarations()

        s = f"module {self.top_module}_fpv \n"
        s += module_header_port_str + ";" + "\n" * 3 + sig_declarations + "\n" * 2
        s += "`include `PROPERTIES_FILE" + "\n" * 2
        s += "endmodule\n"
        with open(self.file_path, "w") as f:
            f.write(s)

    def add_signal(self, sig_name, bitwidth):
        self.ports[sig_name] = bitwidth