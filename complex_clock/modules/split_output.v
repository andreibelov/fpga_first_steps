`timescale 1ns/1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:51:22 11/09/2015 
// Design Name: 
// Module Name:    split_output 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module split_output(
    input[5:0] total,
    output reg[3:0] left, right
);

    // verilator lint_off UNUSED
    function [3:0] trunc_6_to_4(input[5:0] val6);
        trunc_6_to_4 = val6[3:0];
    endfunction
    //verilator lint_on UNUSED

    always @* begin
        if (total < 6'd10) begin
            left = 4'b0000;
            right = total[3:0];
        end
        else if (total < 6'd20) begin
            left = 4'b0001;
            right = trunc_6_to_4(total-6'd10);
        end
        else if (total < 6'd30) begin
            left = 4'b0010;
            right = trunc_6_to_4(total-6'd20);
        end
        else if (total < 6'd40) begin
            left = 4'b0011;
            right = trunc_6_to_4(total-6'd30);
        end
        else if (total < 6'd50) begin
            left = 4'b0100;
            right = trunc_6_to_4(total-6'd40);
        end
        else if (total < 6'd60) begin
            left = 4'b0101;
            right = trunc_6_to_4(total-6'd50);
        end
        else begin // final is 'else'
            left = 4'b0110;
            right = 4'b0000;
        end
    end

endmodule