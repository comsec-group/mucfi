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

USING_YOSYS_NAMESPACE
PRIVATE_NAMESPACE_BEGIN

struct BreakdownGliftWorker {
private:
	// Command line arguments.
	bool opt_verbose;
	bool opt_exclude_xor;
	bool opt_exclude_mux;

	const RTLIL::IdString breakdown_glift_attribute_name = ID(breakdown_glift);

	void breakdown_glift_logic(RTLIL::Module *module) {
		if (opt_verbose)
			log("Breaking down GLIFT gates for module %s.\n", module->name.c_str());

		if (module->processes.size())
			log_error("Unexpected process. Requires a `proc` pass before.\n");

		std::vector<Yosys::RTLIL::Cell *> original_cells = module->cells().to_vector();
		std::vector<Yosys::RTLIL::Cell *> cells_to_remove;

		// Second, add the logic corresponding to the cells. The input and output ports are supposed to have a width of 1. The corresponding port of the input port is obtained
		for(auto &cell : original_cells) {

			if (cell->type.in(ID($_XOR_), ID($xor))) {
				if (opt_exclude_xor) {
					if (opt_verbose)
						log("    Skipping %s cell (%s) because of flag -exclude-xor.\n", cell->type.c_str(), cell->name.c_str());
					continue;
				}

				if (opt_verbose)
					log("    Breaking down %s cell (%s)\n", cell->type.c_str(), cell->name.c_str());
				const unsigned int A = 0, B = 1, Y = 2;
				const unsigned int NUM_PORTS = 3;
				RTLIL::SigSpec ports[NUM_PORTS] = {cell->getPort(ID::A), cell->getPort(ID::B), cell->getPort(ID::Y)};
				std::vector<RTLIL::SigSpec> port_taints[NUM_PORTS];

				int output_width = ports[Y].size();

				RTLIL::SigSpec extended_a(ports[A]);
				RTLIL::SigSpec extended_b(ports[B]);
				if (ports[A].size() < output_width)
					extended_a.append(RTLIL::SigSpec(RTLIL::State::S0, output_width-ports[A].size()));
				if (ports[B].size() < output_width)
					extended_b.append(RTLIL::SigSpec(RTLIL::State::S0, output_width-ports[B].size()));

				RTLIL::SigSpec not_a = module->Not(NEW_ID, extended_a);
				RTLIL::SigSpec not_b = module->Not(NEW_ID, extended_b);
				RTLIL::SigSpec a_and_not_b = module->And(NEW_ID, extended_a, not_b);
				RTLIL::SigSpec b_and_not_a = module->And(NEW_ID, not_a, extended_b);
				module->addOr(NEW_ID, a_and_not_b, b_and_not_a, ports[Y]);

				cells_to_remove.push_back(cell);
			}
			else if (cell->type.in(ID($_MUX_))) {
				if (opt_exclude_mux) {
					if (opt_verbose)
						log("    Skipping %s cell (%s) because of flag -exclude-mux.\n", cell->type.c_str(), cell->name.c_str());
					continue;
				}
				if (opt_verbose)
					log("    Breaking down %s cell (%s)\n", cell->type.c_str(), cell->name.c_str());
				const unsigned int A = 0, B = 1, Y = 2, S = 3;
				const unsigned int NUM_PORTS = 4;
				RTLIL::SigSpec ports[NUM_PORTS] = {cell->getPort(ID::A), cell->getPort(ID::B), cell->getPort(ID::Y), cell->getPort(ID::S)};
				std::vector<RTLIL::SigSpec> port_taints[NUM_PORTS];

				int output_width = ports[Y].size();

				RTLIL::SigSpec extended_a(ports[A]);
				RTLIL::SigSpec extended_b(ports[B]);
				RTLIL::SigSpec extended_s(ports[S]);
				if (ports[A].size() < output_width)
					extended_a.append(RTLIL::SigSpec(RTLIL::State::S0, output_width-ports[A].size()));
				if (ports[B].size() < output_width)
					extended_b.append(RTLIL::SigSpec(RTLIL::State::S0, output_width-ports[B].size()));
				if (ports[S].size() < output_width)
					extended_s.append(RTLIL::SigSpec(RTLIL::State::S0, output_width-ports[S].size()));

				RTLIL::SigSpec not_s = module->Not(NEW_ID, extended_s);
				RTLIL::SigSpec b_and_s = module->And(NEW_ID, extended_b, extended_s);
				RTLIL::SigSpec a_and_not_s = module->And(NEW_ID, extended_a, not_s);
				module->addOr(NEW_ID, b_and_s, a_and_not_s, ports[Y]);

				cells_to_remove.push_back(cell);
			}
			else if (cell->type.in(ID($_NMUX_))) {
				if (opt_exclude_mux) {
					if (opt_verbose)
						log("    Skipping %s cell (%s) because of flag -exclude-mux.\n", cell->type.c_str(), cell->name.c_str());
					continue;
				}
				if (opt_verbose)
					log("    Breaking down %s cell (%s)\n", cell->type.c_str(), cell->name.c_str());
				const unsigned int A = 0, B = 1, Y = 2, S = 3;
				const unsigned int NUM_PORTS = 4;
				RTLIL::SigSpec ports[NUM_PORTS] = {cell->getPort(ID::A), cell->getPort(ID::B), cell->getPort(ID::Y), cell->getPort(ID::S)};
				std::vector<RTLIL::SigSpec> port_taints[NUM_PORTS];

				int output_width = ports[Y].size();

				RTLIL::SigSpec extended_a(ports[A]);
				RTLIL::SigSpec extended_b(ports[B]);
				RTLIL::SigSpec extended_s(ports[S]);
				if (ports[A].size() < output_width)
					extended_a.append(RTLIL::SigSpec(RTLIL::State::S0, output_width-ports[A].size()));
				if (ports[B].size() < output_width)
					extended_b.append(RTLIL::SigSpec(RTLIL::State::S0, output_width-ports[B].size()));
				if (ports[S].size() < output_width)
					extended_s.append(RTLIL::SigSpec(RTLIL::State::S0, output_width-ports[S].size()));


				RTLIL::SigSpec not_a = module->Not(NEW_ID, extended_a);
				RTLIL::SigSpec not_b = module->Not(NEW_ID, extended_b);
				RTLIL::SigSpec not_s = module->Not(NEW_ID, extended_s);
				RTLIL::SigSpec b_and_s = module->And(NEW_ID, not_b, extended_s);
				RTLIL::SigSpec a_and_not_s = module->And(NEW_ID, not_a, not_s);
				module->addOr(NEW_ID, b_and_s, a_and_not_s, ports[Y]);

				cells_to_remove.push_back(cell);
			}

			// Submodule: call the breakdown function on it recursively.
			else if (module->design->module(cell->type) != nullptr)
				breakdown_glift_logic(module->design->module(cell->type));
		} //end foreach cell in cells

		// Remove the cells that are replaced by the broken-down version.
		for (RTLIL::Cell *cell_to_remove: cells_to_remove)
			module->remove(cell_to_remove);

		module->set_bool_attribute(breakdown_glift_attribute_name, true);
	}

public:
	BreakdownGliftWorker(RTLIL::Module *_module, bool _opt_verbose, bool _opt_exclude_xor, bool _opt_exclude_mux) {
		opt_verbose = _opt_verbose;
		opt_exclude_xor = _opt_exclude_xor;
		opt_exclude_mux = _opt_exclude_mux;

		breakdown_glift_logic(_module);
	}
};

struct BreakdownGliftPass : public Pass {
	BreakdownGliftPass() : Pass("breakdown_glift", "break down muxes and xors into simpler gates after a vanilla techmap pass.") {}

	void help() override
	{
		//   |---v---|---v---|---v---|---v---|---v---|---v---|---v---|---v---|---v---|---v---|
		log("\n");
		log("    breakdown_glift <command> [options] [selection]\n");
		log("\n");
		log("Breaks down muxes and xors into simpler gates after a vanilla techmap pass.\n");
		log("\n");
		log("Options:\n");
		log("\n");
		log("  -verbose\n");
		log("    Verbose mode.\n");
		log("\n");
		log("  -exclude-xor\n");
		log("    Do not break down xor and xnor gates.\n");
		log("\n");
		log("  -exclude-mux\n");
		log("    Do not break down multiplexers and non-multiplexers.\n");
		log("\n");
	}

	void execute(std::vector<std::string> args, RTLIL::Design *design) override
	{
		bool opt_verbose = false;
		bool opt_exclude_xor = false;
		bool opt_exclude_mux = false;

		std::vector<std::string>::size_type argidx;
		for (argidx = 1; argidx < args.size(); argidx++) {
			if (args[argidx] == "-verbose") {
				opt_verbose = true;
				continue;
			}
			if (args[argidx] == "-exclude-xor") {
				opt_exclude_xor = true;
				continue;
			}
			if (args[argidx] == "-exclude-mux") {
				opt_exclude_mux = true;
				continue;
			}
		}

		log_header(design, "Executing breakdown_glift pass.\n");

		if (GetSize(design->selected_modules()) == 0)
			log_cmd_error("Can't operate on an empty selection!\n");

		if (opt_exclude_xor && opt_exclude_mux)
			log("Both -exclude-xor and -exclude-mux flags are set, therefore the breakdown_glift pass will do nothing.\n");

		BreakdownGliftWorker worker(design->top_module(), opt_verbose, opt_exclude_xor, opt_exclude_mux);
	}
} BreakdownGliftPass;

PRIVATE_NAMESPACE_END
