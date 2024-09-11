module _SHIFT_LEFT_AbyB #(parameter n = 8) (
    output [n-1:0] res,
    input [n-1:0] A,
    input [$clog2(n)-1:0] B
    );
    wire [n-1:0] shift_intermediate[$clog2(n):0];
    
    assign shift_intermediate[0] = A;

    genvar i;
    generate
        for (i = 0; i < $clog2(n); i = i + 1) begin
            _MUX_2to1_n #(n) mux_shift(shift_intermediate[i+1], B[i], shift_intermediate[i], {shift_intermediate[i][n-(1<<i)-1:0], {(1<<i){1'b0}}});
        end
    endgenerate

    assign res = shift_intermediate[$clog2(n)];
endmodule

module _SHIFT_RIGHTL_AbyB #(parameter n = 8) (
    output [n-1:0] res,
    input [n-1:0] A,
    input [$clog2(n)-1:0] B
    );
    wire [n-1:0] shift_intermediate[$clog2(n):0];
    
    assign shift_intermediate[0] = A;

    genvar i;
    generate
        for (i = 0; i < $clog2(n); i = i + 1) begin
            _MUX_2to1_n #(n) mux_shift(shift_intermediate[i+1], B[i], shift_intermediate[i], {{(1<<i){1'b0}}, shift_intermediate[i][n-1:(1<<i)]});
        end
    endgenerate

    assign res = shift_intermediate[$clog2(n)];
endmodule

module _SHIFT_RIGHTA_AbyB #(parameter n = 8) (
    output [n-1:0] res,
    input [n-1:0] A,
    input [$clog2(n)-1:0] B
    );
    wire [n-1:0] shift_intermediate[$clog2(n):0];
    
    assign shift_intermediate[0] = A;

    genvar i;
    generate
        for (i = 0; i < $clog2(n); i = i + 1) begin
            _MUX_2to1_n #(n) mux_shift(shift_intermediate[i+1], B[i], shift_intermediate[i], {{(1<<i){A[n-1]}}, shift_intermediate[i][n-1:(1<<i)]});
        end
    endgenerate

    assign res = shift_intermediate[$clog2(n)];
endmodule
