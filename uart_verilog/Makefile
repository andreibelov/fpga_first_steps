MODELSIM_DIR := ~/intelFPGA_lite/18.1/modelsim_ase/linuxaloem
QUARTUS_DIR  := ~/intelFPGA_lite/18.1/quartus/bin
VERILATOR    := /usr/bin/verilator
MAKE_JOBS    := -j4 -l8

uart_tb: uart_tb.v
	$(MODELSIM_DIR)/vsim -do $@.do

.PHONY: uart_tb.v
