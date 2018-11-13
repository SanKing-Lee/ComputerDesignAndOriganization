# ComputerDesignAndOriganization
design a cpu with verilog according to the book《自己动手写CPU》

vivado version: 2018.1

text editor: sumblime-text 3

operating system: linux 18.01

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
