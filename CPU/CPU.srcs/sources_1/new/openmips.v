`timescale 1ns / 1ps
`include "define.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/10/15 18:15:48
// Design Name: 
// Module Name: openmips
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


module openmips(
	input wire rst, clk,
	input wire[`InstBus] rom_data_i,
	output wire[`InstAddrBus] rom_addr_o,
	output wire rom_ce_o
    );
	//id input
	wire[`InstAddrBus] pc;
	wire[`InstBus] id_inst_i;
	wire[`InstAddrBus] id_pc_i;

	//id output
	wire[`AluOpBus] id_aluop_o;
	wire[`AluSelBus] id_alusel_o;
	wire[`RegBus] id_reg1_o;
	wire[`RegBus] id_reg2_o;
	wire id_wreg_o;
	wire[`RegAddrBus] id_wd_o;

	//ex input
	//from id_ex
	wire[`AluOpBus] ex_aluop_i;
	wire[`AluSelBus] ex_alusel_i;
	wire[`RegBus] ex_reg1_i;
	wire[`RegBus] ex_reg2_i;
	wire ex_wreg_i;
	wire[`RegAddrBus] ex_wd_i;
	//from hilo_reg
	wire[`RegBus] ex_hi_i;
	wire[`RegBus] ex_lo_i;

	//ex output
	wire ex_wreg_o;
	wire[`RegAddrBus] ex_wd_o;
	wire[`RegBus] ex_wdata_o;
	wire ex_whilo_o;
	wire[`RegBus] ex_hi_o;
	wire[`RegBus] ex_lo_o;

	//mem input
	wire mem_wreg_i;
	wire[`RegAddrBus] mem_wd_i;
	wire[`RegBus] mem_wdata_i;
	wire mem_whilo_i;
	wire[`RegBus] mem_hi_i;
	wire[`RegBus] mem_lo_i;

	//mem output
	wire mem_wreg_o;
	wire[`RegAddrBus] mem_wd_o;
	wire[`RegBus] mem_wdata_o;
	wire mem_whilo_o;
	wire[`RegBus] mem_hi_o;
	wire[`RegBus] mem_lo_o;

	//wb input
	wire wb_wreg_i;
	wire[`RegAddrBus] wb_wd_i;
	wire[`RegBus] wb_wdata_i;
	wire wb_whilo_i;
	wire[`RegBus] wb_hi_i;
	wire[`RegBus] wb_lo_i;

	//regfile 
	wire reg1_read, reg2_read;
	wire[`RegBus] reg1_data, reg2_data;
	wire[`RegAddrBus] reg1_addr, reg2_addr;

	//pc_reg
	pc_reg pc_reg0(.clk(clk),.rst(rst),.pc(pc),.ce(rom_ce_o));
	assign rom_addr_o = pc;

	//hilo_reg
	hilo_reg hilo_reg0(
		.clk(clk),.rst(rst)
		//from wb
		,.we 	(wb_whilo_i)
		,.hi_i 	(wb_hi_i)
		,.lo_i 	(wb_lo_i)

		//to ex
		,.hi_o 	(ex_hi_i)
		,.lo_o 	(ex_lo_i)
		);
	//regfile
	regfile regfile0(
		.clk(clk),.rst(rst)
		//from id
		,.re1 	(reg1_read)
		,.re2 	(reg2_read)
		,.raddr1(reg1_addr)
		,.raddr2(reg2_addr)
		//to id
		,.rdata1(reg1_data)
		,.rdata2(reg2_data)
		//from wb
		,.we 	(wb_wreg_i)
		,.waddr (wb_wd_i)
		,.wdata (wb_wdata_i)
		);
	//if_id
	if_id if_id0(
		.clk(clk),.rst(rst)	
		,.if_pc		(pc)		
		,.if_inst 	(rom_data_i)
		,.id_pc 	(id_pc_i)	
		,.id_inst 	(id_inst_i)
		);
	//id
	id id0(
		.rst 			(rst)
		//from if_id
		,.pc_i 			(id_pc_i)	
		,.inst_i  		(id_inst_i)
		//from regfile
		,.reg1_data_i 	(reg1_data)
		,.reg2_data_i 	(reg2_data)
		//to regfile
		,.reg1_read_o 	(reg1_read)
		,.reg2_read_o 	(reg2_read)
		,.reg1_addr_o 	(reg1_addr)
		,.reg2_addr_o 	(reg2_addr)
		//to id_ex
		,.aluop_o 		(id_aluop_o)	
		,.alusel_o  	(id_alusel_o)
		,.reg1_o 		(id_reg1_o)		
		,.reg2_o 		(id_reg2_o)
		,.wd_o 			(id_wd_o)			
		,.wreg_o 		(id_wreg_o)
		//data forwarding from ex
		,.ex_wreg_i  	(ex_wreg_o)	
		,.ex_wd_i    	(ex_wd_o)
		,.ex_wdata_i 	(ex_wdata_o)
		//data forwarding from mem
		,.mem_wreg_i 	(mem_wreg_o)	
		,.mem_wd_i   	(mem_wd_o)
		,.mem_wdata_i 	(mem_wdata_o)
		);
	//id_ex
	id_ex id_ex0(
		.clk(clk),.rst(rst)
		//from id
		,.id_aluop (id_aluop_o)	
		,.id_alusel(id_alusel_o)
		,.id_reg1  (id_reg1_o)	
		,.id_reg2  (id_reg2_o)
		,.id_wd    (id_wd_o)	
		,.id_wreg  (id_wreg_o)
		//to ex
		,.ex_aluop (ex_aluop_i)	
		,.ex_alusel(ex_alusel_i)
		,.ex_reg1  (ex_reg1_i)  
		,.ex_reg2  (ex_reg2_i)
		,.ex_wd    (ex_wd_i)	
		,.ex_wreg  (ex_wreg_i)
		);
	//ex
	ex ex0(
		.rst(rst)
		//from id_ex
		,.aluop_i  		(ex_aluop_i) 	
		,.alusel_i  	(ex_alusel_i)
		,.reg1_i    	(ex_reg1_i)	
		,.reg2_i    	(ex_reg2_i)
		,.wd_i      	(ex_wd_i)		
		,.wreg_i   		(ex_wreg_i)
		//to ex_mem
		,.wreg_o    	(ex_wreg_o)	
		,.wd_o      	(ex_wd_o)
		,.wdata_o   	(ex_wdata_o)
		,.whilo_o    	(ex_whilo_O)
		,.hi_o       	(ex_hi_o)
		,.lo_o       	(ex_lo_o)
		//from hilo_reg
		,.hi_i     		(ex_hi_i)		
		,.lo_i 			(ex_lo_i)
		//from mem
		,.mem_whilo_i 	(mem_whilo_o)
		,.mem_hi_i   	(mem_hi_o)
		,.mem_lo_i  	(mem_lo_o)
		//from wb
		,.wb_hi_i   	(wb_hi_o)
		,.wb_lo_i    	(wb_lo_o)
		);
	//ex_mem
	ex_mem ex_mem0(
		.clk(clk),.rst(rst)
		//from ex
		,.ex_wreg   (ex_wreg_o)	
		,.ex_wd    	(ex_wd_o)
		,.ex_wdata  (ex_wdata_o)
		,.ex_whilo  (ex_whilo_o)
		,.ex_hi 	(ex_hi_o)
		,.ex_lo 	(ex_lo_o)	
		//to mem
		,.mem_wreg  (mem_wreg_i)	
		,.mem_wd   	(mem_wd_i)
		,.mem_wdata (mem_wdata_i)
		,.mem_whilo (mem_whilo_i)
		,.mem_hi 	(mem_hi_i)
		,.mem_lo 	(mem_lo_i)
		);
	//mem
	mem mem0(
		.rst    (rst)
		//from ex_mem
		,.wreg_i (mem_wreg_i) 	
		,.wd_i   (mem_wd_i)
		,.wdata_i(mem_wdata_i)
		,.whilo_i(mem_whilo_i)
		,.hi_i 	 (mem_hi_i)
		,.lo_i   (mem_lo_i)
		//to mem_wb
		,.wreg_o (mem_wreg_o)	
		,.wd_o   (mem_wd_o)
		,.wdata_o(mem_wdata_o)
		,.whilo_o(mem_whilo_o)
		,.hi_o   (mem_hi_o)
		,.lo_o   (mem_lo_o)
		);
	//mem_wb
	mem_wb mem_wb0(
		.clk       (clk)		
		,.rst      (rst)
		//from mem
		,.mem_wreg (mem_wreg_o)	
		,.mem_wd   (mem_wd_o)
		,.mem_wdata(mem_wdata_o)
		,.mem_whilo(mem_whilo_o)
		,.mem_hi   (mem_hi_o)
		,.mem_lo   (mem_lo_o)
		//to wb
		,.wb_wreg  (wb_wreg_i)	
		,.wb_wd    (wb_wd_i)
		,.wb_wdata (wb_wdata_i)
		,.wb_whilo (wb_whilo_i)
		,.wb_hi    (wb_hi_i)
		,.wb_lo    (wb_lo_i)
		);


endmodule
