`timescale 1ns / 1ps
`include "define.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/10/14 20:35:01
// Design Name: 
// Module Name: if_id
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


module if_id(
	//rst and clk
	input wire rst,
	input wire clk,
	input wire[`InstAddrBus] if_pc,
	input wire[`InstBus] if_inst,
	input wire[5:0] stall,
	output reg[`InstAddrBus] id_pc,
	output reg[`InstBus] id_inst,
	//exception
	input wire flush
    );
	//set output according to rst
	always@(posedge clk) begin
		if(rst == `RstEnable) begin
			id_pc <= `ZeroWord;
			id_inst <= `ZeroWord;
		end
		else if(flush == 1'b1) begin
			id_pc <= `ZeroWord;
			id_inst <= `ZeroWord;
		end
		else if(stall[1] == `Stop && stall[2] == `NoStop) begin
			id_pc <= `ZeroWord;
			id_inst <= `ZeroWord;
		end // else if(stall[1] == `Stop && stall[2] == `Nostop)
		else if(stall[1] == `NoStop) begin
			id_pc <= if_pc;
			id_inst <= if_inst;
		end
	end
endmodule
