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

struct MulToAddsWorker {
private:
	RTLIL::Module *module = nullptr;
	const RTLIL::IdString mul_to_adds_attribute_name = ID(mul_to_adds);

	void decompose_multipliers_to_adders() {

		if (module->get_bool_attribute(mul_to_adds_attribute_name))
			return;

		log("Applying mta to module %s.\n", module->name.c_str());

		std::vector<RTLIL::SigSig> connections(module->connections());

		std::vector<Yosys::RTLIL::Cell *> original_cells = module->cells().to_vector();
		std::vector<Yosys::RTLIL::Cell *> cells_to_remove;
		// Second, add the logic corresponding to the cells. The input and output ports are supposed to have a width of 1. The corresponding port of the input port is obtained
		for(auto &cell : original_cells) {
			// Only consider multipliers.
			if (!cell->type.in(ID($mul))) {
				// log("    - Discarding mul_to_adds in cell %s: not a multiplier.\n", cell->name.c_str());
				// // if (module->design->module(cell->type) != nullptr)
				// 	log("      -> This cell was of type %s.\n", cell->type.c_str());
				continue;
			}
			log("    MTA success for multiplier: %s.\n", cell->name.c_str());

			cells_to_remove.push_back(cell);

			const unsigned int A = 0, B = 1, Y = 2;
			const unsigned int NUM_PORTS = 3;
			RTLIL::SigSpec ports[NUM_PORTS] = {cell->getPort(ID::A), cell->getPort(ID::B), cell->getPort(ID::Y)};

			int output_width = ports[Y].size();
			int double_output_width = 2*output_width;
			RTLIL::SigSpec extended_a(ports[A]);
			RTLIL::SigSpec extended_b(ports[B]);
			if (ports[A].size() < double_output_width)
				extended_a.append(RTLIL::SigSpec(RTLIL::State::S0, double_output_width-ports[A].size()));
			if (ports[B].size() < double_output_width)
				extended_b.append(RTLIL::SigSpec(RTLIL::State::S0, double_output_width-ports[B].size()));

			// Create the lines that will subsequently be added.
			std::vector<RTLIL::SigSpec> lines_to_add;
			for (int line_id = 0; line_id < output_width; line_id++) {
				std::vector<RTLIL::SigBit> bits_in_new_line;
				for (int shift_id = 0; shift_id < line_id; shift_id++)
					bits_in_new_line.push_back(RTLIL::State::S0);

				// Iterate through the bits of b.
				for (int input_bit_id = 0; input_bit_id < output_width && bits_in_new_line.size() <= output_width; input_bit_id++)
					bits_in_new_line.push_back(module->And(NEW_ID, extended_a[line_id], extended_b[input_bit_id]));

				while (bits_in_new_line.size() < output_width)
					bits_in_new_line.push_back(RTLIL::State::S0);
				lines_to_add.push_back(bits_in_new_line);
			}

			// Add the lines one by one.
			std::vector<RTLIL::SigSpec> interm_addition_results;
			interm_addition_results.push_back(lines_to_add[0]);
			for (int line_id = 1; line_id < lines_to_add.size(); line_id++) {
				// std::cout << std::dec << interm_addition_results[line_id-1].size() << " -- " << lines_to_add[line_id].size() << std::endl;
				interm_addition_results.push_back(module->Add(NEW_ID, interm_addition_results[line_id-1], lines_to_add[line_id]));
			}

			module->connect(ports[Y], interm_addition_results[interm_addition_results.size()-1].extract(0, output_width));
		} //end foreach cell in cells

		// Remove the cells that are replaced by the IFT compound.
		for (RTLIL::Cell *cell_to_remove: cells_to_remove)
			module->remove(cell_to_remove);

		module->set_bool_attribute(mul_to_adds_attribute_name, true);
	}

public:
	MulToAddsWorker(RTLIL::Module *_module) {
		module = _module;
		decompose_multipliers_to_adders();
	}
};

struct MulToAddsPass : public Pass {
	MulToAddsPass() : Pass("mul_to_adds", "Decompose multipliers into adders.") {}

	void help() override
	{
		//   |---v---|---v---|---v---|---v---|---v---|---v---|---v---|---v---|---v---|---v---|
		log("\n");
		log("    mul_to_adds <command> [options] [selection]\n");
		log("\n");
		log("Decomposes multipliers into adders.\n");
		log("\n");
	}

	void execute(std::vector<std::string> args, RTLIL::Design *design) override
	{
		log_header(design, "Executing mul_to_adds pass (decomposing multipliers into adders).\n");

		if (GetSize(design->selected_modules()) == 0)
			log_cmd_error("Can't operate on an empty selection!\n");

		TopoSort<RTLIL::Module*, IdString::compare_ptr_by_name<RTLIL::Module>> topo_modules; // taken from passes/techmap/flatten\.cc
		auto worklist = design->selected_modules();
		pool<RTLIL::IdString> non_top_modules;
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
					non_top_modules.insert(cell->type);
				}
			}
		}

		if (!topo_modules.sort())
			log_cmd_error("Cannot handle recursive module instantiations.\n");

		for (auto i = 0; i < GetSize(topo_modules.sorted); ++i) {
			RTLIL::Module *module = topo_modules.sorted[i];
			MulToAddsWorker worker(module);
		}
	}
} MulToAddsPass;

PRIVATE_NAMESPACE_END
