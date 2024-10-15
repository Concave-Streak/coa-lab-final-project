module ControlUnit_FSM (
    input  clk,             // Clock signal
    input  reset,           // Reset signal
    input  [3:0] op_code,   // 4-bit OP code
    output reg loadPC,      // Load Program Counter
    output reg MemRW,       // Memory Read/Write
    output reg IMMsel,      // Select between RS2 or Immediate
    output reg [1:0] DataSel, // Data select (ALU, memory, CMOV)
    output reg [2:0] BRANCH // Branch select (no branch, BR, BMI, BPL, BZ, CMOV)
);

    // OP code mappings
    parameter ALU        = 4'h0;  // ALU operation
    parameter ALU_IMM    = 4'h1;  // ALU immediate operation
    parameter LOAD       = 4'h2;  // Load instruction
    parameter STORE      = 4'h3;  // Store instruction
    parameter BR         = 4'h4;  // Branch instruction
    parameter BMI        = 4'h5;  // Branch if minus
    parameter BPL        = 4'h6;  // Branch if positive
    parameter BZ         = 4'h7;  // Branch if zero
    parameter MOVE       = 4'h8;  // Move instruction
    parameter CMOV       = 4'h9;  // Conditional move instruction
    parameter HALT       = 4'hF;  // Halt instruction
    parameter NOP        = 4'hE;  // No operation

    // FSM state definitions
    parameter FETCH      = 3'b000;
    parameter DECODE     = 3'b001;
    parameter EXECUTE    = 3'b010;
    parameter MEMORY     = 3'b011;
    parameter WRITEBACK  = 3'b100;
    parameter UPDATE_PC  = 3'b101;

    // State registers
    reg [2:0] current_state, next_state;

    // Registers to store control signals between states
    reg [3:0] opcode_reg;

    // FSM state transitions
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= FETCH; // Reset state to instruction fetch
        end else begin
            current_state <= next_state; // Move to the next state
        end
    end

    // Control logic based on FSM state and instruction opcode
    always @(*) begin
        // Default control signal values
        loadPC  = 0;
        MemRW   = 0;
        IMMsel  = 0;
        DataSel = 2'b00;
        BRANCH  = 3'b000;

        case (current_state)
            FETCH: begin
                // Fetch instruction (update opcode_reg)
                loadPC = 1;  // Load PC to fetch the next instruction
                next_state = DECODE;  // Move to the decode stage
            end

            DECODE: begin
                // Decode instruction
                opcode_reg = op_code; // Store opcode for further states
                next_state = EXECUTE;
            end

            EXECUTE: begin
                case (opcode_reg)
                    ALU: begin // ALU Operation
                        IMMsel = 0; // Use register value
                        DataSel = 2'b00; // Select ALU output
                        next_state = WRITEBACK; // Move to writeback stage
                    end

                    ALU_IMM: begin // ALU Immediate
                        IMMsel = 1; // Use immediate value
                        DataSel = 2'b00; // Select ALU output
                        next_state = WRITEBACK; // Move to writeback stage
                    end

                    LOAD: begin // Load instruction
                        next_state = MEMORY; // Move to memory access stage
                    end

                    STORE: begin // Store instruction
                        MemRW = 1; // Enable memory write
                        next_state = MEMORY; // Move to memory access stage
                    end

                    BR: begin // Branch (BR)
                        loadPC = 1; // Update PC for branch
                        BRANCH = 3'b001; // BR type
                        next_state = UPDATE_PC; // Move to PC update
                    end

                    BMI: begin // Branch if minus (BMI)
                        loadPC = 1;
                        BRANCH = 3'b010; // BMI type
                        next_state = UPDATE_PC;
                    end

                    BPL: begin // Branch if positive (BPL)
                        loadPC = 1;
                        BRANCH = 3'b011; // BPL type
                        next_state = UPDATE_PC;
                    end

                    BZ: begin // Branch if zero (BZ)
                        loadPC = 1;
                        BRANCH = 3'b100; // BZ type
                        next_state = UPDATE_PC;
                    end

                    MOVE: begin // MOVE instruction
                        DataSel = 2'b10; // Select MOVE output
                        next_state = WRITEBACK; // Move to writeback stage
                    end

                    CMOV: begin // Conditional MOVE (CMOV)
                        DataSel = 2'b10; // Select CMOV output
                        BRANCH = 3'b101; // CMOV operation
                        next_state = WRITEBACK;
                    end

                    NOP: begin // NOP (No operation)
                        next_state = UPDATE_PC; // No operation, go to next instruction
                    end

                    HALT: begin // HALT instruction
                        // No state transition, halt the machine
                        next_state = current_state; // Remain in halt state
                    end

                    default: begin
                        next_state = FETCH; // Default case, go back to fetch state
                    end
                endcase
            end

            MEMORY: begin
                if (opcode_reg == LOAD) begin // Load instruction
                    MemRW = 0; // Read from memory
                    DataSel = 2'b01; // Select memory output
                    next_state = WRITEBACK;
                end else if (opcode_reg == STORE) begin // Store instruction
                    MemRW = 1; // Write to memory
                    next_state = UPDATE_PC; // Move to PC update after store
                end
            end

            WRITEBACK: begin
                // Write result back to register file (if necessary)
                next_state = UPDATE_PC; // Move to PC update
            end

            UPDATE_PC: begin
                // Update the Program Counter
                loadPC = 1; // Load the next instruction address into PC
                next_state = FETCH; // Go back to fetch the next instruction
            end

            default: begin
                next_state = FETCH; // Default case, start fetching instructions
            end
        endcase
    end
endmodule
