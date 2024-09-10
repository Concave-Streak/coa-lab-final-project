`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.09.2024 18:34:37
// Design Name: 
// Module Name: _DEMUX_1to8_16b
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


module _DEMUX_1to8_16b(
    input [15:0] in,      // 16-bit input
    input [2:0] sel,      // 3-bit select input
    output [15:0] out0,   // 16-bit output 0
    output [15:0] out1,   // 16-bit output 1
    output [15:0] out2,   // 16-bit output 2
    output [15:0] out3,   // 16-bit output 3
    output [15:0] out4,   // 16-bit output 4
    output [15:0] out5,   // 16-bit output 5
    output [15:0] out6,   // 16-bit output 6
    output [15:0] out7    // 16-bit output 7
    );

    wire [15:0] demux1_out0, demux1_out1;

    _DEMUX_1to2_16b demux1(in, sel[2], demux1_out0, demux1_out1);
    
    _DEMUX_1to4_16b demux2(demux1_out0, sel[1:0], out0, out1, out2, out3);
    _DEMUX_1to4_16b demux3(demux1_out1, sel[1:0], out4, out5, out6, out7);

endmodule

