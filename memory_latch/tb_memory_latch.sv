module test ();

    localparam time PERIOD = (1.0e9/14.7456e6)*1ns;

    wire         cpubus;

    bit            ale;
    bit            rd;
    bit            wr;
    reg         outbit;
    reg         inbit;

    logic  data;

    // DUT
    top u1(
        .cpldbus(cpubus),
        .ale,
        .rd,
        .wr,
        .outbit,
        .inbit
    );

    initial
        begin
            // put some dummy data on inbit
            inbit = 8'h33;
            // Stimulus
            //$stop; // to allow signal setup on wave page

            // Write A5 to addr 0
            # PERIOD data = 0;
            # PERIOD ale = 1;
            # PERIOD ale = 0;
            # PERIOD data = 8'hA5;
            # PERIOD wr = 1;
            # PERIOD wr = 0;

            // Write 5A to addr 1
            # PERIOD data = 1;
            # PERIOD ale = 1;
            # PERIOD ale = 0;
            # PERIOD data = 8'h5A;
            # PERIOD wr = 1;
            # PERIOD wr = 0;

            // Read addr 2
            # PERIOD data = 2;
            # PERIOD ale = 1;
            # PERIOD ale = 0;
            # PERIOD rd = 1;
            # PERIOD rd = 0;
        end
    assign# 1ps cpubus = (ale || wr) ? data : 8'bZ;

endmodule