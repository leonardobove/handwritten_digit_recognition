/*
 * This module loads into the LCD frame buffer memory a set of predefined constant frames. 
 * If the touchscreen input is enabled, it draws the corresponding LCD pixels that have
 * been touched by the pen.
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

    // Frame buffer memory interface
    output ram_data,                                    // 1-bit pixel color to be loaded to the frame buffer
    output reg [PIXEL_NUM_WIDTH - 1:0] ram_write_addr,  // Frame buffer write address
    output reg ram_write_en,                            // Frame buffer write enable

    // Graphic manager interface
    input initialized,

    // LT24 touchscreen driver interface
    input pos_ready,
    input [11:0] x_pos,     // X, Y position from the ADC, given with a resolution of 12 bits
    input [11:0] y_pos
);  

    localparam ROW_NUM = 8'd240;    // Rows number
    localparam COL_NUM = 9'd320;    // Columns number

    // FSM States
    localparam RESET            = 3'd0,
               IDLE             = 3'd1,
               LOAD_FRAME       = 3'd2,
               PAINT_PIXEL      = 3'd3,
               WAIT_PAINT_PIXEL = 3'd4;

    reg [2:0] Sreg, Snext;

    // Buffer for the currently selected frame number
    reg [N_FRAMES_WIDTH-1:0] load_frame_sel_reg;

    // Counter to be used as a pointer address to the frames ROM
    reg rom_pointer_en_reg;     // Enable for the pointer counter
    reg rom_pointer_reset_reg;  // Reset for the pointer counter

    wire [PIXEL_NUM_WIDTH-1:0] rom_pointer; // ROM pointer address without frame offset
    wire rom_pointer_en, rom_pointer_reset;

    assign rom_pointer_en = rom_pointer_en_reg && en;
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

    // Frame buffer memory interface

    /*  If a new frame has to be loaded, the pixel color (black or white) will depend on the output of the ROM.
     *  If the screen has been touched, draw the corresponding pixel white (1'b1).
     *  Otherwise leave it to 0.
     */
    assign ram_data = (Sreg == LOAD_FRAME) ? rom_q_reg : (Sreg == PAINT_PIXEL || Sreg == WAIT_PAINT_PIXEL) ? 1'b1 : 1'b0;
    /*  If the screen has been touched, add a white pixel at the coordinates given by the touchscreen driver, i.e.
     *  col = (x_pos/4096) * COL_NUM and row = (y_pos/4096) + ROW_NUM.
     *  If a new frame has to be loaded, the position pixel to be drawn comes from the current rom_pointer,
     *  in order to have a 1:1 correspondece between ROM and RAM frames.
     *  Otherwise they are set to 0.
     */

    reg [20:0] touchscreen_x;
    reg [19:0] touchscreen_y;

    // Output ranges from touchscreen ADC
    localparam TS_MINX = 0;
    localparam TS_MAXX = 4000;
    localparam TS_MINY = 0;
    localparam TS_MAXY = 4000;

    // Map touchscreen ADC values to pixel coordinates
    always @ (*) begin
        if (x_pos < TS_MINX)
            touchscreen_x = 1'b0;
        else if (x_pos > TS_MAXX)
            touchscreen_x = COL_NUM - 1'b1;
        else
            touchscreen_x = (x_pos - TS_MINX) * (COL_NUM - 1'b1) / (TS_MAXX - TS_MINX);

        if (y_pos < TS_MINY)
            touchscreen_y = ROW_NUM - 1'b1;
        else if (y_pos > TS_MAXY)
            touchscreen_y = 1'b0;
        else
            touchscreen_y = (ROW_NUM - 1'b1) - (y_pos - TS_MINY) * (ROW_NUM - 1'b1) / (TS_MAXY - TS_MINY);

        // Set frame buffer write address
        if (Sreg == PAINT_PIXEL || Sreg == WAIT_PAINT_PIXEL)
            ram_write_addr = (x_pos > 4096) ? 17'd3210 : 17'd3290;
        else if (Sreg == LOAD_FRAME)
            ram_write_addr = rom_pointer;
        else
            ram_write_addr = 17'd0;
    end

    // Update current state
    always @ (posedge clk)
        if (reset) begin
            Sreg <= RESET;
            rom_q_reg <= 1'b0;
            load_frame_sel_reg <= 1'b0;
        end else
            if (en) begin
                Sreg <= Snext;

                // Update current frame selection
                load_frame_sel_reg <= load_frame_sel;

                // Update output data from ROM
                rom_q_reg <= rom_q;
            end else begin
                Sreg <= Sreg;
                load_frame_sel_reg <= load_frame_sel_reg;
                rom_q_reg <= rom_q_reg;
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

            PAINT_PIXEL: Snext = WAIT_PAINT_PIXEL;

            WAIT_PAINT_PIXEL: Snext = IDLE;

            default: Snext = RESET;
        endcase

    always @ (Sreg) begin
        ram_write_en = 1'b0;
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
                ram_write_en = 1'b1;
                rom_pointer_en_reg = 1'b1;
                rom_pointer_reset_reg = 1'b0;
            end

            PAINT_PIXEL: begin
                ram_write_en = 1'b1;
                rom_pointer_en_reg = 1'b0;
                rom_pointer_reset_reg = 1'b1;
            end

            WAIT_PAINT_PIXEL: begin
                ram_write_en = 1'b1;
                rom_pointer_en_reg = 1'b0;
                rom_pointer_reset_reg = 1'b1;
            end

            default: begin
                ram_write_en = 1'b0;
                rom_pointer_en_reg = 1'b0;
                rom_pointer_reset_reg = 1'b1;
            end
        endcase
    end

endmodule