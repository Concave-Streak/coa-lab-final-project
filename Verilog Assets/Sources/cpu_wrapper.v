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
    input nreset,
    input continue,
    output pwr,
    output halted,
    output [6:0] SEG,
    output [7:0] AN,
    output DP
    );
    not n(reset, nreset);
    wire [31:0] debug;
    
    wire MemEn, MemWen;   
    wire [31:0] addr_out, data_in, data_out;
    
    CPU EPYC_Rome(clk, reset, continue, pwr, halted, debug, MemEn, MemWen, addr_out, data_in, data_out);
    
    data_mem DM(clk, addr_out, MemEn, MemWen, data_out, data_in);
    
    seg_disp disp(debug, clk, SEG, AN, DP);
endmodule
