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
  // $rose(taint_inject_start) // Whith this precondition, proofs were slightly faster, 
                               // but adding it could lead to missed taint flows that taint the PC in the same 
                               // clock cycle as taint injection. 
                               // Plus, the property would be satisified if taint_inject_start never rises. (But we 
                               // have the sanity checkers to indicate that as well).
  // |->
  // always 
  !pc_t0;
endproperty

/////////////////////// END - PROPERTIES                ///////////////////////
