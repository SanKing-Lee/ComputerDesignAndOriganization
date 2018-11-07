`timescale 1ns / 1ps
`include "define.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/10/30 23:18:57
// Design Name: 
// Module Name: module_test
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


module module_test(

    );
	reg clk = 0;
	reg rst = 1;
	always #5 clk = ~clk;
	initial begin
		#20 rst = 0;
	end // initial

	//pc_reg & inst_rom
	wire[`InstAddrBus] pc;
	wire ce;
	wire[`InstBus] inst;

	//if_id
	wire[`InstAddrBus] id_pc;
	wire[`InstBus] id_inst;

	//id
	wire[`AluOpBus] id_aluop_o;
	wire[`AluSelBus] id_alusel_o;
	wire[`RegBus] id_reg1_o;
	wire[`RegBus] id_reg2_o;
	wire id_wreg_o;
	wire[`RegAddrBus] id_wd_o;
	//id & regfile
	wire[`RegBus] reg1_data, reg2_data;
	wire reg1_read, reg2_read;
	wire[`RegAddrBus] reg1_addr, reg2_addr;

	//wb & regfile
	wire wb_wreg_i;
	wire[`RegAddrBus] wb_wd_i;
	wire[`RegBus] wb_wdata_i;

	//from id_ex to ex
	wire[`AluOpBus] ex_aluop_i;
	wire[`AluSelBus] ex_alusel_i;
	wire[`RegBus] ex_reg1_i;
	wire[`RegBus] ex_reg2_i;
	wire ex_wreg_i;
	wire[`RegAddrBus] ex_wd_i;

	//ex and ex_mem
	wire ex_wreg_o;
	wire[`RegAddrBus] ex_wd_o;
	wire[`RegBus] ex_wdata_o;

	//ex_mem and mem
	wire mem_wreg_i;
	wire[`RegAddrBus] mem_wd_i;
	wire[`RegBus] mem_wdata_i;

	//mem and mem_wb
	wire mem_wreg_o;
	wire[`RegAddrBus] mem_wd_o;
	wire[`RegBus] mem_wdata_o;


	//pc_reg
	pc_reg pc_reg1(.clk(clk),.rst(rst),.pc (pc),.ce (ce));
	//inst_rom
	inst_rom inst_rom1(.addra(pc),.clka(clk),.ena(ce),.douta(inst));
	//if_id
	if_id if_id1(.rst    (rst),.clk    (clk),.if_pc  (pc),.if_inst(inst),.id_pc  (id_pc),.id_inst(id_inst));
	//id
	id id1(
		.rst(rst)
		//from if_id
		,.pc_i(id_pc)			,.inst_i(id_inst)
		//from regfile
		,.reg1_data_i(reg1_data),.reg2_data_i(reg2_data)
		//to regfile
		,.reg1_read_o(reg1_read),.reg2_read_o(reg2_read)
		,.reg1_addr_o(reg1_addr),.reg2_addr_o(reg2_addr)
		//to id_ex
		,.aluop_o(id_aluop_o)	,.alusel_o(id_alusel_o)
		,.reg1_o(id_reg1_o)		,.reg2_o(id_reg2_o)
		,.wd_o(id_wd_o)			,.wreg_o(id_wreg_o)
		);
	//regfile
	regfile regfile1(
		.clk(clk),.rst(rst)
		//from id
		,.re1(reg1_read),.re2(reg2_read)
		,.raddr1(reg1_addr),.raddr2(reg2_addr)
		//to id
		,.rdata1(reg1_data),.rdata2(reg2_data)
		//from wb
		,.we(wb_wreg_i),.waddr (wb_wd_i),.wdata (wb_wdata_i)
		);
	//id_dx
	id_ex id_ex1(
		.clk(clk),.rst(rst)
		//from id
		,.id_aluop (id_aluop_o)	,.id_alusel(id_alusel_o)
		,.id_reg1  (id_reg1_o)	,.id_reg2  (id_reg2_o)
		,.id_wd    (id_wd_o)	,.id_wreg  (id_wreg_o)
		//to ex
		,.ex_aluop (ex_aluop_i)	,.ex_alusel(ex_alusel_i)
		,.ex_reg1  (ex_reg1_i)  ,.ex_reg2  (ex_reg2_i)
		,.ex_wd    (ex_wd_i)	,.ex_wreg  (ex_wreg_i)
		);
	//ex
	ex ex0(
		.rst     (rst)
		//from id_ex
		,.aluop_i (ex_aluop_i) 	,.alusel_i(ex_alusel_i)
		,.reg1_i  (ex_reg1_i)	,.reg2_i  (ex_reg2_i)
		,.wd_i    (ex_wd_i)		,.wreg_i  (ex_wreg_i)
		//to ex_mem
		,.wreg_o  (ex_wreg_o)	,.wd_o    (ex_wd_o)
		,.wdata_o (ex_wdata_o)
		);
	//ex_mem
	ex_mem ex_mem0(
		.clk      (clk)	,.rst      (rst)
		//from ex
		,.ex_wreg  (ex_wreg_o)	,.ex_wd    (ex_wd_o)
		,.ex_wdata (ex_wdata_o)	
		//to mem
		,.mem_wreg (mem_wreg_i)	,.mem_wd   (mem_wd_i)
		,.mem_wdata(mem_wdata_i)
		);
	//mem
	mem mem0(
		.rst    (rst)
		//from ex_mem
		,.wreg_i(mem_wreg_i) 	,.wd_i   (mem_wd_i)
		,.wdata_i(mem_wdata_i)
		//to wb
		,.wreg_o (mem_wreg_o)	,.wd_o   (mem_wd_o)
		,.wdata_o(mem_wdata_o)
		);
	//mem_wb
	mem_wb mem_wb0(
		.clk       (clk)		,.rst      (rst)
		//from mem
		,.mem_wreg (mem_wreg_o)	,.mem_wd   (mem_wd_o)
		,.mem_wdata(mem_wdata_o)
		//to wb
		,.wb_wreg  (wb_wreg_i)	,.wb_wd    (wb_wd_i)
		,.wb_wdata (wb_wdata_i)
		);
endmodule