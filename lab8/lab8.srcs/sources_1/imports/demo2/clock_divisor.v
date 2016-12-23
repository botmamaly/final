module clock_divisor(clk1, clk, clk18, clk19, clk20, clk21, clk22, clk23, clk24);
input clk;
output clk1, clk18, clk19, clk20, clk21, clk22, clk23, clk24;

reg [21:0] num;
wire [21:0] next_num;

always @(posedge clk) begin
  num <= next_num;
end

assign next_num = num + 1'b1;

assign clk1 = num[1];
assign clk18 = num[17];
assign clk19 = num[18];
assign clk20 = num[19];
assign clk21 = num[20];
assign clk22 = num[21];
assign clk23 = num[22];
assign clk24 = num[23];
endmodule
