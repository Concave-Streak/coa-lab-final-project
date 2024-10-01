`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.08.2024 21:45:01
// Design Name: 
// Module Name: half_adder
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


module half_adder(input a, input b, output s, output c);
    assign s = a^b;
    assign c = a&b;
endmodule

module struct_ha(input a, input b, output s, output c);
    xor x1(s,a,b);
    and a1(c,a,b);
endmodule

module full_adder(input a, input b, input c_in, output s, output c_out, output s0, output c0);
    struct_ha h0(a,b,s0,c0);
    struct_ha h1(s0,c_in,s,c1);
    or o1(c_out, c0, c1);
endmodule

module rca #(
    parameter WIDTH = 8
)(
    input  [WIDTH-1:0] A, 
    input  [WIDTH-1:0] B, 
    input              Cin,
    output [WIDTH-1:0] Sum, 
    output             Cout 
);
    wire [WIDTH:0] carry;
    
    assign carry[0] = Cin;
    assign Cout = carry[WIDTH];
   
    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : full_adder_chain
            full_adder f(A[i], B[i], carry[i], Sum[i], carry[i+1]);
        end
    endgenerate
    
endmodule


module cla_4(input [3:0] a, input [3:0] b, input c_in, output [3:0] s, output c_out, output p_out, output g_out);
    
    wire [3:0] p, g, c, x;
    
    assign c[0] = c_in;
    
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : gen_loop
            full_adder f(a[i], b[i], c[i], s[i], x[i], p[i],g[i]);
        end
    endgenerate 

    assign c[1] = g[0] | (p[0]&c_in);
    assign c[2] = g[1] | (p[1]&g[0]) | (p[1]&p[0]&c_in);
    assign c[3] = g[2] | (p[2]&g[1])| (p[2]&p[1]&g[0]) | (p[2]&p[1]&p[0]&c_in);
    assign c_out = g[3] | (p[3]&g[2]) | (p[3]&p[2]&g[1]) | (p[3]&p[2]&p[1]&g[0]) | (p[3]&p[2]&p[1]&p[0]&c_in);

    assign p_out = p[3]&p[2]&p[1]&p[0];
    assign g_out = g[3] | (p[3]&g[2]) | (p[3]&p[2]&g[1]) | (p[3]&p[2]&p[1]&g[0]); 
    
endmodule

module rca_cla_8(input [7:0] a, input [7:0] b, input c_in, output [7:0] s, output c_out);
    cla_4 a0(a[3:0], b[3:0], c_in, s[3:0], c1);
    cla_4 a1(a[7:4], b[7:4], c1, s[7:4], c_out);
endmodule

module cla_16(input [15:0] a, input [15:0] b, input c_in, output [15:0] s, output c_out);
    
    wire [3:0] c, x, p, g;
    assign c[0] = c_in;
    
    genvar i;
    generate
       for (i = 0; i < 4; i = i + 1) begin : gen_cla
            cla_4 a(a[4*i+3:4*i],b[4*i+3:4*i],c[i], s[4*i+3:4*i], x[i], p[i], g[i]);
       end
    endgenerate

    assign c[1] = g[0] | (p[0]&c_in);
    assign c[2] = g[1] | (p[1]&g[0]) | (p[1]&p[0]&c_in);
    assign c[3] = g[2] | (p[2]&g[1])| (p[2]&p[1]&g[0]) | (p[2]&p[1]&p[0]&c_in);
    assign c_out = g[3] | (p[3]&g[2]) | (p[3]&p[2]&g[1]) | (p[3]&p[2]&p[1]&g[0]) | (p[3]&p[2]&p[1]&p[0]&c_in);

endmodule

module rca_cla_32(input [31:0] a, input [31:0] b, input c_in, output [31:0] s, output c_out);
    cla_16 a0(a[15:0], b[15:0], c_in, s[15:0], carry);
    cla_16 a1(a[31:16], b[31:16], carry, s[31:16], c_out);
endmodule

module add_sub_8 (
    input  [7:0] A,
    input  [7:0] B,
    input        mode,  // 0 for addition, 1 for subtraction
    output [7:0] Result,
    output       CarryOut
);
    wire [7:0] B_inverted;
    wire [7:0] B_mux;

    // Invert the bits of B for subtraction
    _NOT_A  n(B_inverted,B);

    // Mux to select B or ~B based on mode
    _MUX_2to1_n #8 m(B_mux, mode, B, B_inverted);

    // Structural instantiation of addr_8
    rca_cla_8 as(A, B_mux, mode, Result, CarryOut);

endmodule

module add_sub_32 (
    input  [31:0] A,
    input  [31:0] B,
    input        mode,  // 0 for addition, 1 for subtraction
    output [31:0] Result,
    output       CarryOut
);
    wire [31:0] B_inverted;
    wire [31:0] B_mux;

    // Invert the bits of B for subtraction
    _NOT_A #32 n(B_inverted,B);

    // Mux to select B or ~B based on mode
    _MUX_2to1_n #32 m(B_mux, mode, B, B_inverted);

    // Structural instantiation of addr_8
    rca_cla_32 as(A, B_mux, mode, Result, CarryOut);

endmodule

module inc_dec_8(
    input  [7:0] A,
    input  [7:0] B,
    input        mode,  // 0 for addition, 1 for subtraction
    output [7:0] Result,
    output       CarryOut
);
    wire [7:0] four;
    _OUTPUT_A o(four, 8'd4);
    not (nmode, mode);
    add_sub_8 as(A, four, nmode, Result, CarryOut);
    
endmodule

module inc_dec_32(
    input  [31:0] A,
    input  [31:0] B,
    input        mode,  // 0 for addition, 1 for subtraction
    output [31:0] Result,
    output       CarryOut
);
    wire [31:0] four;
    _OUTPUT_A #32 o(four, 32'd4);
    not (nmode, mode);
    add_sub_32 as(A, four, nmode, Result, CarryOut);
    
endmodule
    
