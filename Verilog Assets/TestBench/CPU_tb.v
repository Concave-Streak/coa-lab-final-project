`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.10.2024 14:35:16
// Design Name: 
// Module Name: CPU_tb
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


module CPU_tb(

    );
    
    reg clk, rst, continue;
    wire [31:0] debug;
    
    CPU threadripper3990wx(clk, rst, continue, pwr, halted, debug);
    
    initial begin
        clk = 0;
        continue = 0;
        rst = 0;
        #2
        rst = 1;
        #2
        rst = 0;
        
    end
    
    always begin
        #1 clk = ~clk;
    end
    
    
    
endmodule
