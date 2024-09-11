
# Generic solution descritption in declass_asm.sv

# abstract the forwarding logic selection to let the tainted register value through in case forwarded data should be used as input.
# we are still blocking the result taint from spreading, but we are allowing input taint



# For test:
#"i_pipeline.fwd_s2_wdata_hi_t0" "i_pipeline.fwd_s2_wdata_t0"
#"i_pipeline.hzd_rs1_s2"

set declassifiedSigs {"i_pipeline.fwd_s3_wdata_hi_t0" "i_pipeline.fwd_s3_wdata_t0"
"i_pipeline.i_pipeline_s4_writeback.gpr_wdata_t0" "i_pipeline.i_pipeline_s4_writeback.gpr_wdata_hi_t0"
"i_pipeline.gpr_wdata_t0" "i_pipeline.gpr_wdata_hi_t0"




"i_pipeline.hzd_rs1_s3"

"i_pipeline.hzd_rs1_s4"

"i_pipeline.hzd_rs2_s2"

"i_pipeline.hzd_rs2_s3"

"i_pipeline.hzd_rs2_s4"

"i_pipeline.hzd_rs3_s2"

"i_pipeline.hzd_rs3_s3"

"i_pipeline.hzd_rs3_s4"

}

