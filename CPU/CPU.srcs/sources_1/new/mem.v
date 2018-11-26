`timescale 1ns / 1ps
`include "define.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/10/15 18:00:12
// Design Name: 
// Module Name: mem
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module mem(
	input wire rst,
	input wire wreg_i,
	input wire[`RegAddrBus] wd_i,
	input wire[`RegBus] wdata_i,
	output reg wreg_o,
	output reg[`RegAddrBus] wd_o,
	output reg[`RegBus] wdata_o,

	//hi_lo input
	input wire whilo_i,
	input wire[`RegBus] hi_i,
	input wire[`RegBus] lo_i,

	//hi_lo output
	output reg whilo_o,
	output reg[`RegBus] hi_o,
	output reg[`RegBus] lo_o
    );
	always@(*) begin
		if(rst == `RstEnable) begin
			wreg_o <= `WriteDisable;
			wd_o <= `NOPRegAddr;
			wdata_o <= `ZeroWord;
			whilo_o <= `WriteDisable;
			hi_o <= `ZeroWord;
			lo_o <= `ZeroWord;
		end // if(rst == `RstEnable)
		else begin
			wreg_o <= wreg_i;
			wd_o <= wd_i;
			wdata_o <= wdata_i;
			whilo_o <= whilo_i;
			hi_o <= hi_i;
			lo_o <= lo_i;
		end // else
	end // always@(*)
endmodule
