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

struct InsertShiftCellWorker {
private:
	bool opt_verbose = false;

	RTLIL::Module *module = nullptr;
	const RTLIL::IdString insert_shift_cell_attribute_name = ID(insert_shift_cell);

	void insert_shift_cell() {

		if (module->get_bool_attribute(insert_shift_cell_attribute_name))
			return;

		if (opt_verbose)
			log("Inserting shift cell...\n");

		std::vector<RTLIL::Wire*> wires(module->wires());
		std::vector<RTLIL::Cell*> cells(module->cells());

		module->remove(cells[0]);

		if (opt_verbose)
			log("Removed original cell.\n");

		RTLIL::Wire* wire_a;
		RTLIL::Wire* wire_b;
		RTLIL::Wire* wire_y;

		for(unsigned int i = 0; i < wires.size(); i++) {
			if (wires[i]->name == ID(shift_a_i))
				wire_a = wires[i];
			else if (wires[i]->name == ID(shift_b_i))
				wire_b = wires[i];
			else if (wires[i]->name == ID(shift_y_o))
				wire_y = wires[i];
		}

		RTLIL::Cell* shift_cell = module->addShift(NEW_ID, wire_a, wire_b, wire_y);

		for (auto &param: module->parameter_default_values) {
			if (opt_verbose)
				log("Transmitting param %s: %s\n", param.first.c_str(), param.second.as_string().c_str());

			if (param.first.in(ID(A_SIGNED), ID(B_SIGNED), ID(A_WIDTH), ID(B_WIDTH), ID(Y_WIDTH)))
				shift_cell->setParam(param.first, param.second);
		}

		module->set_bool_attribute(insert_shift_cell_attribute_name, true);
	}

public:
	InsertShiftCellWorker(RTLIL::Module *_module, bool _opt_verbose) {
		opt_verbose = _opt_verbose;

		module = _module;
		insert_shift_cell();
	}
};

struct InsertShiftCellPass : public Pass {
	InsertShiftCellPass() : Pass("insert_shift_cell", "Add a $shift cell in each module of the design. This is an ad-hoc pass.") {}

	void help() override
	{
		//   |---v---|---v---|---v---|---v---|---v---|---v---|---v---|---v---|---v---|---v---|
		log("\n");
		log("    insert_shift_cell <command> [options] [selection]\n");
		log("\n");
		log("Add a $shift cell in each module of the design.\n");
		log("There must be a pre-existing cell with inputs a_i and b_i,\n");
		log("and output y_o or out_o.\n");
		log("\n");
		log("Options:\n");
		log("\n");
		log("  -verbose\n");
		log("    Verbose mode.\n");
		log("\n");
	}

	void execute(std::vector<std::string> args, RTLIL::Design *design) override
	{
		bool opt_verbose = false;

		log_header(design, "Executing insert_shift_cell pass (Add a $shift cell in each module of the design).\n");

		std::vector<std::string>::size_type argidx;
		for (argidx = 1; argidx < args.size(); argidx++) {
			if (args[argidx] == "-verbose") {
				opt_verbose = true;
				continue;
			}
		}

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
			InsertShiftCellWorker worker(module, opt_verbose);
		}
	}
} InsertShiftCellPass;

PRIVATE_NAMESPACE_END
