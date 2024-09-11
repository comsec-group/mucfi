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

typedef enum {
	INSERT_UNDEF,
	INSERT_ADFF,
	INSERT_ADFFE,
	INSERT_DFFE,
	INSERT_DLATCH,
	INSERT_SDFF,
	INSERT_SDFFCE,
	INSERT_SDFFE,
} insert_dff_type_t;

struct InsertDffCellWorker {
private:
	int insert_dff_type;

	RTLIL::Module *module = nullptr;
	const RTLIL::IdString insert_dff_cell_attribute_name = ID(insert_dff_cell);

	void insert_dff_cell() {

		if (module->get_bool_attribute(insert_dff_cell_attribute_name))
			return;

		log("Inserting dff cell...\n");

		std::vector<RTLIL::Wire*> wires(module->wires());
		std::vector<RTLIL::Cell*> cells(module->cells());

		RTLIL::Wire* wire_clk_i;
		RTLIL::Wire* wire_rst_ni;
		RTLIL::Wire* wire_en_i;
		RTLIL::Wire* wire_d_i;
		RTLIL::Wire* wire_interm;

		for(unsigned int i = 0; i < wires.size(); i++) {
			if (wires[i]->name == ID(clk_i))
				wire_clk_i = wires[i];
			else if (wires[i]->name == ID(rst_ni))
				wire_rst_ni = wires[i];
			else if (wires[i]->name == ID(en_i))
				wire_en_i = wires[i];
			else if (wires[i]->name == ID(d_i))
				wire_d_i = wires[i];
			else if (wires[i]->name == ID(interm))
				wire_interm = wires[i];
			else
				log("Skipped wire: %s (width: %d).\n", wires[i]->name.c_str(), wires[i]->width);
		}

		if (insert_dff_type != INSERT_DLATCH)
			log("wire_clk_i width:      %d\n", wire_clk_i->width);
		log("wire_d_i width:        %d\n", wire_d_i->width);
		log("wire_interm width:     %d\n", wire_interm->width);
		if (insert_dff_type != INSERT_ADFF && insert_dff_type != INSERT_SDFF)
			log("wire_en_i width:       %d\n", wire_en_i->width);
		if (insert_dff_type != INSERT_DFFE && insert_dff_type != INSERT_DLATCH)
			log("wire_rst_ni width:     %d\n", wire_rst_ni->width);

		RTLIL::Cell* new_cell;
		RTLIL::Const rst_val_sigspec;

		switch (insert_dff_type) {
			case INSERT_ADFF:
				rst_val_sigspec = module->parameter_default_values.find(ID(ARST_VALUE))->second.as_int(), module->parameter_default_values.find(ID(WIDTH))->second.as_int();
				new_cell = module->addAdff(NEW_ID, wire_clk_i, wire_rst_ni, wire_d_i, wire_interm, rst_val_sigspec);
				break;
			case INSERT_ADFFE:
				rst_val_sigspec = module->parameter_default_values.find(ID(ARST_VALUE))->second.as_int(), module->parameter_default_values.find(ID(WIDTH))->second.as_int();
				new_cell = module->addAdffe(NEW_ID, wire_clk_i, wire_en_i, wire_rst_ni, wire_d_i, wire_interm, rst_val_sigspec);
				break;
			case INSERT_DFFE:
				new_cell = module->addDffe(NEW_ID, wire_clk_i, wire_en_i, wire_d_i, wire_interm);
				break;
			case INSERT_DLATCH:
				new_cell = module->addDlatch(NEW_ID, wire_en_i, wire_d_i, wire_interm);
				break;
			case INSERT_SDFF:
				rst_val_sigspec = module->parameter_default_values.find(ID(SRST_VALUE))->second.as_int(), module->parameter_default_values.find(ID(WIDTH))->second.as_int();
				new_cell = module->addSdff(NEW_ID, wire_clk_i, wire_rst_ni, wire_d_i, wire_interm, rst_val_sigspec);
				break;
			case INSERT_SDFFCE:
				rst_val_sigspec = module->parameter_default_values.find(ID(SRST_VALUE))->second.as_int(), module->parameter_default_values.find(ID(WIDTH))->second.as_int();
				new_cell = module->addSdffce(NEW_ID, wire_clk_i, wire_en_i, wire_rst_ni, wire_d_i, wire_interm, rst_val_sigspec);
				break;
			case INSERT_SDFFE:
				rst_val_sigspec = module->parameter_default_values.find(ID(SRST_VALUE))->second.as_int(), module->parameter_default_values.find(ID(WIDTH))->second.as_int();
				new_cell = module->addSdffe(NEW_ID, wire_clk_i, wire_en_i, wire_rst_ni, wire_d_i, wire_interm, rst_val_sigspec);
				break;
			default:
				log("Error: Unsupported DFF type insertion. Please check your flags.\n");
		}
		for (auto &param: module->parameter_default_values)
			new_cell->setParam(param.first, param.second);
		module->set_bool_attribute(insert_dff_cell_attribute_name, true);
	}

public:
	InsertDffCellWorker(RTLIL::Module *_module, insert_dff_type_t _insert_dff_type) {
		insert_dff_type = _insert_dff_type;
		module = _module;
		insert_dff_cell();
	}
};

struct InsertDffCellPass : public Pass {
	InsertDffCellPass() : Pass("insert_dff_cell", "Add a dff cell in each module of the design. This is an ad-hoc pass.") {}

	void help() override
	{
		//   |---v---|---v---|---v---|---v---|---v---|---v---|---v---|---v---|---v---|---v---|
		log("\n");
		log("    insert_dff_cell <command> [options] [selection]\n");
		log("\n");
		log("Add a dff cell in each module of the design.\n");
		log("Takes exactly one of the following flags.\n");
		log("-adff\n");
		log("-adffe\n");
		log("-dffe\n");
		log("-dlatch\n");
		log("-sdff\n");
		log("-sdffe\n");
		log("-sdffce\n");
		log("\n");
	}

	void execute(std::vector<std::string> args, RTLIL::Design *design) override
	{
		insert_dff_type_t insert_dff_type = INSERT_UNDEF;

		log_header(design, "Executing insert_dff_cell pass.\n");

		std::vector<std::string>::size_type argidx;

		for (argidx = 1; argidx < args.size(); argidx++) {
			if (args[argidx] == "-adff") {
				if (insert_dff_type == INSERT_UNDEF)
					insert_dff_type = INSERT_ADFF;
				else
					log_error("Multiple contradictory flags specifying the DFF type were provided.\n");
				continue;
			}
			if (args[argidx] == "-adffe") {
				if (insert_dff_type == INSERT_UNDEF)
					insert_dff_type = INSERT_ADFFE;
				else
					log_error("Multiple contradictory flags specifying the DFF type were provided.\n");
				continue;
			}
			if (args[argidx] == "-dffe") {
				if (insert_dff_type == INSERT_UNDEF)
					insert_dff_type = INSERT_DFFE;
				else
					log_error("Multiple contradictory flags specifying the DFF type were provided.\n");
				continue;
			}
			if (args[argidx] == "-dlatch") {
				if (insert_dff_type == INSERT_UNDEF)
					insert_dff_type = INSERT_DLATCH;
				else
					log_error("Multiple contradictory flags specifying the DFF type were provided.\n");
				continue;
			}
			if (args[argidx] == "-sdffce") {
				if (insert_dff_type == INSERT_UNDEF)
					insert_dff_type = INSERT_SDFFCE;
				else
					log_error("Multiple contradictory flags specifying the DFF type were provided.\n");
				continue;
			}
			if (args[argidx] == "-sdffe") {
				if (insert_dff_type == INSERT_UNDEF)
					insert_dff_type = INSERT_SDFFE;
				else
					log_error("Multiple contradictory flags specifying the DFF type were provided.\n");
				continue;
			}
			break;
		}
		extra_args(args, argidx, design);

		if (GetSize(design->selected_modules()) == 0)
			log_cmd_error("Can't operate on an empty selection!\n");

		if (insert_dff_type == INSERT_UNDEF)
			log_cmd_error("You must speficy the DFF type through a flag.\n");

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
			InsertDffCellWorker worker(module, insert_dff_type);
		}
	}
} InsertDffCellPass;

PRIVATE_NAMESPACE_END
