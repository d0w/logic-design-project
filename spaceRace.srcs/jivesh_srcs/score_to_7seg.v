`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/05/2020 09:23:35 PM
// Design Name: 
// Module Name: score_to_7seg
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


module score_to_7seg(
    input wire clk, // input clock
    input wire [8:0] currscore,
    input wire [8:0] currscore2, // input score
    output reg [7:0] anode, // output anode
    output reg [6:0] segment // output segment
    );
    
    wire [7:0] bcd_score,bcd_score2; // score in BCD
    dec_bcd bcd(.bin(currscore),.bin2(currscore2), .bcd(bcd_score),.bcd2(bcd_score2)); // BCD decoder instance
    //dec_bcd bcd2(.bin(currscore2), .bcd(bcd_score2)); // BCD decoder instance

    
    wire [3:0] score1 = bcd_score[7:4]; // assign first 4 bits
    wire [3:0] score2 = bcd_score[3:0]; // assign last 4 bits
    
    wire [3:0] score3 = bcd_score2[7:4]; // assign first 4 bits
    wire [3:0] score4 = bcd_score2[3:0]; // assign last 4 bits
    
    wire [6:0] hseg1, hseg2,hseg3,hseg4; // first and second digit anodes
    
    num_hex hex1(.clk(clk), .bnum(score1), .hex_seg(hseg1)); // hex decoder instance
    num_hex hex2(.clk(clk), .bnum(score2), .hex_seg(hseg2)); // hex decoder instance
    num_hex hex3(.clk(clk), .bnum(score3), .hex_seg(hseg3)); // hex decoder instance
    num_hex hex4(.clk(clk), .bnum(score4), .hex_seg(hseg4)); // hex decoder instance
    reg counter = 0; // counter to get timing
    
    always @(posedge clk) begin
        case (counter)
            0: begin
                anode <= 8'b11111101; // first anode
                segment <= hseg2;
            end
            1: begin 
                anode <= 8'b01111111; // second anode
                segment <= hseg4;
            end
        
        endcase
        
        counter <= counter + 1;
        if (counter == 2) begin 
            counter <= 0;
        end
     end
    
endmodule
