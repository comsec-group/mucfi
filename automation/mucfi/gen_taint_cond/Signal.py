# Copyright 2024 Katharina Ceesay-Seitz, ETH Zurich.
# Licensed under the General Public License, Version 3.0, see LICENSE for details.
# SPDX-License-Identifier: GPL-3.0-only
from collections import OrderedDict
import copy

class Signal:
    def __init__(self, name):
        self.name = name
        self.width = 0
        self.attributes = {}
        self.orig_name_expr = ""
        self.chunks = OrderedDict()
        self.declaration = ""

    def construct_expr(self,chunks):
        expr = ""
        for chunk in chunks.values():
            if expr:
                expr += " & "
            if chunk.lsb == 0:
                if not chunk.expr:
                    chunks_str = ", ".join([f"{k}: {v.expr}" for k,v in chunks.items()])
                    raise Exception(f"Trying to concatenate an empty chunk. Chunk 0 of signal {self.name} has no expression. It's orig name expression is {chunk.orig_name_expr}. The chunks are {chunks_str}.")
                expr += chunk.expr
            else:
                expr += f"({chunk.expr} << {chunk.lsb})"
        return expr

    def all_bits_driven(self):
        """
        Check whether each bit is part of a chunk. If there are unassigned bits, they are undriven/X. They are printed and
        the function returns False.
        """
        next_expected_msb = self.width - 1
        for range, sigchunk in self.chunks.items():
            if sigchunk.msb < next_expected_msb:
                print(f"Error: Unassigned bits in signal {self.name} in range {next_expected_msb}:{sigchunk.msb}.")
                return False
            next_expected_msb = sigchunk.lsb - 1
        if not next_expected_msb == -1:
            print(f"Error: Unassigned bits in signal {self.name} in range {next_expected_msb}:{0}.")
            return False
        return True

    def construct_orig_name_expr(self, chunks):
        """
        Returns original named expression if it has been constructed for all chunks. Otherwise returns empty string.
        """
        expr = ""
        for chunk in chunks.values():
            if not chunk.orig_name_expr:
                return ""
            if expr:
                expr += " & "
            if chunk.lsb == 0:
                expr += chunk.orig_name_expr
            else:
                expr += f"({chunk.orig_name_expr} << {chunk.lsb})"
        self.orig_name_expr = expr
        return expr

    def get_orig_name_expr(self):
        if self.orig_name_expr:
            return self.orig_name_expr
        return self.construct_orig_name_expr(self.chunks)

    def get_expr(self):
        return self.construct_expr(self.chunks)

    def add_chunk_ordered(self, range:str, sigchunk):
        """
        Insert the chunk into the chunks dictionary ordered by chunk ranges, with the range starting with MSB being the first element.
        """
        if sigchunk.msb < sigchunk.lsb:
            raise Exception(f"MSB of chunk {sigchunk} is smaller than LSB.")

        tmp_dict = copy.deepcopy(self.chunks)
        self.chunks = OrderedDict()
        inserted = False

        for existing_range, existing_sigchunk in tmp_dict.items():
            # Insert only at one position
            # Insert new item before the range where msb is smaller than the new elements lsb
            # There may be a gap in ranges
            if not inserted and existing_sigchunk.msb < sigchunk.lsb:
                self.chunks[range] = sigchunk
                inserted = True
            # Copy existing items
            self.chunks[existing_range] = existing_sigchunk

        if not inserted:
            self.chunks[range] = sigchunk
        print("Added chunk to signal: ", self.name, " with range: ", range, " and expression ", sigchunk.expr)
