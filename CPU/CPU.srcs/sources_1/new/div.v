`timescale 1ns / 1ps
`include "define.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/04 21:07:26
// Design Name: 
// Module Name: div
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


module div(
	input wire rst, clk,
	//signed division or not
	input wire signed_div_i, 
	//dividend
	input wire[`RegBus] opdata1_i,
	//divisor
	input wire[`RegBus] opdata2_i,
	//start division or not
	input wire start_i,
	//cancel division or not
	input wire annul_i,
	output reg[`DoubleRegBus] result_o,
	output reg ready_o
    );
	wire[32:0] div_temp;
	reg[5:0] cnt;
	reg[64:0] dividend;
	reg[1:0] state;
	reg[31:0] divisor;
	reg[31:0] temp_op1;
	reg[31:0] temp_op2;

	//store the result of subscreement
	assign div_temp = {1'b0, dividend[63:32]} - {1'b0, divisor};

	always@(posedge clk) begin
		if(rst == `RstEnable) begin
			state <= `DivFree;
			ready_o <= `DivResultNotReady;
			result_o <= {`ZeroWord, `ZeroWord};
		end // if(rst == `RstEnable)
		else begin
			case(state)
				//initialization
				`DivFree: begin
					//start division
					if(start_i == `DivStart && annul_i == 1'b0) begin
						//divided by zero
						if(opdata2_i == `ZeroWord) begin
							state <= `DivByZero;
						end // if(opdata2_i == `ZeroWord)
						else begin
							state <= `DivOn;
							cnt <= 6'b000000;
							//signed division and negative dividend
							if(signed_div_i == 1'b1 && opdata1_i[31] == 1'b1) begin
								temp_op1 = ~opdata1_i + 1;
							end
							else begin
								temp_op1 = opdata1_i;
							end // else
							//signed division and negative divisor
							if(signed_div_i == 1'b1 && opdata2_i[31] == 1'b1) begin
								temp_op2 = ~opdata2_i + 1;
							end // if(signed_div_i == 1'b1 && opdata2_i[31]==1'b1})
							else begin
								temp_op2 = opdata2_i;
							end // else
							dividend <= {`ZeroWord, `ZeroWord};
							dividend[32:1] <= temp_op1;
							divisor <= temp_op2;
						end // else
					end // if(start_i == `DivStart && annul_i == 1'b0)
					else begin
						ready_o <= `DivResultNotReady;
						result_o <= {`ZeroWord, `ZeroWord};
					end // else
				end
				`DivByZero: begin
					dividend <= {`ZeroWord, `ZeroWord};
					state <= `DivEnd;
				end
				`DivOn: begin
					if(annul_i == 1'b0) begin
						if(cnt != 6'b100000) begin
							if(div_temp[32] == 1'b1) begin
								dividend <= {dividend[63:0], 1'b0};
							end // if(div_temp[32] == 1'b1)
							else begin
								dividend <= {div_temp[31:0], dividend[31:0], 1'b1};
							end // else
							cnt <= cnt+1;
						end // if(cnt != 6'b100000)
						//finished division
						else begin
							//signed division, one positive, another negative, get the complement
							if((signed_div_i == 1'b1) && ((opdata1_i[31]^opdata2_i[31]) == 1'b1)) begin
								dividend[31:0] <= (~dividend[31:0] + 1);
							end // if((signed_div_i==1'b1) && ((opdata1_i[31]^opdata2_i[31]) == 1'b1))
							if((signed_div_i == 1'b1) && ((opdata1_i[31]^dividend[64]) == 1'b1)) begin
								dividend[64:33] <= (~dividend[64:33] + 1);
							end // if((signed_div_i == 1'b1) && ((opdata1_i[31]^dividend[64]) == 1'b1))
							state <= `DivEnd;
							cnt <= 6'b000000;
						end // else
					end // if(annul_i == 1'b0)
					//division canceled
					else begin
						state <= `DivFree;
					end // else
				end
				`DivEnd: begin
					result_o <= {dividend[64:33], dividend[31:0]};
					ready_o <= `DivResultReady;
					if(start_i <= `DivStop) begin
						state <= `DivFree;
						ready_o <= `DivResultNotReady;
						result_o <= {`ZeroWord, `ZeroWord};
					end // if(start_i <= `DivStop)
				end
				default: begin
					state <= `DivFree;
					ready_o <= `DivResultNotReady;
					result_o <= {`ZeroWord, `ZeroWord};
				end // default:
			endcase // state
		end // else
	end // always@(posedge clk) 
	
endmodule
