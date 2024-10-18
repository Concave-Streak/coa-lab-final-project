`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.10.2024 22:16:20
// Design Name: 
// Module Name: cpu_wrapper
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


module cpu_wrapper(
    input clk,
    input reset,
    input continue,
    output pwr,
    output halted,
    output [6:0] SEG,
    output [7:0] AN,
    output DP
    );
    wire [31:0] debug, outdec;
    CPU EPYC_Rome(clk, reset, continue, pwr, halted, debug);
    bin32_to_bcd(debug, outdec)
    seg_disp disp(outdec, clk, SEG, AN, DP);
endmodule
