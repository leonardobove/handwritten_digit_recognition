/*
 * This module controls loads into the LCD frame RAM through the graphic manager
 * a set of predefined constant frames. If the touchscreen input is enabled, it
 * draws the corresponding LCD pixels that have been touched by the pen.
 *
 */
module painter #( 
    parameter N_FRAMES = 1
    )(
    input clk,
    input en,
    input reset,
    input [$clog2(N_FRAMES) - 1:0] load_frame_sel, // 2 possible pre-loaded frames

    // ROM memory interface
    output reg [$clog2(PIXEL_NUM * N_FRAMES) - 1:0] rom_addr,
    input rom_q,

    // Graphic manager interface
    input initialized,
    output reg bw_pixel_color,
    output [8:0] pixel_col,
    output [7:0] pixel_row,
    output reg write_pixel,

    // LT24 touchscreen driver interface
    input pos_ready,
    input [11:0] x_pos,     // X, Y position from the ADC, given with a resolution of 12 bits
    input [11:0] y_pos
);  

    // FSM States
    localparam RESET       = 2'd0,
               IDLE        = 2'd1,
               LOAD_FRAME  = 2'd2,
               PAINT_PIXEL = 2'd3;

    reg [1:0] Sreg, Snext;

    // Buffer for ROM output data
    reg rom_q_reg;

    localparam ROW_NUM = 8'd240;    // Rows number
    localparam COL_NUM = 9'd320;    // Columns number
    localparam PIXEL_NUM = 17'd76800; // Pixels number

    // Buffers for pixel column and row calculations
    reg [20:0] pixel_col_reg;
    reg [19:0] pixel_row_reg;
    
    assign pixel_col = pixel_col_reg[8:0];
    assign pixel_row = pixel_row_reg[7:0];

    // Flag to keep track whether the currently selected frame has changed
    reg frame_changed;
    
    // Buffer for the currently selected frame number
    reg [$clog2(PIXEL_NUM) - 1:0] load_frame_sel_reg;

    // Update current state
    always @ (posedge clk)
        if (reset) begin
            Sreg <= RESET;
            rom_addr <= 1'b0;
            rom_q_reg <= 1'b0;
            frame_changed <= 1'b1;
            load_frame_sel_reg <= 1'b0;
            pixel_col_reg <= 21'b0;
            pixel_row_reg <= 20'b0;
        end else begin
            Sreg <= Snext;

            // Update current frame selection
            if (Sreg != RESET)
                if (load_frame_sel_reg != load_frame_sel) begin
                    frame_changed <= 1'b1;
                    load_frame_sel_reg <= load_frame_sel;
                    rom_addr <= load_frame_sel_reg*PIXEL_NUM;    // Add offset to the current frame
                end else
                    frame_changed <= 1'b0;

            // Update pixel column and row from touchscreen conversion data
            if (Snext == PAINT_PIXEL) begin
                pixel_col_reg <= (x_pos * COL_NUM) >> 12; // col = (x_pos/4096) * COL_NUM
                pixel_row_reg <= (y_pos * ROW_NUM) >> 12; // row = (y_pos/4096) + ROW_NUM
            end

            // Update pixel column and row from current constant frame pointer
            if (Snext == LOAD_FRAME) begin
                pixel_col_reg <= (rom_addr - (load_frame_sel_reg*PIXEL_NUM)) % COL_NUM;
                pixel_row_reg <= (rom_addr - (load_frame_sel_reg*PIXEL_NUM)) / COL_NUM;
                rom_addr <= rom_addr + 1'b1;
            end

            // Update output data from ROM
            rom_q_reg <= rom_q;
        end

    always @ (*)
        case (Sreg)
            RESET:
                if (initialized)
                    Snext = IDLE;
                else
                    Snext = RESET;

            IDLE:
                if (pos_ready && en)
                    Snext = PAINT_PIXEL;
                else if (frame_changed && en)
                    Snext = LOAD_FRAME;
                else
                    Snext = IDLE;

            LOAD_FRAME: // Load constant frame to graphic manager RAM memory
                if (rom_addr == ((load_frame_sel_reg + 1'b1)*PIXEL_NUM - 17'd1) || ~en)  // Check if the end of the current frame has been reached
                    Snext = IDLE;
                else
                    Snext = LOAD_FRAME;

            PAINT_PIXEL:
                Snext = IDLE;
        endcase

    always @ (Sreg, rom_q_reg) begin
        write_pixel = 1'b0;
        bw_pixel_color = 1'b0;

        case (Sreg)
            LOAD_FRAME: begin
                write_pixel = 1'b1;
                bw_pixel_color = rom_q_reg;     // Print a pixel whose color corresponds to the one read from ROM
            end

            PAINT_PIXEL: begin
                write_pixel = 1'b1;
                bw_pixel_color = 1'b1;  // Print a white pixel where the pen has touched

            end

            default: begin
                write_pixel = 1'b0;
                bw_pixel_color = 1'b0;
            end
        endcase
    end

endmodule