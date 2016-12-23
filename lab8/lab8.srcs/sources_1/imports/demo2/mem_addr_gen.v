module mem_addr_gen(
   input clk18,
   input clk19,
   input clk20,
   input clk21,
   input clk22,
   input clk23,
   input clk24,
   input clk,
   input rst,
   input en,
   input [9:0] h_cnt,
   input [9:0] v_cnt,
   output [16:0] pixel_addr
   );
   
   reg [7:0] position1;
   reg [7:0] position2;
   reg [7:0] position3;
   assign pixel_addr = (h_cnt < 10'd220) ? ((h_cnt>>1)+ 100*(v_cnt>>1) + position1*100 )% 24000
           : (h_cnt < 10'd420 && h_cnt >= 10'd220) ? ( ((h_cnt - 10'd220) >> 1)+ 100 * (v_cnt>>1)  + position2*100 )% 24000
           : ( ((h_cnt - 10'd420) >> 1)+ 100 * (v_cnt>>1)  + position3*100 )% 24000;
   
   wire [3:0] clk1_index, clk2_index, clk3_index;
   wire clk1_en, clk2_en, clk3_en;
   
   
   clock_index_generator clk1_in_gen(clk, rst, en, 4'd8, clk1_index, clk1_en, en);
   clock_index_generator clk2_in_gen(clk, rst, clk1_en, 4'd7, clk2_index, clk2_en, en);
   clock_index_generator clk3_in_gen(clk, rst, clk2_en, 4'd6, clk3_index, clk3_en, en);
   
   wire clk1, clk2, clk3;
   clock_selector clk_sel_pic1(clk1_index, clk, clk18, clk19, clk20, clk21, clk22, clk23, clk_1);
   always @ (posedge clk_1 or posedge rst) begin
       if(rst)
          position1 <= 0;
       else if(position1 < 239)
          position1 <= position1 + 1;
       else
          position1 <= 0;
   end
   
   clock_selector clk_sel_pic2(clk2_index, clk, clk18, clk19, clk20, clk21, clk22, clk23, clk_2);
   always @ (posedge clk_2 or posedge rst) begin
       if(rst)
          position2 <= 0;
       else if(position2 < 239)
          position2 <= position2 + 1;
       else
          position2 <= 0;
   end
   
   clock_selector clk_sel_pic3(clk3_index, clk, clk18, clk19, clk20, clk21, clk22, clk23, clk_3);
   always @ (posedge clk_3 or posedge rst) begin
      if(rst)
          position3 <= 0;
      else if(position3 < 239)
          position3 <= position3 + 1;
      else
          position3 <= 0;
   end
     
endmodule
