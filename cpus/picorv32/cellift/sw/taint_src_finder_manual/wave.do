onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_top/i_dut/i_picorv32_mem_top/i_picorv32/resetn
add wave -noupdate /tb_top/i_dut/i_picorv32_mem_top/i_picorv32/clk
add wave -noupdate /tb_top/i_dut/i_picorv32_mem_top/i_picorv32/decoder_trigger
add wave -noupdate /tb_top/i_dut/i_picorv32_mem_top/i_picorv32/decoder_pseudo_trigger
add wave -noupdate /tb_top/i_dut/i_picorv32_mem_top/i_picorv32/mem_rdata
add wave -noupdate /tb_top/i_dut/i_picorv32_mem_top/i_picorv32/mem_rdata_latched
add wave -noupdate /tb_top/i_dut/i_picorv32_mem_top/i_picorv32/mem_rdata_latched_noshuffle
add wave -noupdate /tb_top/i_dut/i_picorv32_mem_top/i_picorv32/mem_rdata_q
add wave -noupdate /tb_top/i_dut/i_picorv32_mem_top/i_picorv32/reg_pc
add wave -noupdate /tb_top/i_dut/i_picorv32_mem_top/i_picorv32/pcpi_rs1
add wave -noupdate /tb_top/i_dut/i_picorv32_mem_top/i_picorv32/pcpi_rs2
add wave -noupdate /tb_top/i_dut/i_picorv32_mem_top/i_picorv32/alu_add_sub
add wave -noupdate /tb_top/i_dut/i_picorv32_mem_top/i_picorv32/alu_out
add wave -noupdate /tb_top/i_dut/i_picorv32_mem_top/i_picorv32/alu_out_0
add wave -noupdate /tb_top/i_dut/i_picorv32_mem_top/i_picorv32/count_cycle
add wave -noupdate /tb_top/i_dut/i_picorv32_mem_top/i_picorv32/count_instr
add wave -noupdate /tb_top/i_dut/i_picorv32_mem_top/i_picorv32/cpu_state
add wave -noupdate /tb_top/i_dut/i_picorv32_mem_top/i_picorv32/mem_ready
add wave -noupdate /tb_top/i_dut/i_picorv32_mem_top/i_picorv32/mem_xfer
add wave -noupdate /tb_top/i_dut/i_picorv32_mem_top/i_picorv32/mem_la_use_prefetched_high_word
add wave -noupdate /tb_top/i_dut/i_picorv32_mem_top/instr_mem_gnt
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {875000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
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
WaveRestoreZoom {0 ps} {3319330 ps}
