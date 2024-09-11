onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_top/instr_mem_addr
add wave -noupdate /tb_top/instr_mem_addr_t0
add wave -noupdate /tb_top/instr_mem_gnt
add wave -noupdate /tb_top/instr_mem_gnt_t0
add wave -noupdate /tb_top/instr_mem_rdata
add wave -noupdate /tb_top/instr_mem_rdata_t0
add wave -noupdate /tb_top/i_dut/i_picorv32_mem_top/i_picorv32/reg_pc
add wave -noupdate /tb_top/i_dut/i_picorv32_mem_top/i_picorv32/instr_rdcycle
add wave -noupdate /tb_top/i_dut/i_picorv32_mem_top/i_picorv32/instr_rdinstr
add wave -noupdate /tb_top/instr_mem_req
add wave -noupdate /tb_top/instr_mem_req_t0
add wave -noupdate /tb_top/instr_mem_strb
add wave -noupdate /tb_top/instr_mem_strb_t0
add wave -noupdate /tb_top/instr_mem_wdata
add wave -noupdate /tb_top/instr_mem_wdata_t0
add wave -noupdate /tb_top/instr_mem_we
add wave -noupdate /tb_top/instr_mem_we_t0
add wave -noupdate /tb_top/i_dut/i_picorv32_mem_top/i_picorv32/pcpi_rs1
add wave -noupdate /tb_top/i_dut/i_picorv32_mem_top/i_picorv32/pcpi_rs2
add wave -noupdate /tb_top/i_dut/i_picorv32_mem_top/i_picorv32/reg_out
add wave -noupdate /tb_top/i_dut/i_picorv32_mem_top/i_picorv32/decoded_rs1
add wave -noupdate /tb_top/i_dut/i_picorv32_mem_top/i_picorv32/decoded_rs2
add wave -noupdate /tb_top/i_dut/i_picorv32_mem_top/i_picorv32/decoded_rd
add wave -noupdate /tb_top/i_dut/i_picorv32_mem_top/i_picorv32/decoded_imm
add wave -noupdate /tb_top/i_dut/i_picorv32_mem_top/i_picorv32/alu_out
add wave -noupdate /tb_top/i_dut/i_picorv32_mem_top/i_picorv32/reg_sh
add wave -noupdate /tb_top/i_dut/i_picorv32_mem_top/i_picorv32/cpuregs_rs1
add wave -noupdate /tb_top/i_dut/i_picorv32_mem_top/i_picorv32/cpuregs_rs2
add wave -noupdate /tb_top/i_dut/i_picorv32_mem_top/i_picorv32/decoded_rs2
add wave -noupdate /tb_top/i_dut/i_picorv32_mem_top/i_picorv32/decoded_rs1
add wave -noupdate /tb_top/i_dut/i_picorv32_mem_top/i_picorv32/cpuregs_wrdata
add wave -noupdate {/tb_top/i_dut/i_picorv32_mem_top/i_picorv32/\cpuregs[6] }
add wave -noupdate {/tb_top/i_dut/i_picorv32_mem_top/i_picorv32/\cpuregs[7] }
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3125000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 194
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {543060 ps} {4145020 ps}
