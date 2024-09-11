  // Since the rf_wdata_wb signal is cut off, we must specify the taint for all clock cycles. We never want to consider taint that flows back
  // to the register data.
  // We can restrict the state space even more by stating that rf_wdata is never tainted? Anyway it is only read when rf_we_wb is high.
  asm_declass_cpuregs_wrdata: assume property (!cpuregs_wrdata_t0);