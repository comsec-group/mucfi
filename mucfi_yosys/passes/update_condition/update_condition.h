#ifndef UPDATE_CONDITION_H
#define UPDATE_CONDITION_H

#include "kernel/rtlil.h"
#include "kernel/utils.h"
#include "kernel/log.h"
#include "kernel/yosys.h"

USING_YOSYS_NAMESPACE


namespace UpdateCondition {

typedef std::vector<RTLIL::IdString> visited_signals_t;
#define TMP_DEF_VISITED_STATE "\\uc_state_visited"

void log_cmd_error_lineinfo(const char *err_msg, ...);
void set_past_attribute(RTLIL::SigSpec &sig);
RTLIL::Cell *get_curr_instance_cell(std::vector<RTLIL::Cell *> cell_hierarchy);
RTLIL::Cell *pop_curr_instance_cell(std::vector<RTLIL::Cell *> cell_hierarchy);
std::vector<RTLIL::Cell *> find_driving_cell(std::vector<RTLIL::Cell *> cells, RTLIL::IdString signal_name);
// Determine whether a cell is a state element based on its driving cell (if any).
bool is_state_element(RTLIL::Module *module, RTLIL::IdString signal_name);
RTLIL::Cell *find_memwr_cell(RTLIL::Cell *memrd_cell);
RTLIL::SigSpec create_observing_wire(RTLIL::Module *module, RTLIL::SigSpec observed_sig,
																	   std::vector<IdString> bool_attributes);
// Updates visited signals and returns false if signal_name is already in visited_signals.
bool update_visited_signals(visited_signals_t &visited_signals, RTLIL::IdString signal_name);

// Generates the update condition logic for signal `signal_name` in current module instantiation represented by `curr_instance_cell`.
// If a chunk is within the `visited_signals` or within the `excluded_signals` list, it's update condition is not generated and 0 is used instead.
// If it is a constant, 1 is returned.
RTLIL::SigSpec create_uc_logic(RTLIL::Design *design, std::vector<RTLIL::Cell *> cell_hierarchy, RTLIL::Cell *curr_instance_cell, RTLIL::Wire *start_sig, visited_signals_t &visited_signals, std::vector<string> *excluded_signals, std::vector<string> *read_from_signals);
RTLIL::SigSpec _create_uc_logic(RTLIL::Design *design, std::vector<RTLIL::Cell *> cell_hierarchy, RTLIL::Cell *curr_instance_cell, RTLIL::Wire *start_sig, visited_signals_t &visited_signals, std::vector<string> *excluded_signals, std::vector<string> *read_from_signals);
RTLIL::SigSpec create_cell_uc_logic(RTLIL::Design *design, std::vector<RTLIL::Cell *> cell_hierarchy, RTLIL::Cell *cell, visited_signals_t &visited_signals, std::vector<string> *excluded_signals, std::vector<string> *read_from_signals);
// Returns the update condition of a cell's port
// It or's the update conditions of the chunks of the port
RTLIL::SigSpec uc_cell_port(RTLIL::Design *design, std::vector<RTLIL::Cell *> cell_hierarchy, RTLIL::Cell *cell, RTLIL::IdString port_name, visited_signals_t &visited_signals, std::vector<string> *excluded_signals, std::vector<string> *read_from_signals);

// Returns constant 0 in case the read_from_signals list is not empty, because a cell is not a direct assignment from a signal in read_from_signals.
// Otherwise, returns constant 1, because a cell is not a direct self-assignment.
RTLIL::SigSpec uc_comb_two_input_cell(RTLIL::Design *design, std::vector<RTLIL::Cell *> cell_hierarchy, RTLIL::Cell *cell, visited_signals_t &visited_signals,std::vector<string> *excluded_signals, std::vector<string> *read_from_signals);
RTLIL::SigSpec uc_comb_one_input_cell(RTLIL::Design *design, std::vector<RTLIL::Cell *> cell_hierarchy, RTLIL::Cell *cell, visited_signals_t &visited_signals,std::vector<string> *excluded_signals, std::vector<string> *read_from_signals);

// Determines the return value for state elements if no more state elements should be examined, which is after
// the fist one in case that the start signal was a state element, or always if the start signal was not a state element.
std::tuple<bool, RTLIL::SigSpec> already_visited_a_state_element(RTLIL::Cell *cell,visited_signals_t &visited_signals, std::vector<string> *excluded_signals, std::vector<string> *read_from_signals);
RTLIL::SigSpec uc_dff(RTLIL::Design *design, std::vector<RTLIL::Cell *> cell_hierarchy, RTLIL::Cell *cell, visited_signals_t &visited_signals, std::vector<string> *excluded_signals, std::vector<string> *read_from_signals);
RTLIL::SigSpec uc_sdff(RTLIL::Design *design, std::vector<RTLIL::Cell *> cell_hierarchy, RTLIL::Cell *cell, visited_signals_t &visited_signals, std::vector<string> *excluded_signals, std::vector<string> *read_from_signals);
RTLIL::SigSpec uc_adff(RTLIL::Design *design, std::vector<RTLIL::Cell *> cell_hierarchy, RTLIL::Cell *cell, visited_signals_t &visited_signals, std::vector<string> *excluded_signals, std::vector<string> *read_from_signals);
RTLIL::SigSpec uc_sdffe(RTLIL::Design *design, std::vector<RTLIL::Cell *> cell_hierarchy, RTLIL::Cell *cell, visited_signals_t &visited_signals, std::vector<string> *excluded_signals, std::vector<string> *read_from_signals);
RTLIL::SigSpec uc_adffe(RTLIL::Design *design, std::vector<RTLIL::Cell *> cell_hierarchy, RTLIL::Cell *cell, visited_signals_t &visited_signals, std::vector<string> *excluded_signals, std::vector<string> *read_from_signals);
RTLIL::SigSpec uc_dffe(RTLIL::Design *design, std::vector<RTLIL::Cell *> cell_hierarchy, RTLIL::Cell *cell, visited_signals_t &visited_signals, std::vector<string> *excluded_signals, std::vector<string> *read_from_signals);
RTLIL::SigSpec uc_dffe_n(RTLIL::Design *design, std::vector<RTLIL::Cell *> cell_hierarchy, RTLIL::Cell *cell, visited_signals_t &visited_signals, std::vector<string> *excluded_signals, std::vector<string> *read_from_signals);

// uc of mux = S && uc_B || !S && uc_A
RTLIL::SigSpec uc_mux(RTLIL::Design *design, std::vector<RTLIL::Cell *> cell_hierarchy, RTLIL::Cell *cell, visited_signals_t &visited_signals, std::vector<string> *excluded_signals, std::vector<string> *read_from_signals);

// This function is not tested and not complete
RTLIL::SigSpec uc_memrd(RTLIL::Design *design, std::vector<RTLIL::Cell *> cell_hierarchy, RTLIL::Cell *cell, visited_signals_t &visited_signals, std::vector<string> *excluded_signals, std::vector<string> *read_from_signals);

void log_uc_cond(char *msg, ...);
} // UpdateCondition

#endif // UPDATE_CONDITION_H
