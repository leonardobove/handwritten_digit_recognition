/*
 * This module controls loads into the LCD frame RAM through the graphic manager
 * a set of predefined constant frames. If the touchscreen input is enabled, it
 * draws the corresponding LCD pixels that have been touched by the pen.
 *
 */
module painter #(
    parameter integer N_FRAMES = 2,
    parameter integer N_FRAMES_WIDTH = $clog2(N_FRAMES),
    parameter PIXEL_NUM =  17'd76800, // Pixels number
    parameter integer PIXEL_NUM_WIDTH = $clog2(PIXEL_NUM)
)(
    input clk,
    input en,
    input reset,
    input [N_FRAMES_WIDTH - 1:0] load_frame_sel, // Pre-loaded frames selector

    // ROM memory interface
    output [PIXEL_NUM_WIDTH + N_FRAMES_WIDTH - 1:0] rom_addr,
    input rom_q,

    // Graphic manager interface
    input initialized,
    output bw_pixel_color,
    output [8:0] pixel_col,
    output [7:0] pixel_row,
    output reg write_pixel,

    // LT24 touchscreen driver interface
    input pos_ready,
    input [11:0] x_pos,     // X, Y position from the ADC, given with a resolution of 12 bits
    input [11:0] y_pos
);  

    localparam ROW_NUM = 8'd240;    // Rows number
    localparam COL_NUM = 9'd320;    // Columns number

    // FSM States
    localparam RESET       = 2'd0,
               IDLE        = 2'd1,
               LOAD_FRAME  = 2'd2,
               PAINT_PIXEL = 2'd3;

    reg [1:0] Sreg, Snext;

    // Buffer for the currently selected frame number
    reg [N_FRAMES_WIDTH-1:0] load_frame_sel_reg;

    // Counter to be used as a pointer address to the frames ROM
    reg rom_pointer_en_reg;     // Enable for the pointer counter
    reg rom_pointer_reset_reg;  // Reset for the pointer counter

    wire [PIXEL_NUM_WIDTH-1:0] rom_pointer; // ROM pointer address without frame offset
    wire rom_pointer_en, rom_pointer_reset;

    assign rom_pointer_en = rom_pointer_en_reg;
    assign rom_pointer_reset = rom_pointer_reset_reg;

    counter #(
        .MAX_VALUE(PIXEL_NUM)
    ) rom_pointer_instance (
        .clk(clk),
        .en(rom_pointer_en),
        .reset(rom_pointer_reset),
        .count(rom_pointer)
    );

    // ROM interface
    assign rom_addr = rom_pointer + load_frame_sel_reg*PIXEL_NUM; // ROM pointer address with frame offset
    reg rom_q_reg; // Buffer for ROM output data

    // Graphic manager interface

    /*  If a new frame has to be loaded, the pixel color (black or white) will depend on the output of the ROM.
     *  If the screen has been touched, draw the corresponding pixel white (1'b1).
     *  Otherwise leave it to 0.
     */
    assign bw_pixel_color = (Sreg == LOAD_FRAME) ? rom_q_reg : (Sreg == PAINT_PIXEL) ? 1'b1 : 1'b0;
    /*  If the screen has been touched, add a white pixel at the coordinates given by the touchscreen driver, i.e.
     *  col = (x_pos/4096) * COL_NUM and row = (y_pos/4096) + ROW_NUM.
     *  If a new frame has to be loaded, the position pixel to be drawn comes from the current rom_pointer,
     *  in order to have a 1:1 correspondece between ROM and RAM frames.
     *  Otherwise they are set to 0.
     */

    // Pixel column and row calculations
    wire [20:0] pixel_col_calc;
    wire [19:0] pixel_row_calc;

    assign pixel_col_calc = (Sreg == PAINT_PIXEL) ? (x_pos * COL_NUM) >> 12 : (Sreg == LOAD_FRAME) ? (rom_pointer % COL_NUM) : 9'b0;
    assign pixel_row_calc = (Sreg == PAINT_PIXEL) ? (y_pos * ROW_NUM) >> 12 : (Sreg == LOAD_FRAME) ? (rom_pointer / COL_NUM) : 8'b0;

    assign pixel_col = pixel_col_calc[8:0];
    assign pixel_row = pixel_row_calc[7:0];

    // Update current state
    always @ (posedge clk)
        if (reset) begin
            Sreg <= RESET;
            rom_q_reg <= 1'b0;
            load_frame_sel_reg <= 1'b0;
        end else begin
            Sreg <= Snext;

            // Update current frame selection
            load_frame_sel_reg <= load_frame_sel;

            // Update output data from ROM
            rom_q_reg <= rom_q;
        end

    always @ (*)
        case (Sreg)
            RESET:
                if (initialized)
                    Snext = LOAD_FRAME;
                else
                    Snext = RESET;

            IDLE:
                if (pos_ready && en)
                    Snext = PAINT_PIXEL;
                else if ((load_frame_sel_reg != load_frame_sel) && en)   // Check if frame selection has changed
                    Snext = LOAD_FRAME;
                else
                    Snext = IDLE;

            LOAD_FRAME: // Load constant frame to graphic manager RAM memory
                if (rom_pointer == (PIXEL_NUM - 1'b1))  // Check if the end of the current frame has been reached
                    Snext = IDLE;
                else
                    Snext = LOAD_FRAME;

            PAINT_PIXEL:
                Snext = IDLE;
        endcase

    always @ (Sreg) begin
        write_pixel = 1'b0;
        rom_pointer_en_reg = 1'b0;
        rom_pointer_reset_reg = 1'b1;

        case (Sreg)
            RESET: begin
                rom_pointer_en_reg = 1'b0;
                rom_pointer_reset_reg = 1'b1;
            end

            IDLE: begin
                rom_pointer_en_reg = 1'b0;
                rom_pointer_reset_reg = 1'b1;
            end

            LOAD_FRAME: begin
                write_pixel = 1'b1;
                rom_pointer_en_reg = 1'b1;
                rom_pointer_reset_reg = 1'b0;
            end

            PAINT_PIXEL: begin
                write_pixel = 1'b1;
                rom_pointer_en_reg = 1'b0;
                rom_pointer_reset_reg = 1'b1;
            end

            default: begin
                write_pixel = 1'b0;
                rom_pointer_en_reg = 1'b0;
                rom_pointer_reset_reg = 1'b1;
            end
        endcase
    end

endmodule