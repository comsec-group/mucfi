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

struct AddAttrsToStateElemsWorker {
private:
	bool opt_exclude_latches;

	const std::string add_attrs_to_state_elems_attr_name = ID(add_attrs_to_state_elems).str();

	#define NUM_FF_CELL_TYPES 105
	const std::string ff_cell_types[NUM_FF_CELL_TYPES] = { "$_DFFE_NN0N_",
		"$_DFFE_NN0P_",
		"$_DFFE_NN1N_",
		"$_DFFE_NN1P_",
		"$_DFFE_NN_",
		"$_DFFE_NP0N_",
		"$_DFFE_NP0P_",
		"$_DFFE_NP1N_",
		"$_DFFE_NP1P_",
		"$_DFFE_NP_",
		"$_DFFE_PN0N_",
		"$_DFFE_PN0P_",
		"$_DFFE_PN1N_",
		"$_DFFE_PN1P_",
		"$_DFFE_PN_",
		"$_DFFE_PP0N_",
		"$_DFFE_PP0P_",
		"$_DFFE_PP1N_",
		"$_DFFE_PP1P_",
		"$_DFFE_PP_",
		"$_DFFSRE_NNNN_",
		"$_DFFSRE_NNNP_",
		"$_DFFSRE_NNPN_",
		"$_DFFSRE_NNPP_",
		"$_DFFSRE_NPNN_",
		"$_DFFSRE_NPNP_",
		"$_DFFSRE_NPPN_",
		"$_DFFSRE_NPPP_",
		"$_DFFSRE_PNNN_",
		"$_DFFSRE_PNNP_",
		"$_DFFSRE_PNPN_",
		"$_DFFSRE_PNPP_",
		"$_DFFSRE_PPNN_",
		"$_DFFSRE_PPNP_",
		"$_DFFSRE_PPPN_",
		"$_DFFSRE_PPPP_",
		"$_DFFSR_NNN_",
		"$_DFFSR_NNP_",
		"$_DFFSR_NPN_",
		"$_DFFSR_NPP_",
		"$_DFFSR_PNN_",
		"$_DFFSR_PNP_",
		"$_DFFSR_PPN_",
		"$_DFFSR_PPP_",
		"$_DFF_NN0_",
		"$_DFF_NN1_",
		"$_DFF_NP0_",
		"$_DFF_NP1_",
		"$_DFF_N_",
		"$_DFF_PN0_",
		"$_DFF_PN1_",
		"$_DFF_PP0_",
		"$_DFF_PP1_",
		"$_DFF_P_",
		"$_FF_",
		"$_SDFFCE_NN0N_",
		"$_SDFFCE_NN0P_",
		"$_SDFFCE_NN1N_",
		"$_SDFFCE_NN1P_",
		"$_SDFFCE_NP0N_",
		"$_SDFFCE_NP0P_",
		"$_SDFFCE_NP1N_",
		"$_SDFFCE_NP1P_",
		"$_SDFFCE_PN0N_",
		"$_SDFFCE_PN0P_",
		"$_SDFFCE_PN1N_",
		"$_SDFFCE_PN1P_",
		"$_SDFFCE_PP0N_",
		"$_SDFFCE_PP0P_",
		"$_SDFFCE_PP1N_",
		"$_SDFFCE_PP1P_",
		"$_SDFFE_NN0N_",
		"$_SDFFE_NN0P_",
		"$_SDFFE_NN1N_",
		"$_SDFFE_NN1P_",
		"$_SDFFE_NP0N_",
		"$_SDFFE_NP0P_",
		"$_SDFFE_NP1N_",
		"$_SDFFE_NP1P_",
		"$_SDFFE_PN0N_",
		"$_SDFFE_PN0P_",
		"$_SDFFE_PN1N_",
		"$_SDFFE_PN1P_",
		"$_SDFFE_PP0N_",
		"$_SDFFE_PP0P_",
		"$_SDFFE_PP1N_",
		"$_SDFFE_PP1P_",
		"$_SDFF_NN0_",
		"$_SDFF_NN1_",
		"$_SDFF_NP0_",
		"$_SDFF_NP1_",
		"$_SDFF_PN0_",
		"$_SDFF_PN1_",
		"$_SDFF_PP0_",
		"$_SDFF_PP1_",
		"$adff",
		"$adffe",
		"$dff",
		"$dffe",
		"$dffsr",
		"$dffsre",
		"$ff",
		"$sdff",
		"$sdffce",
		"$sdffe"
	};

	#define NUM_LATCH_CELL_TYPES 25
	const std::string latch_cell_types[NUM_LATCH_CELL_TYPES] = { "$_DLATCHSR_NNN_",
		"$_DLATCHSR_NNP_",
		"$_DLATCHSR_NPN_",
		"$_DLATCHSR_NPP_",
		"$_DLATCHSR_PNN_",
		"$_DLATCHSR_PNP_",
		"$_DLATCHSR_PPN_",
		"$_DLATCHSR_PPP_",
		"$_DLATCH_NN0_",
		"$_DLATCH_NN1_",
		"$_DLATCH_NP0_",
		"$_DLATCH_NP1_",
		"$_DLATCH_N_",
		"$_DLATCH_PN0_",
		"$_DLATCH_PN1_",
		"$_DLATCH_PP0_",
		"$_DLATCH_PP1_",
		"$_DLATCH_P_",
		"$_SR_NN_",
		"$_SR_NP_",
		"$_SR_PN_",
		"$_SR_PP_",
		"$adlatch",
		"$dlatch",
		"$dlatchsr"
	};

	/////////////////////////////
	// Main recursive function //
	/////////////////////////////

	/**
	 * @param module the current module.
	 */
	void add_attrs_to_state_elems (RTLIL::Module *module) {
		for (RTLIL::Cell *cell: module->cells()) {
			RTLIL::Module *submodule = module->design->module(cell->type);
			// If this is an elementary cell.
			if (submodule == nullptr) {
				string cell_type = cell->type.str();

				// Check whether this is a state holding element
				bool is_state_holding_element = false;
				for (size_t cell_type_id = 0; cell_type_id < NUM_FF_CELL_TYPES; cell_type_id++) {
					if (ff_cell_types[cell_type_id] == cell_type) {
						is_state_holding_element = true;
						break;
					}
				}

				if (!is_state_holding_element && !opt_exclude_latches) {
					for (size_t cell_type_id = 0; cell_type_id < NUM_LATCH_CELL_TYPES; cell_type_id++) {
						if (latch_cell_types[cell_type_id] == cell_type) {
							is_state_holding_element = true;
							break;
						}
					}
				}

				// If this cell is a state holding element, then add the attribute to its output. Else, continue.
				if (!is_state_holding_element)
					continue;

				// State output may have different names (usually Q).
				RTLIL::IdString out_port_name;
				if (cell->hasPort(ID(Y)))
					out_port_name = ID(Y);
				else
					out_port_name = ID(Q);

				RTLIL::SigSpec out_port(cell->getPort(out_port_name));

				// For each chunk in the output sigspec, create a new output.
				for (auto &chunk_it: out_port.chunks()) {
					if (!chunk_it.is_wire())
						continue;

					chunk_it.wire->set_string_attribute(ID(verilator_public), "1");
				}

			} else {
				// If this is a submodule, then apply the statistics function recursively.
				add_attrs_to_state_elems(submodule);
			}
		}
	}

public:
	AddAttrsToStateElemsWorker(RTLIL::Module *top_module, bool _opt_exclude_latches) {
		opt_exclude_latches = _opt_exclude_latches;

		add_attrs_to_state_elems(top_module);
	}
};

struct AddAttrsToStateElemsPass : public Pass {
	AddAttrsToStateElemsPass() : Pass("add_attrs_to_state_elems", "Adds the `verilator public` attribute to all outputs of state elements.") {}

	void help() override
	{
		//   |---v---|---v---|---v---|---v---|---v---|---v---|---v---|---v---|---v---|---v---|
		log("\n");
		log("    add_attrs_to_state_elems <command> [options] [selection]\n");
		log("\n");
		log("        Adds the `verilator public` attribute to all outputs of state elements.\n");
		log("\n");
		log("    -exclude-latches\n");
		log("        Exclude latches from enumeration.\n");
		log("\n");
	}

	void execute(std::vector<std::string> args, RTLIL::Design *design) override
	{
		bool opt_exclude_latches = false;

		std::vector<std::string>::size_type argidx;
		for (argidx = 1; argidx < args.size(); argidx++) {
			if (args[argidx] == "-exclude-latches") {
				opt_exclude_latches = true;
				continue;
			}
		}

		if (GetSize(design->selected_modules()) == 0)
			log_cmd_error("Can't operate on an empty selection!\n");

		AddAttrsToStateElemsWorker worker(design->top_module(), opt_exclude_latches);
	}
} AddAttrsToStateElemsPass;

PRIVATE_NAMESPACE_END
