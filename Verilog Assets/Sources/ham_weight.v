module HAM_weight #(parameter n = 8) (
    input [n-1:0] A,
    input [n-1:0] B,
    output [n-1:0] weight
);
    // Internal signals
    wire [n-1:0] count;
    wire [n:0] carry;
    
    assign carry[0] = 0;

    //adders to compute the Hamming weight
    genvar i;
    generate
        for (i = 0; i < n; i = i + 1) begin : adder_array
            full_adder fa(A[i],count[i],carry[i],count[i],carry[i+1]);
        end
    endgenerate

    // The final Hamming weight is the sum of all individual bits
    assign weight = count;

endmodule
