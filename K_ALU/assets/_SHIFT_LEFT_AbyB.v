`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.09.2024 15:15:02
// Design Name: 
// Module Name: _SHIFT_LEFT_AbyB
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


module _SHIFT_LEFT_AbyB(
    output [7:0] res,
    input [7:0] A,
    input [7:0] B
    );
    wire [7:0] out1, out2;
    _MUX_2to1_8b mux_1(out1, B[0], A, {A[6:0], 1'b0});
    _MUX_2to1_8b mux_2(out2, B[1], out1, {out1[5:0], 2'b00});
    _MUX_2to1_8b mux_4(res, B[2], out2, {out2[3:0], 4'b0000});
endmodule
