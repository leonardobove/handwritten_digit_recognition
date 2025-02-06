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
// CREATED		"Wed Feb 05 17:52:55 2025"

module FW_logic_FSM_wrapper(
	clk,
	en,
	reset,
	start,
	pixels_in,
	done,
	predict_digit
);


input wire	clk;
input wire	en;
input wire	reset;
input wire	start;
input wire	[1567:0] pixels_in;
output wire	done;
output wire	[3:0] predict_digit;

wire	[1567:0] pixels_reg;
wire	[0:0] SYNTHESIZED_WIRE_0;





FW_logic_FSM	FW_logic_FSM_i(
	.clk(clk),
	.reset(reset),
	.start(SYNTHESIZED_WIRE_0),
	.en(en),
	.averaged_pixels(pixels_reg),
	.done(done),
	.predict_digit(predict_digit));
	defparam	FW_logic_FSM_i.pixels_averaged_nr = 196;
	defparam	FW_logic_FSM_i.WIDTH = 8;


dff_nbit	dff_pixels(
	.clk(clk),
	.en(en),
	.reset(reset),
	.di(pixels_in),
	.dout(pixels_reg));
	defparam	dff_pixels.nbit = 1568;


dff_nbit	dff_start(
	.clk(clk),
	.en(en),
	.reset(reset),
	.di(start),
	.dout(SYNTHESIZED_WIRE_0));
	defparam	dff_start.nbit = 1;


endmodule
