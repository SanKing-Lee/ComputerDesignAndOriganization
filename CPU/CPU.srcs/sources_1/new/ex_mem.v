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
	output reg[`RegBus] mem_lo,
	//stall
	input wire[5:0] stall,

	//madd, msub
	input wire[`DoubleRegBus] hilo_i,
	input wire[1:0] cnt_i,
	output reg[`DoubleRegBus] hilo_o,
	output reg[1:0] cnt_o,

	//store and load
	input wire[`AluOpBus] ex_aluop,
	input wire[`InstAddrBus] ex_mem_addr,
	input wire[`RegBus] ex_reg2,
	output reg[`AluOpBus] mem_aluop,
	output reg[`InstAddrBus] mem_mem_addr,
	output reg[`RegBus] mem_reg2,

	//cp0 regsiter
	input wire ex_cp0_reg_we,
	input wire[`RegAddrBus] ex_cp0_reg_waddr,
	input wire[`RegBus] ex_cp0_reg_data,

	output reg mem_cp0_reg_we,
	output reg[`RegAddrBus] mem_cp0_reg_waddr,
	output reg[`RegBus] mem_cp0_reg_data,

	//exception
	input wire flush,
	input wire[`RegBus] ex_excepttype,
	input wire[`InstAddrBus] ex_current_inst_address,
	input wire ex_is_in_delayslot,

	output reg[`RegBus] mem_excepttype,
	output reg[`InstAddrBus] mem_current_inst_address,
	output reg mem_is_in_delayslot
    );
	always@(posedge clk) begin
		if(rst == `RstEnable) begin
			mem_wreg <= `WriteDisable;
			mem_wd <= `NOPRegAddr;
			mem_wdata <= `ZeroWord;
			mem_whilo <= `WriteDisable;
			mem_hi <= `ZeroWord;
			mem_lo <= `ZeroWord;
			hilo_o <= {`ZeroWord, `ZeroWord};
			cnt_o <= 2'b00;
			mem_aluop <= `EXE_NOP_OP;
			mem_mem_addr <= `ZeroWord;
			mem_reg2 <= `ZeroWord;
			mem_cp0_reg_we <= `WriteDisable;
			mem_cp0_reg_data <= `ZeroWord;
			mem_cp0_reg_waddr <= `NOPRegAddr;
			mem_excepttype <= `ZeroWord;
			mem_is_in_delayslot <= 1'b0;
			mem_current_inst_address <= `ZeroWord;
		end // if(rst == `RstEnable)
		//execute was stalled 
		else if(flush == 1'b1) begin
			mem_wreg <= `WriteDisable;
			mem_wd <= `NOPRegAddr;
			mem_wdata <= `ZeroWord;
			mem_whilo <= `WriteDisable;
			mem_hi <= `ZeroWord;
			mem_lo <= `ZeroWord;
			hilo_o <= {`ZeroWord, `ZeroWord};
			cnt_o <= 2'b00;
			mem_aluop <= `EXE_NOP_OP;
			mem_mem_addr <= `ZeroWord;
			mem_reg2 <= `ZeroWord;
			mem_cp0_reg_we <= `WriteDisable;
			mem_cp0_reg_data <= `ZeroWord;
			mem_cp0_reg_waddr <= `NOPRegAddr;
			mem_excepttype <= `ZeroWord;
			mem_is_in_delayslot <= 1'b0;
			mem_current_inst_address <= `ZeroWord;
		end
		else if(stall[3] == `Stop && stall[4] == `NoStop) begin
			mem_wreg <= `WriteDisable;
			mem_wd <= `NOPRegAddr;
			mem_wdata <= `ZeroWord;
			mem_whilo <= `WriteDisable;
			mem_hi <= `ZeroWord;
			mem_lo <= `ZeroWord;
			hilo_o <= hilo_i;
			cnt_o <= cnt_i;
			mem_aluop <= `EXE_NOP_OP;
			mem_mem_addr <= `ZeroWord;
			mem_reg2 <= `ZeroWord;
			mem_cp0_reg_we <= `WriteDisable;
			mem_cp0_reg_data <= `ZeroWord;
			mem_cp0_reg_waddr <= `NOPRegAddr;
			mem_excepttype <= `ZeroWord;
			mem_is_in_delayslot <= 1'b0;
			mem_current_inst_address <= `ZeroWord;
		end // else if(stall[3] == `Stop && stall[4] == `NoStop)
		else if(stall[3] == `NoStop) begin
			mem_wreg <= ex_wreg;
			mem_wd <= ex_wd;
			mem_wdata <= ex_wdata;
			mem_whilo <= ex_whilo;
			mem_hi <= ex_hi;
			mem_lo <= ex_lo;
			hilo_o <= {`ZeroWord, `ZeroWord};
			cnt_o <= 2'b00;
			mem_aluop <= ex_aluop;
			mem_mem_addr <= ex_mem_addr;
			mem_reg2 <= ex_reg2;
			mem_cp0_reg_waddr <= ex_cp0_reg_waddr;
			mem_cp0_reg_we <= ex_cp0_reg_we;
			mem_cp0_reg_data <= ex_cp0_reg_data;
			mem_excepttype <= ex_excepttype;
			mem_is_in_delayslot <= ex_is_in_delayslot;
			mem_current_inst_address <= ex_current_inst_address;
		end // else
		else begin
			hilo_o <= hilo_i;
			cnt_o <= cnt_i;
		end // else
	end // always@(posedge clk)
endmodule
