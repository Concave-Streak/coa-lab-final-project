`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.09.2024 16:42:38
// Design Name: 
// Module Name: _FULL_ADDER_3b
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


module _FULL_ADDER_3b(
    output [2:0] sum,
    output c_out,
    input [2:0] a,
    input [2:0] b,
    input c_in
    );
    wire t0;
    _FULL_ADDER_2b fa2b1(sum[1:0], t0, a[1:0], b[1:0], c_in);
    _FULL_ADDER fa1(sum[2], c_out, a[2], b[2], t0);
endmodule
