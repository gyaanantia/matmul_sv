setenv LMC_TIMEUNIT -9
vlib work
vmap work work

# Compile
vlog -work work "../matmul.sv"
vlog -work work "../bram.sv"
vlog -work work "../bram_block.sv"
vlog -work work "../matmul_top.sv"
vlog -work work "../matmul_tb.sv"

# run simulation
vsim -classdebug -voptargs=+acc +notimingchecks -L work work.matmul_tb -wlf matmul.wlf

# waves
add wave -noupdate -group matmul_tb
add wave -noupdate -group matmul_tb -radix hexadecimal /matmul_tb/*
add wave -noupdate -group matmul_tb/mat
add wave -noupdate -group matmul_tb -radix hexadecimal /matmul_tb/mat/*
run -all