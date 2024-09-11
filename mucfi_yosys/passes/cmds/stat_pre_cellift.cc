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

struct StatPreCelliftWorker {
private:
	bool opt_shift_ports;
	bool opt_cell_ports;

	const std::string pre_cellift_attr_name = ID(pre_cellift).str();

	dict<std::string, unsigned long> tot_num_cells_by_type;
	dict<std::string, unsigned long> pre_tainted_num_cells_by_type;

	/**
	 * @param candidate the potential pre_cellift attribute. 
	*
	 * @return true iff the attribute is a pre-cellift attribute.
	 */
	inline bool is_pre_cellift_param(std::string candidate_str) {
		return candidate_str.size() >= pre_cellift_attr_name.size() && candidate_str.substr(0, pre_cellift_attr_name.size()) == pre_cellift_attr_name;
	}

	/////////////////////////////
	// Main recursive function //
	/////////////////////////////

	/**
	 * @param module the current module.
	 */
	void stat_pre_cellift (RTLIL::Module *module) {		
		for (RTLIL::Cell *cell: module->cells()) {
			RTLIL::Module *submodule = module->design->module(cell->type);
			// If this is an elementary cell.
			if (submodule == nullptr) {
				// Increment the total cell count.
				if (tot_num_cells_by_type.find(cell->type.str()) == tot_num_cells_by_type.end())
					tot_num_cells_by_type[cell->type.str()] = 1;
				else
					tot_num_cells_by_type[cell->type.str()]++;

				// If the cell is pre-tainted, then increment the pre-tainted cell count.
				if (cell->has_attribute(pre_cellift_attr_name)) {
					if (pre_tainted_num_cells_by_type.find(cell->type.str()) == pre_tainted_num_cells_by_type.end())
						pre_tainted_num_cells_by_type[cell->type.str()] = 1;
					else
						pre_tainted_num_cells_by_type[cell->type.str()]++;
				}

				// If some flags requests printing taints for individual cells.
				if (opt_cell_ports || (opt_shift_ports && cell->type.in(ID($shl), ID($sshl), ID($shr), ID($sshr), ID($shift), ID($shiftx)))) {
					pool<std::pair<std::string, std::string>> cell_connection_attrs;
					bool has_pre_cellift_attr = false;
					std::string curr_wire_bit_attr_name;
					for (std::pair<RTLIL::IdString, RTLIL::SigSpec> connection: cell->connections()) {
						std::string connection_name = connection.first.str();
						RTLIL::SigSpec connection_sigspec = connection.second;
						std::string connection_attr_str(connection_sigspec.size(), '0');

						// Check the connection bitwise.
						for (int curr_bit_id = 0; curr_bit_id < connection_sigspec.size(); curr_bit_id++) {
							// If the bit is a constant, then do nothing. Only look at wire bits.
							if (connection_sigspec[curr_bit_id].wire) {
								RTLIL::Wire *connection_sigspec_wire = connection_sigspec[curr_bit_id].wire;

								// If the origin of the connection is not pre-tainted, then do nothing.
								for (std::pair<RTLIL::IdString, RTLIL::Const> attr: connection_sigspec_wire->attributes) {
									if (is_pre_cellift_param(attr.first.str())) {
										has_pre_cellift_attr = true;
										curr_wire_bit_attr_name = attr.first.str();
										break;
									}

								}
								if (!has_pre_cellift_attr)
									continue;

								// If the input pre-taint bit is one, so must be the output.
								if (connection_sigspec_wire->get_string_attribute(curr_wire_bit_attr_name)[connection_sigspec[curr_bit_id].offset] == '1' && connection_attr_str[curr_bit_id] == '0') {
									connection_attr_str[curr_bit_id] = '1';
								}
							}
						}
						cell_connection_attrs.insert(std::pair<std::string, std::string>(connection_name, connection_attr_str));
					}

					// Display the cell connections.
					log("Cell input pre-taint for %s of name %s in module %s:\n", cell->type.c_str(), cell->name.c_str(), module->name.c_str());
					for (std::pair<std::string, std::string> attr_pair: cell_connection_attrs) {
						log("  %-3s: %s\n", attr_pair.first.c_str(), attr_pair.second.c_str());
					}
				}

			} else {
				// If this is a submodule, then apply the statistics function recursively.
				stat_pre_cellift(submodule);
			}
		}
	}

	/////////////////////////////
	// Display wire pre-taints //
	/////////////////////////////

	void display_stats () {
		// First, compute the total number of cells and display it.
		unsigned long total_cell_count = 0;
		unsigned long pre_tainted_cell_count = 0;
		for (std::pair<std::string, unsigned long> cell_batch: tot_num_cells_by_type)
			total_cell_count += cell_batch.second;
		for (std::pair<std::string, unsigned long> cell_batch: pre_tainted_num_cells_by_type)
			pre_tainted_cell_count += cell_batch.second;

		float loss_percentage = 100 * ((float)(total_cell_count-pre_tainted_cell_count))/((float)total_cell_count);
		log("   Number of pre-tainted cells: %lu / %lu (removed %.2f %%).\n", pre_tainted_cell_count, total_cell_count, loss_percentage);

		for (std::pair<std::string, unsigned long> cell_batch: tot_num_cells_by_type) {
			total_cell_count = cell_batch.second;
			// If there are some pre-tainted of this type.
			if (pre_tainted_num_cells_by_type.find(cell_batch.first) != pre_tainted_num_cells_by_type.end()) {
				pre_tainted_cell_count = pre_tainted_num_cells_by_type[cell_batch.first];
				float loss_percentage = 100 * ((float)(total_cell_count-pre_tainted_cell_count))/((float)total_cell_count);
				log("     Pre-tainted %-20s: %6lu / %6lu (removed %6.2f %%).\n", cell_batch.first.c_str(), pre_tainted_cell_count, total_cell_count, loss_percentage);
			}
			else {
				pre_tainted_cell_count = 0;
				log("     Pre-tainted %-20s:      0 / %6lu (removed 100.00 %).\n", cell_batch.first.c_str(), total_cell_count);
			}
		}
	}

public:
	StatPreCelliftWorker(RTLIL::Module *top_module, bool _opt_cell_ports, bool _opt_shift_ports, bool _opt_no_general_stat) {
		opt_shift_ports = _opt_shift_ports;
		opt_cell_ports = _opt_cell_ports;

		pool<RTLIL::Wire*> top_wires = top_module->wires();
		dict<std::string, std::string> input_wires_taints;

		stat_pre_cellift(top_module);

		if(!_opt_no_general_stat)
			display_stats();
	}
};

struct StatPreCelliftPass : public Pass {
	StatPreCelliftPass() : Pass("stat_pre_cellift", "Counts the number of taintable cells.") {}

	void help() override
	{
		//   |---v---|---v---|---v---|---v---|---v---|---v---|---v---|---v---|---v---|---v---|
		log("\n");
		log("    stat_pre_cellift <command> [options] [selection]\n");
		log("\n");
		log("Makes statistics about the design after a static taint analysis.\n");
		log("\n");
		log("  -general-stat\n");
		log("    Displays the general statistics.\n");
		log("\n");
		log("  -cell-ports\n");
		log("    Displays statistics on all cells.\n");
		log("\n");
		log("  -shift-ports\n");
		log("    Displays statistics on the shift cells. Triggers an error if the -cell-ports\n");
		log("    flag is also present.\n");
		log("\n");
	}

	void execute(std::vector<std::string> args, RTLIL::Design *design) override
	{
		bool opt_shift_ports = false;
		bool opt_cell_ports = false;
		bool opt_no_general_stat = false;

		std::vector<std::string>::size_type argidx;
		for (argidx = 1; argidx < args.size(); argidx++) {
			if (args[argidx] == "-no-general-stat") {
				opt_no_general_stat = true;
				continue;
			}
			if (args[argidx] == "-shift-ports") {
				opt_shift_ports = true;
				continue;
			}
			if (args[argidx] == "-cell-ports") {
				opt_cell_ports = true;
				continue;
			}
		}

		log_header(design, "Executing stat_pre_cellift pass (statistics after pre-tainting).\n");

		if (GetSize(design->selected_modules()) == 0)
			log_cmd_error("Can't operate on an empty selection!\n");
		if (opt_cell_ports && opt_shift_ports)
			log_cmd_error("It is forbidden to specify flags -shift-ports and -cell-ports simultaneously!\n");

		StatPreCelliftWorker worker(design->top_module(), opt_cell_ports, opt_shift_ports, opt_no_general_stat);
	}
} StatPreCelliftPass;

PRIVATE_NAMESPACE_END
