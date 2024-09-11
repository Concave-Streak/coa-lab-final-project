`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.09.2024 16:38:52
// Design Name: 
// Module Name: _FULL_ADDER_2b
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


module _FULL_ADDER_2b(
    output [1:0] sum,
    output c_out,
    input [1:0] a,
    input [1:0] b,
    input c_in
    );
    _FULL_ADDER fa0(sum[0], t0, a[0], b[0], c_in);
    _FULL_ADDER fa1(sum[1], c_out, a[1], b[1], t0);
endmodule
