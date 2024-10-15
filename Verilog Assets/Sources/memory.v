module data_mem(
    input clk,
    input [31:0] addr, 
    input en, input we, 
    input [31:0] din, 
    output [31:0] dout
);

    gskill_ripjaw blk_mem_gen_0(
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

    samsung_990pro blk_mem_gen_1(
        .DO(dout),
        .ADDR(addr[11:0]),
        .CLK(clk)
    );

endmodule