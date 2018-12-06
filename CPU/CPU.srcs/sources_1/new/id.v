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

	//data forwarding for stage ex
	input wire ex_wreg_i,
	input wire[`RegAddrBus] ex_wd_i,
	input wire[`RegBus] ex_wdata_i,
	//data forwarding for stage mem
	input wire mem_wreg_i,
	input wire[`RegAddrBus] mem_wd_i,
	input wire[`RegBus] mem_wdata_i,

	output reg reg1_read_o, reg2_read_o,
	output reg[`RegAddrBus] reg1_addr_o, reg2_addr_o,
	//parts of instruction
	output reg[`AluOpBus] aluop_o,
	output reg[`AluSelBus] alusel_o,
	output reg[`RegBus] reg1_o, reg2_o,
	output reg[`RegAddrBus] wd_o,
	output reg wreg_o,
	//stall
	output reg stallreq,

	//branch
	//the present instruction is in delayslot or not
	input wire is_in_delayslot_i,
	//branch flag 
	output reg branch_flag_o,
	//branch address
	output reg[`InstAddrBus] branch_target_address_o,
	//the present instruction is in delayslot or not
	output reg is_in_delayslot_o,
	//the returned address to be saved
	output reg[`InstAddrBus] link_addr_o,
	//the next instruction is in delayslot or not
	output reg next_inst_in_delayslot_o
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

	//branch
	wire[`InstAddrBus] pc_plus_8;
	wire[`InstAddrBus] pc_plus_4;
	wire[`RegBus] imm_sll2_signedext;

	assign pc_plus_8 = pc_i + 8;
	assign pc_plus_4 = pc_i + 4;
	assign imm_sll2_signedext = {{14{inst_i[15]}},inst_i[15:0],2'b00};

	//decode the instruction
	always@(*) begin
		//reset
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
			stallreq <= 1'b0;
			link_addr_o <= `ZeroWord;
			branch_flag_o <= `NotBranch;
			branch_target_address_o <= `ZeroWord;
			next_inst_in_delayslot_o <= `NotInDelaySlot;
		end
		else begin
			//initial the output
			instvalid <= `InstValid;
			aluop_o <= `EXE_NOP_OP;
			alusel_o <= `EXE_RES_NOP;
			reg1_read_o <= `ReadDisable;
			reg2_read_o <= `ReadDisable;
			reg1_addr_o <= inst_i[25:21];
			reg2_addr_o <= inst_i[20:16];
			wd_o <= inst_i[15:11];
			wreg_o <= `WriteDisable;
			imm <= `ZeroWord;
			stallreq <= 1'b0;
			link_addr_o <= `ZeroWord;
			branch_flag_o <= `NotBranch;
			branch_target_address_o <= `ZeroWord;
			next_inst_in_delayslot_o <= `NotInDelaySlot;

			//assign the output according to the instruction
			case(op)
				//special instructions
				`EXE_SPECIAL_INST: begin 	
					case(op2)
						5'b00000: begin
							case(op3)
								//logical instructinos
								`EXE_AND: begin
									instvalid <= `InstValid;
									aluop_o <= `EXE_AND_OP;
									alusel_o <= `EXE_RES_LOGIC;
									reg1_read_o <= `ReadEnable;
									reg2_read_o <= `ReadEnable;
									wreg_o <= `WriteEnable;
								end 
								`EXE_OR: begin
									instvalid <= `InstValid;
									aluop_o <= `EXE_OR_OP;
									alusel_o <= `EXE_RES_LOGIC;
									reg1_read_o <= `ReadEnable;
									reg2_read_o <= `ReadEnable;
									wreg_o <= `WriteEnable;
								end
								`EXE_XOR: begin
									instvalid <= `InstValid;
									aluop_o <= `EXE_XOR_OP;
									alusel_o <= `EXE_RES_LOGIC;
									reg1_read_o <= `ReadEnable;
									reg2_read_o <= `ReadEnable;
									wreg_o <= `WriteEnable;
								end
								`EXE_NOR: begin
									instvalid <= `InstValid;
									aluop_o <= `EXE_NOR_OP;
									alusel_o <= `EXE_RES_LOGIC;
									reg1_read_o <= `ReadEnable;
									reg2_read_o <= `ReadEnable;
									wreg_o <= `WriteEnable;						
								end
								//shift instructions
								`EXE_SLLV: begin
									instvalid <= `InstValid;
									aluop_o <= `EXE_SLL_OP;
									alusel_o <= `EXE_RES_SHIFT;
									reg1_read_o <= `ReadEnable;
									reg2_read_o <= `ReadEnable;
									wreg_o <= `WriteEnable;						
								end	
								`EXE_SRLV: begin
									instvalid <= `InstValid;
									aluop_o <= `EXE_SRL_OP;
									alusel_o <= `EXE_RES_SHIFT;
									reg1_read_o <= `ReadEnable;
									reg2_read_o <= `ReadEnable;
									wreg_o <= `WriteEnable;						
								end	
								`EXE_SRAV: begin
									instvalid <= `InstValid;
									aluop_o <= `EXE_SRA_OP;
									alusel_o <= `EXE_RES_SHIFT;
									reg1_read_o <= `ReadEnable;
									reg2_read_o <= `ReadEnable;
									wreg_o <= `WriteEnable;						
								end	
								`EXE_SYNC: begin
									instvalid <= `InstValid;
									aluop_o <= `EXE_NOP_OP;
									alusel_o <= `EXE_RES_NOP;
									reg1_read_o <= `ReadDisable;
									reg2_read_o <= `ReadEnable;
									wreg_o <= `WriteEnable;						
								end	
								//move instructions
								`EXE_MOVZ: begin
									instvalid <= `InstValid;
									aluop_o <= `EXE_MOVZ_OP;
									alusel_o <= `EXE_RES_MOVE;
									reg1_read_o <= `ReadEnable;
									reg2_read_o <= `ReadEnable;
									if(reg2_o == `ZeroWord) begin
										wreg_o <= `WriteEnable;
									end
									else begin
										wreg_o <= `WriteDisable;
									end
								end
								`EXE_MOVN: begin
									instvalid <= `InstValid;
									aluop_o <= `EXE_MOVN_OP;
									alusel_o <= `EXE_RES_MOVE;
									reg1_read_o <= `ReadEnable;
									reg2_read_o <= `ReadEnable;
									if(reg2_o == `ZeroWord) begin
										wreg_o <= `WriteEnable;
									end
									else begin
										wreg_o <= `WriteDisable;
									end
								end
								`EXE_MFHI: begin
									instvalid <= `InstValid;
									aluop_o <= `EXE_MFHI_OP;
									alusel_o <= `EXE_RES_MOVE;
									reg1_read_o <= `ReadDisable;
									reg2_read_o <= `ReadDisable;
									wreg_o <= `WriteEnable;
								end
								`EXE_MFLO: begin
									instvalid <= `InstValid;
									aluop_o <= `EXE_MFLO_OP;
									alusel_o <= `EXE_RES_MOVE;
									reg1_read_o <= `ReadDisable;
									reg2_read_o <= `ReadDisable;
									wreg_o <= `WriteEnable;
								end
								`EXE_MTHI: begin
									instvalid <= `InstValid;
									aluop_o <= `EXE_MTHI_OP;
									alusel_o <= `EXE_RES_MOVE;
									reg1_read_o <= `ReadEnable;
									reg2_read_o <= `ReadDisable;
								end
								`EXE_MTLO: begin
									instvalid <= `InstValid;
									aluop_o <= `EXE_MTLO_OP;
									alusel_o <= `EXE_RES_MOVE;
									reg1_read_o <= `ReadEnable;
									reg2_read_o <= `ReadDisable;
								end
								//arithmetic instructions
								`EXE_ADD: begin
									instvalid <= `InstValid;
									aluop_o <= `EXE_ADD_OP;
									alusel_o <= `EXE_RES_ARITHMETIC;
									reg1_read_o <= `ReadEnable;
									reg2_read_o <= `ReadEnable;
									wreg_o <= `WriteEnable;
								end
								`EXE_ADDU: begin
									instvalid <= `InstValid;
									aluop_o <= `EXE_ADDU_OP;
									alusel_o <= `EXE_RES_ARITHMETIC;
									reg1_read_o <= `ReadEnable;
									reg2_read_o <= `ReadEnable;
									wreg_o <= `WriteEnable;
								end
								`EXE_SUB: begin
									instvalid <= `InstValid;
									aluop_o <= `EXE_SUB_OP;
									alusel_o <= `EXE_RES_ARITHMETIC;
									reg1_read_o <= `ReadEnable;
									reg2_read_o <= `ReadEnable;
									wreg_o <= `WriteEnable;
								end
								`EXE_SUBU: begin
									instvalid <= `InstValid;
									aluop_o <= `EXE_SUBU_OP;
									alusel_o <= `EXE_RES_ARITHMETIC;
									reg1_read_o <= `ReadEnable;
									reg2_read_o <= `ReadEnable;
									wreg_o <= `WriteEnable;
								end
								`EXE_SLT: begin
									instvalid <= `InstValid;
									aluop_o <= `EXE_SLT_OP;
									alusel_o <= `EXE_RES_ARITHMETIC;
									reg1_read_o <= `ReadEnable;
									reg2_read_o <= `ReadEnable;
									wreg_o <= `WriteEnable;
								end
								`EXE_SLTU: begin
									instvalid <= `InstValid;
									aluop_o <= `EXE_SLTU_OP;
									alusel_o <= `EXE_RES_ARITHMETIC;
									reg1_read_o <= `ReadEnable;
									reg2_read_o <= `ReadEnable;
									wreg_o <= `WriteEnable;
								end
								`EXE_MULT: begin
									instvalid <= `InstValid;
									aluop_o <= `EXE_MULT_OP;
									reg1_read_o <= `ReadEnable;
									reg2_read_o <= `ReadEnable;
									wreg_o <= `WriteEnable;
								end
								`EXE_MULTU: begin
									instvalid <= `InstValid;
									aluop_o <= `EXE_MULTU_OP;
									reg1_read_o <= `ReadEnable;
									reg2_read_o <= `ReadEnable;
									wreg_o <= `WriteEnable;
								end
								//division
								`EXE_DIV: begin
									instvalid <= `InstValid;
									aluop_o <= `EXE_DIV_OP;
									reg1_read_o <= `ReadEnable;
									reg2_read_o <= `ReadEnable;
									wreg_o <= `WriteDisable;
								end
								`EXE_DIVU: begin
									instvalid <= `InstValid;
									aluop_o <= `EXE_DIVU_OP;
									reg1_read_o <= `ReadEnable;
									reg2_read_o <= `ReadEnable;
									wreg_o <= `WriteDisable;
								end
								//branch instrutions
								`EXE_JR: begin
									instvalid <= `InstValid;
									aluop_o <= `EXE_JR_OP;
									alusel_o <= `EXE_RES_JUMP_BRANCH;
									reg1_read_o <= `ReadEnable;
									reg2_read_o <= `ReadDisable;
									wreg_o <= `WriteDisable;
									link_addr_o <= `ZeroWord;
									branch_target_address_o <= reg1_o;
									branch_flag_o <= `Branch;
									next_inst_in_delayslot_o <= `InDelaySlot;
								end
								`EXE_JALR: begin
									instvalid <= `InstValid;
									aluop_o <= `EXE_JALR_OP;
									alusel_o <= `EXE_RES_JUMP_BRANCH;
									reg1_read_o <= `ReadEnable;
									reg2_read_o <= `ReadDisable;
									wreg_o <= `WriteEnable;
									wd_o <= inst_i[15:11];
									link_addr_o <= pc_plus_8;
									branch_target_address_o <= reg1_o;
									branch_flag_o <= `Branch;
									next_inst_in_delayslot_o <= `InDelaySlot;
								end
								default: begin
								end // default:
							endcase // op3
						end
						default: begin
						end // default:
					endcase
				end
				`EXE_ORI: begin
					instvalid <= `InstValid;
					aluop_o <= `EXE_OR_OP;
					alusel_o <= `EXE_RES_LOGIC;
					reg1_read_o <= `ReadEnable;
					reg2_read_o <= `ReadDisable;
					wd_o <= inst_i[20:16];
					wreg_o <= `WriteEnable;
					//unsigned extension
					imm <= {16'h0, inst_i[15:0]};
				end
				`EXE_ANDI: begin
					instvalid <= `InstValid;
					aluop_o <= `EXE_AND_OP;
					alusel_o <= `EXE_RES_LOGIC;
					reg1_read_o <= `ReadEnable;
					reg2_read_o <= `ReadDisable;
					wd_o <= inst_i[20:16];
					wreg_o <= `WriteEnable;
					//unsigned extension
					imm <= {16'h0, inst_i[15:0]};
				end
				`EXE_XORI: begin
					instvalid <= `InstValid;
					aluop_o <= `EXE_XOR_OP;
					alusel_o <= `EXE_RES_LOGIC;
					reg1_read_o <= `ReadEnable;
					reg2_read_o <= `ReadDisable;
					wd_o <= inst_i[20:16];
					wreg_o <= `WriteEnable;
					//unsigned extension
					imm <= {16'h0, inst_i[15:0]};
				end
				`EXE_LUI: begin
					instvalid <= `InstValid;
					aluop_o <= `EXE_OR_OP;
					alusel_o <= `EXE_RES_LOGIC;
					reg1_read_o <= `ReadEnable;
					reg2_read_o <= `ReadDisable;
					wd_o <= inst_i[20:16];
					wreg_o <= `WriteEnable;
					//unsigned extension
					imm <= {inst_i[15:0], 16'h0};
				end
				`EXE_PREF: begin
					instvalid <= `InstValid;
					aluop_o <= `EXE_NOP_OP;
					alusel_o <= `EXE_RES_NOP;
					reg1_read_o <= `ReadDisable;
					reg2_read_o <= `ReadDisable;
				end
				//airthmetic instructions
				`EXE_SLTI: begin
					instvalid <= `InstValid;
					aluop_o <= `EXE_SLTI_OP;
					alusel_o <= `EXE_RES_ARITHMETIC;
					reg1_read_o <= `ReadEnable;
					reg2_read_o <= `ReadDisable;
					wd_o <= inst_i[20:16];
					wreg_o <= `WriteEnable;
					imm <= {{16{inst_i[15]}}, inst_i[15:0]};
				end
				`EXE_SLTIU: begin
					instvalid <= `InstValid;
					aluop_o <= `EXE_SLTIU_OP;
					alusel_o <= `EXE_RES_ARITHMETIC;
					reg1_read_o <= `ReadEnable;
					reg2_read_o <= `ReadDisable;
					wd_o <= inst_i[20:16];
					wreg_o <= `WriteEnable;
					imm <= {{16{inst_i[15]}}, inst_i[15:0]};
				end
				`EXE_ADDI: begin
					instvalid <= `InstValid;
					aluop_o <= `EXE_ADDI_OP;
					alusel_o <= `EXE_RES_ARITHMETIC;
					reg1_read_o <= `ReadEnable;
					reg2_read_o <= `ReadDisable;
					wd_o <= inst_i[20:16];
					wreg_o <= `WriteEnable;
					imm <= {{16{inst_i[15]}}, inst_i[15:0]};
				end
				`EXE_ADDIU: begin
					instvalid <= `InstValid;
					aluop_o <= `EXE_ADDIU_OP;
					alusel_o <= `EXE_RES_ARITHMETIC;
					reg1_read_o <= `ReadEnable;
					reg2_read_o <= `ReadDisable;
					wd_o <= inst_i[20:16];
					wreg_o <= `WriteEnable;
					imm <= {{16{inst_i[15]}}, inst_i[15:0]};
				end
				//jump instrutions
				`EXE_J: begin
					instvalid <= `InstValid;
					aluop_o <= `EXE_J_OP;
					alusel_o <= `EXE_RES_JUMP_BRANCH;
					reg1_read_o <= `ReadDisable;
					reg2_read_o <= `ReadDisable;
					wreg_o <= `WriteDisable;
					link_addr_o <= `ZeroWord;
					branch_flag_o <= `Branch;
					next_inst_in_delayslot_o <= `InDelaySlot;
					branch_target_address_o <= {pc_plus_4[31:28], inst_i[25:0], 2'b00};
				end
				`EXE_JAL: begin
					instvalid <= `InstValid;
					aluop_o <= `EXE_JAL_OP;
					alusel_o <= `EXE_RES_JUMP_BRANCH;
					reg1_read_o <= `ReadDisable;
					reg2_read_o <= `ReadDisable;
					wreg_o <= `WriteEnable;
					wd_o <= 5'b11111;
					link_addr_o <= pc_plus_8;
					branch_flag_o <= `Branch;
					next_inst_in_delayslot_o <= `InDelaySlot;
					branch_target_address_o <= {pc_plus_4[31:28], inst_i[25:0], 2'b00};
				end
				`EXE_BEQ: begin
					instvalid <= `InstValid;
					aluop_o <= `EXE_BEQ_OP;
					alusel_o <= `EXE_RES_JUMP_BRANCH;
					reg1_read_o <= `ReadEnable;
					reg2_read_o <= `ReadEnable;
					wreg_o <= `WriteDisable;
					link_addr_o <= `ZeroWord;
					//branch equal
					if(reg1_o == reg2_o) begin
						branch_flag_o <= `Branch;
						next_inst_in_delayslot_o <= `InDelaySlot;
						branch_target_address_o <= pc_plus_4 + imm_sll2_signedext;
					end // if(reg1_o == reg2_o)
				end
				`EXE_BGTZ: begin
					instvalid <= `InstValid;
					aluop_o <= `EXE_BGTZ_OP;
					alusel_o <= `EXE_RES_JUMP_BRANCH;
					reg1_read_o <= `ReadEnable;
					reg2_read_o <= `ReadDisable;
					wreg_o <= `WriteDisable;
					link_addr_o <= `ZeroWord;
					if((reg1_o[31] == 1'b0) && (reg1_o != `ZeroWord)) begin
						branch_flag_o <= `Branch;
						next_inst_in_delayslot_o <= `InDelaySlot;
						branch_target_address_o <= pc_plus_4 + imm_sll2_signedext;
					end
				end
				`EXE_BLEZ: begin
					instvalid <= `InstValid;
					aluop_o <= `EXE_BLEZ_OP;
					alusel_o <= `EXE_RES_JUMP_BRANCH;
					reg1_read_o <= `ReadEnable;
					reg2_read_o <= `ReadDisable;
					wreg_o <= `WriteDisable;
					link_addr_o <= `ZeroWord;
					//branch when reg1 is negative or zero
					if((reg1_o[31] == 1'b1) || (reg1_o == `ZeroWord)) begin
						branch_flag_o <= `Branch;
						next_inst_in_delayslot_o <= `InDelaySlot;
						branch_target_address_o <= pc_plus_4 + imm_sll2_signedext;
					end
				end
				`EXE_BNE: begin
					instvalid <= `InstValid;
					aluop_o <= `EXE_BNE_OP;
					alusel_o <= `EXE_RES_JUMP_BRANCH;
					reg1_read_o <= `ReadEnable;
					reg2_read_o <= `ReadEnable;
					wreg_o <= `WriteDisable;
					link_addr_o <= `ZeroWord;
					if(reg1_o != reg2_o) begin
						branch_flag_o <= `Branch;
						next_inst_in_delayslot_o <= `InDelaySlot;
						branch_target_address_o <= pc_plus_4 + imm_sll2_signedext;
					end
				end
				`EXE_REGIMM_INST: begin
					case(op4) 
						`EXE_BGEZ: begin
							instvalid <= `InstValid;
							aluop_o <= `EXE_BGEZ_OP;
							alusel_o <= `EXE_RES_JUMP_BRANCH;
							reg1_read_o <= `ReadEnable;
							reg2_read_o <= `ReadDisable;
							wreg_o <= `WriteDisable;
							if(reg1_o[31] == 1'b0) begin
								branch_flag_o <= `Branch;
								next_inst_in_delayslot_o <= `InDelaySlot;
								branch_target_address_o <= pc_plus_4 + imm_sll2_signedext;
							end // if(reg1_o[31] == 1'b0)
						end 
						`EXE_BGEZAL: begin
							instvalid <= `InstValid;
							aluop_o <= `EXE_BGEZAL_OP;
							alusel_o <= `EXE_RES_JUMP_BRANCH;
							reg1_read_o <= `ReadEnable;
							reg2_read_o <= `ReadDisable;
							wreg_o <= `WriteEnable;
							wd_o <= 5'b11111;
							link_addr_o <= pc_plus_8;
							if(reg1_o[31] == 1'b0) begin
								branch_flag_o <= `Branch;
								next_inst_in_delayslot_o <= `InDelaySlot;
								branch_target_address_o <= pc_plus_4 + imm_sll2_signedext;
							end // if(reg1_o[31] == 1'b0)
						end 
						`EXE_BLTZ: begin
							instvalid <= `InstValid;
							aluop_o <= `EXE_BLTZ_OP;
							alusel_o <= `EXE_RES_JUMP_BRANCH;
							reg1_read_o <= `ReadEnable;
							reg2_read_o <= `ReadDisable;
							wreg_o <= `WriteDisable;
							if(reg1_o[31] == 1'b1) begin
								branch_flag_o <= `Branch;
								next_inst_in_delayslot_o <= `InDelaySlot;
								branch_target_address_o <= pc_plus_4 + imm_sll2_signedext;
							end // if(reg1_o[31] == 1'b0)
						end
						`EXE_BLTZAL: begin
							instvalid <= `InstValid;
							aluop_o <= `EXE_BLTZAL_OP;
							alusel_o <= `EXE_RES_JUMP_BRANCH;
							reg1_read_o <= `ReadEnable;
							reg2_read_o <= `ReadDisable;
							wreg_o <= `WriteEnable;
							wd_o <= 5'b11111;
							link_addr_o <= pc_plus_8;
							if(reg1_o[31] == 1'b1) begin
								branch_flag_o <= `Branch;
								next_inst_in_delayslot_o <= `InDelaySlot;
								branch_target_address_o <= pc_plus_4 + imm_sll2_signedext;
							end // if(reg1_o[31] == 1'b0)
						end 
						default: begin
						end // default:
					endcase // op4
				end
				`EXE_SPECIAL2_INST: begin
					case(op3)
						`EXE_CLZ: begin
							instvalid <= `InstValid;
							aluop_o <= `EXE_CLZ_OP;
							alusel_o <= `EXE_RES_ARITHMETIC;
							reg1_read_o <= `ReadEnable;
							reg2_read_o <= `ReadDisable;
							wreg_o <= `WriteEnable;
						end
						`EXE_CLO: begin
							instvalid <= `InstValid;
							aluop_o <= `EXE_CLO_OP;
							alusel_o <= `EXE_RES_ARITHMETIC;
							reg1_read_o <= `ReadEnable;
							reg2_read_o <= `ReadDisable;
							wreg_o <= `WriteEnable;
						end
						`EXE_MUL: begin
							instvalid <= `InstValid;
							aluop_o <= `EXE_MUL_OP;
							alusel_o <= `EXE_RES_MUL;
							reg1_read_o <= `ReadEnable;
							reg2_read_o <= `ReadEnable;
							wreg_o <= `WriteEnable;
						end
						`EXE_MADD: begin
							instvalid <= `InstValid;
							aluop_o <= `EXE_MADD_OP;
							alusel_o <= `EXE_RES_MUL;
							reg1_read_o <= `ReadEnable;
							reg2_read_o <= `ReadEnable;
							wreg_o <= `WriteDisable;
						end 
						`EXE_MADDU: begin
							instvalid <= `InstValid;
							aluop_o <= `EXE_MADDU_OP;
							alusel_o <= `EXE_RES_MUL;
							reg1_read_o <= `ReadEnable;
							reg2_read_o <= `ReadEnable;
							wreg_o <= `WriteDisable;
						end 
						`EXE_MSUB: begin
							instvalid <= `InstValid;
							aluop_o <= `EXE_MSUB_OP;
							alusel_o <= `EXE_RES_MUL;
							reg1_read_o <= `ReadEnable;
							reg2_read_o <= `ReadEnable;
							wreg_o <= `WriteDisable;
						end 
						`EXE_MSUBU: begin
							instvalid <= `InstValid;
							aluop_o <= `EXE_MSUBU_OP;
							alusel_o <= `EXE_RES_MUL;
							reg1_read_o <= `ReadEnable;
							reg2_read_o <= `ReadEnable;
							wreg_o <= `WriteDisable;
						end
						`EXE_MADDU: begin
							instvalid <= `InstValid;
							aluop_o <= `EXE_MADDU_OP;
							alusel_o <= `EXE_RES_MUL;
							reg1_read_o <= `ReadEnable;
							reg2_read_o <= `ReadEnable;
							wreg_o <= `WriteDisable;
						end
						default: begin
						end // default:  
					endcase // op3
				end
				default:begin
				end
			endcase
			if(inst_i[31:21] == 11'b0) begin
				//instruction sll
				if(op3 == `EXE_SLL) begin
					instvalid <= `InstValid;
					aluop_o <= `EXE_SLL_OP;
					alusel_o <= `EXE_RES_SHIFT;
					reg1_read_o <= `ReadDisable;
					reg2_read_o <= `ReadEnable;
					wd_o <= inst_i[15:11];
					wreg_o <= `WriteEnable;
					imm <= inst_i[10:6];
				end
				//instruction srl
				else if(op3 == `EXE_SRL) begin
					instvalid <= `InstValid;
					aluop_o <= `EXE_SRL_OP;
					alusel_o <= `EXE_RES_SHIFT;
					reg1_read_o <= `ReadDisable;
					reg2_read_o <= `ReadEnable;
					wd_o <= inst_i[15:11];
					wreg_o <= `WriteEnable;
					imm <= inst_i[10:6];
				end
				//instruction sra
				else if(op3 == `EXE_SRA) begin
					instvalid <= `InstValid;
					aluop_o <= `EXE_SRA_OP;
					alusel_o <= `EXE_RES_SHIFT;
					reg1_read_o <= `ReadDisable;
					reg2_read_o <= `ReadEnable;
					wd_o <= inst_i[15:11];
					wreg_o <= `WriteEnable;
					imm <= inst_i[10:6];
				end
			end
		end
	end

	//set the reg1
	always@(*) begin
		if(rst == `RstEnable) begin
			reg1_o <= `ZeroWord;
		end
		//the data forwarding need to be frotier than the normal data pass
		//new condition: data from exe
		else if(reg1_read_o == `ReadEnable && ex_wreg_i == `WriteEnable && reg1_addr_o == ex_wd_i) begin
			reg1_o <= ex_wdata_i;
		end // else if(ex_wreg_i == `ReadEnable)
		//new condition: data from mem
		else if(reg1_read_o == `ReadEnable && mem_wreg_i == `WriteEnable && reg1_addr_o == mem_wd_i) begin
			reg1_o <= mem_wdata_i;
		end // else if(reg1_read_o == `ReadEnable && mem_wreg_i == `WriteEnable && reg1_addr_o == mem_wd_i)
		else if(reg1_read_o == `ReadEnable) begin
			reg1_o <= reg1_data_i;
		end
		else if(reg1_read_o == `ReadDisable) begin
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
		//new condition: data from exe
		else if(reg2_read_o == `ReadEnable && ex_wreg_i == `WriteEnable && reg2_addr_o == ex_wd_i) begin
			reg2_o <= ex_wdata_i;
		end // else if(reg2_read_o == `ReadEnable && ex_wreg_i == `WriteEnable && reg2_addr_o == ex_wd_i)
		else if(reg2_read_o == `ReadEnable && mem_wreg_i == `WriteEnable && reg2_addr_o == mem_wd_i) begin
			reg2_o <= mem_wdata_i;
		end // else if(reg2_read_o == `ReadEnable && mem_wreg_i == `WriteEnable && reg2_addr_o == mem_wd_i)
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

	//set the is_in_delayslot
	always@(*) begin
		if(rst == `RstEnable) begin
			is_in_delayslot_o <= `NotInDelaySlot;
		end // if(rst == `RstEnable)
		else begin
			is_in_delayslot_o <= is_in_delayslot_i;
		end
	end // always@(*)
endmodule
