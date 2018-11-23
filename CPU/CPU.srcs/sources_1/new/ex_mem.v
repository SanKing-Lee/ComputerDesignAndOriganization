`timescale 1ns / 1ps
`include "define.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/10/15 17:49:58
// Design Name: 
// Module Name: ex_mem
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


module ex_mem(
	//clk and rst
	input wire clk, rst,
	input wire ex_wreg,
	input wire[`RegAddrBus] ex_wd,
	input wire[`RegBus] ex_wdata,
	output reg mem_wreg,
	output reg[`RegAddrBus] mem_wd,
	output reg[`RegBus] mem_wdata,

	//hi_lo from ex
	input wire ex_whilo,
	input wire[`RegBus] ex_hi,
	input wire[`RegBus] ex_lo,

	//hi_lo to mem
	output reg mem_whilo,
	output reg[`RegBus] mem_hi,
	output reg[`RegBus] mem_lo
    );
	always@(posedge clk) begin
		if(rst == `RstEnable) begin
			mem_wreg <= `WriteDisable;
			mem_wd <= `NOPRegAddr;
			mem_wdata <= `ZeroWord;
			mem_whilo <= `WriteDisable;
			mem_hi <= `ZeroWord;
			mem_lo <= `ZeroWord;
		end // if(rst == `RstEnable)
		else begin
			mem_wreg <= ex_wreg;
			mem_wd <= ex_wd;
			mem_wdata <= ex_wdata;
			mem_whilo <= ex_whilo;
			mem_hi <= ex_hi;
			mem_lo <= ex_lo;
		end // else
	end // always@(posedge clk)
endmodule
