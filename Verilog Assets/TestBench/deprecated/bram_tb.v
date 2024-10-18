`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.10.2024 16:29:08
// Design Name: 
// Module Name: bram_tb
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


module bram_tb;

    reg clk;
    reg en;
    reg we;
    reg [31:0] addr;
    reg [31:0] din;
    wire [31:0] dout;
    
    data_mem bram(clk, addr, en, we, din, dout);
    
     // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // Clock with a period of 10 units
    end

    // Test procedure
    initial begin
        // Initialize inputs
        en = 1;
        we = 0;
        addr = 0;
        din = 0;

        // Reset the BRAM
        #10;

        // Test 1: Write 8'hA5 to address 0 and read it back
        we = 1; addr = 32'h00000000; din = 32'h000000A5;
        #10;
        we = 0; addr = 32'h00000000;
        #10;
        $display("Read from address 0: %h", dout);  // Expected: A5

        // Test 2: Write 8'h3C to address 5 and read it back
        we = 1; addr = 32'h00000101; din = 32'h0000003C;
        #10;
        we = 0; addr = 32'h00000101;
        #10;
        $display("Read from address 5: %h", dout);  // Expected: 3C

        // Test 3: Read from an uninitialized address (should return 'x')
        addr = 32'h00000011;
        #10;
        $display("Read from uninitialized address 3: %h", dout);  // Expected: x or default memory value

        // End the simulation
        #20;
        $finish;
    end

endmodule
