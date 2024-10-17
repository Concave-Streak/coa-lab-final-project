module BranchControl (
    input  [31:0] PC_plus,  // PC + 4 input
    input  [31:0] A,          // Register A input (used for branch conditions)
    input  [31:0] B,          // Register B input (used for conditional move)
    input  [2:0]  BRANCH,     // 3-bit branch control line
    output [31:0] NPC,    // Next Program Counter output
    output [31:0] CMOV_out // Conditional Move (CMOV) result
);

    // BRANCH types
    parameter NB = 3'b000;  // No branch
    parameter BR  = 3'b001;  // Unconditional branch
    parameter BMI = 3'b010;  // Branch if A < 0 (negative)
    parameter BPL = 3'b011;  // Branch if A > 0 (positive)
    parameter BZ  = 3'b100;  // Branch if A == 0 (zero)
    parameter JR = 3'b101;

    assign CMOV_out = (A>B) ? A : B;

    assign GT = (A > 0) ? 1 : 0;
    assign LT = (A < 0) ? 1 : 0;
    assign EQ = (A == 0) ? 1 : 0;

    assign condition = (BRANCH == BR) || ((BRANCH == BMI) & LT) || ((BRANCH == BPL) & GT) || ((BRANCH == BZ) & EQ);

    assign jump = (BRANCH!=NB) & condition;
    
    wire [31:0] NPC_eff;
    assign NPC_eff = (jump) ? PC_plus + B : PC_plus;
    
    assign NPC = (BRANCH==JR) ? B : NPC_eff;

endmodule
