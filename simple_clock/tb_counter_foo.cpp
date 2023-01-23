// Verilator Example
// Norbertas Kremeris 2021
#include <cstdlib>
#include <iostream>
#include <verilated.h>
#include <verilated_vcd_c.h>
#include "Vcounter_foo.h"

#define MAX_SIM_TIME 300
#define OUTPUT_FILE "waveform.vcd"
vluint64_t sim_time = 0;

int main(int argc, char** argv, char** env) {

    auto *dut = new Vcounter_foo;

    Verilated::traceEverOn(true);
    auto *m_trace = new VerilatedVcdC;
    dut->trace(m_trace, 5);
    m_trace->open(OUTPUT_FILE);

    while (sim_time < MAX_SIM_TIME) {

        dut->iRst = 1;
        dut->iEn = 1;

        if(sim_time > 1 && sim_time < 5){
            dut->iRst = 0;
            dut->iEn = 0;
        }

        dut->iClk ^= 1;
        dut->eval();
        m_trace->dump(sim_time);
        sim_time++;
    }

    m_trace->close();
    delete dut;
    exit(EXIT_SUCCESS);
}
