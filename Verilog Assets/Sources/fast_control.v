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
    parameter ALU = 4'h0;
    parameter ALU_IMM = 4'h1;
    parameter LOAD = 4'h2;
    parameter STORE = 4'h3; 
    parameter BR = 4'h4; 
    parameter BMI = 4'h5; 
    parameter BPL = 4'h6; 
    parameter BZ = 4'h7;
    parameter MOVE = 4'h8;
    parameter CMOV = 4'h9;
    parameter HALT = 4'hF;
    parameter NOP = 4'hE;  

    // FSM state definitions
    parameter FETCH  = 2'b00;
    parameter DECODE = 2'b01;
    parameter EXECUTE = 2'b10;
    parameter WRITEBACK = 2'b11;

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
    always @(*) begin
        // Default control signal values
        loadPC = 0;
        writeReg = 0;
        MemEn = 0;
        MemWen = 0;
        
        case (current_state)
            FETCH: begin
                next_state = DECODE;  
            end

            DECODE: begin
                next_state = EXECUTE;
            end                     

            EXECUTE: begin
                //default values
                BRANCH = 3'b000;
                loadPC = 1;
                next_state = FETCH;

                case (op_code)
                    ALU: begin
                        IMMsel = 0;
                        DataSel = 2'b00;
                        writeReg = 1;
                    end

                    ALU_IMM: begin 
                        IMMsel = 1;
                        DataSel = 2'b00;
                        writeReg = 1;
                    end

                    LOAD: begin 
                        MemEn = 1; // Enable memory access
                        IMMsel = 1;                    
                        MemWen = 0; // Read from memory
                        DataSel = 2'b01; // Select memory output
                        loadPC = 0;
                        next_state = WRITEBACK;
                    end

                    STORE: begin 
                        MemEn = 1; // Enable memory access
                        IMMsel = 1;
                        MemWen = 1; // Write to memory
                        writeReg = 0;          
                    end

                    BR: begin
                        IMMsel = 1;
                        BRANCH = 3'b001; // BR type
                    end

                    BMI: begin // Branch if minus (BMI)
                        IMMsel = 1;
                        BRANCH = 3'b010; // BMI type
                        
                    end

                    BPL: begin // Branch if positive (BPL)
                        IMMsel = 1;
                        BRANCH = 3'b011; // BPL type
                        
                    end

                    BZ: begin // Branch if zero (BZ)
                        IMMsel = 1;
                        BRANCH = 3'b100; // BZ type
                        
                    end

                    MOVE: begin 
                        writeReg = 1;
                        DataSel = 2'b00; // Select MOVE output
                    end

                    CMOV: begin 
                        writeReg = 1;
                        IMMsel = 0;
                        DataSel = 2'b10; // Select CMOV output                
                    end

                    NOP: begin
                        //pass
                    end

                    HALT: begin 
                        if (continue) begin
                            //pass
                        end else begin
                            loadPC = 0;
                            next_state = current_state; 
                        end
                    end

                    default: begin
                        //pass
                    end
                endcase
            end


            WRITEBACK: begin
                writeReg = 1;
                loadPC = 1;
                next_state = FETCH; 
            end

            default: begin
                next_state = FETCH;
            end
        endcase
    end
endmodule
