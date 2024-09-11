module REG_BANK (
    input clk,
    input rst_n,
    input [3:0] rs1,       // Source register 1 address
    input [3:0] rs2,       // Source register 2 address
    input [3:0] rd,        // Destination register address
    input [31:0] write_data,  // Data to be written
    input reg_write,       // Write enable
    output [31:0] data1,   // Data output from rs1
    output [31:0] data2,   // Data output from rs2
    output [31:0] r13_out  // Output for debug register (R13)
);

    reg [31:0] registers [0:15];

    // Initialize R0 and R15 to fixed values
    initial begin
        registers[0] = 32'd0;
        registers[15] = 32'd0; // Kernel reserved
    end

    // Reading from registers
    assign data1 = registers[rs1];
    assign data2 = registers[rs2];
    assign r13_out = registers[13]; // Debug register output

    // Writing to registers
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset register values if needed
        end else if (reg_write) begin
            if (rd != 4'd0 && rd != 4'd15) begin
                registers[rd] <= write_data;
            end
        end
    end

endmodule

