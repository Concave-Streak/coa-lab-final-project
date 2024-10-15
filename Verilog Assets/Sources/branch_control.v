module BranchControl (
    input  [31:0] PC_plus_4,  // PC + 4 input
    input  [31:0] A,          // Register A input (used for branch conditions)
    input  [31:0] B,          // Register B input (used for conditional move)
    input  [2:0]  BRANCH,     // 3-bit branch control line
    output reg [31:0] NPC,    // Next Program Counter output
    output reg [31:0] CMOV_out // Conditional Move (CMOV) result
);

    // BRANCH types
    parameter BR  = 3'b001;  // Unconditional branch
    parameter BMI = 3'b010;  // Branch if A < 0 (negative)
    parameter BPL = 3'b011;  // Branch if A > 0 (positive)
    parameter BZ  = 3'b100;  // Branch if A == 0 (zero)
    parameter CMOV = 3'b101; // Conditional move (if A < B ? A : B)

    always @(*) begin
        // Default output values
        NPC = PC_plus_4;      // By default, PC advances normally (PC + 4)
        CMOV_out = A;         // Default CMOV output to A

        case (BRANCH)
            BR: begin
                // Unconditional branch: NPC = PC + 4 + immediate
                NPC = PC_plus_4 + B;
            end

            BMI: begin
                // Branch if A < 0 (BMI): NPC = PC + 4 + immediate if A < 0
                if ($signed(A) < 0) begin
                    NPC = PC_plus_4 + B;
                end
            end

            BPL: begin
                // Branch if A > 0 (BPL): NPC = PC + 4 + immediate if A > 0
                if ($signed(A) > 0) begin
                    NPC = PC_plus_4 + B;
                end
            end

            BZ: begin
                // Branch if A == 0 (BZ): NPC = PC + 4 + immediate if A == 0
                if (A == 0) begin
                    NPC = PC_plus_4 + B;
                end
            end

            CMOV: begin
                // Conditional Move (CMOV): CMOV_out = (A < B) ? A : B
                CMOV_out = ($signed(A) < $signed(B)) ? A : B;
            end

            default: begin
                // No branch or invalid BRANCH signal, default to PC + 4
                NPC = PC_plus_4;
            end
        endcase
    end
endmodule
