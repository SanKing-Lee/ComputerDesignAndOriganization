`timescale 1ns / 1ps
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
	input [7:0] num1,
	input [2:0] op,
	input [31:0] num2,
	output [31:0] result
    );
	
	wire [31:0] extend;
	wire [31:0] sub;
	assign sub = num1-num2;
	assign extend = {24'h000_000, num1};
	assign result = (op == 3'b000)?(extend+num2):
					(op == 3'b001)?(extend-num2):
					(op == 3'b010)?(extend&num2):
					(op == 3'b011)?(extend|num2):
					(op == 3'b100)?(~extend):
					(op == 3'b101)?((sub<0)?1:0):32'h0000_0000;
endmodule
