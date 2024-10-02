module hamming_weight_32bit (
    output [31:0] weight,  // Maximum weight can be 32, which needs 6 bits to represent.
    input [31:0] A,
    input [31:0] B
);

    wire [31:0] level0;
    wire [23:0] level1;
    wire [15:0] level2;
    wire [9:0] level3;

    genvar i;

    // Generate blocks for the first level RCAs (1-bit RCAs)
    generate
        for (i = 0; i < 32; i = i + 2) begin : gen_rca1
            rca #(1) rca1 (A[i], A[i+1], 1'b0, level0[i], level0[i+1]);
        end
    endgenerate

    // Generate blocks for the second level RCAs (2-bit RCAs)
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_rca2
            rca #(2) rca2 (level0[4*i+1:4*i], level0[4*i+3:4*i+2], 1'b0, level1[3*i+1:3*i], level1[3*i+2]);
        end
    endgenerate

    // Generate blocks for the third level RCAs (3-bit RCAs)
    generate
        for (i = 0; i < 4; i = i + 1) begin : gen_rca3
            rca #(3) rca3 (level1[6*i+2:6*i], level1[6*i+5:6*i+3], 1'b0, level2[4*i+2:4*i], level2[4*i+3]);
        end
    endgenerate

    // Generate blocks for the fourth level RCAs (4-bit RCAs)
    generate
        for (i = 0; i < 2; i = i + 1) begin : gen_rca4
            rca #(4) rca4 (level2[8*i+3:8*i], level2[8*i+7:8*i+4], 1'b0, level3[5*i+3:5*i], level3[5*i+4]);
        end
    endgenerate

    // Final RCA for 5-bit addition
    rca #(5) rca5 (level3[4:0], level3[9:5], 1'b0, weight[4:0], weight[5]);

    generate
        for (i = 6; i < 32; i = i + 1) begin : gen_buf
            buf (weight[i], 1'b0);
        end
    endgenerate
    
endmodule
