module K_ALU(
    output [7:0] res,
    input [7:0] A,
    input [7:0] B,
    input [3:0] sel
);
    
    wire [7:0] out_add, out_mul, out_div;
    wire [7:0] out_and, out_or, out_xor, out_not;
    wire [7:0] out_A, out_B, out_sll, out_srl, out_sra;
    wire [7:0] out_p4, out_ham;

    // Functional Units
    add_sub_8 adder(A, B, sel[0], out_add);
    mul m(A, B, out_mul);
    div d(A, B, out_div);
    _AND and_gate(out_and, A, B);
    _OR or_gate(out_or, A, B);
    _XOR xor_gate(out_xor, A, B);
    _NOT_A not_a_gate(out_not, A, B);
    _OUTPUT_A output_a_gate(out_A, A, B);
    _OUTPUT_B output_b_gate(out_B, A, B);
    _SHIFT_LEFT_AbyB sll_gate(out_sll, A, B);
    _SHIFT_RIGHTL_AbyB srl_gate(out_srl, A, B);
    _SHIFT_RIGHTA_AbyB sra_gate(out_sra, A, B);
    inc_dec_8 increment(A, B, sel[0], out_p4);
    _XOR ham_gate(out_ham, A, B);
    
    wire [16*8-1:0] combined_outputs;
    
    assign combined_outputs = { 
        out_ham, out_p4, out_p4, out_sra, 
        out_srl, out_sll, out_B, out_A, 
        out_not, out_xor, out_or, out_and, 
        out_div, out_mul, out_add, out_add
    };
    
    // Multiplexer to select the result
    _MUX_16to1_n #8 mux1(
        res, sel,
        combined_outputs
    );
    
endmodule

module K_ALU_32(
    output [31:0] res,
    input [31:0] A,
    input [31:0] B,
    input [3:0] sel
);
    
    wire [31:0] out_add, out_mul, out_div;
    wire [31:0] out_and, out_or, out_xor, out_not;
    wire [31:0] out_A, out_B, out_sll, out_srl, out_sra;
    wire [31:0] out_p4, out_ham;

    // Functional Units
    add_sub_32 adder(A, B, sel[0], out_add);
    mul #32 m(A, B, out_mul);
    div #32 d(A, B, out_div);
    _AND #32 and_gate(out_and, A, B);
    _OR #32 or_gate(out_or, A, B);
    _XOR #32 xor_gate(out_xor, A, B);
    _NOT_A #32 not_a_gate(out_not, A, B);
    _OUTPUT_A #32 output_a_gate(out_A, A, B);
    _OUTPUT_B #32 output_b_gate(out_B, A, B);
    _SHIFT_LEFT_AbyB #32 sll_gate(out_sll, A, B);
    _SHIFT_RIGHTL_AbyB #32 srl_gate(out_srl, A, B);
    _SHIFT_RIGHTA_AbyB #32 sra_gate(out_sra, A, B);
    inc_dec_8 #32 increment(A, B, sel[0], out_p4);
    _XOR #32 ham_gate(out_ham, A, B);
    
    wire [16*32-1:0] combined_outputs;
    
    assign combined_outputs = { 
        out_ham, out_p4, out_p4, out_sra, 
        out_srl, out_sll, out_B, out_A, 
        out_not, out_xor, out_or, out_and, 
        out_div, out_mul, out_add, out_add
    };
    
    // Multiplexer to select the result
    _MUX_16to1_n #32 mux1(
        res, sel,
        combined_outputs
    );
    
endmodule
