module CPU(
    input clk,
    input reset,
    input continue,
    output [31:0] debug
    );
    
    wire loadPC, writeReg, IMMsel, MemEn, MemWen;
    wire [1:0] DataSel;
    wire [2:0] BRANCH;
    wire [31:0] NPC, PCout, PCinc, INS, rd_in, rs1_d, rs2_d, rd_d, imm, A, B, ALU_OUT, mem_data, CMOV;
    
    PC_reg PC(clk, reset, loadPC, NPC, PCout);
    
    rca_cla_32 ADD(PCout, 32'd1, 1'b0, PCinc);
    
    inst_mem IM(clk, PCout, INS);
    
    REG_BANK RB(clk, reset, INS[23:20], INS[19:16], INS[15:12], rd_in, writeReg, rs1_d, rs2_d, rd_d, debug);
    
    sign_ext SE(INS[15:0], imm);    

    _MUX_2to1_n #32 immMUX(B, IMMsel, rs2_d, imm);
    
    assign A = rs1_d;
    
    K_ALU_32 ALU(ALU_OUT, A, B, INS[27:24]);
    
    data_mem DM(clk, ALU_OUT, MemEn, MemWen, rd_d, mem_data);
    
    wire [127:0] dataMUXin;
    assign dataMUXin = {32'd0, CMOV, mem_data, ALU_OUT};
    _MUX_4to1_n #32 dataMUX(rd_in, DataSel, dataMUXin);
    
    ControlUnit_Fast CU(clk, reset, continue, INS[31:28], loadPC, writeReg, MemEn, MemWen, IMMsel, DataSel, BRANCH);
    
    BranchControl BU(PCinc, A, B, BRANCH, NPC, CMOV);
    
endmodule
