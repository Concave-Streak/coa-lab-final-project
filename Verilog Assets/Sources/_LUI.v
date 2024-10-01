`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.10.2024 15:15:20
// Design Name: 
// Module Name: _LUI
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


module _LUI #(parameter n = 8) (
    output [n-1:0] res,
    input [n-1:0] A,
    input [n-1:0] B
);

    genvar i;

    // First generate block: assign res[n-1:n/2] = A[n/2-1:0];
    generate
        for (i = 0; i < n/2; i = i + 1) begin : assign_upper_half
            buf(res[n/2 + i], A[i]);
        end
    endgenerate

    // Second generate block: assign res[n/2-1:0] = {n/2{1'b0}};
    generate
        for (i = 0; i < n/2; i = i + 1) begin : assign_lower_half_zero
            buf(res[i],1'b0);
        end
    endgenerate
    
endmodule
