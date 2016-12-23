`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/12/20 20:56:39
// Design Name: 
// Module Name: clock_index_generator
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


module clock_index_generator(clk, rst, en, init_clk_index, clk_index, next_en, restart);
   input clk;
   input rst;
   input en;
   input restart;
   input [3:0]init_clk_index;
   output [3:0]clk_index;
   output next_en;
   
   
   reg [1:0] now_state;
   reg [1:0] next_state;
   reg [31:0] counter;//counter when to slow the speed
   reg [31:0] next_counter;
   parameter ROLL = 2'b00;
   parameter SLOW = 2'b01;
   parameter STOP = 2'b11;
     
   reg [3:0]now_index;//clk index
   reg [3:0]next_index;//next clk index
   
   assign next_en = (now_state == STOP) ? 1 : 0;
   assign clk_index = now_index;
   
   always @ (posedge clk or posedge rst)//slow the scrolling
   begin
       if(rst)
	      begin
	       now_state <= ROLL;
		   now_index <= init_clk_index;
		   counter <= 32'h0;
	      end
	   else
	     begin
	       now_index <= next_index;
		   now_state <= next_state;
		   counter <= next_counter;
	     end
   end
   
   always @(*)
   begin
      case(now_state)
		  ROLL:
		  begin
		      next_index = now_index;
			  next_counter = counter;
		      if(en)
			  begin
			    next_state = SLOW;
			  end
		      else
			  begin
			    next_state = ROLL;
			  end
		  end
		  SLOW:
		  begin
			  if(now_index < 4'd3)
			  begin
			    next_state = STOP;
				next_index = 4'd0;
				next_counter = counter;
		      end
			  else if(counter >= 32'h0111_1111_1111_1111_1111_1111_1111_1111)
			  begin
			    next_state = SLOW;
				next_index = now_index - 1;
				next_counter = 32'h0;
			  end
			  else
			  begin
			    next_state = SLOW;
				next_index = now_index;
				next_counter = counter + 1;
			  end
		  end
          STOP:
          begin
			 if(restart)
			 begin
			    next_state = ROLL;
				next_index = init_clk_index;
				next_counter = 32'h0;
			 end
			 else
			 begin
			    next_state = STOP;
				next_index = 4'd0;
				next_counter = counter;
			 end
          end		  
	  endcase
   end
   
endmodule