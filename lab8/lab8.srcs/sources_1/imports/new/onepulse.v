`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/10/25 23:02:27
// Design Name: 
// Module Name: onepulse
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

module onepulse (PB_debounced, clock, PB_single_pulse);
input PB_debounced;
input clock;
output PB_single_pulse;
reg PB_single_pulse;
reg PB_debounced_delay;
always @(posedge clock)
begin
 if (PB_debounced == 1'b1 & PB_debounced_delay == 1'b0)
    PB_single_pulse <= 1'b1;
 else
   PB_single_pulse <= 1'b0;
PB_debounced_delay <= PB_debounced;
end
endmodule

