module K_ALU_32(
    output [31:0] res,
    input [31:0] A,
    input [31:0] B,
    input [3:0] sel
);
    
    wire [31:0] out_add, out_lt, out_gt;
    wire [31:0] out_and, out_or, out_xor, out_not;
    wire [31:0] out_nor, out_lui, out_sll, out_srl, out_sra;
    wire [31:0] out_p4, out_ham;

    // Functional Units
    add_sub_32 adder(A, B, sel[0], out_add);
    sltgt_32 cond(A, B, out_lt, out_gt);
    _AND #32 and_gate(out_and, A, B);
    _OR #32 or_gate(out_or, A, B);
    _XOR #32 xor_gate(out_xor, A, B);
    _NOT_A #32 not_a_gate(out_not, A, B);
    _NOR #32 output_a_gate(out_nor, A, B);
    _LUI #32 upper(out_lui, A, B);
    _SHIFT_LEFT_AbyB #32 sll_gate(out_sll, A, B);
    _SHIFT_RIGHTL_AbyB #32 srl_gate(out_srl, A, B);
    _SHIFT_RIGHTA_AbyB #32 sra_gate(out_sra, A, B);
    inc_dec_32 increment(A, B, sel[0], out_p4);
    HAM_weight_32 ham_gate(out_ham, A, B);
    
    wire [16*32-1:0] combined_outputs;
    
    assign combined_outputs = { 
        out_ham, out_p4, out_p4, out_sra, 
        out_srl, out_sll, out_lui, out_nor, 
        out_not, out_xor, out_or, out_and, 
        out_gt, out_lt, out_add, out_add
    };
    
    // Multiplexer to select the result
    _MUX_16to1_n #32 mux1(
        res, sel,
        combined_outputs
    );
    
endmodule
