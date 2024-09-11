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

struct RegroupMuxBySelWorker {
private:
	
	// Key: Number of muxes sharing the same signal.
	// Value: Number of occurrences.
	dict<int, int> muxes_per_select_signal_num_stats;
	dict<RTLIL::SigSpec, vector<RTLIL::Cell*>> muxes_per_select_signal;

	const std::string regroup_mux_by_sel_attr_name = ID(regroup_mux_by_sel).str();

	/////////////////////////////
	// Main recursive function //
	/////////////////////////////

	/**
	 * @param module the current module.
	 */
	void regroup_mux (RTLIL::Module *module) {

		for (RTLIL::Cell *cell: module->cells()) {
			RTLIL::Module *submodule = module->design->module(cell->type);
			// If this is an elementary cell.
			if (submodule == nullptr) {
				string cell_type = cell->type.str();
				if (cell_type == "$mux") { // $_MUX_ and $_NMUX_ come from the techmap pass and are therefore ignored.
					RTLIL::SigSpec selector_sigspec = cell->getPort(ID::S);
					// If this is the first mux controlled by this select signal.
					if (muxes_per_select_signal.find(selector_sigspec) == muxes_per_select_signal.end())
						muxes_per_select_signal[selector_sigspec] = std::vector<RTLIL::Cell*>({cell});
					else // If some other muxes are also controlled by this select signal.
						muxes_per_select_signal[selector_sigspec].push_back(cell);
				}
			} else {
				// If this is a submodule, then apply the statistics function recursively.
				regroup_mux(submodule);
			}
		}
	}

	//////////////////////////
	// Display the elements //
	//////////////////////////

	void display_statistics () {
		log("Num of muxes per cluster\n\n");
		muxes_per_select_signal_num_stats.sort();
		int last_key = 0;
		for (std::pair<int, int> stats_pair: muxes_per_select_signal_num_stats) {
			for (int absent_id = last_key+1; absent_id < stats_pair.first; absent_id++)
				log("%d 0\n", absent_id);
			log("%d %d\n", stats_pair.first, stats_pair.second);
			last_key = stats_pair.first;
		}
		log("\n\n");
	}

public:
	RegroupMuxBySelWorker(RTLIL::Module *top_module) {
		regroup_mux(top_module);

		// Make the statistics.
		for (std::pair<RTLIL::SigSpec, vector<RTLIL::Cell*>> select_pair: muxes_per_select_signal) {
			int num_cells_for_this_selector = select_pair.second.size();
			if (muxes_per_select_signal_num_stats.find(num_cells_for_this_selector) == muxes_per_select_signal_num_stats.end())
				muxes_per_select_signal_num_stats[num_cells_for_this_selector] = 1;
			else // If some other muxes are also controlled by this select signal.
				muxes_per_select_signal_num_stats[num_cells_for_this_selector]++;
		}

		display_statistics();
	}
};

struct RegroupMuxBySelPass : public Pass {
	RegroupMuxBySelPass() : Pass("regroup_mux_by_sel", "Regroups multiplexers by select signal.") {}

	void help() override
	{
		//   |---v---|---v---|---v---|---v---|---v---|---v---|---v---|---v---|---v---|---v---|
		log("\n");
		log("    regroup_mux_by_sel <command> [options] [selection]\n");
		log("\n");
		log("Regroups multiplexers by select signal. Does not modify the design.\n");
		log("\n");
	}

	void execute(std::vector<std::string> args, RTLIL::Design *design) override
	{
		log_header(design, "Executing regroup_mux_by_sel pass.\n");

		if (GetSize(design->selected_modules()) == 0)
			log_cmd_error("Can't operate on an empty selection!\n");

		RegroupMuxBySelWorker worker(design->top_module());
	}
} RegroupMuxBySelPass;

PRIVATE_NAMESPACE_END
