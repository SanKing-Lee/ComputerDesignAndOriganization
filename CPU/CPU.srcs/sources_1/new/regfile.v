`timescale 1ns / 1ps
`include "define.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/10/14 20:40:33
// Design Name: 
// Module Name: regfile
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


module regfile(
	//clk and rst
	input wire clk,
	input wire rst,
	//write
	input wire[`RegAddrBus] waddr,
	input wire[`RegBus] wdata,
	input wire we,
	//read1
	input wire[`RegAddrBus] raddr1,
	input wire re1,
	output reg[`RegBus] rdata1,
	//read2
	input wire[`RegAddrBus] raddr2,
	input wire re2,
	output reg[`RegBus] rdata2
    );
	//initial registers
	reg[`RegBus] regs[0:`RegNum-1];

	//write operation
	always@(posedge clk) begin
		if(rst == `RstDisable) begin
			if((we == `WriteEnable) && (waddr != `RegNumLog2'h0)) begin
				regs[waddr] <= wdata;
			end
		end
	end

	//read1 operation
	always@(*) begin
		if(rst == `RstEnable) begin
			rdata1 <= `ZeroWord;
		end
		else if(raddr1 == `RegNumLog2'h0) begin
			rdata1 <= `ZeroWord;
		end
		//data forwarding
		else if((raddr1 == waddr) && (we == `WriteEnable) && (re1 == `ReadEnable)) begin
			rdata1 <= wdata;
		end
		//read normally
		else if(re1 == `ReadEnable) begin
			rdata1 <= regs[raddr1];
		end
		//default
		else begin
			rdata1 <= `ZeroWord;
		end
	end

	//read2 operation
	always@(*) begin
		//reset
		if(rst == `RstEnable) begin
			rdata2 <= `ZeroWord;
		end
		else if(raddr2 == `RegNumLog2'h0) begin
			rdata2 <= `ZeroWord;
		end
		else if((raddr2 == waddr) && (we = `WriteEnable) && (re2 == `ReadEnable)) begin
			rdata2 <= wdata;
		end
		else if(re2 == `ReadEnable) begin
			rdata2 <= regs[raddr2];
		end
		else begin
			rdata2 <= `ZeroWord;
		end
	end
endmodule
