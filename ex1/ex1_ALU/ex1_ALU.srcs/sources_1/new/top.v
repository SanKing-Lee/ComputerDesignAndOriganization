`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/10/10 20:05:13
// Design Name: 
// Module Name: top
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


module top(
	input [7:0] num1,
	input [2:0] op,
	input clk, rst,
	output [6:0]seg,
	output [7:0]ans
    );
	reg [31:0]num2 = 32'h10329320;
	wire [31:0]result;
	alu alu1(.op(op),.num1(num1),.num2(num2),.result(result));
	display dis(.clk(clk),.reset(rst),.s(result),.seg(seg),.ans(ans));

endmodule
