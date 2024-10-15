module data_mem(
    input clk,
    input [31:0] addr, 
    input en, input we, 
    input [31:0] din, 
    output [31:0] dout
);

    blk_mem_gen_0 gskill_ripjaw(
        .DO(dout),
        .ADDR(addr[11:0]),
        .CLK(clk),
        .DI(din),
        .EN(en),
        .WE(we)
    );

endmodule

module inst_mem(
    input clk,
    input [31:0] addr, 
    output [31:0] dout
);

    blk_mem_gen_1 samsung_990pro(
        .DO(dout),
        .ADDR(addr[11:0]),
        .CLK(clk)
    );

endmodule