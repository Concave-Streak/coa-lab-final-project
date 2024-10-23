module data_mem(
    input clk,
    input [31:0] addr, 
    input en, input we, 
    input [31:0] din, 
    output [31:0] dout
);

    blk_mem_gen_0 BRAM(
        .douta(dout),
        .addra(addr[11:0]),
        .clka(clk),
        .dina(din),
        .ena(en),
        .wea(we)
    );

endmodule

module inst_mem(
    input clk,
    input [31:0] addr, 
    output [31:0] dout
);

    blk_mem_gen_1 BROM(
        .douta(dout),
        .addra(addr[11:0]),
        .clka(clk)
    );

endmodule