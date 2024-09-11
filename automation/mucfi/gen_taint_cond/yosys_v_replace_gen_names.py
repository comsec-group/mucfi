# Copyright 2024 Katharina Ceesay-Seitz, ETH Zurich.
# Licensed under the General Public License, Version 3.0, see LICENSE for details.
# SPDX-License-Identifier: GPL-3.0-only

# This tool reconstructs
# Input has to be a Yosys generated Verilog file (generated with write_verilog command of the verilog_backend.cc
# parse the file stripped_line by stripped_line
# collect attirbutes with regex: /* attr_name = some_str */
# when finding one of the keywords: module, wire (now only wire)
# create a new wire object with the attributes
# wire _002_
# find the assignments, store them to the wire
# assign _002_ = _001_ & _000_;
# build up string
# replace assignment rhs _001_ with assignment rhs of _001_
# same for _000_
# only replace sigs that have the _nr_ pattern
# -> finally should have the original names
# if a wire, eg.. _001_ has the uc_past attribute, put $(past) around it.
# ... maybe better to create an always block, could use a jinjer template.
# For now it seemed to work with Jasper with $past, but it could be differently intereted by other
# tools, so better to use always block.

# Currently one global clock is assumed, so clock signals are not extracted from always blocks.

import argparse
import copy
import regex as re
from Wire import Wire
from Module import Module
from Reg import Reg
from Signal import Signal
from SignalChunk import SignalChunk

modules = {}
log_level = 1


range_pattern = r"(?P<range>\[(?P<msb>\d+)(?:\:(?P<lsb>\d+))?\])"
verilog_escaped_name_pattern = r"\\.+? "
verilog_signal_name_pattern = r"[A-Za-z0-9\-\._]+"
auto_name_pattern = re.compile(r"(?:\W|\s)(?P<wire_name>_\d+_)\s*" + range_pattern + r"?")
auto_name_only_pattern = re.compile(r"(?P<wire_name>_\d+_)")
# This pattern matches auto generated or orignal signal names consisting of letters, numbers, underscores and hierarchical dots (not checking for any correct placement).
# It also matches Verilog escaped names, e.g. \genblk2.pcpi_div.quotient_msk with a trailing space
# and arbitrary characters within the \ and the space.
signal_name_pattern = re.compile(r"(?:\W|\s)(?P<wire_name>(?:" + verilog_signal_name_pattern + "|" + verilog_escaped_name_pattern + r"))\s*" + range_pattern + r"?")

def log(msg, level=0):
    if level >= log_level:
        print(msg)

# The simplification might not be accurate in some cases
# Replacing & 1'b1 with nothing is a heuristic, because in some cases this might be needed for bit selection
def simplify_reconstructed_expr(expr):
    simplified_expr = expr
    # replace unnecessary muxes: (\u_if.u_rf.regwr_en  ?  1'h1 : 1'h0) with \u_if.u_rf.regwr_en
    unnecessary_muxes = re.compile(r"\(\s*(?P<cond>.+?)\s*\?\s*1'h1\s*:\s*1'h0\s*\)")
    for match in unnecessary_muxes.finditer(simplified_expr):
        simplified_expr = simplified_expr.replace(match.group(0), match.group("cond"))
        if not match.group("cond"):
            raise Exception("Could not find condition in mux: " + match.group(0))
    # replace unnecessary ands: (\u_if.u_rf.regwr_en  &  1'h1) with \u_if.u_rf.regwr_en
    simplified_expr = simplified_expr.replace(" & 1'b1","") # this is a heuristic, in some cases this might be needed for bit selection
    simplified_expr = simplified_expr.replace(" & 1'h1","") # this is a heuristic, in some cases this might be needed for bit selection
    # replace unnecessary ands: (\u_if.u_rf.regwr_en  & 1'h0) with 1'h0
    unnecessary_ands = re.compile(r"\s*\(\s*(?P<sig>[^()]+?)\s*&\s*1'h0\s*\)")
    for match in unnecessary_ands.finditer(simplified_expr):
        simplified_expr = simplified_expr.replace(match.group(0), " 1'b0")
    # replace unnecessary ors: (\u_if.u_rf.regwr_en  |  1'h0) with \u_if.u_rf.regwr_en TODO
    return simplified_expr

def replace_yosys_gen_names(filename, module_name, signal_name):
    parse_modules(filename)
    sig_to_replace = modules[module_name].signals[signal_name]
    register_definitions = []
    modules[module_name].signals[signal_name].orig_name_expr = reconstruct_orig_name_expr_for_sig(sig_to_replace, module_name, register_definitions)

    print('--- end debug output ---')
    print()
    print()
    print("Reconstructed orignal name expression for " + signal_name + ":\n")
    reconstructed_expr = signal_name + " = " + modules[module_name].signals[signal_name].get_orig_name_expr() + ";\n"
    reconstructed_expr += "\n".join(register_definitions).replace(";", ";\n")
    # reconstructed_expr += str(modules[module_name].signals[signal_name].attributes)
    print(reconstructed_expr)
    return reconstructed_expr


def create_sigchunk_from_matchgroup(sig):
    msb = 0
    lsb = 0
    if sig.group("lsb"):
        msb = int(sig.group("msb"))
        lsb = int(sig.group("lsb"))
    elif sig.group("msb"):
        msb = int(sig.group("msb"))
        lsb = msb
    sigchunk = SignalChunk(msb, lsb)

    if not sig.group("range"):
        sigchunk.range = ""
        sigchunk.width = 0
    return sigchunk

def width_to_range(width : int) -> str:
    if width == 1:
        return "[0]"
    return "[" + str(width - 1) + ":0]"

def past(expr):
    return "$past(" + expr + ")"

def reconstruct_orig_name_expr_for_sig(sig_to_replace, module_name, register_definitions : list()):
    start_sig_chunk = SignalChunk(sig_to_replace.width-1, 0)
    start_sig_chunk.set_expr(sig_to_replace.get_expr())
    orig_name_expr = reconstruct_orig_name_expr_for_chunk(modules[module_name], sig_to_replace.name, start_sig_chunk,{}, register_definitions)
    if isinstance(sig_to_replace, Reg) or \
        (isinstance(sig_to_replace, Wire) and sig_to_replace.attributes.get("uc_past")):
        orig_name_expr = past(start_sig_chunk.orig_name_expr)
    return orig_name_expr

# Idea: parse the expression with pyverilog and then construct the orig_name_expr as ast with pyverilog's
# code generator. Then we can simplify the expression easily by dropping useless and/or's.
def reconstruct_orig_name_expr_for_chunk(module, signal_name, start_chunk, already_visited, register_definitions : list()):
    """
    Iterates through all occurances of auto named signals in auto_sig's expression and recursively calls this function for each of them.
    The function adds the current signal to the already visited ones to catch combinational loops.
        Combinational loops are treated as errors, because no valid design should contain them. They might never stabilize to a steady state.
        The generated signals that we reconstruct for example when creating the update condition only contain loops if the Yosys pass is buggy.
    If an auto named signal is partially selected, the name  is replaced and the selection is replaced with a bitmask.
    For auto generated registers (which are rare), the register and its always block with replacement needs to be stored. That means that the final output will be a condition plus potentially auto generated registers with always blocks where their rhs auto generated signals are replaced with origninal name expressions. This approach is cleaner than generating $past() expressions for the auto generated registers. Generally, we should avoid using $past() in the update condition, because tools need to infer registers and might treat such assignments inconsistently (Cadence Jasper gives a warning that a $past() in an assignement is not recommended).

    Parameters:
      already_visted:        A dictionary that for each modules contains a further dictionary that for each signal name contains a list of SignalChunks.
      register_definitions:  The function fills this list with the necessary temporary register definition strings.

    Returns either the orignal expression of auto_sig, if it alreay exists, otherwise it calls this function recursively for all signals to replace in
    auto_sig's expression from left to right.
    """

    # Return existing original name expression, if this signal has already been visited
    if start_chunk.orig_name_expr:
        # print("Returning existing orig_name_expr: " + start_chunk.orig_name_expr)
        return start_chunk.orig_name_expr

    print("")
    log("Searching for auto sigs in " + signal_name + start_chunk.range + " with expression " + start_chunk.expr, 1)

    already_visited_with_current = copy.deepcopy(already_visited)
    if already_visited_with_current:
        if signal_name in already_visited_with_current[module.name].keys():
            already_visited_with_current[module.name][signal_name].append(start_chunk)
        else:
            already_visited_with_current[module.name][signal_name] = [start_chunk]
    else:
        already_visited_with_current = {module.name: {signal_name: [start_chunk]}}
    log("Added " + signal_name + start_chunk.range + " to already visited: " + str(already_visited),0)

    orig_name_expr = start_chunk.expr

    # Search if there are any auto named signals to replace
    # Example: _1_ = { _2_, _3_, _4_};
    # If all these _autosignals_ are 1 bit wide and start_sig_chunk is [2:1], we are now iterating through _2_, _3_. _4_ is the epxression of the next start_sig_chunk
    auto_sigs = [match for match in auto_name_pattern.finditer(orig_name_expr)]
    for auto_sig in auto_sigs:
        auto_sig_chunk = create_sigchunk_from_matchgroup(auto_sig)
        wire_name = auto_sig.group("wire_name")

        declared_chunk = None
        if modules[module.name].signals.get(wire_name):
            declared_chunk = modules[module.name].signals[wire_name].chunks.get(auto_sig_chunk.range)
        else:
            raise Exception("Found a signal name on the rhs for which we have no declaration: " + wire_name + " in expression " + orig_name_expr)

        # Check for combo loop per chunk that is replaced, and per replacement chunk.
        # If the chunks refers to a past clock cycle, we do not need to check for combo loops.
        # improvement: registers that are assigned with their previous value should not be flagged as combo loops.
        if (not declared_chunk or not declared_chunk.past) and module.name in already_visited.keys() and wire_name in already_visited[module.name].keys():
            for visited_chunk in already_visited[module.name][wire_name]:
                if (auto_sig_chunk.lsb >= visited_chunk.lsb and auto_sig_chunk.lsb <= visited_chunk.msb) or (auto_sig_chunk.msb <= visited_chunk.msb and auto_sig_chunk.msb >= visited_chunk.lsb):
                    raise Exception("Signal " + signal_name + " has a combo loop in its expression: " + orig_name_expr + ". " + wire_name + f"[{auto_sig_chunk.msb}:{auto_sig_chunk.lsb}] has been already replaced.")

        # if we found the exact chunk, we can simply replace its mentioning in the input expression
        # otherwise we have to replace it with the bitmasked replacement expression of the full wire
        if declared_chunk:
            print("Going to replace chunk " + wire_name + auto_sig_chunk.range + " in " + orig_name_expr)
            replacement = reconstruct_orig_name_expr_for_chunk(module, wire_name, declared_chunk, already_visited_with_current, register_definitions)
            if declared_chunk.past:
                replacement = past(replacement)
            if not replacement:
                raise Exception("Replacement for " + wire_name + " is empty.")
            orig_name_expr = orig_name_expr.replace(wire_name + (auto_sig.group("range") if auto_sig.group("range") else ""), replacement)
        else:
            if (type(modules[module.name].signals[wire_name]) == Wire):
                replacement = reconstruct_orig_name_expr_for_chunk(module, wire_name,
                                                                   modules[module.name].signals[wire_name].chunks[width_to_range(modules[module.name].signals[wire_name].width)], already_visited_with_current,
                                                                   register_definitions)

                # If we are replacing a range of the auto sig which is smaller than the full bitwidth of that signal, we select a chunk with a bitmask
                if auto_sig.group("range") and not auto_sig.group("range") == width_to_range(modules[module.name].signals[wire_name].width):
                    if not auto_sig_chunk.bitmask:
                            raise Exception("Expected a bitmask for " + wire_name + auto_sig_chunk.range + " but got none.")
                    if auto_sig_chunk.lsb == 0:
                        replacement = f"{replacement} & {auto_sig_chunk.bitmask}"
                    else:
                        if not auto_sig_chunk.lsb:
                            raise Exception("Expected a lsb for " + wire_name + auto_sig_chunk.range + " but got none.")
                        replacement = f"({replacement} >> {auto_sig_chunk.lsb}) & {auto_sig_chunk.bitmask}"
                if modules[module.name].signals[wire_name].attributes.get("uc_past"):
                    replacement = past(replacement)

                print("Replacing " + wire_name + " with " + replacement + "... in " + orig_name_expr)
                if not replacement:
                    raise Exception("Replacement for " + wire_name + " is empty.")
                orig_name_expr = orig_name_expr.replace(wire_name + (auto_sig.group("range") if auto_sig.group("range") else ""), replacement)

            elif (type(modules[module.name].signals[wire_name]) == Reg):
                tmp_reg_name = "tmp" + wire_name.replace("_","")
                orig_name_expr = orig_name_expr.replace(wire_name, tmp_reg_name)

                tmp_sig_chunk = SignalChunk(modules[module.name].regs[wire_name].width-1, 0)
                tmp_sig_chunk.expr = modules[module.name].regs[wire_name].get_expr().replace(wire_name, tmp_reg_name)
                if not tmp_sig_chunk.expr.startswith("always"):
                    raise Exception("Expected always block for register " + wire_name + " but got: " + tmp_sig_chunk.expr)

                tmp_declaration = modules[module.name].regs[wire_name].declaration.replace(wire_name, tmp_reg_name)
                if not tmp_declaration in register_definitions:
                    register_definitions.insert(0,tmp_declaration)
                    register_definitions.append(reconstruct_orig_name_expr_for_chunk(module, wire_name,
                                                                                    tmp_sig_chunk,
                                                                                    already_visited_with_current,
                                                                                    register_definitions))
            else:
                raise Exception(f"{modules[module.name].signals[wire_name]} is neither a Wire nor a Reg.")


    # print("Replacing auto expr of " + signal_name + start_chunk.range + " with " + orig_name_expr)
    start_chunk.orig_name_expr = orig_name_expr
    if "& )" in orig_name_expr:
        raise Exception("Found a syntax error '& )' in the expression of " + signal_name + start_chunk.range + ": " + orig_name_expr)
    return start_chunk.orig_name_expr


def extract_attributes(expr):
    # pattern = re.compile(r'/\* \S+ = ".*" \*/') - often attrs have a value, but could also be "e.g. /* verilator public */;"
    pattern = re.compile(r'/\*.*\*/')
    attrs = re.findall(pattern,expr)
    trimmed_expr = expr
    for attr in attrs:
        trimmed_expr = trimmed_expr.replace(attr,"")
    return trimmed_expr, attrs

def check_for_undriven_bits(signals):
    for signalname, signal in signals.items():
        if re.match(auto_name_only_pattern, signalname) and not signal.all_bits_driven():
            log("Signal " + signal.name + " does not have an assignment for all its bits.")
            return False
    return True

def combine_chunks(signals):
    # We should have collected an assignment for each bit of each wire. Otherwise there are undriven (X) bits in the design.
    if not check_for_undriven_bits(signals):
        raise Exception("ERROR: Some signals have undriven bits.")
    for signalname, signal in signals.items():
        if re.match(auto_name_only_pattern, signalname):
            range = width_to_range(signal.width)
            if not signal.chunks.get(range):
                combined_expr = signal.get_expr()
                signal.chunks[range] = SignalChunk(signal.width-1, 0)
                signal.chunks[range].set_expr(combined_expr)

def parse_modules(filename):
    """
    This function parses the Yosys generated Verilog file and creates a list of modules,
    with their wires and regs. It saves the assigned expressions to the wires and regs.
    Expecting properly formatted (System)Verilog files, dumped by Yosys.

    Currently adapted to Yosys version Yosys 0.29+11 (gcc 10.3.0-1ubuntu1~18.04~1 -Og -fPIC).
    Parsing is very simple and relies on Yosys' output format, which is not expected to change frequently.

    For the moment module header is expected to have this format:
    module <module_name> (<port_list>);

    To replace assignments to conjunctions, e,g, assign {_1_, _2_} = _3_ & _4_;
    You can have _1_ assigned in multiple assignments if they are targeting different bit slices.
    This function stores all chunks. A Signal can construct the full expression out of the chunks.

    Assignments to signal selections get shifted by the lsb of the selection and and'ed with a bitmasks of the selection's width.
    E.g. assign _1_[32] = _2_ & 3; ... becomes: (_2_ & _3_) >> 32 & 1'b1;
    """
    attr_pattern = re.compile(r"/\*\s+(?P<attr_name>\S+)\s+=\s+(?P<attr_value>\S+)\s+\*/")
    with open(filename, "r") as f:
        attributes = {}
        wires = {}
        regs = {}
        curr_module_name = ""
        l = 0
        file = f.readlines()
        while (l < len(file)):
            stripped_line = file[l].strip()
            match = re.match(attr_pattern, stripped_line)
            if match:
                attributes[match.group("attr_name")] = match.group("attr_value")
            elif stripped_line.startswith("module"):
                # stripped_line expected to have this format:
                # module <module_name> (<port_list>);
                # with any number of spaces around the name
                param_list_start = stripped_line.find("(")
                module_name = stripped_line[6:param_list_start].strip()
                curr_module_name = module_name
                module = Module(module_name)
                module.attributes = copy.deepcopy(attributes)
                modules[module_name] = module
                log("Created module: " + module.name + "\n with attributes: " + str(module.attributes), 0)
                attributes = {}
                wires = {}
            elif stripped_line.startswith("wire") or stripped_line.startswith("reg"):
                stripped_line, unused_inline_attrs = extract_attributes(stripped_line)
                wire_decl_pattern = re.compile(r"\s*(?P<type>(reg)|(wire))\s*(?P<range>\[(?P<msb>\d+)(?:\:(?P<lsb>\d+))?\])?\s*(?P<wire_name>(?:" + verilog_signal_name_pattern + "|" + verilog_escaped_name_pattern + r"))\s*;")
                match = re.match(wire_decl_pattern, stripped_line)
                if match:
                    wire_name = match.group("wire_name")
                    # Store the space that terminates escaped wire names
                    if wire_name.startswith("\\") and not wire_name[-1] == " ":
                        wire_name = wire_name + " "
                        raise Exception("Wire name " + wire_name + " is not terminated with a space. Thought I fixed the regex to support this. Coming from " + stripped_line)
                    signal_type = match.group("type")
                    wire = None
                    if signal_type == "reg":
                        wire = Reg(wire_name)
                    else:
                        wire = Wire(wire_name)
                    if match.group("range"):
                        wire.width = int(match.group("msb")) - int(match.group("lsb")) + 1
                    else:
                        wire.width = 1
                    wire.attributes = copy.deepcopy(attributes)
                    attributes = {}
                    wire.declaration = stripped_line
                    if signal_type == "reg":
                        regs[wire_name] = wire
                    else:
                        wires[wire_name] = wire

                # TODO: improvement: store also original named wires so that we know their length and can simplify the generated expression
            elif stripped_line.startswith("assign"):
                # examples: assign { _08957_[62:32], _08951_[62:31] } = _02860_ | _05941_;
                # assign _1_[32] = ....;
                # assign _1_ = ..\n..;

                # First, check if we encountered a multiline assignment
                while (not ";" in stripped_line and l+1 < len(file)):
                    l += 1
                    stripped_line += file[l].strip()
                if l == len(file):
                    raise Exception("File ended before the last assignment ended. Got: " + stripped_line)

                split_line = stripped_line.split("=")

                # Extract the signal names on the left hand side of the assignment
                lhs = split_line[0]
                lhs_signals = [match for match in signal_name_pattern.finditer(lhs[len("assign"):])]

                rhs = "=".join(split_line[1:]).replace(";","").lstrip() # using lstrip, because strip could strip the space from an escaped name

                # Discard all inline attributes, OPTION: store them
                wire_expr, attrs = extract_attributes(rhs)

                # Iterate over the signals on the left hand side of the assignment to be able to construct
                # the bit offset of signals in a concatenated assignment
                # Iterating in reversed order to be able to calculate the offset of each chunk
                concatenation_offset = 0
                for sig in reversed(lhs_signals):
                    # examples: ('_08957_', '[31:0]', '31', '0')
                    # examples: ('_08957_', '', '', '')
                    # examples: ('_2_', '[0]', '0', '')
                    wire_name = sig.group("wire_name")
                    if not wires.get(wire_name):
                        for wire in wires:
                            print(wire)
                        raise Exception("ERROR: Wire " + wire_name + " not found in wire list  but found an assignment: " + stripped_line)

                    if not sig.group("range"):
                        full_range = width_to_range(wires[wire_name].width)
                        wires[wire_name].chunks[full_range] = SignalChunk(wires[wire_name].width-1, 0)
                        wires[wire_name].chunks[full_range].set_expr(wire_expr)
                        if wires[wire_name].attributes.get("uc_past"):
                            wires[wire_name].chunks[full_range].past = True
                        concatenation_offset += wires[wire_name].width
                        # log("Added expression to wire " + wire_name + ": " + wires[wire_name].expr, 0)
                    else:
                        sigchunk = create_sigchunk_from_matchgroup(sig)
                        if not sigchunk.bitmask:
                            raise Exception("Expected a bitmask for " + wire_name + sigchunk.range + " but got none.")
                        if concatenation_offset == 0:
                            sigchunk.set_expr(f"({wire_expr}) & {sigchunk.bitmask}")
                        else:
                            if not concatenation_offset:
                                raise Exception("Expected a concatenation offset for " + wire_name + sigchunk.range + " but got none.")
                            sigchunk.set_expr(f"(({wire_expr}) >> {concatenation_offset}) & {sigchunk.bitmask}")

                        wires[wire_name].add_chunk_ordered(sig.group("range"), sigchunk)

                        if wires[wire_name].attributes.get("uc_past"):
                            wires[wire_name].chunks[sig.group("range")].past = True
                        concatenation_offset += sigchunk.width
                        # log("Added expression to wire " + wire_name + ", chunk " + sig.group("range") + ": " + sigchunk.expr, 0)
                    log(f"Assigned: " + wire_name + " with expression " + str(wires[wire_name].get_expr()))

            elif stripped_line.startswith("always"):
                # examples:
                #   always_ff @(posedge \genblk2.pcpi_div.clk )
                #     if (_08846_)
                #         if (\genblk2.pcpi_div.start ) _123_  <= 32'd2147483648;
                #         else _123_  <= _08938_;
                # Any state holding register Yosys cells are converted to always_ff blocks (or always blocks if output is not dumped as systemverilog)
                # Only one regiter is assigned in one always block.
                # Store the always block as a whole and later replace the auto named signals
                # within the if conditions and on the rhs of the assignments.

                always_block_finished = False
                always_block = stripped_line
                while (not always_block_finished and l+1 < len(file)):
                    l += 1
                    next_line = file[l].strip()
                    if next_line.endswith(";") and l+1 < len(file) and not file[l+1].strip().startswith("else"):
                        always_block_finished = True
                    always_block += "\n" + next_line
                if l == len(file):
                    raise Exception("File ended without 'endmodule'. Or last always block was not correctly sotred. Got: " + always_block)

                always_block, unused_inline_attrs = extract_attributes(always_block)

                reg_name = ""
                for always_line in always_block.split("\n"):
                    words = always_line.split()
                    if words.count("<="):
                        reg_name = words[words.index("<=")-1]
                        break
                    elif words.count("="):
                        reg_name = words[words.index("=")-1]
                        break
                if not reg_name:
                    print("Could not find register name in always block: " + always_block)
                    raise Exception("Could not find register name in always block above.")

                if regs.get(reg_name):
                    full_range = width_to_range(regs[reg_name].width)
                    regs[reg_name].chunks[full_range] = SignalChunk(regs[reg_name].width-1, 0)
                    regs[reg_name].chunks[full_range].expr = always_block
                    log("Added expression to reg " + reg_name + ": " + always_block, 0)
                else:
                    log("WARNING: Reg " + reg_name + " not found in reg list:  but found an assignment: " + always_block, 0)

            elif stripped_line.startswith("endmodule"):
                combine_chunks(wires)
                combine_chunks(regs)

                modules[curr_module_name].regs = copy.deepcopy(regs)
                modules[curr_module_name].wires = copy.deepcopy(wires)
                modules[curr_module_name].signals = modules[curr_module_name].wires | modules[curr_module_name].regs
                wires = {}
                regs = {}
            l += 1

if __name__ == "__main__":

    parser = argparse.ArgumentParser(description='Replaces all Yosys generated names with its expression built from the original names.')
    parser.add_argument('--design_file', dest='design_file', type=str, required=True, help='Input (System)Verilog file - dumped by Yosys')
    parser.add_argument('--signal_name', dest='signal_name', type=str, required=True, help='Signal name to be replaced' )
    parser.add_argument('--module_name', dest='module_name', type=str, required=True, help='Name of the module where signal is part of.' )
    args = parser.parse_args()

    replace_yosys_gen_names(args.design_file, args.module_name, args.signal_name)
