module dwrap(
    input CLK,
    input rst,
    input [15:0] SW,
    output [6:0] SEG,
    output [7:0] AN,
    output DPbin32_to_bcd
);    
    wire new_clk, write;
    wire [31:0] rdec, rout,rd, rs1, rs2;
    clk_div cd(CLK, rst, new_clk);
    assign write = 1'b1;
    REG_BANK regs(new_clk, rst, SW[11:8], SW[7:4], SW[3:0], rd, write, rs1, rs2, rout);
    K_ALU_32 alu(rd, rs1, rs2, SW[15:12]);
    bin32_to_bcd bcd(rout, rdec);
    seg_disp disp(rdec, CLK, SEG, AN, DP);
    
endmodule 