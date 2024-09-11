#include "kernel/rtlil.h"
#include "kernel/utils.h"
#include "kernel/log.h"
#include "kernel/yosys.h"
#include "passes/update_condition/update_condition.h"

USING_YOSYS_NAMESPACE

namespace UpdateCondition {

/**
 * @param module the current module instance
 * @param cell the current cell instance
 */
RTLIL::SigSpec uc_comb_two_input_cell(RTLIL::Design *design, std::vector<RTLIL::Cell *> cell_hierarchy, RTLIL::Cell *cell, visited_signals_t &visited_signals, std::vector<string> *excluded_signals, std::vector<string> *read_from_signals) {
    if ((*read_from_signals).size() > 0) {
        log_uc_cond("UC_COND: cell 0 \n");
        return RTLIL::SigBit(RTLIL::State::S0);
    }
    log_uc_cond("UC_COND: cell 1 \n");
    return RTLIL::SigBit(RTLIL::State::S1);
}

RTLIL::SigSpec uc_comb_one_input_cell(RTLIL::Design *design, std::vector<RTLIL::Cell *> cell_hierarchy, RTLIL::Cell *cell, visited_signals_t &visited_signals, std::vector<string> *excluded_signals, std::vector<string> *read_from_signals) {
    return uc_comb_two_input_cell(design, cell_hierarchy, cell, visited_signals, excluded_signals, read_from_signals);
}

// uc of mux = S && uc_B || !S && uc_A
RTLIL::SigSpec uc_mux(RTLIL::Design *design, std::vector<RTLIL::Cell *> cell_hierarchy, RTLIL::Cell *cell, visited_signals_t &visited_signals, std::vector<string> *excluded_signals, std::vector<string> *read_from_signals) {

    // Pass down a fresh copy of the `visited_signals` list when calling uc_cell_port for a second time, because when this function is called, we are exploring a new assignment path
    // Signals visited on this path should not influence the update condition of other paths. E.g. a = b || b is fine, when visiting the right b, we should not
    // return 0 (already visited), because we have already seen b on the left side of the || . But a = b || a is not fine, uc(b) should return 1, uc(a) should return 0.
    visited_signals_t visited_signals_copy = visited_signals;

    const RTLIL::SigSpec &s = cell->getPort(ID::S);
    log_uc_cond("UC_COND: (  \n");

    log_uc_cond("UC_COND: (%s &&\n", log_signal(s));
    RTLIL::SigSpec uc_b = uc_cell_port(design, cell_hierarchy, cell, ID::B, visited_signals, excluded_signals, read_from_signals);

    // the difference is that s is a reference to the port S and uc_b is a sigspec that we created here!

    RTLIL::SigSpec s_and_uc_b = design->top_module()->And(Yosys::new_id("uc_s_and_uc_b",0,""), s, uc_b);
    log_uc_cond("UC_COND: DEBUG: log_signal(uc_b):  %s\n", log_signal(uc_b));
    log_uc_cond("UC_COND: DEBUG: log_signal(s_and_uc_b):  %s\n", log_signal(s_and_uc_b));
    log_uc_cond("UC_COND: ) || (!%s &&\n", log_signal(s));
    RTLIL::SigSpec uc_a = uc_cell_port(design, cell_hierarchy,  cell, ID::A, visited_signals_copy, excluded_signals, read_from_signals);
    RTLIL::SigSpec not_s_and_uc_a = design->top_module()->And(Yosys::new_id("uc_not_s_and_uc_a",0,""), design->top_module()->Not(Yosys::new_id("uc_not",0,""), s), uc_a);
    log_uc_cond("UC_COND: DEBUG: log_signal(uc_a):  %s\n", log_signal(uc_a));
    log_uc_cond("UC_COND: ) \n");

    RTLIL::SigSpec uc_mux_part2 = design->top_module()->Or(Yosys::new_id("uc_mux_part2",0,""), s_and_uc_b, not_s_and_uc_a);
    log_uc_cond("UC_COND: DEBUG: log_signal(uc_mux_part2):  %s\n", log_signal(uc_mux_part2));
    log_uc_cond("UC_COND: DEBUG: addr of uc_mux_part2 %p \n", &uc_mux_part2);

    return uc_mux_part2;
}


} // UpdateCondition namespace
