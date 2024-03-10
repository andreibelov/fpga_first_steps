module oled_spi(

	//////////// CLOCK //////////
	input 		          		ADC_CLK_10,
	input 		          		MAX10_CLK1_50,
	input 		          		MAX10_CLK2_50,

	//////////// KEY //////////
	input 		     [1:0]		KEY,

	//////////// GPIO, GPIO connect to GPIO Default //////////
	inout 		    [35:0]		GPIO
);

//=======================================================
//  REG/WIRE declarations
//=======================================================




//=======================================================
//  Structural coding
//=======================================================

	noop_spi spi(
		.i_Res(Res),
		.i_CS1_n(CS1_n),
		.i_DC(DC),
		.i_CS2_n(CS2_n),
		.i_D0(D0),
		.i_D1(D1),

		.o_Res(Res),
		.o_CS1_n(CS1_n),
		.o_DC(DC),
		.o_CS2_n(CS2_n),
		.o_D0(D0),
		.o_D1(D1)
	);

endmodule : oled_spi
