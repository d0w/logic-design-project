`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/29/2023 03:27:55 PM
// Design Name: 
// Module Name: rocket
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


module rocket
#(
    P_WIDTH=5,     // half the paddle width
    P_HEIGHT=10,     // half the paddle height     
    IX=160,         // initial horizontal position of square centre
    IY=480,         // initial vertical position of square centre
    IX_DIR=0,       // initial horizontal direction: 0 idle, 1 is left, 2 is right
    D_WIDTH=640,    // width of display
    D_HEIGHT=480    // height of display
    )
    (
    input wire endgame,       // end game flag
    input wire i_clk,         // base clock
    input wire i_ani_stb,     // animation clock: pixel clock is 1 pix/frame
    input wire i_animate,     // animate flag 
    input wire [7:0] keycode,     // bit 0 - right, bit 1 - left
    output reg [11:0] o_x1,  // square left edge: 12-bit value: 0-4095
    output reg [11:0] o_x2,  // square right edge
    output reg [11:0] o_y1,  // square top edge
    output reg [11:0] o_y2,   // square bottom edge
    output wire active,     // active button flag
    output wire [7:0] com,  // paddle direction
    output reg [8:0] lives
    );
    
    assign com = keycode; // pass paddle direction to output
    //assign active = BTN_DIR[0] | BTN_DIR[1]; // check if button is pressed when game over state
    
    reg [8:0] L = 5;
    reg [11:0] x = IX;   // horizontal position of square centre
    reg [11:0] y = IY;   // vertical position of square centre
    
    reg[2:0] btnPress;
    reg[1:0] movement; 
    
    always @ (posedge i_clk)
    begin
        if (endgame)  // on reset return to starting position
        begin
            x <= IX; // intialize x direction
            y <= IY; // intialize y direction
        end
        if (i_animate & i_ani_stb & !endgame) begin
            if (keycode == 8'h1B & o_y2<=D_HEIGHT) begin// up button pressed
                btnPress <= 1;
                movement <= 1;
            end
            else if (keycode == 8'h1D & o_y1>=10) begin// down button pressed
                btnPress <= 2;
                movement <= 2;
            end
            else if (keycode == 8'h1C & o_y1>=10) begin// down button pressed
                btnPress <= 3;
                movement <= 0;
            end
           else
                btnPress <= 4;
            end 
        else
        btnPress <= 0;

    // Move paddle based on button press
    if(btnPress) begin
    if (movement == 1 && o_y2<=D_HEIGHT-5) begin
        //if (keycode == 8'h1B & o_y2<=D_HEIGHT-5 || keycode == 8'h72 & o_y2<=D_HEIGHT-5 || keycode == 8'h75 & o_y2<=D_HEIGHT-5) // down button pressed
            y <= y + 10; // move paddle downwards
    end
    else if (movement == 2 && o_y1>=10) begin
        //if (keycode == 8'h1D & o_y1>=10 || keycode == 8'h72 & o_y1>=10 || keycode == 8'h75 & o_y1>=10) // up button pressed
            y <= y - 10; // move paddle upwards
    end
    end
    end
    
    always @(*)
    begin
        o_x1 = x - P_WIDTH;  // left edge
        o_x2 = x + P_WIDTH;  // right edge
        o_y1 = y - P_HEIGHT;  // top edge
        o_y2 = y + P_HEIGHT;  // bottom edge
        
        lives = L;
    end
    
endmodule