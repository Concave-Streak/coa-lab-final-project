`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.09.2024 16:16:17
// Design Name: 
// Module Name: _FULL_ADDER
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


module _FULL_ADDER(
    output sum,
    output c_out,
    input a,
    input b,
    input c_in
    );
    wire t1, t2, t3;
    xor(t1, a, b);
    xor(sum, t1, c_in);
    and(t2, t1, c_in);
    and(t3, a, b);
    or(c_out, t3, t2);
endmodule
