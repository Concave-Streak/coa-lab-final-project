`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.09.2024 15:17:02
// Design Name: 
// Module Name: _MUX_2to1_8b
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
module _MUX_2to1(
    output res,
    input sel,
    input in0,
    input in1
    );
    wire a, b, n_sel;
    not (n_sel, sel);
    and (a, sel, in1);
    and (b, n_sel, in0);
    or (res, a, b);
endmodule

module _MUX_2to1_n #( parameter WIDTH = 8 )(output [WIDTH-1:0] res,input  sel,input  [WIDTH-1:0] A, input  [WIDTH-1:0] B);
    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : mux_gen
             _MUX_2to1 mux_inst (res[i],sel,A[i],B[i]);
        end
    endgenerate
endmodule


module _MUX_4to1_n #(
    parameter WIDTH = 8  // Parameter to specify the width of the data
)(
    output [WIDTH-1:0] res,
    input  [1:0] sel,
    input  [4*WIDTH-1:0] in  // Single large array for 4 inputs, each WIDTH bits wide
);
    wire [WIDTH-1:0] mux1_out, mux2_out;

    // Instantiate the 2-to-1 multiplexers with direct input slicing
    _MUX_2to1_n #WIDTH mux1 (mux1_out, sel[0], in[WIDTH-1:0], in[2*WIDTH-1:WIDTH]);
    _MUX_2to1_n #WIDTH mux2 (mux2_out, sel[0], in[3*WIDTH-1:2*WIDTH], in[4*WIDTH-1:3*WIDTH]);
    _MUX_2to1_n #WIDTH mux3 (res, sel[1], mux1_out, mux2_out);
    
endmodule

module _MUX_8to1_n #(
    parameter WIDTH = 8  // Parameter to specify the width of the data
)(
    output [WIDTH-1:0] res,
    input  [2:0] sel,
    input  [8*WIDTH-1:0] in  // Single large array for 8 inputs, each WIDTH bits wide
);
    wire [WIDTH-1:0] mux1_out, mux2_out;

    // Instantiate the 4-to-1 multiplexers with direct input slicing
    _MUX_4to1_n #WIDTH mux1 (mux1_out, sel[1:0], in[WIDTH-1:0], in[2*WIDTH-1:WIDTH], in[3*WIDTH-1:2*WIDTH], in[4*WIDTH-1:3*WIDTH]);
    _MUX_4to1_n #WIDTH mux2 (mux2_out, sel[1:0], in[5*WIDTH-1:4*WIDTH], in[6*WIDTH-1:5*WIDTH], in[7*WIDTH-1:6*WIDTH], in[8*WIDTH-1:7*WIDTH]);

    // Final 2-to-1 multiplexer
    _MUX_2to1_n #WIDTH mux3 (res, sel[2], mux1_out, mux2_out);
    
endmodule


module _MUX_16to1_n #(
    parameter WIDTH = 8  // Parameter to specify the width of the data
)(
    output [WIDTH-1:0] res,
    input  [3:0] sel,
    input  [16*WIDTH-1:0] in  // Single large array for 16 inputs, each WIDTH bits wide
);
    wire [WIDTH-1:0] mux1_out, mux2_out;

    // Instantiate the 8-to-1 multiplexers with direct input slicing
    _MUX_8to1_n #WIDTH mux1 (mux1_out, sel[2:0], in[WIDTH-1:0], in[2*WIDTH-1:WIDTH], in[3*WIDTH-1:2*WIDTH], in[4*WIDTH-1:3*WIDTH], in[5*WIDTH-1:4*WIDTH], in[6*WIDTH-1:5*WIDTH], in[7*WIDTH-1:6*WIDTH], in[8*WIDTH-1:7*WIDTH]);
    _MUX_8to1_n #WIDTH mux2 (mux2_out, sel[2:0], in[9*WIDTH-1:8*WIDTH], in[10*WIDTH-1:9*WIDTH], in[11*WIDTH-1:10*WIDTH], in[12*WIDTH-1:11*WIDTH], in[13*WIDTH-1:12*WIDTH], in[14*WIDTH-1:13*WIDTH], in[15*WIDTH-1:14*WIDTH], in[16*WIDTH-1:15*WIDTH]);

    // Final 2-to-1 multiplexer
    _MUX_2to1_n #WIDTH mux3 (res, sel[3], mux1_out, mux2_out);
    
endmodule




