`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.09.2024 15:52:13
// Design Name: 
// Module Name: _SHIFT_RIGHTA_AbyB
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


module _SHIFT_RIGHTA_AbyB(
    output [7:0] res,
    input [7:0] A,
    input [7:0] B
    );
    wire [7:0] out1, out2;
    _MUX_2to1_8b mux_1(out1, B[0], A, {A[7], A[7:1]});
    _MUX_2to1_8b mux_2(out2, B[1], out1, {A[7], A[7], out1[7:2]});
    _MUX_2to1_8b mux_4(res, B[2], out2, {A[7], A[7], A[7], A[7], out2[7:4]});
endmodule
