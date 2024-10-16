module REG_BANK (
    input clk,
    input rst_n,
    input [3:0] rd_addr,          // Destination register address
    input [3:0] rs1_addr,         // Source register 1 address
    input [3:0] rs2_addr,         // Source register 2 address
    input [31:0] write_data, // Data to be written
    input reg_write,         // Write enable
    output reg [31:0] rs1_data, // Data output from rs1
    output reg [31:0] rs2_data, // Data output from rs2
    output reg [31:0] rd_data, // Output for debug register
    output reg [31:0] debug
);

    reg [31:0] registers [0:15]; // Register array

    // Writing to registers on the positive edge of the clock
    always @(posedge clk or posedge rst_n) begin
        if (rst_n) begin
            registers[0] <= 0;
            registers[1] <= 0;
            registers[2] <= 0;
            registers[3] <= 0;
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
            if (rd_addr != 4'd0) begin
                registers[rd_addr] <= write_data; // Write data to register if valid
            end
        end
    end

    // Reading from registers on the negative edge of the clock
    always @(negedge clk or posedge rst_n) begin
        if (rst_n) begin
            // Reset the outputs if needed
            rs1_data <= 32'd0;
            rs2_data <= 32'd0;
            rd_data <= 32'd0;
            debug <= 32'd0;
        end else begin
            // Read data from registers
            registers[0] <= 0;
            rs1_data <= registers[rs1_addr];  // Read from rs1 register
            rs2_data <= registers[rs2_addr];  // Read from rs2 register
            rd_data <= registers[rd_addr]; // Read from register
            debug <= registers[13];
        end
    end

endmodule
