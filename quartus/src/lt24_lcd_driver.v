/*
 * Driver for ILI9341 chip driving a 240x320 RGB display.
 *
 * This module takes the output signals and converts them to
 * IL9341 signals following the 16-bit 8080-I serial parallel interface.
 *
 * The input clock must be less than 30 MHz.
 * The module will write data to the ILI9341 at half this speed (i.e., 15 MHz).
 */

module lt24_lcd_driver (
    input clk,
    input en,
    input reset,
    input [15:0] pixel_rgb, // 16-bit RGB code (5-bit red, 6-bit green, 5-bit blue)
    input print,
    output reg done,
    output reg initialized,

    // ILI9341 interface
    output tft_rst,
    output tft_csx,
    output tft_dcx,
    output tft_wrx,
    output tft_rdx,
    output [15:0] tft_data
);

    // FSM states
    localparam RESET_START           = 4'd0,
               RESET_LOW             = 4'd1,
               RESET_WAIT_RST        = 4'd2,
               RESET_INIT            = 4'd3,
               RESET_INIT_WRITE_BUSY = 4'd4,
               RESET_WAIT_INIT       = 4'd5,
               IDLE                  = 4'd6,
               WRITE                 = 4'd7,
               WRITE_BUSY            = 4'd8;

    reg [3:0] Sreg, Snext;

    // Add counter to keep track of the number of clock cycles with tft_rst low (active)
    localparam RST_LOW_CLKS = 24'd300; // ~10us: reset low duration as specified in datasheet
    localparam RST_LOW_CLKS_NUM_BITS = $clog2(RST_LOW_CLKS);

    reg rst_low_cnt_reset_reg; // Reset for the rst_low counter
    reg rst_low_cnt_en_reg;    // Enable for the rst_low counter

    wire [RST_LOW_CLKS_NUM_BITS-1:0] rst_low_cnt; // rst_low counter
    wire rst_low_cnt_reset, rst_low_cnt_en;

    assign rst_low_cnt_reset = rst_low_cnt_reset_reg;
    assign rst_low_cnt_en = rst_low_cnt_en_reg;

    counter #(
        .MAX_VALUE(RST_LOW_CLKS)
    ) rst_low_counter_instance (
        .clk(clk),
        .en(rst_low_cnt_en),
        .reset(rst_low_cnt_reset),
        .count(rst_low_cnt)
    );

    // Add counter to keep track of the delay number of clock cycles needed during reset
    localparam RESET_CLKS = 24'd1500000; // ~120ms: delay clocks as specified in datasheet
    localparam RESET_CLKS_NUM_BITS = $clog2(RESET_CLKS);

    reg delay_cnt_reset_reg; // Reset for the delay counter
    reg delay_cnt_en_reg;    // Enable for the delay counter

    wire [RESET_CLKS_NUM_BITS-1:0] delay_cnt; // Delay counter
    wire delay_cnt_reset, delay_cnt_en;

    assign delay_cnt_reset = delay_cnt_reset_reg;
    assign delay_cnt_en = delay_cnt_en_reg;

    counter #(
        .MAX_VALUE(RESET_CLKS)
    ) delay_counter_instance (
        .clk(clk),
        .en(delay_cnt_en),
        .reset(delay_cnt_reset),
        .count(delay_cnt)
    );
    
    // Add counter for the initialization command sequence
    localparam INIT_LEN = 6'd62;    // Number of commands in the initialization sequence
    localparam INIT_NUM_BITS = $clog2(INIT_LEN);
    
    reg init_cnt_reset_reg; // Reset for the initialization sequence counter
    reg init_cnt_en_reg;    // Enable for the initialization sequence counter

    wire [INIT_NUM_BITS-1:0] init_cnt;  // Counter for the current command in the initialization sequence
    wire init_cnt_reset, init_cnt_en;
    
    assign init_cnt_reset = init_cnt_reset_reg;
    assign init_cnt_en = init_cnt_en_reg;

    counter #(
        .MAX_VALUE(INIT_LEN)
    ) init_counter_instance (
        .clk(clk),
        .en(init_cnt_en),
        .reset(init_cnt_reset),
        .count(init_cnt)
    );

    /* Sequence of ILI9341 initialization commands/data
     * idx: index of the command/data to be sent
     * return: 1 bit for the D/CX selector and 16 bit for the command/data
     */
    function [16:0] init_data(input [INIT_NUM_BITS-1:0] idx);
        case (idx)
            0:   init_data = {1'b0, 16'h01};  // Software reset
            1:   init_data = {1'b0, 16'h28};  // Display OFF
            2:   init_data = {1'b0, 16'hCB};  // Power control A
            3:   init_data = {1'b1, 16'h39};
            4:   init_data = {1'b1, 16'h2C};
            5:   init_data = {1'b1, 16'h00};
            6:   init_data = {1'b1, 16'h34};
            7:   init_data = {1'b1, 16'h02};
            8:   init_data = {1'b0, 16'hCF};  // Power control B
            9:   init_data = {1'b1, 16'h00};
            10:  init_data = {1'b1, 16'hC1};
            11:  init_data = {1'b1, 16'h30};
            12:  init_data = {1'b0, 16'hE8};  // Driver timing control A
            13:  init_data = {1'b1, 16'h85};
            14:  init_data = {1'b1, 16'h00};
            15:  init_data = {1'b1, 16'h78};
            16:  init_data = {1'b0, 16'hEA};  // Driver timing control B
            17:  init_data = {1'b1, 16'h00};
            18:  init_data = {1'b1, 16'h00};
            19:  init_data = {1'b0, 16'hED};  // Power on sequence control
            20:  init_data = {1'b1, 16'h64};
            21:  init_data = {1'b1, 16'h03};
            22:  init_data = {1'b1, 16'h12};
            23:  init_data = {1'b1, 16'h81};
            24:  init_data = {1'b0, 16'hF7};  // Pump ratio control
            25:  init_data = {1'b1, 16'h20};
            26:  init_data = {1'b0, 16'hC0};  // Power Control 1: 4.60 V
            27:  init_data = {1'b1, 16'h23};
            28:  init_data = {1'b0, 16'hC1};  // Power Control 2
            29:  init_data = {1'b1, 16'h10};
            30:  init_data = {1'b0, 16'hC5};  // VCOM Control 1
            31:  init_data = {1'b1, 16'h2B};
            32:  init_data = {1'b1, 16'h2B};
            33:  init_data = {1'b0, 16'hC7};  // VCOM Control 2
            34:  init_data = {1'b1, 16'hC0};
            35:  init_data = {1'b0, 16'h36};  // Memory Access Control
            36:  init_data = {1'b1, 16'h20}; // A4
            37:  init_data = {1'b0, 16'h3A};  // Pixel format
            38:  init_data = {1'b1, 16'h55};
            39:  init_data = {1'b0, 16'hB1};  // Frame Rate
            40:  init_data = {1'b1, 16'h00};
            41:  init_data = {1'b1, 16'h1B};
            42:  init_data = {1'b0, 16'hB6};  // Display Function Control
            43:  init_data = {1'b1, 16'h08};
            44:  init_data = {1'b1, 16'h82};
            45:  init_data = {1'b1, 16'h27};
            46:  init_data = {1'b1, 16'h00};
            47:  init_data = {1'b0, 16'hB7};
            48:  init_data = {1'b1, 16'h07};
            49:  init_data = {1'b0, 16'h11};  // Exit sleep
            50:  init_data = {1'b0, 16'h29};  // Display ON
            51:  init_data = {1'b0, 16'h2A};  // Set column range
            52:  init_data = {1'b1, 16'h00};  // Start from column 0
            53:  init_data = {1'b1, 16'h00};
            54:  init_data = {1'b1, 16'h01};  // End at column 319
            55:  init_data = {1'b1, 16'h3f};
            56:  init_data = {1'b0, 16'h2B};  // Set row range
            57:  init_data = {1'b1, 16'h00};  // Start form row 0
            58:  init_data = {1'b1, 16'h00};
            59:  init_data = {1'b1, 16'h00};  // End at row 239
            60:  init_data = {1'b1, 16'hef};
            61:  init_data = {1'b0, 16'h2C};  // Start memory write
            default: init_data = 17'd0;
        endcase
    endfunction

    wire [16:0] write_data;   // Parallel data to send to ILI9341
    reg [15:0] pixel_rgb_reg; // Buffer for the input RGB color

    assign write_data = init_data(init_cnt); // Command taken form the initialization sequence LUT

    // ILI9341 interface
    assign tft_rst = Sreg != RESET_LOW;                              // Pulse reset (active low)
    assign tft_csx = 1'b0;                                           // Chip select enable (active low)
    assign tft_rdx = 1'b1;                                           // Read disable (active low)
    assign tft_wrx = ~(Sreg == WRITE || Sreg == RESET_INIT);         // Pulse write (active low)
    // When in the initialization phase the output data is taken from the initialization sequence.
    // Otherwise it is the buffered pixel RGB value
    assign tft_dcx = (Sreg < IDLE) ? write_data[16] : 1'b1; // Command/Data select
    assign tft_data = (Sreg < IDLE) ? write_data[15:0] : pixel_rgb_reg;    

    // Update current state
    always @ (posedge clk)
        if (reset) begin
            Sreg <= RESET_START;
            pixel_rgb_reg <= 16'b0;
        end else begin
            Sreg <= Snext;

            // Update input RGB value
            pixel_rgb_reg <= pixel_rgb;   
        end

    // Evaluate next state
    always @ (*)
        case (Sreg)
            RESET_START: Snext = RESET_LOW;

            RESET_LOW:
                if (rst_low_cnt == (RST_LOW_CLKS - 1'b1))
                    Snext = RESET_WAIT_RST;
                else
                    Snext = RESET_LOW;

            RESET_WAIT_RST:
                if (delay_cnt == (RESET_CLKS - 1'b1))
                    Snext = RESET_INIT;
                else
                    Snext = RESET_WAIT_RST;

            RESET_INIT: Snext = RESET_INIT_WRITE_BUSY;  // Wait 1 clock cycle between each write as specified in the datasheet

            RESET_INIT_WRITE_BUSY:
                if (init_cnt == 0 || init_cnt == 49) // Wait 120ms after software reset and sleep out commands 
                    Snext = RESET_WAIT_INIT;
                else if (init_cnt == (INIT_LEN - 1'b1))  // The initialization command sequence is finished
                    Snext = IDLE;
                else
                    Snext = RESET_INIT; // Continue with the initialization command sequence

            RESET_WAIT_INIT:
                if (delay_cnt == (RESET_CLKS - 1'b1))
                    Snext = RESET_INIT;
                else
                    Snext = RESET_WAIT_INIT;

            IDLE:
                if (print && en)
                    Snext = WRITE;
                else
                    Snext = IDLE;
            
            WRITE: Snext = WRITE_BUSY;
            
            WRITE_BUSY:
                if (print && en)
                    Snext = WRITE;
                else
                    Snext = IDLE;

            default: Snext = RESET_START;
        endcase

    always @ (Sreg) begin
        delay_cnt_en_reg = 1'b0;
        delay_cnt_reset_reg = 1'b1;
        rst_low_cnt_en_reg = 1'b0;
        rst_low_cnt_reset_reg = 1'b1;
        init_cnt_en_reg = 1'b0;
        init_cnt_reset_reg = 1'b1;

        done = 1'b0;
        initialized = 1'b0;

        case (Sreg)
            RESET_LOW: begin
                rst_low_cnt_en_reg = 1'b1;
                rst_low_cnt_reset_reg = 1'b0;
            end

            RESET_WAIT_RST: begin
                delay_cnt_en_reg = 1'b1;
                delay_cnt_reset_reg = 1'b0;
            end

            RESET_INIT: begin
                init_cnt_en_reg = 1'b0;
                init_cnt_reset_reg = 1'b0;
            end

            RESET_INIT_WRITE_BUSY: begin
                init_cnt_en_reg = 1'b1;
                init_cnt_reset_reg = 1'b0;
            end

            RESET_WAIT_INIT: begin
                delay_cnt_en_reg = 1'b1;
                delay_cnt_reset_reg = 1'b0;
                init_cnt_en_reg = 1'b0;
                init_cnt_reset_reg = 1'b0;
            end

            IDLE: begin
                done = 1'b1;
                initialized = 1'b1;
            end

            WRITE: begin
                done = 1'b0;
                initialized = 1'b1;
            end

            WRITE_BUSY: begin
                done = 1'b0;
                initialized = 1'b1;
            end

            default: begin
                delay_cnt_en_reg = 1'b0;
                delay_cnt_reset_reg = 1'b1;
                rst_low_cnt_en_reg = 1'b0;
                rst_low_cnt_reset_reg = 1'b1;
                init_cnt_en_reg = 1'b0;
                init_cnt_reset_reg = 1'b1;
        
                done = 1'b0;
                initialized = 1'b0;
            end
        endcase
    end

endmodule