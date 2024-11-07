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

    reg [1:0] Sreg, Snext;

    // Flag to check if the reset signal to the driver has been sent
    reg reset_sent;

    // LT24 LCD Driver input interface
    wire rst_driver, driver_done, print;
    wire [15:0] pixel_rgb;
    reg rst_driver_reg, print_reg;
    reg [15:0] pixel_rgb_reg;

    assign rst_driver = rst_driver_reg;
    assign print = print_reg;
    assign pixel_rgb = pixel_rgb_reg;

    // LT24 LCD Driver instance
    lt24_lcd_driver lt24_lcd_driver_inst (
        .clk(clk),
        .en(en),
        .reset(rst_driver),
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

    localparam ROW_NUM = 8'd240;    // Rows number
    localparam COL_NUM = 9'd320;    // Columns number
    localparam PIXEL_NUM = 17'd76800; // Pixels number

    // Frame RAM address
    reg [16:0] address_reg;
    wire [16:0] address = address_reg;

    // Current pixel counter for LCD print
    reg [16:0] current_pixel;

    // Frame RAM interface
    reg data_in_reg, write_enable_reg;
    wire data_in, write_enable, data_out;

    assign data_in = data_in_reg;
    assign write_enable = write_enable_reg;

    // 1-bit color frame RAM instance
    altsyncram #(
        .operation_mode("SINGLE_PORT"),  // Single port mode
        .width_a(1),                     // 1-bit data width
        .widthad_a($clog2(PIXEL_NUM))    // Address width for PIXEL_NUM words
    ) pixel_buffer_inst (
        .clock0(clk),                    // Single clock for the RAM
        .address_a(address),             // Address for the memory
        .data_a(data_in),                // Data input (1 bit)
        .wren_a(write_enable),           // Write enable
        .q_a(data_out)                   // Data output (1 bit)
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

    // Update current status
    always @ (posedge clk)
        if (reset) Sreg <= RESET;
        else Sreg <= Snext;

    // Evaluate next state
    always @ (*)
        case (Sreg)
            RESET: if (initialized) Snext = IDLE;
            else Snext = RESET;

            IDLE: if (write_pixel && en) Snext = ADD_PIXEL;
                  else Snext = IDLE;

            ADD_PIXEL: if (~write_enable) Snext <= IDLE;
                       else Snext = ADD_PIXEL;

            default: Snext = RESET;
        endcase

    always @ (posedge clk)
        if (reset) begin
            // Initialize registers on reset
            reset_sent <= 1'b0;
            rst_driver_reg <= 1'b0;
            print_reg <= 1'b0;
            write_enable_reg <= 1'b0;
            data_in_reg <= 1'b0;
            address_reg <= 17'b0;
            current_pixel <= 17'b0;
        end else
            case (Sreg)
                RESET: begin
                    if (~reset_sent) begin
                        rst_driver_reg <= 1'b1;
                        reset_sent <= 1'b1;
                    end else begin
                        rst_driver_reg <= 1'b0;
                    end
                end

                IDLE: begin
                    if (driver_done) begin
                        write_enable_reg <= 1'b0;

                        // Enable LCD print and set pixel value
                        print_reg <= 1'b1;
                        address_reg <= current_pixel;
                        pixel_rgb_reg <= current_pixel; //rgb565_color(data_out);
                        
                        current_pixel <= current_pixel + 2;
                        if (current_pixel == PIXEL_NUM) begin
                            current_pixel <= 17'd0;
                        end
                    end else begin
                        print_reg <= 1'b0;  // Disable LCD print
                    end
                end

                ADD_PIXEL: begin
                    if (write_pixel) begin
                        write_enable_reg <= 1'b1;
                    end
                    if (write_pixel) begin
                        // Write pixel data to buffer at specified row/column
                        address_reg <= (pixel_row * COL_NUM) + pixel_col;
                        data_in_reg <= bw_pixel_color;
                        write_enable_reg <= 1'b1;
                    end else begin
                        write_enable_reg <= 1'b0;
                    end
                end

                default: begin
                    print_reg <= 1'b0;
                    rst_driver_reg <= 1'b0;
                    write_enable_reg <= 1'b0;
                end
            endcase

endmodule