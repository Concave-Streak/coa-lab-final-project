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


