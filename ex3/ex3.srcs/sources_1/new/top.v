`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/11/07 13:50:53
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
	input wire clk,rst,
	output wire[31:0] writedata,dataadr,
	output wire memwrite
    );
	// wire clk;
	wire inst_ce;
	wire[31:0] pc,instr,readdata;

	//   clk_div instance_name(
 //    	// Clock out ports
	//     .clk_out1(hclk),     // output clk_out1
	//    // Clock in ports
	//     .clk_in1(clk)
 //    	); 
   	wire [3:0] data_wea;
   	assign data_wea = {4{memwrite}};

	mips mips(clk,rst,inst_ce, pc,instr,memwrite,dataadr,writedata,readdata);
	inst_mem imem(.clka(clk),.ena(inst_ce),.addra(pc),.douta(instr));
	data_mem dmem(.addra(dataadr), .clka(clk), .wea(data_wea),.dina(writedata),.douta(readdata));
endmodule
