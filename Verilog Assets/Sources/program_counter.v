module PC_reg (
    input wire clk,       // Clock signal
    input wire rst,       // Asynchronous reset signal
    input wire load,      // Load enable signal
    input wire [31:0] PCin,  // 32-bit input data
    output reg [31:0] PCout   // 32-bit output register
);
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            PCout <= 32'b0;
        end else if (load) begin
            PCout <= PCin;
        end
    end
    
endmodule

