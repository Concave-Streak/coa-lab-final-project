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