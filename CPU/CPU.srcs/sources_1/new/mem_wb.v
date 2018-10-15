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
	output reg[`RegBus] wb_wdata
    );	
	always@(posedge clk) begin
		if(rst == `RstEnable) begin
			wb_wreg <= `WriteDisable;
			wb_wd <= `NOPRegAddr;
			wb_wdata <= `ZeroWord;
		end // if(rst == `RstEnable)
		else begin
			wb_wreg <= mem_wreg;
			wb_wd <= mem_wd;
			wb_wdata <= mem_wdata;
		end // else
	end
endmodule
