//global macros
//rst
`define RstEnable 			1'b1			//enable the rst
`define RstDisable 			1'b0			//disbale the rst
`define ZeroWord 			32'h0000_0000	//the 32bit zero
//write
`define WriteEnable 		1'b1			//enable the write signal
`define WriteDisable		1'b0			//disable the wirte signal
//read
`define ReadEnable 			1'b1			//enable the read signal
`define ReadDisable 		1'b0			//disable the read signal
//alu output
`define AluOpBus 			7:0				//the width of op in the decoding stage
`define AluSelBus			2:0				//the width of sel in the decoding stage
//instruction
`define InstValid 			1'b1			//instruction is valid
`define InstInvalid			1'b0			//instruction is invalid
//ture and flase in logic
`define True_v				1'b1			//true in logic
`define False_v				1'b0			//false in logic
//chip
`define ChipEnable 			1'b1			//the chip is enabled
`define ChipDisable 		1'b0			//the chip is disabled


//macros in instructions
//logical instructions
`define EXE_NOP				6'b000000		//code of instruction nope
`define EXE_AND 			6'b100100
`define EXE_OR 				6'b100101
`define EXE_XOR				6'b100110
`define EXE_NOR				6'b100111
`define EXE_ANDI 			6'b001100
`define EXE_ORI 			6'b001101
`define EXE_XORI			6'b001110
`define EXE_LUI				6'b001111

//shift instructions
`define EXE_SLL				6'b000000 		//shift left logically
`define EXE_SLLV			6'b000100       
`define EXE_SRL 			6'b000010
`define EXE_SRLV 			6'b000110 
`define EXE_SRA				6'b000011 
`define EXE_SRAV 			6'b000111

//specail instructions
`define EXE_SYNC 			6'b001111 
`define EXE_PREF 			6'b110011
`define EXE_SPECIAL_INST 	6'b000000
//alu option code
`define EXE_NOP_OP			8'b00000000		//option code of instruction NOP in decoding stage
`define EXE_AND_OP			8'b00100100
`define EXE_OR_OP			8'b00100101		//option code of instruction ORI in decoding stage
`define EXE_XOR_OP			8'b00100110			
`define EXE_NOR_OP			8'b00100111
`define EXE_SLL_OP 			8'b00000000
`define EXE_SLLV_OP			8'b00000100
`define EXE_SRL_OP			8'b00000010
`define EXE_SRLV_OP			8'b00000110
`define EXE_SRA_OP			8'b00000011
`define EXE_SRAV_OP			8'b00000111
`define EXE_SYNC_OP			8'b00001111
`define EXE_PREF_OP			8'b00110011
//alu sel code
`define EXE_RES_NOP 		3'b000
`define EXE_RES_LOGIC		3'b001 			//select code of logistic instructions
`define EXE_RES_SHIFT		3'b010 


//macros in ROM
`define InstAddrBus			31:0			//width of instruction address
`define InstBus 			31:0			//widht of instruction
`define InstMemNum 	  	  	131071			//size of instruction ROM
`define InstMemNumLog2		17				//


//macros in Regfile
`define RegAddrBus			4:0				//width of register address bus
`define RegBus 				31:0			//width of register bus
`define RegWidth 			32				//width of register
`define DoubleRegWidth		64				//width of dual register
`define DoubleRegBus		63:0			//width of dual register bus
`define RegNum				32				//numbre of registers in MIPS
`define RegNumLog2			5				//
`define NOPRegAddr			5'b00000 		//address of nope register