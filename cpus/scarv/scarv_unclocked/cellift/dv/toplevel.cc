// Copyright 2022 Flavien Solt, ETH Zurich.
// Licensed under the General Public License, Version 3.0, see LICENSE for details.
// SPDX-License-Identifier: GPL-3.0-only

#include "testbench.h"
#include "ticks.h"

// Stops when zero data is written to address 0, or if the PC is tainted (if applicable)
#define RUNMORETICKS_AFTER_STOP 50 // Run a bit longer in case something interesting still happens
static inline long tb_run_ticks_stoppable(Testbench *tb, int simlen, bool reset = false) {
  if (reset)
    tb->reset();

  bool got_stop_req = false;
  bool got_pc_tainted = false;
  int curr_int_req_dump_id = 1;
  int curr_float_req_dump_id = 0;
  int remaining_before_stop = RUNMORETICKS_AFTER_STOP;

  // Check if the benchmark performs loads with a tainted address.
  bool got_mem_tainted_addr = false;

  auto start = std::chrono::steady_clock::now();

  size_t step_id = 0;
  for (; step_id < simlen; step_id++) {
    tick_req_t tick_req = tb->tick();

    // Check whether we got a register dump request.
    if (tick_req.type == REQ_INTREGDUMP) {
      printf("Dump of reg x%02d: 0x%016lx.\n", curr_int_req_dump_id, tick_req.content);
      curr_int_req_dump_id++;
    } else if (tick_req.type == REQ_FLOATREGDUMP) {
      printf("Dump of reg f%02d: 0x%016lx.\n", curr_float_req_dump_id, tick_req.content);
      curr_float_req_dump_id++;
    }

    // Check whether stop has been requested.
    if (!got_stop_req &&
        tb->module_->data_mem_req_o &&
        tb->module_->data_mem_we_o &&
        // tb->module_->data_mem_wdata_o == 0 &&  // We release this constraint == 0 since now we store the destination register for stopping. 
        tb->module_->data_mem_addr_o == 0x00000000) {
      std::cout << "Found a stop request. Stopping the benchmark after " << RUNMORETICKS_AFTER_STOP << " more ticks." << std::endl;
      got_stop_req = true;
    }

    // Decrement the chrono and maybe stop if stop request has been detected.
    if (got_stop_req)
      if (remaining_before_stop-- == 0)
        break;

    // "Natural" stop since SIMLEN has been reached
    if (step_id == simlen-1)
      std::cout << "Reached SIMLEN (" << simlen << " cycles). Stopping." << std::endl;
  }

  auto stop = std::chrono::steady_clock::now();
  long ret = std::chrono::duration_cast<std::chrono::milliseconds>(stop - start).count();

  // std::cout << "Duration: " << step_id << " cycles. Stopping." << std::endl;

  return ret;
}

/**
 * Runs the testbench.
 *
 * @param tb a pointer to a testbench instance
 * @param simlen the number of cycles to run
 */
long run_test(Testbench *tb, int simlen) {
  return tb_run_ticks_stoppable(tb, simlen, true);
}


int main(int argc, char **argv, char **env) {

  Verilated::commandArgs(argc, argv);
  Verilated::traceEverOn(VM_TRACE);

  ////////
  // Get the env vars early to avoid Verilator segfaults.
  ////////

  std::cout << "Starting getting env variables." << std::endl;

  int simlen = get_sim_length_cycles(LEADTICKS);

  ////////
  // Initialize testbench.
  ////////

  Testbench *tb = new Testbench(cl_get_tracefile());

  ////////
  // Run the lead ticks.
  ////////

  long duration = run_test(tb, simlen);

#if !VM_TRACE
  std::cout << "Testbench complete!" << std::endl;
  std::cout << "Elapsed time: " << std::dec << duration << "." << std::endl;
#else // VM_TRACE
  std::cout << "Testbench with traces complete!" << std::endl;
  std::cout << "Elapsed time (traces enabled): " << std::dec << duration << "." << std::endl;
#endif // VM_TRACE

  delete tb;
  exit(0);
}
