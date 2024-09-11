// Copyright 2024 Katharina Ceesay-Seitz, ETH Zurich.
// Licensed under the General Public License, Version 3.0, see LICENSE for details.
// SPDX-License-Identifier: GPL-3.0-only

/////////////////////// START - PROPERTIES                ///////////////////////

property p_no_pc_taint_100clk(bit taint_inject_start);
  $rose(taint_inject_start)
  |->
  !pc_t0[*100];
endproperty

property p_no_pc_taint_ever(bit taint_inject_start);
  $rose(taint_inject_start)
  |->
  always !pc_t0;
endproperty

/////////////////////// END - PROPERTIES                ///////////////////////
