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
// CREATED		"Sun Dec 15 11:14:10 2024"

module predicted_digit(
	clk,
	reset,
	en,
	indices,
	output_activations,
	max_val_ouot,
	predicted_digit
);


input wire	clk;
input wire	reset;
input wire	en;
input wire	[39:0] indices;
input wire	[79:0] output_activations;
output wire	[7:0] max_val_ouot;
output wire	[3:0] predicted_digit;

wire	[3:0] SYNTHESIZED_WIRE_0;
wire	[3:0] SYNTHESIZED_WIRE_1;
wire	[3:0] SYNTHESIZED_WIRE_2;
wire	[3:0] SYNTHESIZED_WIRE_3;
wire	[7:0] SYNTHESIZED_WIRE_4;
wire	[7:0] SYNTHESIZED_WIRE_5;
wire	[3:0] SYNTHESIZED_WIRE_6;
wire	[3:0] SYNTHESIZED_WIRE_7;
wire	[7:0] SYNTHESIZED_WIRE_8;
wire	[7:0] SYNTHESIZED_WIRE_9;
wire	[3:0] SYNTHESIZED_WIRE_10;
wire	[3:0] SYNTHESIZED_WIRE_11;
wire	[7:0] SYNTHESIZED_WIRE_12;
wire	[7:0] SYNTHESIZED_WIRE_13;
wire	[3:0] SYNTHESIZED_WIRE_14;
wire	[3:0] SYNTHESIZED_WIRE_15;
wire	[7:0] SYNTHESIZED_WIRE_16;
wire	[7:0] SYNTHESIZED_WIRE_17;
wire	[7:0] SYNTHESIZED_WIRE_18;
wire	[7:0] SYNTHESIZED_WIRE_19;





dff_nbit	b2v_idx2(
	.clk(clk),
	.en(en),
	.reset(reset),
	.di(SYNTHESIZED_WIRE_0),
	.dout(SYNTHESIZED_WIRE_3));
	defparam	b2v_idx2.nbit = 4;


dff_nbit	b2v_idx_1(
	.clk(clk),
	.en(en),
	.reset(reset),
	.di(SYNTHESIZED_WIRE_1),
	.dout(SYNTHESIZED_WIRE_0));
	defparam	b2v_idx_1.nbit = 4;


comparator	b2v_inst(
	.clk(clk),
	.reset(reset),
	.idx1(indices[39:36]),
	.idx2(indices[35:32]),
	.in1(output_activations[79:72]),
	.in2(output_activations[71:64]),
	.max_idx(SYNTHESIZED_WIRE_6),
	.max_val(SYNTHESIZED_WIRE_8));
	defparam	b2v_inst.index_size = 4;
	defparam	b2v_inst.resolution = 8;


comparator	b2v_inst14(
	.clk(clk),
	.reset(reset),
	.idx1(SYNTHESIZED_WIRE_2),
	.idx2(SYNTHESIZED_WIRE_3),
	.in1(SYNTHESIZED_WIRE_4),
	.in2(SYNTHESIZED_WIRE_5),
	.max_idx(predicted_digit),
	.max_val(max_val_ouot));
	defparam	b2v_inst14.index_size = 4;
	defparam	b2v_inst14.resolution = 8;


comparator	b2v_inst3(
	.clk(clk),
	.reset(reset),
	.idx1(indices[31:28]),
	.idx2(indices[27:24]),
	.in1(output_activations[63:56]),
	.in2(output_activations[55:48]),
	.max_idx(SYNTHESIZED_WIRE_7),
	.max_val(SYNTHESIZED_WIRE_9));
	defparam	b2v_inst3.index_size = 4;
	defparam	b2v_inst3.resolution = 8;


comparator	b2v_inst4(
	.clk(clk),
	.reset(reset),
	.idx1(indices[23:20]),
	.idx2(indices[19:16]),
	.in1(output_activations[47:40]),
	.in2(output_activations[39:32]),
	.max_idx(SYNTHESIZED_WIRE_10),
	.max_val(SYNTHESIZED_WIRE_12));
	defparam	b2v_inst4.index_size = 4;
	defparam	b2v_inst4.resolution = 8;


comparator	b2v_inst5(
	.clk(clk),
	.reset(reset),
	.idx1(indices[15:12]),
	.idx2(indices[11:8]),
	.in1(output_activations[31:24]),
	.in2(output_activations[23:16]),
	.max_idx(SYNTHESIZED_WIRE_11),
	.max_val(SYNTHESIZED_WIRE_13));
	defparam	b2v_inst5.index_size = 4;
	defparam	b2v_inst5.resolution = 8;


comparator	b2v_inst6(
	.clk(clk),
	.reset(reset),
	.idx1(indices[7:4]),
	.idx2(indices[3:0]),
	.in1(output_activations[15:8]),
	.in2(output_activations[7:0]),
	.max_idx(SYNTHESIZED_WIRE_1),
	.max_val(SYNTHESIZED_WIRE_19));
	defparam	b2v_inst6.index_size = 4;
	defparam	b2v_inst6.resolution = 8;


comparator	b2v_inst7(
	.clk(clk),
	.reset(reset),
	.idx1(SYNTHESIZED_WIRE_6),
	.idx2(SYNTHESIZED_WIRE_7),
	.in1(SYNTHESIZED_WIRE_8),
	.in2(SYNTHESIZED_WIRE_9),
	.max_idx(SYNTHESIZED_WIRE_14),
	.max_val(SYNTHESIZED_WIRE_16));
	defparam	b2v_inst7.index_size = 4;
	defparam	b2v_inst7.resolution = 8;


comparator	b2v_inst8(
	.clk(clk),
	.reset(reset),
	.idx1(SYNTHESIZED_WIRE_10),
	.idx2(SYNTHESIZED_WIRE_11),
	.in1(SYNTHESIZED_WIRE_12),
	.in2(SYNTHESIZED_WIRE_13),
	.max_idx(SYNTHESIZED_WIRE_15),
	.max_val(SYNTHESIZED_WIRE_17));
	defparam	b2v_inst8.index_size = 4;
	defparam	b2v_inst8.resolution = 8;


comparator	b2v_inst9(
	.clk(clk),
	.reset(reset),
	.idx1(SYNTHESIZED_WIRE_14),
	.idx2(SYNTHESIZED_WIRE_15),
	.in1(SYNTHESIZED_WIRE_16),
	.in2(SYNTHESIZED_WIRE_17),
	.max_idx(SYNTHESIZED_WIRE_2),
	.max_val(SYNTHESIZED_WIRE_4));
	defparam	b2v_inst9.index_size = 4;
	defparam	b2v_inst9.resolution = 8;


dff_nbit	b2v_outp_act2(
	.clk(clk),
	.en(en),
	.reset(reset),
	.di(SYNTHESIZED_WIRE_18),
	.dout(SYNTHESIZED_WIRE_5));
	defparam	b2v_outp_act2.nbit = 8;


dff_nbit	b2v_outp_activ1(
	.clk(clk),
	.en(en),
	.reset(reset),
	.di(SYNTHESIZED_WIRE_19),
	.dout(SYNTHESIZED_WIRE_18));
	defparam	b2v_outp_activ1.nbit = 8;


endmodule
