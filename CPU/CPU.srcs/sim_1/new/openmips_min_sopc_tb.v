`timescale 1ns / 1ps
`include "define.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/10/23 15:49:59
// Design Name: 
// Module Name: openmips_min_spoc_tb
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


module openmips_min_sopc_tb(

    );

	reg CLOCK_50 = 0;
	reg rst = 1;
	always #5 CLOCK_50 = ~CLOCK_50;
	initial begin
		#25 rst = `RstDisable;
	end // initial

    openmips_min_sopc openmips_min_sopc0(.clk(CLOCK_50),.rst(rst));
endmodule
