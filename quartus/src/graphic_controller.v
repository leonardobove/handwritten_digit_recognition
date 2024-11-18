module graphic_controller (
    input clk,
    input en,
    input reset,
    input bw_pixel_color,
    input [8:0] pixel_col,
    input [7:0] pixel_row,
    input write_pixel,
    output initialized,

    // 1 bit color frame RAM interface
    output [16:0] write_addr,         // Write address for the memory
    output [16:0] read_addr,          // Read address for the memory
    output ram_data,                  // Data input (1 bit)
    output write_enable,              // Write enable
    input ram_q,                          // Data output (1 bit)

    // LT24 LCD driver interface
    output [15:0] pixel_rgb,
    output print,
    input driver_done,
    input driver_initialized
);

    // FSM states
    localparam RESET             = 3'd0,
               CLEAR_RAM         = 3'd1,
               WAIT_DRIVER_INIT  = 3'd2,
               IDLE              = 3'd3,
               WAIT_RAM          = 3'd4,
               WAIT_DRIVER_DONE  = 3'd5,
               ADD_PIXEL         = 3'd6;

    // Current state and future state
    reg [2:0] Sreg, Snext;

    // Input buffers
    reg [7:0] pixel_row_reg;
    reg [8:0] pixel_col_reg;

    localparam ROW_NUM = 8'd240;      // Rows number
    localparam COL_NUM = 9'd320;      // Columns number
    localparam PIXEL_NUM = 17'd76800; // Pixels number

    // Add counter as a pointer to the frame RAM, in order to continously update the LCD frame
    localparam POINTER_WIDTH = $clog2(PIXEL_NUM);
    reg ram_pointer_en_reg;     // Enable for the pointer counter
    reg ram_pointer_reset_reg;  // Reset for the pointer counter

    wire [POINTER_WIDTH-1:0] ram_pointer;
    wire ram_pointer_en, ram_pointer_reset;

    assign ram_pointer_en = ram_pointer_en_reg;
    assign ram_pointer_reset = ram_pointer_reset_reg;

    counter #(
        .MAX_VALUE(PIXEL_NUM)
    ) ram_pointer_instance (
        .clk(clk),
        .en(ram_pointer_en),
        .reset(ram_pointer_reset),
        .count(ram_pointer)
    );

    assign initialized = (Sreg >= IDLE);

    // Frame RAM interface
    assign ram_data = (Sreg == ADD_PIXEL) ? bw_pixel_color : 1'b0;
    assign write_addr = (Sreg == CLEAR_RAM) ? ram_pointer : (pixel_row_reg * COL_NUM) + pixel_col_reg;
    assign read_addr = ram_pointer;
    assign write_enable = (Sreg == ADD_PIXEL || Sreg == CLEAR_RAM);

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
            pixel_row_reg <= 8'b0;
            pixel_col_reg <= 9'b0;
        end else begin
            Sreg <= Snext;

            // Update input values buffers
            pixel_row_reg <= pixel_row;
            pixel_col_reg <= pixel_col;
        end

    // Evaluate next state
    always @ (*) begin
        case (Sreg)
            RESET: Snext = CLEAR_RAM;
            
            CLEAR_RAM: 
                if (ram_pointer == (PIXEL_NUM - 1'b1))
                    Snext = WAIT_DRIVER_INIT;
                else 
                    Snext = CLEAR_RAM;
            
            WAIT_DRIVER_INIT:
                if (driver_initialized)
                    Snext = IDLE;
                else
                    Snext = WAIT_DRIVER_INIT;

            IDLE:
                if (write_pixel && en)
                    Snext = ADD_PIXEL;
                else
                    Snext = WAIT_RAM;

            WAIT_RAM:
                if (write_pixel && en)
                    Snext = ADD_PIXEL;
                else
                    Snext = WAIT_DRIVER_DONE;

            WAIT_DRIVER_DONE:
                if (write_pixel && en)
                    Snext = ADD_PIXEL;
                else
                    Snext = IDLE;

            ADD_PIXEL:
                if (driver_done)
                    Snext = WAIT_RAM;
                else
                    Snext = IDLE;

            default: begin
                Snext = RESET;
            end
        endcase
    end

    always @ (Sreg) begin
        ram_pointer_en_reg = 1'b0;
        ram_pointer_reset_reg = 1'b1;

        case (Sreg)
            CLEAR_RAM: begin
                ram_pointer_en_reg = 1'b1;
                ram_pointer_reset_reg = 1'b0;
            end

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

            ADD_PIXEL: begin
                ram_pointer_en_reg = 1'b0;
                ram_pointer_reset_reg = 1'b0;
            end

            default: begin
                ram_pointer_en_reg = 1'b0;
                ram_pointer_reset_reg = 1'b1;
            end
        endcase
    end

endmodule