// Copyright 2024 Katharina Ceesay-Seitz, ETH Zurich.
// Licensed under the General Public License, Version 3.0, see LICENSE for details.
// SPDX-License-Identifier: GPL-3.0-only

property p_taint_source_taint_active(untyped taint_source, bit taint_active);
  signed'(taint_source) == signed'(-1'b1) iff taint_active;
endproperty

property p_taint_source_taint_not_active(untyped taint_source, bit taint_active);
  taint_source == 0 iff !taint_active;
endproperty

// Taint once, but ANY time the IUV (Instruction Under Verification) occurs, not at a specific time
// This one would lead to an exhaustive proof when starting in reset state
checker pc_taint_checker_to_anytime(input bit taint_start_cond, taint_stop_cond, untyped taint_source);
  default clocking clk_verif @(posedge fpv_clk); endclocking
  default disable iff (!fpv_resetn);

  bit taint_start, taint_stop, tainted_once;
  bit taint_active;   // FREE signals
  bit taint_optional; // FREE signal that allows taint_start to become true at any taint_start_cond, not only at the first occurance

  bit taint_stop_cond_internal;
  assign taint_stop_cond_internal = taint_stop_cond;

  assign taint_start = taint_start_cond && !$past(tainted_once) && taint_optional;
  assign taint_stop = taint_stop_cond_internal && $past(taint_active) /*&& tainted_once*/;
  assign tainted_once = taint_start ? 1 : $past(tainted_once);

  asm_taint_active: assume property(
    (taint_start && !$past(tainted_once))
    |->
    (taint_active until taint_stop)); // means: until before taint_stop
  asm_taint_not_active_before: assume property(!taint_active |-> !taint_active until taint_start);
  asm_taint_not_active_after: assume property(taint_stop |-> !taint_active until taint_start);

  asm_taint_source_active: assume property(
    p_taint_source_taint_active(taint_source, taint_active)
  );
  asm_taint_source_not_active: assume property(
    p_taint_source_taint_not_active(taint_source, taint_active)
  );

  as_no_pc_taint_ever: assert property(p_no_pc_taint_ever(taint_start));

  // Maximum length of an instruction in CPI according to pico manual is mulh[su|u] with 72 cycles
  //as_no_pc_taint_100: assert property(p_no_pc_taint_100clk(taint_start));

  pc_taint_sanity_checker_to_anytime pc_taint_sanity_checker_inst(taint_start, taint_start_cond, taint_stop, taint_stop_cond,
                                                        taint_stop_cond_internal, taint_active, tainted_once, taint_optional, taint_source);

  // pc_taint_find_taint_propagation pc_taint_find_taint_propagation_inst();

endchecker

checker pc_taint_checker_to_anytime_no_taint_states(input bit taint_start_cond, taint_stop_cond, untyped taint_source);
  default clocking clk_verif @(posedge fpv_clk); endclocking
  default disable iff (!fpv_resetn);

  bit taint_start, taint_stop, tainted_once;
  bit taint_active;   // FREE signals
  bit taint_optional; // FREE signal that allows taint_start to become true at any taint_start_cond, not only at the first occurance

  bit taint_stop_cond_internal;
  assign taint_stop_cond_internal = taint_stop_cond;

  assign taint_start = taint_start_cond && !$past(tainted_once) && taint_optional;
  assign taint_stop = taint_stop_cond_internal && $past(taint_active) /*&& tainted_once*/;
  assign tainted_once = taint_start ? 1 : $past(tainted_once);

  asm_taint_active: assume property(
    (taint_start && !$past(tainted_once))
    |->
    (taint_active until taint_stop)); // means: until before taint_stop
  asm_taint_not_active_before: assume property(!taint_active |-> !taint_active until taint_start);
  asm_taint_not_active_after: assume property(taint_stop |-> !taint_active until taint_start);

  asm_taint_source_active: assume property(
    p_taint_source_taint_active(taint_source, taint_active)
  );
  asm_taint_source_not_active: assume property(
    p_taint_source_taint_not_active(taint_source, taint_active)
  );

  as_no_pc_taint_ever: assert property(p_no_pc_taint_ever(taint_start));

  // Maximum length of an instruction in CPI according to pico manual is mulh[su|u] with 72 cycles
  as_no_pc_taint_100: assert property(p_no_pc_taint_100clk(taint_start));

  // Helper assertions:
  chk_no_taint_ever chk_no_taint_ever_inst();

  pc_taint_sanity_checker_to_anytime pc_taint_sanity_checker_inst(taint_start, taint_start_cond, taint_stop, taint_stop_cond,
                                        taint_stop_cond_internal, taint_active, tainted_once, taint_optional, taint_source);

endchecker


////////////////////////////////////////// Sanity Checking //////////////////////////////////////////////////


checker pc_taint_sanity_checker_to(untyped taint_start, untyped taint_start_cond, untyped taint_stop, untyped taint_stop_cond, untyped taint_stop_cond_internal,
                                untyped taint_active, untyped tainted_once, untyped taint_source);
  c_sanity_taint_start_expCov: cover property(##1 $rose(taint_start));
  c_sanity_not_always_taint_start: assert property(!taint_start);
  c_sanity_taint_stop_expCov: cover property(##1 $rose(taint_stop));
  c_sanity_taint_stop_cond_expCov: cover property(##1 $rose(taint_stop_cond));
  c_sanity_taint_stop_cond_internal_expCov: cover property(##1 $rose(taint_stop_cond_internal));
  c_sanity_tainted_once_expCov: cover property($past(taint_active) && tainted_once);

  // c_sanity_taint_div_stays_high_taint_multiple_expCov: cover property((taint_start[*2])); // currently not expecting taint start to be high for a specific amount of clock cycles
  c_sanity_fell_taint_start_expCov: cover property(##2 $fell(taint_start)); // covers with fell should be preceded with ##2, because we don't care about this seq:  sig reset/start,1,0. We want to see reste/start, ..., 1, 0
  c_sanity_fell_taint_end_expCov: cover property(##2 $fell(taint_stop));
  c_sanity_rose_taint_expCov: cover property(##1 $rose(taint_source));
  c_sanity_fell_taint_expCov: cover property(##2 $fell(taint_source));
  c_sanity_rose_taint_start_cond_instr_expCov: cover property(##1 $rose(taint_start_cond));
  c_sanity_taint_one_cycle_expCov: cover property(##1 $rose(taint_active) ##1 $fell(taint_active));
  c_sanity_taint_active_mult_cycles_expCov: cover property(taint_active[*2:$]);

  c_sanity_taint_active_mult_times_expUncov: cover property(##1 $rose(taint_active)
                                            ##[1:$] $rose(taint_active)
                                            ##[1:$] $rose(taint_active)
                                            ##[1:$] $rose(taint_active)
                                            ##[1:$] $rose(taint_active));
  c_sanity_two_taints_div_expUncov: cover property(##[1:$]$rose(taint_start) ##[1:$] $rose(taint_start));

  as_sanity_tainted_once_expPass: assert property(##1 $past(taint_active) |-> tainted_once);
  as_sanity_taint_start_expPass: assert property(taint_start |-> taint_start_cond);
  as_sanity_taint_start_not_always_expUncov: cover property(taint_start && !taint_active && !tainted_once);

  // Taint start & stop at same time
  as_sanity_taint_start_and_stop1_expPass: assert property(
    !taint_active ##1 taint_start_cond && taint_stop_cond
    |->
    (taint_active)
  );
  as_sanity_taint_start_and_stop2_expPass: assert property(
    taint_active ##1 taint_stop
    |->
    always !taint_active
  );
endchecker

checker pc_taint_sanity_checker_to_anytime(untyped taint_start, untyped taint_start_cond, untyped taint_stop, untyped taint_stop_cond, untyped taint_stop_cond_internal,
                                untyped taint_active, untyped tainted_once, untyped taint_optional, untyped taint_source);

  // Whenever we use functions spanning over multiple clock cycles (like $rose()), we ned to skip as many cycles as we look into the past
  // before the condition should hold. (Eg. ##1 for $rose(a), ##2 for $fell(a,2)). Otherwise the sanity checker covers could be trivially fulfilled by
  // spanning over cycles before the start of formal analysis, or assertions may fail unexpectedly for the same reason.

  c_sanity_taint_start_expCov: cover property(##1 $rose(taint_start));
  // c_sanity_taint_stop_expCov: cover property(##1 $rose(taint_stop));
  // c_sanity_taint_stop_cond_expCov: cover property(##1 $rose(taint_stop_cond));
  // c_sanity_taint_stop_cond_internal_expCov: cover property(##1 $rose(taint_stop_cond_internal));
  c_sanity_tainted_once_expCov: cover property($past(taint_active) && tainted_once);

  // c_sanity_taint_div_stays_high_taint_multiple_expCov: cover property((taint_start[*2])); // currently not expecting taint start to be high for a specific amount of clock cycles
  c_sanity_fell_taint_start_expCov: cover property(##2 $fell(taint_start)); // covers with fell should be preceded with ##2, because we don't care about this seq:  sig reset/start,1,0. We want to see reste/start, ..., 1, 0
  // c_sanity_fell_taint_end_expCov: cover property(##2 $fell(taint_stop));
  c_sanity_rose_taint_expCov: cover property(##1 $rose(taint_source));
  c_sanity_fell_taint_expCov: cover property(##2 $fell(taint_source));
  c_sanity_rose_taint_start_cond_instr_expCov: cover property(##1 $rose(taint_start_cond));
  c_sanity_taint_one_cycle_expCov: cover property(##1 $rose(taint_active) ##1 $fell(taint_active));
  c_sanity_taint_active_mult_cycles_expCov: cover property(taint_active[*2:$]);

  c_sanity_taint_active_mult_times_expUncov: cover property(##1 $rose(taint_active)
                                            ##[1:$] $rose(taint_active)
                                            ##[1:$] $rose(taint_active)
                                            ##[1:$] $rose(taint_active)
                                            ##[1:$] $rose(taint_active));
  // as_sanity_two_taints: assert property(not (##[1:$]$rose(taint_start) ##[1:$] $rose(taint_start)));
  as_sanity_two_taints: assert property($rose(taint_start) |=> !( $rose(taint_start)));

  as_sanity_tainted_once_expPass: assert property(##1 $past(taint_active) |-> tainted_once);
  as_sanity_taint_start_expPass: assert property(taint_start |-> taint_start_cond);
  as_sanity_taint_start_not_always_expCov: cover property(taint_start_cond && !taint_active && !tainted_once);
  as_sanity_taint_later_expCov: cover property(taint_start_cond && !taint_active && !tainted_once ##[1:$] taint_active);

  // Taint start & stop at same time
  as_sanity_taint_start_and_stop1_expPass: assert property(
    !taint_active ##1 taint_start_cond && taint_stop_cond && taint_optional && !$past(tainted_once)
    |->
    (taint_active)
  );
  as_sanity_taint_start_and_stop2_expPass: assert property(
    taint_active ##1 taint_stop_cond
    |->
    always !taint_active
  );

  c_sanity_taint_in_first_cycle_of_taint_start: cover property(##1 $rose(taint_start) && (taint_source != 0));
  c_sanity_taint_in_last_cycle_of_taint_start: cover property(##1 $fell(taint_start) && ($past(taint_source) != 0));
endchecker
