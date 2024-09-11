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

#include <algorithm>

// (e) FUTURE Treat processes

USING_YOSYS_NAMESPACE
PRIVATE_NAMESPACE_BEGIN

struct PreCelliftWorker {
private:
	const std::string pass_attr_name = ID(pre_cellift).str();

	bool opt_verbose;

	///////////////////////////////////////
	// Attribute string helper functions //
	///////////////////////////////////////

	bool has_string_at_least_one_non_pre_taint(std::string str) {
		return str.find('0') != std::string::npos;
	}
	bool has_string_at_least_one_pre_taint(std::string str) {
		return str.find('1') != std::string::npos;
	}

	std::string pre_taint_string_or(std::string str0, std::string str1, int out_size) {
		std::string ret(out_size, '0');
		for (int i = 0; i < out_size; i++) {
			if (str0[i] == '1' || str1[i] == '1')
				ret[i] = '1';
		}
		return ret;
	}

	////////////////////////////////////////
	// Pre-taint propagation by cell type //
	////////////////////////////////////////

	// const std::vector dangerous_cells[1] = {"$pmux"};

#define CELL_PREP_PORTS \
			std::string attrs[NUM_INTERESTING_PORTS]; \
			bool attr_received[NUM_INTERESTING_PORTS]; \
			for (std::pair<std::string, std::string> pre_tainted_wire_in: new_pre_tainted_wires_in) { \
				for (unsigned int port_id = 0; port_id < NUM_INTERESTING_PORTS; port_id++) \
					if (pre_tainted_wire_in.first == (port_idstrings[port_id].str())) { \
						attrs[port_id] = pre_tainted_wire_in.second; \
						attr_received[port_id] = true; \
					} \
			} \
			for (unsigned int port_id = 0; port_id < NUM_INTERESTING_PORTS; port_id++) \
				if (!attr_received[port_id]) \
					attrs[port_id] = std::string(cell->getPort(port_idstrings[port_id]).size(), '0');

	/**
	 * @param new_pre_tainted_wires_in must contain all the cell input ports with at least one pre-tainted bit.
	 */
	dict<std::string, std::string> pre_cellift_cell (RTLIL::Cell *cell, const dict<std::string, std::string> &new_pre_tainted_wires_in) {
		dict<std::string, std::string> ret_wires_dict;

		if (opt_verbose)
			log("Treating cell %s in module %s.\n", cell->name.c_str(), cell->module->name.c_str());
		
		// for (std::pair<std::string, std::string> pre_tainted_wire_in: new_pre_tainted_wires_in) {
		// 	log("  Cell port %s has attr: %s.\n", pre_tainted_wire_in.first.c_str(), pre_tainted_wire_in.second.c_str());
		// }

		////
		// Muxes
		////

		if (cell->type.in(ID($mux), ID($_MUX_), ID($_NMUX_))) {
			const unsigned int NUM_INTERESTING_PORTS = 3;
			const IdString port_idstrings[] = {ID::A, ID::B, ID::S};
			const unsigned int A = 0, B = 1, S = 2;

			// First, get the input pre-taints.
			CELL_PREP_PORTS

			// Second, for the multiplexer, OR A and B together to get the output pre-taint. If S is pre-tainted, then pre-taint the whole output as well.
			if(has_string_at_least_one_pre_taint(attrs[S])) {
				ret_wires_dict[(ID::Y).str()] = std::string(cell->getPort(ID::Y).size(), '1');
			}
			else {
				ret_wires_dict[(ID::Y).str()] = pre_taint_string_or(attrs[A], attrs[B], cell->getPort(ID::Y).size());
			}
		}

		////
		// Arithmetics
		////

		// In the case of add and sub, the non-pre-tainted input LSBs give non-pre-tainted output LSBs.
		if (cell->type.in(ID($add), ID($sub))) {
			const unsigned int NUM_INTERESTING_PORTS = 2;
			const IdString port_idstrings[] = {ID::A, ID::B};
			const unsigned int A = 0, B = 1;

			// First, get the input pre-taints.
			CELL_PREP_PORTS

			int a_size = cell->getPort(ID::A).size();
			int b_size = cell->getPort(ID::B).size();
			int output_size = cell->getPort(ID::Y).size();

			// By default, pre-taint the whole output.
			std::string ret_string(cell->getPort(ID::Y).size(), '1');

			// However, un-pre-taint the output LSBs until the first input LSB.
			for (int i = 0; i < output_size; i++) {
				if ((i < a_size && attrs[A][i] == '1') || (i < b_size && attrs[B][i] == '1'))
					break;
				ret_string[i] = '0';
			}

			ret_wires_dict[(ID::Y).str()] = ret_string;
		}

		////
		// Bitwise logic functions
		////

		// On a single connection.
		else if (cell->type.in(ID($_BUF_), ID($_NOT_), ID($not), ID($pos))) {
			const unsigned int NUM_INTERESTING_PORTS = 1;
			const IdString port_idstrings[] = {ID::A};
			const unsigned int A = 0;

			// First, get the input pre-taints.
			CELL_PREP_PORTS

			ret_wires_dict[(ID::Y).str()] = attrs[A];		
		}

		// XORs.
		else if (cell->type.in(ID($_XNOR_), ID($_XOR_), ID($xnor), ID($xor))) {
			const unsigned int NUM_INTERESTING_PORTS = 2;
			const IdString port_idstrings[] = {ID::A, ID::B};
			const unsigned int A = 0, B = 1;

			// First, get the input pre-taints.
			CELL_PREP_PORTS

			ret_wires_dict[(ID::Y).str()] = pre_taint_string_or(attrs[A], attrs[B], cell->getPort(ID::Y).size());
		}

		// ANDs.
		else if (cell->type.in(ID($_AND_), ID($_NAND_), ID($and))) {
			const unsigned int NUM_INTERESTING_PORTS = 2;
			const IdString port_idstrings[] = {ID::A, ID::B};
			const unsigned int A = 0, B = 1;

			// First, get the input pre-taints.
			CELL_PREP_PORTS

			int a_size = cell->getPort(ID::A).size();
			int b_size = cell->getPort(ID::B).size();
			int output_size = cell->getPort(ID::Y).size();

			// By default, pre-taint the ORing of the inputs.
			std::string ret_string(pre_taint_string_or(attrs[A], attrs[B], output_size));

			// However, un-pre-taint the output bits when one signal is constant zero.
			for (int i = 0; i < output_size; i++) {
				// TODO Improve by using constant propagation.
				if ((i >= a_size || (!cell->getPort(ID::A)[i].is_wire() && cell->getPort(ID::A)[i].data == RTLIL::State::S0)) || (i >= b_size || (!cell->getPort(ID::B)[i].is_wire() && cell->getPort(ID::B)[i].data == RTLIL::State::S0)))
					ret_string[i] = '0';
			}

			ret_wires_dict[(ID::Y).str()] = ret_string;
		}

		// ORs.
		else if (cell->type.in(ID($_NOR_), ID($_OR_), ID($or))) {
			const unsigned int NUM_INTERESTING_PORTS = 2;
			const IdString port_idstrings[] = {ID::A, ID::B};
			const unsigned int A = 0, B = 1;

			// First, get the input pre-taints.
			CELL_PREP_PORTS

			RTLIL::SigSpec port_a(cell->getPort(ID::A));
			RTLIL::SigSpec port_b(cell->getPort(ID::B));
			RTLIL::SigSpec port_y(cell->getPort(ID::Y));

			int a_size = port_a.size();
			int b_size = port_b.size();
			int y_size = port_y.size();

			RTLIL::SigSpec extended_a(port_a);
			RTLIL::SigSpec extended_b(port_b);
			if (a_size < y_size)
				extended_a.append(RTLIL::SigSpec(RTLIL::State::S0, y_size-a_size));
			if (b_size < y_size)
				extended_b.append(RTLIL::SigSpec(RTLIL::State::S0, y_size-b_size));

			// By default, pre-taint the ORing of the inputs.
			std::string ret_string(pre_taint_string_or(attrs[A], attrs[B], y_size));

			// However, un-pre-taint the output bits when one signal is constant zero.
			for (int i = 0; i < y_size; i++) {
				// TODO Improve by using constant propagation.
				if ((i < a_size && (!cell->getPort(ID::A)[i].is_wire() && cell->getPort(ID::A)[i].data == RTLIL::State::S1)) || (i < b_size && (!cell->getPort(ID::B)[i].is_wire() && cell->getPort(ID::B)[i].data == RTLIL::State::S1)))
					ret_string[i] = '0';
			}

			ret_wires_dict[(ID::Y).str()] = ret_string;
		}

		// Not yet supported variants.
		else if (cell->type.in(ID($_ANDNOT_), ID($_ORNOT_))) {
			log_error("Cell type not yet supported: %s (name: %s, located in module %s).\n", cell->type.c_str(), cell->name.c_str(), cell->module->name.c_str());
		}

		////
		// Reduction logic functions
		////

		else if (cell->type.in(ID($reduce_and), ID($reduce_bool), ID($reduce_or), ID($reduce_xnor), ID($reduce_xor), ID($logic_and), ID($logic_not), ID($logic_or))) {
			const unsigned int NUM_INTERESTING_PORTS = 1;
			const IdString port_idstrings[] = {ID::A};
			const unsigned int A = 0;

			// First, get the input pre-taints.
			CELL_PREP_PORTS

			if (has_string_at_least_one_pre_taint(attrs[A]))
				ret_wires_dict[(ID::Y).str()] = std::string(cell->getPort(ID::Y).size(), '1');	
			else
				ret_wires_dict[(ID::Y).str()] = std::string(cell->getPort(ID::Y).size(), '0');	
		}

		////
		// Equalities and comparisons
		////

		else if (cell->type.in(ID($eq), ID($eqx), ID($ge), ID($gt), ID($le), ID($lt), ID($ne))) {
			const unsigned int NUM_INTERESTING_PORTS = 2;
			const IdString port_idstrings[] = {ID::A, ID::B};
			const unsigned int A = 0, B = 1;

			// First, get the input pre-taints.
			CELL_PREP_PORTS

			if (has_string_at_least_one_pre_taint(attrs[A]) || has_string_at_least_one_pre_taint(attrs[B])) {
				ret_wires_dict[(ID::Y).str()] = std::string(cell->getPort(ID::Y).size(), '1');	
			}
			else {
				ret_wires_dict[(ID::Y).str()] = std::string(cell->getPort(ID::Y).size(), '0');	
			}
		}

		////
		// Flip-flops and latches
		////

		else if (cell->type.in(ID($dff), ID($_DFF_NN0_), ID($_DFF_NN1_), ID($_DFF_NP0_), ID($_DFF_NP1_), ID($_DFF_N_), ID($_DFF_PN0_), ID($_DFF_PN1_), ID($_DFF_PP0_), ID($_DFF_PP1_), ID($_DFF_P_), ID($ff), ID($_FF_), ID($adff), ID($sdff), ID($adlatch), ID($dlatch))) {
			const unsigned int NUM_INTERESTING_PORTS = 1;
			const IdString port_idstrings[] = {ID::D};
			const unsigned int D = 0;

			// First, get the input pre-taints.
			CELL_PREP_PORTS

			ret_wires_dict[(ID::Q).str()] = attrs[D];		
		} else if (cell->type.in(ID($_DFFE_NN0N_), ID($_DFFE_NN0P_), ID($_DFFE_NN1N_), ID($_DFFE_NN1P_), ID($_DFFE_NN_), ID($_DFFE_NP0N_), ID($_DFFE_NP0P_), ID($_DFFE_NP1N_), ID($_DFFE_NP1P_), ID($_DFFE_NP_), ID($_DFFE_PN0N_), ID($_DFFE_PN0P_), ID($_DFFE_PN1N_), ID($_DFFE_PN1P_), ID($_DFFE_PN_), ID($_DFFE_PP0N_), ID($_DFFE_PP0P_), ID($_DFFE_PP1N_), ID($_DFFE_PP1P_), ID($_DFFE_PP_), ID($_DLATCH_N_), ID($_DLATCH_P_))) {
			const unsigned int NUM_INTERESTING_PORTS = 2;
			const IdString port_idstrings[] = {ID::D, ID::E};
			const unsigned int D = 0, E = 1;

			// First, get the input pre-taints.
			CELL_PREP_PORTS

			if(has_string_at_least_one_pre_taint(attrs[E]))
				ret_wires_dict[(ID::Q).str()] = std::string(cell->getPort(ID::Q).size(), '1');
			else
				ret_wires_dict[(ID::Q).str()] = attrs[D];
		} else if (cell->type.in(ID($_DFFSRE_NNNN_), ID($_DFFSRE_NNNP_), ID($_DFFSRE_NNPN_), ID($_DFFSRE_NNPP_), ID($_DFFSRE_NPNN_), ID($_DFFSRE_NPNP_), ID($_DFFSRE_NPPN_), ID($_DFFSRE_NPPP_), ID($_DFFSRE_PNNN_), ID($_DFFSRE_PNNP_), ID($_DFFSRE_PNPN_), ID($_DFFSRE_PNPP_), ID($_DFFSRE_PPNN_), ID($_DFFSRE_PPNP_), ID($_DFFSRE_PPPN_), ID($_DFFSRE_PPPP_))) {
			const unsigned int NUM_INTERESTING_PORTS = 3;
			const IdString port_idstrings[] = {ID::D, ID::E, ID::S};
			const unsigned int D = 0, E = 1, S = 2;

			// First, get the input pre-taints.
			CELL_PREP_PORTS

			if(has_string_at_least_one_pre_taint(attrs[E]) || has_string_at_least_one_pre_taint(attrs[S]))
				ret_wires_dict[(ID::Q).str()] = std::string(cell->getPort(ID::Q).size(), '1');
			else
				ret_wires_dict[(ID::Q).str()] = attrs[D];
		} else if (cell->type.in(ID($_DFFSR_NNN_), ID($_DFFSR_NNP_), ID($_DFFSR_NPN_), ID($_DFFSR_NPP_), ID($_DFFSR_PNN_), ID($_DFFSR_PNP_), ID($_DFFSR_PPN_), ID($_DFFSR_PPP_))) {
			const unsigned int NUM_INTERESTING_PORTS = 2;
			const IdString port_idstrings[] = {ID::D, ID::S};
			const unsigned int D = 0, S = 1;

			// First, get the input pre-taints.
			CELL_PREP_PORTS

			if(has_string_at_least_one_pre_taint(attrs[S]))
				ret_wires_dict[(ID::Q).str()] = std::string(cell->getPort(ID::Q).size(), '1');
			else
				ret_wires_dict[(ID::Q).str()] = attrs[D];
		} else if (cell->type.in(ID($_DLATCHSR_NNN_), ID($_DLATCHSR_NNP_), ID($_DLATCHSR_NPN_), ID($_DLATCHSR_NPP_), ID($_DLATCHSR_PNN_), ID($_DLATCHSR_PNP_), ID($_DLATCHSR_PPN_), ID($_DLATCHSR_PPP_))) {
			const unsigned int NUM_INTERESTING_PORTS = 4;
			const IdString port_idstrings[] = {ID::D, ID::E, ID::S, ID::R};
			const unsigned int D = 0, E = 1, S = 2, R = 3;

			// First, get the input pre-taints.
			CELL_PREP_PORTS

			if(has_string_at_least_one_pre_taint(attrs[E]), has_string_at_least_one_pre_taint(attrs[S]), has_string_at_least_one_pre_taint(attrs[R]))
				ret_wires_dict[(ID::Q).str()] = std::string(cell->getPort(ID::Q).size(), '1');
			else
				ret_wires_dict[(ID::Q).str()] = attrs[D];
		} else if (cell->type.in(ID($_DLATCH_NN0_), ID($_DLATCH_NN1_), ID($_DLATCH_NP0_), ID($_DLATCH_NP1_), ID($_DLATCH_PN0_), ID($_DLATCH_PN1_), ID($_DLATCH_PP0_), ID($_DLATCH_PP1_), ID($_SDFFCE_NN0N_), ID($_SDFFCE_NN0P_), ID($_SDFFCE_NN1N_), ID($_SDFFCE_NN1P_), ID($_SDFFCE_NP0N_), ID($_SDFFCE_NP0P_), ID($_SDFFCE_NP1N_), ID($_SDFFCE_NP1P_), ID($_SDFFCE_PN0N_), ID($_SDFFCE_PN0P_), ID($_SDFFCE_PN1N_), ID($_SDFFCE_PN1P_), ID($_SDFFCE_PP0N_), ID($_SDFFCE_PP0P_), ID($_SDFFCE_PP1N_), ID($_SDFFCE_PP1P_), ID($_SDFFE_NN0N_), ID($_SDFFE_NN0P_), ID($_SDFFE_NN1N_), ID($_SDFFE_NN1P_), ID($_SDFFE_NP0N_), ID($_SDFFE_NP0P_), ID($_SDFFE_NP1N_), ID($_SDFFE_NP1P_), ID($_SDFFE_PN0N_), ID($_SDFFE_PN0P_), ID($_SDFFE_PN1N_), ID($_SDFFE_PN1P_), ID($_SDFFE_PP0N_), ID($_SDFFE_PP0P_), ID($_SDFFE_PP1N_), ID($_SDFFE_PP1P_))) {
			const unsigned int NUM_INTERESTING_PORTS = 3;
			const IdString port_idstrings[] = {ID::D, ID::R, ID::E};
			const unsigned int D = 0, R = 1, E = 1;

			// First, get the input pre-taints.
			CELL_PREP_PORTS

			if(has_string_at_least_one_pre_taint(attrs[R]) || has_string_at_least_one_pre_taint(attrs[E]))
				ret_wires_dict[(ID::Q).str()] = std::string(cell->getPort(ID::Q).size(), '1');
			else
				ret_wires_dict[(ID::Q).str()] = attrs[D];
		} else if (cell->type.in(ID($_SDFF_NN0_), ID($_SDFF_NN1_), ID($_SDFF_NP0_), ID($_SDFF_NP1_), ID($_SDFF_PN0_), ID($_SDFF_PN1_), ID($_SDFF_PP0_), ID($_SDFF_PP1_))) {
			const unsigned int NUM_INTERESTING_PORTS = 2;
			const IdString port_idstrings[] = {ID::D, ID::R};
			const unsigned int D = 0, R = 1;

			// First, get the input pre-taints.
			CELL_PREP_PORTS

			if(has_string_at_least_one_pre_taint(attrs[R]))
				ret_wires_dict[(ID::Q).str()] = std::string(cell->getPort(ID::Q).size(), '1');
			else
				ret_wires_dict[(ID::Q).str()] = attrs[D];
		} else if (cell->type.in(ID($_SR_NN_), ID($_SR_NP_), ID($_SR_PN_), ID($_SR_PP_))) {
			const unsigned int NUM_INTERESTING_PORTS = 2;
			const IdString port_idstrings[] = {ID::S, ID::R};
			const unsigned int S = 0, R = 1;

			// First, get the input pre-taints.
			CELL_PREP_PORTS

			if(has_string_at_least_one_pre_taint(attrs[S]) || has_string_at_least_one_pre_taint(attrs[R]))
				ret_wires_dict[(ID::Q).str()] = std::string(cell->getPort(ID::Q).size(), '1');
			else
				ret_wires_dict[(ID::Q).str()] = std::string(cell->getPort(ID::Q).size(), '0');
		} else if (cell->type.in(ID($sr))) {
			const unsigned int NUM_INTERESTING_PORTS = 2;
			const IdString port_idstrings[] = {ID::SET, ID::CLR};
			const unsigned int SET = 0, CLR = 1;

			// First, get the input pre-taints.
			CELL_PREP_PORTS

			if(has_string_at_least_one_pre_taint(attrs[SET]) || has_string_at_least_one_pre_taint(attrs[CLR]))
				ret_wires_dict[(ID::Q).str()] = std::string(cell->getPort(ID::Q).size(), '1');
			else
				ret_wires_dict[(ID::Q).str()] = std::string(cell->getPort(ID::Q).size(), '0');
		} else if (cell->type.in(ID($sdffe), ID($sdffce), ID($adffe))) {
			const unsigned int NUM_INTERESTING_PORTS = 2;
			const IdString port_idstrings[] = {ID::D, ID::EN};
			const unsigned int D = 0, EN = 1;

			// First, get the input pre-taints.
			CELL_PREP_PORTS

			if(has_string_at_least_one_pre_taint(attrs[EN]))
				ret_wires_dict[(ID::Q).str()] = std::string(cell->getPort(ID::Q).size(), '1');
			else
				ret_wires_dict[(ID::Q).str()] = attrs[D];
		} else if (cell->type.in(ID($dffsr), ID($dffsre), ID($dlatchsr))) {
			const unsigned int NUM_INTERESTING_PORTS = 2;
			const IdString port_idstrings[] = {ID::D, ID::CLR};
			const unsigned int D = 0, CLR = 1;

			// First, get the input pre-taints.
			CELL_PREP_PORTS

			if(has_string_at_least_one_pre_taint(attrs[CLR]))
				ret_wires_dict[(ID::Q).str()] = std::string(cell->getPort(ID::Q).size(), '1');
			else
				ret_wires_dict[(ID::Q).str()] = attrs[D];
		} else { // For all the other cells
			// Fully pre-taint the outputs.
			for (std::pair<RTLIL::IdString, RTLIL::SigSpec> connection_out: cell->connections()) {
				// Only look at output connections.
				if (!cell->output(connection_out.first))
					continue;

				ret_wires_dict[connection_out.first.str()] = std::string(connection_out.second.size(), '1');
			}
		}

		return ret_wires_dict;
	}

	/////////////////////////////
	// Main recursive function //
	/////////////////////////////

	/**
	 * @param module the current module.
	 * @param new_pre_tainted_wires_in dict of input names and corresponding pre-taint strings.
	 * @return dict of output names and corresponding pre-taint strings.
	 */
	dict<std::string, std::string> pre_taint (RTLIL::Module *module, const dict<std::string, std::string> &new_pre_tainted_wires_in, std::string curr_attr_name) {		
		// Contains all the wires that had some pre-tainting modification during the call of this function.
		pool<RTLIL::Wire*> ret_wires;
		// Adapt the ret_wires into a dict.
		dict<std::string, std::string> ret_wires_dict;

		// Alternating array. Any element in this struct must have at least one pre-tainted bit.
		// Represents the wires to be newly explored.
		pool<RTLIL::Wire*> new_pre_tainted_wires[2];
		// Alternates between 0 and 1.
		int curr_index_in_arr = 0;

		// if (module->name.c_str() == ID(FPUExeUnit).str()) {
		// 	for (RTLIL::Wire *wire_it: module->wires()) {
		// 		if (wire_it->has_attribute(curr_attr_name))
		// 			log("Initially, module %s has wire %s (ptr %p): %s.\n", module->name.c_str(), wire_it->name.c_str(), wire_it, wire_it->get_string_attribute(curr_attr_name).c_str());
		// 		else
		// 			log("Initially, module %s has wire %s (ptr %p): Untouched.\n", module->name.c_str(), wire_it->name.c_str(), wire_it);
		// 	}
		// }

		// Select all the taint input wires.
		for(std::pair<std::string, std::string> new_pre_tainted_wire_in: new_pre_tainted_wires_in) {
			// Extract the port information (name and pre-taint information) from the function input.
			std::string port_name = new_pre_tainted_wire_in.first;
			std::string port_pre_taint_assignment = new_pre_tainted_wire_in.second;

			// For all the wires in the module, look if there is a name match.
			for (RTLIL::Wire *wire_it: module->wires()) {
				// If there is an input match.
				if (!wire_it->port_input || wire_it->name != port_name)
					continue;
				log_assert((size_t)wire_it->width == port_pre_taint_assignment.size());

				// If there is a match, then OR the wire attr with the argument attr.

				// This is a test to check that there has indeed been an update on the input wire.
				if (wire_it->has_attribute(curr_attr_name)) {
					bool is_there_an_update = false;
					std::string wire_attr = wire_it->get_string_attribute(curr_attr_name);
					for (int curr_bit_id = 0; curr_bit_id < wire_it->width; curr_bit_id++)
						is_there_an_update |= wire_attr[curr_bit_id] == '0' && port_pre_taint_assignment[curr_bit_id] == '1';

					if (!is_there_an_update) {
						// There may be no update. Because this is difficult to control from the outside, do the check at the beginning of the submodule treatment.
						continue;
					}
				}
				wire_it->set_string_attribute(curr_attr_name, port_pre_taint_assignment);
				// And finally insert the wire to the new wires to consider, if there was indeed a change.
				new_pre_tainted_wires[curr_index_in_arr].insert(wire_it);
			}
		}

		// If there is no new input pre-taint, then skip this module.
		if (new_pre_tainted_wires[curr_index_in_arr].empty())
			return ret_wires_dict;

		// Continue by looping while there are no new pre-tainted wires.
		while (!new_pre_tainted_wires[curr_index_in_arr].empty()) {
			// log("\n");
			// log("[module %s] Starting a new round!\n", module->name.c_str());
			// log("\n");
			// for (RTLIL::Wire *wire_it: new_pre_tainted_wires[curr_index_in_arr])
			// 	log("New tainted wire: %s.\n", wire_it->name.c_str());
			// log("\n");

			// Add the output wires corresponding to module outputs to the return pool.
			for (RTLIL::Wire *new_pre_tainted_wire: new_pre_tainted_wires[curr_index_in_arr])
				if (new_pre_tainted_wire->port_output && ret_wires.find(new_pre_tainted_wire) == ret_wires.end())
					ret_wires.insert(new_pre_tainted_wire);

			// Clear the pool of the next new pre-tainted wires.
			new_pre_tainted_wires[1-curr_index_in_arr].clear();

			for (RTLIL::Cell *cell: module->cells()) {
				RTLIL::Module *submodule = module->design->module(cell->type);
				// Look among the cells, which ones are affected by the new wire taint assignments.

				// First, prepare the cell connections dict.
				dict<std::string, std::string> cell_connections_in;
				// is_some_connection_affected is used for elementary cells. Whereas submodules record the attrs of their inputs, thereby
				// allowing the new input dict to contain only the fresh inputs, thereby allowing to check if some input was affected, simply by checking whether the dict is empty,
				// the boolean is_some_connection_affected helps with elementary cells, whose dict is always full;
				bool is_some_connection_affected = false;
				// Iterate through all the module's outside connections.
				for (std::pair<RTLIL::IdString, RTLIL::SigSpec> connection: cell->connections()) {
					// Only look at input connections.
					if (!cell->input(connection.first))
						continue;
					RTLIL::SigSpec connection_sigspec = connection.second;

					// is_connection_affected translates that this connection belongs to the newly refreshed wires.
					bool is_connection_affected = false;
					std::string connection_attr_str(connection_sigspec.size(), '0');

					// Check the connection bitwise.
					for (int curr_bit_id = 0; curr_bit_id < connection_sigspec.size(); curr_bit_id++) {
						// If the bit is a constant, then do nothing. Only look at wire bits.
						if (connection_sigspec[curr_bit_id].wire) {
							RTLIL::Wire *connection_sigspec_wire = connection_sigspec[curr_bit_id].wire;

							// If the origin of the connection is not pre-tainted, then do nothing.
							if (!connection_sigspec_wire->has_attribute(curr_attr_name))
								continue;

							// Check whether the connection has been refreshed.
							for (RTLIL::Wire *new_wire: new_pre_tainted_wires[curr_index_in_arr]) {
								if (new_wire == connection_sigspec_wire) {
									is_connection_affected = true;
									// Submodules record the past attributes of inputs. But elementary cells must be fed with all the attributes.
									if (submodule != nullptr)
										break;
								}
							}
							if (!is_connection_affected && submodule != nullptr)
								break;

							// If the input pre-taint bit is one, so must be the output.
							// TODO May be optimized.
							if (connection_sigspec_wire->get_string_attribute(curr_attr_name)[connection_sigspec[curr_bit_id].offset] == '1' && connection_attr_str[curr_bit_id] == '0') {
								connection_attr_str[curr_bit_id] = '1';
							}
						}
					}
					if (is_connection_affected)
						cell_connections_in[connection.first.str()] = connection_attr_str;
					is_some_connection_affected |= is_connection_affected;


				}

				if (is_some_connection_affected) {
					// Look among the modules, which ones are affected by the new wire taint assignments.
					// If there is at least one modified input wire, then explore the submodule.
					dict<std::string, std::string> cell_connections_out;
					if (submodule == nullptr) {
						cell_connections_out = pre_cellift_cell(cell, cell_connections_in);
						cell->set_bool_attribute(pass_attr_name);
					}
					else {
						cell_connections_out = pre_taint(submodule, cell_connections_in, curr_attr_name+"-"+cell->name.str());
					}

					// Look at all the cell output connections and check whether there is a match with the cell execution output.
					for (std::pair<std::string, std::string> &cell_connection_out: cell_connections_out) {
						for (std::pair<RTLIL::IdString, RTLIL::SigSpec> connection: cell->connections()) {
							// Check whether the connection matches one of the changed wires.
							if (connection.first.str() != cell_connection_out.first)
								continue;

							RTLIL::SigSpec connection_sigspec = connection.second;
							std::string connection_attr_str(connection_sigspec.size(), '0');
							for (int curr_bit_id = 0; curr_bit_id < connection_sigspec.size(); curr_bit_id++) {
								// The output connection must be a wire, else cannot be pre-tainted.
								if (connection_sigspec[curr_bit_id].wire) {
									RTLIL::Wire *connection_sigspec_wire = connection_sigspec[curr_bit_id].wire;
									// If the origin of the connection is not pre-tainted, then do nothing.
									if (!connection_sigspec_wire->has_attribute(curr_attr_name))
										connection_sigspec_wire->set_string_attribute(curr_attr_name, std::string(connection_sigspec_wire->width, '0'));

									// If the input pre-taint bit is one, so must be the output.
									if (cell_connection_out.second[curr_bit_id] == '1') {
										std::string str_attr = connection_sigspec_wire->get_string_attribute(curr_attr_name);

										if (str_attr[connection_sigspec[curr_bit_id].offset] == '0') {
											str_attr[connection_sigspec[curr_bit_id].offset] = '1';
											connection_sigspec_wire->set_string_attribute(curr_attr_name, str_attr);

											new_pre_tainted_wires[1-curr_index_in_arr].insert(connection_sigspec_wire);
										}
									}
								}
							}
						}
					}
				}
			}

			// (d) Look among the connections, which ones are affected by the new wire taint assignments.
			for (RTLIL::SigSig connection_it: module->connections()) {
				// Iterate through the bits of each connection sigspec. The bit id indexes the source and destination SigSpec connection.
				for (int curr_bit_id = 0; curr_bit_id < connection_it.second.size(); curr_bit_id++) {
					// Both SigBits need to be wires.
					if (connection_it.first[curr_bit_id].wire && connection_it.second[curr_bit_id].wire) {
						RTLIL::Wire *first_wire  = connection_it.first[curr_bit_id].wire;
						RTLIL::Wire *second_wire = connection_it.second[curr_bit_id].wire;

						// If the origin of the connection is not pre-tainted, then do nothing.
						if (!second_wire->has_attribute(curr_attr_name))
							continue;

						// Initialize the wire attributes to zero if necessary.
						if (!first_wire->has_attribute(curr_attr_name))
							first_wire->set_string_attribute(curr_attr_name, std::string(first_wire->width, '0'));

						// If the input pre-taint bit is one, so must be the output.
						if (second_wire->get_string_attribute(curr_attr_name)[connection_it.second[curr_bit_id].offset] == '1') {
							std::string new_first_attribute = first_wire->get_string_attribute(curr_attr_name);

							if (new_first_attribute[connection_it.first[curr_bit_id].offset] == '0') {
								new_first_attribute[connection_it.first[curr_bit_id].offset] = '1';
								first_wire->set_string_attribute(curr_attr_name, new_first_attribute);
								// log("[module %s] Adding taint wire from connection %s <- %s.\n", module->name.c_str(), first_wire->name.c_str(), second_wire->name.c_str());

								new_pre_tainted_wires[1-curr_index_in_arr].insert(first_wire);
							}
						}
					}
				}
			}

			curr_index_in_arr = 1-curr_index_in_arr;
		}

		module->set_bool_attribute(curr_attr_name);

		for (RTLIL::Wire *ret_wire: ret_wires)
			ret_wires_dict[ret_wire->name.str()] = ret_wire->get_string_attribute(curr_attr_name);

		// if (module->name.c_str() == ID(FPUExeUnit).str()) {
		// 	for (RTLIL::Wire *wire_it: module->wires()) {
		// 		if (wire_it->has_attribute(curr_attr_name))
		// 			log("Finally, module %s has wire %s: %s.\n", module->name.c_str(), wire_it->name.c_str(), wire_it->get_string_attribute(curr_attr_name).c_str());
		// 		else
		// 			log("Finally, module %s has wire %s: Untouched.\n", module->name.c_str(), wire_it->name.c_str());
		// 	}
		// }

		return ret_wires_dict;
	}

	/////////////////////////////
	// Display wire pre-taints //
	/////////////////////////////

	void display_wire_pre_taints (RTLIL::Module *module, std::string log_prefix, std::string curr_attr_name) {

		log("%s-- Module: %s --.\n", log_prefix.c_str(), module->name.c_str());

		for (RTLIL::Wire *wire_it: module->wires()) {
			if (wire_it->has_attribute(curr_attr_name))
				log("%s%s: %s.\n", log_prefix.c_str(), wire_it->name.c_str(), wire_it->get_string_attribute(curr_attr_name).c_str());
			else
				log("%s%s: Untouched.\n", log_prefix.c_str(), wire_it->name.c_str());
		}

		for (RTLIL::Cell *cell: module->cells()) {
			RTLIL::Module *submodule = module->design->module(cell->type);
			if (submodule != nullptr) {
				display_wire_pre_taints(submodule, log_prefix+"  ", curr_attr_name+"-"+cell->name.str());
			}
		}
	}

public:
	PreCelliftWorker(RTLIL::Module *top_module, const std::vector<std::string>& opt_excluded_signals, const std::vector<std::string>& opt_included_signals, bool _opt_verbose) {
		pool<RTLIL::Wire*> top_wires = top_module->wires();
		dict<std::string, std::string> input_wires_taints;

		// If the include_signals flag is set, then only the in signals present in the opt_included_signals vector will be pre-tainted
		// for the first top round.  
		bool include_signals = (bool) opt_included_signals.size();
		log("Excluded signals size: %zu.\n", opt_excluded_signals.size());
		log("Included signals size: %zu.\n", opt_included_signals.size());
		log("Include signals flag: %d.\n", include_signals);

		opt_verbose = _opt_verbose;

		// Pre-taint the input wires completely.
		for (RTLIL::Wire *it : top_wires)
			if (it->port_input && (!include_signals || std::find(opt_included_signals.begin(), opt_included_signals.end(), it->name.str().substr(1, it->name.str().size()-1)) != opt_included_signals.end()) && std::find(opt_excluded_signals.begin(), opt_excluded_signals.end(), it->name.str().substr(1, it->name.str().size()-1)) == opt_excluded_signals.end()) {
				log("Including signal: %s.\n", it->name.c_str());

				input_wires_taints[it->name.str()] = std::string(it->width, '1');
			}

		pre_taint(top_module, input_wires_taints, pass_attr_name);

		display_wire_pre_taints(top_module, "", pass_attr_name);
	}
};

struct PreCelliftPass : public Pass {
	PreCelliftPass() : Pass("pre_cellift", "Static taint analysis.") {}

	void help() override
	{
		//   |---v---|---v---|---v---|---v---|---v---|---v---|---v---|---v---|---v---|---v---|
		log("\n");
		log("    pre_cellift <command> [options] [selection]\n");
		log("\n");
		log("Pre-taints the design through static analysis starting at the specified top inputs.\n");
		log("\n");
		log("  -exclude-top-signals\n");
		log("    Specifies a list of comma-separated signals that are not considered\n");
		log("    as taint sources. Incompatible with -include-top-signals.\n");
		log("\n");
		log("  -verbose\n");
		log("    Verbose mode.\n");
		log("\n");
		log("  -include-top-signals\n");
		log("    Specifies a list of comma-separated signals that are considered\n");
		log("    as the taint sources. Incompatible with -exclude-top-signals.\n");
		log("\n");
	}

	void execute(std::vector<std::string> args, RTLIL::Design *design) override
	{
		bool opt_verbose = false;

		string opt_excluded_signals_csv;
		std::vector<std::string> opt_excluded_signals;
		string opt_included_signals_csv;
		std::vector<std::string> opt_included_signals;

		std::vector<std::string>::size_type argidx;
		for (argidx = 1; argidx < args.size(); argidx++) {
			if (args[argidx] == "-exclude-top-signals") {
				opt_excluded_signals_csv = args[++argidx];
				continue;
			}
			if (args[argidx] == "-include-top-signals") {
				opt_included_signals_csv = args[++argidx];
				continue;
			}
			if (args[argidx] == "-verbose") {
				opt_verbose = true;
				continue;
			}
		}

		log_header(design, "Executing pre_cellift pass.\n");

		if (GetSize(design->selected_modules()) == 0)
			log_cmd_error("Can't operate on an empty selection!\n");

		if (opt_excluded_signals_csv.size() && opt_included_signals_csv.size())
			log_error("Cannot specify -exclude-top-signals and -include-top-signals simultaneously.\n");

		// Parse the excluded signals.
		if (opt_excluded_signals_csv.size()) {
			char delimiter = ',';
			int csv_start = 0;
			int end = opt_excluded_signals_csv.find(delimiter);
			while (end != -1) {
				opt_excluded_signals.push_back(opt_excluded_signals_csv.substr(csv_start, end - csv_start));
				csv_start = end+1;
				end = opt_excluded_signals_csv.find(delimiter, csv_start);
			}
			opt_excluded_signals.push_back(opt_excluded_signals_csv.substr(csv_start, end - csv_start));
		}
		// Parse the included signals.
		if (opt_included_signals_csv.size()) {
			char delimiter = ',';
			int csv_start = 0;
			int end = opt_included_signals_csv.find(delimiter);
			while (end != -1) {
				opt_included_signals.push_back(opt_included_signals_csv.substr(csv_start, end - csv_start));
				csv_start = end+1;
				end = opt_included_signals_csv.find(delimiter, csv_start);
			}
			opt_included_signals.push_back(opt_included_signals_csv.substr(csv_start, end - csv_start));
		}

		PreCelliftWorker worker(design->top_module(), opt_excluded_signals, opt_included_signals, opt_verbose);
	}
} PreCelliftPass;

PRIVATE_NAMESPACE_END
