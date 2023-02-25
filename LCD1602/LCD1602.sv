module huayuandianzi (CLOCK_50, LCD_DATA, LCD_RW, LCD_RS,LCD_EN);
    input CLOCK_50;
    input iRst_L;
    output [7:0]LCD_DATA;
    output LCD_RW;
    output LCD_RS;
    output LCD_EN;
    wire  [7:0]LCD_DATA;
    reg  LCD_RW ;
    reg  LCD_RS;
    reg  LCD_EN;
    reg  clk_1k=1'b0;
    reg [15:0]counter=0;
    reg [9:0]counter1=0;

    wire [7:0]MISO;

    wire RX_DV;
    wire TX_DV;

    always@(posedge CLOCK_50)
        if(counter==25000)
            begin
                clk_1k<=~clk_1k;
                counter<=0;
            end
        else
            counter<=counter+1;

    always@(posedge clk_1k)//
        begin
            if(counter1<1023)
                counter1<=counter1+1;
        end

    SPI_Slave slave(
        // Control/Data Signals,
        .i_Rst_L(iRst_L),    // FPGA Reset, active low
        .i_Clk(CLOCK_50),      // FPGA Clock
        .o_RX_DV(RX_DV),    // Data Valid pulse (1 clock cycle)
        .o_RX_Byte(LCD_DATA),  // Byte received on MOSI
        .i_TX_DV(TX_DV),    // Data Valid pulse to register i_TX_Byte
        .i_TX_Byte(MISO),  // Byte to serialize to MISO.

        // SPI Interface
        .i_SPI_Clk(),
        .o_SPI_MISO(),
        .i_SPI_MOSI(),
        .i_SPI_CS_n()        // active low
    );

endmodule
