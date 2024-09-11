`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.09.2024 14:49:44
// Design Name: 
// Module Name: controler
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


module controller(
        input clk,
        input rst,
        input [2:0] code
    );
    wire [31:0] rd, rs1, rs2;
    
    reg [15:0] cont;
    
    //15-12, 11-8, 7-4, 3-0
    
    always @(*) begin
        case (code)
            3'd0: cont = {4'b0000,4'd1,4'd2,4'd3};
            3'd1: cont = {4'b0001,4'd4,4'd1,4'd5};
            3'd2: cont = {4'b1010,4'd2,4'd1,4'd2};
            3'd3: cont = {4'b1011,4'd7,4'd1,4'd2};
            3'd4: cont = {4'b0010,4'd6,4'd1,4'd2};
            3'd5: cont = {4'b0100,4'd1,4'd1,4'd2};
            3'd6: cont = {4'b1000,4'd3,4'd2,4'd0};
            3'd7: cont = {4'b1000,4'd6,4'd0,4'd0};
            default: cont=15'd0;
        endcase
    end
    
    assign write = 1'b1;
    
    REG_BANK regs(clk, rst, cont[7:4], cont[3:0], cont[11:8], rd, write, rs1, rs2);
    K_ALU_32 alu(rd, rs1, rs2, cont[15:12]);
    
endmodule
