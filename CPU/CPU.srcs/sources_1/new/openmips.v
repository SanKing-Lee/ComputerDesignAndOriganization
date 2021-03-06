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
	input wire 						resetn, clk,
	//cp0
	input wire[5:0] 				int,
	output wire 					timer_int_o,
	//from inst_rom
	output wire						inst_sram_en,
	output wire[3:0]				inst_sram_wen,
	output wire[`InstAddrBus] 		inst_sram_addr,
	output wire[`DataBus] 			inst_sram_wdata,
	input wire[`InstBus] 			inst_sram_rdata,

	//from data_ram
	output wire 					data_sram_en,
	output wire[3:0] 				data_sram_wen,
	output wire[`InstAddrBus]		data_sram_addr,
	output wire[`RegBus] 			data_sram_wdata,
	input wire[`RegBus] 			data_sram_rdata,

	//debug
	output wire[`InstAddrBus] 		debug_wb_pc,
	output wire[3:0] 				debug_wb_rf_wen,
	output wire[`RegAddrBus] 		debug_wb_rf_wnum,
	output wire[`DataBus] 			debug_wb_rf_wdata
	
    );
		
	assign inst_sram_wen = 4'b0000;
	assign inst_sram_wdata = `ZeroWord;
	assign debug_wb_pc = mem_current_inst_address_o;
	assign debug_wb_rf_wen = {4{wb_wreg_i}};
	assign debug_wb_rf_wnum = wb_wd_i;
	assign debug_wb_rf_wdata = wb_wdata_i;

	//id input
	wire[`InstAddrBus] 				pc;
	wire[`InstBus] 					id_inst_i;
	wire[`InstAddrBus] 				id_pc_i;
	wire 							id_is_in_delayslot_i;
	//load relation
	wire[`AluOpBus] 				id_ex_aluop_i;

	//id output
	wire[`AluOpBus] 				id_aluop_o;
	wire[`AluSelBus] 				id_alusel_o;
	wire[`RegBus] 					id_reg1_o;
	wire[`RegBus] 					id_reg2_o;
	wire 							id_wreg_o;
	wire[`RegAddrBus] 				id_wd_o;
	wire 							id_is_in_delayslot_o;
	wire[`InstAddrBus] 				id_link_address_o;
	wire 							id_next_inst_in_delayslot_o;
	wire[`InstAddrBus] 				id_branch_target_address_o;
	wire 							id_branch_flag_o;
	wire[`InstBus]					id_inst_o;
	//exception
	wire[`RegBus] 					id_excepttype_o;
	wire[`InstAddrBus] 				id_current_inst_address_o;

	//ex input
	//from id_ex
	wire[`AluOpBus] 				ex_aluop_i;
	wire[`AluSelBus] 				ex_alusel_i;
	wire[`RegBus] 					ex_reg1_i;
	wire[`RegBus] 					ex_reg2_i;
	wire 							ex_wreg_i;	
	wire[`RegAddrBus] 				ex_wd_i;
	//from hilo_reg
	wire[`RegBus] 					ex_hi_i;
	wire[`RegBus] 					ex_lo_i;
	//madd, msub
	wire[`DoubleRegBus] 			ex_hilotemp_i;
	wire[1:0] 						ex_cnt_i;
	//branch
	wire 							ex_is_in_delayslot_i;
	wire[`InstAddrBus] 				ex_link_address_i;
	//load and store
	wire[`InstBus]					ex_inst_i;
	//from cp0
	wire[`RegBus] 					ex_cp0_reg_data_i;
	//exception
	wire[`RegBus] 					ex_excepttype_i;
	wire[`InstAddrBus] 				ex_current_inst_address_i;
	
	//ex output
	wire 							ex_wreg_o;
	wire[`RegAddrBus] 				ex_wd_o;
	wire[`RegBus] 					ex_wdata_o;
	wire 							ex_whilo_o;
	wire[`RegBus] 					ex_hi_o;
	wire[`RegBus] 					ex_lo_o;
	wire[`DoubleRegBus] 			ex_hilotemp_o;
	wire[1:0] 						ex_cnt_o;
	//load and store
	wire[`AluOpBus] 				ex_aluop_o;
	wire[`InstAddrBus]				ex_mem_addr_o;
	wire[`RegBus]					ex_reg2_o;
	//to cp0
	wire[`RegAddrBus] 				ex_cp0_reg_raddr_o;
	//to ex_mem
	wire 							ex_cp0_we_o;
	wire[`RegAddrBus]				ex_cp0_waddr_o;
	wire[`RegBus] 					ex_cp0_data_o;
	//exception
	wire[`RegBus] 					ex_excepttype_o;
	wire[`InstAddrBus] 				ex_current_inst_address_o;
	wire 							ex_is_in_delayslot_o;

	//mem input
	wire 							mem_wreg_i;
	wire[`RegAddrBus] 				mem_wd_i;
	wire[`RegBus] 					mem_wdata_i;
	wire 							mem_whilo_i;
	wire[`RegBus] 					mem_hi_i;
	wire[`RegBus] 					mem_lo_i;
	//cp0
	wire							mem_cp0_we_i;
	wire[`RegAddrBus]     			mem_cp0_waddr_i;
	wire[`RegBus] 					mem_cp0_data_i;
	//load and store
	//from ex_mem
	wire[`AluOpBus]					mem_aluop_i;
	wire[`InstAddrBus]				mem_mem_addr_i;
	wire[`RegBus] 					mem_reg2_i;
	//exception
	wire[`RegBus] 					mem_excepttype_i;
	wire[`InstAddrBus] 				mem_current_inst_address_i;
	wire 							mem_is_in_delay_slot_i;
	wire[`RegBus] 					mem_cp0_status_i;
	wire[`RegBus] 					mem_cp0_cause_i;
	wire[`RegBus] 					mem_cp0_epc_i;

	//mem output
	wire 							mem_wreg_o;
	wire[`RegAddrBus] 				mem_wd_o;
	wire[`RegBus] 					mem_wdata_o;
	wire 							mem_whilo_o;
	wire[`RegBus] 					mem_hi_o;
	wire[`RegBus] 					mem_lo_o;
	wire 							mem_cp0_we_o;
	wire[`RegAddrBus] 				mem_cp0_waddr_o;
	wire[`RegBus]					mem_cp0_data_o;
	//exception
	wire[`RegBus]					mem_cp0_epc_o;
	wire[`RegBus] 					mem_excepttype_o;
	wire							mem_is_in_delay_slot_o;
	wire[`InstAddrBus] 				mem_current_inst_address_o;

	//wb input
	wire 							wb_wreg_i;
	wire[`RegAddrBus] 				wb_wd_i;
	wire[`RegBus] 					wb_wdata_i;
	wire							wb_whilo_i;
	wire[`RegBus] 					wb_hi_i;
	wire[`RegBus] 					wb_lo_i;
	//cp0
	wire 							wb_cp0_we_i;
	wire[`RegAddrBus]   			wb_cp0_waddr_i;
	wire[`RegBus]					wb_cp0_data_i;

	//ctrl
	wire 							stallreq_from_id_i;
	wire 							stallreq_from_ex_i;
	wire [5:0]						stall_o;

	//regfile 
	wire 							reg1_read, reg2_read;
	wire[`RegBus] 					reg1_data, reg2_data;
	wire[`RegAddrBus] 				reg1_addr, reg2_addr;

	//div
	wire 							signed_div;
	wire[`RegBus] 					opdata1_div;
	wire[`RegBus] 					opdata2_div;
	wire 							div_start;
	wire 							div_ready;
	wire[`DoubleRegBus] 			div_result;

	//exception
	wire 							flush;
	wire[`InstAddrBus]     			new_pc;


	//ctrl
	ctrl ctrl0(
		.rst 				(resetn)
		,.stallreq_from_id 	(stallreq_from_id_i)
		,.stallreq_from_ex 	(stallreq_from_ex_i)
		,.stall 			(stall_o)
		,.excepttype_i    (mem_excepttype_o)
		,.cp0_epc_i       (mem_cp0_epc_o)
		,.new_pc          (new_pc)
		,.flush           (flush)
		);
	//pc_reg
	pc_reg pc_reg0(
		.clk(clk),.rst(resetn)
		,.pc 						(pc)
		,.ce 						(inst_sram_en)
		,.stall 					(stall_o)
		,.branch_flag_i 			(id_branch_flag_o)
		,.branch_target_address_i 	(id_branch_target_address_o)
		,.flush                  (flush)
		,.new_pc                 (new_pc)
		);
	assign inst_sram_addr = pc;

	//hilo_reg
	hilo_reg hilo_reg0(
		.clk(clk),.rst(resetn)
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
		.clk(clk),.rst(resetn)
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
		.clk(clk),.rst(resetn)	
		,.if_pc		(pc)		
		,.if_inst 	(inst_sram_rdata)
		,.id_pc 	(id_pc_i)	
		,.id_inst 	(id_inst_i)
		//stall from ctrl 
		,.stall   	(stall_o)
		,.flush  (flush)
		);
	//id
	id id0(
		.rst 						(resetn)
		//from if_id
		,.pc_i 						(id_pc_i)	
		,.inst_i  					(id_inst_i)
		//from regfile
		,.reg1_data_i 				(reg1_data)
		,.reg2_data_i 				(reg2_data)
		//to regfile
		,.reg1_read_o 				(reg1_read)
		,.reg2_read_o 				(reg2_read)
		,.reg1_addr_o 				(reg1_addr)
		,.reg2_addr_o 				(reg2_addr)
		//to id_ex
		,.aluop_o 					(id_aluop_o)	
		,.alusel_o  				(id_alusel_o)
		,.reg1_o 					(id_reg1_o)		
		,.reg2_o 					(id_reg2_o)
		,.wd_o 						(id_wd_o)			
		,.wreg_o 					(id_wreg_o)
		//data forwarding from ex
		,.ex_wreg_i  				(ex_wreg_o)	
		,.ex_wd_i    				(ex_wd_o)
		,.ex_wdata_i 				(ex_wdata_o)
		//data forwarding from mem
		,.mem_wreg_i 				(mem_wreg_o)	
		,.mem_wd_i   				(mem_wd_o)
		,.mem_wdata_i 				(mem_wdata_o)
		//stall to ctrl 
		,.stallreq      			(stallreq_from_id_i)
		//delay slot
		,.is_in_delayslot_i 		(id_is_in_delayslot_i)
		,.branch_flag_o     		(id_branch_flag_o)
		,.branch_target_address_o 	(id_branch_target_address_o)
		,.is_in_delayslot_o       	(id_is_in_delayslot_o)
		,.link_addr_o             	(id_link_address_o)
		,.next_inst_in_delayslot_o	(id_next_inst_in_delayslot_o)
		//load and store
		,.inst_o                  	(id_inst_o)
		,.ex_aluop_i               	(ex_aluop_o)
		,.excepttype_o            (id_excepttype_o)
		,.current_inst_addr_o     (id_current_inst_address_o)
		);
	//id_ex
	id_ex id_ex0(
		.clk(clk),.rst(resetn)
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
		//stall from ctrl
		,.stall    (stall_o)
		//branch
		,.id_is_in_delayslot      (id_is_in_delayslot_o)
		,.id_link_address         (id_link_address_o)
		,.next_inst_in_delayslot_i(id_next_inst_in_delayslot_o)
		,.ex_is_in_delayslot      (ex_is_in_delayslot_i)
		,.ex_link_address         (ex_link_address_i)
		,.is_in_delayslot_o       (id_is_in_delayslot_i)
		//load and store
		,.id_inst                 (id_inst_o)
		,.ex_inst                 (ex_inst_i)
		,.flush                   (flush)
		//exception
		,.id_excepttype           (id_excepttype_o)
		,.id_current_inst_address (id_current_inst_address_o)
		,.ex_excepttype           (ex_excepttype_i)
		,.ex_current_inst_address (ex_current_inst_address_i)
		);
	//ex
	ex ex0(
		.rst(resetn)
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
		,.whilo_o    	(ex_whilo_o)
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
		,.wb_whilo_i 	(wb_whilo_i)
		,.wb_hi_i   	(wb_hi_i)
		,.wb_lo_i    	(wb_lo_i)
		//stallreq to ctrl 
		,.stallreq   	(stallreq_from_ex_i)
		//madd, msub
		,.hilo_temp_i   (ex_hilotemp_i)
		,.cnt_i 		(ex_cnt_i)
		,.hilo_temp_o   (ex_hilotemp_o)
		,.cnt_o   		(ex_cnt_o)
		//div
		,.signed_div_o 	(signed_div)
		,.div_opdata1_o	(opdata1_div)
		,.div_opdata2_o	(opdata2_div)
		,.div_start_o  	(div_start)
		,.div_result_i 	(div_result)
		,.div_ready_i  	(div_ready)
		//branch
		,.is_in_delayslot_i(ex_is_in_delayslot_i)
		,.link_address_i   (ex_link_address_i)
		//load and store
		,.inst_i           (ex_inst_i)
		,.aluop_o          (ex_aluop_o)
		,.mem_addr_o       (ex_mem_addr_o)
		,.reg2_o           (ex_reg2_o)
		//cp0
		,.mem_cp0_reg_we   (mem_cp0_we_o)
		,.mem_cp0_reg_waddr(mem_cp0_waddr_o)
		,.mem_cp0_reg_data (mem_cp0_data_o)
		,.wb_cp0_reg_we    (wb_cp0_we_i)
		,.wb_cp0_reg_waddr (wb_cp0_waddr_i)
		,.wb_cp0_reg_data  (wb_cp0_data_i)
		,.cp0_reg_raddr_o  (ex_cp0_reg_raddr_o)
		,.cp0_reg_data_i   (ex_cp0_reg_data_i)
		,.cp0_reg_we_o     (ex_cp0_we_o)
		,.cp0_reg_waddr_o  (ex_cp0_waddr_o)
		,.cp0_reg_data_o   (ex_cp0_data_o)
		//exception
		,.excepttype_i          (ex_excepttype_i)
		,.current_inst_address_i(ex_current_inst_address_i)
		,.excepttype_o          (ex_excepttype_o)
		,.current_inst_address_o(ex_current_inst_address_o)
		,.is_in_delayslot_o     (ex_is_in_delayslot_o)
		);
	//ex_mem
	ex_mem ex_mem0(
		.clk(clk),.rst(resetn)
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
		,.stall     (stall_o)
		//madd, msub
		,.hilo_i 	(ex_hilotemp_o)
		,.cnt_i     (ex_cnt_o)
		,.hilo_o 	(ex_hilotemp_i)
		,.cnt_o 	(ex_cnt_i)
		//load and store
		,.ex_aluop    (ex_aluop_o)
		,.ex_reg2     (ex_reg2_o)
		,.ex_mem_addr (ex_mem_addr_o)
		,.mem_aluop   (mem_aluop_i)
		,.mem_mem_addr(mem_mem_addr_i)
		,.mem_reg2    (mem_reg2_i)
		//cp0
		,.ex_cp0_reg_we    (ex_cp0_we_o)
		,.ex_cp0_reg_waddr (ex_cp0_waddr_o)
		,.ex_cp0_reg_data  (ex_cp0_data_o)
		,.mem_cp0_reg_we   (mem_cp0_we_i)
		,.mem_cp0_reg_waddr(mem_cp0_waddr_i)
		,.mem_cp0_reg_data (mem_cp0_data_i)
		,.flush                   (flush)
		//exception
		,.ex_excepttype           (ex_excepttype_o)
		,.ex_current_inst_address (ex_current_inst_address_o)
		,.ex_is_in_delayslot      (ex_is_in_delayslot_o)
		,.mem_excepttype          (mem_excepttype_i)
		,.mem_current_inst_address(mem_current_inst_address_i)
		,.mem_is_in_delayslot     (mem_is_in_delay_slot_i)
		);
	//mem
	mem mem0(
		.rst    (resetn)
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
		,.aluop_i   (mem_aluop_i)
		//load and store
		,.mem_addr_i(mem_mem_addr_i)
		,.reg2_i    (mem_reg2_i)
		//from data_ram
		,.mem_data_i(data_sram_rdata)
		//to data_ram
		,.mem_addr_o(data_sram_addr)
		,.mem_data_o(data_sram_wdata)
		,.mem_we_o(data_sram_wen)
		,.mem_ce_o  (data_sram_en)
		//cp0
		,.cp0_reg_we_i   (mem_cp0_we_i)
		,.cp0_reg_waddr_i(mem_cp0_waddr_i)
		,.cp0_reg_data_i (mem_cp0_data_i)
		,.cp0_reg_we_o   (mem_cp0_we_o)
		,.cp0_reg_waddr_o(mem_cp0_waddr_o)
		,.cp0_reg_data_o (mem_cp0_data_o)
		//exception
		,.excepttype_i            (mem_excepttype_i)
		,.current_inst_address_i  (mem_current_inst_address_i)
		,.is_in_delayslot_i       (mem_is_in_delay_slot_i)
		,.cp0_status_i            (mem_cp0_status_i)
		,.cp0_cause_i             (mem_cp0_cause_i)
		,.cp0_epc_i               (mem_cp0_epc_i)
		,.wb_cp0_reg_we           (wb_cp0_we_i)
		,.wb_cp0_reg_write_address(wb_cp0_waddr_i)
		,.wb_cp0_reg_data         (wb_cp0_data_i)
		,.excepttype_o            (mem_excepttype_o)
		,.current_inst_address_o  (mem_current_inst_address_o)
		,.is_in_delayslot_o       (mem_is_in_delay_slot_o)
		,.cp0_epc_o               (mem_cp0_epc_o)
		);
	//mem_wb
	mem_wb mem_wb0(
		.clk       (clk)		
		,.rst      (resetn)
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
		,.stall    (stall_o)
		//cp0
		,.mem_cp0_reg_we   (mem_cp0_we_o)
		,.mem_cp0_reg_waddr(mem_cp0_waddr_o)
		,.mem_cp0_reg_data (mem_cp0_data_o)
		,.wb_cp0_reg_we    (wb_cp0_we_i)
		,.wb_cp0_reg_waddr (wb_cp0_waddr_i)
		,.wb_cp0_reg_data  (wb_cp0_data_i)
		,.flush            (flush)
		);

	//div
	div div0(
		.rst         	(resetn)
		,.clk        	(clk)
		,.signed_div_i	(signed_div)
		,.opdata1_i   	(opdata1_div)
		,.opdata2_i  	(opdata2_div)
		,.start_i     	(div_start)
		,.annul_i     	(1'b0)
		,.result_o    	(div_result)
		,.ready_o    	(div_ready)
		);

	//cp0
	cp0_reg cp0_reg0(
		.clk        (clk)
		,.rst        (resetn)
		,.we_i       (wb_cp0_we_i)
		,.waddr_i    (wb_cp0_waddr_i)
		,.data_i     (wb_cp0_data_i)
		,.raddr_i    (ex_cp0_reg_raddr_o)
		,.data_o     (ex_cp0_reg_data_i)
		,.int_i      (int)
		,.timer_int_o(timer_int_o)
		,.excepttype_i       (mem_excepttype_o)
		,.current_inst_addr_i(mem_current_inst_address_o)
		,.is_in_delayslot_i  (mem_is_in_delay_slot_o)
		,.status_o           (mem_cp0_status_i)
		,.epc_o              (mem_cp0_epc_i)
		,.cause_o            (mem_cp0_cause_i)
		,.count_o            ()
		,.compare_o          ()
		,.config_o           ()
		,.prid_o             ()
		);
	
endmodule
