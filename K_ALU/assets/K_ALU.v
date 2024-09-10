`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.09.2024 17:16:33
// Design Name: 
// Module Name: K_ALU
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


module K_ALU(
    output [7:0] res,
    input [7:0] A,
    input [7:0] B,
    input [3:0] sel
    );
    
    wire [15:0] in_add,
    in_sub, in_mul, 
    in_div, in_and,
    in_or, in_xor,
    in_not, in_A,
    in_B, in_sll,
    in_srl, in_sra,
    in_p4, in_m4,
    in_ham;
    wire [7:0]  out_add,
    out_sub, out_mul, 
    out_div, out_and,
    out_or, out_xor,
    out_not, out_A,
    out_B, out_sll,
    out_srl, out_sra,
    out_p4, out_m4,
    out_ham;

    
    _DEMUX_1to16_16b demux_1to16_16b1(
    {A, B}, sel,
    in_add,
    in_sub, in_mul, 
    in_div, in_and,
    in_or, in_xor,
    in_not, in_A,
    in_B, in_sll,
    in_srl, in_sra,
    in_p4, in_m4,
    in_ham
    );
    
    wire [15:0] in_add_sub, in_pm;
    _OR addor(in_add_sub[7:0], in_add[7:0], in_sub[7:0]);
    _OR addor2(in_add_sub[15:8], in_add[15:8], in_sub[15:8]);
    _OR incor(in_pm[7:0], in_p4[7:0], in_m4[7:0]);
    _OR incor2(in_pm[15:8], in_p4[15:8], in_m4[15:8]);
    
    add_sub_8 adder(in_add_sub[15:8], in_add_sub[7:0], sel[0], out_add);
    mul_8 m(in_mul[15:8], in_mul[7:0], out_mul);
    div_8 d(in_div[15:8], in_div[7:0], out_div);
    _AND and_gate(out_and, in_and[15:8], in_and[7:0]);
    _OR or_gate(out_or, in_or[15:8], in_or[7:0]);
    _XOR xor_gate(out_xor, in_xor[15:8], in_xor[7:0]);
    _NOT_A not_a_gate(out_not, in_not[15:8], in_not[7:0]);
    _OUTPUT_A output_a_gate(out_A, in_A[15:8], in_A[7:0]);
    _OUTPUT_B output_b_gate(out_B, in_B[15:8], in_B[7:0]);
    _SHIFT_LEFT_AbyB sll_gate(out_sll, in_sll[15:8], in_sll[7:0]);
    _SHIFT_RIGHTL_AbyB srl_gate(out_srl, in_srl[15:8], in_srl[7:0]);
    _SHIFT_RIGHTA_AbyB sra_gate(out_sra, in_sra[15:8], in_sra[7:0]);
    add_sub_inc increment(in_pm[15:8], in_pm[7:0], sel[0], out_p4);
    _HAM_WEIGHT_A ham_gate(out_ham, in_ham[15:8], in_ham[7:0]);
    
    _MUX_16to1_n #8 mux1(
    res, sel,
    out_add,
    out_add, out_mul, 
    out_div, out_and,
    out_or, out_xor,
    out_not, out_A,
    out_B, out_sll,
    out_srl, out_sra,
    out_p4, out_p4,
    out_ham);
    
endmodule
