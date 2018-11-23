`timescale 1ns / 1ps
`include "define.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/10/15 17:34:18
// Design Name: 
// Module Name: ex
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


module ex(
	//rst
	input wire rst,
	input wire[`AluOpBus] aluop_i,
	input wire[`AluSelBus] alusel_i,
	input wire[`RegBus] reg1_i, reg2_i,
	input wire[`RegAddrBus] wd_i,
	input wire wreg_i,

	output reg wreg_o,
	output reg[`RegAddrBus] wd_o,
	output reg[`RegBus] wdata_o,
	
	//hilo_reg
	input wire[`RegBus] hi_i,
	input wire[`RegBus] lo_i,
	//mem to hilo_reg
	input wire mem_whilo_i,
	input wire[`RegBus] mem_hi_i,
	input wire[`RegBus] mem_lo_i,
	//wb to hilo_reg
	input wire wb_whilo_i,
	input wire[`RegBus] wb_hi_i,
	input wire[`RegBus] wb_lo_i,

	//output hilo_reg
	output reg whilo_o,
	output reg[`RegBus] hi_o,
	output reg[`RegBus] lo_o
    );
	//logical output
	reg[`RegBus] logicout;
	//shift result
	reg[`RegBus] shiftres;
	//move result
	reg[`RegBus] moveres;
	//hi reg
	reg[`RegBus] HI;
	//lo reg
	reg[`RegBus] LO;

	//set logicout according ot the operation code
	always@(*) begin
		if(rst == `RstEnable) begin
			logicout <= `ZeroWord;
		end // if(rst == `RstEnable)
		else begin
			case(aluop_i) 
				`EXE_OR_OP: begin
					logicout <= reg1_i | reg2_i;
				end
				`EXE_AND_OP: begin
					logicout <= reg1_i & reg2_i;
				end
				`EXE_XOR_OP: begin
					logicout <= reg1_i ^ reg2_i;
				end
				`EXE_NOR_OP: begin
					logicout <= ~(reg1_i | reg2_i);
				end
				default: begin
					logicout <= `ZeroWord;
				end
			endcase // aluop_i
		end
	end

	//shift instructions
	always@(*) begin
		if(rst == `RstEnable) begin
			shiftres <= `ZeroWord;
		end
		else begin
			case(aluop_i)
				`EXE_SLL_OP: begin
					shiftres <= reg2_i << reg1_i[4:0];
				end 
				`EXE_SRL_OP: begin
					shiftres <= reg2_i >> reg1_i[4:0];
				end
				`EXE_SRA_OP: begin
					shiftres <= ({32{reg2_i[31]}}<<(6'd32-{1'b0, reg1_i[4:0]})) | (reg2_i >> reg1_i[4:0]);
				end
				default: begin
					shiftres <= `ZeroWord;
				end // default:
			endcase // aluop_i
		end // else
	end // always(@*)

	//hilo_reg
	always@(*) begin
		if(rst == `RstEnable) begin
			{HI, LO} <= `ZeroWord;
		end // if(rst == `RstEnable)
		//mem to hilo_reg
		else if(mem_whilo_i == `WriteEnable) begin
			HI <= mem_hi_i;
			LO <= mem_lo_i;
		end // else if(mem_whilo_i == `WriteEnable)
		//wb to hilo_reg
		else if(wb_whilo_i == `WriteEnable) begin
			HI <= wb_hi_i;
			LO <= wb_lo_i;
		end
		else begin
			HI <= hi_i;
			LO <= lo_i;
		end // else
	end

	//movz, movn, mfhi, mflo 
	always@(*) begin
		if(rst == `RstEnable) begin
			moveres <= `ZeroWord;
		end
		else begin
			case(aluop_i)
				`EXE_MOVZ_OP: begin
					moveres <= reg1_i;
				end
				`EXE_MOVN_OP: begin
					moveres <= reg1_i;
				end
				`EXE_MFHI_OP: begin
					moveres <= HI;
				end
				`EXE_MFLO_OP: begin
					moveres <= LO;
				end
			endcase // aluop_i
		end
	end

	//select the output
	always@(*) begin
		wd_o <= wd_i;
		wreg_o <= wreg_i;
		case(alusel_i) 
			`EXE_RES_LOGIC: begin
				wdata_o <= logicout;
			end
			`EXE_RES_SHIFT: begin
				wdata_o <= shiftres;
			end
			`EXE_RES_MOVE: begin
				wdata_o <= moveres;
			end
			default: begin
				wdata_o <= `ZeroWord;
			end // default:
		endcase // alusel_i
	end // always@(*)

	//mthi, mtlo
	always@(*) begin
		if(rst == `RstEnable) begin
			whilo_o <= `WriteDisable;
			hi_o <= `ZeroWord;
			lo_o <= `ZeroWord;
		end // if(rst == `RstEnable)
		else begin
			case(aluop_i)
				`EXE_MTHI_OP: begin
					whilo_o <= `WriteEnable;
					hi_o <= reg1_i;
					lo_o <= LO;
				end
				`EXE_MTLO_OP: begin
					whilo_o <= `WriteEnable;
					hi_o <= HI;
					lo_o <= reg1_i;
				end
				default: begin
					whilo_o <= `WriteDisable;
					hi_o <= `ZeroWord;
					lo_o <= `ZeroWord;
				end
			endcase // aluop_i
		end // else
	end
endmodule
