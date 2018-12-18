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
	wire ram_ce;
	wire[`InstAddrBus] ram_addr;
	wire[`RegBus] ram_wdata;
	wire[3:0] ram_sel;
	wire[`RegBus] ram_rdata;
	wire[5:0] int_i;
	wire timer_int_o;
	assign int_i = {5'b0, timer_int_o};
	wire[3:0] inst_wen;
	assign inst_wen = 4'b0000;
	wire[`RegBus] inst_wdata;
	assign inst_wdata = `ZeroWord;
	openmips openmips0(
		.resetn           (rst)
		,.clk              (clk)
		,.int              (int_i)
		,.timer_int_o      (timer_int_o)
		,.inst_sram_en     (rom_ce)
		,.inst_sram_wen    (inst_wen)
		,.inst_sram_addr   (inst_addr)
		,.inst_sram_wdata  (inst_wdata)
		,.inst_sram_rdata  (inst)
		,.data_sram_en     (ram_ce)
		,.data_sram_wen    (ram_sel)
		,.data_sram_addr   (ram_addr)
		,.data_sram_wdata  (ram_wdata)
		,.data_sram_rdata  (ram_rdata)
		,.debug_wb_pc      ()
		,.debug_wb_rf_wen  ()
		,.debug_wb_rf_wnum ()
		,.debug_wb_rf_wdata()
		);
	data_ram data_ram0(
		.clka     (~clk)
		,.rsta     (rst)
		,.ena      (ram_ce)
		,.wea      (ram_sel)
		,.addra    (ram_addr)
		,.dina     (ram_wdata)
		,.douta    (ram_rdata)
		);
	inst_rom inst_rom0(
		.addra(inst_addr)
		,.ena(rom_ce)
		,.douta(inst)
		,.clka(~clk)
		,.wea      (inst_wen)
		,.dina     (inst_wdata)
		);
endmodule
