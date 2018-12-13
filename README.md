# ComputerDesignAndOriganization
design a cpu with verilog according to the book《自己动手写CPU》

vivado version: 2018.1

text editor: sublime-text 3

operating system: linux 18.01

**2018.12.7**
1. branch instructions
	- modified ex.v
2. test branch instructions
	- created test_jump_inst.coe 
	- problems
		- no else condition in the pc_reg.v, which contributes to an error jump
	- solutions
		- added the else in the pc_reg.v

**2018.12.6**
1. added branch instructions 
	- modified define.vh, id.v,

**2018.12.4**
1. added div instruction
	- created div.v
	- modified define.vh, id.v, ex.v
		- added the opcode 
2. tested div instructions
	- created test_div_inst.coe 
	- problems
		- the temp_op1 and temp_op2 is unblocked assignment in the div.v
		- get into the div_end state incorrectly
	- solutions 
		- have them turned into blocked assignment
		- reposition the state change code in the divon state


**2018.12.3**
1. tested madd and msub instructions
	- created test_maddandmsub_inst.coe

**2018.11.26**
1. tested nop and shift instructions
	- modified test_nop_shift_inst.coe
2. tested move instructions
	- modified test_move_inst.coe
	- problems
		- the wire ex_whilo_o mistaked to ex_whilo_0
	- solutions
		- correct it
3. tested arithmetic instructions
	- created test_arithmeticl_inst.coe
	- problems
		- erros occured when carry out slti instruction 
		- ex.opdata1_mult and opdata2_mult error, assign failed
	- solutions
		- add the EXE_SLTI_OP in ex.v
		- correct the assign 

**2018.11.25**
1. added the stall mechanism
	- created ctrl.v
	- modified define.vh, ex.v, ex_mem.v, id.v, id_ex.v, mem_wb.v, openmips.v, pc_reg.v
		- added stall conditions


**2018.11.24**
1. added the arithmetic instructions
	- modified define.vh
		- added the opcode and selcode
	- modified id.v
		- added the decode stage of each instruction
	- modified ex.v

**2018.11.23**
1. added the move instructions
	- modified define.vh
		- added the opcode and selcode
	- created hilo_reg.v
	- modified id.v
	- modified ex.v
	- modified ex_mem.v
	- modified mem.v
	- modified mem_wb.v
	- modified openmipsl.v
		- added the wires 

**2018.11.15**
1. tested the first part of nop and shift instructions
	- created test_nop_shift_inst.coe
	- interupt the fisrt part of nop and shift instuctions from assembly language to binary
	- problems
		- when execute sllv $2, $2, $7, the reg2_addr_o is 12 while 2 is correct
	- solutions
		- error occured when interupt this instruction: 00f21004->00e21004

**2018.11.13**
1. tested the logical instructions
	- created test_logc_inst.coe

**2018.11.11**
1. finished the execution stage of added instructions
	- modified the ex.v

**2018.11.10**
1. finished the decode stage of added instructions
	- modified the id.v 

**2018.11.08**
1. finished the simulation of data forwarding
	- modified the id.v to add data forwarding 
		- added the input from stage ex and mem
		- added the code of data forwarding in the registers assignment
			- added in the front of the normal data passing 
		- added the wires to implement data forwarding in the open_mips
2. added some instructions 
	- modified the define.vh
		- added the opcode and exe code for these instructions
		- added the res code for these instructions
	- modified the id.v
		- added the instructions of special op code
