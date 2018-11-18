`timescale 1ns / 1ps
`include "define.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/01 00:06:53
// Design Name: 
// Module Name: controller
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


module controller(
	input wire[5:0] op, 
	input wire[5:0] funct,
	input wire zero,
	output reg memtoreg, memwrite, 
	output wire pcsrc, 
	output reg alusrc, regdst, regwrite, jump,
	output reg [2:0] alucontrol
    );
	reg[1:0] alu_op;
	reg branch;
	assign pcsrc = branch & zero;
	//main decoder
	always@(*) begin
		if(op == 6'b0 && funct == 6'b0) begin
			memtoreg <= 1'b0;
			memwrite <= 1'b0;
			branch <= 1'b0;
			alusrc <= 1'b0;
			regdst <= 1'b0;
			regwrite <= 1'b0;
			jump <= 1'b0;
			alu_op 	<= 2'b00;
		end // if(op == 6'b0 && funct == 6'b0)
		case(op) 
			`OP_RTYPE: 	begin
				memtoreg <= 1'b0;
				memwrite <= 1'b0;
				branch <= 1'b0;
				alusrc <= 1'b0;
				regdst <= 1'b1;
				regwrite <= 1'b1;
				jump <= 1'b0;
				alu_op 	<= 2'b10;
			end
			`OP_LW:		begin
				memtoreg <= 1'b1;
				memwrite <= 1'b0;
				branch <= 1'b0;
				alusrc <= 1'b1;
				regdst <= 1'b0;
				regwrite <= 1'b1;
				jump <= 1'b0;
				alu_op 	<= 2'b00;
			end
			`OP_SW:		begin
				memtoreg <= 1'b0;
				memwrite <= 1'b1;
				branch <= 1'b0;
				alusrc <= 1'b1;
				regdst <= 1'b0;
				regwrite <= 1'b0;
				jump <= 1'b0;
				alu_op 	<= 2'b00;
			end
			`OP_BEQ: 	begin
				memtoreg <= 1'b0;
				memwrite <= 1'b0;
				branch <= 1'b1;
				alusrc <= 1'b0;
				regdst <= 1'b0;
				regwrite <= 1'b0;
				jump <= 1'b0;
				alu_op 	<= 2'b01;
			end
			`OP_ADDI:	begin
				memtoreg <= 1'b0;
				memwrite <= 1'b0;
				branch <= 1'b0;
				alusrc <= 1'b1;
				regdst <= 1'b0;
				regwrite <= 1'b1;
				jump <= 1'b0;
				alu_op 	<= 2'b00;
			end
			`OP_J:		begin
				memtoreg <= 1'b0;
				memwrite <= 1'b0;
				branch <= 1'b0;
				alusrc <= 1'b0;
				regdst <= 1'b0;
				regwrite <= 1'b0;
				jump <= 1'b1;
				alu_op 	<= 2'b00;
			end
			default:	begin
			end
		endcase // op
	end // always@(*)

	always@(*) begin
		case(alu_op) 
			2'b00: 		begin
				alucontrol <= 3'b010;
			end // 2'b00:
			2'b01:		begin
				alucontrol <= 3'b110;
			end // 2'b01:
			2'b10:		begin
				case(funct)
					6'b100000: alucontrol <= 3'b010;
					6'b100010: alucontrol <= 3'b110;
					6'b100100: alucontrol <= 3'b000;
					6'b100101: alucontrol <= 3'b001;
					6'b101010: alucontrol <= 3'b111;
					default: begin
					end // default:
				endcase // funct
			end // 2'b10:
		endcase // alu_op
	end
endmodule
