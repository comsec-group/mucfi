# Declassify the forward data, the data written to register and the forward select

# forwarding control:
# u_ibex_core.rf_write_wb

# Just abstracting the wb match signals could be wrong. But let's try. Worst case: false positives.

set declassifiedSigs {u_ibex_core.rf_wdata_fwd_wb_t0 u_ibex_core.rf_wdata_wb_ecc_o_t0

u_ibex_core.id_stage_i._0084_


}

