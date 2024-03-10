/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   tb_clock.cpp                                       :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: Norbertas Kremeris <marvin@42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2021/03/10 17:03:58 by abelov            #+#    #+#             */
/*   Updated: 2024/03/10 17:03:59 by abelov           ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <cstdlib>
#include <iostream>
#include <verilated.h>
#include <verilated_vcd_c.h>
#include "Vclock.h"

#define MAX_SIM_TIME 18001
#define OUTPUT_FILE "waveform.vcd"
vluint64_t sim_time = 0;

int main(int argc, char** argv, char** env) {

    auto *dut = new Vclock;

    Verilated::traceEverOn(true);
    auto *m_trace = new VerilatedVcdC;

    dut->trace(m_trace, 5);
    m_trace->open(OUTPUT_FILE);

    while (sim_time < MAX_SIM_TIME) {

        dut->KEY = 1;

        if(sim_time > 1 && sim_time < 5){
            dut->KEY = 0;
        }

        dut->MAX10_CLK2_50 ^= 1;
        dut->eval();
        m_trace->dump(sim_time);
        sim_time++;
    }

    m_trace->close();
    delete dut;
    exit(EXIT_SUCCESS);
}
