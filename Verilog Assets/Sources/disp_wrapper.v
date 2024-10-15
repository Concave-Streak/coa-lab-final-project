module dwrap(
    input CLK,
    output [6:0] SEG,
    output [7:0] AN,
    output DP
);
    wire [31:0] x = 32'd48;
    
    seg_disp disp(x, CLK, SEG, AN, DP);
    
endmodule 