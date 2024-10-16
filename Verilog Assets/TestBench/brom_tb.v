`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.10.2024 17:03:20
// Design Name: 
// Module Name: brom_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module brom_tb;

    // Parameters
    reg [31:0] address; // 12-bit address (for depth 4096)
    wire [31:0] data_out; // 32-bit data output from ROM
    reg clk; // Clock signal

    // Instantiate the Block ROM
    // Replace 'your_brom_instance' with the actual name of your BROM module
    inst_mem brom(clk, address, data_out);

     // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // Clock with a period of 10 units
    end
    // Test procedure
    initial begin

        // Test various addresses
        #10 address = 32'h00000000; // Address 0
        #10 address = 32'h00000001; // Address 1
        #10 address = 32'h00000002; // Address 2
        #10 address = 32'h00000003; // Address 3
        #10 address = 32'h00000100; // Address 256 (example)
        #10 address = 32'h00000FFF; // Address 4095 (last address)

        // Wait some time and finish the simulation
        #50 $finish;
    end

    // Monitor output for debugging
    initial begin
        $monitor("At time %t, Address = %h, Data out = %h", $time, address, data_out);
    end

endmodule