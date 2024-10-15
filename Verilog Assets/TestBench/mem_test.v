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
        clk = 0;
        rst = 1;
        #10 rst = 0;
        
        for(i = 0; i < 8; i = i + 1) begin
            code = i;
            #10;
        end
        
        #100
        $finish;
    end
    
    always begin
        #5 clk = ~clk;
    end


endmodule
