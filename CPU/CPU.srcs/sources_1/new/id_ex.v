`timescale 1ns / 1ps
`include "define.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/10/15 17:22:01
// Design Name: 
// Module Name: id_ex
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


module id_ex(
	//rst and clk
	input wire rst, clk,
	//parts of instruction from id
	input wire[`AluOpBus] id_aluop,
	input wire[`AluSelBus] id_alusel,
	input wire[`RegBus] id_reg1,
	input wire[`RegBus] id_reg2,
	input wire[`RegAddrBus] id_wd,
	input wire id_wreg,
	//stall
	input wire[5:0] stall,
	//branch instructions
	input wire id_is_in_delayslot,
	input wire[`InstAddrBus] id_link_address,
	input wire next_inst_in_delayslot_i,

	input wire[`InstBus] id_inst,

	//parts of instruction to ex
	output reg[`AluOpBus] ex_aluop,
	output reg[`AluSelBus] ex_alusel,
	output reg[`RegBus] ex_reg1,
	output reg[`RegBus] ex_reg2,
	output reg[`RegAddrBus] ex_wd,
	output reg ex_wreg,
	//branch 
	output reg ex_is_in_delayslot,
	output reg[`InstAddrBus] ex_link_address,
	output reg is_in_delayslot_o,

	output reg[`InstBus] ex_inst,

	//exception
	input wire flush,
	input wire[`RegBus] id_excepttype,
	input wire[`InstAddrBus] id_current_inst_address,

	output reg[`RegBus] ex_excepttype,
	output reg[`InstAddrBus] ex_current_inst_address
    );
	always@(posedge clk) begin
		if(rst == `RstEnable) begin
			ex_aluop <= `EXE_NOP_OP;
			ex_alusel <= `EXE_RES_NOP;
			ex_reg1 <= `ZeroWord;
			ex_reg2 <= `ZeroWord;
			ex_wd <= `NOPRegAddr;
			ex_wreg <= `WriteDisable;
			ex_is_in_delayslot <= `NotInDelaySlot;
			ex_link_address <= `ZeroWord;
			is_in_delayslot_o <= `NotInDelaySlot;
			ex_inst <= `ZeroWord;
			ex_excepttype <= `ZeroWord;
			ex_current_inst_address <= `ZeroWord;
		end
		else if(flush == 1'b1) begin
			ex_aluop <= `EXE_NOP_OP;
			ex_alusel <= `EXE_RES_NOP;
			ex_reg1 <= `ZeroWord;
			ex_reg2 <= `ZeroWord;
			ex_wd <= `NOPRegAddr;
			ex_wreg <= `WriteDisable;
			ex_is_in_delayslot <= `NotInDelaySlot;
			ex_link_address <= `ZeroWord;
			is_in_delayslot_o <= `NotInDelaySlot;
			ex_inst <= `ZeroWord;
			ex_excepttype <= `ZeroWord;
			ex_current_inst_address <= `ZeroWord;
		end
		//decode was stalled
		else if(stall[2] == `Stop && stall[3] == `NoStop) begin
			ex_aluop <= `EXE_NOP_OP;
			ex_alusel <= `EXE_RES_NOP;
			ex_reg1 <= `ZeroWord;
			ex_reg2 <= `ZeroWord;
			ex_wd <= `NOPRegAddr;
			ex_wreg <= `WriteDisable;
			ex_is_in_delayslot <= `NotInDelaySlot;
			ex_link_address <= `ZeroWord;
			is_in_delayslot_o <= `NotInDelaySlot;
			ex_inst <= `ZeroWord;
			ex_excepttype <= `ZeroWord;
			ex_current_inst_address <= `ZeroWord;
		end // else if(stall[2] == `Stop && stall[3] == `NoStop)
		//decode was not stalled 
		else if(stall[2] == `NoStop) begin
			ex_aluop <= id_aluop;
			ex_alusel <= id_alusel;
			ex_reg1 <= id_reg1;
			ex_reg2 <= id_reg2;
			ex_wd <= id_wd;
			ex_wreg <= id_wreg;
			ex_is_in_delayslot <= id_is_in_delayslot;
			ex_link_address <= id_link_address;
			is_in_delayslot_o <= next_inst_in_delayslot_i;
			ex_inst <= id_inst;
			ex_excepttype <= id_excepttype;
			ex_current_inst_address <= id_current_inst_address;
		end // else
	end // always@(posedge clk)
endmodule
