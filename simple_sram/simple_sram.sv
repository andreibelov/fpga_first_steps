/***************************************************
* File: simple_sram.sv
* Author: Andrei Belov
* Class: EE 271
* Module: simple_sram
* Description: Simple SRAM circuit
****************************************************/

module simple_sram
    #(
        parameter ADDR_WIDTH=8,
        parameter DATA_WIDTH=8
    )
    (
        input logic[ADDR_WIDTH-1:0] i_addr,
        input i_CS,
        input i_WE,
        input i_OE,
        inout logic[DATA_WIDTH-1:0] bi_data
    );
    /* verilator lint_off UNOPTFLAT */
    reg[DATA_WIDTH-1:0] Mem[0:(1 << ADDR_WIDTH)-1];
    /* verilator lint_on UNOPTFLAT */
    assign bi_data = (!i_CS && !i_OE) ? Mem[i_addr]:{DATA_WIDTH{1'bz}};

    always @(i_CS or i_WE)
        if (!i_CS && !i_WE)
            Mem[i_addr] = bi_data;

    always @(i_WE or i_OE)
        if (!i_WE && !i_OE)
            $display("Operational error in simple_sram: i_OE and i_WE both active");

endmodule : simple_sram
