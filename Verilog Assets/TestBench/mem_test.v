`timescale 1ns/1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.09.2024 15:24:16
// Design Name: 
// Module Name: controller_test
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


module mem_test;
    reg [2:0] code;
    reg clk, rst;
    controller uut(clk, rst, code);
    integer i;
    
    initial begin
        
        
        
        #100
        $finish;
    end
    
    always begin
        #5 clk = ~clk;
    end


endmodule
