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
    output tx,
    input rx,
    output [6:0] SEG,
    output [7:0] AN,
    output DP
    );    
    not n(reset, nreset);
    wire [31:0] debug;

    SOC P(clk, reset, continue, pwr, halted, debug, tx, rx);
    
    seg_disp disp(debug, clk, SEG, AN, DP);
endmodule

module SOC(
    input clk,
    input reset,
    input continue,
    output pwr,
    output halted,
    output [31:0] debug,
    output tx,
    input rx
);
    
    wire [31:0] addr_bus, data_bus;
    
    wire En, Wen, MemEn, ioEn;   
    
    CPU EPYC_Rome(clk, reset, continue, pwr, halted, debug, En, Wen, addr_bus, data_bus);
    
    assign MemEn = ~addr_bus[12];
    data_mem DM(clk, addr_bus, MemEn, Wen, data_bus);
    
    assign ioEn = addr_bus[12];
    IO_wrapper io(clk, reset, addr_bus, data_bus, ioEn, Wen, tx, rx);
    
endmodule