`timescale 1ns/1ps
module painter_tb();
    reg clk = 0;
    reg en = 0;
    reg reset = 0;
    reg load_frame_sel = 0;

    // ROM memory frame
    wire [16:0] rom_addr;
    reg rom_q = 0;

    // Graphic manager interface
    reg initialized = 0;
    wire bw_pixel_color;
    wire [8:0] pixel_col;
    wire [7:0] pixel_row;
    wire write_pixel;

    // LT24 touchscreen driver interface
    reg pos_ready = 0;
    reg [11:0] x_pos, y_pos;

    painter #(
        .N_FRAMES(2)
    ) dut (
        .clk(clk),
        .en(en),
        .reset(reset),
        .load_frame_sel(load_frame_sel),
        .rom_addr(rom_addr),
        .rom_q(rom_q),
        .initialized(initialized),
        .bw_pixel_color(bw_pixel_color),
        .pixel_col(pixel_col),
        .pixel_row(pixel_row),
        .write_pixel(write_pixel),
        .pos_ready(pos_ready),
        .x_pos(x_pos),
        .y_pos(y_pos)
    );

    always begin
        #5 clk = ~clk;
    end

    initial begin
        load_frame_sel = 1;
        rom_q = 1;
        reset = 1;
        #40;
        reset = 0;
        en = 1;
        #80;
        initialized = 1;
        #20;
        #(320*240*10);  // Wait PIXEL_NUM clock cycles
        #20;
        pos_ready = 1;
        x_pos = 12'b100000000000;
        y_pos = 12'b111111111111;
        #60;
        pos_ready = 0;


    end

endmodule