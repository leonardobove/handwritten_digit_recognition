/*
 *  This module loops over the frame buffer memory and prints
 *  each pixel to the LCD display.
 */

module graphic_controller (
    input clk,
    input en,
    input reset,
    output initialized,

    // 1 bit color frame RAM interface (read port only)
    output [16:0] read_addr,          // Read address for the memory
    input ram_q,                      // Data output (1 bit)

    // LT24 LCD driver interface
    output [15:0] pixel_rgb,
    output print,
    input driver_done,
    input driver_initialized
);

    // FSM states
    localparam RESET             = 3'd0,
               WAIT_DRIVER_INIT  = 3'd1,
               IDLE              = 3'd2,
               WAIT_RAM          = 3'd3,
               WAIT_DRIVER_DONE  = 3'd4;

    // Current state and future state
    reg [2:0] Sreg, Snext;

    localparam ROW_NUM = 8'd240;      // Rows number
    localparam COL_NUM = 9'd320;      // Columns number
    localparam PIXEL_NUM = 17'd76800; // Pixels number

    // Add counter as a pointer to the frame RAM, in order to continuously update the LCD frame
    localparam POINTER_WIDTH = $clog2(PIXEL_NUM);
    reg ram_pointer_en_reg;     // Enable for the pointer counter
    reg ram_pointer_reset_reg;  // Reset for the pointer counter

    wire [POINTER_WIDTH-1:0] ram_pointer;
    wire ram_pointer_en, ram_pointer_reset;

    assign ram_pointer_en = ram_pointer_en_reg && en;
    assign ram_pointer_reset = ram_pointer_reset_reg;

    counter #(
        .MAX_VALUE(PIXEL_NUM)
    ) ram_pointer_instance (
        .clk(clk),
        .en(ram_pointer_en),
        .reset(ram_pointer_reset),
        .count(ram_pointer)
    );

    // Flag to signal that the initialization is complete
    assign initialized = (Sreg >= IDLE);

    // Frame buffer memory interface
    assign read_addr = ram_pointer;

    // ILI9341 LCD interface
    assign pixel_rgb = rgb565_color(ram_q);
    assign print = (Sreg == WAIT_DRIVER_DONE);

    /* Convert 1-bit color to RGB565 color.
     * The following mapping is used:
     *  BW  RGB565
     *  0   0000
     *  1   ffff
     */
    function [15:0] rgb565_color(input col);
        case (col)
            1'b0: rgb565_color = 16'h0000;  // Black
            1'b1: rgb565_color = 16'hffff;  // White
        endcase
    endfunction

    // Update current status
    always @ (posedge clk)
        if (reset) begin
            Sreg <= RESET;
        end else
            if (en)
                Sreg <= Snext;
            else
                Sreg <= Sreg;

    // Evaluate next state
    always @ (*) begin
        case (Sreg)
            RESET: Snext = WAIT_DRIVER_INIT;
            
            WAIT_DRIVER_INIT:
                if (driver_initialized)
                    Snext = IDLE;
                else
                    Snext = WAIT_DRIVER_INIT;

            IDLE:
                if (en)
                    Snext = WAIT_RAM;
                else
                    Snext = IDLE;

            WAIT_RAM: Snext = WAIT_DRIVER_DONE;

            WAIT_DRIVER_DONE: Snext = IDLE;

            default: Snext = RESET;
        endcase
    end

    always @ (Sreg) begin
        ram_pointer_en_reg = 1'b0;
        ram_pointer_reset_reg = 1'b1;

        case (Sreg)
            WAIT_DRIVER_INIT: begin
                ram_pointer_en_reg = 1'b0;
                ram_pointer_reset_reg = 1'b1;
            end

            IDLE: begin
                ram_pointer_en_reg = 1'b0;
                ram_pointer_reset_reg = 1'b0;
            end

            WAIT_RAM: begin
                ram_pointer_en_reg = 1'b0;
                ram_pointer_reset_reg = 1'b0;

            end

            WAIT_DRIVER_DONE: begin
                ram_pointer_en_reg = 1'b1;
                ram_pointer_reset_reg = 1'b0;
            end

            default: begin
                ram_pointer_en_reg = 1'b0;
                ram_pointer_reset_reg = 1'b1;
            end
        endcase
    end

endmodule