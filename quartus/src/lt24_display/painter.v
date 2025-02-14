/*
 * This module loads into the LCD frame buffer memory a set of predefined constant frames.
 * If the touchscreen input is enabled, it draws the corresponding LCD pixels that have
 * been touched by the pen.
 */
module painter #(
    parameter integer N_FRAMES = 2,
    parameter integer N_FRAMES_WIDTH = $clog2(N_FRAMES),
    parameter integer PIXEL_NUM = 76800, // Pixels number
    parameter integer PIXEL_NUM_WIDTH = $clog2(PIXEL_NUM),
    parameter integer DRAWING_AREA_SIDE_LENGTH = 28,
    parameter integer DRAWING_AREA_ADDR_WIDTH = $clog2(DRAWING_AREA_SIDE_LENGTH**2)
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
    input [11:0] y_pos,
 
    // Neural network inputs buffer RAM memory
    output reg nn_ram_data,          // Single 1-bit pixel to be written into the buffer memory
    output reg [DRAWING_AREA_ADDR_WIDTH-1:0] nn_ram_write_addr,
    output reg nn_ram_we,
 
    // Main controller interface
    input clear_display,
    output reg painter_ready
);  
 
    localparam ROW_NUM = 8'd240;    // Rows number
    localparam COL_NUM = 9'd320;    // Columns number
 
    // FSM States
    localparam RESET            = 2'd0,
               IDLE             = 2'd1,
               LOAD_FRAME       = 2'd2,
               PAINT_PIXEL      = 2'd3;

    reg [1:0] Sreg, Snext;
 
    // Buffer for the currently selected frame number
    reg [N_FRAMES_WIDTH-1:0] load_frame_sel_reg;
 
    // Counter to be used as a pointer address to the neural network inputs buffer RAM
    reg nn_ram_pointer_en_reg;          // Enable for the pointer counter
    reg nn_ram_pointer_reset_reg;       // Reset for the pointer counter
 
    wire [$clog2(DRAWING_AREA_SIDE_LENGTH**2)-1:0] nn_ram_pointer;  // NN RAM pointer address
    wire nn_ram_pointer_en, nn_ram_pointer_reset;
 
    assign nn_ram_pointer_en = nn_ram_pointer_en_reg && en;
    assign nn_ram_pointer_reset = nn_ram_pointer_reset_reg;
 
    counter #(
        .MAX_VALUE(DRAWING_AREA_SIDE_LENGTH**2)
    ) nn_ram_pointer_instance (
        .clk(clk),
        .en(nn_ram_pointer_en),
        .reset(nn_ram_pointer_reset),
        .count(nn_ram_pointer)
    );
 
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
    assign rom_addr = rom_pointer + load_frame_sel_reg*PIXEL_NUM[PIXEL_NUM_WIDTH-1:0]; // ROM pointer address with frame offset

    // Frame buffer memory interface
 
    /*  If a new frame has to be loaded, the pixel color (black or white) will depend on the output of the ROM.
     *  If the screen has been touched, draw the corresponding pixel white (1'b1).
     *  Otherwise leave it to 0.
     */
    assign ram_data = (Sreg == LOAD_FRAME) ? rom_q : (Sreg == PAINT_PIXEL) ? 1'b1 : 1'b0;
    /*  If the screen has been touched, add a white pixel at the coordinates given by the touchscreen driver, i.e.
     *  col = (x_pos/4096) * COL_NUM and row = (y_pos/4096) + ROW_NUM.
     *  If a new frame has to be loaded, the position pixel to be drawn comes from the current rom_pointer,
     *  in order to have a 1:1 correspondece between ROM and RAM frames.
     *  Otherwise they are set to 0.
     */
 
    reg [20:0] touchscreen_x_temp;	// Temporary variables for calculations
    reg [19:0] touchscreen_y_temp;
	 wire [8:0] touchscreen_x;			// Final (x, y) coordinates of touched pixel
	 wire [7:0] touchscreen_y;
	 
	 assign touchscreen_x = touchscreen_x_temp[8:0];
	 assign touchscreen_y = touchscreen_y_temp[7:0]; 
 
    // Output ranges from touchscreen ADC
    localparam TS_MINX = 12'd0;
    localparam TS_MAXX = 12'd4095;
    localparam TS_MINY = 12'd0;
    localparam TS_MAXY = 12'd4095;
 
    // Map touchscreen ADC values to pixel coordinates
    always @ (*) begin
        if (x_pos < TS_MINX)
            touchscreen_x_temp = 1'b0;
        else if (x_pos > TS_MAXX)
            touchscreen_x_temp = COL_NUM - 1'b1;
        else
            touchscreen_x_temp = ((x_pos - TS_MINX) * (COL_NUM - 1'b1)) >> 12;
           
        if (y_pos < TS_MINY)
            touchscreen_y_temp = ROW_NUM - 1'b1;
        else if (y_pos > TS_MAXY)
            touchscreen_y_temp = 1'b0;
        else
            touchscreen_y_temp = ((TS_MAXY - y_pos) * (ROW_NUM - 1'b1)) >> 12;
    end
 
    // Set frame buffer write address
    always @ (*) begin
        if (Sreg == PAINT_PIXEL)
            ram_write_addr = touchscreen_y*COL_NUM + touchscreen_x;
        else if (Sreg == LOAD_FRAME)
            ram_write_addr = rom_pointer;
        else
            ram_write_addr = 17'd0;
    end
 
    // Neural network inputs buffer RAM memory interface
    always @ (*) begin
        // Add touched pixel to the neural network inputs array
        // as a white pixel (1).
        // Add it only if the touch happened inside a specific drawing area.
        if ((Sreg == PAINT_PIXEL) &&
            touchscreen_x >= 21'd0 && touchscreen_x < DRAWING_AREA_SIDE_LENGTH &&
            touchscreen_y >= 20'd0 && touchscreen_y < DRAWING_AREA_SIDE_LENGTH)
            nn_ram_write_addr = (DRAWING_AREA_SIDE_LENGTH[$clog2(DRAWING_AREA_SIDE_LENGTH)-1:0])**2 - (touchscreen_y*DRAWING_AREA_SIDE_LENGTH[$clog2(DRAWING_AREA_SIDE_LENGTH)-1:0] + touchscreen_x);
        else if (Sreg == LOAD_FRAME)
            nn_ram_write_addr = nn_ram_pointer;
        else
            nn_ram_write_addr = 0;
    end
 
    // Update current state
    always @ (posedge clk)
        if (reset) begin
            Sreg <= RESET;
            load_frame_sel_reg <= 1'b0;
        end else
            if (en) begin
                Sreg <= Snext;
 
                // Update current frame selection
                load_frame_sel_reg <= load_frame_sel;
            end else begin
                Sreg <= Sreg;
                load_frame_sel_reg <= load_frame_sel_reg;
            end
 
    always @ (*)
        case (Sreg)
            RESET:
                if (initialized)
                    Snext = LOAD_FRAME;
                else
                    Snext = RESET;
 
            IDLE:
                if (pos_ready)
                    Snext = PAINT_PIXEL;
                else if ((load_frame_sel_reg != load_frame_sel) || clear_display)   // Check if frame selection has changed or if the display needs to be cleared
                    Snext = LOAD_FRAME;
                else
                    Snext = IDLE;
 
            LOAD_FRAME: // Load constant frame to graphic manager RAM memory
                if (rom_pointer == (PIXEL_NUM - 1'b1))  // Check if the end of the current frame has been reached
                    Snext = IDLE;
                else
                    Snext = LOAD_FRAME;
 
            PAINT_PIXEL: Snext = IDLE;
  
            default: Snext = RESET;
        endcase
 
    always @ (Sreg) begin
        ram_write_en = 1'b0;
        rom_pointer_en_reg = 1'b0;
        rom_pointer_reset_reg = 1'b1;
 
        painter_ready = 1'b0;
 
        nn_ram_we = 1'b0;
        nn_ram_data = 1'b0;
        nn_ram_pointer_en_reg = 1'b0;
        nn_ram_pointer_reset_reg = 1'b1;
 
        case (Sreg)
            RESET: begin
                rom_pointer_en_reg = 1'b0;
                rom_pointer_reset_reg = 1'b1;
            end
 
            IDLE: begin
                rom_pointer_en_reg = 1'b0;
                rom_pointer_reset_reg = 1'b1;
                painter_ready = 1'b1;
            end
 
            LOAD_FRAME: begin
                ram_write_en = 1'b1;
                rom_pointer_en_reg = 1'b1;
                rom_pointer_reset_reg = 1'b0;
 
                nn_ram_data = 1'b0;
                nn_ram_we = 1'b1;
                nn_ram_pointer_reset_reg = 1'b0;
                nn_ram_pointer_en_reg = 1'b1;
            end
 
            PAINT_PIXEL: begin
                ram_write_en = 1'b1;
                rom_pointer_en_reg = 1'b0;
                rom_pointer_reset_reg = 1'b1;
 
                nn_ram_we = 1'b1;
                nn_ram_data = 1'b1;
            end
 
            default: begin
                ram_write_en = 1'b0;
                rom_pointer_en_reg = 1'b0;
                rom_pointer_reset_reg = 1'b1;
                painter_ready = 1'b0;
 
                nn_ram_we = 1'b0;
                nn_ram_data = 1'b0;
                nn_ram_pointer_en_reg = 1'b0;
                nn_ram_pointer_reset_reg = 1'b1;
            end
        endcase
    end
 
endmodule
 