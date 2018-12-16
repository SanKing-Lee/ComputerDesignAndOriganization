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
	wire ram_ce, ram_we;
	wire[`RegBus] ram_rdata;
	wire[`RegBus] ram_wdata;
	wire[`DataAddrBus] ram_addr;
	wire[3:0] ram_sel;

	openmips openmips0(.clk(clk),.rst(rst)
		,.rom_addr_o(inst_addr),.rom_data_i(inst)
		,.rom_ce_o  (rom_ce)
		,.ram_data_i(ram_rdata)
		,.ram_addr_o(ram_addr)
		,.ram_data_o(ram_wdata)
		,.ram_we_o  (ram_we)
		,.ram_sel_o (ram_sel)
		,.ram_ce_o  (ram_ce)
		);

	data_ram data_ram0(
		.clk   (clk)
		,.ce    (ram_ce)
		,.we    (ram_we)
		,.addr  (ram_addr)
		,.sel   (ram_sel)
		,.data_i(ram_rdata)
		,.data_o(ram_wdata)
		);

	inst_rom inst_rom0(.addra(inst_addr),.ena(rom_ce),.douta(inst),.clka(~clk));
endmodule
