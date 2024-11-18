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
// CREATED		"Mon Nov 11 22:55:28 2024"


module lpm_ram_dp_0(rden,rdclock,rdclken,wren,wrclock,wrclken,data,rdaddress,wraddress,q);
input rden;
input rdclock;
input rdclken;
input wren;
input wrclock;
input wrclken;
input [0:0] data;
input [16:0] rdaddress;
input [16:0] wraddress;
output [0:0] q;

lpm_ram_dp	lpm_instance(.rden(rden),.rdclock(rdclock),.rdclken(rdclken),.wren(wren),.wrclock(wrclock),.wrclken(wrclken),.data(data),.rdaddress(rdaddress),.wraddress(wraddress),.q(q));
	defparam	lpm_instance.LPM_INDATA = "REGISTERED";
	defparam	lpm_instance.LPM_NUMWORDS = 131072;
	defparam	lpm_instance.LPM_OUTDATA = "UNREGISTERED";
	defparam	lpm_instance.LPM_RDADDRESS_CONTROL = "REGISTERED";
	defparam	lpm_instance.LPM_WIDTH = 1;
	defparam	lpm_instance.LPM_WIDTHAD = 17;
	defparam	lpm_instance.LPM_WRADDRESS_CONTROL = "REGISTERED";

endmodule
