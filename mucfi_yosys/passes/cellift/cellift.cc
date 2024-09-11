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

// For all new cells, add src=cell->get_src_attribute()

#include "kernel/log.h"
#include "kernel/register.h"
#include "kernel/rtlil.h"
#include "kernel/utils.h"
#include "kernel/yosys.h"

USING_YOSYS_NAMESPACE

extern bool is_signal_excluded(std::vector<string> *excluded_signals, string signal_name);
extern std::string get_wire_taint_idstring(RTLIL::IdString id_string, unsigned int taint_id);
extern std::vector<RTLIL::SigSpec> get_corresponding_taint_signals(RTLIL::Module *module, std::vector<string> *excluded_signals,
								   const RTLIL::SigSpec &sig, unsigned int num_taints);

extern bool cellift_dlatch(RTLIL::Module *module, RTLIL::Cell *cell, unsigned int num_taints, std::vector<string> *excluded_signals);
extern bool cellift_dlatch_en(RTLIL::Module *module, RTLIL::Cell *cell, unsigned int num_taints, std::vector<string> *excluded_signals);
extern bool cellift_dff(RTLIL::Module *module, RTLIL::Cell *cell, unsigned int num_taints, std::vector<string> *excluded_signals);
extern bool cellift_dff_techmap(RTLIL::Module *module, RTLIL::Cell *cell, unsigned int num_taints, std::vector<string> *excluded_signals);
extern bool cellift_adff(RTLIL::Module *module, RTLIL::Cell *cell, unsigned int num_taints, std::vector<string> *excluded_signals);
extern bool cellift_aldff(RTLIL::Module *module, RTLIL::Cell *cell, unsigned int num_taints, std::vector<string> *excluded_signals, bool opt_data_flow);
extern bool cellift_sdff(RTLIL::Module *module, RTLIL::Cell *cell, unsigned int num_taints, std::vector<string> *excluded_signals);
extern bool cellift_sdff_techmap(RTLIL::Module *module, RTLIL::Cell *cell, unsigned int num_taints, std::vector<string> *excluded_signals);
extern bool cellift_adffe(RTLIL::Module *module, RTLIL::Cell *cell, unsigned int num_taints, std::vector<string> *excluded_signals, bool opt_data_flow);
extern bool cellift_sdffe(RTLIL::Module *module, RTLIL::Cell *cell, unsigned int num_taints, std::vector<string> *excluded_signals, bool opt_data_flow);
extern bool cellift_dffe(RTLIL::Module *module, RTLIL::Cell *cell, unsigned int num_taints, std::vector<string> *excluded_signals, bool opt_data_flow);
extern bool cellift_dffe_techmap(RTLIL::Module *module, RTLIL::Cell *cell, unsigned int num_taints, std::vector<string> *excluded_signals, bool opt_data_flow);
extern bool cellift_sdffce(RTLIL::Module *module, RTLIL::Cell *cell, unsigned int num_taints, std::vector<string> *excluded_signals, bool opt_data_flow);
extern bool cellift_sdffce_techmap(RTLIL::Module *module, RTLIL::Cell *cell, unsigned int num_taints, std::vector<string> *excluded_signals, bool opt_data_flow);
extern bool cellift_sdffe_techmap(RTLIL::Module *module, RTLIL::Cell *cell, unsigned int num_taints, std::vector<string> *excluded_signals, bool opt_data_flow);
extern bool cellift_dffe_rst_techmap(RTLIL::Module *module, RTLIL::Cell *cell, unsigned int num_taints, std::vector<string> *excluded_signals, bool opt_data_flow);
extern bool cellift_sdff_techmap(RTLIL::Module *module, RTLIL::Cell *cell, unsigned int num_taints, std::vector<string> *excluded_signals);
extern bool cellift_dff_simple_techmap(RTLIL::Module *module, RTLIL::Cell *cell, unsigned int num_taints, std::vector<string> *excluded_signals);
extern bool cellift_add(RTLIL::Module *module, RTLIL::Cell *cell, unsigned int num_taints, std::vector<string> *excluded_signals);
extern bool cellift_sub(RTLIL::Module *module, RTLIL::Cell *cell, unsigned int num_taints, std::vector<string> *excluded_signals);
extern bool cellift_not(RTLIL::Module *module, RTLIL::Cell *cell, unsigned int num_taints, std::vector<string> *excluded_signals);
extern bool cellift_neg(RTLIL::Module *module, RTLIL::Cell *cell, unsigned int num_taints, std::vector<string> *excluded_signals);
extern bool cellift_and(RTLIL::Module *module, RTLIL::Cell *cell, unsigned int num_taints, std::vector<string> *excluded_signals);
extern bool cellift_or(RTLIL::Module *module, RTLIL::Cell *cell, unsigned int num_taints, std::vector<string> *excluded_signals);
extern bool cellift_mod(RTLIL::Module *module, RTLIL::Cell *cell, unsigned int num_taints, std::vector<string> *excluded_signals);
extern bool cellift_mul(RTLIL::Module *module, RTLIL::Cell *cell, unsigned int num_taints, std::vector<string> *excluded_signals);
extern bool cellift_pmux_large_cells(RTLIL::Module *module, RTLIL::Cell *cell, unsigned int num_taints, std::vector<string> *excluded_signals);
extern bool cellift_pmux_small_cells(RTLIL::Module *module, RTLIL::Cell *cell, unsigned int num_taints, std::vector<string> *excluded_signals);
extern bool cellift_mux(RTLIL::Module *module, RTLIL::Cell *cell, unsigned int num_taints, std::vector<string> *excluded_signals, bool opt_data_flow);
extern bool cellift_xor(RTLIL::Module *module, RTLIL::Cell *cell, unsigned int num_taints, std::vector<string> *excluded_signals);
extern bool cellift_eq_ne(RTLIL::Module *module, RTLIL::Cell *cell, unsigned int num_taints, std::vector<string> *excluded_signals);
extern bool cellift_ge(RTLIL::Module *module, RTLIL::Cell *cell, unsigned int num_taints, std::vector<string> *excluded_signals);
extern bool cellift_gt(RTLIL::Module *module, RTLIL::Cell *cell, unsigned int num_taints, std::vector<string> *excluded_signals);
extern bool cellift_le(RTLIL::Module *module, RTLIL::Cell *cell, unsigned int num_taints, std::vector<string> *excluded_signals);
extern bool cellift_lt(RTLIL::Module *module, RTLIL::Cell *cell, unsigned int num_taints, std::vector<string> *excluded_signals);
extern bool cellift_logic_and(RTLIL::Module *module, RTLIL::Cell *cell, unsigned int num_taints, std::vector<string> *excluded_signals);
extern bool cellift_logic_or(RTLIL::Module *module, RTLIL::Cell *cell, unsigned int num_taints, std::vector<string> *excluded_signals);
extern bool cellift_logic_not(RTLIL::Module *module, RTLIL::Cell *cell, unsigned int num_taints, std::vector<string> *excluded_signals);
extern bool cellift_reduce_and(RTLIL::Module *module, RTLIL::Cell *cell, unsigned int num_taints, std::vector<string> *excluded_signals);
extern bool cellift_reduce_xor(RTLIL::Module *module, RTLIL::Cell *cell, unsigned int num_taints, std::vector<string> *excluded_signals);
extern bool cellift_shl_sshl_precise(RTLIL::Module *module, RTLIL::Cell *cell, unsigned int num_taints, std::vector<string> *excluded_signals);
extern bool cellift_shl_sshl_imprecise(RTLIL::Module *module, RTLIL::Cell *cell, unsigned int num_taints, std::vector<string> *excluded_signals);
extern bool cellift_shr_sshr_imprecise(RTLIL::Module *module, RTLIL::Cell *cell, unsigned int num_taints, std::vector<string> *excluded_signals);
extern bool cellift_shr(RTLIL::Module *module, RTLIL::Cell *cell, unsigned int num_taints, std::vector<string> *excluded_signals);
extern bool cellift_sshr(RTLIL::Module *module, RTLIL::Cell *cell, unsigned int num_taints, std::vector<string> *excluded_signals);
extern bool cellift_shift_shiftx_precise(RTLIL::Module *module, RTLIL::Cell *cell, unsigned int num_taints, std::vector<string> *excluded_signals);
extern bool cellift_shiftx_imprecise(RTLIL::Module *module, RTLIL::Cell *cell, unsigned int num_taints, std::vector<string> *excluded_signals);
extern bool cellift_shift_imprecise(RTLIL::Module *module, RTLIL::Cell *cell, unsigned int num_taints, std::vector<string> *excluded_signals);

extern bool cellift_conjunctive_one_input(RTLIL::Module *module, RTLIL::Cell *cell, unsigned int num_taints, std::vector<string> *excluded_signals);
extern bool cellift_conjunctive_two_inputs(RTLIL::Module *module, RTLIL::Cell *cell, unsigned int num_taints, std::vector<string> *excluded_signals);
extern bool cellift_conjunctive_three_inputs(RTLIL::Module *module, RTLIL::Cell *cell, unsigned int num_taints,
					     std::vector<string> *excluded_signals);

bool cellift_comp_data_flow(RTLIL::Module *module, RTLIL::Cell *cell, unsigned int num_taints, std::vector<string> *excluded_signals);
bool cellift_reduce_data_flow(RTLIL::Module *module, RTLIL::Cell *cell, unsigned int num_taints, std::vector<string> *excluded_signals);
bool cellift_shr_sshr_data_flow(RTLIL::Module *module, RTLIL::Cell *cell, unsigned int num_taints, std::vector<string> *excluded_signals);
bool cellift_shl_sshl_data_flow(RTLIL::Module *module, RTLIL::Cell *cell, unsigned int num_taints, std::vector<string> *excluded_signals);
extern bool cellift_pmux_data_flow(RTLIL::Module *module, RTLIL::Cell *cell, unsigned int num_taints, std::vector<string> *excluded_signals);
bool cellift_shift_data_flow(RTLIL::Module *module, RTLIL::Cell *cell, unsigned int num_taints, std::vector<string> *excluded_signals);
bool cellift_shiftx_data_flow(RTLIL::Module *module, RTLIL::Cell *cell, unsigned int num_taints, std::vector<string> *excluded_signals);
bool cellift_mod_data_flow(RTLIL::Module *module, RTLIL::Cell *cell, unsigned int num_taints, std::vector<string> *excluded_signals);

extern bool rtlift_add(RTLIL::Module *module, RTLIL::Cell *cell, unsigned int num_taints, std::vector<string> *excluded_signals);

PRIVATE_NAMESPACE_BEGIN

struct CellIFTWorker {
      private:
	// Command line arguments.
	bool opt_verbose = false;
	bool opt_rtlift = false;		     // Whether to implement the adder/multiplier using the RTLIFT fashion.
	pool<string> opt_conjunctive_cells_pool;     // Whether to implement over-conservatively with plain OR gates.
	bool opt_conjunctive_gates = false;	     // Whether to implement over-conservatively with plain OR gates.
	bool opt_precise_shiftx = false;	     // Whether to implement precise IFT logic for the shiftx.
	bool opt_imprecise_shl_sshl = false;	     // Whether to implement precise IFT logic for the shl and sshl.
	bool opt_imprecise_shr_sshr = false;	     // Whether to implement precise IFT logic for the shr and sshr.
	bool opt_pmux_use_large_cells = false;	     // pmux instrumentation performance.
	bool opt_data_flow = false; // Propagate taint only via data flows
	unsigned int num_taints = 1;
	std::vector<string> *excluded_signals;

	RTLIL::Module *module = nullptr;
	const RTLIL::IdString cellift_attribute_name = ID(cellift);

	void create_cellift_logic()
	{
		// If cellift has already been applied.
		if (module->get_bool_attribute(cellift_attribute_name)) {
			log("CellIFT has already been applied to module %s. Aborting CellIFT instrumentation.\n", module->name.c_str());
			return;
		}
		if (opt_verbose)
			log("CellIFTing module %s.\n", module->name.c_str());

		std::vector<RTLIL::SigSig> connections(module->connections());

		// Add the new taint I/O connections.
		pool<std::pair<RTLIL::IdString, int>> input_wires_to_add;
		pool<std::pair<RTLIL::IdString, int>> output_wires_to_add;

		// First, create the input and output wires for the taints if they are not excluded.
		for (auto &wire_it : module->wires_) {
			// If this is a module port corresponding to a non-excluded taint signal, then add the corresponding taint signal ports.
			if (wire_it.second->port_input && !is_signal_excluded(excluded_signals, wire_it.first.str())) {
				for (unsigned int taint_id = 0; taint_id < num_taints; taint_id++) {
					input_wires_to_add.insert(
					  std::pair<RTLIL::IdString, int>(get_wire_taint_idstring(wire_it.first, taint_id), wire_it.second->width));
				}
			}
			// All output ports must be augmented (excluded or not).
			if (wire_it.second->port_output && !is_signal_excluded(excluded_signals, wire_it.first.str())) {
				for (unsigned int taint_id = 0; taint_id < num_taints; taint_id++) {
					output_wires_to_add.insert(
					  std::pair<RTLIL::IdString, int>(get_wire_taint_idstring(wire_it.first, taint_id), wire_it.second->width));
				}
			}
		}
		// No need to check for taint signal exclusion here, the filtering has already been made when adding the signals to the
		// *put_wires_to_add pools.
		for (auto &wire_info_it : input_wires_to_add) {
			if (opt_verbose)
				log("New input wire: %s.\n", wire_info_it.first.c_str());
			RTLIL::Wire *w = module->addWire(wire_info_it.first, wire_info_it.second);
			w->port_input = true;
			w->set_bool_attribute(cellift_attribute_name);
		}
		for (auto &wire_info_it : output_wires_to_add) {
			if (opt_verbose)
				log("New output wire: %s.\n", wire_info_it.first.c_str());
			RTLIL::Wire *w = module->addWire(wire_info_it.first, wire_info_it.second);
			w->port_output = true;
			w->set_bool_attribute(cellift_attribute_name);
		}

		// True: the cell will be SUPPLEMENTED by the taint tracking logic.
		// False: the cell will be REPLACED by the taint tracking logic.
		bool keep_current_cell;

		// Structures to make the modifications once the iteration through all the cells is complete.
		std::vector<Yosys::RTLIL::Cell *> original_cells = module->cells().to_vector();
		std::vector<Yosys::RTLIL::Cell *> cells_to_remove;

		// Second, add the logic corresponding to the cells. The input and output ports are supposed to have a width of 1. The corresponding
		// port of the input port is obtained
		for (auto &cell : original_cells) {
			if (opt_verbose)
				log("    CellIFTing %s cell (%s)\n", cell->type.c_str(), cell->name.c_str());

			// By default, do not remove the original cell but supplement it with IFT logic.
			keep_current_cell = true;

			////
			// Latches
			////

			if (cell->type.in(ID($dlatch)))
				keep_current_cell = cellift_dlatch(module, cell, num_taints, excluded_signals);

			else if (cell->type.in(ID($_DLATCH_N_), ID($_DLATCH_P_)))
				keep_current_cell = cellift_dlatch_en(module, cell, num_taints, excluded_signals);

			////
			// Flip-flops
			////

			else if (cell->type.in(ID($dff)))
				keep_current_cell = cellift_dff(module, cell, num_taints, excluded_signals);

			else if (cell->type.in(ID($_DFF_NN0_), ID($_DFF_NN1_), ID($_DFF_NP0_), ID($_DFF_NP1_), ID($_DFF_PN0_), ID($_DFF_PN1_),
					       ID($_DFF_PP0_), ID($_DFF_PP0_)))
				keep_current_cell = cellift_dff_techmap(module, cell, num_taints, excluded_signals);

			else if (cell->type.in(ID($adff)))
				keep_current_cell = cellift_adff(module, cell, num_taints, excluded_signals);

      else if (cell->type.in(ID($aldff)))
				keep_current_cell = cellift_aldff(module, cell, num_taints, excluded_signals, opt_data_flow);

			else if (cell->type.in(ID($sdff)))
				keep_current_cell = cellift_sdff(module, cell, num_taints, excluded_signals);

			else if (cell->type.in(ID($_SDFF_NN0_), ID($_SDFF_NN1_), ID($_SDFF_NP0_), ID($_SDFF_NP1_), ID($_SDFF_PN0_), ID($_SDFF_PN1_),
					       ID($_SDFF_PP0_), ID($_SDFF_PP1_)))
				keep_current_cell = cellift_sdff_techmap(module, cell, num_taints, excluded_signals);

			else if (cell->type.in(ID($adffe)))
				keep_current_cell = cellift_adffe(module, cell, num_taints, excluded_signals, opt_data_flow);

			else if (cell->type.in(ID($sdffe)))
				keep_current_cell = cellift_sdffe(module, cell, num_taints, excluded_signals, opt_data_flow);

			else if (cell->type.in(ID($dffe)))
				keep_current_cell = cellift_dffe(module, cell, num_taints, excluded_signals, opt_data_flow);

			else if (cell->type.in(ID($_DFFE_NN_), ID($_DFFE_NP_), ID($_DFFE_PN_), ID($_DFFE_PP_)))
				keep_current_cell = cellift_dffe_techmap(module, cell, num_taints, excluded_signals, opt_data_flow);

			else if (cell->type.in(ID($sdffce)))
				keep_current_cell = cellift_sdffce(module, cell, num_taints, excluded_signals, opt_data_flow);

			else if (cell->type.in(ID($_SDFFCE_NN0N_), ID($_SDFFCE_NN0P_), ID($_SDFFCE_NN1N_), ID($_SDFFCE_NN1P_), ID($_SDFFCE_NP0N_),
					       ID($_SDFFCE_NP0P_), ID($_SDFFCE_NP1N_), ID($_SDFFCE_NP1P_), ID($_SDFFCE_PN0N_), ID($_SDFFCE_PN0P_),
					       ID($_SDFFCE_PN1N_), ID($_SDFFCE_PN1P_), ID($_SDFFCE_PP0N_), ID($_SDFFCE_PP0P_), ID($_SDFFCE_PP1N_),
					       ID($_SDFFCE_PP1P_)))
				keep_current_cell = cellift_sdffce_techmap(module, cell, num_taints, excluded_signals, opt_data_flow);

			else if (cell->type.in(ID($_SDFFE_NN0N_), ID($_SDFFE_NN0P_), ID($_SDFFE_NN1N_), ID($_SDFFE_NN1P_), ID($_SDFFE_NP0N_),
					       ID($_SDFFE_NP0P_), ID($_SDFFE_NP1N_), ID($_SDFFE_NP1P_), ID($_SDFFE_PN0N_), ID($_SDFFE_PN0P_),
					       ID($_SDFFE_PN1N_), ID($_SDFFE_PN1P_), ID($_SDFFE_PP0N_), ID($_SDFFE_PP0P_), ID($_SDFFE_PP1N_),
					       ID($_SDFFE_PP1P_)))
				keep_current_cell = cellift_sdffe_techmap(module, cell, num_taints, excluded_signals, opt_data_flow);
			else if (cell->type.in(ID($_DFFE_NN0N_), ID($_DFFE_NN0P_), ID($_DFFE_NN1N_), ID($_DFFE_NN1P_), ID($_DFFE_NP0N_),
					       ID($_DFFE_NP0P_), ID($_DFFE_NP1N_), ID($_DFFE_NP1P_), ID($_DFFE_PN0N_), ID($_DFFE_PN0P_),
					       ID($_DFFE_PN1N_), ID($_DFFE_PN1P_), ID($_DFFE_PP0N_), ID($_DFFE_PP0P_), ID($_DFFE_PP1N_),
					       ID($_DFFE_PP1P_)))
				keep_current_cell = cellift_dffe_rst_techmap(module, cell, num_taints, excluded_signals, opt_data_flow);

			else if (cell->type.in(ID($_SDFF_PN0_), ID($_SDFF_PN1_), ID($_SDFF_PP0_)))
				keep_current_cell = cellift_sdff_techmap(module, cell, num_taints, excluded_signals);
			else if (cell->type.in(ID($_DFF_N_), ID($_DFF_P_)))
				keep_current_cell = cellift_dff_simple_techmap(module, cell, num_taints, excluded_signals);

			////
			// Stateless cells
			////

			else if (cell->type.in(ID($add)))
				if (opt_conjunctive_cells_pool.find("add") != opt_conjunctive_cells_pool.end())
					keep_current_cell = cellift_conjunctive_two_inputs(module, cell, num_taints, excluded_signals);
				else if (opt_rtlift)
					keep_current_cell = rtlift_add(module, cell, num_taints, excluded_signals);
				else
					keep_current_cell = cellift_add(module, cell, num_taints, excluded_signals);

			else if (cell->type.in(ID($sub)))
				if (opt_conjunctive_cells_pool.find("sub") != opt_conjunctive_cells_pool.end())
					keep_current_cell = cellift_conjunctive_two_inputs(module, cell, num_taints, excluded_signals);
				else
					keep_current_cell = cellift_sub(module, cell, num_taints, excluded_signals);

			else if (cell->type.in(ID($not), ID($_NOT_)))
				keep_current_cell = cellift_not(module, cell, num_taints, excluded_signals);

			else if (cell->type.in(ID($neg)))
				if (opt_conjunctive_cells_pool.find("neg") != opt_conjunctive_cells_pool.end())
					keep_current_cell = cellift_conjunctive_one_input(module, cell, num_taints, excluded_signals);
				else
					keep_current_cell = cellift_neg(module, cell, num_taints, excluded_signals);

			else if (cell->type.in(ID($and), ID($_AND_), ID($_NAND_)))
				if (opt_conjunctive_cells_pool.find("and") != opt_conjunctive_cells_pool.end() || opt_conjunctive_gates)
					keep_current_cell = cellift_conjunctive_two_inputs(module, cell, num_taints, excluded_signals);
				else
					keep_current_cell = cellift_and(module, cell, num_taints, excluded_signals);

			else if (cell->type.in(ID($or), ID($_OR_), ID($_NOR_)))
				if (opt_conjunctive_cells_pool.find("or") != opt_conjunctive_cells_pool.end() || opt_conjunctive_gates)
					keep_current_cell = cellift_conjunctive_two_inputs(module, cell, num_taints, excluded_signals);
				else
					keep_current_cell = cellift_or(module, cell, num_taints, excluded_signals);

			else if (cell->type.in(ID($pmux)))
				if (!opt_data_flow)
					if (opt_conjunctive_cells_pool.find("pmux") != opt_conjunctive_cells_pool.end())
						keep_current_cell = cellift_conjunctive_three_inputs(module, cell, num_taints, excluded_signals);
					else if (opt_pmux_use_large_cells)
						keep_current_cell = cellift_pmux_large_cells(module, cell, num_taints, excluded_signals);
					else
						keep_current_cell = cellift_pmux_small_cells(module, cell, num_taints, excluded_signals);
				else
					keep_current_cell = cellift_pmux_data_flow(module, cell, num_taints, excluded_signals);

			else if (cell->type.in(ID($mux), ID($_MUX_), ID($_NMUX_)))
				if (opt_conjunctive_cells_pool.find("mux") != opt_conjunctive_cells_pool.end())
					keep_current_cell = cellift_conjunctive_three_inputs(module, cell, num_taints, excluded_signals);
				else
					keep_current_cell = cellift_mux(module, cell, num_taints, excluded_signals, opt_data_flow);

			else if (cell->type.in(ID($xor), ID($xnor), ID($_XOR_), ID($_XNOR_)))
				keep_current_cell = cellift_xor(module, cell, num_taints, excluded_signals);

			else if (cell->type.in(ID($eq), ID($eqx), ID($ne), ID($nex)))
				if (!opt_data_flow)
					if (opt_conjunctive_cells_pool.find("eq-ne") != opt_conjunctive_cells_pool.end())
						keep_current_cell = cellift_conjunctive_two_inputs(module, cell, num_taints, excluded_signals);
					else
						keep_current_cell = cellift_eq_ne(module, cell, num_taints, excluded_signals);
				else
					keep_current_cell = cellift_comp_data_flow(module, cell, num_taints, excluded_signals);

			else if (cell->type.in(ID($ge)))
				if (!opt_data_flow)
					if (opt_conjunctive_cells_pool.find("ge") != opt_conjunctive_cells_pool.end())
						keep_current_cell = cellift_conjunctive_two_inputs(module, cell, num_taints, excluded_signals);
					else
						keep_current_cell = cellift_ge(module, cell, num_taints, excluded_signals);
				else
					keep_current_cell = cellift_comp_data_flow(module, cell, num_taints, excluded_signals);

			else if (cell->type.in(ID($gt)))
				if (!opt_data_flow)
					if (opt_conjunctive_cells_pool.find("gt") != opt_conjunctive_cells_pool.end())
						keep_current_cell = cellift_conjunctive_two_inputs(module, cell, num_taints, excluded_signals);
					else
						keep_current_cell = cellift_gt(module, cell, num_taints, excluded_signals);
				else
					keep_current_cell = cellift_comp_data_flow(module, cell, num_taints, excluded_signals);

			else if (cell->type.in(ID($le)))
				if (!opt_data_flow)
					if (opt_conjunctive_cells_pool.find("le") != opt_conjunctive_cells_pool.end())
						keep_current_cell = cellift_conjunctive_two_inputs(module, cell, num_taints, excluded_signals);
					else
						keep_current_cell = cellift_le(module, cell, num_taints, excluded_signals);
				else
					keep_current_cell = cellift_comp_data_flow(module, cell, num_taints, excluded_signals);

			else if (cell->type.in(ID($lt)))
				if (!opt_data_flow)
					if (opt_conjunctive_cells_pool.find("lt") != opt_conjunctive_cells_pool.end())
						keep_current_cell = cellift_conjunctive_two_inputs(module, cell, num_taints, excluded_signals);
					else
						keep_current_cell = cellift_lt(module, cell, num_taints, excluded_signals);
				else
					keep_current_cell = cellift_comp_data_flow(module, cell, num_taints, excluded_signals);

			else if (cell->type.in(ID($logic_and)))
				if (!opt_data_flow)
					if (opt_conjunctive_cells_pool.find("logic-and") != opt_conjunctive_cells_pool.end())
						keep_current_cell = cellift_conjunctive_two_inputs(module, cell, num_taints, excluded_signals);
					else
						keep_current_cell = cellift_logic_and(module, cell, num_taints, excluded_signals);
				else
					keep_current_cell = cellift_comp_data_flow(module, cell, num_taints, excluded_signals);

			else if (cell->type.in(ID($logic_or)))
				if (!opt_data_flow)
					if (opt_conjunctive_cells_pool.find("logic-or") != opt_conjunctive_cells_pool.end())
						keep_current_cell = cellift_conjunctive_two_inputs(module, cell, num_taints, excluded_signals);
					else
						keep_current_cell = cellift_logic_or(module, cell, num_taints, excluded_signals);
				else
					keep_current_cell = cellift_comp_data_flow(module, cell, num_taints, excluded_signals);

			else if (cell->type.in(ID($logic_not), ID($reduce_or), ID($reduce_bool)))
				if (!opt_data_flow)
					if (opt_conjunctive_cells_pool.find("logic-not") != opt_conjunctive_cells_pool.end())
						keep_current_cell = cellift_conjunctive_one_input(module, cell, num_taints, excluded_signals);
					else
						keep_current_cell = cellift_logic_not(module, cell, num_taints, excluded_signals);
				else
					keep_current_cell = cellift_reduce_data_flow(module, cell, num_taints, excluded_signals);

			else if (cell->type.in(ID($reduce_and)))
				if (!opt_data_flow)
					if (opt_conjunctive_cells_pool.find("reduce-and") != opt_conjunctive_cells_pool.end())
						keep_current_cell = cellift_conjunctive_one_input(module, cell, num_taints, excluded_signals);
					else
						keep_current_cell = cellift_reduce_and(module, cell, num_taints, excluded_signals);
				else
					keep_current_cell = cellift_reduce_data_flow(module, cell, num_taints, excluded_signals);

			else if (cell->type.in(ID($reduce_xor)))
				if (!opt_data_flow)
					keep_current_cell = cellift_reduce_xor(module, cell, num_taints, excluded_signals);
				else
					keep_current_cell = cellift_reduce_data_flow(module, cell, num_taints, excluded_signals);

			else if (cell->type.in(ID($shl), ID($sshl)))
				if (!opt_data_flow)
					if (opt_conjunctive_cells_pool.find("shl-sshl") != opt_conjunctive_cells_pool.end())
						keep_current_cell = cellift_conjunctive_two_inputs(module, cell, num_taints, excluded_signals);
					else if (opt_imprecise_shl_sshl)
						keep_current_cell = cellift_shl_sshl_imprecise(module, cell, num_taints, excluded_signals);
					else
						keep_current_cell = cellift_shl_sshl_precise(module, cell, num_taints, excluded_signals);
				else
						keep_current_cell = cellift_shl_sshl_data_flow(module, cell, num_taints, excluded_signals);

			else if (cell->type.in(ID($shr)))
				if (!opt_data_flow)
					if (opt_conjunctive_cells_pool.find("shr") != opt_conjunctive_cells_pool.end())
						keep_current_cell = cellift_conjunctive_two_inputs(module, cell, num_taints, excluded_signals);
					else if (opt_imprecise_shr_sshr)
						keep_current_cell = cellift_shr_sshr_imprecise(module, cell, num_taints, excluded_signals);
					else
						keep_current_cell = cellift_shr(module, cell, num_taints, excluded_signals);
				else
						keep_current_cell = cellift_shr_sshr_data_flow(module, cell, num_taints, excluded_signals);

			else if (cell->type.in(ID($sshr)))
				if (!opt_data_flow)
					if (opt_conjunctive_cells_pool.find("sshr") != opt_conjunctive_cells_pool.end())
						keep_current_cell = cellift_conjunctive_two_inputs(module, cell, num_taints, excluded_signals);
					else if (opt_imprecise_shr_sshr)
						keep_current_cell = cellift_shr_sshr_imprecise(module, cell, num_taints, excluded_signals);
					else
						keep_current_cell = cellift_sshr(module, cell, num_taints, excluded_signals);
				else
						keep_current_cell = cellift_shr_sshr_data_flow(module, cell, num_taints, excluded_signals);

			else if ((cell->type.in(ID($shift),ID($shiftx)) && opt_data_flow))
				keep_current_cell = cellift_shift_data_flow(module, cell, num_taints, excluded_signals);

			else if ((cell->type.in(ID($shift)) && opt_precise_shiftx) || (cell->type.in(ID($shiftx)) && opt_precise_shiftx))
				if (opt_conjunctive_cells_pool.find("shift-shiftx") != opt_conjunctive_cells_pool.end())
					keep_current_cell = cellift_conjunctive_two_inputs(module, cell, num_taints, excluded_signals);
				else
					keep_current_cell = cellift_shift_shiftx_precise(module, cell, num_taints, excluded_signals);

			else if (cell->type.in(ID($shiftx)) && !opt_precise_shiftx)
				if (opt_conjunctive_cells_pool.find("shift-shiftx") != opt_conjunctive_cells_pool.end())
					keep_current_cell = cellift_conjunctive_two_inputs(module, cell, num_taints, excluded_signals);
				else
					keep_current_cell = cellift_shiftx_imprecise(module, cell, num_taints, excluded_signals);

			else if (cell->type.in(ID($shift)) && !opt_precise_shiftx)
				if (opt_conjunctive_cells_pool.find("shift-shiftx") != opt_conjunctive_cells_pool.end())
					keep_current_cell = cellift_conjunctive_two_inputs(module, cell, num_taints, excluded_signals);
				else
					keep_current_cell = cellift_shift_imprecise(module, cell, num_taints, excluded_signals);

			else if (cell->type.in(ID($mod)))
				if (!opt_data_flow)
					if (opt_conjunctive_cells_pool.find("mod") != opt_conjunctive_cells_pool.end())
						keep_current_cell = cellift_conjunctive_two_inputs(module, cell, num_taints, excluded_signals);
					else
						keep_current_cell = cellift_mod(module, cell, num_taints, excluded_signals);
				else
					keep_current_cell = cellift_comp_data_flow(module, cell, num_taints, excluded_signals);

			else if (cell->type.in(ID($mul)))
				if (opt_conjunctive_cells_pool.find("mul") != opt_conjunctive_cells_pool.end())
					keep_current_cell = cellift_conjunctive_two_inputs(module, cell, num_taints, excluded_signals);
				else
					keep_current_cell = cellift_mul(module, cell, num_taints, excluded_signals);

			else if (module->design->module(cell->type) != nullptr) {
				// User cell type

				dict<RTLIL::IdString, RTLIL::SigSpec> orig_ports = cell->connections();
				for (auto &it : orig_ports) {
					RTLIL::SigSpec connected_sig = it.second;

					// Not the IFT-excluded signals.
					if (is_signal_excluded(excluded_signals, it.first.str()) ||
					    (it.second.is_wire() && is_signal_excluded(excluded_signals, it.second.as_wire()->name.str())))
						continue;

					std::vector<RTLIL::SigSpec> port_taints =
					  get_corresponding_taint_signals(module, excluded_signals, connected_sig, num_taints);
					for (unsigned int taint_id = 0; taint_id < num_taints; taint_id++) {
						cell->setPort(get_wire_taint_idstring(it.first.c_str(), taint_id), port_taints[taint_id]);
					}
				}
			} else
				log_cmd_error("Cell type not supported: %s. Consider running techmap or creating your own IFT implementation.\n",
					      cell->type.c_str());

			if (!keep_current_cell)
				cells_to_remove.push_back(cell);
		} // end foreach cell in cells

		// Remove the cells that are replaced by the IFT compound.
		for (RTLIL::Cell *cell_to_remove : cells_to_remove)
			module->remove(cell_to_remove);

		if (module->processes.size())
			log_error("Unexpected process. Cellift requires a `proc` pass before.\n");

		// For all original connections, also connect the corresponding taints.
		for (auto &conn : connections) {
			log_assert(conn.first.size() == conn.second.size());

			std::vector<RTLIL::SigSpec> first = get_corresponding_taint_signals(module, excluded_signals, conn.first, num_taints);
			std::vector<RTLIL::SigSpec> second = get_corresponding_taint_signals(module, excluded_signals, conn.second, num_taints);

			for (unsigned int taint_id = 0; taint_id < num_taints; taint_id++)
				module->connect(first[taint_id], second[taint_id]);
		}

		module->fixup_ports();
		module->set_bool_attribute(cellift_attribute_name, true);
	}

      public:
	CellIFTWorker(RTLIL::Module *_module, bool _opt_verbose, bool _opt_rtlift, bool _opt_conjunctive_gates,
		      pool<string> _opt_conjunctive_cells_pool, bool _opt_precise_shiftx, bool _opt_imprecise_shl_sshl, bool _opt_imprecise_shr_sshr,
		      bool _opt_pmux_use_large_cells, bool _opt_data_flow, int unsigned _num_taints,
		      std::vector<string> *_excluded_signals)
	{
		module = _module;
		opt_verbose = _opt_verbose;
		opt_rtlift = _opt_rtlift;
		opt_conjunctive_gates = _opt_conjunctive_gates;
		opt_conjunctive_cells_pool = _opt_conjunctive_cells_pool;
		opt_precise_shiftx = _opt_precise_shiftx;
		opt_imprecise_shl_sshl = _opt_imprecise_shl_sshl;
		opt_imprecise_shr_sshr = _opt_imprecise_shr_sshr;
		opt_pmux_use_large_cells = _opt_pmux_use_large_cells;
		opt_data_flow = _opt_data_flow;
		num_taints = _num_taints;
		excluded_signals = _excluded_signals;

		create_cellift_logic();
	}
};

struct CelliftPass : public Pass {
	CelliftPass() : Pass("cellift", "instrument modules using the CellIFT mechanism.") {}

	void help() override
	{
		//   |---v---|---v---|---v---|---v---|---v---|---v---|---v---|---v---|---v---|---v---|
		log("\n");
		log("    cellift <command> [options] [selection]\n");
		log("\n");
		log("Instruments the selected design with CellIFT.\n");
		log("All processes must be broken down into cells, for instance using the built-in yosys command: `proc`.\n");
		log("All $pmux cells must be broken down into $mux cells, for instance using the built-in yosys command: `pmuxtree`.\n");
		log("Multipliers are implemented using a single OR reduction.\n");
		log("\n");
		log("Options:\n");
		log("\n");
		log("  -num-distinct-labels\n");
		log("    The number of distinct available labels. Each new label reproduces the taint \n");
		log("    propagation logic and storage one more time. Default: 1.\n");
		log("\n");
		log("  -rtlift\n");
		log("    Use the RTLIFT-style adders.\n");
		log("    CellIFT-style adders are equally precise but faster in simulation and result in a simpler model than RTLIFT.\n");
		log("\n");
		log("  -conjunctive-gates\n");
		log("    Use an OR cells of all inputs for elementary logic gates (AND and OR). Equivalent to: -conjunctive-and -conjunctive-or\n");
		log("\n");
		log("  -verbose\n");
		log("    Verbose mode.\n");
		log("\n");
		log("  -exclude-signals\n");
		log("    Exclude a list of signal names from the IFT. Typically, this comprises clock and reset signals.\n");
		log("    The list must be comma-separated and must contain no space.\n");
		log("    Example: -exclude-signals clk_i,rst_ni\n");
		log("\n");
		log("  -precise-shiftx\n");
		log("    Implement precise IFT logic for the shift and shiftx cells. This is expensive.\n");
		log("\n");
		log("  -imprecise-shl-sshl\n");
		log("    Implement imprecise IFT logic for the shl and sshl cells..\n");
		log("\n");
		log("  -pmux-use-large-cells\n");
		log("    For pmux instrumentation performance purposes.\n");
		log("\n");
		log("  -data-flow\n");
		log("    Track data flows, block all taint flows via control paths.\n");
		log("\n");
		log("  -conjunctive-and\n");
		log("  -conjunctive-or\n");
		log("  -conjunctive-add\n");
		log("  -conjunctive-sub\n");
		log("  -conjunctive-not\n");
		log("  -conjunctive-neg\n");
		log("  -conjunctive-and\n");
		log("  -conjunctive-or\n");
		log("  -conjunctive-mul\n");
		log("  -conjunctive-pmux\n");
		log("  -conjunctive-mod\n");
		log("  -conjunctive-mux\n");
		log("  -conjunctive-eq-ne\n");
		log("  -conjunctive-ge\n");
		log("  -conjunctive-gt\n");
		log("  -conjunctive-le\n");
		log("  -conjunctive-lt\n");
		log("  -conjunctive-logic-and\n");
		log("  -conjunctive-logic-or\n");
		log("  -conjunctive-logic-not\n");
		log("  -conjunctive-reduce-and\n");
		log("  -conjunctive-shl-sshl\n");
		log("  -conjunctive-shr\n");
		log("  -conjunctive-sshr\n");
		log("  -conjunctive-shift-shiftx\n");
		log("    Implement each cell with a simple OR reduction.\n");
		log("\n");
	}

	void execute(std::vector<std::string> args, RTLIL::Design *design) override
	{
		bool opt_verbose = false;
		bool opt_rtlift = false;
		bool opt_conjunctive_gates = false;
		pool<string> opt_conjunctive_cells_pool;
		bool opt_precise_shiftx = false;
		bool opt_imprecise_shl_sshl = false;
		bool opt_imprecise_shr_sshr = false;
		bool opt_pmux_use_large_cells = false;
		bool opt_data_flow = false;
		string opt_excluded_signals_csv;
		std::vector<string> opt_excluded_signals;

		int unsigned num_taints = 1;
		log_header(design, "Executing CellIFT pass.\n");
		std::vector<std::string>::size_type argidx;

		for (argidx = 1; argidx < args.size(); argidx++) {
			if (args[argidx] == "-num-distinct-labels") {
				num_taints = std::stoi(args[++argidx]);
				continue;
			}
			if (args[argidx] == "-verbose") {
				opt_verbose = true;
				continue;
			}
			if (args[argidx] == "-rtlift") {
				opt_rtlift = true;
				continue;
			}
			if (args[argidx] == "-conjunctive-gates") {
				opt_conjunctive_gates = true;
				continue;
			}
			if (args[argidx] == "-exclude-signals") {
				opt_excluded_signals_csv = args[++argidx];
				continue;
			}
			if (args[argidx] == "-precise-shiftx") {
				opt_precise_shiftx = true;
				continue;
			}
			if (args[argidx] == "-imprecise-shl-sshl") {
				opt_imprecise_shl_sshl = true;
				continue;
			}
			if (args[argidx] == "-imprecise-shr-sshr") {
				opt_imprecise_shr_sshr = true;
				continue;
			}
			if (args[argidx] == "-pmux-use-large-cells") {
				opt_pmux_use_large_cells = true;
				continue;
			}
			if (args[argidx] == "-data-flow") {
				opt_data_flow = true;
				continue;
			}
			if (args[argidx] == "-conjunctive-and") {
				opt_conjunctive_cells_pool.insert("and");
				continue;
			}
			if (args[argidx] == "-conjunctive-or") {
				opt_conjunctive_cells_pool.insert("or");
				continue;
			}
			if (args[argidx] == "-conjunctive-add") {
				opt_conjunctive_cells_pool.insert("add");
				continue;
			}
			if (args[argidx] == "-conjunctive-sub") {
				opt_conjunctive_cells_pool.insert("sub");
				continue;
			}
			if (args[argidx] == "-conjunctive-not") {
				opt_conjunctive_cells_pool.insert("not");
				continue;
			}
			if (args[argidx] == "-conjunctive-neg") {
				opt_conjunctive_cells_pool.insert("neg");
				continue;
			}
			if (args[argidx] == "-conjunctive-and") {
				opt_conjunctive_cells_pool.insert("and");
				continue;
			}
			if (args[argidx] == "-conjunctive-or") {
				opt_conjunctive_cells_pool.insert("or");
				continue;
			}
			if (args[argidx] == "-conjunctive-mul") {
				opt_conjunctive_cells_pool.insert("mul");
				continue;
			}
			if (args[argidx] == "-conjunctive-pmux") {
				opt_conjunctive_cells_pool.insert("pmux");
				continue;
			}
			if (args[argidx] == "-conjunctive-mux") {
				opt_conjunctive_cells_pool.insert("mux");
				continue;
			}
			if (args[argidx] == "-conjunctive-eq-ne") {
				opt_conjunctive_cells_pool.insert("eq-ne");
				continue;
			}
			if (args[argidx] == "-conjunctive-ge") {
				opt_conjunctive_cells_pool.insert("ge");
				continue;
			}
			if (args[argidx] == "-conjunctive-gt") {
				opt_conjunctive_cells_pool.insert("gt");
				continue;
			}
			if (args[argidx] == "-conjunctive-le") {
				opt_conjunctive_cells_pool.insert("le");
				continue;
			}
			if (args[argidx] == "-conjunctive-lt") {
				opt_conjunctive_cells_pool.insert("lt");
				continue;
			}
			if (args[argidx] == "-conjunctive-logic-and") {
				opt_conjunctive_cells_pool.insert("logic-and");
				continue;
			}
			if (args[argidx] == "-conjunctive-logic-or") {
				opt_conjunctive_cells_pool.insert("logic-or");
				continue;
			}
			if (args[argidx] == "-conjunctive-logic-not") {
				opt_conjunctive_cells_pool.insert("logic-not");
				continue;
			}
			if (args[argidx] == "-conjunctive-reduce-and") {
				opt_conjunctive_cells_pool.insert("reduce-and");
				continue;
			}
			if (args[argidx] == "-conjunctive-shl-sshl") {
				opt_conjunctive_cells_pool.insert("shl-sshl");
				continue;
			}
			if (args[argidx] == "-conjunctive-shr") {
				opt_conjunctive_cells_pool.insert("shr");
				continue;
			}
			if (args[argidx] == "-conjunctive-sshr") {
				opt_conjunctive_cells_pool.insert("sshr");
				continue;
			}
			if (args[argidx] == "-conjunctive-shift-shiftx") {
				opt_conjunctive_cells_pool.insert("shift-shiftx");
				continue;
			}
			break;
		}
		extra_args(args, argidx, design);

		// Check whether some module is selected.
		if (GetSize(design->selected_modules()) == 0)
			log_cmd_error("CellIFT cannot operate on an empty.\n");

		// Modules must be taken in inverted topological order to instrument the deepest modules first.
		// Taken from passes/techmap/flatten.cc
		TopoSort<RTLIL::Module *, IdString::compare_ptr_by_name<RTLIL::Module>> topo_modules;
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
			log_cmd_error("Recursive modules are not supported by CellIFT.\n");

		// Parse the excluded signals.
		if (opt_excluded_signals_csv.size()) {
			char delimiter = ',';
			int csv_start = 0;
			int end = opt_excluded_signals_csv.find(delimiter);
			while (end != -1) {
				opt_excluded_signals.push_back(opt_excluded_signals_csv.substr(csv_start, end - csv_start));
				csv_start = end + 1;
				end = opt_excluded_signals_csv.find(delimiter, csv_start);
			}
			opt_excluded_signals.push_back(opt_excluded_signals_csv.substr(csv_start, end - csv_start));
		} else if (opt_verbose)
			log("No -exclude-signals has been provided. \n");

		// Run the worker on each module.
		for (auto i = 0; i < GetSize(topo_modules.sorted); ++i) {
			RTLIL::Module *module = topo_modules.sorted[i];
			CellIFTWorker(module, opt_verbose, opt_rtlift, opt_conjunctive_gates, opt_conjunctive_cells_pool, opt_precise_shiftx,
				      opt_imprecise_shl_sshl, opt_imprecise_shr_sshr, opt_pmux_use_large_cells, opt_data_flow,
				      num_taints, &opt_excluded_signals);
		}
	}
} CelliftPass;

PRIVATE_NAMESPACE_END
