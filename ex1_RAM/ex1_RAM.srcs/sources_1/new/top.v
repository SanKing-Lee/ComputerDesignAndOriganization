`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/10/10 20:54:42
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
	input[31:0] addr,
	input clk, rst,
	output [7:0] ans,
	output [6:0] seg
    );
	wire enable = 1'b1;
	wire [31:0] data;
	blk_mem_gen_0 rom(.addra(addr),.ena(enable),.rsta(rst),.clka(clk),.douta(data));
	display dis(.clk(clk),.ans(ans),.seg(seg),.s(data));
endmodule
