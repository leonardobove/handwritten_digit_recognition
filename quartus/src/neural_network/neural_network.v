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
// CREATED		"Sun Jan 19 16:59:54 2025"

module neural_network(
	clk,
	start,
	reset,
	en,
	pixels,
	done,
	predicted_digit
);

parameter	input_pixels_number = 784;
parameter	pixels_averaged_number = 196;
parameter	resolution = 8;

input wire	clk;
input wire	start;
input wire	reset;
input wire	en;
input wire	[6271:0] pixels;
output wire	done;
output wire	[3:0] predicted_digit;

wire	[0:0] SYNTHESIZED_WIRE_0;
wire	[6271:0] SYNTHESIZED_WIRE_1;





FW_logic_FSM	b2v_forward_logic_inst(
	.clk(clk),
	.reset(reset),
	.start(SYNTHESIZED_WIRE_0),
	.en(en),
	.pixels(SYNTHESIZED_WIRE_1),
	.done(done),
	.predicted_digit(predicted_digit));
	defparam	b2v_forward_logic_inst.pixels_averaged_nr = 196;
	defparam	b2v_forward_logic_inst.pixels_number = 784;
	defparam	b2v_forward_logic_inst.resolution = 8;


dff_nbit	b2v_pixels_buffer(
	.clk(clk),
	.en(en),
	.reset(reset),
	.di(pixels),
	.dout(SYNTHESIZED_WIRE_1));
	defparam	b2v_pixels_buffer.nbit = 6272;


dff_nbit	b2v_start_buffer(
	.clk(clk),
	.en(en),
	.reset(reset),
	.di(start),
	.dout(SYNTHESIZED_WIRE_0));
	defparam	b2v_start_buffer.nbit = 1;


endmodule
