onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {Estados FSM}
add wave -noupdate /TB_FSM_Control/DUV/EstadoAtual
add wave -noupdate /TB_FSM_Control/DUV/EstadoFuturo
add wave -noupdate -divider Entradas
add wave -noupdate /TB_FSM_Control/Clock
add wave -noupdate /TB_FSM_Control/Reset
add wave -noupdate /TB_FSM_Control/Start
add wave -noupdate -divider Saídas
add wave -noupdate /TB_FSM_Control/u
add wave -noupdate /TB_FSM_Control/v
add wave -noupdate /TB_FSM_Control/x
add wave -noupdate /TB_FSM_Control/y
add wave -noupdate /TB_FSM_Control/Read_Enable
add wave -noupdate /TB_FSM_Control/Address
add wave -noupdate /TB_FSM_Control/Active_MAC
add wave -noupdate /TB_FSM_Control/Ready
add wave -noupdate -divider {Registradores aux}
add wave -noupdate /TB_FSM_Control/DUV/U_Atual
add wave -noupdate /TB_FSM_Control/DUV/V_Atual
add wave -noupdate /TB_FSM_Control/DUV/X_Atual
add wave -noupdate /TB_FSM_Control/DUV/Y_Atual
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 84
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
WaveRestoreZoom {0 ps} {145776 ps}
