module graphic_manager (
    input clk,
    input en,
    input reset,
    input bw_pixel_color,
    input [8:0] pixel_col,
    input [7:0] pixel_row,
    input write_pixel,
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
    localparam RESET = 0,
               IDLE = 1,
               ADD_PIXEL = 2;

    // Current state and future state
    reg [1:0] Sreg, Snext;

    localparam ROW_NUM = 8'd240;    // Rows number
    localparam COL_NUM = 9'd320;    // Columns number
    localparam PIXEL_NUM = 17'd76800; // Pixels number

    // LT24 LCD Driver input interface
    wire driver_done, print;
    wire [15:0] pixel_rgb;
    reg print_reg;
    reg [15:0] pixel_rgb_reg;

    assign print = print_reg;
    assign pixel_rgb = pixel_rgb_reg;

    // LT24 LCD Driver instance
    lt24_lcd_driver lt24_lcd_driver_inst (
        .clk(clk),
        .en(en),
        .reset(reset),
        .pixel_rgb(pixel_rgb),
        .print(print),
        .done(driver_done),
        .initialized(initialized),
        .tft_rst(tft_rst),
        .tft_csx(tft_csx),
        .tft_dcx(tft_dcx),
        .tft_wrx(tft_wrx),
        .tft_rdx(tft_rdx),
        .tft_data(tft_data)
    );

    // Frame RAM address
    reg [16:0] wr_address_reg, rd_address_reg;
    wire [16:0] wr_address = wr_address_reg;
    wire [16:0] rd_address = rd_address_reg;

    // Current pixel counter for LCD print
    reg [16:0] current_pixel;
    reg memory_cleared;

    // Frame RAM interface
    reg data_in_reg, write_enable_reg;
    wire data_in, write_enable, data_out;

    assign data_in = data_in_reg;
    assign write_enable = write_enable_reg;

    // 1-bit color frame RAM instance
    simple_dual_port_ram_single_clock #(
        .DATA_WIDTH(1),                  // 1 bit memory word
        .ADDR_WIDTH($clog2(PIXEL_NUM))   // Address width for PIXEL_NUM words
    ) pixel_buffer (
        .clk(clk),                       // Input clock for the RAM
        .write_addr(wr_address),         // Write address for the memory
        .read_addr(rd_address),          // Read address for the memory
        .data(data_in),                  // Data input (1 bit)
        .we(write_enable),               // Write enable
        .q(data_out)                     // Data output (1 bit)
    );

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

    // Input buffers
    reg bw_pixel_color_reg;
    reg [7:0] pixel_row_reg;
    reg [8:0] pixel_col_reg;

    // Update current status
    always @ (posedge clk)
        if (reset) begin
            Sreg <= RESET;
            current_pixel <= 17'b0;
            memory_cleared <= 1'b0;
            bw_pixel_color_reg = 1'b0;
            pixel_row_reg = 8'b0;
            pixel_col_reg = 9'b0;
        end else begin
            Sreg <= Snext;

            // Update input values buffers
            bw_pixel_color_reg <= bw_pixel_color;
            pixel_row_reg <= pixel_row;
            pixel_col_reg <= pixel_col;

            // Update current pixel memory pointer
            if ((Sreg != RESET && driver_done) || (Sreg == RESET && ~memory_cleared)) begin
                current_pixel <= current_pixel + 17'b1;
                if (current_pixel == PIXEL_NUM) begin
                    current_pixel <= 17'd0;
                    if (Sreg == RESET)
                        memory_cleared <= 1'b1;
                    else
                        memory_cleared <= 1'b0;
                end
            end
        end

    // Evaluate next state
    always @ (*) begin
        case (Sreg)
            RESET: 
                if (initialized && memory_cleared)
                    Snext = IDLE;
                else 
                    Snext = RESET;

            IDLE:
                if (write_pixel && en)
                    Snext = ADD_PIXEL;
                else
                    Snext = IDLE;

            ADD_PIXEL: Snext = IDLE;

            default: begin
                Snext = RESET;
            end
        endcase
    end

    always @ (Sreg, bw_pixel_color_reg, pixel_row_reg, pixel_col_reg, current_pixel, data_out) begin
        wr_address_reg = 17'd0;
        rd_address_reg = current_pixel;
        pixel_rgb_reg = 16'd0;
        data_in_reg = 1'b0;
        pixel_rgb_reg = rgb565_color(data_out);

        case (Sreg)
            RESET: begin
                data_in_reg = 1'b0;
                wr_address_reg = current_pixel;
                write_enable_reg = 1'b1;
                print_reg = 1'b0;
            end

            IDLE: begin
                write_enable_reg = 1'b0;
                print_reg = 1'b1;
            end
  
            ADD_PIXEL: begin
                wr_address_reg = (pixel_row_reg * COL_NUM) + pixel_col_reg;
                data_in_reg = bw_pixel_color_reg;
                write_enable_reg = 1'b1;
                print_reg = 1'b1;
            end

            default: begin
                print_reg = 1'b0;
                write_enable_reg = 1'b0;
            end

        endcase
    end

endmodule