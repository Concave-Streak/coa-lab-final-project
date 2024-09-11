module REG_BANK (
    input clk,
    input rst_n,
    input [3:0] rs1,         // Source register 1 address
    input [3:0] rs2,         // Source register 2 address
    input [3:0] rd,          // Destination register address
    input [31:0] write_data, // Data to be written
    input reg_write,         // Write enable
    output reg [31:0] data1, // Data output from rs1
    output reg [31:0] data2, // Data output from rs2
    output reg [31:0] r13_out // Output for debug register (R13)
);

    reg [31:0] registers [0:15]; // Register array

    // Writing to registers on the positive edge of the clock
    always @(posedge clk or posedge rst_n) begin
        if (rst_n) begin
            registers[0] <= 0;
            registers[1] <= 0;
            registers[2] <= 2;
            registers[3] <= 349;
            registers[4] <= 0;
            registers[5] <= 0;
            registers[6] <= 0;
            registers[7] <= 0;
            registers[8] <= 0;
            registers[9] <= 0;
            registers[10] <= 0;
            registers[11] <= 0;
            registers[12] <= 0;
            registers[13] <= 0;
            registers[14] <= 0;
            registers[15] <= 0;
        end else if (reg_write) begin
            if (rd != 4'd0 && rd != 4'd15) begin
                registers[rd] <= write_data; // Write data to register if valid
            end
        end
    end

    // Reading from registers on the negative edge of the clock
    always @(negedge clk or posedge rst_n) begin
        if (rst_n) begin
            // Reset the outputs if needed
            data1 <= 32'd0;
            data2 <= 32'd0;
            r13_out <= 32'd0;
        end else begin
            // Read data from registers
            registers[0] <= 0;
            data1 <= registers[rs1];  // Read from rs1 register
            data2 <= registers[rs2];  // Read from rs2 register
            r13_out <= registers[13]; // Read from register 13
        end
    end

endmodule
