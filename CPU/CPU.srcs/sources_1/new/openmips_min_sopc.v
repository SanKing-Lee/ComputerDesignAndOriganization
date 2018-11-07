`timescale 1ns / 1ps
`include "define.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/10/23 15:41:19
// Design Name: 
// Module Name: openmips_min_sopc
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


module openmips_min_sopc(
	input wire clk, rst
    );
	wire[`InstAddrBus] inst_addr;
	wire[`InstBus] inst;
	wire rom_ce;

	openmips openmips0(.clk(clk),.rst(rst)
		,.rom_addr_o(inst_addr),.rom_data_i(inst)
		,.rom_ce_o  (rom_ce));

	inst_rom inst_rom0(.addra(inst_addr),.ena(rom_ce),.douta(inst),.clka(clk));
endmodule
