module SEG7_LUT	( oSEG,iDIG,iDOT );
    input	[3:0]	iDIG;
    input	iDOT;
    output	[7:0]	oSEG;
    reg		[7:0]	oSEG;

    always @(iDIG, iDOT)
    begin
        case(iDIG)
        4'h1: oSEG = { iDOT, 7'b1111001 };	// ---t----
        4'h2: oSEG = { iDOT, 7'b0100100 }; 	// |	  |
        4'h3: oSEG = { iDOT, 7'b0110000 }; 	// lt	 rt
        4'h4: oSEG = { iDOT, 7'b0011001 }; 	// |	  |
        4'h5: oSEG = { iDOT, 7'b0010010 }; 	// ---m----
        4'h6: oSEG = { iDOT, 7'b0000010 }; 	// |	  |
        4'h7: oSEG = { iDOT, 7'b1111000 }; 	// lb	 rb
        4'h8: oSEG = { iDOT, 7'b0000000 }; 	// |	  |
        4'h9: oSEG = { iDOT, 7'b0011000 }; 	// ---b----
        4'ha: oSEG = { iDOT, 7'b0001000 };
        4'hb: oSEG = { iDOT, 7'b0000011 };
        4'hc: oSEG = { iDOT, 7'b1000110 };
        4'hd: oSEG = { iDOT, 7'b0100001 };
        4'he: oSEG = { iDOT, 7'b0000110 };
        4'hf: oSEG = { iDOT, 7'b0001110 };
        4'h0: oSEG = { iDOT, 7'b1000000 };
        endcase
    end

endmodule
