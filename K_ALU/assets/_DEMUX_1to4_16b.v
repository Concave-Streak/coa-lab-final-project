`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.09.2024 18:33:22
// Design Name: 
// Module Name: _DEMUX_1to4_16b
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


module _DEMUX_1to4_16b(
    input [15:0] in,
    input [1:0] sel,
    output [15:0] out0,
    output [15:0] out1,
    output [15:0] out2,
    output [15:0] out3
    );

    wire [15:0] demux1_out0, demux1_out1;

    _DEMUX_1to2_16b demux1(in, sel[1], demux1_out0, demux1_out1);
    
    _DEMUX_1to2_16b demux2(demux1_out0, sel[0], out0, out1);
    _DEMUX_1to2_16b demux3(demux1_out1, sel[0], out2, out3);

endmodule

