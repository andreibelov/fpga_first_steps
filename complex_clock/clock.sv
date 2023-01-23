module clock#()
    (
        //////////// CLOCK //////////
        input MAX10_CLK2_50,

        //////////// SEG7 //////////
        output[7:0] HEX0,
        output[7:0] HEX1,
        output[7:0] HEX2,
        output[7:0] HEX3,
        output[7:0] HEX4,
        output[7:0] HEX5,

        //////////// KEY //////////
        // verilator lint_off UNUSED
        input[1:0] KEY
        // verilator lint_on UNUSED

    );

//=======================================================
//  REG/WIRE/LOGIC declarations
//=======================================================
    logic resrt_n;

    logic[3:0] minLeft, minRight;
    logic[3:0] secLeft, secRight;
    logic[3:0] hourLeft, hourRight;

    logic[5:0] second, minute, hour;
    logic sec_strobe, min_strobe, hour_strobe;

    assign resrt_n = KEY[0];

    localparam COUNT_LIMIT = 50_000_000;

    logic[$clog2(COUNT_LIMIT)-1:0] counter;

    // behavioural
    always_ff @(posedge MAX10_CLK2_50 or negedge resrt_n)
        begin
            sec_strobe <= '0;
            if (!resrt_n) begin
                counter <= '0;
            end
            else begin
                if (counter == 5)
                    begin
                        counter <= '0;
                        sec_strobe <= '1;
                    end
                else
                    begin
                        counter <= counter+1;
                    end
            end
        end


    Counter secs(
        .iClk(MAX10_CLK2_50),
        .iRst(resrt_n),
        .iEn(sec_strobe),
        .oStrb(min_strobe),
        .oValue(second));

    Counter mins(
        .iClk(MAX10_CLK2_50),
        .iRst(resrt_n),
        .iEn(min_strobe),
        .oStrb(hour_strobe),
        .oValue(minute));

    Counter hours(
        .iClk(MAX10_CLK2_50),
        .iRst(resrt_n),
        .iEn(hour_strobe),
        // verilator lint_off PINCONNECTEMPTY
        .oStrb(),
        // verilator lint_on PINCONNECTEMPTY
        .oValue(hour)
    );

    split_output sec(second, secLeft, secRight);
    split_output min(minute, minLeft, minRight);
    split_output hr(hour, hourLeft, hourRight);

    SEG7_LUT u0(HEX0, secRight, 1);
    SEG7_LUT u1(HEX1, secLeft, 1);

    SEG7_LUT u2(HEX2, minRight, 0);
    SEG7_LUT u3(HEX3, minLeft, 1);

    SEG7_LUT u4(HEX4, hourRight, 0);
    SEG7_LUT u5(HEX5, hourLeft, 1);

endmodule : clock
