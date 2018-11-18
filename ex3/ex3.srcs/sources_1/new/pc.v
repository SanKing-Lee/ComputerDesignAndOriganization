`timescale 1ns / 1ps
`include "define.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/01 00:06:28
// Design Name: 
// Module Name: pc
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


module pc(
	input wire clk, rst,
	input wire[31:0] pcnext,
	output reg[31:0] pc, 
	output reg inst_ce
    );
	always@(posedge clk) begin
		if(rst == `RstEnable) begin
			inst_ce <= `InstDisable;
		end
		else begin
			inst_ce <= `InstEnable;
		end // else
	end
	always@(posedge clk) begin
		if(inst_ce == `InstDisable) begin	
			pc <= 32'h0;
		end
		else begin
			pc <= pcnext + 4;
		end // else
	end
endmodule
