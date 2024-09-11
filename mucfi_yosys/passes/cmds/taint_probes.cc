/*
 *  yosys -- Yosys Open SYnthesis Suite
 *
 *  Copyright (C) 2020  Alberto Gonzalez <boqwxp@airmail.cc> & Flavien Solt <flsolt@ethz.ch>
 *
 *  Permission to use, copy, modify, and/or distribute this software for any
 *  purpose with or without fee is hereby granted, provided that the above
 *  copyright notice and this permission notice appear in all copies.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 *  WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 *  MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 *  ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 *  WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 *  ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 *  OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *
 */

#include "kernel/register.h"
#include "kernel/rtlil.h"
#include "kernel/utils.h"
#include "kernel/log.h"
#include "kernel/yosys.h"

#include <algorithm>

USING_YOSYS_NAMESPACE
PRIVATE_NAMESPACE_BEGIN

struct TaintProbesWorker {
private:
	// Command line arguments.
	bool opt_verbose;
	bool opt_exclude_latches;
	bool opt_include_nontainted;

	std::string sanitize_wire_name(std::string wire_name) {
		std::string ret;
		ret.reserve(wire_name.size());
		for(size_t char_id = 0; char_id < wire_name.size(); char_id++) {
			char curr_char = wire_name[char_id];
			if(curr_char != '$' && curr_char != ':' && curr_char != '.' && curr_char != '\\' && curr_char != '[' && curr_char != ']')
				ret += wire_name[char_id];
		}
		return '\\'+ret;
	}

	const RTLIL::IdString taint_probes_attribute_name = ID(taint_probes);

	// The taint_probes pass adds a probe wire for each sigchunk of a taint ff/latch cell, makes it an output and sets a taint probe attribute.
	// Then it lifts all signals with taint probe attribute one level higher by making them an output of the next higher module.
	void create_taint_probes(RTLIL::Module *module) {
		if (opt_verbose)
			log("Creating taint probes for module %s.\n", module->name.c_str());

		if (module->processes.size())
			log_error("Unexpected process. Requires a `proc` pass before.\n");

		for(std::pair<RTLIL::IdString, RTLIL::Cell*> cell_pair : module->cells_) {
			RTLIL::IdString cell_name = cell_pair.first;
			RTLIL::Cell *cell = cell_pair.second;

			bool is_tainted_ff = cell->type.in(ID($_DFFE_NN0N_), ID($_DFFE_NN0P_), ID($_DFFE_NN1N_), ID($_DFFE_NN1P_), ID($_DFFE_NN_), ID($_DFFE_NP0N_), ID($_DFFE_NP0P_), ID($_DFFE_NP1N_), ID($_DFFE_NP1P_), ID($_DFFE_NP_), ID($_DFFE_PN0N_), ID($_DFFE_PN0P_), ID($_DFFE_PN1N_), ID($_DFFE_PN1P_), ID($_DFFE_PN_), ID($_DFFE_PP0N_), ID($_DFFE_PP0P_), ID($_DFFE_PP1N_), ID($_DFFE_PP1P_), ID($_DFFE_PP_), ID($_DFFSRE_NNNN_), ID($_DFFSRE_NNNP_), ID($_DFFSRE_NNPN_), ID($_DFFSRE_NNPP_), ID($_DFFSRE_NPNN_), ID($_DFFSRE_NPNP_), ID($_DFFSRE_NPPN_), ID($_DFFSRE_NPPP_), ID($_DFFSRE_PNNN_), ID($_DFFSRE_PNNP_), ID($_DFFSRE_PNPN_), ID($_DFFSRE_PNPP_), ID($_DFFSRE_PPNN_), ID($_DFFSRE_PPNP_), ID($_DFFSRE_PPPN_), ID($_DFFSRE_PPPP_), ID($_DFFSR_NNN_), ID($_DFFSR_NNP_), ID($_DFFSR_NPN_), ID($_DFFSR_NPP_), ID($_DFFSR_PNN_), ID($_DFFSR_PNP_), ID($_DFFSR_PPN_), ID($_DFFSR_PPP_), ID($_DFF_NN0_), ID($_DFF_NN1_), ID($_DFF_NP0_), ID($_DFF_NP1_), ID($_DFF_N_), ID($_DFF_PN0_), ID($_DFF_PN1_), ID($_DFF_PP0_), ID($_DFF_PP1_), ID($_DFF_P_), ID($_FF_), ID($_SDFFCE_NN0N_), ID($_SDFFCE_NN0P_), ID($_SDFFCE_NN1N_), ID($_SDFFCE_NN1P_), ID($_SDFFCE_NP0N_), ID($_SDFFCE_NP0P_), ID($_SDFFCE_NP1N_), ID($_SDFFCE_NP1P_), ID($_SDFFCE_PN0N_), ID($_SDFFCE_PN0P_), ID($_SDFFCE_PN1N_), ID($_SDFFCE_PN1P_), ID($_SDFFCE_PP0N_), ID($_SDFFCE_PP0P_), ID($_SDFFCE_PP1N_), ID($_SDFFCE_PP1P_), ID($_SDFFE_NN0N_), ID($_SDFFE_NN0P_), ID($_SDFFE_NN1N_), ID($_SDFFE_NN1P_), ID($_SDFFE_NP0N_), ID($_SDFFE_NP0P_), ID($_SDFFE_NP1N_), ID($_SDFFE_NP1P_), ID($_SDFFE_PN0N_), ID($_SDFFE_PN0P_), ID($_SDFFE_PN1N_), ID($_SDFFE_PN1P_), ID($_SDFFE_PP0N_), ID($_SDFFE_PP0P_), ID($_SDFFE_PP1N_), ID($_SDFFE_PP1P_), ID($_SDFF_NN0_), ID($_SDFF_NN1_), ID($_SDFF_NP0_), ID($_SDFF_NP1_), ID($_SDFF_PN0_), ID($_SDFF_PN1_), ID($_SDFF_PP0_), ID($_SDFF_PP1_), ID($adff), ID($adffe), ID($dff), ID($dffe), ID($dffsr), ID($dffsre), ID($ff), ID($sdff), ID($sdffce), ID($sdffe));
			is_tainted_ff &= cell->has_attribute(ID(taint_ff)) || opt_include_nontainted;
			bool is_tainted_latch = cell->type.in(ID($_DLATCHSR_NNN_), ID($_DLATCHSR_NNP_), ID($_DLATCHSR_NPN_), ID($_DLATCHSR_NPP_), ID($_DLATCHSR_PNN_), ID($_DLATCHSR_PNP_), ID($_DLATCHSR_PPN_), ID($_DLATCHSR_PPP_), ID($_DLATCH_NN0_), ID($_DLATCH_NN1_), ID($_DLATCH_NP0_), ID($_DLATCH_NP1_), ID($_DLATCH_N_), ID($_DLATCH_PN0_), ID($_DLATCH_PN1_), ID($_DLATCH_PP0_), ID($_DLATCH_PP1_), ID($_DLATCH_P_), ID($adlatch), ID($dlatch), ID($dlatchsr));
			is_tainted_latch &= !opt_exclude_latches && (cell->has_attribute(ID(taint_latch)) || opt_include_nontainted);

			if (is_tainted_ff || is_tainted_latch) {
				RTLIL::SigSpec port_q(cell->getPort(ID::Q));
				// For each chunk in the output sigspec, create a new wire.
				for (auto &chunk_it: port_q.chunks()) {
					if (!chunk_it.is_wire())
						continue;

					std::string wire_name;
					wire_name = "probesig"+cell->name.str()+"WIRE"+chunk_it.wire->name.str()+"BITS"+std::to_string(chunk_it.offset)+"_"+std::to_string(chunk_it.offset+chunk_it.width)+"_";
					wire_name = sanitize_wire_name(wire_name);

					if (opt_verbose)
						log("Adding wire from ff or latch in module %s cell name %s, of type %s: %s\n", module->name.c_str(), cell->name.c_str(), cell->type.c_str(), wire_name.c_str());

					Wire *new_wire = module->addWire(wire_name, chunk_it.width);
					module->connect(new_wire, chunk_it);

					new_wire->port_output = true;
					new_wire->set_bool_attribute(ID(taint_wire));

					module->fixup_ports();
				}
			}

			else if (module->design->module(cell->type) != nullptr) {

				RTLIL::Module *submodule = module->design->module(cell->type);

				for (Wire *submodule_wire: submodule->wires()) {
					if (submodule_wire->has_attribute(ID(taint_wire))) {
						std::string wire_name = submodule_wire->name.str()+"INST"+cell->name.str()+"PORT"+std::to_string(submodule_wire->port_id);
						wire_name = sanitize_wire_name(wire_name);
						if (opt_verbose)
							log("Adding wire in module %s from submodule %s (cell name %s) of type %s: %s\n", module->name.c_str(), submodule->name.c_str(), cell->name.c_str(), cell->type.c_str(), wire_name.c_str());
						Wire *new_wire = module->addWire(wire_name, submodule_wire->width);
						cell->setPort(submodule_wire->name.str(), new_wire);

						new_wire->port_output = true;
						new_wire->set_bool_attribute(ID(taint_wire));
						module->fixup_ports();
					}
				}
			}
		}
		module->set_bool_attribute(taint_probes_attribute_name, true);
	}

public:
	TaintProbesWorker(RTLIL::Module *_module, bool _opt_verbose, bool _opt_exclude_latches, bool _opt_include_nontainted) {
		opt_verbose = _opt_verbose;
		opt_exclude_latches = _opt_exclude_latches;
		opt_include_nontainted = _opt_include_nontainted;

		create_taint_probes(_module);
	}
};

struct TaintProbesPass : public Pass {
	TaintProbesPass() : Pass("taint_probes", "create taint probes reaching the selected module.") {}

	void help() override
	{
		//   |---v---|---v---|---v---|---v---|---v---|---v---|---v---|---v---|---v---|---v---|
		log("\n");
		log("    taint_probes <command> [options] [selection]\n");
		log("\n");
		log("Creates taint probes reaching the design toplevel.\n");
		log("\n");
		log("Options:\n");
		log("\n");
		log("  -verbose\n");
		log("    Verbose mode.\n");
		log("\n");
		log("  -exclude-latches\n");
		log("    By default, latches are probed. This flag lets them be ignored.\n");
		log("\n");
		log("  -include-nontainted\n");
		log("    Also includes non-tainted states.\n");
		log("\n");
	}

	void execute(std::vector<std::string> args, RTLIL::Design *design) override
	{
		bool opt_verbose = false;
		bool opt_exclude_latches = false;
		bool opt_include_nontainted = false;

		std::vector<std::string>::size_type argidx;
		for (argidx = 1; argidx < args.size(); argidx++) {
			if (args[argidx] == "-verbose") {
				opt_verbose = true;
				continue;
			}
			if (args[argidx] == "-exclude-latches") {
				opt_exclude_latches = true;
				continue;
			}
			if (args[argidx] == "-include-nontainted") {
				opt_include_nontainted = true;
				continue;
			}
		}

		log_header(design, "Executing taint_probes pass.\n");

		if (GetSize(design->selected_modules()) == 0)
			log_cmd_error("Can't operate on an empty selection!\n");

		// Modules must be taken in inverted topological order to instrument the deepest modules first.
		// Taken from passes/techmap/flatten.cc
		TopoSort<RTLIL::Module*, IdString::compare_ptr_by_name<RTLIL::Module>> topo_modules;
		auto worklist = design->selected_modules();
		while (!worklist.empty()) {
			RTLIL::Module *module = *(worklist.begin());
			worklist.erase(worklist.begin());
			topo_modules.node(module);

			for (auto cell : module->selected_cells()) {
				RTLIL::Module *tpl = design->module(cell->type);
				if (tpl != nullptr) {
					if (topo_modules.database.count(tpl) == 0)
						worklist.push_back(tpl);
					topo_modules.edge(tpl, module);
				}
			}
		}
		if (!topo_modules.sort())
			log_cmd_error("Recursive modules are not supported by taint_probes.\n");

		// Run the worker on each module.
		for (auto i = 0; i < GetSize(topo_modules.sorted); ++i) {
			RTLIL::Module *module = topo_modules.sorted[i];
			TaintProbesWorker(module, opt_verbose, opt_exclude_latches, opt_include_nontainted);
		}
	}
} TaintProbesPass;

PRIVATE_NAMESPACE_END
