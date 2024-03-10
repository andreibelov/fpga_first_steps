module noop_spi
    (
        input   .i_Res(Res),      // Display reset
        input   .i_CS1_n(CS1_n),    // Chip select1
        input   .i_DC(DC),       // Data/Command
        input   .i_CS2_n(),    // Chip select2
        input   .i_D0(D0),       // SCLK
        input   .i_D1(D1),       // SDIN

        output  .o_Res(Res),      // Display reset
        output  .o_CS1_n(CS1_n),    // Chip select1
        output  .o_DC(DC),       // Data/Command
        output  .o_CS2_n(),    // Chip select2
        output  .o_D0(D0),       // SCLK
        output  .o_D1(D1)       // SDIN
    );
//=======================================================
//  REG/WIRE declarations
//=======================================================
    wire Res;
    wire CS1_n;
    wire DC;
    wire D0;
    wire D1;

    reg i_CS2_n;
    reg o_CS2_n;

    assign o_CS2_n = 1'bz;

//=======================================================
//  Structural coding
//=======================================================
//=======================================================
//  REG/WIRE declarations
//=======================================================




//=======================================================
//  Structural coding
//=======================================================

endmodule : noop_spi