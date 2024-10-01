`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.09.2024 16:18:30
// Design Name: 
// Module Name: _OR
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


module _OR #(parameter WIDTH = 8)(output [WIDTH-1:0] res,input  [WIDTH-1:0] A, input  [WIDTH-1:0] B);
    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : or_gen
            or (res[i], A[i], B[i]);
        end
    endgenerate
endmodule

module _AND #(parameter WIDTH = 8)(output [WIDTH-1:0] res,input  [WIDTH-1:0] A, input  [WIDTH-1:0] B);
    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : or_gen
            and (res[i], A[i], B[i]);
        end
    endgenerate
endmodule

module _XOR #(parameter WIDTH = 8)(output [WIDTH-1:0] res,input  [WIDTH-1:0] A, input  [WIDTH-1:0] B);
    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : or_gen
            xor (res[i], A[i], B[i]);
        end
    endgenerate
endmodule

module _NOR #(parameter WIDTH = 8)(output [WIDTH-1:0] res,input  [WIDTH-1:0] A, input  [WIDTH-1:0] B);
    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : or_gen
            nor (res[i], A[i], B[i]);
        end
    endgenerate
endmodule

module _NOT_A #(parameter WIDTH = 8)(output [WIDTH-1:0] res,input  [WIDTH-1:0] A, input  [WIDTH-1:0] B);
    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : or_gen
            not (res[i], A[i]);
        end
    endgenerate
endmodule

module _OUTPUT_A #(parameter WIDTH = 8)(output [WIDTH-1:0] res,input  [WIDTH-1:0] A, input  [WIDTH-1:0] B);
    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : or_gen
            buf (res[i], A[i]);
        end
    endgenerate
endmodule

module _OUTPUT_B #(parameter WIDTH = 8)(output [WIDTH-1:0] res,input  [WIDTH-1:0] A, input  [WIDTH-1:0] B);
    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : or_gen
            buf (res[i], B[i]);
        end
    endgenerate
endmodule



