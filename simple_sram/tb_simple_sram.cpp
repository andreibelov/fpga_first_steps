// Verilator Example
// Norbertas Kremeris 2021
#include <cstdlib>
#include <iostream>
#include <verilated.h>
#include <verilated_vcd_c.h>
#include "Vsimple_sram.h"

#define MAX_SIM_TIME 300
#define OUTPUT_FILE "waveform.vcd"
vluint64_t sim_time = 0;

int main(void) {

    auto *dut = new Vsimple_sram;

    Verilated::traceEverOn(true);
    auto *m_trace = new VerilatedVcdC;
    dut->trace(m_trace, 5);
    m_trace->open(OUTPUT_FILE);

    while (sim_time < MAX_SIM_TIME) {
        dut->i_addr = 0xFF;
        dut->bi_data = 0xFF;
		dut->i_CS = 1;
		dut->i_WE = 1;
		m_trace->dump(sim_time);
		dut->i_WE = 0;
		sim_time++;
    }

    m_trace->close();
    delete dut;
    exit(EXIT_SUCCESS);
}
