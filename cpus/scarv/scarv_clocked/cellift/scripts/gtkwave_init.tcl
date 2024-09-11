set signals [list \
    "top.clk_i" \
    "top.rst_ni" \
    "top.scarv_tiny_soc.instr_mem_req" \
    "top.scarv_tiny_soc.instr_mem_gnt" \
    "top.scarv_tiny_soc.instr_mem_addr" \
    "top.scarv_tiny_soc.instr_mem_wdata" \
    "top.scarv_tiny_soc.instr_mem_strb" \
    "top.scarv_tiny_soc.instr_mem_we" \
    "top.scarv_tiny_soc.instr_mem_rdata" \
    "top.scarv_tiny_soc.instr_mem_req_t0" \
    "top.scarv_tiny_soc.instr_mem_gnt_t0" \
    "top.scarv_tiny_soc.instr_mem_addr_t0" \
    "top.scarv_tiny_soc.instr_mem_wdata_t0" \
    "top.scarv_tiny_soc.instr_mem_strb_t0" \
    "top.scarv_tiny_soc.instr_mem_we_t0" \
    "top.scarv_tiny_soc.instr_mem_rdata_t0" \
]

gtkwave::addSignalsFromList $signals