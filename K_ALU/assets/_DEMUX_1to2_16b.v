`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.09.2024 18:40:46
// Design Name: 
// Module Name: _DEMUX_1to2_16b
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


module _DEMUX_1to2_16b(
    input [15:0] in,
    input sel,
    output [15:0] out0,
    output [15:0] out1
    );

    _DEMUX_1to2_1b demux0 (in[0], sel, out0[0], out1[0]);
    _DEMUX_1to2_1b demux1 (in[1], sel, out0[1], out1[1]);
    _DEMUX_1to2_1b demux2 (in[2], sel, out0[2], out1[2]);
    _DEMUX_1to2_1b demux3 (in[3], sel, out0[3], out1[3]);
    _DEMUX_1to2_1b demux4 (in[4], sel, out0[4], out1[4]);
    _DEMUX_1to2_1b demux5 (in[5], sel, out0[5], out1[5]);
    _DEMUX_1to2_1b demux6 (in[6], sel, out0[6], out1[6]);
    _DEMUX_1to2_1b demux7 (in[7], sel, out0[7], out1[7]);
    _DEMUX_1to2_1b demux8 (in[8], sel, out0[8], out1[8]);
    _DEMUX_1to2_1b demux9 (in[9], sel, out0[9], out1[9]);
    _DEMUX_1to2_1b demux10 (in[10], sel, out0[10], out1[10]);
    _DEMUX_1to2_1b demux11 (in[11], sel, out0[11], out1[11]);
    _DEMUX_1to2_1b demux12 (in[12], sel, out0[12], out1[12]);
    _DEMUX_1to2_1b demux13 (in[13], sel, out0[13], out1[13]);
    _DEMUX_1to2_1b demux14 (in[14], sel, out0[14], out1[14]);
    _DEMUX_1to2_1b demux15 (in[15], sel, out0[15], out1[15]);

endmodule

