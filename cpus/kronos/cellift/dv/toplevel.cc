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
        tick_req.type == REQ_STOP) {
      std::cout << "Found a stop request. Stopping the benchmark after " << RUNMORETICKS_AFTER_STOP << " more ticks." << std::endl;
      got_stop_req = true;
    }

// #ifdef TAINTS
//     // Check whether some taint has been seen on the bus.
//     static int taint_already_seen = 0;
//     if (!taint_already_seen &&
//         tb->module_->rootp->vlSymsp->TOP.kronos_tiny_soc->data_mem_rdata_t0) {
//       taint_already_seen = 1;
//       std::cout << "Detected taint transit on the bus." << std::endl;
//     }

//     // Check whether the PC is tainted.
//     if (!got_pc_tainted &&
//       tb->module_->rootp->vlSymsp->TOP__kronos_tiny_soc__i_picorv32_mem_top__i_picorv32.next_pc_t0) {
//       std::cout << "PC tainted! Stopping the benchmark after " << RUNMORETICKS_AFTER_STOP << " more ticks." << std::endl;
//       std::cout << "Approximative PC at taint time: 0x" << std::hex << tb->module_->rootp->vlSymsp->TOP__kronos_tiny_soc__i_picorv32_mem_top__i_picorv32.next_pc << std::dec << std::endl;
//       got_stop_req = true;
//       got_pc_tainted = true;
//     }

//     // Check whether a memory operation with tainted address occurred.
//     if (!got_mem_tainted_addr &&
//       tb->module_->rootp->vlSymsp->TOP.kronos_tiny_soc->data_mem_addr_t0) {
//       std::cout << "Memery operation with tainted address detected." << std::endl;
//       got_mem_tainted_addr = true;
//     }

// #endif // TAINTS

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
#ifdef HAS_COVERAGE
  char *coveragepath;
  coveragepath = getenv("COVERAGEFILE");
#endif // HAS_COVERAGE

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

#ifdef HAS_COVERAGE
  // Write the coverage if needed
  if (coveragepath != NULL && strlen(coveragepath)) {
    std::cout << "Writing coverage to " << coveragepath << std::endl;
    Verilated::threadContextp()->coveragep()->write(coveragepath);
  } else { 
    std::cout << "Not writing coverage." << std::endl;
  }
#endif // HAS_COVERAGE

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
