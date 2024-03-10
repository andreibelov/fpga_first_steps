// *****************************************************************
// *** FIFO_3word_0_latency.sv V1.0, July 6, 2020
// ***
// *** This 3 word + 1 reserve word Zero latency FIFO
// *** with look ahead data and status flags outputs was
// *** written by Brian Guralnick.
// ***
// *** See the included 'FIFO_0_latency.png' simulation for functionality.
// ***
// *** Using System Verilog code which only uses synchronous logic.
// *** Well commented for educational purposes.
// *****************************************************************

module FIFO_3word_0_latency
    (

        input wire clk,                  // CLK input
        input wire reset,                // reset FIFO

        input wire shift_in,            // load a word into the FIFO.
        input wire shift_out,           // shift data out of the FIFO.
        input wire[bits-1:0] data_in,  // data word input.

        output wire fifo_not_empty,      // High when there is data available.
        output wire fifo_full,           // High when the FIFO is 3 words full.
        // *** Note the FIFO has 1 extra word of free space after
        // *** the fifo_full flag goes high, so it's actually a 4 word FIFO.

        output wire[bits-1:0] data_out  // FIFO data word output
    );

    parameter bits = 8;             // sets the width of the fifo
    parameter zero_latency = 1;      // When set to 1, if the FIFO is empty, the data_out and fifo_empty flag will
    // immediately reflect the state of the inputs data_in and shift_in, 0 clock cycle delay.
    // When set to 0, like a normal synchronous FIFO, It will take 1 clock cycle before the
    // fifo_empty flag goes high and the data_out will have a copy of the data_in after a 'shift_in'.

    reg[bits-1:0] fifo_data_reg[3:0];                  // FIFO memory
    reg[2:0] fifo_wr_pos, fifo_rd_pos, fifo_size; // the amount of data stored in the fifo


    assign data_out = (fifo_size == 0) && (zero_latency) ? data_in:fifo_data_reg[fifo_rd_pos[1:0]]; // When FIFO is empty and parameter zero_latency = 1,
    // bypass the memory registers and wire the output directly to the input.
    // Otherwise show the correct FIFO memory register once it is latched.

    assign fifo_not_empty = (fifo_size != 0) || (zero_latency && shift_in);             // While the FIFO is empty and zero_latency = 1, directly wire
    // 'fifo_not_empty' output to the 'shift_in' input.  Otherwise,
    assign fifo_full = (fifo_size >= 3'd3);                                        // only set high once there is data in the FIFO.

    always @(posedge clk) begin

        if (reset) begin

            fifo_data_reg[0] <= 0;  // clear the FIFO's memory contents
            fifo_data_reg[1] <= 0;  // clear the FIFO's memory contents
            fifo_data_reg[2] <= 0;  // clear the FIFO's memory contents
            fifo_data_reg[3] <= 0;  // clear the FIFO's memory contents

            fifo_rd_pos <= 3'd0;      // reset the FIFO memory counter
            fifo_wr_pos <= 3'd0;      // reset the FIFO memory counter
            fifo_size <= 3'd0;      // reset the FIFO memory counter

        end else begin

            if (shift_in && ~shift_out) fifo_size <= fifo_size+1'b1; // Calculate the number of words stored in the FIFO
            else if (~shift_in && shift_out) fifo_size <= fifo_size-1'b1;

            if (shift_in) begin
                fifo_wr_pos <= fifo_wr_pos+1'b1;
                fifo_data_reg[fifo_wr_pos[1:0]] <= data_in;
            end
            if (shift_out) begin
                fifo_rd_pos <= fifo_rd_pos+1'b1;
            end

        end // ~reset

    end // always @ (posedge clk) begin
endmodule

