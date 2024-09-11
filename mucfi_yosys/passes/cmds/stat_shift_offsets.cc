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
    SHIFT_TYPE,
	SHIFTX_TYPE,
	SHL_TYPE,
	SHR_TYPE,
	SSHL_TYPE,
	SSHR_TYPE
} shift_cell_t;

struct StatShiftOffsetsWorker {
private:
	bool opt_shift_ports;
	bool opt_cell_ports;

	const std::string stat_shift_offsets_attr_name = ID(stat_shift_offsets).str();

	// Cannot use dict because the key is not hashable
	std::map<unsigned long, unsigned long> shift_cell_offsets[6];
	const std::string shift_cell_names[6] = {"$shift",
		"$shiftx",
		"$shl",
		"$shr",
		"$sshl",
		"$sshr"
	};

	/////////////////////////////
	// Main recursive function //
	/////////////////////////////

	/**
	 * @param module the current module.
	 */
	void stat_stat_shift_offsets (RTLIL::Module *module) {		
		for (RTLIL::Cell *cell: module->cells()) {
			RTLIL::Module *submodule = module->design->module(cell->type);
			// If this is an elementary cell.
			if (submodule == nullptr) {
				unsigned int shift_cell_offset;
				for (int i = 0; i < 6; i++) {
					if (cell->type.str() == shift_cell_names[i]) {
						shift_cell_offset = cell->getParam(ID(B_WIDTH)).as_int();
						if (shift_cell_offsets[i].find(shift_cell_offset) == shift_cell_offsets[i].end()) {
							shift_cell_offsets[i][shift_cell_offset] = 1;
						} else {
							shift_cell_offsets[i][shift_cell_offset]++;
						}

						log("Found a shift (%s) of width %lu in module %s\n", shift_cell_names[i].c_str(), shift_cell_offset, module->name.c_str());
					}
				}
			} else {
				// If this is a submodule, then apply the statistics function recursively.
				stat_stat_shift_offsets(submodule);
			}
		}
	}

	/////////////////////////////
	// Display wire pre-taints //
	/////////////////////////////

	void display_stats () {

		for (int i = 0; i < 6; i++) {
			log("Cell is %s\n", shift_cell_names[i].c_str());

			for (auto const& curr_offset : shift_cell_offsets[i]) {
				log("  %lu is %lu\n", curr_offset.first, curr_offset.second);
			}
		}

		// log("shift_offsets\n");
		// log("shiftx_offsets\n");
		// log("shl_offsets\n");
		// log("shr_offsets\n");
		// log("shl_offsets\n");
		// log("shr_offsets\n");
		// // First, compute the total number of cells and display it.
		// unsigned long total_cell_count = 0;
		// unsigned long pre_tainted_cell_count = 0;
		// for (std::pair<std::string, unsigned long> cell_batch: tot_num_cells_by_type)
		// 	total_cell_count += cell_batch.second;
		// for (std::pair<std::string, unsigned long> cell_batch: pre_tainted_num_cells_by_type)
		// 	pre_tainted_cell_count += cell_batch.second;

		// float loss_percentage = 100 * ((float)(total_cell_count-pre_tainted_cell_count))/((float)total_cell_count);
		// log("   Number of pre-tainted cells: %lu / %lu (removed %.2f %%).\n", pre_tainted_cell_count, total_cell_count, loss_percentage);

		// for (std::pair<std::string, unsigned long> cell_batch: tot_num_cells_by_type) {
		// 	total_cell_count = cell_batch.second;
		// 	// If there are some pre-tainted of this type.
		// 	if (pre_tainted_num_cells_by_type.find(cell_batch.first) != pre_tainted_num_cells_by_type.end()) {
		// 		pre_tainted_cell_count = pre_tainted_num_cells_by_type[cell_batch.first];
		// 		float loss_percentage = 100 * ((float)(total_cell_count-pre_tainted_cell_count))/((float)total_cell_count);
		// 		log("     Pre-tainted %-20s: %6lu / %6lu (removed %6.2f %%).\n", cell_batch.first.c_str(), pre_tainted_cell_count, total_cell_count, loss_percentage);
		// 	}
		// 	else {
		// 		pre_tainted_cell_count = 0;
		// 		log("     Pre-tainted %-20s:      0 / %6lu (removed 100.00 %).\n", cell_batch.first.c_str(), total_cell_count);
		// 	}
		// }
	}

public:
	StatShiftOffsetsWorker(RTLIL::Module *top_module) {
		stat_stat_shift_offsets(top_module);

		display_stats();
	}
};

struct StatShiftOffsetsPass : public Pass {
	StatShiftOffsetsPass() : Pass("stat_shift_offsets", "Makes statistics for the shift cells offsets.") {}

	void help() override
	{
		//   |---v---|---v---|---v---|---v---|---v---|---v---|---v---|---v---|---v---|---v---|
		log("\n");
		log("    stat_shift_offsets <command> [options] [selection]\n");
		log("\n");
		log("Makes statistics for the shift cells offsets.\n");
		log("\n");
	}

	void execute(std::vector<std::string> args, RTLIL::Design *design) override
	{
		log_header(design, "Executing stat_shift_offsets pass (statistics for shift offsets).\n");

		if (GetSize(design->selected_modules()) == 0)
			log_cmd_error("Can't operate on an empty selection!\n");

		StatShiftOffsetsWorker worker(design->top_module());
	}
} StatShiftOffsetsPass;

PRIVATE_NAMESPACE_END
