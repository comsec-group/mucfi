set signals [list \
    "top.clk_i" \
    "top.rst_ni" \
    "top.ibex_tiny_soc.i_mem_top.i_rv_core_ibex.u_core.u_ibex_core.alu_operand_a_ex" \
    "top.ibex_tiny_soc.i_mem_top.i_rv_core_ibex.u_core.u_ibex_core.alu_operand_b_ex" \
    "top.ibex_tiny_soc.i_mem_top.i_rv_core_ibex.u_core.u_ibex_core.alu_operand_a_ex_t0" \
    "top.ibex_tiny_soc.i_mem_top.i_rv_core_ibex.u_core.u_ibex_core.alu_operand_b_ex_t0" \
    "top.ibex_tiny_soc.i_mem_top.i_rv_core_ibex.u_core.u_ibex_core.multdiv_operand_a_ex" \
    "top.ibex_tiny_soc.i_mem_top.i_rv_core_ibex.u_core.u_ibex_core.multdiv_operand_b_ex" \
    "top.ibex_tiny_soc.i_mem_top.i_rv_core_ibex.u_core.u_ibex_core.multdiv_operand_a_ex_t0" \
    "top.ibex_tiny_soc.i_mem_top.i_rv_core_ibex.u_core.u_ibex_core.multdiv_operand_b_ex_t0" \
    "top.ibex_tiny_soc.i_mem_top.i_rv_core_ibex.u_core.gen_regfile_ff.register_file_i.rf_reg" \
    "top.ibex_tiny_soc.i_mem_top.i_rv_core_ibex.u_core.gen_regfile_ff.register_file_i.rf_reg_t0" \
    "top.ibex_tiny_soc.i_mem_top.i_rv_core_ibex.u_core.u_ibex_core.pc_id" \
    "top.ibex_tiny_soc.i_mem_top.i_rv_core_ibex.u_core.u_ibex_core.pc_id_t0" \
]

gtkwave::addSignalsFromList $signals