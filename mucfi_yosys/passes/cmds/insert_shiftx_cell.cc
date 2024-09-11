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

struct InsertShiftxCellWorker {
private:
	RTLIL::Module *module = nullptr;
	const RTLIL::IdString insert_shiftx_cell_attribute_name = ID(insert_shiftx_cell);

	void insert_shiftx_cell() {

		if (module->get_bool_attribute(insert_shiftx_cell_attribute_name))
			return;

		log("Inserting shiftx cell...\n");

		std::vector<RTLIL::Wire*> wires(module->wires());
		std::vector<RTLIL::Cell*> cells(module->cells());

		RTLIL::Wire* wire_a;
		RTLIL::Wire* wire_b;
		RTLIL::Wire* wire_y;

		for(unsigned int i = 0; i < wires.size(); i++) {
			if (wires[i]->name == ID(a_i))
				wire_a = wires[i];
			else if (wires[i]->name == ID(b_i))
				wire_b = wires[i];
			else if (wires[i]->name == ID(interm))
				wire_y = wires[i];
			else
				log("Skipped wire: %s (width: %d).\n", wires[i]->name.c_str(), wires[i]->width);
		}

		log("wire_a width: %d\n", wire_a->width);
		log("wire_b width: %d\n", wire_b->width);
		log("wire_y width: %d\n", wire_y->width);

		RTLIL::Cell* shiftx_cell = module->addShiftx(NEW_ID, wire_a, wire_b, wire_y);

		for (auto &param: module->parameter_default_values) {
			shiftx_cell->setParam(param.first, param.second);
		}

		module->set_bool_attribute(insert_shiftx_cell_attribute_name, true);
	}

public:
	InsertShiftxCellWorker(RTLIL::Module *_module) {
		module = _module;
		insert_shiftx_cell();
	}
};

struct InsertShiftXCellPass : public Pass {
	InsertShiftXCellPass() : Pass("insert_shiftx_cell", "Add a $shift cell in each module of the design. This is an ad-hoc pass.") {}

	void help() override
	{
		//   |---v---|---v---|---v---|---v---|---v---|---v---|---v---|---v---|---v---|---v---|
		log("\n");
		log("    insert_shiftx_cell <command> [options] [selection]\n");
		log("\n");
		log("Add a $shiftx cell in each module of the design.\n");
		log("\n");
	}

	void execute(std::vector<std::string> args, RTLIL::Design *design) override
	{
		log_header(design, "Executing insert_shiftx_cell pass (Add a $shift cell in each module of the design).\n");

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
			InsertShiftxCellWorker worker(module);
		}
	}
} InsertShiftXCellPass;

PRIVATE_NAMESPACE_END
