`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.10.2024 14:35:16
// Design Name: 
// Module Name: CPU_tb
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


module CPU_tb(

    );
    
    reg clk, rst, continue;
    wire [31:0] debug;
    wire tx;

    // UART parameters
    localparam CLOCK_DIVIDE = 5; // Clock divider for 9600 baud at 100MHz clock
    reg [7:0] data_to_send;
    reg [3:0] bit_index;
    reg [13:0] baud_counter;
    reg tx_reg;
    reg enable;

    SOC threadripper3990wx(clk, rst, continue, pwr, halted, debug, tx, tx_reg);
    
    initial begin
        clk = 0;
        continue = 0;
        rst = 0;
        #11
        rst = 1;
        #11
        rst = 0;
        
         // Data to be sent (example: 0xA5)
        bit_index = 4'b0;
        baud_counter = 14'b0;
        tx_reg = 1'b1; // Idle state of UART line is high
        enable = 1'b0;
                      // Wait for some delay before starting transmission
        #30000; // Delay before starting transmission (~2ms)
     
        data_to_send = 8'd49;
        bit_index = 4'b0; // Reset bit index
        enable = 1'b1;
        #300
        data_to_send = 8'd48;
        bit_index = 4'b0; // Reset bit index
        enable = 1'b1;
        #300
        data_to_send = 8'd100;
        bit_index = 4'b0; // Reset bit index
        enable = 1'b1;
        #300
        data_to_send = 8'd48;
        bit_index = 4'b0; // Reset bit index
        enable = 1'b1;
        #300
        data_to_send = 8'd48;
        bit_index = 4'b0; // Reset bit index
        enable = 1'b1;
        #300
        data_to_send = 8'd48;
        bit_index = 4'b0; // Reset bit index
        enable = 1'b1;
        #300
        data_to_send = 8'd48;
        bit_index = 4'b0; // Reset bit index
        enable = 1'b1;
        #300
        data_to_send = 8'd53;
        bit_index = 4'b0; // Reset bit index
        enable = 1'b1;
        #300
        data_to_send = 8'd10;
        bit_index = 4'b0; // Reset bit index
        enable = 1'b1;
        #3000
        data_to_send = 8'd82;
        bit_index = 4'b0; // Reset bit index
        enable = 1'b1;
        #300
        data_to_send = 8'd10;
        bit_index = 4'b0; // Reset bit index
        enable = 1'b1;
       
    end
    
    always begin
        #1 clk = ~clk;
    end
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            baud_counter <= 14'b0;
            tx_reg <= 1'b1;
        end else if (enable) begin
            if (baud_counter == CLOCK_DIVIDE) begin
                baud_counter <= 14'b0;

                if (bit_index == 4'b0) begin
                    // Start bit
                    tx_reg <= 1'b0;
                    bit_index <= bit_index + 1;
                end else if (bit_index <= 8) begin
                    // Data bits (LSB first)
                    tx_reg <= data_to_send[0];
                    data_to_send <= data_to_send >> 1;
                    bit_index <= bit_index + 1;
                end else if (bit_index == 9) begin
                    // Stop bit
                    tx_reg <= 1'b1;
                    bit_index <= bit_index + 1;
                end else begin
                    // Transmission complete, reset state
                    bit_index <= 4'b0;
                    enable <= 1'b0;
                end
            end else begin
                baud_counter <= baud_counter + 1;
            end
        end
    end
    
    
endmodule
