`timescale 1ns / 1ps
`include "define.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/10/31 00:39:57
// Design Name: 
// Module Name: inst_rom_tb
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


module inst_rom_tb(

    );
	reg[`InstAddrBus] pc = 0;
	reg ena = 1;
	reg clka = 0;
	wire[`InstBus] inst;
	always begin
		#5 begin 
			clka = ~clka; 
			pc = pc+4;
		end
	end
	inst_rom inst_rom2(.clka(clka),.ena(ena),.addra(pc),.douta(inst));
endmodule
