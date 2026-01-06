// Copyright (C) 2020  Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions 
// and other software and tools, and any partner logic 
// functions, and any output files from any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License 
// Subscription Agreement, the Intel Quartus Prime License Agreement,
// the Intel FPGA IP License Agreement, or other applicable license
// agreement, including, without limitation, that your use is for
// the sole purpose of programming logic devices manufactured by
// Intel and sold by Intel or its authorized distributors.  Please
// refer to the applicable agreement for further details, at
// https://fpgasoftware.intel.com/eula.

// PROGRAM		"Quartus Prime"
// VERSION		"Version 20.1.1 Build 720 11/11/2020 SJ Lite Edition"
// CREATED		"Fri Jan 02 13:54:23 2026"

module MAIN(
	CLOCK_50,
	SW,
	LEDG,
	LEDR
);


input wire	CLOCK_50;
input wire	[0:0] SW;
output wire	[0:0] LEDG;
output wire	[0:15] LEDR;

wire	SYNTHESIZED_WIRE_0;
wire	SYNTHESIZED_WIRE_1;
wire	[4:0] SYNTHESIZED_WIRE_2;
wire	[15:0] SYNTHESIZED_WIRE_3;
wire	[15:0] SYNTHESIZED_WIRE_4;

assign	LEDR[0:15] = SYNTHESIZED_WIRE_4[15:0];




memory	b2v_inst(
	.wren(SYNTHESIZED_WIRE_0),
	.rden(SYNTHESIZED_WIRE_1),
	.clock(CLOCK_50),
	.address(SYNTHESIZED_WIRE_2),
	.data(SYNTHESIZED_WIRE_3),
	.q(SYNTHESIZED_WIRE_4));


TOP	b2v_inst1(
	.Clock(CLOCK_50),
	.Reset(SW),
	.DataOut(SYNTHESIZED_WIRE_4),
	.Ready(LEDG),
	.ReadEnable(SYNTHESIZED_WIRE_1),
	.WriteEnable(SYNTHESIZED_WIRE_0),
	.Address(SYNTHESIZED_WIRE_2),
	.DataIN(SYNTHESIZED_WIRE_3));


endmodule
