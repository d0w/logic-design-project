`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/01/2023 01:33:01 PM
// Design Name: 
// Module Name: paddle_tb
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


module paddle_tb;

    reg endgame, i_clk, i_ani_stb, i_animate;
    reg [1:0] BTN_DIR;
    
    wire [11:0] o_x1;
    wire [11:0] o_x2;
    wire [11:0] o_y1;
    wire [11:0] o_y2;
    
    wire active;
    wire [1:0] com;
    
    wire err;
    
    // check if the points are moving and are moving together
    
    
    // check and set an err flag based on whether or not the paddle is out of bounds.
    parameter width = 30, height = 5, iX = 320, iY = 480, iDir = 0, monitorWidth = 640, monitorHeight = 480;

    rocket #(width, height, iX, iY, iDir, monitorWidth, monitorHeight) 
        p1(endgame, i_clk, i_ani_stb, i_animate, BTN_DIR, o_x1, o_x2, o_y1, o_y2);
    
    
    
    always #5 i_clk = ~i_clk;
    
    
    assign err = o_y1 > monitorHeight || o_y1 < monitorHeight;
        
    initial begin;
        endgame = 0;
        i_clk = 0;
        i_ani_stb = 1;
        i_animate = 1;
        
        BTN_DIR = 0;
        
        #10;
        
        BTN_DIR = 2'b10; // down
        
        #100;
        
        BTN_DIR = 2'b01; // go up;
        
        
        #1000;
        
        BTN_DIR = 2'b00; // no direction
        
        
        #10;
        
        
        
    
        
        
        
        
    end


endmodule