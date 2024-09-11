#include "kernel/rtlil.h"
#include "kernel/utils.h"
#include "kernel/log.h"
#include "kernel/yosys.h"
#include "passes/update_condition/update_condition.h"

USING_YOSYS_NAMESPACE

namespace UpdateCondition {

// Update condition for an unconditional flip flop is set to 1 (precisely it would be $past(1))
// For better consistency with combinational cells, it could be set to $past(uc(D)).
// Often, DFFs are assigned with a new value if some condition is true. In an (often implicit) else condition, they are
// assigned with their previous value.
// The update condition is the condition that selects an assignment from other signals.
RTLIL::SigSpec uc_dff(RTLIL::Design *design, std::vector<RTLIL::Cell *> cell_hierarchy, RTLIL::Cell *cell, visited_signals_t &visited_signals, std::vector<string> *excluded_signals, std::vector<string> *read_from_signals) {
    RTLIL::Cell *curr_instance_cell = get_curr_instance_cell(cell_hierarchy);
    RTLIL::Module *start_module;

    //Is the D port connected to an output of a MUX?
    //Find the cell that is driving the D port (must be exactly one, Yosys should guarantee this)
    if (!cell->getPort(ID::D).is_wire())
        log_cmd_error_lineinfo("DFF %s has multiple chunks connected to its D port. This is not yet supported or even unexpected. Did you forget to run the opt pass before the update_condition pass?\n", log_id(cell->name));

    RTLIL::SigSpec ret_if_no_more_state_depth_allowed;
    bool trace_back_state_elem;
    std::tie(trace_back_state_elem, ret_if_no_more_state_depth_allowed) = already_visited_a_state_element(cell, visited_signals, excluded_signals, read_from_signals);
    if (!trace_back_state_elem) {
        return ret_if_no_more_state_depth_allowed;
    }

    RTLIL::SigSpec uc_sig = uc_cell_port(design, cell_hierarchy, cell, ID::D, visited_signals, excluded_signals, read_from_signals);
    set_past_attribute(uc_sig);
    log_uc_cond("UC_COND: $past(%s)\n", log_signal(uc_sig));

    return uc_sig;
}

// An SDFF cell is reset when its SRST port is asserted, otherwise it is update with the value of its D port.
// Since the reset value is a constant, the udpate condition is true, when SRST becomes SRST_POLARITY.
// To be precise, it should not be true when SRST remains SRST_POLARITY, but we don't care about reset cases for now
RTLIL::SigSpec uc_sdff(RTLIL::Design *design, std::vector<RTLIL::Cell *> cell_hierarchy, RTLIL::Cell *cell, visited_signals_t &visited_signals, std::vector<string> *excluded_signals, std::vector<string> *read_from_signals) {
    RTLIL::SigSpec ret_if_no_more_state_depth_allowed;
    bool trace_back_state_elem;
    std::tie(trace_back_state_elem, ret_if_no_more_state_depth_allowed) = already_visited_a_state_element(cell, visited_signals, excluded_signals, read_from_signals);
    if (!trace_back_state_elem) {
        return ret_if_no_more_state_depth_allowed;
    }
    log_uc_cond("UC_COND: $past(\n");
    RTLIL::SigSpec srst = design->top_module()->Eq(NEW_ID, cell->getPort(ID::SRST), cell->getParam(ID::SRST_POLARITY));
    RTLIL::SigSpec uc_d = uc_cell_port(design, cell_hierarchy,  cell, ID::D, visited_signals, excluded_signals, read_from_signals);
    RTLIL::SigSpec uc_sig = design->top_module()->Or(Yosys::new_id("uc_sdff",0,""), srst, uc_d);
    log_uc_cond("UC_COND: %s || %s\n", log_signal(srst), log_signal(uc_d));
    log_uc_cond("UC_COND: )\n");
    set_past_attribute(uc_sig);
    return uc_sig;
}

// An ADFF cell is reset when its ARST port is asserted, otherwise it is update with the value of its D port.
RTLIL::SigSpec uc_adff(RTLIL::Design *design, std::vector<RTLIL::Cell *> cell_hierarchy, RTLIL::Cell *cell, visited_signals_t &visited_signals, std::vector<string> *excluded_signals, std::vector<string> *read_from_signals) {
    RTLIL::SigSpec ret_if_no_more_state_depth_allowed;
    bool trace_back_state_elem;
    std::tie(trace_back_state_elem, ret_if_no_more_state_depth_allowed) = already_visited_a_state_element(cell, visited_signals, excluded_signals, read_from_signals);
    if (!trace_back_state_elem) {
        return ret_if_no_more_state_depth_allowed;
    }
    log_uc_cond("UC_COND: $past(\n");
    RTLIL::SigSpec arst = design->top_module()->Eq(NEW_ID, cell->getPort(ID::ARST), cell->getParam(ID::ARST_POLARITY));
    RTLIL::SigSpec uc_d = uc_cell_port(design, cell_hierarchy,  cell, ID::D, visited_signals, excluded_signals, read_from_signals);
    RTLIL::SigSpec uc_sig = design->top_module()->Or(Yosys::new_id("uc_adff",0,""), arst, uc_d);
    set_past_attribute(uc_sig);
    log_uc_cond("UC_COND: %s || %s\n", log_signal(arst), log_signal(uc_d));
    log_uc_cond("UC_COND: )\n");
    return uc_sig;
}

// An SDFFE cell is reset when its SRST port is asserted, otherwise it is update when the EN port is equalling its polarity.
RTLIL::SigSpec uc_sdffe(RTLIL::Design *design, std::vector<RTLIL::Cell *> cell_hierarchy, RTLIL::Cell *cell, visited_signals_t &visited_signals, std::vector<string> *excluded_signals, std::vector<string> *read_from_signals) {
    RTLIL::SigSpec ret_if_no_more_state_depth_allowed;
    bool trace_back_state_elem;
    std::tie(trace_back_state_elem, ret_if_no_more_state_depth_allowed) = already_visited_a_state_element(cell, visited_signals, excluded_signals, read_from_signals);
    if (!trace_back_state_elem) {
        return ret_if_no_more_state_depth_allowed;
    }
    log_uc_cond("UC_COND: (\n");
    RTLIL::SigSpec srst = design->top_module()->Eq(NEW_ID, cell->getPort(ID::SRST), cell->getParam(ID::SRST_POLARITY));
    log_uc_cond("UC_COND: %s || \n", log_signal(cell->getPort(ID::SRST)));
    RTLIL::SigSpec en = design->top_module()->Eq(NEW_ID, cell->getPort(ID::EN), cell->getParam(ID::EN_POLARITY));
    RTLIL::SigSpec uc_d = uc_cell_port(design, cell_hierarchy,  cell, ID::D, visited_signals, excluded_signals, read_from_signals);
    log_uc_cond("UC_COND: (%s && %s)\n", log_signal(en), log_signal(uc_d));
    RTLIL::SigSpec en_and_uc_d = design->top_module()->And(Yosys::new_id("en_and_uc_d",0,""), en, uc_d);
    RTLIL::SigSpec uc_sig = design->top_module()->Or(Yosys::new_id("uc_adffe",0,""), srst, en_and_uc_d);
    set_past_attribute(uc_sig);
    log_uc_cond("UC_COND: )\n");
    uc_sig.as_wire()->set_bool_attribute(ID(uc_past), true);
    return uc_sig;
}

// An ADFFE cell is reset asynchronously, when its ARST port is matching its polarity, otherwise it is update when the EN port is equalling its polarity.
// We are not considering the asynchronicity of the reset.
// Reset with a constant value, which can therefore not be in visited signals or excluded signals. Therefore, we do not need to call uc(reset value).
RTLIL::SigSpec uc_adffe(RTLIL::Design *design, std::vector<RTLIL::Cell *> cell_hierarchy, RTLIL::Cell *cell, visited_signals_t &visited_signals, std::vector<string> *excluded_signals, std::vector<string> *read_from_signals) {

    RTLIL::SigSpec ret_if_no_more_state_depth_allowed;
    bool trace_back_state_elem;
    std::tie(trace_back_state_elem, ret_if_no_more_state_depth_allowed) = already_visited_a_state_element(cell, visited_signals, excluded_signals, read_from_signals);
    if (!trace_back_state_elem) {
        return ret_if_no_more_state_depth_allowed;
    }

    log_uc_cond("UC_COND: (\n");
    RTLIL::SigSpec arst = design->top_module()->Eq(NEW_ID, cell->getPort(ID::ARST), cell->getParam(ID::ARST_POLARITY));
    log_uc_cond("UC_COND: %s || \n", log_signal(cell->getPort(ID::ARST)));
    RTLIL::SigSpec en = design->top_module()->Eq(NEW_ID, cell->getPort(ID::EN), cell->getParam(ID::EN_POLARITY));
    RTLIL::SigSpec uc_d = uc_cell_port(design, cell_hierarchy,  cell, ID::D, visited_signals, excluded_signals, read_from_signals);
    log_uc_cond("UC_COND: (%s && %s)\n", log_signal(en), log_signal(uc_d));
    RTLIL::SigSpec en_and_uc_d = design->top_module()->And(Yosys::new_id("en_and_uc_d",0,""), en, uc_d);
    RTLIL::SigSpec uc_sig = design->top_module()->Or(Yosys::new_id("uc_adffe",0,""), arst, en_and_uc_d);
    set_past_attribute(uc_sig);
    log_uc_cond("UC_COND: )\n");
    uc_sig.as_wire()->set_bool_attribute(ID(uc_past), true);
    return uc_sig;
}

RTLIL::SigSpec uc_dffe(RTLIL::Design *design, std::vector<RTLIL::Cell *> cell_hierarchy, RTLIL::Cell *cell, visited_signals_t &visited_signals, std::vector<string> *excluded_signals, std::vector<string> *read_from_signals) {
    RTLIL::SigSpec ret_if_no_more_state_depth_allowed;
    bool trace_back_state_elem;
    std::tie(trace_back_state_elem, ret_if_no_more_state_depth_allowed) = already_visited_a_state_element(cell, visited_signals, excluded_signals, read_from_signals);
    if (!trace_back_state_elem) {
        return ret_if_no_more_state_depth_allowed;
    }
    RTLIL::SigSpec en = design->top_module()->Eq(NEW_ID, cell->getPort(ID::EN), cell->getParam(ID::EN_POLARITY));
    RTLIL::SigSpec uc_d = uc_cell_port(design, cell_hierarchy,  cell, ID::D, visited_signals, excluded_signals, read_from_signals);
    RTLIL::SigSpec uc_sig = design->top_module()->And(Yosys::new_id("en_and_uc_d",0,""), en, uc_d);
    set_past_attribute(uc_sig);
    log_uc_cond("UC_COND: $past(%s && %s)\n", log_signal(cell->getPort(ID::EN)), log_signal(uc_d));
    return uc_sig;
}

RTLIL::SigSpec uc_dffe_n(RTLIL::Design *design, std::vector<RTLIL::Cell *> cell_hierarchy, RTLIL::Cell *cell, visited_signals_t &visited_signals, std::vector<string> *excluded_signals, std::vector<string> *read_from_signals) {
    RTLIL::SigSpec ret_if_no_more_state_depth_allowed;
    bool trace_back_state_elem;
    std::tie(trace_back_state_elem, ret_if_no_more_state_depth_allowed) = already_visited_a_state_element(cell, visited_signals, excluded_signals, read_from_signals);
    if (!trace_back_state_elem) {
        return ret_if_no_more_state_depth_allowed;
    }

    RTLIL::SigSpec en = design->top_module()->Eq(NEW_ID, cell->getPort(ID::EN), RTLIL::SigBit(RTLIL::State::S0));
    RTLIL::SigSpec uc_d = uc_cell_port(design, cell_hierarchy,  cell, ID::D, visited_signals, excluded_signals, read_from_signals);
    RTLIL::SigSpec uc_sig = design->top_module()->And(Yosys::new_id("en_and_uc_d",0,""), en, uc_d);
    set_past_attribute(uc_sig);
    log_uc_cond("UC_COND: $past(%s)\n", log_signal(cell->getPort(ID::EN)));
    return uc_sig;
}

// TODO: There can be multiple write cells for a memory. Need a rule how to relate them to read cells.
// Update condition of a memory data read signal is true when
//
// - the enable condition is high and the data at the current read adress changes
//
// - the enable condition is true and the memory address selection changes -> now reading from a different location
//
///// Normally, the enable condition should be the same as the read signal's update condition, so no need to reimplement it here. (not sure if this is true)
// - the enable condition becomes high (the address could have changed just before) ??
// Considering the following clock sequence:
// 1. en and read from A, 2. !en and set addr to B, 3. no change, 4. en and read from B
// In the 4th cycle, we need to set the update condition true ($rose(en))
//
// - the enable condition becomes high and the address has changed since the last time when the enable condition was true
// 1. en and read from A, 2. !en, 3. no change, 4. en and read from A
// Generally: In the 4th cycle, we need to set the update condition false.
// For instructions: In the 4th cycle, we need to set the update condition true, because a new read is performed. ($rose(en))? This seems inconsistent with the uc. of dffe cells, because in that case a "read" is performed at every clock cycle, but we only read when the (write) enable is high.
/////
//
// Update condition of a specific memory location:
//
// "read enable is high && previous clock cycle: write enable && the last clock cycle's write address matches the current read address
// 	or
// 	the read enable is high and the read address'es update condition is true (corresponding to a potential address change)
//  or
//  $rose(enable)"  (this line is debatable, for instruction tainting it is correct, as it indicates a new register read by an instruction)
RTLIL::SigSpec uc_memrd(RTLIL::Design *design, std::vector<RTLIL::Cell *> cell_hierarchy, RTLIL::Cell *cell, visited_signals_t &visited_signals, std::vector<string> *excluded_signals, std::vector<string> *read_from_signals) {

    // Find the corresponding write cell with the same memory ID, expecting it to be in the same module
    RTLIL::Cell *memwr_cell = find_memwr_cell(cell);

    // Add a new wire that gets assigned with the enable condition of the memory write cell
    // We need a new wire, because we need to set the uc_past attribute on it and we cannot set
    // it on the original enable condition wire, because it may be used elsewhere in this or
    // another update condition without requiring the uc_past attribute.

    // TODO: What if the register write is not clocked?
    RTLIL::SigSpec past_write_en = create_observing_wire(design->top_module(),
        memwr_cell->getPort(ID::EN), {ID(uc_past)});

    const RTLIL::SigSpec past_write_addr = create_observing_wire(design->top_module(),
        memwr_cell->getPort(ID::ADDR), {ID(uc_past)});

    RTLIL::SigSpec read_addr_matches_past_write_addr = design->top_module()->Eq(NEW_ID, cell->getPort(ID::ADDR), past_write_addr);

    // The enable condition is high and the data at the current read adress changes
    RTLIL::SigSpec read_and_past_write = design->top_module()->And(NEW_ID, cell->getPort(ID::EN), past_write_en);
    RTLIL::SigSpec data_changed = design->top_module()->And(NEW_ID, read_and_past_write, read_addr_matches_past_write_addr);

    // The enable condition is true and the memory address selection changes -> now reading from a different location
    RTLIL::SigSpec read_and_addr_changed = design->top_module()->And(NEW_ID, cell->getPort(ID::EN), uc_cell_port(design, cell_hierarchy, cell, ID::ADDR, visited_signals, excluded_signals, read_from_signals));

    RTLIL::SigSpec uc_sig = design->top_module()->Or(NEW_ID, data_changed, read_and_addr_changed);
    uc_sig.as_wire()->set_bool_attribute(ID(uc_past), true);

    return uc_sig;

}

std::tuple<bool, RTLIL::SigSpec> already_visited_a_state_element(RTLIL::Cell *cell,visited_signals_t &visited_signals, std::vector<string> *excluded_signals, std::vector<string> *read_from_signals) {
    if (std::find(visited_signals.begin(), visited_signals.end(), TMP_DEF_VISITED_STATE) != visited_signals.end()){
        if (cell->getPort(ID::D).is_fully_const()) {
            log("UC_COND: 0 %s is constant\n", cell->getPort(ID::D).as_const().as_string().c_str());
            return std::make_tuple(false, RTLIL::SigSpec(RTLIL::State::S0));
        }
        RTLIL::IdString  signal_name;
        signal_name = cell->getPort(ID::D).as_wire()->name;
        if (!update_visited_signals(visited_signals, signal_name) || (std::find(excluded_signals->begin(), excluded_signals->end(), signal_name.str()) != excluded_signals->end())) {
            log("UC_COND: 0 %s is in visited signals or excluded signals\n", signal_name.str().c_str());
            return std::make_tuple(false, RTLIL::SigSpec(RTLIL::State::S0));
        }
        log("UC_COND: 1. Found another state element %s\n", signal_name.str().c_str());
        return std::make_tuple(false, RTLIL::SigSpec(RTLIL::State::S1));
    } else {
        visited_signals.push_back(*(new RTLIL::IdString(TMP_DEF_VISITED_STATE)));
        return std::make_tuple(true, *(new RTLIL::SigSpec(RTLIL::State::S0)));
    }
}


} // UpdateCondition namespace
