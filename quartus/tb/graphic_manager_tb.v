`timescale 1ns/1ps
module graphic_manager_tb;
    // Graphic manager input
    reg clk_tb = 0;
    reg en_tb = 0;
    reg reset_tb = 0;
    reg bw_pixel_color = 0;
    reg [8:0] pixel_col = 0;
    reg [7:0] pixel_row = 0;
    reg write_pixel = 0;

    // ILI9341 input interface
    wire rst, csx, dcx, wrx, rdx, initialized;
    wire [15:0] data;

    // Instantiate graphic manager
    graphic_manager graphic_manager_inst (
        .clk(clk_tb),
        .en(en_tb),
        .reset(reset_tb),
        .pixel_col(pixel_col),
        .pixel_row(pixel_row),
        .write_pixel(write_pixel),
        .bw_pixel_color(bw_pixel_color),
        .initialized(initialized),
        .tft_rst(rst),
        .tft_csx(csx),
        .tft_dcx(dcx),
        .tft_wrx(wrx),
        .tft_rdx(rdx),
        .tft_data(data)
    );

    // Clock generation
    always begin
        #5 clk_tb = ~clk_tb;
    end

    initial begin
        #10;
        reset_tb = 1;
        #10;
        reset_tb = 0;
        en_tb = 1;

        wait(initialized != 0);

        #10;
        pixel_col = 5;
        pixel_row = 0;
        bw_pixel_color = 1'b1;

        #40;
        write_pixel = 1;
        #20;
        write_pixel = 0;
        #20;
    end


endmodule