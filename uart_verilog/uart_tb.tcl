transcript on

if { [file exists rtl_work] } {
	puts "Project folder 'rtl_work' already exists"
	vdel -lib rtl_work -all
}

vlib rtl_work
vmap work rtl_work

if { [file exists uart_tb.mpf] } {
	puts "Project 'uart_tb' already exists opening"
	project open uart_tb
	project compileall
} else {
	puts "Creating new project library 'rtl_work'"
	# Create a new project

	project new . uart_tb rtl_work
	project addfile rtl/uart_rx.v
	project addfile rtl/uart_tx.v
	project addfile rtl/uart_tb.v
	project compileall
}

# Compile the project
vlog -vlog01compat -work rtl_work +incdir+rtl {rtl/uart_rx.v}
vlog -vlog01compat -work rtl_work +incdir+rtl {rtl/uart_tx.v}
vlog -vlog01compat -work rtl_work +incdir+rtl {rtl/uart_tb.v}

# Open the project for simulation
vsim -work rtl_work \
	-t 1ns \
	-L altera_ver \
	-L lpm_ver \
	-L sgate_ver \
	-L altera_mf_ver \
	-L altera_lnsim_ver \
	-L fiftyfivenm_ver \
	-L rtl_work \
	-L work \
	-voptargs="+acc -sv -timescale=1ns/10ps" \
	uart_tb

# https://stackoverflow.com/questions/56306120/how-to-specify-height-of-waveform-in-modelsim-questasim
add wave -height 40 -position insertpoint -radix hex \
	sim:/uart_tb/r_Tx_DV \
	sim:/uart_tb/w_Tx_Done \
	sim:/uart_tb/r_Tx_Byte \
	sim:/uart_tb/w_Tx_Serial \
	sim:/uart_tb/r_Rx_Byte \
	sim:/uart_tb/r_Rx_Serial \
	sim:/uart_tb/w_Rx_Byte
add wave -height 40 -position top -color gold \
	sim:/uart_tb/r_Clock
view structure
view signals
run -all
wave zoom full