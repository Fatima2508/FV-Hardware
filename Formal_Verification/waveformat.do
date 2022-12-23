onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench/clk1
add wave -noupdate /testbench/clk2
add wave -noupdate /testbench/core_0/clk1_delay
add wave -noupdate /testbench/core_0/clk1_delay_meta
add wave -noupdate /testbench/core_0/clk1_edge_detected
add wave -noupdate /testbench/core_0/curr_state
add wave -noupdate /testbench/core_0/n_out
add wave -noupdate /testbench/core_0/cmem_addr_fsm
add wave -noupdate /testbench/rstn
add wave -noupdate /testbench/start
add wave -noupdate /testbench/din
add wave -noupdate /testbench/valid_in
add wave -noupdate /testbench/cin
add wave -noupdate /testbench/caddr
add wave -noupdate /testbench/cload
add wave -noupdate /testbench/dout
add wave -noupdate /testbench/valid_out
add wave -noupdate -radix unsigned /testbench/i
add wave -noupdate -radix unsigned /testbench/j
add wave -noupdate /testbench/fir_expected_out
add wave -noupdate -radix unsigned /testbench/error_count
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 223
configure wave -valuecolwidth 89
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
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ns} {12 ns}
