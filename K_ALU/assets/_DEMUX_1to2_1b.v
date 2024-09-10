`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.09.2024 18:45:31
// Design Name: 
// Module Name: _DEMUX_1to2_1b
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


module _DEMUX_1to2_1b(
    input in,
    input sel,
    output out0,
    output out1
    );

    wire n_sel;

    not (n_sel, sel);

    and (out0, in, n_sel);
    and (out1, in, sel);
    
endmodule
