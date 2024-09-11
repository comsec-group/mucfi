// // Declassify data that goes back to the register file
asm_declass_s4_gpr_wdata: assume property (!i_pipeline__i_pipeline_s4_writeback__gpr_wdata_t0);
asm_declass_s4_gpr_wdata_hi: assume property (!i_pipeline__i_pipeline_s4_writeback__gpr_wdata_hi_t0);


// // Declassify register address based forwarded data
asm_declass_fwd_s2_wdata_hi_t0: assume property (!i_pipeline__fwd_s2_wdata_hi_t0);
asm_declass_fwd_s2_wdata_t0: assume property (!i_pipeline__fwd_s2_wdata_t0);
asm_declass_fwd_s3_wdata_hi_t0: assume property (!i_pipeline__fwd_s3_wdata_hi_t0);
asm_declass_fwd_s3_wdata_t0: assume property (!i_pipeline__fwd_s3_wdata_t0);

// The following signals are the same as s4_writeback output, which we have already declassified above.
// For completenes, based on automated rules, we should find these signals too:
asm_declass_gpr_wdata: assume property (!i_pipeline__gpr_wdata_t0);
asm_declass_gpr_wdata_hi: assume property (!i_pipeline__gpr_wdata_hi_t0);