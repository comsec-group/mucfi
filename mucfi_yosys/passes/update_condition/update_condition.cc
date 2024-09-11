/*
 *  yosys -- Yosys Open SYnthesis Suite
 *
 *  Copyright (C) 2012  Claire Xenia Wolf <claire@yosyshq.com>
 *                2020  Alberto Gonzalez <boqwxp@airmail.cc> & Flavien Solt <flsolt@ethz.ch>
 *                2023  Katharina Ceesay-Seitz <kceesay@ethz.ch>
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

// For all new cells, add src=cell->get_src_attribute()

#include "kernel/log.h"
#include "kernel/register.h"
#include "kernel/rtlil.h"
#include "kernel/utils.h"
#include "kernel/yosys.h"
#include "passes/update_condition/update_condition.h"

USING_YOSYS_NAMESPACE

#define LOG_UC_COND

extern bool is_signal_excluded(std::vector<string> *excluded_signals, string signal_name);

namespace UpdateCondition {

	dict<RTLIL::IdString, RTLIL::SigSpec> uc_cache;

	void log_uc_cond(char *msg, ...){
#ifdef LOG_UC_COND
		log(msg);
#endif
	}

	void log_cmd_error_lineinfo(const char *err_msg, ...) {
		va_list ap;
	  va_start(ap, err_msg);
		string msg = vstringf(err_msg, ap);
		log_cmd_error("%s:%d: %s", __FILE__, __LINE__, msg.c_str());
	}

	void set_past_attribute(RTLIL::SigSpec &sig) {
		if (sig.is_wire())
        sig.as_wire()->set_bool_attribute(ID(uc_past), true);
	}

	// The last element in the cell hierarch points to the cell that contains the current working cell.
	// This containing cell is a module instance cell.
	// It may be a nullptr, which is the case if the cell was part of the top module.
	// However, if the hierachy is empty, there was an implementation error somewhere.
	// Returns NULL in the special case where the current instance is the top module
	RTLIL::Cell *get_curr_instance_cell(std::vector<RTLIL::Cell *> cell_hierarchy) {
		RTLIL::Cell *curr_instance_cell = nullptr;

		if (cell_hierarchy.size() > 0) {
				curr_instance_cell = cell_hierarchy.back();
		} else {
				log_cmd_error_lineinfo("Cell hierarchy is empty.\n");
		}
		return curr_instance_cell;
	}

	RTLIL::Cell *pop_curr_instance_cell(std::vector<RTLIL::Cell *> cell_hierarchy) {
		RTLIL::Cell *curr_instance_cell = get_curr_instance_cell(cell_hierarchy);
		cell_hierarchy.pop_back();
		return curr_instance_cell;
	}

	// Return true if there is a signal chunk in the sigspec that has the provided name.
	// Chunks of the same signal have the same name and are addressed by width and offset.
	// This function returns true if the name matches any of the chunks.
	bool name_in_sigspec(RTLIL::SigSpec sig, RTLIL::IdString name) {
		for (auto it = sig.chunks().rbegin(); it != sig.chunks().rend(); ++it) {
			// If the sigchunk is not a wire, it's a constant value without name, so we can ignore it.
			// if ((*it).is_wire()) // DEBUG
			// 	log("Comparing cell output %s with %s\n", (*it).wire->name.c_str(), name.c_str());
			if ((*it).is_wire() && name == (*it).wire->name) {
				return true;
			}
		}
		return false;
	}

	// Determine whether a cell is a state element based on its driving cell (if any).
	bool is_state_element(RTLIL::Module *module, RTLIL::IdString signal_name) {
		for (auto cell : module->cells()) {
			 if (cell->hasPort(ID::Q)) {
				if (name_in_sigspec(cell->getPort(ID::Q), signal_name)) {
					return true;
				}
			} else if (cell->type.in(ID($memrd), ID($memrd_v2))) {
				if (name_in_sigspec(cell->getPort(ID::DATA), signal_name)) {
					return true;
				}
			}
		}
		return false;
	}

	std::vector<RTLIL::Cell *> find_driving_cell(std::vector<RTLIL::Cell *> cells, RTLIL::IdString signal_name) {
		std::vector<RTLIL::Cell *> update_cells;

		for (auto cell : cells) {
			if (cell->hasPort(ID::Y)) {
				if (name_in_sigspec(cell->getPort(ID::Y), signal_name)) {
					update_cells.push_back(cell);
					log("UpdateConditionDebug: Found signal %s at cell %s, port Y.\n", signal_name.c_str(), cell->name.c_str());
				}
			} else if (cell->hasPort(ID::Q)) {
				if (name_in_sigspec(cell->getPort(ID::Q), signal_name)) {
					update_cells.push_back(cell);
					log("UpdateConditionDebug: Found signal  %s at cell %s, port Q.\n", signal_name.c_str(), cell->name.c_str());
				}
			} else if (cell->type.in(ID($memrd), ID($memrd_v2))) {
				if (name_in_sigspec(cell->getPort(ID::DATA), signal_name)) {
					update_cells.push_back(cell);
					log("UpdateConditionDebug: Found signal  %s at cell %s, port DATA.\n", signal_name.c_str(), cell->name.c_str());
				}
			}
		}
		return update_cells;
	}

	// Find the cell that writes to the memory that is read by the memrd_cell.
	// The memory is identified by the memid parameter of both cells.
	// Each memory has only one write cell (to be confirmed)
	RTLIL::Cell *find_memwr_cell(RTLIL::Cell *memrd_cell) {
		bool memwr_found = false;
		RTLIL::Cell *memwr_cell = nullptr;
		RTLIL::Const memid_memrd = memrd_cell->getParam(ID::MEMID);
		for (auto cell : memrd_cell->module->cells()) {
			if (cell->type.in(ID($memwr), ID($memwr_v2))) {
				RTLIL::Const memid_memwr = cell->getParam(ID::MEMID);
				if (memid_memrd == memid_memwr) {
					if (memwr_found)
						log_cmd_error_lineinfo("Found more than one write cell for memory %s.\n", memid_memrd.as_string().c_str());
					memwr_cell = cell;
					memwr_found = true;
				}
			}
		}
		if (!memwr_found)
			log_cmd_error_lineinfo("No write cell found for memory %s.\n", memid_memrd.as_string().c_str());
		return memwr_cell;

	}

	bool all_chunks_in_list(RTLIL::SigSpec sig, std::vector<string> *read_from_signals) {
		for (auto it = sig.chunks().rbegin(); it != sig.chunks().rend(); ++it) {
			for (auto read_from_sig : *read_from_signals) {
				if ((*it).is_wire()) {
					RTLIL::IdString chunk_name = (*it).wire->name;
					if (chunk_name.str().size() >= read_from_sig.size()) {
						// Search whether the included signal is a prefix of the signal name
						if (chunk_name.str().find(read_from_sig) != 0) {
							log_uc_cond("UC_COND: 0 - found an assignment from %s to %s\n", chunk_name.c_str(), read_from_sig.c_str());
							return false;
						}
					}
				}
			}
		}
		return true;
	}

	RTLIL::SigSpec uc_assignment(RTLIL::Design *design, std::vector<RTLIL::Cell *> cell_hierarchy, RTLIL::Cell *curr_instance_cell, const RTLIL::SigSpec &sig, visited_signals_t visited_signals, std::vector<string> *excluded_signals, std::vector<string> *read_from_signals){
		RTLIL::SigSpec uc_sig;

		if (sig.chunks().size() > 1) {
			// Assignment with multiple chunks are not treated as self-assignment
			// ... although if all of them would be from the same signal, it coulb be a self assignment, but only if all of them are assigned with the same bit position
			// ... assuming that Yosys would not split these assignments into chunks.
			// ... any case where a potentila self-assignment is combined or re-orderd is not a self assignment
			//
			// Read from considers partial, or re-ordered chunks, as long as they are not combined with other signals
			if ((*read_from_signals).size() == 0 || all_chunks_in_list(sig, read_from_signals)) {
				log_uc_cond("UC_COND: 1 (assignemnt with concatenation is not treated as self-assignments)\n");
				uc_sig = RTLIL::SigBit(RTLIL::State::S1);
			} else {
				uc_sig = RTLIL::SigBit(RTLIL::State::S0);
			}
		} else {
			if (sig.chunks()[0].is_wire()) {
				uc_sig = create_uc_logic(design, cell_hierarchy, curr_instance_cell, sig.chunks()[0].wire, visited_signals, excluded_signals, read_from_signals);
			} else {
				if ((*read_from_signals).size() == 0) {
					log_uc_cond("UC_COND: const 1\n");
					uc_sig = RTLIL::SigBit(RTLIL::State::S1);
				} else {
					log_uc_cond("UC_COND: const 0\n");
					uc_sig = RTLIL::SigBit(RTLIL::State::S0);
				}
			}
		}
		return uc_sig;
	}

	RTLIL::SigSpec uc_cell_port(RTLIL::Design *design, std::vector<RTLIL::Cell *> cell_hierarchy, RTLIL::Cell *cell, RTLIL::IdString port_name, visited_signals_t &visited_signals, std::vector<string> *excluded_signals, std::vector<string> *read_from_signals) {
		const RTLIL::SigSpec &sig = cell->getPort(port_name);
		RTLIL::Cell *curr_instance_cell = pop_curr_instance_cell(cell_hierarchy);
		return uc_assignment(design, cell_hierarchy, curr_instance_cell, sig, visited_signals, excluded_signals, read_from_signals);
	}

	// Creates a new wire in the provided module. The wire is assigned with the observed signal and
	// has the provided bool attributes set.
	RTLIL::SigSpec create_observing_wire(RTLIL::Module *module, RTLIL::SigSpec observed_sig,
																		std::vector<IdString> bool_attributes){
		RTLIL::Wire *observing_wire = module->addWire(NEW_ID, observed_sig.size());

		for (auto &attr : bool_attributes) {
				observing_wire->set_bool_attribute(attr, true);
		}

		RTLIL::SigSpec observing_sigspec(observing_wire);
		module->connect(observing_sigspec, observed_sig);
		return observing_sigspec;
	}

	// Find the wire that corresponds to the signal name
	RTLIL::Wire *find_wire(RTLIL::Module *start_module, RTLIL::IdString signal_name) {
		if (start_module->wires_.find(signal_name) != start_module->wires_.end())
			return start_module->wires_.at(signal_name);
		else
			log_cmd_error_lineinfo("Signal %s not found in module %s.\n", signal_name.c_str(), start_module->name.c_str());
	}

	// Updates visited signals and returns false if signal_name is already in visited_signals.
	bool update_visited_signals(visited_signals_t &visited_signals, RTLIL::IdString signal_name) {
		// TODO: Does not yet work accross module boundaries. Signals in different modules may have the same name.
		// Should store the instance's hierarchical path (or an equivalent Yosys ID) together with the visited signal names.

		// Update condition is 0 if the signal has already been visited. This avoids loops and excludes self-assignments from the update condition.
		if (std::find(visited_signals.begin(), visited_signals.end(), signal_name) != visited_signals.end()) {
			log("UpdateConditionDebug: Signal %s has self-assignment. Returning 0.\n", signal_name.c_str());
			for (auto e : visited_signals) {
				log("Visited signal: %s\n", e.c_str());
			}
			return false;
		}

		visited_signals.push_back(signal_name);
		for (auto v : visited_signals) {
			log("Visited signal: %s\n", v.c_str());
		}
		return true;
	}

	std::tuple<bool, RTLIL::SigSpec> uc_logic_check_read_from(std::vector<string> *read_from_signals, RTLIL::IdString signal_name, RTLIL::IdString start_signal_name) {
		bool ret = false;
		RTLIL::SigSpec ret_sig;

		// Check whether the current signal is in the read-from list
		bool signal_included = false;
		for (auto read_from_sig : *read_from_signals) {
			log("Checking included signal %s against signal %s\n", read_from_sig.c_str(), signal_name.c_str());
			if (signal_name.str().size() >= read_from_sig.size()) {
				// Search whether the included signal is a prefix of the signal name
				if (signal_name.str().find(read_from_sig) == 0) {
					signal_included = true;
				}
			}
		}
		if (signal_included) {
			log("UpdateConditionDebug: Signal %s was specified to be included. Returning 1.\n", signal_name.c_str());
			log_uc_cond("UC_COND: 1\n");
			return std::make_tuple(true, RTLIL::SigBit(RTLIL::State::S1));
		}

		// If we reached a design signal (indicated by \ at the beginning of the name), and that signal is not in the include list, return 0
		if (signal_name.str()[0] == '\\' && !signal_included) {
			log("UpdateConditionDebug: Signal %s was not specified to be included. Returning 0.\n", signal_name.c_str());
			log_uc_cond("UC_COND: 0\n");
			return std::make_tuple(true, RTLIL::SigBit(RTLIL::State::S0));
		}

		return std::make_tuple(false, ret_sig);
	}

	// Checks whether all cells in update_cells have the same type, same input/output signal names and same fully const ports.
	bool all_cells_same(std::vector<Yosys::RTLIL::Cell *> &update_cells) {
		std::vector<RTLIL::IdString> first_cell_fully_const_ports;
		std::vector<std::tuple<RTLIL::IdString, RTLIL::IdString>> first_cell_input_ports;
		std::vector<std::tuple<RTLIL::IdString, RTLIL::IdString>> first_cell_output_ports;
		RTLIL::IdString first_cell_type = update_cells.at(0)->type;
		for (auto con : update_cells.at(0)->connections()){
			bool inout_type;
			if (update_cells.at(0)->getPort(con.first).is_fully_const()) {
				first_cell_fully_const_ports.push_back(con.first);
			} else {
				if (update_cells.at(0)->input(con.first)) {
					inout_type = true;
				} else {
					inout_type = false;
				}
				for (auto chunk : con.second.chunks()) {
					// Collect the wires, ignore the consts. Mismatching positions of consts do not matter.
					if (chunk.is_wire()) {
						if (inout_type)
							first_cell_input_ports.push_back(std::make_tuple(con.first, chunk.wire->name));
						else
							first_cell_output_ports.push_back(std::make_tuple(con.first, chunk.wire->name));
					}
				}
			}
		}
		for (auto cell_it = update_cells.begin() + 1; cell_it != update_cells.end(); ++cell_it) {
			if ((*cell_it)->type != first_cell_type) {
				log("UpdateConditionDebug: Cells have different types.\n");
				return false;
			}
			for (auto con : (*cell_it)->connections()){
				if ((*cell_it)->getPort(con.first).is_fully_const()) {
					if (std::find(first_cell_fully_const_ports.begin(), first_cell_fully_const_ports.end(), con.first) == first_cell_fully_const_ports.end()) {
						log("UpdateConditionDebug: Cells have different fully const ports.\n");
						return false;
					}
				} else {
					bool inout_type;
					if ((*cell_it)->input(con.first)) {
						inout_type = true;
					} else {
						inout_type = false;
					}
					for (auto chunk : con.second.chunks()) {
						if (chunk.is_wire()) {
							if (inout_type) {
								if (std::find(first_cell_input_ports.begin(), first_cell_input_ports.end(), std::make_tuple(con.first, chunk.wire->name)) == first_cell_input_ports.end()) {
									log("UpdateConditionDebug: Cells have different input ports.\n");
									return false;
								}
							} else {
								if (std::find(first_cell_output_ports.begin(), first_cell_output_ports.end(), std::make_tuple(con.first, chunk.wire->name)) == first_cell_output_ports.end()) {
									log("UpdateConditionDebug: Cells have different output ports.\n");
									return false;
								}
							}
						}
					}
				}
			}
		}
		return true;
	}


  // The update condition cells are always placed into the top module,
	// because they can consist of various signals from different modules.
	RTLIL::SigSpec create_uc_logic(RTLIL::Design *design, std::vector<RTLIL::Cell *> cell_hierarchy, RTLIL::Cell *curr_instance_cell, RTLIL::Wire *sig, visited_signals_t &visited_signals, std::vector<string> *excluded_signals, std::vector<string> *read_from_signals)	{
		RTLIL::IdString signal_name = sig->name;

		// Check if we have already created an update condition for this signal
		if (uc_cache.find(signal_name) != uc_cache.end()) {
			log("UpdateConditionDebug: Found cached update condition for signal %s: %s.\n", signal_name.c_str(), log_signal(uc_cache.at(signal_name)));
			// TODO: should check for visited signals
			return uc_cache.at(signal_name);
		}

		// Store either the pointer to the wire or the constant value in the cache
		RTLIL::SigSpec uc_sig = _create_uc_logic(design, cell_hierarchy, curr_instance_cell, sig, visited_signals, excluded_signals, read_from_signals);
		uc_cache[signal_name] = uc_sig;
		return uc_sig;
	}

	RTLIL::SigSpec _create_uc_logic(RTLIL::Design *design, std::vector<RTLIL::Cell *> cell_hierarchy, RTLIL::Cell *curr_instance_cell, RTLIL::Wire *sig, visited_signals_t &visited_signals, std::vector<string> *excluded_signals, std::vector<string> *read_from_signals)	{
		static RTLIL::IdString start_signal_name = ID("");
		bool in_top_module = false;

		RTLIL::IdString signal_name = sig->name;
    log("UpdateConditionDebug: Generating update condition for signal %s.\n", signal_name.c_str());

		if (start_signal_name == ID("")) {
			start_signal_name = signal_name;
		}

		// Find start module
		RTLIL::Module *start_module;
		// Check if the signal is in top module
		if (curr_instance_cell == nullptr) {
			start_module = design->top_module();
			in_top_module = true;
			// TODO: return 1 in case a signal is an input to the top module and read_from_list is empty, otherwise 0
		} else {
			start_module = curr_instance_cell->module;

			// If signal is an input port, its update condition is the one of the signal that connects to it in
			// the module that contains the current cell/instance.
			if (curr_instance_cell->input(signal_name)){
				// TODO: we have no reference to hierarchically higher cells, only to the module type of the higher cell.
				// Will have to make the reference available
				// // return update cond of
				// RTLIL::SigSpec sig_at_input = curr_instance_cell->module->cells(curr_instance_cell->name).connections().at(signal_name);
				log_cmd_error_lineinfo("Signal %s is an input port. Its update condition is the one of the signal that connects to it in the module that contains the current cell/instance. This is not yet implemented. Use 'flatten' pass before\n", signal_name.c_str());
			}
		}

		// Check for path terminating conditions. First, check for explicitely ex- or included signals.

		// Check only if we have passed the start signal
		if (signal_name.str().compare(start_signal_name.str())) {
			if (std::find(excluded_signals->begin(), excluded_signals->end(), signal_name.str()) != excluded_signals->end()) {
				log("UpdateConditionDebug: Signal %s was specified to be excluded. Returning 0.\n", signal_name.c_str());
				log_uc_cond("UC_COND: 0\n");
				return RTLIL::SigBit(RTLIL::State::S0);
			}

			if ((*read_from_signals).size() > 0) {
				bool ret;
				RTLIL::SigSpec ret_sig;
				std::tie(ret, ret_sig) = uc_logic_check_read_from(read_from_signals, signal_name, start_signal_name);
				if (ret)
					return ret_sig;
			}
		}

		// If the signal was not explicitely ex- or included, we continue with the update condition generation.

		if (!update_visited_signals(visited_signals, signal_name)) {
			log("UpdateConditionDebug: Signal %s has already been visited. Self-assignments are no updates. Returning 0.\n", signal_name.c_str());
			log_uc_cond("UC_COND: 0\n");
			return RTLIL::SigBit(RTLIL::State::S0);
		}

		// A top level input may be updated anytime, so unless the input is in the exclude list, this is a path of interest
		if (in_top_module){
			if(sig->port_input){
				log("UpdateConditionDebug: Signal %s is a top module input. Returning 1.\n", signal_name.c_str());
			  log_uc_cond("UC_COND: 1\n");
				return RTLIL::SigBit(RTLIL::State::S1);
			}
		}

		// Check whether signal_name is directly assigned with the value of another signal via
		// a direct connection (assuming that signals can only be assigned via connections or via cells)
		int multiple_connections = 0;
		RTLIL::SigSpec uc_connected_sig;
		for (auto conn: start_module->connections()) {
			if (name_in_sigspec(conn.first, sig->name)) {
				uc_connected_sig = uc_assignment(design, cell_hierarchy, curr_instance_cell, conn.second, visited_signals, excluded_signals, read_from_signals);
				multiple_connections++;
				if (multiple_connections > 1) {
					log_cmd_error_lineinfo("Signal %s is connected to multiple signals. This is not yet supported.\n", sig->name.c_str());
				}
			}
		}
		if (multiple_connections == 1) {
			return uc_connected_sig;
		}
		// else: signal is not driven by a direct assignment.

		// Finally, if sig is connected to a cell output, we need to apply cell update condition rules.

		std::vector<Yosys::RTLIL::Cell *> start_module_cells = start_module->cells().to_vector();
		std::vector<Yosys::RTLIL::Cell *> update_cells;

		std::vector<Yosys::RTLIL::Cell *> driving_cells = find_driving_cell(start_module_cells, sig->name);
		update_cells.insert(update_cells.end(), driving_cells.begin(), driving_cells.end());

		if (driving_cells.empty()) {
			log_cmd_error_lineinfo("Signal %s of module %s not found at any output of a cell and it is not a module input, has no wire connection. Something went wrong.\n", sig->name.c_str(), start_module->name.c_str());
		}

		if (update_cells.size() > 1) {
			if ((*read_from_signals).size() > 0) {
				// Since we are not checking for update conditions of individual chunks of sigals, there is a special case that is ok:
				// If the signal is driven by mutliple cells of same type and, which have exactly the same inputs and outputs (but potentialy update different partial selections of the signal), then we can continue with the update condition of any of these cells (as they will be the same anyway).

				log("Signal %s is driven by multiple cells\n", sig->name.c_str());
				if (!all_cells_same(update_cells)) {
					log("Signal %s is driven by multiple cells and different signals\n", sig->name.c_str());
					log_uc_cond("UC_COND: 0\n");
					return RTLIL::SigBit(RTLIL::State::S0);
				}

			} else {
				log("UC_COND: 1. Signal %s is driven by multiple cells. That means it's chunks are assigned with individual cells. Assuming that this is no self-assignment.\n", sig->name.c_str());
				return RTLIL::SigBit(RTLIL::State::S1);
			}
		}

		// Add the module that contains the current udpate_cells to the hierarchy
		cell_hierarchy.push_back(curr_instance_cell);
		log_uc_cond("UC_COND: (\n");
		RTLIL::SigSpec uc_sig = create_cell_uc_logic(design, cell_hierarchy, update_cells.at(0), visited_signals, excluded_signals, read_from_signals);
    log_uc_cond("UC_COND: )\n");
		return uc_sig;
	}

	// current instance cell has been added to hierarchy, current cell is the one where we need to construct the uc logic for
	RTLIL::SigSpec create_cell_uc_logic(RTLIL::Design *design, std::vector<RTLIL::Cell *> cell_hierarchy, RTLIL::Cell *cell, visited_signals_t &visited_signals, std::vector<string> *excluded_signals, std::vector<string> *read_from_signals) {
			RTLIL::SigSpec uc_sig;

			if (cell == nullptr)
				return  RTLIL::SigBit(RTLIL::State::S1);
			////
			// Latches
			////

			// if (cell->type.in(ID($dlatch)))
			// 	uc_sig = uc_dlatchdesign, cell_hierarchy, cell, visited_signals, excluded_signals, read_from_signals);

			// else if (cell->type.in(ID($_DLATCH_N_), ID($_DLATCH_P_)))
			// 	uc_sig = uc_dlatch_endesign, cell_hierarchy, cell, visited_signals, excluded_signals, read_from_signals);

			// ////
			// // Flip-flops
			// ////

			if (cell->type.in(ID($dff)))
				uc_sig = uc_dff(design, cell_hierarchy, cell, visited_signals, excluded_signals, read_from_signals);

			// else if (cell->type.in(ID($_DFF_NN0_), ID($_DFF_NN1_), ID($_DFF_NP0_), ID($_DFF_NP1_), ID($_DFF_PN0_), ID($_DFF_PN1_),
			// 		       ID($_DFF_PP0_), ID($_DFF_PP0_)))
			// 	uc_sig = uc_dff_techmapdesign, cell_hierarchy, cell, visited_signals, excluded_signals, read_from_signals);

			else if (cell->type.in(ID($adff)))
				uc_sig = uc_adff(design, cell_hierarchy, cell, visited_signals, excluded_signals, read_from_signals);

      // else if (cell->type.in(ID($aldff)))
			// 	uc_sig = uc_aldffdesign, cell_hierarchy, cell, visited_signals, excluded_signals, read_from_signals);

			else if (cell->type.in(ID($sdff)))
				uc_sig = uc_sdff(design, cell_hierarchy, cell, visited_signals, excluded_signals, read_from_signals);

			// else if (cell->type.in(ID($_SDFF_NN0_), ID($_SDFF_NN1_), ID($_SDFF_NP0_), ID($_SDFF_NP1_), ID($_SDFF_PN0_), ID($_SDFF_PN1_),
			// 		       ID($_SDFF_PP0_), ID($_SDFF_PP1_)))
			// 	uc_sig = uc_sdff_techmapdesign, cell_hierarchy, cell, visited_signals, excluded_signals, read_from_signals);

			else if (cell->type.in(ID($adffe)))
				uc_sig = uc_adffe(design, cell_hierarchy, cell, visited_signals, excluded_signals, read_from_signals);

			else if (cell->type.in(ID($sdffe)))
				uc_sig = uc_sdffe(design, cell_hierarchy, cell, visited_signals, excluded_signals, read_from_signals);

			else if (cell->type.in(ID($dffe), ID($_DFFE_NP_), ID($_DFFE_PP_)))
				uc_sig = uc_dffe(design, cell_hierarchy, cell, visited_signals, excluded_signals, read_from_signals);

			else if (cell->type.in(ID($_DFFE_NN_), ID($_DFFE_PN_)))
				uc_sig = uc_dffe_n(design, cell_hierarchy, cell, visited_signals, excluded_signals, read_from_signals);

			else if (cell->type.in(ID($sdffce)))
				uc_sig = uc_dffe(design, cell_hierarchy, cell, visited_signals, excluded_signals, read_from_signals); // same uc as dffe

			// else if (cell->type.in(ID($_SDFFCE_NN0N_), ID($_SDFFCE_NN0P_), ID($_SDFFCE_NN1N_), ID($_SDFFCE_NN1P_), ID($_SDFFCE_NP0N_),
			// 		       ID($_SDFFCE_NP0P_), ID($_SDFFCE_NP1N_), ID($_SDFFCE_NP1P_), ID($_SDFFCE_PN0N_), ID($_SDFFCE_PN0P_),
			// 		       ID($_SDFFCE_PN1N_), ID($_SDFFCE_PN1P_), ID($_SDFFCE_PP0N_), ID($_SDFFCE_PP0P_), ID($_SDFFCE_PP1N_),
			// 		       ID($_SDFFCE_PP1P_)))
			// 	uc_sig = uc_sdffce_techmapdesign, cell_hierarchy, cell, visited_signals, excluded_signals, read_from_signals);

			// else if (cell->type.in(ID($_SDFFE_NN0N_), ID($_SDFFE_NN0P_), ID($_SDFFE_NN1N_), ID($_SDFFE_NN1P_), ID($_SDFFE_NP0N_),
			// 		       ID($_SDFFE_NP0P_), ID($_SDFFE_NP1N_), ID($_SDFFE_NP1P_), ID($_SDFFE_PN0N_), ID($_SDFFE_PN0P_),
			// 		       ID($_SDFFE_PN1N_), ID($_SDFFE_PN1P_), ID($_SDFFE_PP0N_), ID($_SDFFE_PP0P_), ID($_SDFFE_PP1N_),
			// 		       ID($_SDFFE_PP1P_)))
			// 	uc_sig = uc_sdffe_techmapdesign, cell_hierarchy, cell, visited_signals, excluded_signals, read_from_signals);
			// else if (cell->type.in(ID($_DFFE_NN0N_), ID($_DFFE_NN0P_), ID($_DFFE_NN1N_), ID($_DFFE_NN1P_), ID($_DFFE_NP0N_),
			// 		       ID($_DFFE_NP0P_), ID($_DFFE_NP1N_), ID($_DFFE_NP1P_), ID($_DFFE_PN0N_), ID($_DFFE_PN0P_),
			// 		       ID($_DFFE_PN1N_), ID($_DFFE_PN1P_), ID($_DFFE_PP0N_), ID($_DFFE_PP0P_), ID($_DFFE_PP1N_),
			// 		       ID($_DFFE_PP1P_)))
			// 	uc_sig = uc_dffe_rst_techmapdesign, cell_hierarchy, cell, visited_signals, excluded_signals, read_from_signals);

			// else if (cell->type.in(ID($_SDFF_PN0_), ID($_SDFF_PN1_), ID($_SDFF_PP0_)))
			// 	uc_sig = uc_sdff_techmapdesign, cell_hierarchy, cell, visited_signals, excluded_signals, read_from_signals);
			// else if (cell->type.in(ID($_DFF_N_), ID($_DFF_P_)))
			// 	uc_sig = uc_dff_simple_techmapdesign, cell_hierarchy, cell, visited_signals, excluded_signals, read_from_signals);

			// ////
			// // Stateless cells
			// ////

			else if (cell->type.in(ID($add), ID($sub)))
				uc_sig = uc_comb_two_input_cell(design, cell_hierarchy, cell, visited_signals, excluded_signals, read_from_signals);

			else if (cell->type.in(ID($not), ID($_NOT_), ID($logic_not)))
				uc_sig = uc_comb_one_input_cell(design, cell_hierarchy, cell, visited_signals, excluded_signals, read_from_signals);

			else if (cell->type.in(ID($neg)))
				uc_sig = uc_comb_one_input_cell(design, cell_hierarchy, cell, visited_signals, excluded_signals, read_from_signals);

			else if (cell->type.in(ID($and), ID($_AND_), ID($_NAND_)))
				uc_sig = uc_comb_two_input_cell(design, cell_hierarchy, cell, visited_signals, excluded_signals, read_from_signals);

			else if (cell->type.in(ID($or), ID($_OR_), ID($_NOR_)))
				uc_sig = uc_comb_two_input_cell(design, cell_hierarchy, cell, visited_signals, excluded_signals, read_from_signals);

			else if (cell->type.in(ID($pmux)))
				log_cmd_error_lineinfo("pmux currently not supported. Use 'pmuxtree' pass before this one.\n");

			else if (cell->type.in(ID($mux), ID($_MUX_), ID($_NMUX_)))
				uc_sig = uc_mux(design, cell_hierarchy, cell, visited_signals, excluded_signals, read_from_signals);

			else if (cell->type.in(ID($xor), ID($xnor), ID($_XOR_), ID($_XNOR_)))
				uc_sig = uc_comb_two_input_cell(design, cell_hierarchy, cell, visited_signals, excluded_signals, read_from_signals);

			else if (cell->type.in(ID($eq), ID($eqx), ID($ne), ID($nex)))
				 uc_sig = uc_comb_two_input_cell(design, cell_hierarchy, cell, visited_signals, excluded_signals, read_from_signals);

			else if (cell->type.in(ID($ge), ID($gt), ID($le), ID($lt)))
				 uc_sig = uc_comb_two_input_cell(design, cell_hierarchy, cell, visited_signals, excluded_signals, read_from_signals);

			else if (cell->type.in(ID($logic_and), ID($logic_or)))
				 uc_sig = uc_comb_two_input_cell(design, cell_hierarchy, cell, visited_signals, excluded_signals, read_from_signals);

			else if (cell->type.in(ID($reduce_and), ID($reduce_or), ID($reduce_bool), ID($reduce_xor), ID($reduce_xnor), ID($reduce_or)))
					uc_sig = uc_comb_one_input_cell(design, cell_hierarchy, cell, visited_signals, excluded_signals, read_from_signals);

			else if (cell->type.in(ID($shl), ID($sshl), ID($shr), ID($sshr)))
					uc_sig = uc_comb_one_input_cell(design, cell_hierarchy, cell, visited_signals, excluded_signals, read_from_signals);

			// else if ((cell->type.in(ID($shift)) && opt_precise_shiftx) || (cell->type.in(ID($shiftx)) && opt_precise_shiftx))
			// 	if (opt_conjunctive_cells_pool.find("shift-shiftx") != opt_conjunctive_cells_pool.end())
			// 		uc_sig = uc_conjunctive_two_inputsdesign, cell_hierarchy, cell, visited_signals, excluded_signals, read_from_signals);
			// 	else
			// 		uc_sig = uc_shift_shiftx_precisedesign, cell_hierarchy, cell, visited_signals, excluded_signals, read_from_signals);

			// else if (cell->type.in(ID($shiftx)) && !opt_precise_shiftx)
			// 	if (opt_conjunctive_cells_pool.find("shift-shiftx") != opt_conjunctive_cells_pool.end())
			// 		uc_sig = uc_conjunctive_two_inputsdesign, cell_hierarchy, cell, visited_signals, excluded_signals, read_from_signals);
			// 	else
			// 		uc_sig = uc_shiftx_imprecisedesign, cell_hierarchy, cell, visited_signals, excluded_signals, read_from_signals);

			// else if (cell->type.in(ID($shift)) && !opt_precise_shiftx)
			// 	if (opt_conjunctive_cells_pool.find("shift-shiftx") != opt_conjunctive_cells_pool.end())
			// 		uc_sig = uc_conjunctive_two_inputsdesign, cell_hierarchy, cell, visited_signals, excluded_signals, read_from_signals);
			// 	else
			// 		uc_sig = uc_shift_imprecisedesign, cell_hierarchy, cell, visited_signals, excluded_signals, read_from_signals);

			// else if (cell->type.in(ID($mod)))
			// 	if (opt_conjunctive_cells_pool.find("mod") != opt_conjunctive_cells_pool.end())
			// 		uc_sig = uc_conjunctive_two_inputsdesign, cell_hierarchy, cell, visited_signals, excluded_signals, read_from_signals);
			// 	else
			// 		uc_sig = uc_moddesign, cell_hierarchy, cell, visited_signals, excluded_signals, read_from_signals);

			else if (cell->type.in(ID($mul)))
			  uc_sig = uc_comb_two_input_cell(design, cell_hierarchy, cell, visited_signals, excluded_signals, read_from_signals);
			else if (cell->type.in(ID($memrd), ID($memrd_v2))) {
				uc_sig = uc_memrd(design, cell_hierarchy, cell, visited_signals, excluded_signals, read_from_signals);
			} else {
				log_cmd_error_lineinfo("TODO: Cell type not supported: %s. Consider running techmap or creating your own update condition implementation.\n", cell->type.c_str());
				return RTLIL::SigSpec(RTLIL::Const(RTLIL::State::S0));
			}
			return uc_sig;
	}

	// Sets a pointer to the the cell that represents the instance in which the start signal is located in paramter *cell
	// Starts searching in the top module
	// Top module is not expected to be part of _sig_hier_path
	// Sets it to nullptr if the signal is on top level
	// Returns true if the instance could be found, false otherwise
	std::tuple<bool, RTLIL::Cell*, std::string> find_instance_cell_and_name(RTLIL::Design *design, std::string sig_hier_path) {
		std::size_t start_ind, stop_ind;
		bool in_escaped_name = false;
		RTLIL::Cell *cell = nullptr;
		RTLIL::Module *module = design->top_module();

		start_ind = 0;
		for (std::size_t i = 0; i < sig_hier_path.length(); i++) {
			// Potential leading \ is part of the cell (=instance) name
			if (sig_hier_path[i] == '\\') {
				in_escaped_name = true;
				if (!in_escaped_name && i != start_ind) {
					log_cmd_error_lineinfo("Found a \\ inside the hierarchical signal path in the middle of a instance or signal name: %s\n", sig_hier_path.c_str());
					return std::make_tuple(false, nullptr, "");
				}
			} else if (in_escaped_name && sig_hier_path[i] == ' ') {
				in_escaped_name = false;
			} else if ((!in_escaped_name && sig_hier_path[i] == '.')) {
				stop_ind = i;
				// skip over a potential . after a space in an escaped name
				if (stop_ind > start_ind) {
					std::string inst_name = sig_hier_path.substr(start_ind, stop_ind - start_ind);
					cell = module->cell(RTLIL::IdString("\\" + inst_name));
					if (cell == nullptr) {
						log_cmd_error_lineinfo("Instance %s (part of %s) not found. \n", inst_name.c_str(), sig_hier_path.c_str());
						return std::make_tuple(false, nullptr, "");
					}
					module = cell->module;
				}
				start_ind = i+1;
			}
		}
		if (cell != nullptr)
			log("Instance cell found: %s for signal %s\n", cell->name.c_str(), sig_hier_path.c_str());
		else
			log("Signal %s found in top module\n", sig_hier_path.c_str());
		return std::make_tuple(true, cell, sig_hier_path.substr(start_ind, std::string::npos));
	}


struct UpdateConditionWorker {
      private:
	// Command line arguments.
	bool opt_verbose = false;
  RTLIL::IdString signal_name ;
  RTLIL::Design *design;
	std::vector<string> *excluded_signals;
	std::vector<string> *read_from_signals;
	const RTLIL::IdString uc_attribute_name = ID(update_condition);
	const RTLIL::IdString sv_past_attribute_name = ID(sv_past);


      public:

	UpdateConditionWorker(RTLIL::Design *_design, std::string _sig_hier_path, bool _opt_verbose, std::vector<string> *_excluded_signals, std::vector<string> *_read_from_signals)
	{
		opt_verbose = _opt_verbose;
		excluded_signals = _excluded_signals;
		read_from_signals = _read_from_signals;
		design = _design;

		RTLIL::Cell *start_instance_cell;
		bool start_instance_found;
		std::string signal_name;
		std::tie(start_instance_found, start_instance_cell, signal_name) = find_instance_cell_and_name(design, _sig_hier_path);
		if (!start_instance_found) {
			log_cmd_error_lineinfo("Could not find the instance of the start signal %s.\n", _sig_hier_path.c_str());
			return;
		}

		// Strip off the trailing space if there is one, because Yosys stores escaped names without the trailing space.
		if (signal_name.back() == ' '){
			signal_name = signal_name.substr(0, signal_name.size()-1);
		}

		RTLIL::IdString signal_name_id = RTLIL::IdString(RTLIL::escape_id(signal_name));

		// if (start_instance_cell != nullptr)
		// 	log_cmd_error_lineinfo("Not yet implemented for start signals in a lower level module. It must be in the top module for now\n");

		std::vector<RTLIL::Cell *> cell_hierarchy;
		// Create a new wire at the top level that represents the update condition for the signal.
    RTLIL::Module *start_module;
		if (start_instance_cell == nullptr)
			start_module = design->top_module();
		else
			start_module = start_instance_cell->module;

		RTLIL::Wire *sig = find_wire(start_module, signal_name_id);
		visited_signals_t visited_signals = {};
		// We allow only one clock cycle deep reference into the past, if the start signal is a state element.
		// Otherwise, uc(state element) should return 1.
		if (!is_state_element(start_module, sig->name))
			visited_signals.push_back(*(new RTLIL::IdString(TMP_DEF_VISITED_STATE))); // TODO: create a function param
		RTLIL::SigSpec uc_sig = create_uc_logic(_design, cell_hierarchy, start_instance_cell, sig, visited_signals, excluded_signals, read_from_signals);
		if (!uc_sig.is_wire())
			log_warning("The update condition of signal %s is constant %s, that's unusal.\n", _sig_hier_path.c_str(), uc_sig.as_const().as_string().c_str());
		else {
			uc_sig.as_wire()->set_bool_attribute(ID(update_condition), true);
			uc_sig.as_wire()->set_bool_attribute(ID(keep), true);
		}
	}
};

struct UpdateConditionPass : public Pass {
	UpdateConditionPass() : Pass("update_condition", "Generate the update condition of a signal.") {}

	void help() override
	{
		//   |---v---|---v---|---v---|---v---|---v---|---v---|---v---|---v---|---v---|---v---|
		log("\n");
		log("    update_condition [options] -module_name <module_name> -signal_name <signal_name>\n");
		log("\n");
		log("Generates the update condition of the provided signal. That is an disjunction of all conditions in which the signal may be (partially or completely) assigned with a new value different from itself. An exception are constant assignments. Constants are treated as new values. If the signal is always assigned with a constant, the update condition is always true, although it does not actually receive a new value.\n");
		log("The pass searches for self-assignments 1 clock cycle into the past. \n");
		log("\n");
		log("Expected to run after `proc` and `opt`. Currently the pass only works on one module. Run the `flatten` pass before.\n");
		log("If not necessary for other reasons, avoid using `pmuxtree` before this pass, it may increase its runtime.\n");
		log("\n");
		log("Options:\n");
		log("\n");
		log("  -signal_name\n");
		log("    The signal of which the update condition should be determined with its hierarchical path (without top module), e.g. submodule1.submodule2.signal_name\n");
		log("\n");
		log("  -verbose\n");
		log("    Verbose mode.\n");
		log("\n");
		log("  -exclude-signals\n");
		log("    Exclude a list of signal names from the update condition. Typically, this comprises clock and reset signals.\n");
		log("    The list must be comma-separated and must contain no space.\n");
		log("    Example: -exclude-signals clk_i,rst_ni\n");
		log("  -read-from-signals\n");
		log("    When this list is not empty, the update condition will be true whenever the input signal reads values from signals that start with names in this list. This includes partial selects and concatenations from these signal, together with other signals, and excludes any value transforming reads, where a signal of this list is read via some logic cell. Inputs are included, if they are in the list, constants are excluded.\n");
		log("    The list must be comma-separated and must contain no space.\n");
		log("    Example: -read-from-signals u_if.u_rf.REG\n");
		log("\n");
	}

	void parse_args_list(std::string csv, std::vector<string> &sig_list) {
		if (csv.size() != 0) {
			log("Parsing csv: %s of size %ld\n", csv.c_str(), csv.size());
			char delimiter = ',';
			int csv_start = 0;
			int end = csv.find(delimiter);
			if (end == -1) {
				log("Adding %s to list\n", csv.c_str());
				sig_list.push_back("\\" + csv);
			} else {
				log("And entering else also\n");
				while (end != -1) {
					log("Adding substring %s from %d to %d to list\n", csv.substr(csv_start, end - csv_start).c_str(), csv_start, end);
					sig_list.push_back("\\" + csv.substr(csv_start, end - csv_start));
					csv_start = end + 1;
					end = csv.find(delimiter, csv_start);
				}
				log("Last time Adding substring %s from %d to %d to list\n", csv.substr(csv_start, end - csv_start).c_str(), csv_start, end);
				sig_list.push_back("\\" + csv.substr(csv_start, end - csv_start));
			}
		}
	}

	void execute(std::vector<std::string> args, RTLIL::Design *design) override
	{
		bool opt_verbose = false;
		std::string opt_excluded_signals_csv;
		std::string opt_read_from_signals_csv;
		std::vector<string> opt_excluded_signals;
		std::vector<string> opt_read_from_signals;

		log_header(design, "Executing update condition pass.\n");
		std::vector<std::string>::size_type argidx;

		std::string signal_name_hier_path;
		for (argidx = 1; argidx < args.size(); argidx++) {
			if (args[argidx] == "-verbose") {
				opt_verbose = true;
				continue;
			}
			if (args[argidx] == "-signal_name") {
				if (argidx+1 < args.size()) {
					signal_name_hier_path = args[++argidx];
					continue;
				} else {
					log_cmd_error_lineinfo("Missing argument: signal name.\n");
				}
			}
			if (args[argidx] == "-exclude-signals") {
				opt_excluded_signals_csv = args[++argidx];
				continue;
			}
			if (args[argidx] == "-read-from-signals") {
				opt_read_from_signals_csv = args[++argidx];
				continue;
			}
			break;
		}
		extra_args(args, argidx, design);

		RTLIL::Module *top_module = design->top_module();
		if (top_module == nullptr)
			log_cmd_error_lineinfo("No top module selected. Run 'hierarchy' pass before this pass.\n");

		if (!design->selected_whole_module(top_module))
			log_cmd_error_lineinfo("Whole top module must be selected.");

		if (top_module->processes.size())
			log_cmd_error_lineinfo("This pass needs to run after the 'proc' pass, and ideally also after 'opt'.\n");

		// if (design->modules().size() > 1)
		// 	log_cmd_error_lineinfo("This pass currently only works on one module. Run the 'flatten' pass before.\n");

		// Parse the excluded signals.
		parse_args_list(opt_excluded_signals_csv, opt_excluded_signals);
		// Parse the read-from signals.
		parse_args_list(opt_read_from_signals_csv, opt_read_from_signals);

		// Run the worker
		UpdateConditionWorker(design, signal_name_hier_path, opt_verbose, &opt_excluded_signals, &opt_read_from_signals);
	}
} UpdateConditionPass;

} // UpdateCondition

