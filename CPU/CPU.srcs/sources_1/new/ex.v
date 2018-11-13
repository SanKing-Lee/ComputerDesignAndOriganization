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
	input wire	wreg_i,
	output reg wreg_o,
	output reg[`RegAddrBus] wd_o,
	output reg[`RegBus] wdata_o
    );
	//logical output
	reg[`RegBus] logicout;
	//shift result
	reg[`RegBus] shiftres;

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

	//choose the output
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
			default: begin
				wdata_o <= `ZeroWord;
			end // default:
		endcase // alusel_i
	end // always@(*)
endmodule
