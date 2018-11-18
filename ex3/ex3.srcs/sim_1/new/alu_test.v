`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/18 14:56:18
// Design Name: 
// Module Name: alu_test
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


module alu_test(

    );
	reg [31:0] srca, srcb;
	reg [2:0] alucontrol;
	wire [31:0] aluout;
	wire overflow, zero;
	initial begin
		#0 srca = 32'h0010;
		#5 srcb = 32'h0100;
		#5 alucontrol = 3'b000;
		#5 alucontrol = 3'b001;
		#5 alucontrol = 3'b010;
		#5 alucontrol = 3'b011;
		#5 alucontrol = 3'b100;
		#5 alucontrol = 3'b101;
		#5 srcb = 32'h0010;
		#5 alucontrol = 3'b001;
	end // initial
	alu alu0(srca, srcb, alucontrol, aluout, overflow, zero);
endmodule
