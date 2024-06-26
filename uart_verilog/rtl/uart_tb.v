/***************************************************
* File: uart_tb.v
* Author: nandland.com
* Contributor: Andrei Belov
* Class: EE 271
* Module: uart_tb
* Description: UART testbench
* File Downloaded from https://nandland.com
****************************************************/

`timescale 1ns/10ps
// This testbench will exercise both the UART Tx and Rx.
// It sends out byte 0xAB over the transmitter
// It then exercises the receive by receiving byte 0x3F
module uart_tb();

    // Testbench uses a 10 MHz clock
    // Want to interface to 115200 baud UART
    // 10000000 / 115200 = 87 Clocks Per Bit.
    parameter c_CLOCK_PERIOD_NS = 20;
    parameter c_CLKS_PER_BIT = 2;
    parameter c_BIT_PERIOD = 41;

    reg r_Clock = 0;
    reg r_Tx_DV = 0;
    wire w_Tx_Done;
    reg[7:0] r_Tx_Byte = 0;
    reg[7:0] r_Rx_Byte;
    reg r_Rx_Serial = 1;
    wire w_Tx_Serial;
    wire[7:0] w_Rx_Byte;

    // Takes in input byte and serializes it
    task UART_WRITE_BYTE;
        input[7:0] i_Data;
        integer ii;
        begin
            // Send Start Bit
            r_Rx_Serial <= 1'b0;
            #(c_BIT_PERIOD);
            // #(c_CLOCK_PERIOD_NS * 10);

            // Send Data Byte
            for (ii = 0; ii < 8; ii = ii+1)
                begin
                    r_Rx_Serial <= i_Data[ii];
                    #(c_BIT_PERIOD);
                end

            // Send Stop Bit
            r_Rx_Serial <= 1'b1;
            #(c_BIT_PERIOD);
        end
    endtask // UART_WRITE_BYTE

    uart_rx#(.CLKS_PER_BIT(c_CLKS_PER_BIT)) UART_RX_INST(
        .i_Clock(r_Clock),
        .i_Rx_Serial(r_Rx_Serial),
        .o_Rx_DV(),
        .o_Rx_Byte(w_Rx_Byte)
    );

    uart_tx#(.CLKS_PER_BIT(c_CLKS_PER_BIT)) UART_TX_INST(
        .i_Clock(r_Clock),
        .i_Tx_DV(r_Tx_DV),
        .i_Tx_Byte(r_Tx_Byte),
        .o_Tx_Active(),
        .o_Tx_Serial(w_Tx_Serial),
        .o_Tx_Done(w_Tx_Done)
    );

    always
        #(c_CLOCK_PERIOD_NS/2) r_Clock <= !r_Clock;

    // Main Testing:
    initial
        begin

            // Tell UART to send a command (exercise Tx)
            @(posedge r_Clock) r_Rx_Byte = 8'h0;
            @(posedge r_Clock);
            r_Tx_DV <= 1'b1;
            r_Tx_Byte <= 8'hAB;
            @(posedge r_Clock);
            r_Tx_DV <= 1'b0;
            @(posedge w_Tx_Done);

            // Send a command to the UART (exercise Rx)
            // https://www.javatpoint.com/verilog-timing-control
            // https://vlsiverify.com/verilog/procedural-timing-control/#a_Regular_event_control
            // In Verilog, the statement @(posedge Clock); is called a procedural timing control statement,
            @(posedge r_Clock) r_Rx_Byte = 8'h56;
            UART_WRITE_BYTE(r_Rx_Byte);
            @(posedge r_Clock);

            // Check that the correct command was received
            if (w_Rx_Byte == r_Rx_Byte)
                $display("Test Passed - Correct Byte Received");
            else
                $display("Test Failed - Incorrect Byte Received");
            $stop; // and stop.
        end
endmodule // uart_tb
