`timescale 1ns / 1ps
`include "define.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/25 17:31:52
// Design Name: 
// Module Name: ctrl
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


module ctrl(
	input wire rst,
	input wire stallreq_from_id,
	input wire stallreq_from_ex,
	output reg[5:0] stall
    );
	always@(*) begin
		if(rst == `RstEnable) begin
			stall <= 6'b000000;
		end // if(rst == `RstEnable)
		else if(stallreq_from_ex == `Stop) begin
			stall <= 6'b001111;
		end // else if(stallreq_from_ex == `Stop)
		else if(stallreq_from_id == `Stop) begin
			stall <= 6'b000111;
		end // else if(stallreq_from_id == `Stop)
		else begin
			stall <= 6'b000000;
		end // else
	end // always@(*)
endmodule
