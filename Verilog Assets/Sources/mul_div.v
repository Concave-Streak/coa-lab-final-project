`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.09.2024 16:22:06
// Design Name: 
// Module Name: mul_8
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module mul_8(input [7:0] A, input [7:0] B, output [7:0] mul);
    assign mul = A * B;
endmodule

module div_8(input [7:0] A, input [7:0] B, output [7:0] div);
    assign div = A / B;
endmodule
