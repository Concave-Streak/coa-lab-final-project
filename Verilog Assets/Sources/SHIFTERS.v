module _SHIFT_LEFT_AbyB(
    output [7:0] res,
    input [7:0] A,
    input [7:0] B
    );
    wire [7:0] out1, out2;
    _MUX_2to1_8b mux_1(out1, B[0], A, {A[6:0], 1'b0});
    _MUX_2to1_8b mux_2(out2, B[1], out1, {out1[5:0], 2'b00});
    _MUX_2to1_8b mux_4(res, B[2], out2, {out2[3:0], 4'b0000});
endmodule

module _SHIFT_RIGHTL_AbyB(
    output [7:0] res,
    input [7:0] A,
    input [7:0] B
    );
    wire [7:0] out1, out2;
    _MUX_2to1_8b mux_1(out1, B[0], A, {1'b0, A[7:1]});
    _MUX_2to1_8b mux_2(out2, B[1], out1, {2'b00, out1[7:2]});
    _MUX_2to1_8b mux_4(res, B[2], out2, {4'b0000, out2[7:4]});
endmodule

module _SHIFT_RIGHTA_AbyB(
    output [7:0] res,
    input [7:0] A,
    input [7:0] B
    );
    wire [7:0] out1, out2;
    _MUX_2to1_8b mux_1(out1, B[0], A, {A[7], A[7:1]});
    _MUX_2to1_8b mux_2(out2, B[1], out1, {A[7], A[7], out1[7:2]});
    _MUX_2to1_8b mux_4(res, B[2], out2, {A[7], A[7], A[7], A[7], out2[7:4]});
endmodule