module top (
    inout wire          cpldbus,
    input bit           ale,
    input bit           rd,
    input bit           wr,
    output reg[7:0]     data_out,
    input reg           data_in
);

    logic[15:0]               addr;
    logic[7:0]                data;

    always_ff @ (posedge ale, posedge wr)
        begin
            if (ale) addr = cpldbus; // when ale is true latch the address
            if (wr)
                begin
                    if (addr == 0) outbit = cpldbus;
                    if (addr == 1) outbit = cpldbus;
                end
        end

    assign# 1ns cpldbus = (rd) ? data : 8'bZ;

    always_ff @ (posedge rd)
        begin
            if (addr == 2) data = inbit;
            if (addr == 3) data = inbit;
        end

endmodule
