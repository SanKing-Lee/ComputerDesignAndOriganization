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
	output reg[`RegBus] lo_o,
	//stall request to ctrl
	output reg stallreq,

	//for madd, maddu, msub, msubu instructions
	input wire[`DoubleRegBus] hilo_temp_i,
	//count the clock
	input wire[1:0] cnt_i,
	output reg[`DoubleRegBus] hilo_temp_o,
	output reg[1:0] cnt_o,

	//division
	output reg signed_div_o,
	output reg[`RegBus] div_opdata1_o,
	output reg[`RegBus] div_opdata2_o,
	output reg div_start_o,
	input wire[`DoubleRegBus] div_result_i,
	input wire div_ready_i
    );
	//logical output
	reg[`RegBus] logicout;
	//shift result
	reg[`RegBus] shiftres;
	//move result
	reg[`RegBus] moveres;
	//arithmetic result
	reg[`RegBus] arithmeticres;
	//hi reg
	reg[`RegBus] HI;
	//lo reg
	reg[`RegBus] LO;

	//overflow
	wire ov_sum;
	//equal
	wire reg1_eq_reg2;
	//less than
	wire reg1_lt_reg2;
	//complement
	wire[`RegBus] reg2_i_mux;
	//not
	wire[`RegBus] reg1_i_not;
	//add result
	wire[`RegBus] result_sum;
	//multiply
	wire[`RegBus] opdata1_mult;
	wire[`RegBus] opdata2_mult;
	//multiply result temp
	wire[`DoubleRegBus] hilo_temp;
	reg[`DoubleRegBus] mulres;
	reg[`DoubleRegBus] hilo_temp1;
	//stall request
	reg stallreq_for_madd_msub;
	reg stallreq_for_div;

	assign reg2_i_mux =    ((aluop_i == `EXE_SUB_OP) 	||
							(aluop_i == `EXE_SUBU_OP) 	||
							(aluop_i == `EXE_SLT_OP))	?
							(~reg2_i)+1 : reg2_i;

	assign result_sum = reg1_i + reg2_i_mux;

	assign ov_sum = ((!reg1_i[31]&&!reg2_i_mux[31]) && result_sum[31]) ||
					((reg1_i[31] && reg2_i_mux[31]) && (!result_sum[31]));

	assign reg1_lt_reg2 =	((aluop_i == `EXE_SLT_OP))?
							($signed(reg1_i) < $signed(reg2_i)):
							(reg1_i < reg2_i);	

	assign reg1_i_not = ~reg1_i;

	//set arithmeticres 
	always@(*) begin
		if(rst == `RstEnable) begin
			arithmeticres <= `ZeroWord;
		end // if(rst == `RstEnable)
		else begin
			case(aluop_i) 
				`EXE_SLT_OP, `EXE_SLTI_OP, `EXE_SLTU_OP: begin
					arithmeticres <= reg1_lt_reg2;
				end
				`EXE_ADD_OP, `EXE_ADDU_OP, `EXE_ADDI_OP, `EXE_ADDIU_OP: begin
					arithmeticres <= result_sum;
				end
				`EXE_SUB_OP, `EXE_SUBU_OP: begin
					arithmeticres <= result_sum;
				end
				`EXE_CLZ_OP: begin
					arithmeticres <= reg1_i[31] ? 0 : 
									 reg1_i[30] ? 1 :
									 reg1_i[29] ? 2 :
									 reg1_i[28] ? 3 :
									 reg1_i[27] ? 4 :
									 reg1_i[26] ? 5 :
									 reg1_i[25] ? 6 :
									 reg1_i[24] ? 7 :
									 reg1_i[23] ? 8 :
									 reg1_i[22] ? 9 :
									 reg1_i[21] ? 10 :
									 reg1_i[20] ? 11 :
									 reg1_i[19] ? 12 :
									 reg1_i[18] ? 13 :
									 reg1_i[17] ? 14 :
									 reg1_i[16] ? 15 :
									 reg1_i[15] ? 16 :
									 reg1_i[14] ? 17 :
									 reg1_i[13] ? 18 :
									 reg1_i[12] ? 19 :
									 reg1_i[11] ? 20 :
									 reg1_i[10] ? 21 :
									 reg1_i[9] ? 22 :
									 reg1_i[8] ? 23 :
									 reg1_i[7] ? 24 :
									 reg1_i[6] ? 25 :
									 reg1_i[5] ? 26 :
									 reg1_i[4] ? 27 :
									 reg1_i[3] ? 28 :
									 reg1_i[2] ? 29 :
									 reg1_i[1] ? 30 :
									 reg1_i[0] ? 31 : 32;
				end
				`EXE_CLO_OP: begin
					arithmeticres <= reg1_i_not[31] ? 0 : 
									 reg1_i_not[30] ? 1 :
									 reg1_i_not[29] ? 2 :
									 reg1_i_not[28] ? 3 :
									 reg1_i_not[27] ? 4 :
									 reg1_i_not[26] ? 5 :
									 reg1_i_not[25] ? 6 :
									 reg1_i_not[24] ? 7 :
									 reg1_i_not[23] ? 8 :
									 reg1_i_not[22] ? 9 :
									 reg1_i_not[21] ? 10 :
									 reg1_i_not[20] ? 11 :
									 reg1_i_not[19] ? 12 :
									 reg1_i_not[18] ? 13 :
									 reg1_i_not[17] ? 14 :
									 reg1_i_not[16] ? 15 :
									 reg1_i_not[15] ? 16 :
									 reg1_i_not[14] ? 17 :
									 reg1_i_not[13] ? 18 :
									 reg1_i_not[12] ? 19 :
									 reg1_i_not[11] ? 20 :
									 reg1_i_not[10] ? 21 :
									 reg1_i_not[9] ? 22 :
									 reg1_i_not[8] ? 23 :
									 reg1_i_not[7] ? 24 :
									 reg1_i_not[6] ? 25 :
									 reg1_i_not[5] ? 26 :
									 reg1_i_not[4] ? 27 :
									 reg1_i_not[3] ? 28 :
									 reg1_i_not[2] ? 29 :
									 reg1_i_not[1] ? 30 :
									 reg1_i_not[0] ? 31 : 32;
				end
				default: begin
					arithmeticres <= `ZeroWord;
				end // default:
			endcase // aluop_i
		end // else
	end // always@(*)

	//multiply
	assign opdata1_mult = (((aluop_i == `EXE_MUL_OP) || (aluop_i == `EXE_MULT_OP)
						  	||(aluop_i == `EXE_MADD_OP) || (aluop_i == `EXE_MSUB_OP)) 
						&& (reg1_i[31]==1'b1)) ?(~reg1_i + 1): reg1_i;

	assign opdata2_mult = (((aluop_i == `EXE_MUL_OP) || (aluop_i == `EXE_MULT_OP)
							||(aluop_i == `EXE_MADD_OP)||(aluop_i == `EXE_MSUB_OP)) 
						&& (reg2_i[31]==1'b1)) ?(~reg2_i + 1): reg2_i;
	assign hilo_temp = opdata1_mult*opdata2_mult;

	always@(*) begin
		if(rst == `RstEnable) begin
			mulres <= {`ZeroWord, `ZeroWord};
		end // if(rst == `RstEnable)
		else if((aluop_i == `EXE_MULT_OP) 
				|| (aluop_i == `EXE_MUL_OP)
				|| (aluop_i == `EXE_MADD_OP)
				|| (aluop_i == `EXE_MSUB_OP)) begin
			if(reg1_i[31] ^ reg2_i[31] == 1'b1) begin
				mulres <= ~hilo_temp + 1;
			end
			else begin
				mulres <= hilo_temp;
			end // else
		end // else if((aluop_i == `EXE_MULT_OP) || aluop_i == `EXE_MUL_OP)
		else begin
			mulres <= hilo_temp;
		end // else
	end // always@(*)

	//madd, maddu, msub, msubu instructions execution
	always@(*) begin
		if(rst == `RstEnable) begin
			hilo_temp_o <= {`ZeroWord, `ZeroWord};
			cnt_o <= 2'b00;
			stallreq_for_madd_msub <= `NoStop;
		end // if(rst == `RstEnable)
		else begin
			case(aluop_i)
				`EXE_MADD_OP, `EXE_MADDU_OP: begin
					if(cnt_i == 2'b00) begin
						hilo_temp_o <= mulres;
						cnt_o <= 2'b01;
						hilo_temp1 <= {`ZeroWord, `ZeroWord};
						stallreq_for_madd_msub <= `Stop;
					end // if(cnt_i == 2'b00)
					else if(cnt_i == 2'b01) begin
						hilo_temp_o <= {`ZeroWord, `ZeroWord};
						cnt_o <= 2'b10;
						hilo_temp1 <= hilo_temp_i + {HI, LO};
						stallreq_for_madd_msub <= `NoStop;
					end // else if(cnt_i == 2'b01)
				end
				`EXE_MSUB_OP, `EXE_MSUBU_OP: begin
					if(cnt_i == 2'b00) begin
						hilo_temp_o <= ~mulres+1;
						cnt_o <= 2'b1;
						stallreq_for_madd_msub <= `Stop;
					end // if(cnt_i == 2'b00)
					else if(cnt_i == 2'b01) begin
						hilo_temp_o <= {`ZeroWord, `ZeroWord};
						cnt_o <= 2'b10;
						hilo_temp1 <= hilo_temp_i + {HI, LO};
						stallreq_for_madd_msub <= `NoStop;
					end // else if(cnt_i == 2'b01)
				end 
				default: begin
				end // default:
			endcase // aluop_i
		end // else
	end // always@(*)

	//division
	always@(*) begin
		if(rst == `RstEnable) begin
			stallreq_for_div <= `NoStop;
			div_opdata1_o <= `ZeroWord;
			div_opdata2_o <= `ZeroWord;
			div_start_o <= `DivStop;
			signed_div_o <= 1'b0;
		end // if(rst == `RstEnable)
		else begin
			//default configuration
			stallreq_for_div <= `NoStop;
			div_opdata1_o <= `ZeroWord;
			div_opdata2_o <= `ZeroWord;
			div_start_o <= `DivStop;
			signed_div_o <= 1'b0;
			case(aluop_i) 
				`EXE_DIV_OP: begin
					//start division
					if(div_ready_i == `DivResultNotReady) begin
						div_opdata1_o <= reg1_i;
						div_opdata2_o <= reg2_i;
						div_start_o <= `DivStart;
						signed_div_o <= 1'b1;
						stallreq_for_div <= `Stop;
					end // if(div_ready_i == `DivResultNotReady)
					//finished division
					else if(div_ready_i == `DivResultReady) begin
						div_opdata1_o <= reg1_i;
						div_opdata2_o <= reg2_i;
						div_start_o <= `DivStop;
						signed_div_o <= 1'b1;
						stallreq_for_div <= `NoStop;
					end // else if(div_ready_i == `DivResultReady)
					//default
					else begin
						stallreq_for_div <= `NoStop;
						div_opdata1_o <= `ZeroWord;
						div_opdata2_o <= `ZeroWord;
						div_start_o <= `DivStop;
						signed_div_o <= 1'b0;
					end // else
				end // default:
				`EXE_DIVU_OP: begin
					//start division
					if(div_ready_i == `DivResultNotReady) begin
						div_opdata1_o <= reg1_i;
						div_opdata2_o <= reg2_i;
						div_start_o <= `DivStart;
						signed_div_o <= 1'b0;
						stallreq_for_div <= `Stop;
					end // if(div_ready_i == `DivResultNotReady)
					//finished division
					else if(div_ready_i == `DivResultReady) begin
						div_opdata1_o <= reg1_i;
						div_opdata2_o <= reg2_i;
						div_start_o <= `DivStop;
						signed_div_o <= 1'b0;
						stallreq_for_div <= `NoStop;
					end // else if(div_ready_i == `DivResultReady)
					//default
					else begin
						stallreq_for_div <= `NoStop;
						div_opdata1_o <= `ZeroWord;
						div_opdata2_o <= `ZeroWord;
						div_start_o <= `DivStop;
						signed_div_o <= 1'b0;
					end // else
				end
				default: begin
				end // default:
			endcase // aluop_i
		end
	end // always@(*)

	//set stallreq
	always@(*) begin
		stallreq = stallreq_for_madd_msub || stallreq_for_div;
	end // always@(*)

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
				default: begin
					moveres <= `ZeroWord;
				end // default:
			endcase // aluop_i
		end
	end

	//select the output
	always@(*) begin
		wd_o <= wd_i;
		//overflow
		if(((aluop_i == `EXE_ADD_OP) || (aluop_i == `EXE_ADDI_OP) || 
			(aluop_i == `EXE_SUB_OP))&&(ov_sum == 1'b1)) begin
			wreg_o <= `WriteDisable;
		end // else
		else begin
			wreg_o <= wreg_i;
		end
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
			`EXE_RES_ARITHMETIC: begin
				wdata_o <= arithmeticres;
			end
			`EXE_RES_MUL: begin
				wdata_o <= mulres[31:0];
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
		//madd, msub
		else if((aluop_i == `EXE_MSUB_OP)||(aluop_i == `EXE_MSUBU_OP)) begin
			whilo_o <= `WriteEnable;
			hi_o <= hilo_temp1[63:32];
			lo_o <= hilo_temp1[31:0];
		end // else if((aluop_i == `EXE_MSUB_OP)||(aluop_i == `EXE_MSUBU_OP))
		else if((aluop_i == `EXE_MADD_OP)||(aluop_i == `EXE_MADDU_OP)) begin
			whilo_o <= `WriteEnable;
			hi_o <= hilo_temp1[63:32];
			lo_o <= hilo_temp1[31:0];
		end // else if((aluop_i == `EXE_MADD_OP)||(aluop_i == `EXE_MADDU_OP))
		else if((aluop_i == `EXE_MULT_OP) || (aluop_i == `EXE_MULTU_OP)) begin
			whilo_o <= `WriteEnable;
			hi_o <= mulres[63:32];
			lo_o <= mulres[31:0];
		end // else if((aluop_i == `EXE_MULT_OP) || (aluop_i == `EXE_MULTU_OP))
		else if((aluop_i == `EXE_DIV_OP) || (aluop_i == `EXE_DIVU_OP)) begin
			whilo_o <= `WriteEnable;
			hi_o <= div_result_i[63:32];
			lo_o <= div_result_i[31:0];
		end // else if((aluop_i == `EXE_DIV_OP) || (aluop_i == `EXE_DIVU_OP))
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
