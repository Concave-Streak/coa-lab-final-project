`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.09.2024 18:46:41
// Design Name: 
// Module Name: tb_K_ALU
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


module tb_K_ALU;
    wire [31:0] res;
    reg [31:0] A, B;
    reg [3:0] sel;
    K_ALU_32 k_alu(res, A, B, sel);
    initial begin
        A = 8'd123;
        B = 8'd78;
        sel = 4'b0010;
    end
endmodule
