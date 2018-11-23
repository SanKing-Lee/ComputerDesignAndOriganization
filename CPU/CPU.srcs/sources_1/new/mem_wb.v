`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/10/15 18:08:45
// Design Name: 
// Module Name: mem_wb
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


module mem_wb(
	input wire clk, rst,
	input wire mem_wreg,
	input wire[`RegAddrBus] mem_wd,
	input wire[`RegBus] mem_wdata,
	output reg wb_wreg,
	output reg[`RegAddrBus] wb_wd,
	output reg[`RegBus] wb_wdata,

	//hi_lo from mem
	input wire mem_whilo,
	input wire[`RegBus] mem_hi,
	input wire[`RegBus] mem_lo,

	//hi_lo to wb
	output reg wb_whilo,
	output reg[`RegBus] wb_hi,
	output reg[`RegBus] wb_lo
    );	
	always@(posedge clk) begin
		if(rst == `RstEnable) begin
			wb_wreg <= `WriteDisable;
			wb_wd <= `NOPRegAddr;
			wb_wdata <= `ZeroWord;
			wb_whilo <= `WriteDisable;
			wb_hi <= `ZeroWord;
			wb_lo <= `ZeroWord;
		end // if(rst == `RstEnable)
		else begin
			wb_wreg <= mem_wreg;
			wb_wd <= mem_wd;
			wb_wdata <= mem_wdata;
			wb_whilo <= mem_whilo;
			wb_hi <= mem_hi;
			wb_lo <= mem_lo;
		end // else
	end
endmodule
