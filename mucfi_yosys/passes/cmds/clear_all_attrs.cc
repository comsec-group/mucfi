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

struct ClearAllAttrsWorker {
private:

	/////////////////////////////
	// Main recursive function //
	/////////////////////////////

	/**
	 * @param module the current module.
	 * @param path_so_far the path to current module. Does not include the final separator.
	 */
	void clear_all_attrs (RTLIL::Module *module) {
		module->attributes.clear();

		for (auto curr_attrobj: module->wires())
			curr_attrobj->attributes.clear();
		for (auto curr_attr_second_pair: module->memories)
			curr_attr_second_pair.second->attributes.clear();
		for (auto curr_attr_second_pair: module->processes)
			curr_attr_second_pair.second->attributes.clear();

		for (RTLIL::Cell *cell: module->cells()) {
			RTLIL::Module *submodule = module->design->module(cell->type);
			// If this is an elementary cell.
			if (submodule == nullptr) {
				cell->attributes.clear();
			} else {
				// If this is a submodule, then apply the statistics function recursively.
				clear_all_attrs(submodule);
			}
		}
	}

public:
	ClearAllAttrsWorker(RTLIL::Module *top_module) {
		clear_all_attrs(top_module);
	}
};

struct ClearAllAttrsPass : public Pass {
	ClearAllAttrsPass() : Pass("clear_all_attrs", "Clears all attributes in the selected module and its children.") {}

	void help() override
	{
		//   |---v---|---v---|---v---|---v---|---v---|---v---|---v---|---v---|---v---|---v---|
		log("\n");
		log("    clear_all_attrs <command> [options] [selection]\n");
		log("\n");
		log("Clears all attributes in the selected module and its children.\n");
		log("\n");
	}

	void execute(std::vector<std::string> args, RTLIL::Design *design) override
	{
		log_header(design, "Executing clear_all_attrs pass.\n");

		if (GetSize(design->selected_modules()) == 0)
			log_cmd_error("Can't operate on an empty selection!\n");

		ClearAllAttrsWorker worker(design->top_module());
	}
} ClearAllAttrsPass;

PRIVATE_NAMESPACE_END
