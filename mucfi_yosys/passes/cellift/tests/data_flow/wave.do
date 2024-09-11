onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /test_module_tb/clk
add wave -noupdate /test_module_tb/rst
add wave -noupdate /test_module_tb/d1
add wave -noupdate /test_module_tb/d2
add wave -noupdate /test_module_tb/c1
add wave -noupdate /test_module_tb/c2
add wave -noupdate /test_module_tb/out1
add wave -noupdate /test_module_tb/out2
add wave -noupdate /test_module_tb/out1_valid
add wave -noupdate /test_module_tb/out2_valid
add wave -noupdate /test_module_tb/out1_t0
add wave -noupdate /test_module_tb/d1_t0
add wave -noupdate /test_module_tb/c1_t0
add wave -noupdate /test_module_tb/c2_t0
add wave -noupdate /test_module_tb/out2_valid_t0
add wave -noupdate /test_module_tb/out2_t0
add wave -noupdate /test_module_tb/out1_valid_t0
add wave -noupdate /test_module_tb/d2_t0
add wave -noupdate /test_module_tb/rst_t0
add wave -noupdate /test_module_tb/uut/d3
add wave -noupdate /test_module_tb/uut/d3_t0
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {67 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 185
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
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
WaveRestoreZoom {0 ns} {86 ns}
