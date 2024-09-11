set signals [list \
    "top.clk_i" \
    "top.rst_ni" \
    "top.picorv32_tiny_soc.instr_mem_req" \
    "top.picorv32_tiny_soc.instr_mem_gnt" \
    "top.picorv32_tiny_soc.instr_mem_addr" \
    "top.picorv32_tiny_soc.instr_mem_wdata" \
    "top.picorv32_tiny_soc.instr_mem_strb" \
    "top.picorv32_tiny_soc.instr_mem_we" \
    "top.picorv32_tiny_soc.instr_mem_rdata" \
    "top.picorv32_tiny_soc.instr_mem_req_t0" \
    "top.picorv32_tiny_soc.instr_mem_gnt_t0" \
    "top.picorv32_tiny_soc.instr_mem_addr_t0" \
    "top.picorv32_tiny_soc.instr_mem_wdata_t0" \
    "top.picorv32_tiny_soc.instr_mem_strb_t0" \
    "top.picorv32_tiny_soc.instr_mem_we_t0" \
    "top.picorv32_tiny_soc.instr_mem_rdata_t0" \
    "top.picorv32_tiny_soc.i_picorv32_mem_top.i_picorv32.next_pc" \
    "top.picorv32_tiny_soc.i_picorv32_mem_top.i_picorv32.next_pc_t0" \
]

gtkwave::addSignalsFromList $signals