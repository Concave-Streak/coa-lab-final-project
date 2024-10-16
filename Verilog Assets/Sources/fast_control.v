module ControlUnit_Fast (
    input clk,
    input reset,
    input continue,         // Continue signal (for halting)
    input  [3:0] op_code,   // 4-bit OP code
    output reg loadPC,      // Load Program Counter
    output reg writeReg,    // Register Write Enable
    output reg MemEn,       // Memory Read/Write
    output reg MemWen,      // Memory Write Enable
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
    parameter FETCH      = 2'b00;
    parameter DECODE     = 2'b01;
    parameter EXECUTE    = 2'b10;
    parameter UPDATE_PC  = 2'b11;

    // State registers
    reg [2:0] current_state, next_state;

    // FSM state transitions
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= FETCH; // Reset state to instruction fetch
        end else begin
            current_state <= next_state; // Move to the next state
        end
    end

    // Control logic based on FSM state and instruction opcode
    always @(posedge clk) begin
        // Default control signal values
        loadPC = 0;
        MemEn = 0;
        MemWen = 0;
        
        case (current_state)
            FETCH: begin
                next_state = DECODE;  // Move to the decode stage
            end

            DECODE: begin
                writeReg = 0;
                BRANCH  = 3'b000;
                DataSel = 2'b00;
                IMMsel = 0;
                next_state = EXECUTE;
            end                       //clock cycle for register read

            EXECUTE: begin
                case (op_code)
                    ALU: begin // ALU Operation
                        IMMsel = 0; // Use register value
                        DataSel = 2'b00; // Select ALU output
                        writeReg = 1;
                        next_state = UPDATE_PC; // Move to writeback stage
                    end

                    ALU_IMM: begin // ALU Immediate
                        IMMsel = 1; // Use immediate value
                        DataSel = 2'b00; // Select ALU output
                        writeReg = 1;
                        next_state = UPDATE_PC; // Move to writeback stage
                    end

                    LOAD: begin // Load instruction
                        MemEn = 1; // Enable memory access
                        IMMsel = 1;
                        MemWen = 0; // Read from memory
                        DataSel = 2'b01; // Select memory output
                        writeReg = 1;
                        next_state = UPDATE_PC;
                    end

                    STORE: begin // Store instruction
                        MemEn = 1; // Enable memory access
                        IMMsel = 1;
                        MemWen = 1; // Write to memory
                        writeReg = 0;
                        next_state = UPDATE_PC; // Move to PC update after store
                    end

                    BR: begin // Branch (BR)
                        IMMsel = 1;
                        BRANCH = 3'b001; // BR type
                        next_state = UPDATE_PC; // Move to PC update
                    end

                    BMI: begin // Branch if minus (BMI)
                        IMMsel = 1;
                        BRANCH = 3'b010; // BMI type
                        next_state = UPDATE_PC;
                    end

                    BPL: begin // Branch if positive (BPL)
                        IMMsel = 1;
                        BRANCH = 3'b011; // BPL type
                        next_state = UPDATE_PC;
                    end

                    BZ: begin // Branch if zero (BZ)
                        IMMsel = 1;
                        BRANCH = 3'b100; // BZ type
                        next_state = UPDATE_PC;
                    end

                    MOVE: begin // MOVE instruction
                        DataSel = 2'b00; // Select MOVE output
                        writeReg = 1;
                        next_state = UPDATE_PC; // Move to writeback stage
                    end

                    CMOV: begin // Conditional MOVE (CMOV)
                        IMMsel = 0;
                        DataSel = 2'b10; // Select CMOV output
                        writeReg = 1;
                        next_state = UPDATE_PC;
                    end

                    NOP: begin // NOP (No operation)
                        next_state = UPDATE_PC; // No operation, go to next instruction
                    end

                    HALT: begin // HALT instruction
                        if (continue) begin
                            next_state = UPDATE_PC; // Continue executing instructions if continue signal is high
                        end else begin
                            next_state = current_state; // Halt execution if continue signal is low
                        end
                    end

                    default: begin
                        next_state = UPDATE_PC; // Default case, go back to fetch state
                    end
                endcase
            end

            UPDATE_PC: begin
                loadPC = 1;
                next_state = FETCH; 
            end

            default: begin
                next_state = FETCH; // Default case, start fetching instructions
            end
        endcase
    end
endmodule
