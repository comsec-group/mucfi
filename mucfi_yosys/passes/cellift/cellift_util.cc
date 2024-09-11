#include "kernel/register.h"
#include "kernel/rtlil.h"
#include "kernel/utils.h"
#include "kernel/log.h"
#include "kernel/yosys.h"

USING_YOSYS_NAMESPACE
const RTLIL::IdString cellift_attribute_name = ID(cellift);

// Checks whether the signal name is included in the exclude-signals command line argument.
bool is_signal_excluded(std::vector<string> *excluded_signals, string signal_name) {
    if (!signal_name.size())
        return false;

    // Remove the first character of the string.
    string name_to_compare = signal_name.substr(1, signal_name.size()-1);
    // log("Found: %d.", std::find(excluded_signals->begin(), excluded_signals->end(), name_to_compare) != excluded_signals->end());
    return std::find(excluded_signals->begin(), excluded_signals->end(), name_to_compare) != excluded_signals->end();
}

// Transforms an identifier name into the corresponding taint name.
std::string get_wire_taint_idstring(RTLIL::IdString id_string, unsigned int taint_id) {
    return id_string.str() + "_t" + std::to_string(taint_id);
}

// For a given SigSpec, returns the corresponding taint SigSpec.
std::vector<RTLIL::SigSpec> get_corresponding_taint_signals(RTLIL::Module* module, std::vector<string> *excluded_signals, const RTLIL::SigSpec &sig, unsigned int num_taints) {
    std::vector<RTLIL::SigSpec> ret(num_taints);

    // Get a SigSpec for the corresponding taint signal for the given cell port, creating a new SigSpec if necessary.
    for (unsigned int taint_id = 0; taint_id < num_taints; taint_id++) {
        for (auto &chunk_it: sig.chunks()) {

            if (chunk_it.is_wire() && !is_signal_excluded(excluded_signals, chunk_it.wire->name.str())) {
                RTLIL::Wire *w = module->wire(get_wire_taint_idstring(chunk_it.wire->name.str(), taint_id));
                if (w == nullptr) {
                    w = module->addWire(get_wire_taint_idstring(chunk_it.wire->name.str(), taint_id), chunk_it.wire);
                    w->set_bool_attribute(cellift_attribute_name);
                    w->port_input = false;
                    w->port_output = false;
                }
                ret[taint_id].append(RTLIL::SigChunk(w, chunk_it.offset, chunk_it.width));
            }
            else
                ret[taint_id].append(RTLIL::SigChunk(RTLIL::State::S0, chunk_it.width));
        }
        log_assert(ret[taint_id].size() == sig.size());
    }
    return ret;
}
