`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/09/2020 12:26:40 AM
// Design Name: 
// Module Name: mux
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


module mux(
    input wire ctrl,
    input wire a,
    input wire b,
    output reg out
    );
    
    wire w1, w2, w3, w4;
    
    and (w1, b, ctrl);
    not (w3, ctrl);
    and (w2, a, w3);
    or (w4, w1, w2);
    
    always @(ctrl or w3 or a or b) begin
        out = (ctrl & a) | (w3 & b);
    end
    
endmodule