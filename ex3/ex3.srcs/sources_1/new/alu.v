`timescale 1ns / 1ps
`include "define.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/10/10 20:03:32
// Design Name: 
// Module Name: alu
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


module alu(
	input wire[31:0] srca,
	input wire[31:0] srcb,
	input wire[2:0] alucontrol,
	output reg[31:0] aluout,
	output reg overflow, zero
    );
	always @(*) begin
		case(alucontrol) 
			`ALUCONTROL_ADD: aluout <= srca+srcb;
			`ALUCONTROL_SUB: aluout <= srca-srcb;
			`ALUCONTROL_AND: aluout <= srca&srcb;
			`ALUCONTROL_OR:	 aluout <= srca|srcb;
			`ALUCONTROL_AANDNOTB: aluout <= srca & ~srcb;
			`ALUCONTROL_AORNOTB: aluout <= srca | ~srcb;
			`ALUCONTROL_SLT: aluout <= ($signed(srca) < $signed(srcb))?1:0;
			default: begin
				aluout <= 32'h0;
			end // default:
		endcase // alucontrol
	end // always @(*)

	always @(*) begin
		case(alucontrol)
			`ALUCONTROL_ADD: overflow <= srca[31] & srcb[31] & ~aluout[31] | ~srca[31] & ~srcb[31] & aluout[31];
			`ALUCONTROL_SUB: begin 
				overflow <= ((srca[31] & ~srcb[31]) & ~aluout[31]) | ((~srca[31] & srcb[31]) & aluout[31]);
				zero <= (aluout== 32'h0)?1:0;
			end
			default: begin
				overflow <= 0;
				zero <= 0;
			end
		endcase // alucontrol
	end // always @(*)
endmodule
