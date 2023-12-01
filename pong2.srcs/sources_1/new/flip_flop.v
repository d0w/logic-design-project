`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/09/2020 12:26:40 AM
// Design Name: 
// Module Name: flip_flop
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


module flip_flop(
    input wire clk,
    input wire reset,
    input wire D,
    output reg Q
    );
    
    always @(posedge clk or posedge reset) begin
        if (reset == 1'b1) begin
            #2 Q = 1'b0;
        end
        else begin
            Q = #3 D;
        end
    end
endmodule
