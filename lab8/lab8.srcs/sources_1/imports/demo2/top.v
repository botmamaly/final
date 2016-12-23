module top(
   input clk,
   input rst,
   input dir,
   input en,
   output [3:0] vgaRed,
   output [3:0] vgaGreen,
   output [3:0] vgaBlue,
   output hsync,
   output vsync
    );

    wire [11:0] data;
    wire clk_25MHz;
    wire clk18, clk19, clk20, clk21, clk22, clk23, clk24;
    wire [16:0] pixel_addr;
    wire [11:0] pixel_1;
    wire [11:0] pixel_2;
    wire [11:0] pixel_3;
    wire valid;
    wire [9:0] h_cnt; //640
    wire [9:0] v_cnt;  //480

    
    wire db_rst ,op_rst, op_en, db_en;
    debounce dbrst(db_rst,rst,clk);
	debounce dben(db_en,en,clk);
    onepulse oprst(db_rst,clk,op_rst);
	onepulse open(db_en,clk,op_en);
    assign {vgaRed, vgaGreen, vgaBlue} = (valid==1'b1 && h_cnt < 10'd220 && h_cnt >= 10'd20) ? pixel_1 :
                                         (valid==1'b1 && h_cnt < 10'd420 && h_cnt >= 10'd220) ? pixel_2 :
                                         (valid==1'b1 && h_cnt < 10'd620 && h_cnt >= 10'd420) ? pixel_3 :
                                         12'd0;
    
    clock_divisor clk_wiz_0_inst(
        .clk(clk),
        .clk1(clk_25MHz),
        .clk18(clk18),
		.clk19(clk19),
		.clk20(clk20),
		.clk21(clk21),
		.clk22(clk22),
		.clk23(clk23),
		.clk24(clk24)
    );
    
    
    mem_addr_gen mem_addr_gen_inst(
        .clk18(clk18),
		.clk19(clk19),
		.clk20(clk20),
		.clk21(clk21),
		.clk22(clk22),
		.clk23(clk23),
		.clk24(clk24),
		.clk(clk),
        .rst(op_rst),
        .en(op_en),
        .h_cnt(h_cnt),
        .v_cnt(v_cnt),
        .pixel_addr(pixel_addr)//output which is the pixel in memory
    );
    
   blk_mem_gen_0 blk_mem_gen_0_inst(//1st pic
        .clka(clk_25MHz),
	    .wea(0),
        .addra(pixel_addr),
        .dina(data[11:0]),
        .douta(pixel_1)
   );
   
   blk_mem_gen_1 blk_mem_gen_1_inst(//2nd pic
        .clka(clk_25MHz),
        .wea(0),
        .addra(pixel_addr),
        .dina(data[11:0]),
        .douta(pixel_2)
   );
   blk_mem_gen_2 blk_mem_gen_2_inst(//3rd pic
        .clka(clk_25MHz),
        .wea(0),
        .addra(pixel_addr),
        .dina(data[11:0]),
        .douta(pixel_3)//output cur pixel's rgb
    );
    vga_controller   vga_inst(//output the current hor and vertical
          .pclk(clk_25MHz),
          .reset(rst),
          .hsync(hsync),
          .vsync(vsync),
          .valid(valid),
          .h_cnt(h_cnt),
          .v_cnt(v_cnt)
    );
      
endmodule
