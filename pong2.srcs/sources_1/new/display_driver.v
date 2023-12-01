`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/05/2020 08:43:32 AM
// Design Name: 
// Module Name: display_driver
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


module display_driver(
    input clk, // pixel clock
    input rst, // reset
    output reg [9:0] sx, // horizontal screen position
    output reg [9:0] sy, // vertical screen position
    output reg VGA_HS, // horizontal sync
    output reg VGA_VS, // vertical sync
    output reg de // data enable
    );
    
     // horizontal timings
    parameter HA_END = 639;          // end of active pixels
    parameter HS_STA = HA_END + 16;  // sync starts after front porch
    parameter HS_END = HS_STA + 96;  // sync ends
    parameter LINE   = 799;          // last pixel on line (after back porch)

    // vertical timings
    parameter VA_END = 479;          // end of active pixels
    parameter VS_STA = VA_END + 10;  // sync starts after front porch
    parameter VS_END = VS_STA + 2;   // sync ends
    parameter SCREEN = 524;          // last line on screen (after back porch)
    
    always @(*)
    begin
        VGA_HS = ~(sx >= HS_STA && sx < HS_END);  // invert: hsync polarity is negative
        VGA_VS = ~(sy >= VS_STA && sy < VS_END);  // invert: vsync polarity is negative
        de = (sx <= HA_END && sy <= VA_END);
    end
    
    always @ (posedge clk)
    begin
        if (sx == LINE) begin  // last pixel on line?
            sx <= 0;
            sy <= (sy == SCREEN) ? 0 : sy + 1;  // last line on screen?
        end else begin
            sx <= sx + 1;
        end
        if (rst) begin
            sx <= 0;
            sy <= 0;
        end
    end
    
endmodule
