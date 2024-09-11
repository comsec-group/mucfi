/*
 *  yosys -- Yosys Open SYnthesis Suite
 *
 *  Copyright (C) 2012  Claire Xenia Wolf <claire@yosyshq.com>
 *                2020  Alberto Gonzalez <boqwxp@airmail.cc> & Flavien Solt <flsolt@ethz.ch>
 *                2024  Katharina Ceesay-Seitz <kceesay@ethz.ch>
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

extern bool is_signal_excluded(std::vector<string> *register_read_signals, string signal_name);

namespace FindFwdMux {

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

std::tuple<bool, std::string> find_instance_cell_and_name(RTLIL::Design *design, std::string sig_hier_path, std::vector<RTLIL::Cell *> &cell_hierarchy) {
	std::size_t start_ind, stop_ind;
	bool in_escaped_name = false;
	RTLIL::Cell *cell = nullptr;
	RTLIL::Module *module = cell_hierarchy.empty() ? design->top_module() : design->modules_.at(cell_hierarchy.back()->type);

	start_ind = 0;
	for (std::size_t i = 0; i < sig_hier_path.length(); i++) {
		// Potential leading \ is part of the cell (=instance) name
		if (sig_hier_path[i] == '\\') {
			in_escaped_name = true;
			if (!in_escaped_name && i != start_ind) {
				log_cmd_error_lineinfo("Found a \\ inside the hierarchical signal path in the middle of a instance or signal name: %s\n", sig_hier_path.c_str());
				return std::make_tuple(false, "");
			}
		} else if (in_escaped_name && sig_hier_path[i] == ' ') {
			in_escaped_name = false;
		} else if ((!in_escaped_name && sig_hier_path[i] == '.')) {
			stop_ind = i;
			// skip over a potential . after a space in an escaped name
			if (stop_ind > start_ind) {
				std::string inst_name = sig_hier_path.substr(start_ind, stop_ind - start_ind);
				// Remove trailing space of escaped names
				if (inst_name[0] == '\\')
					inst_name = inst_name.substr(0, inst_name.size()-1);
				else
					inst_name = "\\" + inst_name;
				cell = module->cell(RTLIL::IdString(inst_name));
				if (cell == nullptr) {
					log_cmd_error_lineinfo("Instance %s (part of %s) not found. \n", inst_name.c_str(), sig_hier_path.c_str());
					return std::make_tuple(false, "");
				}
				cell_hierarchy.push_back(cell);
				return find_instance_cell_and_name(design, sig_hier_path.substr(stop_ind+1, std::string::npos), cell_hierarchy);
			}
			start_ind = i+1;
		}
	}
	return std::make_tuple(true, sig_hier_path.substr(start_ind, std::string::npos));
}

	bool name_in_sigspec(RTLIL::SigSpec sig, RTLIL::IdString name) {
		for (auto it = sig.chunks().rbegin(); it != sig.chunks().rend(); ++it) {
			if ((*it).is_wire() && name == (*it).wire->name) {
				return true;
			}
		}
		return false;
	}

// Find the wire that corresponds to the signal name
RTLIL::Wire *find_wire(RTLIL::Module *start_module, RTLIL::IdString signal_name) {
	if (start_module->wires_.find(signal_name) != start_module->wires_.end())
		return start_module->wires_.at(signal_name);
	else
		log_cmd_error_lineinfo("Signal %s not found in module %s.\n", signal_name.c_str(), start_module->name.c_str());
	return nullptr;
}

struct FwdDataSignal {
	RTLIL::Design *design;
	// The instance cells in top down hierarchical order from the first one below the top module until the one that contains the signal.
	std::vector<RTLIL::Cell *> cell_hierarchy;
	RTLIL::IdString signal_name;
	RTLIL::Wire *signal_wire;

	FwdDataSignal()
			: design(nullptr), signal_wire(nullptr) {}

	FwdDataSignal(RTLIL::Design *design, std::vector<RTLIL::Cell *> cell_hierarchy, const RTLIL::IdString &name, RTLIL::Wire *wire)
			: design(design), cell_hierarchy(cell_hierarchy), signal_name(name), signal_wire(wire) {}

	void print() {
		log("FwdDataSignal: %s\n", signal_name.c_str());
		for (auto cell : cell_hierarchy) {
			log("  %s\n", cell->name.c_str());
		}
		if (cell_hierarchy.empty()) {
			log("  Top module\n");
		}
	}

	RTLIL::Module *get_module() {
		return cell_hierarchy.empty() ? design->top_module() : design->modules_.at(cell_hierarchy.back()->type);
	}

	bool matches(std::vector<RTLIL::Cell *> &other_cell_hierarchy, RTLIL::IdString other_signal_name) {
		if (signal_name != other_signal_name)
			return false;
		if (cell_hierarchy.size() != other_cell_hierarchy.size())
			return false;
		for (std::size_t i = 0; i < cell_hierarchy.size(); i++) {
			if (cell_hierarchy[i] != other_cell_hierarchy[i])
				return false;
		}
		return true;
	}
};

struct FwdMux {
	RTLIL::Cell *mux;
	FwdDataSignal *register_read_signal;
	FwdDataSignal *forwarding_signal;

	FwdMux(RTLIL::Cell *mux) : mux(mux), register_read_signal(nullptr), forwarding_signal(nullptr) {}
};

struct FindFwdMuxWorker {
private:
	// Command line arguments.
	bool opt_verbose = false;
  RTLIL::Design *design;
	std::vector<FwdDataSignal> register_read_signals;
	std::vector<FwdDataSignal> register_write_signals;
	std::vector<FwdDataSignal> forwarding_signals;
	std::vector<FwdDataSignal> pc_signals;
	std::vector<FwdMux> fwd_muxes;
	const RTLIL::IdString formal_abstract_attribute_name = ID(FORMAL_ABSTRACT);
	std::vector<RTLIL::Cell *> muxes_between_fwd_mux_and_reg_read;

	RTLIL::Module *get_module(std::vector<RTLIL::Cell *> &cell_hierarchy) {
		return cell_hierarchy.empty() ? design->top_module() : design->modules_.at(cell_hierarchy.back()->type);
	}

	void collect_instances(std::vector<string> *signals_w_hier_path,
												std::vector<FwdDataSignal> &sigs_with_instance) {
		for (auto sigpath : *signals_w_hier_path) {
			std::vector<RTLIL::Cell *> cell_hierarchy;
			bool start_instance_found;
			std::string signal_name;
			std::tie(start_instance_found, signal_name) = find_instance_cell_and_name(design, sigpath, cell_hierarchy);
			if (!start_instance_found) {
				log_cmd_error_lineinfo("Could not find the instance of signal %s.\n", sigpath.c_str());
				return;
			}

			// Strip off the trailing space if there is one, because Yosys stores escaped names without the trailing space.
			if (signal_name.back() == ' '){
				signal_name = signal_name.substr(0, signal_name.size()-1);
			}
			RTLIL::IdString signal_name_id = RTLIL::IdString(RTLIL::escape_id(signal_name));
			RTLIL::Wire *sig = find_wire(cell_hierarchy.empty() ? design->top_module() : design->modules_.at(cell_hierarchy.back()->type), signal_name_id);
			sigs_with_instance.emplace_back(design, cell_hierarchy, signal_name_id, sig);
		}
	}

	RTLIL::IdString get_first_chunk_wire_name(RTLIL::SigSpec sig) {
		for (auto chunk : sig.chunks()) {
			if (chunk.is_wire()) {
				return chunk.wire->name;
			}
		}
		return ID("");
	}

	// Currenlty only checks whether all chunks are part of the same signal, but ideally
	// TODO: we should also check whether the chunks are not shuffled
	bool all_chunks_from_same_sig(const std::vector<RTLIL::SigChunk> &chunks, RTLIL::IdString chunk_name) {
		if (chunks.empty()) {
			return false;
		}
		for (auto chunk : chunks) {
			if (!chunk.is_wire()) {
				return false;
			} else if (chunk.wire->name.str().find(chunk_name.str()) != 0) {
				return false;
			}
		}
		return true;
	}

  // Follow assignments and also check whether assigned signals interface with fmuxes
	void follow_assignments_forward(std::vector<RTLIL::Cell*> cell_hierarchy, RTLIL::IdString signal_name, std::vector<FwdDataSignal> &visited) {
		for (auto conn: get_module(cell_hierarchy)->connections()) {
			if (conn.second.is_wire() && conn.second.as_wire()->name == signal_name){
				if (!conn.first.is_wire()) {
					RTLIL::IdString first_chunk_wire_name = get_first_chunk_wire_name(conn.first);
					if (!all_chunks_from_same_sig(conn.first.chunks(), first_chunk_wire_name)) {
						log_cmd_error_lineinfo("PRECONDITION UNSATISFIED: Forwarding data signal %s is used in a concatenation with other signals.\n", first_chunk_wire_name.c_str());
					}
					find_fwd_mux_selects(cell_hierarchy, first_chunk_wire_name, visited);
				} else {
					find_fwd_mux_selects(cell_hierarchy, conn.first.as_wire()->name, visited);
				}
			}
		}
	}

  // If signal is an output (also), find module that uses the forwarded data and also check for fmuxes
	bool follow_output(std::vector<RTLIL::Cell*> cell_hierarchy, RTLIL::IdString signal_name, std::vector<FwdDataSignal> &visited) {
		// If not yet at the top level, follow output
		if (!cell_hierarchy.empty() && cell_hierarchy.back()->output(signal_name)) {
			log("Following output %s of instance %s.\n", signal_name.c_str(), cell_hierarchy.back()->name.c_str());
			for (auto conn : cell_hierarchy.back()->connections()) {
				if (conn.first == signal_name && !conn.second.is_fully_const()) { // Output could be fully const if it is not used by the instantiating module
					if (!conn.second.is_wire()) {
						RTLIL::IdString first_chunk_wire_name = get_first_chunk_wire_name(conn.second);
						if (!all_chunks_from_same_sig(conn.second.chunks(), first_chunk_wire_name)) {
							log_cmd_error_lineinfo("PRECONDITION UNSATISFIED: Forwarding data signal %s is used in a concatenation with other signals.\n", first_chunk_wire_name.c_str());
						} else {
							find_fwd_mux_selects(std::vector<RTLIL::Cell*>(cell_hierarchy.begin(), cell_hierarchy.end()-1), first_chunk_wire_name, visited);
							return true;
						}
					}
					find_fwd_mux_selects(std::vector<RTLIL::Cell*>(cell_hierarchy.begin(), cell_hierarchy.end()-1), conn.second.as_wire()->name, visited);
					return true;
				}
			}
			log_cmd_error_lineinfo("ERROR: Module output %s is not connected to anything? Or yosys does not consistently put output ports at the first element of connections?.\n", signal_name.c_str());
		}
		return false;
	}

	void tag_mux_select(std::vector<RTLIL::Cell*> cell_hierarchy, RTLIL::Cell *cell) {
		if (cell->type == ID($mux)) {
			RTLIL::SigSpec port = cell->getPort(ID::S);
			// Tag the select signal
			if (port.is_wire()) {
				port.as_wire()->set_bool_attribute(formal_abstract_attribute_name, true);
				port.as_wire()->set_bool_attribute(ID::keep, true);
				log("FORMAL_ABSTRACT: Mux %s with MUX_SELECT=", cell->name.c_str());
				std::string hier_path = "";
				for (auto c : cell_hierarchy) {
					// Remove the "\" in front of each instance name
					std::string inst_name = c->name.str().substr(1, string::npos);
					if (inst_name.length() > 0) {
						hier_path += inst_name + ".";
					}
				}
				std::string mux_select = std::string(log_signal(port));
				log("%s%s\n", hier_path.c_str(), mux_select.substr(1, string::npos).c_str());
			} else {
				log_cmd_error("ERROR: Select signal %s of forwarding mux %s is not a wire.\n", log_signal(port), cell->name.c_str());
			}
		} else {
			log_cmd_error_lineinfo("ERROR: Trying to tag the select of a non-mux cell %s.\n", cell->name.c_str());
		}
	}

	RTLIL::IdString connected_to_double_not(RTLIL::Cell *cell, std::vector<RTLIL::Cell*> cell_hierarchy) {
		if (cell->type.in(ID($not), ID($_NOT_))) {
			// Check whether the input of the not is an output of another not
			if (cell->getPort(ID::A).is_wire()) {
				for (auto other_cell : get_module(cell_hierarchy)->cells()) {
					if (other_cell->type.in(ID($not), ID($_NOT_))) {
						if (other_cell->getPort(ID::Y).is_wire() &&
									other_cell->getPort(ID::Y).as_wire()->name == cell->getPort(ID::A).as_wire()->name) {
							return other_cell->getPort(ID::A).as_wire()->name;
						}
					}
				}
			}
		}
		return ID("");
	}

	RTLIL::IdString special_case_cell_connection(RTLIL::Cell *cell, std::vector<RTLIL::Cell*> cell_hierarchy) {
		return connected_to_double_not(cell, cell_hierarchy);
	}

	bool sigspec_reaches_reg(RTLIL::SigSpec port, std::vector<RTLIL::Cell*> cell_hierarchy) {
		bool tmp_ret = true;
		if (port.is_wire()) {
			log("Checking whether %s reaches a register read signal.\n", port.as_wire()->name.c_str());
			tmp_ret = reaches_register_read(cell_hierarchy, port.as_wire()->name);
		} else {
			if (port.is_fully_const()) {
				tmp_ret = false;
			} else {
				RTLIL::IdString first_chunk_wire_name = get_first_chunk_wire_name(port);
				if (all_chunks_from_same_sig(port.chunks(), first_chunk_wire_name)) {
					log("Checking whether chunked signal %s reaches a register read signal.\n", first_chunk_wire_name.c_str());
					tmp_ret = reaches_register_read(cell_hierarchy, first_chunk_wire_name);
				} else {
					tmp_ret = false;
				}
			}
		}
		return tmp_ret;
	}

	bool reaches_register_read(std::vector<RTLIL::Cell*> cell_hierarchy, RTLIL::IdString signal_name) {
		// For an automated precondition check, we need to ensure that there are only direct assignments or other fmuxes on the way to the register read signal
		// So we can collect the muxes, stop if it is not a direct unconditioned assignment, and at the end of everything we check the passed registers against the identified fmuxes.

		for (auto reg_read : register_read_signals) {
			if (reg_read.matches(cell_hierarchy, signal_name)) {
				log("Found register read signal %s.\n", signal_name.c_str());
				return true;
			} else {
				// log("Signal %s.%s does not match register read signal %s.\n", cell_hierarchy.empty()? "top" : cell_hierarchy.back()->name.c_str(), signal_name.c_str(), reg_read.signal_name.c_str());
			}
		}

		// Is the signal an input? ... call same function for the signal that drives the the input
		if (!cell_hierarchy.empty() && cell_hierarchy.back()->input(signal_name)) {
			log("Signal %s is an input of instance %s.\n", signal_name.c_str(), cell_hierarchy.back()->name.c_str());
			for (auto conn : cell_hierarchy.back()->connections()) {
				if (conn.first == signal_name) {
					log("It is connected to %s.\n", log_signal(conn.second));
					if (conn.second.is_fully_const()) {
						return false;
					} else {
						if (!conn.second.is_wire()) {
							RTLIL::IdString first_chunk_wire_name = get_first_chunk_wire_name(conn.second);
							if (!all_chunks_from_same_sig(conn.second.chunks(), first_chunk_wire_name)) {
								log("Signal %s is part of a concatenation.\n", first_chunk_wire_name.c_str());
								return false;
							} else {
								log("Signal %s is part of a concatenation of the same signal.\n",first_chunk_wire_name.c_str());
								return reaches_register_read(std::vector<RTLIL::Cell*>(cell_hierarchy.begin(), cell_hierarchy.end()-1), first_chunk_wire_name);
							}
						} else {
							return reaches_register_read(std::vector<RTLIL::Cell*>(cell_hierarchy.begin(), cell_hierarchy.end()-1), conn.second.as_wire()->name);
						}
					}
				}
			}
		}

		// Is the signal assigned with a register read signal? ... call same function for rhs
		for (auto conn: get_module(cell_hierarchy)->connections()) {
			if (conn.first.is_wire() && conn.first.as_wire()->name == signal_name) {
				log("Signal %s is assigned with %s.\n", signal_name.c_str(), log_signal(conn.second));
				return sigspec_reaches_reg(conn.second, cell_hierarchy);
			}
		}

		// Is the signal a cell output?
		// Mux is ok
		// everything else is not ok
		for (auto cell : get_module(cell_hierarchy)->cells()) {
			// log("Checking cells of module %s.\n", get_module(cell_hierarchy)->name.c_str());
			for (auto port_conn : cell->connections()) {
				// If signal is connected to a cell output
				if (port_conn.second.is_wire() && port_conn.second.as_wire()->name == signal_name && cell->output(port_conn.first)) {
					if (cell->type.in(ID($mux))) {
						if (sigspec_reaches_reg(cell->getPort(ID::A), cell_hierarchy)
									|| sigspec_reaches_reg(cell->getPort(ID::B), cell_hierarchy)) {
							// Store muxes for later check
							muxes_between_fwd_mux_and_reg_read.emplace_back(cell);
							return true;
						} else {
							return false;
						}
					} else if (design->modules_.count(cell->type)) {
							std::vector<RTLIL::Cell*> extended_hier = cell_hierarchy;
							extended_hier.push_back(cell);
							log("Adding cell %s of type %s to hierarchy, continuing at %s\n", cell->name.c_str(), cell->type.c_str(), port_conn.first.c_str());
							return reaches_register_read(extended_hier, port_conn.first);
						// Special case where a signal is directly assigned via a double negation
						// TODO: There are likeley more special cases, like an XOR with 0 e.g.
					} else {
						RTLIL::IdString next_signal_name = special_case_cell_connection(cell,cell_hierarchy);
						if (next_signal_name != ID(""))
							// Continue checking at the input of the other not
							return reaches_register_read(cell_hierarchy, next_signal_name);
					}
					return false;
				}
			}
		}

		return false;
	}

	void follow_non_fwd_mux_forward(std::vector<RTLIL::Cell*> cell_hierarchy, RTLIL::Cell *cell, std::vector<FwdDataSignal> &visited) {
		if (cell->getPort(ID::Y).is_wire()) {
			find_fwd_mux_selects(cell_hierarchy, cell->getPort(ID::Y).as_wire()->name, visited);
		} else if (!cell->getPort(ID::Y).is_fully_const()) {

			log("Info: We do not follow muxes (%s) forward that feed into chunks.\n", cell->name.c_str()); // because then we would have to take partial signals into account and could not just follow forward based on the name only

			std::vector<RTLIL::IdString> already_checked;
			for (auto chunk : cell->getPort(ID::Y))
				if (chunk.is_wire() && !check_precondition(cell_hierarchy, chunk.wire->name, already_checked)) {
					log_cmd_error("PRECONDITION UNSATSIFIED: Forwarding data signal %s reaches the PC before feeding into a declassified signal or source signal. Happened via mux feeding into chunk.\n", chunk.wire->name.c_str(), cell->name.c_str());
				}

		} // else if it is const, this is no path forward
	}

  // Find, check and potentially tag the select of all forwarding muxes in the current instance
	// Also follows assignments to submodules
	void check_cells_for_fmux(std::vector<RTLIL::Cell*> cell_hierarchy, RTLIL::IdString signal_name, std::vector<FwdDataSignal> &visited) {
		bool fwd_mux_found;
		bool a_is_fwd_input;
		bool b_is_fwd_input;

		for (auto cell : get_module(cell_hierarchy)->cells()) {
			fwd_mux_found = false;
			a_is_fwd_input = false;
			b_is_fwd_input = false;
			if (cell->type.in(ID($mux))) {
				// log("Checking mux cell %s.\n", cell->name.c_str());
				if (cell->getPort(ID::A).is_wire() && cell->getPort(ID::A).as_wire()->name == signal_name) {
					log("Found mux %s with signal %s at port A.\n", cell->name.c_str(), signal_name.c_str());
					a_is_fwd_input = true;
				}
				if (cell->getPort(ID::B).is_wire() && cell->getPort(ID::B).as_wire()->name == signal_name) {
					log("Found mux %s with signal %s at port B.\n", cell->name.c_str(), signal_name.c_str());
					b_is_fwd_input = true;
				}
				if (a_is_fwd_input && b_is_fwd_input) {
					// a mux arbitrating between the same signal (or chunks of it) is not a forwarding multiplexer
					log("Found mux %s with two forwarding inputs %s and %s\n", cell->name.c_str(), cell->getPort(ID::A).as_wire()->name.c_str(), cell->getPort(ID::B).as_wire()->name.c_str());
					follow_non_fwd_mux_forward(cell_hierarchy, cell, visited);
				} else {
					// If this is an fwd mux, we tag the select signal and are done with this path
					if (a_is_fwd_input) {
						if (cell->getPort(ID::B).is_wire())
							log("Checking whether %s reaches a register read signal.\n", cell->getPort(ID::B).as_wire()->name.c_str());
						if (sigspec_reaches_reg(cell->getPort(ID::B), cell_hierarchy)) {
							tag_mux_select(cell_hierarchy, cell);
							fwd_mux_found = true;
						}
					}
					if (b_is_fwd_input) {
						if (cell->getPort(ID::A).is_wire())
							log("Checking whether %s reaches a register read signal.\n", cell->getPort(ID::A).as_wire()->name.c_str());
						if (sigspec_reaches_reg(cell->getPort(ID::A), cell_hierarchy)) {
							tag_mux_select(cell_hierarchy, cell);
							fwd_mux_found = true;
						}
					}
					// If the signal is passed to a mux that is not an fwd mux, we follow the output of the mux until we find the fwd mux
					if ((a_is_fwd_input || b_is_fwd_input) && !fwd_mux_found) {
						follow_non_fwd_mux_forward(cell_hierarchy, cell, visited);
					}
				}
			} else {
				for (auto port_conn : cell->connections()) {
					// If the signal is used as cell input, it must be an input to a submodule
					if (port_conn.second.is_wire() && port_conn.second.as_wire()->name == signal_name && cell->input(port_conn.first)) {
						// Found signal at an input of a cell, is the cell a submodule?
						if (design->modules_.count(cell->type)) {
							std::vector<RTLIL::Cell*> extended_hier = cell_hierarchy;
							extended_hier.push_back(cell);
							find_fwd_mux_selects(extended_hier, port_conn.first, visited);
						} else {
							RTLIL::IdString next_signal_name = special_case_cell_connection(cell,cell_hierarchy);
							if (next_signal_name != ID("")) {
								// Continue checking at the input of the other not
								find_fwd_mux_selects(cell_hierarchy, next_signal_name, visited);
							} else {
								std::vector<RTLIL::IdString> already_checked;
								if (!check_precondition(cell_hierarchy, signal_name, already_checked)) {
									log_cmd_error("PRECONDITION UNSATSIFIED: Forwarding data signal %s reaches the PC before feeding into a declassified signal or source signal.\n", signal_name.c_str(), cell->name.c_str());
								}
							}
						}
					}
				}
			}
		}
	}

	void find_fwd_mux_selects(std::vector<RTLIL::Cell*> cell_hierarchy, RTLIL::IdString signal_name, std::vector<FwdDataSignal> &visited) {
		for (auto v : visited) {
			if (v.matches(cell_hierarchy, signal_name)) {
				log("Signal %s already visited.\n", signal_name.c_str());
				return;
			}
		}
		visited.emplace_back(design, cell_hierarchy, signal_name, find_wire(get_module(cell_hierarchy), signal_name));

		for (auto pc : pc_signals) {
			if (pc.matches(cell_hierarchy, signal_name)) {
				log_cmd_error("PRECONDITION UNSATISFIED. Forwarding output feeds into PC signal %s before reaching a declassified signal or SRC.\n", signal_name.c_str());
				return;
			}
		}

		if (!cell_hierarchy.empty())
			log("Checking signal %s.%s.\n", cell_hierarchy.back()->name.c_str(), signal_name.c_str());
		else
			log("Checking signal %s in top module.\n", signal_name.c_str());

		// Passing copies of cell_hierarchy, because a signal may be used multiple times and we follow each of its
		// usages individually

		check_cells_for_fmux(cell_hierarchy, signal_name, visited);

		follow_assignments_forward(cell_hierarchy, signal_name, visited);

		follow_output(cell_hierarchy, signal_name, visited);
	}

	// checks the forwarding declassification precondition, which says that every signal that is declassified, must feed into another declassified one,
	// or into a source signal of the property
	bool check_precondition(std::vector<RTLIL::Cell*> cell_hierarchy, RTLIL::IdString signal_name, vector<RTLIL::IdString> &already_checked) {
		// log("Checking precondition for signal %s.\n", signal_name.c_str());
		for (auto pc : pc_signals) {
			if (pc.matches(cell_hierarchy, signal_name)) {
				log_cmd_error("PRECONDITION UNSATISFIED. Feeding into PC signal %s before reaching a declassified signal or SRC.\n", signal_name.c_str());
				return false;
			}
		}
		for (auto reg_write : register_write_signals) {
			if (reg_write.matches(cell_hierarchy, signal_name)) {
				log("Precondition satisfied. Feeding into register write signal %s.\n", signal_name.c_str());
				return true;
			}
		}
		for (auto reg_read : register_read_signals) {
			if (reg_read.matches(cell_hierarchy, signal_name)) {
				log("Precondition satisfied. Feeding into register read signal %s.\n", signal_name.c_str());
				return true;
			}
		}
		for (auto fwd : forwarding_signals) {
			if (fwd.matches(cell_hierarchy, signal_name)) {
				log("Precondition satisfied. Feeding into forwarding signal %s.\n", signal_name.c_str());
				return true;
			}
		}
		for (auto already_checked_signal : already_checked) {
			if (already_checked_signal == signal_name) {
				return true;
			}
		}
		already_checked.push_back(signal_name);

		if (!check_precondition_cells(cell_hierarchy, signal_name, already_checked))
			return false;

		if (!check_precondition_assignments(cell_hierarchy, signal_name, already_checked))
			return false;

    if (!check_precondition_outputs(cell_hierarchy, signal_name, already_checked))
			return false;

		return true;
	}

	bool check_precondition_cells(std::vector<RTLIL::Cell*> cell_hierarchy, RTLIL::IdString signal_name, vector<RTLIL::IdString> &already_checked) {
		bool ret = true;

		// Walk cells forward
		for (auto cell : get_module(cell_hierarchy)->cells()) {
			for (auto port : cell->connections()){
				if (cell->input(port.first)) {
					if (name_in_sigspec(port.second, signal_name)) {
						// Is there no cell.get_output function?
						for (auto output_port : cell->connections()) {
							if (cell->output(output_port.first)) {
								// log("Checking cell output %s %s.\n", output_port.first.c_str(), log_signal(output_port.second));
								fflush(stdout);
								for (auto chunk : output_port.second.chunks()) {
									if (chunk.is_wire()) {
										ret &= check_precondition(cell_hierarchy, chunk.wire->name, already_checked);
									}
								}
							}
						}
					}
				}
			}
		}
		return ret;
	}

	bool check_precondition_assignments(std::vector<RTLIL::Cell*> cell_hierarchy, RTLIL::IdString signal_name, vector<RTLIL::IdString> &already_checked) {
		bool ret = true;
		for (auto conn: get_module(cell_hierarchy)->connections()) {
			if (conn.second.is_wire() && conn.second.as_wire()->name == signal_name){
				for (auto chunk : conn.first.chunks()) {
					if (chunk.is_wire()) {
						ret &= check_precondition(cell_hierarchy, chunk.wire->name, already_checked);
					}
				}
			}
		}
		return ret;
	}

	bool check_precondition_outputs(std::vector<RTLIL::Cell*> cell_hierarchy, RTLIL::IdString signal_name, vector<RTLIL::IdString> &already_checked) {
		bool ret = true;
		// If not yet at the top level, follow output
		if (!cell_hierarchy.empty() && cell_hierarchy.back()->output(signal_name)) {
			for (auto conn : cell_hierarchy.back()->connections()) {
				if (conn.first == signal_name && !conn.second.is_fully_const()) { // Output could be fully const if it is not used by the instantiating module
					for (auto chunk : conn.second.chunks()) {
						if (chunk.is_wire()) {
							ret &= check_precondition(cell_hierarchy, chunk.wire->name, already_checked);
						}
					}
				}
			}
		}
		return ret;
	}

public:

	FindFwdMuxWorker(RTLIL::Design *_design, std::string _sig_hier_path, bool _opt_verbose, std::vector<string> *_register_read_signals, std::vector<string> *_register_write_signals, std::vector<string> *_forwarding_signals, std::vector<string> *_pc_signals)
	{
		opt_verbose = _opt_verbose;
		design = _design;

		collect_instances(_register_read_signals, register_read_signals);
		collect_instances(_register_write_signals, register_write_signals);
		collect_instances(_forwarding_signals, forwarding_signals);
		collect_instances(_pc_signals, pc_signals);


		RTLIL::Cell *instance_cell;
		RTLIL::IdString signame;

		for (auto fwd_signal: forwarding_signals) {
			std::vector<FwdDataSignal> visited;
			find_fwd_mux_selects(fwd_signal.cell_hierarchy, fwd_signal.signal_name, visited);
		}

		if (!muxes_between_fwd_mux_and_reg_read.empty()) {
			log("PRECONDITION_CHECK_EXTERNAL: The following multiplexers were found on the path between forwarding multiplexers and register read signals. To satisfy the preconditions, they must all be forwarding multiplexers! Please check:\n");
		}
		for (auto mux : muxes_between_fwd_mux_and_reg_read) {
			log("%s\n", log_signal(mux->getPort(ID::S)));
		}

	}
};

struct FindFwdMuxPass : public Pass {
	FindFwdMuxPass() : Pass("find_fwd_mux_selects", "Find forwarding multiplexers and tag their select signal.") {}

	void help() override
	{
		//   |---v---|---v---|---v---|---v---|---v---|---v---|---v---|---v---|---v---|---v---|
		log("\n");
		log("    find_fwd_mux_selects [options] -register-read-signals <signal_list> -forwarding-signals <signal_list>\n");
		log("\n");
		log("Searches for multiplexers that arbitrate between register data and forwarded data and tags their select signals.\n");
		log("\n");
		log("Options:\n");
		log("\n");
		log("  -register-read-signals\n");
		log("    The signal that is connected to the register read port.\n");
		log("\n");
		log("  -register-write-signals\n");
		log("    The signal that is connected to the register write port.\n");
		log("\n");
		log("  -pc-signal\n");
		log("    The PC signal with its hierarchical path.\n");
		log("\n");
		log("  -verbose\n");
		log("    Verbose mode.\n");
		log("\n");
		log("  -forwarding-signals\n");
		log("    Provide a comma separated list of forwarding data signals..\n");
		log("    The list must be comma-separated and must contain no space.\n");
		log("    Example: -forwarding-signals ...\n");
		log("\n");
	}

	void parse_args_list(std::string csv, std::vector<string> &sig_list) {
		if (csv.size() != 0) {
			char delimiter = ',';
			int csv_start = 0;
			int end = csv.find(delimiter);
			if (end == -1) {
				sig_list.push_back(csv);
			} else {
				while (end != -1) {
					sig_list.push_back(csv.substr(csv_start, end - csv_start));
					csv_start = end + 1;
					end = csv.find(delimiter, csv_start);
				}
				sig_list.push_back(csv.substr(csv_start, end - csv_start));
			}
		}
	}

	void execute(std::vector<std::string> args, RTLIL::Design *design) override
	{
		bool opt_verbose = false;
		std::string opt_register_read_signals_csv;
		std::string opt_register_write_signals_csv;
		std::string opt_forwarding_signals_csv;
		std::string opt_pc_signals_csv;
		std::vector<string> opt_register_read_signals;
		std::vector<string> opt_register_write_signals;
		std::vector<string> opt_forwarding_signals;
		std::vector<string> opt_pc_signals;

		log_header(design, "Executing find_fwd_mux_selects pass.\n");
		std::vector<std::string>::size_type argidx;

		std::string signal_name_hier_path;
		for (argidx = 1; argidx < args.size(); argidx++) {
			if (args[argidx] == "-verbose") {
				opt_verbose = true;
				continue;
			}
			if (args[argidx] == "-register-read-signals") {
				opt_register_read_signals_csv = args[++argidx];
				continue;
			}
			if (args[argidx] == "-register-write-signals") {
				opt_register_write_signals_csv = args[++argidx];
				continue;
			}
			if (args[argidx] == "-forwarding-signals") {
				opt_forwarding_signals_csv = args[++argidx];
				continue;
			}
			if (args[argidx] == "-pc-signals") {
				opt_pc_signals_csv = args[++argidx];
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

		parse_args_list(opt_register_read_signals_csv, opt_register_read_signals);
		parse_args_list(opt_register_write_signals_csv, opt_register_write_signals);
		parse_args_list(opt_forwarding_signals_csv, opt_forwarding_signals);
		parse_args_list(opt_pc_signals_csv, opt_pc_signals);

		// Run the worker
		FindFwdMuxWorker(design, signal_name_hier_path, opt_verbose, &opt_register_read_signals, &opt_register_write_signals, &opt_forwarding_signals, &opt_pc_signals);
	}
} FindFwdMuxPass;

} // FindFwdMux

