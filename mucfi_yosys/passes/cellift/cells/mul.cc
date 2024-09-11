#include "kernel/log.h"
#include "kernel/rtlil.h"
#include "kernel/utils.h"
#include "kernel/yosys.h"

USING_YOSYS_NAMESPACE
extern std::vector<RTLIL::SigSpec> get_corresponding_taint_signals(RTLIL::Module *module, std::vector<string> *excluded_signals,
								   const RTLIL::SigSpec &sig, unsigned int num_taints);

/**
 * @param module the current module instance
 * @param cell the current cell instance
 *
 * @return keep_current_cell
 */
bool cellift_mul(RTLIL::Module *module, RTLIL::Cell *cell, unsigned int num_taints, std::vector<string> *excluded_signals)
{
	const unsigned int A = 0, B = 1, Y = 2;
	const unsigned int NUM_PORTS = 3;
	RTLIL::SigSpec ports[NUM_PORTS] = {cell->getPort(ID::A), cell->getPort(ID::B), cell->getPort(ID::Y)};
	std::vector<RTLIL::SigSpec> port_taints[NUM_PORTS];

	for (unsigned int i = 0; i < NUM_PORTS; ++i)
		port_taints[i] = get_corresponding_taint_signals(module, excluded_signals, ports[i], num_taints);

	for (unsigned int taint_id = 0; taint_id < num_taints; taint_id++) {
		RTLIL::SigSpec reduced_a, reduced_b;

		module->addReduceOr(NEW_ID, port_taints[A][taint_id], reduced_a);
		module->addReduceOr(NEW_ID, port_taints[B][taint_id], reduced_b);
		module->addOr(NEW_ID, reduced_a, reduced_b, port_taints[Y][taint_id][0]);
		// For the other bits, taint the output as .
		if (ports[Y].size() > 1)
			module->connect(port_taints[Y][taint_id].extract_end(1), RTLIL::SigSpec(port_taints[Y][taint_id][0], ports[Y].size() - 1));
	}

	return true;
}
