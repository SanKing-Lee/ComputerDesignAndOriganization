`timescale 1ns / 1ps
`include "define.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/10/14 21:49:11
// Design Name: 
// Module Name: id
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


module id(
	//rst
	input wire rst,
	//instruction
	input wire[`InstAddrBus] pc_i,
	input wire[`InstBus] inst_i,
	//read registers 
	input wire[`RegBus] reg1_data_i, reg2_data_i,
	output reg reg1_read_o, reg2_read_o,
	output reg[`RegAddrBus] reg1_addr_o, reg2_addr_o,
	//parts of instruction
	output reg[`AluOpBus] aluop_o,
	output reg[`AluSelBus] alusel_o,
	output reg[`RegBus] reg1_o, reg2_o,
	output reg[`RegAddrBus] wd_o,
	output reg wreg_o
    );
	//operation code
	wire[5:0] op = inst_i[31:26];
	//oprands
	wire[4:0] op2 = inst_i[10:6];
	wire[5:0] op3 = inst_i[5:0];
	wire[4:0] op4 = inst_i[20:16];

	//immediate number
	reg[`RegBus] imm;

	//whether the instruction is valid or not
	reg instvalid;

	//decode the instruction
	always@(*) begin
		if(rst == `RstEnable) begin
			instvalid <= `InstValid;
			aluop_o <= `EXE_NOP_OP;
			alusel_o <= `EXE_RES_NOP;
			reg1_read_o <= `ReadDisable;
			reg2_read_o <= `ReadDisable;
			reg1_addr_o <= `NOPRegAddr;
			reg2_addr_o <= `NOPRegAddr;
			wd_o <= `NOPRegAddr;
			wreg_o <= `WriteDisable;
			imm <= `ZeroWord; 
		end
		else begin
			//initial the output
			instvalid = `InstValid;
			aluop_o <= `EXE_NOP_OP;
			alusel_o <= `EXE_RES_NOP;
			reg1_read_o <= `ReadDisable;
			reg2_read_o <= `ReadDisable;
			reg1_addr_o <= inst_i[25:21];
			reg2_addr_o <= inst_i[20:16];
			wd_o <= inst_i[15:11];
			wreg_o <= `WriteDisable;
			imm <= `ZeroWord;

			//assign the output according to the instruction
			case(op)
				`EXE_ORI: begin
					instvalid <= `InstValid;
					aluop_o <= `EXE_OR_OP;
					alusel_o <= `EXE_RES_LOGIC;
					reg1_read_o <= `ReadEnable;
					reg2_read_o <= `ReadDisable;
					wd_o <= inst_i[20:16];
					wreg_o <= `WriteEnable;
					imm <= {16'h0, inst_i[15:0]};
				end
				default:begin
				end
			endcase
		end
	end

	//set the reg1
	always@(*) begin
		if(rst == `RstEnable) begin
			reg1_o <= `ZeroWord;
		end
		else if(reg1_read_o == `ReadEnable) begin
			reg1_o <= reg1_data_i;
		end
		else if(reg1_read_o <= `ReadDisable) begin
			reg1_o <= imm;
		end
		else begin 
			reg1_o <= `ZeroWord;
		end
	end

	//set the reg2
	always@(*) begin
		if(rst == `RstEnable) begin
			reg2_o <= `ZeroWord;
		end
		else if(reg2_read_o == `ReadEnable) begin
			reg2_o <= reg2_data_i;
		end // else if(reg2_read_o == `ReadEnable)
		else if(reg2_read_o == `ReadDisable) begin
			reg2_o <= imm;
		end
		else begin
			reg2_o <= `ZeroWord;
		end
	end
endmodule
