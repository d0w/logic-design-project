`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/05/2020 08:49:59 AM
// Design Name: 
// Module Name: vga_clock_gen
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


module vga_clock_gen
    #
    (
    MULT_MASTER = 31.5, // master clock multiplier
    DIV_MASTER=5, // master clock divider
    DIV_PIX=25, // pixel clock divider
    IN_PERIOD=10.0 // period of master clock in ns
    )
    (
    input clk, // input clock
    input rst, // reset
    output pix_clk, // pixel clock
    output loc_clk // generated clocks locked
    );
    
    wire clk_fb; // clock feedback
    wire clk_pix_unbuf; // unbuffered pixel clock
    wire locked; // unsynced lock signal
    
    
    
endmodule
