transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/flip_/Documents/GitHub/ENGG56_PCID_TRABALHO/questao_2 {C:/Users/flip_/Documents/GitHub/ENGG56_PCID_TRABALHO/questao_2/TOP.v}
vlog -vlog01compat -work work +incdir+C:/Users/flip_/Documents/GitHub/ENGG56_PCID_TRABALHO/questao_2 {C:/Users/flip_/Documents/GitHub/ENGG56_PCID_TRABALHO/questao_2/Registrador_B.v}
vlog -vlog01compat -work work +incdir+C:/Users/flip_/Documents/GitHub/ENGG56_PCID_TRABALHO/questao_2 {C:/Users/flip_/Documents/GitHub/ENGG56_PCID_TRABALHO/questao_2/Registrador_A.v}
vlog -vlog01compat -work work +incdir+C:/Users/flip_/Documents/GitHub/ENGG56_PCID_TRABALHO/questao_2 {C:/Users/flip_/Documents/GitHub/ENGG56_PCID_TRABALHO/questao_2/FSM.v}
vlog -vlog01compat -work work +incdir+C:/Users/flip_/Documents/GitHub/ENGG56_PCID_TRABALHO/questao_2 {C:/Users/flip_/Documents/GitHub/ENGG56_PCID_TRABALHO/questao_2/FA4.v}
vlog -vlog01compat -work work +incdir+C:/Users/flip_/Documents/GitHub/ENGG56_PCID_TRABALHO/questao_2 {C:/Users/flip_/Documents/GitHub/ENGG56_PCID_TRABALHO/questao_2/FA16.v}
vlog -vlog01compat -work work +incdir+C:/Users/flip_/Documents/GitHub/ENGG56_PCID_TRABALHO/questao_2 {C:/Users/flip_/Documents/GitHub/ENGG56_PCID_TRABALHO/questao_2/FA.v}
vlog -vlog01compat -work work +incdir+C:/Users/flip_/Documents/GitHub/ENGG56_PCID_TRABALHO/questao_2 {C:/Users/flip_/Documents/GitHub/ENGG56_PCID_TRABALHO/questao_2/Acumulador.v}
vcom -93 -work work {C:/Users/flip_/Documents/GitHub/ENGG56_PCID_TRABALHO/questao_2/memory.vhd}

vlog -vlog01compat -work work +incdir+C:/Users/flip_/Documents/GitHub/ENGG56_PCID_TRABALHO/questao_2 {C:/Users/flip_/Documents/GitHub/ENGG56_PCID_TRABALHO/questao_2/tb_memory.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  Testbench_Memory

do C:/Users/flip_/Documents/GitHub/ENGG56_PCID_TRABALHO/questao_2/wave_tb_memory.do
