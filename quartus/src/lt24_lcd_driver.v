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
    output done,
    output initialized,

    // ILI9341 interface
    output tft_rst,
    output tft_csx,
    output tft_dcx,
    output tft_wrx,
    output tft_rdx,
    output [15:0] tft_data
);

    // FSM states
    localparam RESTART     = 2'd0,
               IDLE        = 2'd1,
               PRINT_PIXEL = 2'd2;

    reg [1:0] Sreg, Snext;
    
    // FSM Reset sub-states
    localparam RESET_START = 3'd0,
               RESET_LO    = 3'd1,
               RESET_WAIT  = 3'd2,
               RESET_INIT  = 3'd3,
               RESET_CLEAR = 3'd4,
               RESET_INIT2 = 3'd5,
               RESET_DONE  = 3'd6;
    localparam RESET_CLKS = 24'd5;  //500000; // ~30ms: delay clocks as specified in datasheet
    reg [2:0] reset_stage;  // Current reset sub-state
    reg [23:0] reset_clks;  // Delay counter

    reg done_flag;

    localparam PIXEL_NUM = 17'd76800;   // Total number of pixels (240x320) 
    reg [16:0] clear_cnt;   // Counter for the total number of pixels

    reg write_busy;         // Flag to add 1 clock cycle latency during write sequence, as per ILI9341 reference manual
    reg [16:0] write_data;  // Parallel data to send to ILI9341
    
    localparam INIT_LEN = 6'd49;    // Number of commands in the first initialization sequence
    reg [5:0] init_cnt;    // Counter for the current command in the first initialization sequence

    localparam INIT2_LEN = 4'd11;   // Number of commands in the second initialization sequence
    reg [3:0] init2_cnt;    // Counter for the current command in the second initialization sequence

    /* First sequence of ILI9341 initialization commands/data
     * idx: index of the command/data to be sent
     * return: 1 bit for the D/CX selector and 16 bit for the command/data
     */
    function [16:0] init_data(input [5:0] idx);
        case (idx)
            6'd0:   init_data = {1'b0, 16'h28};  // Display OFF
            6'd1:   init_data = {1'b0, 16'hCB};  // Power control A
            6'd2:   init_data = {1'b1, 16'h39};
            6'd3:   init_data = {1'b1, 16'h2C};
            6'd4:   init_data = {1'b1, 16'h00};
            6'd5:   init_data = {1'b1, 16'h34};
            6'd6:   init_data = {1'b1, 16'h02};
            6'd7:   init_data = {1'b0, 16'hCF};  // Power control B
            6'd8:   init_data = {1'b1, 16'h00};
            6'd9:   init_data = {1'b1, 16'hC1};
            6'd10:  init_data = {1'b1, 16'h30};
            6'd11:  init_data = {1'b0, 16'hE8};  // Driver timing control A
            6'd12:  init_data = {1'b1, 16'h85};
            6'd13:  init_data = {1'b1, 16'h00};
            6'd14:  init_data = {1'b1, 16'h78};
            6'd15:  init_data = {1'b0, 16'hEA};  // Driver timing control B
            6'd16:  init_data = {1'b1, 16'h00};
            6'd17:  init_data = {1'b1, 16'h00};
            6'd18:  init_data = {1'b0, 16'hED};  // Power on sequence control
            6'd19:  init_data = {1'b1, 16'h64};
            6'd20:  init_data = {1'b1, 16'h03};
            6'd21:  init_data = {1'b1, 16'h12};
            6'd22:  init_data = {1'b1, 16'h81};
            6'd23:  init_data = {1'b0, 16'hF7};  // Pump ratio control
            6'd24:  init_data = {1'b1, 16'h20};
            6'd25:  init_data = {1'b0, 16'hC0};  // Power Control 1: 4.60 V
            6'd26:  init_data = {1'b1, 16'h23};
            6'd27:  init_data = {1'b0, 16'hC1};  // Power Control 2
            6'd28:  init_data = {1'b1, 16'h10};
            6'd29:  init_data = {1'b0, 16'hC5};  // VCOM Control 1
            6'd30:  init_data = {1'b1, 16'h3e};
            6'd31:  init_data = {1'b1, 16'h28};
            6'd32:  init_data = {1'b0, 16'hC7};  // VCOM Control 2
            6'd33:  init_data = {1'b1, 16'h86};
            6'd34:  init_data = {1'b0, 16'h36};  // Memory Access Control
            6'd35:  init_data = {1'b1, 16'h88};
            6'd36:  init_data = {1'b0, 16'h3A};  // Pixel format
            6'd37:  init_data = {1'b1, 16'h55};
            6'd38:  init_data = {1'b0, 16'hB1};  // Frame Rate
            6'd39:  init_data = {1'b1, 16'h00};
            6'd40:  init_data = {1'b1, 16'h1B};
            6'd41:  init_data = {1'b0, 16'hB6};  // Display Function Control
            6'd42:  init_data = {1'b1, 16'h08};
            6'd43:  init_data = {1'b1, 16'h82};
            6'd44:  init_data = {1'b1, 16'h27};
            6'd45:  init_data = {1'b1, 16'h00};
            6'd46:  init_data = {1'b0, 16'h11};  // Exit sleep
            6'd47:  init_data = {1'b0, 16'h29};  // Display ON
            6'd48:  init_data = {1'b0, 16'h2C};  // Start memory write
            default: init_data = 17'd0;
        endcase
    endfunction

    /* Second sequence of ILI9341 initialization commands/data
     * idx: index of the command/data to be sent
     * return: 1 bit for the D/CX selector and 16 bit for the command/data
     */
    function [16:0] init2_data(input [3:0] idx);
        case (idx)
            4'd0:  init2_data = {1'b0, 16'h2A};  // Set column range
            4'd1:  init2_data = {1'b1, 16'h00};
            4'd2:  init2_data = {1'b1, 16'h28};
            4'd3:  init2_data = {1'b1, 16'h00};
            4'd4:  init2_data = {1'b1, 16'hc7};
            4'd5:  init2_data = {1'b0, 16'h2B};  // Set row range
            4'd6:  init2_data = {1'b1, 16'h00};
            4'd7:  init2_data = {1'b1, 16'h28};
            4'd8:  init2_data = {1'b1, 16'h00};
            4'd9:  init2_data = {1'b1, 16'hb7};
            4'd10: init2_data = {1'b0, 16'h2C};  // Start memory write
            default: init2_data = 17'd0;
        endcase
    endfunction

    assign tft_rst = reset_stage != RESET_LO;
    assign tft_csx = 1'b0; // Chip select enable (active low)
    assign tft_rdx = 1'b1; // Read disable (active low)
    assign tft_wrx = ~write_busy; // Pulse write (active low)
    assign tft_dcx = write_data[16]; // Command/Data select
    assign tft_data = write_data[15:0];
    assign initialized = !reset && reset_stage == RESET_DONE &&
                         reset_clks == 0 && init_cnt == INIT_LEN;
    assign done = done_flag;
    
    always @ (posedge clk)
        if (reset)
            Sreg <= RESTART;
        else Sreg <= Snext;

    always @ (*)
        case (Sreg)
            RESTART: if (initialized) Snext = IDLE;
                     else Snext = RESTART;

            IDLE: if (print && en) Snext = PRINT_PIXEL;
                  else Snext = IDLE;

            PRINT_PIXEL:
                if (done || ~en) Snext = IDLE;
                else Snext = PRINT_PIXEL;

            default: Snext = RESTART;
        endcase

    // Synchronous output layer. It is needed in order to control the timing of the instructions
    always @ (posedge clk)
        if (reset) begin
            init_cnt <= 6'b0;
            init2_cnt <= 4'b0;
            write_busy <= 1'b0;
            write_data <= 17'b0;
            reset_stage <= RESET_START;
            reset_clks <= RESET_CLKS;
            clear_cnt <= PIXEL_NUM;
            done_flag <= 1'b1;
        end else
                case (Sreg)
                    RESTART: begin
                        if (|reset_clks)
                            reset_clks <= reset_clks - 1'b1;
                        else if (reset_stage == RESET_START ||
                                 reset_stage == RESET_LO ||
                                 reset_stage == RESET_WAIT ||
                                 (reset_stage == RESET_INIT && init_cnt == INIT_LEN) ||
                                 (reset_stage == RESET_CLEAR && clear_cnt == 0) ||
                                 (reset_stage == RESET_INIT2 && init2_cnt == INIT2_LEN)) begin
                            reset_stage <= reset_stage + 1'b1;
                            reset_clks <= RESET_CLKS;
                        end else if (write_busy) begin
                            write_busy <= 1'b0;
                        end else if (init_cnt < INIT_LEN) begin
                            write_data <= init_data(init_cnt);
                            write_busy <= 1'b1;
                            init_cnt <= init_cnt + 1'b1;
                        end else if (|clear_cnt) begin
                            write_data <= {1'b1, 16'b0};
                            write_busy <= 1'b1;
                            clear_cnt <= clear_cnt - 1'b1;
                        end else if (init2_cnt < INIT2_LEN) begin
                            write_data <= init2_data(init2_cnt);
                            write_busy <= 1'b1;
                            init2_cnt <= init2_cnt + 1'b1;
                        end 
                    end
                    
                    PRINT_PIXEL: begin
                        if (write_busy) begin
                            write_busy <= 1'b0;
                            done_flag <= 1'b1;
                        end else if (print) begin
                            write_busy <= 1'b1;
                            done_flag <= 1'b0;
                            write_data <= {1'b1, pixel_rgb};
                        end
                    end
    
                    default: begin
                        write_busy <= 1'b0;
                        done_flag <= 1'b1;
                    end
                endcase

endmodule