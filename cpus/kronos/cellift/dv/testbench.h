// Copyright 2022 Flavien Solt, ETH Zurich.
// Licensed under the General Public License, Version 3.0, see LICENSE for details.
// SPDX-License-Identifier: GPL-3.0-only

#include "Vkronos_tiny_soc.h"
#include "verilated.h"

#include "Vkronos_tiny_soc__Syms.h"
#include "Vkronos_tiny_soc___024root.h"

#if VM_TRACE
#if VM_TRACE_FST
#include <verilated_fst_c.h>
#else
#include <verilated_vcd_c.h>
#endif // VM_TRACE_FST
#endif // VM_TRACE

#include <iostream>
#include <stdlib.h>

#ifndef TESTBENCH_H
#define TESTBENCH_H

const int kResetLength = 5;
#if VM_TRACE
// Depth of the trace.
const int kTraceLevel = 6;
#endif // VM_TRACE

typedef Vkronos_tiny_soc Module;

enum tick_req_type_e {
  REQ_NONE,
  REQ_STOP,
  REQ_INTREGDUMP,
  REQ_FLOATREGDUMP
};

typedef struct {
  enum tick_req_type_e type;
  uint64_t content;
} tick_req_t;

// This class implements elementary interaction with the design under test.
class Testbench {
 public:
  Testbench(const std::string &trace_filename = "")
      : module_(new Module), tick_count_(0l) {
#if VM_TRACE
#if VM_TRACE_FST
    trace_ = new VerilatedFstC;
#else // VM_TRACE_FST
    trace_ = new VerilatedVcdC;
#endif // VM_TRACE_FST
    module_->trace(trace_, kTraceLevel);
    trace_->open(trace_filename.c_str());
#endif // VM_TRACE
  }

  ~Testbench(void) { close_trace(); }

  void reset(void) {
    module_->rst_ni = 1;
    this->tick(1);
    module_->rst_ni = 0;
    this->tick(kResetLength);
    module_->rst_ni = 1;
  }

  void close_trace(void) {
#if VM_TRACE  
    trace_->close();
#endif // VM_TRACE
  }

  /**
   * Performs one or multiple clock cycles.
   *
   * @param num_ticks the number of ticks to perform.
   */
   // @return false.
  tick_req_t tick(int num_ticks = 1, bool false_tick = false) {
    tick_req_t ret;
    for (size_t i = 0; i < num_ticks || num_ticks == -1; i++) {
      tick_count_++;

      module_->clk_i = 0;
      module_->eval();

#if VM_TRACE
      trace_->dump(5 * tick_count_ - 1);
#endif // VM_TRACE

      module_->clk_i = !false_tick;
      module_->eval();

#if VM_TRACE
      trace_->dump(5 * tick_count_);
#endif // VM_TRACE
      if ((module_->data_mem_req & 1) == 1 && (module_->data_mem_we & 1) == 1) {
          if ((module_->data_mem_addr & 0x7FFFFFFFULL) == 0x00ULL) {
            if (ret.type != REQ_NONE)
              std::cerr << "WARNING: Missed a request during a batch of ticks." << std::endl;
            ret.type = REQ_STOP;
          } else if ((module_->data_mem_addr & 0x7FFFFFFFULL) == 0x10ULL) {
            if (ret.type != REQ_NONE)
              std::cerr << "WARNING: Missed a request during a batch of ticks." << std::endl;
            assert(module_->data_mem_strb = 0xFFFFFFFF);
            ret.type = REQ_INTREGDUMP;
            ret.content = module_->data_mem_wdata;
          } else if ((module_->data_mem_addr & 0x7FFFFFFFULL) == 0x18ULL) {
            if (ret.type != REQ_NONE)
              std::cerr << "WARNING: Missed a request during a batch of ticks." << std::endl;
            assert(module_->data_mem_strb = 0xFFFFFFFF);
            ret.type = REQ_FLOATREGDUMP;
            ret.content = module_->data_mem_wdata;
          }
      }

      module_->clk_i = 0;
      module_->eval();

#if VM_TRACE
      trace_->dump(5 * tick_count_ + 2);
      trace_->flush();
#endif // VM_TRACE
    }
    return ret;
  }

  std::unique_ptr<Module> module_;
 private:
  vluint32_t tick_count_;

#if VM_TRACE
#if VM_TRACE_FST
  VerilatedFstC *trace_;
#else
  VerilatedVcdC *trace_;
#endif // VM_TRACE_FST
#endif // VM_TRACE
};

#endif // TESTBENCH_H
