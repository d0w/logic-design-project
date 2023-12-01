`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/05/2020 11:07:06 PM
// Design Name: 
// Module Name: currentscore
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


module currentscore(
    input wire rst,
    input wire clk,
    input wire collision, 
    output reg [7:0] scorecounter = 0
    );
    
    reg ctr = 0;
         
    always @(posedge clk or posedge rst) begin 
        if (collision) begin 
            ctr <= ctr  + 1; 
        end
        if (rst) begin
            ctr <= 0;
        end
    end
    
    always @(posedge clk) 
    begin
        scorecounter <= ctr;   
     end 
    
endmodule
