onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider TOP
add wave -noupdate -radix hexadecimal /Testbench_Memory/dut/Clock
add wave -noupdate -radix hexadecimal /Testbench_Memory/dut/Reset
add wave -noupdate -radix hexadecimal /Testbench_Memory/dut/Ready
add wave -noupdate -radix hexadecimal /Testbench_Memory/dut/DataOut
add wave -noupdate -radix hexadecimal /Testbench_Memory/dut/DataIN
add wave -noupdate -radix hexadecimal /Testbench_Memory/dut/ReadEnable
add wave -noupdate -radix hexadecimal /Testbench_Memory/dut/WriteEnable
add wave -noupdate -radix hexadecimal /Testbench_Memory/dut/Address
add wave -noupdate -radix hexadecimal /Testbench_Memory/dut/Acumulador_DataOut
add wave -noupdate -radix hexadecimal /Testbench_Memory/dut/Load
add wave -noupdate -radix hexadecimal /Testbench_Memory/dut/Clear
add wave -noupdate -radix hexadecimal /Testbench_Memory/dut/Transfer
add wave -noupdate -radix hexadecimal /Testbench_Memory/dut/Reset
add wave -noupdate -divider FSM
add wave -noupdate -radix hexadecimal /Testbench_Memory/dut/fsm/Address
add wave -noupdate -radix hexadecimal /Testbench_Memory/dut/fsm/next_state
add wave -noupdate -radix hexadecimal /Testbench_Memory/dut/fsm/current_state
add wave -noupdate -radix hexadecimal /Testbench_Memory/dut/fsm/block_counter
add wave -noupdate -radix hexadecimal /Testbench_Memory/dut/fsm/acc_counter
add wave -noupdate -divider RAM
add wave -noupdate -radix hexadecimal /Testbench_Memory/sram_inst/address
add wave -noupdate -radix hexadecimal /Testbench_Memory/sram_inst/clock
add wave -noupdate -radix hexadecimal -childformat {{/Testbench_Memory/sram_inst/data(15) -radix hexadecimal} {/Testbench_Memory/sram_inst/data(14) -radix hexadecimal} {/Testbench_Memory/sram_inst/data(13) -radix hexadecimal} {/Testbench_Memory/sram_inst/data(12) -radix hexadecimal} {/Testbench_Memory/sram_inst/data(11) -radix hexadecimal} {/Testbench_Memory/sram_inst/data(10) -radix hexadecimal} {/Testbench_Memory/sram_inst/data(9) -radix hexadecimal} {/Testbench_Memory/sram_inst/data(8) -radix hexadecimal} {/Testbench_Memory/sram_inst/data(7) -radix hexadecimal} {/Testbench_Memory/sram_inst/data(6) -radix hexadecimal} {/Testbench_Memory/sram_inst/data(5) -radix hexadecimal} {/Testbench_Memory/sram_inst/data(4) -radix hexadecimal} {/Testbench_Memory/sram_inst/data(3) -radix hexadecimal} {/Testbench_Memory/sram_inst/data(2) -radix hexadecimal} {/Testbench_Memory/sram_inst/data(1) -radix hexadecimal} {/Testbench_Memory/sram_inst/data(0) -radix hexadecimal}} -subitemconfig {/Testbench_Memory/sram_inst/data(15) {-height 15 -radix hexadecimal} /Testbench_Memory/sram_inst/data(14) {-height 15 -radix hexadecimal} /Testbench_Memory/sram_inst/data(13) {-height 15 -radix hexadecimal} /Testbench_Memory/sram_inst/data(12) {-height 15 -radix hexadecimal} /Testbench_Memory/sram_inst/data(11) {-height 15 -radix hexadecimal} /Testbench_Memory/sram_inst/data(10) {-height 15 -radix hexadecimal} /Testbench_Memory/sram_inst/data(9) {-height 15 -radix hexadecimal} /Testbench_Memory/sram_inst/data(8) {-height 15 -radix hexadecimal} /Testbench_Memory/sram_inst/data(7) {-height 15 -radix hexadecimal} /Testbench_Memory/sram_inst/data(6) {-height 15 -radix hexadecimal} /Testbench_Memory/sram_inst/data(5) {-height 15 -radix hexadecimal} /Testbench_Memory/sram_inst/data(4) {-height 15 -radix hexadecimal} /Testbench_Memory/sram_inst/data(3) {-height 15 -radix hexadecimal} /Testbench_Memory/sram_inst/data(2) {-height 15 -radix hexadecimal} /Testbench_Memory/sram_inst/data(1) {-height 15 -radix hexadecimal} /Testbench_Memory/sram_inst/data(0) {-height 15 -radix hexadecimal}} /Testbench_Memory/sram_inst/data
add wave -noupdate -radix hexadecimal /Testbench_Memory/sram_inst/rden
add wave -noupdate -radix hexadecimal /Testbench_Memory/sram_inst/wren
add wave -noupdate -radix hexadecimal -childformat {{/Testbench_Memory/sram_inst/q(15) -radix hexadecimal} {/Testbench_Memory/sram_inst/q(14) -radix hexadecimal} {/Testbench_Memory/sram_inst/q(13) -radix hexadecimal} {/Testbench_Memory/sram_inst/q(12) -radix hexadecimal} {/Testbench_Memory/sram_inst/q(11) -radix hexadecimal} {/Testbench_Memory/sram_inst/q(10) -radix hexadecimal} {/Testbench_Memory/sram_inst/q(9) -radix hexadecimal} {/Testbench_Memory/sram_inst/q(8) -radix hexadecimal} {/Testbench_Memory/sram_inst/q(7) -radix hexadecimal} {/Testbench_Memory/sram_inst/q(6) -radix hexadecimal} {/Testbench_Memory/sram_inst/q(5) -radix hexadecimal} {/Testbench_Memory/sram_inst/q(4) -radix hexadecimal} {/Testbench_Memory/sram_inst/q(3) -radix hexadecimal} {/Testbench_Memory/sram_inst/q(2) -radix hexadecimal} {/Testbench_Memory/sram_inst/q(1) -radix hexadecimal} {/Testbench_Memory/sram_inst/q(0) -radix hexadecimal}} -subitemconfig {/Testbench_Memory/sram_inst/q(15) {-height 15 -radix hexadecimal} /Testbench_Memory/sram_inst/q(14) {-height 15 -radix hexadecimal} /Testbench_Memory/sram_inst/q(13) {-height 15 -radix hexadecimal} /Testbench_Memory/sram_inst/q(12) {-height 15 -radix hexadecimal} /Testbench_Memory/sram_inst/q(11) {-height 15 -radix hexadecimal} /Testbench_Memory/sram_inst/q(10) {-height 15 -radix hexadecimal} /Testbench_Memory/sram_inst/q(9) {-height 15 -radix hexadecimal} /Testbench_Memory/sram_inst/q(8) {-height 15 -radix hexadecimal} /Testbench_Memory/sram_inst/q(7) {-height 15 -radix hexadecimal} /Testbench_Memory/sram_inst/q(6) {-height 15 -radix hexadecimal} /Testbench_Memory/sram_inst/q(5) {-height 15 -radix hexadecimal} /Testbench_Memory/sram_inst/q(4) {-height 15 -radix hexadecimal} /Testbench_Memory/sram_inst/q(3) {-height 15 -radix hexadecimal} /Testbench_Memory/sram_inst/q(2) {-height 15 -radix hexadecimal} /Testbench_Memory/sram_inst/q(1) {-height 15 -radix hexadecimal} /Testbench_Memory/sram_inst/q(0) {-height 15 -radix hexadecimal}} /Testbench_Memory/sram_inst/q
add wave -noupdate -divider Acumulador
add wave -noupdate -radix hexadecimal /Testbench_Memory/dut/acumulador/B
add wave -noupdate -radix hexadecimal /Testbench_Memory/dut/acumulador/A
add wave -noupdate -radix hexadecimal /Testbench_Memory/dut/acumulador/S
add wave -noupdate -radix hexadecimal /Testbench_Memory/dut/acumulador/COut
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2843694 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 118
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
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {2800000 ps}
