`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/10/14 23:05:44
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
	input wire[7:0] addr,
	input wire clk,
	output wire[6:0] seg,
	output wire[7:0] ans
    );
	wire [31:0]sign_addr;
	wire [31:0]out;
	assign sign_addr={24'h000000,addr[7:0]};
	blk_mem_gen_0 ROM(.addra(sign_addr),.clka(clk),.douta(out));
	display dis(.clk(clk),.reset(rst),.s(out),.seg(seg),.ans(ans));
endmodule
