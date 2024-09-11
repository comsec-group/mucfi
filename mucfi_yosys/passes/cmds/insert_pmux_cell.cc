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

struct InsertPmuxCellWorker {
private:
	RTLIL::Module *module = nullptr;
	const RTLIL::IdString insert_pmux_cell_attribute_name = ID(insert_pmux_cell);

	void insert_pmux_cell() {

		if (module->get_bool_attribute(insert_pmux_cell_attribute_name))
			return;

		log("Inserting pmux cell...\n");

		std::vector<RTLIL::Wire*> wires(module->wires());
		std::vector<RTLIL::Cell*> cells(module->cells());

		module->remove(cells[0]);
		log("Removed original cell.\n");

		RTLIL::Wire* wire_a_i;
		RTLIL::Wire* wire_b_i;
		RTLIL::Wire* wire_s_i;
		RTLIL::Wire* wire_y_o;

		for(unsigned int i = 0; i < wires.size(); i++) {
			if (wires[i]->name == ID(a_i))
				wire_a_i = wires[i];
			else if (wires[i]->name == ID(b_i))
				wire_b_i = wires[i];
			else if (wires[i]->name == ID(s_i))
				wire_s_i = wires[i];
			else if (wires[i]->name == ID(y_o))
				wire_y_o = wires[i];
		}

		RTLIL::Cell* new_cell;
		RTLIL::Const rst_val_sigspec;

		new_cell = module->addPmux(NEW_ID, wire_a_i, wire_b_i, wire_s_i, wire_y_o);
		for (auto &param: module->parameter_default_values)
			new_cell->setParam(param.first, param.second);

		for (auto &param: new_cell->parameters) {
			log("New cell param: %s = %d\n", param.first.c_str(), param.second.as_int());
		}

		module->set_bool_attribute(insert_pmux_cell_attribute_name, true);
	}

public:
	InsertPmuxCellWorker(RTLIL::Module *_module) {
		module = _module;
		insert_pmux_cell();
	}
};

struct InsertPmuxCellPass : public Pass {
	InsertPmuxCellPass() : Pass("insert_pmux_cell", "Add a pmux cell in the design top module. This is a pass dedicated to cell unit testing.") {}

	void help() override
	{
		//   |---v---|---v---|---v---|---v---|---v---|---v---|---v---|---v---|---v---|---v---|
		log("\n");
		log("    insert_pmux_cell <command> [options] [selection]\n");
		log("\n");
		log("Add a pmux cell in each module of the design.\n");
		log("This pass has been designed for testing the pmux implementation.\n");
		log("The top module must contain exactly one dummy cell.\n");
		log("\n");
	}

	void execute(std::vector<std::string> args, RTLIL::Design *design) override
	{
		log_header(design, "Executing insert_pmux_cell pass.\n");

		if (GetSize(design->selected_modules()) == 0)
			log_cmd_error("Can't operate on an empty selection!\n");

		InsertPmuxCellWorker worker(design->top_module());
	}
} InsertPmuxCellPass;

PRIVATE_NAMESPACE_END
