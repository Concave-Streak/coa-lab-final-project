`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.08.2024 14:30:43
// Design Name: 
// Module Name: clk_div
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


module clk_div( input clk, input rst, output new_clk);

reg [31:0] cnt;

always @(posedge clk or posedge rst)
begin
    if (rst)
        cnt = 0;
    else
        cnt = cnt + 1;
end

assign new_clk = cnt[27];

endmodule
