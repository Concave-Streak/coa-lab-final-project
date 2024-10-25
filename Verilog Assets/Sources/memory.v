module data_mem(
    input clk,
    input [31:0] addr, 
    input en, input we, 
    inout [31:0] dbus
);
    wire [31:0] din, dout;
    wire dins, douts;
    assign dins = en & we;
    assign douts = en & ~we;
    tri_buff_out #32 tbd1(din, dins, dbus);
    tri_buff_in #32 tbd2(dout, douts, dbus);
    
    assign wem = en & we;
    blk_mem_gen_0 BRAM(
        .douta(dout),
        .addra(addr[11:0]),
        .clka(clk),
        .dina(din),
        .wea(wem)
    );

endmodule