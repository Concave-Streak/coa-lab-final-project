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

    wire En, Wen, MemEn, ioWen, ioRen;   
    wire [31:0] addr_out, data_read, data_write, data_read_mem, data_read_io;
    
    CPU EPYC_Rome(clk, reset, continue, pwr, halted, debug, En, Wen, addr_out, data_read, data_write);
    
    assign MemEn = En & ~addr_out[12];   
    tristate_buffer #32 tbm(data_read_mem, MemEn, data_read);
    data_mem DM(clk, addr_out, MemEn, Wen, data_write, data_read_mem);
    
    assign ioEn = En & addr_out[12];
    assign ioWen = addr_out[12] & En & Wen;
    assign ioRen = addr_out[12] & En & ~Wen;
    tristate_buffer #32 tbio(data_read_io, ioEn, data_read);  
    UART_IO io(clk, reset, addr_out[3:0], data_write, data_read_io, ioWen, ioRen, tx, rx);
    
endmodule