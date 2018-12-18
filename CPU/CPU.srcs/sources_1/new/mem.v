`timescale 1ns / 1ps
`include "define.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/10/15 18:00:12
// Design Name: 
// Module Name: mem
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


module mem(
	input wire rst,
	input wire wreg_i,
	input wire[`RegAddrBus] wd_i,
	input wire[`RegBus] wdata_i,
	output reg wreg_o,
	output reg[`RegAddrBus] wd_o,
	output reg[`RegBus] wdata_o,

	//hi_lo input
	input wire whilo_i,
	input wire[`RegBus] hi_i,
	input wire[`RegBus] lo_i,

	//hi_lo output
	output reg whilo_o,
	output reg[`RegBus] hi_o,
	output reg[`RegBus] lo_o,

	//load and store
	//from ex_mem
	input wire[`AluOpBus] aluop_i,
	input wire[`InstAddrBus] mem_addr_i,
	input wire[`RegBus] reg2_i,
	//from data memory
	input wire[`RegBus] mem_data_i,

	//to data memory
	output reg[`InstAddrBus] mem_addr_o,
	output reg[`RegBus] mem_data_o,
	output wire[3:0] mem_we_o,
	output reg mem_ce_o,

	//cp0 reg
	input wire cp0_reg_we_i,
	input wire[`RegAddrBus] cp0_reg_waddr_i,
	input wire[`RegBus] cp0_reg_data_i,

	output reg cp0_reg_we_o,
	output reg[`RegAddrBus] cp0_reg_waddr_o,
	output reg[`RegBus] cp0_reg_data_o,

	//except
	input wire[`RegBus] excepttype_i,
	input wire[`InstAddrBus] current_inst_address_i,
	input wire is_in_delayslot_i,
	input wire[`RegBus] cp0_status_i,
	input wire[`RegBus] cp0_cause_i,
	input wire[`RegBus] cp0_epc_i,
	input wire wb_cp0_reg_we,
	input wire[`RegAddrBus] wb_cp0_reg_write_address,
	input wire[`DataBus] wb_cp0_reg_data,

	output reg[`RegBus] excepttype_o,
	output wire[`InstAddrBus] current_inst_address_o,
	output wire is_in_delayslot_o,
	output wire[`RegBus] cp0_epc_o
    );

	wire [`RegBus] zero32;
	reg[`RegBus] cp0_status;
	reg[`RegBus] cp0_cause;
	reg[`RegBus] cp0_epc;
	reg[3:0] mem_sel_o;
	assign zero32 = `ZeroWord;

	assign is_in_delayslot_o = is_in_delayslot_i;
	assign current_inst_address_o = current_inst_address_i;

	always@(*) begin
		if(rst == `RstEnable) begin
			wreg_o <= `WriteDisable;
			wd_o <= `NOPRegAddr;
			wdata_o <= `ZeroWord;
			whilo_o <= `WriteDisable;
			hi_o <= `ZeroWord;
			lo_o <= `ZeroWord;
			mem_addr_o <= `ZeroWord;
			mem_sel_o <= 4'b0000;
			mem_data_o <= `ZeroWord;
			mem_ce_o <= `ChipDisable;
			cp0_reg_we_o <= `WriteDisable;
			cp0_reg_waddr_o <= `NOPRegAddr;
			cp0_reg_data_o <= `ZeroWord;
		end // if(rst == `RstEnable)
		else begin
			wreg_o <= wreg_i;
			wd_o <= wd_i;
			wdata_o <= wdata_i;
			whilo_o <= whilo_i;
			hi_o <= hi_i;
			lo_o <= lo_i;
			mem_addr_o <= `ZeroWord;
			mem_sel_o <= 4'b0000;
			mem_data_o <= `ZeroWord;
			mem_ce_o <= `ChipDisable;
			cp0_reg_we_o <= cp0_reg_we_i;
			cp0_reg_waddr_o <= cp0_reg_waddr_i;
			cp0_reg_data_o <= cp0_reg_data_i;
			case(aluop_i)
				//LOAD BYTE: SIGNED EXTENSION
				`EXE_LB_OP: begin
					mem_addr_o <= mem_addr_i;
					mem_ce_o <= `ChipEnable;
					case(mem_addr_i[1:0])
						2'b00: begin
							wdata_o <= {{24{mem_data_i[31]}}, mem_data_i[31:24]};
							//mem_sel_o <= 4'b1000;
						end
						2'b01: begin
							wdata_o <= {{24{mem_data_i[23]}}, mem_data_i[23:16]};
							//mem_sel_o <= 4'b0100;
						end
						2'b10: begin
							wdata_o <= {{24{mem_data_i[15]}}, mem_data_i[15:8]};
							//mem_sel_o <= 4'b0010;
						end
						2'b11: begin
							wdata_o <= {{24{mem_data_i[7]}}, mem_data_i[7:0]};
							//mem_sel_o <= 4'b0001;
						end
						default: begin
							wdata_o <= `ZeroWord;
						end
					endcase
				end
				//LOAD BYTE UNSIGNED: UNSIGNED EXTENSION
				`EXE_LBU_OP: begin
					mem_addr_o <= mem_addr_i;
					mem_ce_o <= `ChipEnable;
					case(mem_addr_i[1:0])
						2'b00: begin
							wdata_o <= {{24{1'b0}}, mem_data_i[31:24]};
							//mem_sel_o <= 4'b1000;
						end
						2'b01: begin
							wdata_o <= {{24{1'b0}}, mem_data_i[23:16]};
							//mem_sel_o <= 4'b0100;
						end
						2'b10: begin
							wdata_o <= {{24{1'b0}}, mem_data_i[15:8]};
							//mem_sel_o <= 4'b0010;
						end
						2'b11: begin
							wdata_o <= {{24{1'b0}}, mem_data_i[7:0]};
							//mem_sel_o <= 4'b0001;
						end
						default: begin
							wdata_o <= `ZeroWord;
						end
					endcase
				end
				`EXE_LH_OP: begin
					mem_addr_o <= mem_addr_i;
					mem_ce_o <= `ChipEnable;
					case(mem_addr_i[1:0])
						2'b00: begin
							wdata_o <= {{16{mem_data_i[31]}}, mem_data_i[31:16]};
							//mem_sel_o <= 4'b1100;
						end
						2'b10: begin
							wdata_o <= {{16{mem_data_i[15]}}, mem_data_i[15:0]};
							//mem_sel_o <= 4'b0011;
						end
						default: begin
							wdata_o <= `ZeroWord;
						end
					endcase
				end
				`EXE_LHU_OP: begin
					mem_addr_o <= mem_addr_i;
					mem_ce_o <= `ChipEnable;
					case(mem_addr_i[1:0])
						2'b00: begin
							wdata_o <= {{16{1'b0}}, mem_data_i[31:16]};
							//mem_sel_o <= 4'b1100;
						end
						2'b10: begin
							wdata_o <= {{16{1'b0}}, mem_data_i[15:0]};
							//mem_sel_o <= 4'b0011;
						end
						default: begin
							wdata_o <= `ZeroWord;
						end
					endcase
				end
				`EXE_LW_OP: begin
					mem_addr_o <= mem_addr_i;
					mem_ce_o <= `ChipEnable;
					//mem_sel_o <= 4'b1111;
					wdata_o <= mem_data_i;
				end
				`EXE_LWL_OP: begin
					mem_addr_o <= {mem_addr_i[31:2], 2'b00};
					//mem_sel_o <= 4'b1111;
					mem_ce_o <= `ChipEnable;
					case (mem_addr_i[1:0])
						2'b00:	begin
							wdata_o <= mem_data_i[31:0];
						end
						2'b01:	begin
							wdata_o <= {mem_data_i[23:0],reg2_i[7:0]};
						end
						2'b10:	begin
							wdata_o <= {mem_data_i[15:0],reg2_i[15:0]};
						end
						2'b11:	begin
							wdata_o <= {mem_data_i[7:0],reg2_i[23:0]};	
						end
						default:	begin
							wdata_o <= `ZeroWord;
						end
					endcase	
				end
				`EXE_LWR_OP: begin
					mem_addr_o <= {mem_addr_i[31:2], 2'b00};
					//mem_sel_o <= 4'b1111;
					mem_ce_o <= `ChipEnable;
					case(mem_addr_i[1:0])
						2'b00: begin
							wdata_o <= {reg2_i[31:8], mem_data_i[31:24]};
						end
						2'b01: begin
							wdata_o <= {reg2_i[31:16], mem_data_i[31:16]};
						end
						2'b10: begin
							wdata_o <= {reg2_i[31:24], mem_data_i[31:8]};
						end
						2'b11: begin
							wdata_o <= mem_data_i;
						end
						default: begin
							wdata_o <= `ZeroWord;
						end
					endcase // mem_addr_i[1:0]
				end
				`EXE_SB_OP: begin
					mem_addr_o <= mem_addr_i;
					mem_ce_o <= `ChipEnable;
					mem_data_o <= {4{reg2_i[7:0]}};
					case(mem_addr_i[1:0])
						2'b00: begin
							mem_sel_o <= 4'b1000;
						end
						2'b01: begin
							mem_sel_o <= 4'b0100;
						end
						2'b10: begin
							mem_sel_o <= 4'b0010;
						end
						2'b11: begin
							mem_sel_o <= 4'b0001;
						end
						default: begin
							mem_sel_o <= 4'b0000;
						end
					endcase // mem_addr_i[1:0]
				end
				`EXE_SH_OP: begin
					mem_addr_o <= mem_addr_i;
					mem_ce_o <= `ChipEnable;
					mem_data_o <= {2{reg2_i[15:0]}};
					case(mem_addr_i[1:0])
						2'b00: begin
							mem_sel_o <= 4'b1100;
						end
						2'b10: begin
							mem_sel_o <= 4'b0011;
						end
						default: begin
							mem_sel_o <= 4'b0000;
						end
					endcase // mem_addr_i[1:0]
				end
				`EXE_SW_OP: begin
					mem_addr_o <= mem_addr_i;
					mem_ce_o <= `ChipEnable;
					mem_data_o <= reg2_i;
					mem_sel_o <= 4'b1111;
				end
				`EXE_SWL_OP: begin
					mem_addr_o <= {mem_addr_i[31:2], 2'b00};
					mem_ce_o <= `ChipEnable;
					case(mem_addr_i[1:0])
						2'b00: begin
							mem_data_o <= reg2_i;
							mem_sel_o <= 4'b1111;
						end
						2'b01: begin
							mem_data_o <= {zero32[7:0], reg2_i[31:8]};
							mem_sel_o <= 4'b0111;
						end
						2'b10: begin
							mem_data_o <= {zero32[15:0], reg2_i[31:16]};
							mem_sel_o <= 4'b0011;
						end
						2'b11: begin
							mem_data_o <= {zero32[23:0], reg2_i[31:24]};
							mem_sel_o <= 4'b0001;
						end
						default: begin
							mem_data_o <= `ZeroWord;
							mem_sel_o <= 4'b0000;
						end
					endcase // mem_addr_i[1:0]
				end
				`EXE_SWR_OP: begin
					mem_addr_o <= {mem_addr_i[31:2], 2'b00};
					mem_ce_o <= `ChipEnable;
					case(mem_addr_i[1:0])
						2'b00: begin
							mem_data_o <= {reg2_i[7:0], zero32[23:0]};
							mem_sel_o <= 4'b1000;
						end
						2'b01: begin
							mem_data_o <= {reg2_i[15:0], zero32[15:0]};
							mem_sel_o <= 4'b1100;
						end
						2'b10: begin
							mem_data_o <= {reg2_i[23:0], zero32[7:0]};
							mem_sel_o <= 4'b1110;
						end
						2'b11: begin
							mem_data_o <= reg2_i;
							mem_sel_o <= 4'b1111;
						end
						default: begin
							mem_sel_o <= 4'b0000;
						end
					endcase
				end
				default: begin
				end
			endcase // aluop_i
		end // else
	end // always@(*)

	//set cp0_status
	always@(*) begin
		if(rst == `RstEnable) begin
			cp0_status <= `ZeroWord;
		end 
		else if(wb_cp0_reg_we == `WriteEnable && wb_cp0_reg_write_address == `CP0_REG_STATUS) begin
			cp0_status <= wb_cp0_reg_data;
		end
		else begin
			cp0_status <= cp0_status_i;
		end 
	end 

	//set cp0_epc
	always@(*) begin
		if(rst == `RstEnable) begin
			cp0_epc <= `ZeroWord;
		end 
		else if(wb_cp0_reg_we == `WriteEnable && wb_cp0_reg_write_address == `CP0_REG_EPC) begin
			cp0_epc <= wb_cp0_reg_data;
		end
		else begin
			cp0_epc <= cp0_epc_i;
		end 
	end 
	assign cp0_epc_o = cp0_epc;

	//set cp0_cause
	always@(*) begin
		if(rst == `RstEnable) begin
			cp0_cause <= `ZeroWord;
		end 
		else if(wb_cp0_reg_we == `WriteEnable && wb_cp0_reg_write_address == `CP0_REG_CAUSE) begin
			cp0_cause[9:8] <= wb_cp0_reg_data[9:8];
			cp0_cause[22] <= wb_cp0_reg_data[22];
			cp0_cause[23] <= wb_cp0_reg_data[23];
		end
		else begin
			cp0_cause <= cp0_cause_i;
		end 
	end 

	//set excepttype
	always@(*) begin
		if(rst == `RstEnable) begin
			excepttype_o <= `ZeroWord;
		end 
		else begin
			excepttype_o <= `ZeroWord;
			if(current_inst_address_i != `ZeroWord) begin
				if(((cp0_cause[15:8] & (cp0_status[15:8])) != 8'h00) && (cp0_status[1] == 1'b0) && (cp0_status[0] == 1'b1)) begin
					excepttype_o <= 32'h0000_0001;
				end 
				//syscall
				else if(excepttype_i[8] == 1'b1) begin
					excepttype_o <= 32'h0000_0008;
				end 
				else if(excepttype_i[9] == 1'b1) begin
					excepttype_o <= 32'h0000_000a;
				end
				else if(excepttype_i[10] == 1'b1) begin
					excepttype_o <= 32'h0000_000d;
				end 
				else if(excepttype_i[11] == 1'b1) begin
					excepttype_o <= 32'h0000_000c;
				end 
				//eret
				else if(excepttype_i[12] == 1'b1) begin
					excepttype_o <= 32'h0000_000e;
				end 
			end 
		end 
	end 
	assign mem_we_o = mem_sel_o &(~(|excepttype_o));
endmodule
