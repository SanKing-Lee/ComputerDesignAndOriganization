`timescale 1ns / 1ps
`include "define.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/10/14 20:28:08
// Design Name: 
// Module Name: pc_reg
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


module pc_reg(
	//clk and rst signal
	input wire clk,
	input wire rst,
	input wire[5:0] stall,
	//output address of instruction
	output reg[`InstAddrBus] pc,
	//chip enable
	output reg ce,
	//branch
	//branch or not
	input wire branch_flag_i,
	//where to branch 
	input wire[`RegBus] branch_target_address_i,
	//exception
	input wire flush,
	input wire[`RegBus] new_pc
    );
	//set ce according to rst
	always@(posedge clk) begin
		if(rst == `RstEnable) begin
			ce <= `ChipDisable;
		end
		else begin
			ce <= `ChipEnable;
		end
	end

	//set pc according to ce
	always@(posedge clk) begin
		if(ce == `ChipDisable) begin
			pc <= 32'h0000_0000;
		end 
		else begin
			if(flush == 1'b1) begin
				pc <= new_pc;
			end
			else if(stall[0] == `NoStop) begin
				if(branch_flag_i == `Branch) begin
					pc <= branch_target_address_i;
				end
				else begin
					pc <= pc + 4'h4;
				end // else
			end
		end
	end

endmodule
