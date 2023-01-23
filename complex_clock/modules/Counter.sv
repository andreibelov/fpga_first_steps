module Counter #(
    parameter LIMIT = 60
)  (
    input logic iClk
    , input logic iRst
    , input logic iEn
    , output logic oStrb
    , output logic [5:0] oValue
);

    logic [$clog2(LIMIT)-1:0] counter;

    // behavioural
    always_ff @(posedge iClk, posedge iEn or negedge iRst)
        begin
            oStrb  <= '0;
            if(!iRst) begin
                counter <= '0;
            end
            else if (iEn == 1) begin
                if (counter == LIMIT-1)
                    begin
                        counter <= '0;
                        oStrb  <= '1;
                    end
                else
                    begin
                        counter <= counter + 1;
                    end
            end
        end
    assign oValue = counter;

endmodule