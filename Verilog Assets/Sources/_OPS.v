
module _OR #(parameter WIDTH = 8)(output [WIDTH-1:0] res,input  [WIDTH-1:0] A, input  [WIDTH-1:0] B);
    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : or_gen
            or (res[i], A[i], B[i]);
        end
    endgenerate
endmodule

module _AND #(parameter WIDTH = 8)(output [WIDTH-1:0] res,input  [WIDTH-1:0] A, input  [WIDTH-1:0] B);
    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : or_gen
            and (res[i], A[i], B[i]);
        end
    endgenerate
endmodule

module _XOR #(parameter WIDTH = 8)(output [WIDTH-1:0] res,input  [WIDTH-1:0] A, input  [WIDTH-1:0] B);
    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : or_gen
            xor (res[i], A[i], B[i]);
        end
    endgenerate
endmodule

module _NOR #(parameter WIDTH = 8)(output [WIDTH-1:0] res,input  [WIDTH-1:0] A, input  [WIDTH-1:0] B);
    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : or_gen
            nor (res[i], A[i], B[i]);
        end
    endgenerate
endmodule

module _NOT_A #(parameter WIDTH = 8)(output [WIDTH-1:0] res,input  [WIDTH-1:0] A, input  [WIDTH-1:0] B);
    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : or_gen
            not (res[i], A[i]);
        end
    endgenerate
endmodule

module _OUTPUT_A #(parameter WIDTH = 8)(output [WIDTH-1:0] res,input  [WIDTH-1:0] A, input  [WIDTH-1:0] B);
    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : or_gen
            buf (res[i], A[i]);
        end
    endgenerate
endmodule

module _OUTPUT_B #(parameter WIDTH = 8)(output [WIDTH-1:0] res,input  [WIDTH-1:0] A, input  [WIDTH-1:0] B);
    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : or_gen
            buf (res[i], B[i]);
        end
    endgenerate
endmodule

module _LUI #(parameter n = 8) (
    output [n-1:0] res,
    input [n-1:0] A,
    input [n-1:0] B
);

    genvar i;

    // First generate block: assign res[n-1:n/2] = A[n/2-1:0];
    generate
        for (i = 0; i < n/2; i = i + 1) begin : assign_upper_half
            buf(res[n/2 + i], A[i]);
        end
    endgenerate

    // Second generate block: assign res[n/2-1:0] = {n/2{1'b0}};
    generate
        for (i = 0; i < n/2; i = i + 1) begin : assign_lower_half_zero
            buf(res[i],1'b0);
        end
    endgenerate
    
endmodule

module sign_ext(input [15:0] A, output [31:0] Imm);
    assign Imm = {16'd0,A};
endmodule

module sltgt_32 (input [31:0] A, input [31:0] B, output [31:0] outlt, output[31:0] outgt);
    
    buf b0(mode, 1'b1);
    
    wire [31:0] res0, res1;
    
    add_sub_32 a0(A, B, mode, res0, c0);
    add_sub_32 a1(B, A, mode, res1, c1);
    
    buf b1(outlt[0], res0[31]);
    buf n0(outgt[0], res1[31]);
    
    genvar i;
    generate
        for (i = 1; i < 32; i = i + 1) begin : buf_gen
            buf (outlt[i], 1'b0);
            buf (outgt[i], 1'b0);
        end
    endgenerate
        
endmodule
