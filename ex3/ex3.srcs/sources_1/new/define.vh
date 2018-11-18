`define RstEnable 				1'b1
`define RstDisable 				1'b0

`define InstEnable 				1'b1
`define InstDisable 			1'b0

`define ALUCONTROL_ADD 			3'b010
`define ALUCONTROL_SUB 			3'b110
`define ALUCONTROL_AND 			3'b000 
`define ALUCONTROL_OR			3'b001 
`define ALUCONTROL_AANDNOTB		3'b100 
`define ALUCONTROL_AORNOTB		3'b101
`define ALUCONTROL_SLT 			3'b111

`define OP_RTYPE 				6'b000000
`define OP_LW					6'b100011
`define OP_SW					6'b101011
`define OP_BEQ 					6'b000100
`define OP_ADDI					6'b001000
`define OP_J					6'b000010
