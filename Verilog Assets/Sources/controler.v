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


module controler(
        input clk,
        input [2:0] code
    );
    wire [3:0] sel, rd, rs1, rs2;
    
    reg [16:0] cont;
    
    //15-12, 11-8, 7-4, 3-0
    
    always @(posedge clk) begin
        case (code)
            (000): cont = {4'b0000,4'd1,4'd2,4'd3};
            (001): cont = {4'b0001,4'd4,4'd1,4'd5};
            (010): cont = {4'b1010,4'd2,4'd1,4'd2};
            (011): cont = {4'b1011,4'd7,4'd1,4'd2};
            (100): cont = {4'b0010,4'd6,4'd1,4'd2};
            (101): cont = {4'b0100,4'd1,4'd1,4'd2};
            (110): cont = {4'b1000,4'd3,4'd2,4'd0};
            (010): cont = {4'b1000,4'd2,4'd0,4'd0};
        endcase
    end
    
    assign write = 1'b1;
    assign rst = 1'b0;
    
    REG_BANK regs(clk, rst, cont[7:4], cont[3:0], cont[11:8], rd, write, rs1, rs2);
    K_ALU_32(rd, rs1, rs2, cont[15:12]);
    
endmodule
