# Declassify the forward data, the data written to register and the forward select

# forwarding control:
# The mux select:
# u_ibex_core.rf_write_wb
# u_ibex_core.rf_rd_a_wb_match
# u_ibex_core.rf_rd_b_wb_match

set declassifiedSigs {u_ibex_core.rf_wdata_fwd_wb_t0 u_ibex_core.rf_wdata_wb_ecc_o_t0

u_ibex_core.id_stage_i.rf_wdata_fwd_wb_i_t0

}


