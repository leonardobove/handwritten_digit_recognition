// Copyright (C) 2018  Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions 
// and other software and tools, and its AMPP partner logic 
// functions, and any output files from any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License 
// Subscription Agreement, the Intel Quartus Prime License Agreement,
// the Intel FPGA IP License Agreement, or other applicable license
// agreement, including, without limitation, that your use is for
// the sole purpose of programming logic devices manufactured by
// Intel and sold by Intel or its authorized distributors.  Please
// refer to the applicable agreement for further details.

// PROGRAM		"Quartus Prime"
// VERSION		"Version 18.1.0 Build 625 09/12/2018 SJ Lite Edition"
// CREATED		"Wed Nov 13 17:42:40 2024"

module graphic_manager(
	clk,
	en,
	reset,
	bw_pixel_color,
	write_pixel,
	pixel_col,
	pixel_row,
	tft_rst,
	tft_csx,
	tft_dcx,
	tft_wrx,
	tft_rdx,
	initialized,
	tft_data
);


input wire	clk;
input wire	en;
input wire	reset;
input wire	bw_pixel_color;
input wire	write_pixel;
input wire	[8:0] pixel_col;
input wire	[7:0] pixel_row;
output wire	tft_rst;
output wire	tft_csx;
output wire	tft_dcx;
output wire	tft_wrx;
output wire	tft_rdx;
output wire	initialized;
output wire	[15:0] tft_data;

wire	ram_q;
wire	SYNTHESIZED_WIRE_0;
wire	SYNTHESIZED_WIRE_1;
wire	SYNTHESIZED_WIRE_2;
wire	SYNTHESIZED_WIRE_3;
wire	[16:0] SYNTHESIZED_WIRE_4;
wire	[16:0] SYNTHESIZED_WIRE_5;
wire	SYNTHESIZED_WIRE_6;
wire	[15:0] SYNTHESIZED_WIRE_7;





graphic_controller	b2v_graphic_controller_inst(
	.clk(clk),
	.en(en),
	.reset(reset),
	.bw_pixel_color(bw_pixel_color),
	.write_pixel(write_pixel),
	.ram_q(ram_q),
	.driver_done(SYNTHESIZED_WIRE_0),
	.driver_initialized(SYNTHESIZED_WIRE_1),
	.pixel_col(pixel_col),
	.pixel_row(pixel_row),
	.initialized(initialized),
	.ram_data(SYNTHESIZED_WIRE_3),
	.write_enable(SYNTHESIZED_WIRE_2),
	.print(SYNTHESIZED_WIRE_6),
	.pixel_rgb(SYNTHESIZED_WIRE_7),
	.read_addr(SYNTHESIZED_WIRE_4),
	.write_addr(SYNTHESIZED_WIRE_5));


simple_dual_port_ram_single_clock	b2v_inst(
	.we(SYNTHESIZED_WIRE_2),
	.clk(clk),
	.data(SYNTHESIZED_WIRE_3),
	.read_addr(SYNTHESIZED_WIRE_4),
	.write_addr(SYNTHESIZED_WIRE_5),
	.q(ram_q));
	defparam	b2v_inst.ADDR_WIDTH = 17;
	defparam	b2v_inst.DATA_WIDTH = 1;


lt24_lcd_driver	b2v_lt24_lcd_driver_inst(
	.clk(clk),
	.en(en),
	.reset(reset),
	.print(SYNTHESIZED_WIRE_6),
	.pixel_rgb(SYNTHESIZED_WIRE_7),
	.done(SYNTHESIZED_WIRE_0),
	.initialized(SYNTHESIZED_WIRE_1),
	.tft_rst(tft_rst),
	.tft_csx(tft_csx),
	.tft_dcx(tft_dcx),
	.tft_wrx(tft_wrx),
	.tft_rdx(tft_rdx),
	.tft_data(tft_data));


endmodule
