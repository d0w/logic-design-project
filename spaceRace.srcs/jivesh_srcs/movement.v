`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/05/2023 07:33:14 PM
// Design Name: 
// Module Name: movement
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


module movement(
    input wire  reset, 
     input wire i_clk,         // base clock
    input wire i_ani_stb,     // animation clock: pixel clock is 1 pix/frame
    input wire i_animate,     // animate flag 
    input wire [1:0] BTN_DIR, 
    output reg hit, miss,
    output reg [2:0] rgb
    );
    
    localparam MAX_X = 640;
    localparam MAX_Y = 480;
    localparam D_WIDTH=640;    // width of display
    localparam D_HEIGHT=480;    // height of display
    localparam current_x_paddle_left = 600;
    localparam IY = 240;
    localparam  P_HEIGHT=10;
    localparam Ball_v_p = 2;
    localparam Ball_v_n = -2;
    reg [11:0] current_y_paddle;
    reg [11:0] next_y_paddle;
    reg [11:0] ball_x_left, ball_x_right;
    reg [11:0] ball_y_top, ball_y_bottom;
    reg [11:0] ball_x_reg, ball_y_reg;
    reg [11:0] ball_x_next, ball_y_next;
    
    always @(posedge i_clk,posedge reset)
     if (reset)
       begin
         ball_x_reg <= 0;
         ball_y_reg<= 0; 
         end
     if (i_animate && i_anti_stb)
     always @(*)
       begin
       current_y_paddle <= next_y_paddle;
       end
     
           
    
    
endmodule
