module UART_IO (
    input wire clk,         // Clock signal
    input wire rst_n,       // Active low reset
    input wire [3:0] addr,  // Address input from CPU
    input wire [31:0] data_in,  // Data to be written by CPU
    output reg [31:0] data_out, // Data to be read by CPU
    input wire write_enable,    // Write enable signal from CPU
    input wire read_enable,     // Read enable signal from CPU
    output reg tx,          // UART transmit line
    input wire rx,          // UART receive line
    output reg busy         // Busy signal to indicate UART is transmitting or receiving
);

    // Define register addresses
    localparam COMMAND_REG_ADDR = 1'h0;
    localparam DATA_REG_ADDR = 1'h1;

    // Define registers
    reg [31:0] command_reg;  // Command register (only bit 0 is used)
    reg [31:0] data_reg;     // Data register (stores the data to be sent/received)
    reg [7:0] tx_data;       // Byte to be transmitted (from data_reg)
    reg [31:0] bcd_val;      // BCD representation of data_reg

    // UART transmission state
    reg [3:0] bit_index;     // Tracks the bit being transmitted/received
    reg [7:0] shift_reg;     // Shift register for serial transmission
    reg tx_start;            // Flag to indicate the start of transmission
    reg idle;                // Flag to indicate idle state
    reg [2:0] bcd_index;     // Index for BCD digit transmission
    reg [2:0] state;         // FSM state for BCD transmission

    // FSM states
    localparam IDLE = 3'b000;
    localparam LOAD_FIRST_BCD = 3'b100;
    localparam LOAD_BCD = 3'b001;
    localparam TRANSMIT_BCD = 3'b010;
    localparam RESET_CMD = 3'b011;

    // UART reception state
    reg rx_start;            // Flag to indicate the start of reception
    reg [7:0] rx_shift_reg;  // Shift register for receiving data
    reg [13:0] baud_counter; // Counter for baud rate timing
    reg [7:0] rx_data;       // Received byte

    // UART parameters (assuming 9600 baud, adjust accordingly)
    localparam CLOCK_DIVIDE = 10; // Clock divider for 9600 baud with a 100MHz clock

    // BCD conversion module instance
    wire [31:0] bcd_out;
    bin32_to_bcd bin32_to_bcd_inst (
        .bin(data_reg),
        .bcd(bcd_out)
    );

    // UART logic
    always @(posedge clk or posedge rst_n) begin
        if (rst_n) begin
            command_reg <= 32'b0;
            data_reg <= 32'b0;
            tx <= 1'b1;          // Idle state of UART TX line is high
            busy <= 1'b0;
            tx_start <= 1'b0;
            bit_index <= 4'b0;
            shift_reg <= 8'b0;
            idle <= 1'b1;
            baud_counter <= 14'b0;
            rx_start <= 1'b0;
            rx_shift_reg <= 8'b0;
            bcd_index <= 3'b111; // Default to highest index
            bcd_val <= 0;
            state <= IDLE;       // Initialize FSM state
        end else begin
            if (write_enable && idle) begin
                // CPU writes to command or data registers
                if (addr == COMMAND_REG_ADDR) begin
                    command_reg <= data_in;
                end else if (addr == DATA_REG_ADDR && command_reg == 32'b0) begin
                    data_reg <= data_in;
                end
            end

            // UART Transmission Logic for Binary Data
            if (command_reg == 32'h1 && idle) begin
                tx_data <= data_reg[7:0]; // Transmit only the first byte
                tx_start <= 1'b1;         // Trigger transmission
                idle <= 1'b0;             // Exit idle state
                busy <= 1'b1;             // UART is now busy
            end

            // Handle UART transmission
            if (tx_start) begin
                if (baud_counter == CLOCK_DIVIDE) begin
                    baud_counter <= 14'b0;

                    if (bit_index == 4'b0) begin
                        // Start bit
                        tx <= 1'b0;
                        shift_reg <= tx_data; // Load byte into shift register
                        bit_index <= bit_index + 1;
                    end else if (bit_index < 9) begin
                        // Transmitting data bits (LSB first)
                        tx <= shift_reg[0];
                        shift_reg <= shift_reg >> 1;
                        bit_index <= bit_index + 1;
                    end else if (bit_index == 9) begin
                        // Stop bit
                        tx <= 1'b1;
                        bit_index <= bit_index + 1;
                    end else if (command_reg == 1) begin
                        // Transmission complete
                        bit_index <= 4'b0;
                        tx_start <= 1'b0;
                        busy <= 1'b0;
                        idle <= 1'b1;
                        command_reg <= 32'b0;     // Reset command register
                    end
                end else begin
                    baud_counter <= baud_counter + 1;
                end
            end

            // FSM for BCD transmission
            case (state)
                IDLE: begin
                    if (command_reg == 32'h3 && idle) begin
                        bcd_val <= bcd_out;  // Get BCD value
                        bcd_index <= 3'b111; // Start with most significant digit
                        state <= LOAD_FIRST_BCD;   // Move to LOAD_BCD state
                        busy <= 1'b1;
                        idle <= 1'b0;
                    end
                end

                
                LOAD_FIRST_BCD: begin
                    // Skip leading zeros, but at least transmit one digit
                    if (bcd_val[31:28] != 4'b0000 || bcd_index == 0) begin
                        // Convert BCD digit to ASCII
                        tx_data <= bcd_val[31:28] + 8'h30; // BCD to ASCII
                        state <= TRANSMIT_BCD;   // Move to TRANSMIT_BCD state
                        tx_start <= 1'b1;        // Start transmission
                    end else begin
                        // Shift left by 4 bits to move to the next BCD digit
                        bcd_val <= bcd_val << 4;
                        bcd_index <= bcd_index - 1;
                    end
                end

              
                LOAD_BCD: begin
                    tx_data <= bcd_val[31:28] + 8'h30; // BCD to ASCII
                    state <= TRANSMIT_BCD;   // Move to TRANSMIT_BCD state
                    tx_start <= 1'b1;        // Start transmission
                end

                TRANSMIT_BCD: begin
                    if (tx_start && baud_counter == CLOCK_DIVIDE) begin
                        baud_counter <= 14'b0;

                        if (bit_index == 4'b0) begin
                            // Start bit
                            tx <= 1'b0;
                            shift_reg <= tx_data; // Load byte into shift register
                            bit_index <= bit_index + 1;
                        end else if (bit_index < 9) begin
                            // Transmitting data bits (LSB first)
                            tx <= shift_reg[0];
                            shift_reg <= shift_reg >> 1;
                            bit_index <= bit_index + 1;
                        end else if (bit_index == 9) begin
                            // Stop bit
                            tx <= 1'b1;
                            bit_index <= bit_index + 1;
                        end else begin
                            // Transmission complete for one digit
                            bit_index <= 4'b0;
                            tx_start <= 1'b0;

                            // If there are more digits to transmit, go to LOAD_BCD
                            if (bcd_index > 0) begin
                                bcd_val <= bcd_val << 4; // Shift to next digit
                                bcd_index <= bcd_index - 1;
                                state <= LOAD_BCD;
                            end else begin
                                // If all digits are done, go to RESET_CMD
                                state <= RESET_CMD;
                            end
                        end
                    end else begin
                        baud_counter <= baud_counter + 1;
                    end
                end

                RESET_CMD: begin
                    busy <= 1'b0;
                    idle <= 1'b1;
                    command_reg <= 32'b0;   // Reset command register
                    state <= IDLE;          // Go back to IDLE state
                end
            endcase

            // UART Reception Logic remains unchanged
            if (command_reg == 32'h2 && idle) begin
                if (!rx_start && rx == 1'b0) begin
                    // Start receiving when the start bit (0) is detected
                    rx_start <= 1'b1;
                    baud_counter <= 0;
                    bit_index <= 0;
                    busy <= 1'b1;
                    idle <= 1'b0;
                end
            end

            if (rx_start) begin
                if (baud_counter == CLOCK_DIVIDE) begin
                    baud_counter <= 14'b0;

                    if (bit_index < 8) begin
                        // Receiving data bits (LSB first)
                        rx_shift_reg <= {rx, rx_shift_reg[7:1]}; // Shift in the RX data
                        bit_index <= bit_index + 1;
                    end else if (bit_index == 8) begin
                        // Stop bit (ignore for now)
                        bit_index <= bit_index + 1;
                    end else begin
                        // Reception complete
                        rx_data <= rx_shift_reg; // Store received byte
                        data_reg <= {24'b0, rx_shift_reg}; // Save received byte in data_reg
                        rx_start <= 1'b0;
                        busy <= 1'b0;
                        idle <= 1'b1;
                        command_reg <= 32'b0;     // Reset command register
                        bit_index <= 0;
                    end
                end else begin
                    baud_counter <= baud_counter + 1;
                end
            end
        end
    end

    // Read logic for the CPU
    always @(posedge clk) begin
        if (read_enable) begin
            if (addr == COMMAND_REG_ADDR) begin
                data_out <= command_reg;
            end else if (addr == DATA_REG_ADDR) begin
                data_out <= data_reg;
            end else begin
                data_out <= 32'b0;
            end
        end
    end

endmodule
