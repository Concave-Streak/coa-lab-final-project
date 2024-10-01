module mul #(parameter n = 8)(input [n-1:0] A, input [n-1:0] B, output [n-1:0] mul);
    assign mul = A * B;
endmodule


module div #(parameter n = 8)(input [n-1:0] A, input [n-1:0] B, output [n-1:0] div);
    assign div = A / B;
endmodule
