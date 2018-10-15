//global macros
//rst
`define RstEnable 		1'b1			//enable the rst
`define RstDisable 		1'b0			//disbale the rst
`define ZeroWord 		32'h0000_0000	//the 32bit zero
//write
`define WriteEnable 	1'b1			//enable the write signal
`define WriteDisable	1'b0			//disable the wirte signal
//read
`define ReadEnable 		1'b1			//enable the read signal
`define ReadDisable 	1'b0			//disable the read signal
//alu output
`define AluOpBus 		7:0				//the width of op in the decoding stage
`define AluSelBus		2:0				//the width of sel in the decoding stage
//instruction
`define InstValid 		1'b1			//instruction is valid
`define InstInvalid		1'b0			//instruction is invalid
//ture and flase in logic
`define True_v			1'b1			//true in logic
`define False_v			1'b0			//false in logic
//chip
`define ChipEnable 		1'b1			//the chip is enabled
`define ChipDisable 	1'b0			//the chip is disabled


//macros in instructions
`define EXE_ORI 		6'b001101		//code of instruction ORI
`define EXE_NOP			6'b000000		//code of instruction nope
//alu option code
`define EXE_OR_OP		8'b00100101		//option code of instruction ORI in decoding stage
`define EXE_NOP_OP		8'b00000000		//option code of instruction NOP in decoding stage
//alu sel code
`define EXE_RES_LOGIC	3'b001 			//select code of logistic instructions
`define EXE_RES_NOP 	3'b000


//macros in ROM
`define InstAddrBus		31:0			//width of instruction address
`define InstBus 		31:0			//widht of instruction
`define InstMemNum 	    131071			//size of instruction ROM
`define InstMemNumLog2	17				//


//macros in Regfile
`define RegAddrBus		4:0				//width of register address bus
`define RegBus 			31:0			//width of register bus
`define RegWidth 		32				//width of register
`define DoubleRegWidth	64				//width of dual register
`define DoubleRegBus	63:0			//width of dual register bus
`define RegNum			32				//numbre of registers in MIPS
`define RegNumLog2		5				//
`define NOPRegAddr		5'b00000 		//address of nope register