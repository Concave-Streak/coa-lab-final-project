`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.09.2024 18:38:49
// Design Name: 
// Module Name: _DEMUX_1to16_16b
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


module _DEMUX_1to16_16b(
    input [15:0] in,
    input [3:0] sel,
    output [15:0] out0,
    output [15:0] out1,
    output [15:0] out2,
    output [15:0] out3,
    output [15:0] out4,
    output [15:0] out5,
    output [15:0] out6,
    output [15:0] out7,
    output [15:0] out8,
    output [15:0] out9,
    output [15:0] out10,
    output [15:0] out11,
    output [15:0] out12,
    output [15:0] out13,
    output [15:0] out14,
    output [15:0] out15
    );

    wire [15:0] demux1_out0, demux1_out1;

    _DEMUX_1to2_16b demux1(in, sel[3], demux1_out0, demux1_out1);
    
    _DEMUX_1to8_16b demux2(demux1_out0, sel[2:0], out0, out1, out2, out3, out4, out5, out6, out7);
    _DEMUX_1to8_16b demux3(demux1_out1, sel[2:0], out8, out9, out10, out11, out12, out13, out14, out15);

endmodule

