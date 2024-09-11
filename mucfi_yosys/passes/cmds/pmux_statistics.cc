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

struct PmuxStatisticsWorker {
private:
	
	dict<int, int> pmux_s_widths;
	dict<int, int> pmux_a_widths;

	const std::string pmux_statistics_attr_name = ID(pmux_statistics).str();

	/////////////////////////////
	// Main recursive function //
	/////////////////////////////

	/**
	 * @param module the current module.
	 */
	void pmux_statistics (RTLIL::Module *module) {
		for (RTLIL::Cell *cell: module->cells()) {
			RTLIL::Module *submodule = module->design->module(cell->type);
			// If this is an elementary cell.
			if (submodule == nullptr) {
				string cell_type = cell->type.str();
				if (cell_type == "$pmux") {
					int a_width = cell->getParam(ID::WIDTH).as_int(); 
					int s_width = cell->getParam(ID::S_WIDTH).as_int(); 
					if (pmux_a_widths.find(a_width) == pmux_a_widths.end())
						pmux_a_widths[a_width] = 1;
					else
						pmux_a_widths[a_width]++;
					if (pmux_s_widths.find(s_width) == pmux_s_widths.end())
						pmux_s_widths[s_width] = 1;
					else
						pmux_s_widths[s_width]++;
				}
			} else {
				// If this is a submodule, then apply the statistics function recursively.
				pmux_statistics(submodule);
			}
		}
	}

	//////////////////////////
	// Display the elements //
	//////////////////////////

	void display_statistics () {
		pmux_a_widths.sort();
		pmux_s_widths.sort();
		log("A widths\n\n");
		int last_key = 0;
		for (std::pair<int, int> width_pair: pmux_a_widths) {
			for (int absent_id = last_key+1; absent_id < width_pair.first; absent_id++)
						log("%d 0\n", absent_id);
			log("%d %d\n", width_pair.first, width_pair.second);
			last_key = width_pair.first;
		}
		log("\n\n");

		log("S widths\n\n");
		last_key = 0;
		for (std::pair<int, int> width_pair: pmux_s_widths) {
			for (int absent_id = last_key+1; absent_id < width_pair.first; absent_id++)
						log("%d 0\n", absent_id);
			log("%d %d\n", width_pair.first, width_pair.second);
			last_key = width_pair.first;
		}
		log("\n\n");
	}

public:
	PmuxStatisticsWorker(RTLIL::Module *top_module) {
		pmux_statistics(top_module);
		display_statistics();
	}
};

struct PmuxStatisticsPass : public Pass {
	PmuxStatisticsPass() : Pass("pmux_statistics", "Makes statistics about pmux cells.") {}

	void help() override
	{
		//   |---v---|---v---|---v---|---v---|---v---|---v---|---v---|---v---|---v---|---v---|
		log("\n");
		log("    pmux_statistics <command> [options] [selection]\n");
		log("\n");
		log("Makes statistics about pmux cells. Does not modify the design.\n");
		log("\n");
	}

	void execute(std::vector<std::string> args, RTLIL::Design *design) override
	{
		log_header(design, "Executing pmux_statistics pass.\n");

		if (GetSize(design->selected_modules()) == 0)
			log_cmd_error("Can't operate on an empty selection!\n");

		PmuxStatisticsWorker worker(design->top_module());
	}
} PmuxStatisticsPass;

PRIVATE_NAMESPACE_END
