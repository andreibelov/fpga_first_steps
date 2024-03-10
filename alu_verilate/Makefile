# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: abelov <abelov@student.42london.com>       +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/03/10 18:18:04 by abelov            #+#    #+#              #
#    Updated: 2024/03/10 18:18:05 by abelov           ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# https://itsembedded.com/dhd/verilator_2/

# Verilator example makefile
MODULE=alu

sim: waveform.vcd

verilate: .stamp.verilate

build: obj_dir/V$(MODULE)

waves: waveform.vcd
	@echo
	@echo "### WAVES ###"
	gtkwave waveform.vcd -a gtkwave_setup.gtkw &

waveform.vcd: ./obj_dir/V$(MODULE)
	@echo
	@echo "### SIMULATING ###"
	./obj_dir/V$(MODULE) +verilator+rand+reset+2

./obj_dir/V$(MODULE): .stamp.verilate
	@echo
	@echo "### BUILDING SIM ###"
	make -C obj_dir -f V$(MODULE).mk V$(MODULE)

.stamp.verilate: $(MODULE).sv tb_$(MODULE).cpp
	@echo
	@echo "### VERILATING ###"
	verilator -Wall --trace --x-assign unique --x-initial unique -cc $(MODULE).sv --exe tb_$(MODULE).cpp
	@touch .stamp.verilate

lint: $(MODULE).sv
	verilator --lint-only $(MODULE).sv

clean:
	rm -rf .stamp.*;
	rm -rf ./obj_dir
	rm -rf waveform.vcd

.PHONY: sim verilate build waves lint clean
