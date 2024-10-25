module CPU(
    input clk,
    input reset,
    input continue,
    output pwr,
    output halted,
    output [31:0] debug,
    output MemEn, MemWen,
    output [31:0] addr_bus,
    inout [31:0] data_bus
    );
    
    wire loadPC, loadINS, writeReg, IMMsel;
    wire [1:0] DataSel;
    wire [2:0] BRANCH;
    wire [31:0] NPC, PCout, PCinc, INS_in, INS, rd_in, rs1_d, rs2_d, rd_d, imm, A, B, ALU_OUT, mem_data, CMOV;
    wire [31:0] data_ins, data_read, data_write, addr_out, addr_pc;
       
    //data sources
    assign INS_in = data_ins;
    assign mem_data = data_read;
    assign data_write = rd_d;
    //bus master conditions
    assign dread = MemEn & ~MemWen;
    assign dwrite = MemEn & MemWen;
    assign dins = ~MemEn;
    //data bus master logis
    tri_buff_out #32 tbd1(data_ins, dins, data_bus);
    tri_buff_out #32 tbd2(data_read, dread, data_bus);
    tri_buff_in #32 tbd3(data_write, dwrite, data_bus);  
    
    //addr sources
    assign addr_out = ALU_OUT;
    assign addr_pc = PCout;
    //bus master conditions
    assign ains = ~MemEn;
    assign amem = MemEn;
    // addr bus master logic
    tri_buff_in #32 tba1(addr_out, amem, addr_bus);
    tri_buff_in #32 tba2(addr_pc, ains, addr_bus);
    
    
    PC_reg PC(clk, reset, loadPC, NPC, PCout);
    
    rca_cla_32 ADD(PCout, 32'd1, 1'b0, PCinc);
    
    PC_reg INS_reg(clk, reset, loadINS, INS_in, INS); 
    
    REG_BANK RB(clk, reset, INS[23:20], INS[19:16], INS[15:12], rd_in, writeReg, rs1_d, rs2_d, rd_d, debug);
    
    sign_ext SE(INS[15:0], imm);    

    _MUX_2to1_n #32 immMUX(B, IMMsel, rs2_d, imm);
    
    assign A = rs1_d;
    
    K_ALU_32 ALU(ALU_OUT, A, B, INS[27:24]);
    
    wire [127:0] dataMUXin;
    assign dataMUXin = {32'd0, CMOV, mem_data, ALU_OUT};
    _MUX_4to1_n #32 dataMUX(rd_in, DataSel, dataMUXin);
    
    ControlUnit_Fast CU(clk, reset, continue, INS[31:28], loadPC, loadINS, writeReg, MemEn, MemWen, IMMsel, DataSel, BRANCH, pwr, halted);
    
    BranchControl BU(PCinc, A, B, BRANCH, NPC, CMOV);
    
endmodule
