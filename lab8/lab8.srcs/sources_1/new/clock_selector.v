`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/12/20 15:35:58
// Design Name: 
// Module Name: clock_selector
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


module clock_selector(flag, clk, clk18, clk19, clk20, clk21, clk22, clk23, now_clk);
input clk, clk18, clk19, clk20, clk21, clk22, clk23;
input [3:0]flag;
output now_clk;
assign now_clk = (flag == 4'd8) ? clk18 :
                 (flag == 4'd7) ? clk19 :
				 (flag == 4'd6) ? clk20 :
				 (flag == 4'd5) ? clk21 :
				 (flag == 4'd4) ? clk22 :
				 (flag == 4'd3) ? clk23 :
				 1'b0;
endmodule
