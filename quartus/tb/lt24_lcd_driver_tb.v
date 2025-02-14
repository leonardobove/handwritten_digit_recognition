`timescale 1ns/1ps
module lt24_lcd_driver_tb;

    reg clk_tb = 0;
    reg en_tb = 0;
    reg reset_tb = 0;
    reg [15:0] pixel_rgb_tb = 0;
    reg print_tb = 0;
    
    wire initialized_tb;
    wire rst, csx, dcx, wrx, rdx;
    wire [15:0] data;

    // Instantiate LT24 driver
    lt24_lcd_driver dut (
        .clk(clk_tb),
        .en(en_tb),
        .reset(reset_tb),
        .pixel_rgb(pixel_rgb_tb),
        .print(print_tb),
        .initialized(initialized_tb),
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

    // Testbench
    initial begin
        en_tb = 1;
        #10;
        reset_tb = 1;
        #10;
        reset_tb = 0;
        
        wait(initialized_tb != 0);

        #10;
        pixel_rgb_tb = 16'd1;
        print_tb = 1;
        #10;
        print_tb = 0;
        #100;
        reset_tb = 1;
        #20;
    end


endmodule