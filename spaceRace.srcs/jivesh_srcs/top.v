`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/29/2023 04:02:09 PM
// Design Name: 
// Module Name: top
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


module top(
    input wire CLK, // 100 Mhz clock
    input wire RST_BTN, // reset button
    input wire [1:0] BTN_LU,
    input wire [1:0] BTN_DR,
    input wire PS2_CLK, // left and right buttons
    input wire PS2_DATA, // left and right buttons
    input wire BTNC, // mode change button
    input wire switch,
    output reg VGA_HS, // horizontal sync
    output reg VGA_VS, // vertical sync
    output reg [3:0] VGA_R, // red channels
    output reg [3:0] VGA_G, // green channels
    output reg [3:0] VGA_B, // blue channels
    output reg [6:0] seg, // 7-segment segments 
    output reg [7:0] AN // 7-segment anodes
    );
    
    wire [3:0] vga_r, vga_g, vga_b; // pong game vga
    wire [3:0] vga_r_end, vga_g_end, vga_b_end; // game over menu vga
    wire [3:0] vga_r_start, vga_g_start, vga_b_start; // start menu vga 

    wire vga_hs, vga_vs; // pong game horizontal and vertical sync
    wire vga_h_start, vga_v_start; // start menu horizontal and vertical sync
    wire vga_h_end, vga_v_end; // game over menu horizontal and vertical sync

    
    wire [6:0] c_seg, h_seg; // current score segments
    wire [7:0] c_anode, h_anode; // high score segments
    
    wire [8:0] p1Lives, p2Lives; // current score bits
    wire slow_clk; // 7-segment clock 
    
    wire endgame; // game over flag
    wire [1:0] mode; // mode 0 - start menu, 1 - pong 
    assign endgame = 0;
    
    wire [31:0]keycode;
    
    PS2Receiver keyboard(
    .clk(CLK),
    .kclk(PS2_CLK),
    .kdata(PS2_DATA),
    .keycodeout(keycode[31:0])
    );
    
    clock_divider #(.DIVISOR(500000)) clk600Hz(.clk_in(CLK), .clk_out(slow_clk));  // create 200 Hz clock for seven segment display
    
    game spaceRace(.mode(mode), .CLK(CLK), .keycode(keycode[7:0]), .BTN_LU(BTN_LU),.BTN_DR(BTN_DR), .VGA_HS(vga_hs), .VGA_VS(vga_vs), 
    .VGA_R(vga_r), .VGA_G(vga_g), .VGA_B(vga_b), .endgame(endgame), .lives1(p1Lives), .lives2(p2Lives),.switch(switch) ); // initialize pong game
    
//    menu_screen(.mode(mode), .CLK(CLK), .VGA_HS(vga_h_start), .VGA_VS(vga_v_start), 
//    .VGA_R(vga_r_start), .VGA_G(vga_g_start), .VGA_B(vga_b_start)); // start menu driver
    
    //bg_gen #(.MEMFILE("gameover.mem"), .PALETTE("gameover_palette.mem")) end_screen(.CLK(CLK), .RST_BTN(RST_BTN), .VGA_HS(vga_h_end), 
   // .VGA_VS(vga_v_end), .VGA_R(vga_r_end), .VGA_G(vga_g_end), .VGA_B(vga_b_end)); // game over menu driver
            
    score_to_7seg lives(.clk(slow_clk), .currscore(p1Lives),.currscore2(p2Lives), .anode(c_anode), .segment(c_seg)); // current score to 7-segment display
//    score_to_7seg highest(.clk(slow_clk), .currscore(highest_score), .anode(h_anode), .segment(h_seg)); // high score to 7-segment display
    
    incrementer change_mode(.CLK(CLK), .btn(BTNC), .duty(mode)); // change mode
    
     always @(*)
    begin
        case(mode)
            0: begin
                //{seg, AN, VGA_HS, VGA_VS, VGA_R, VGA_G, VGA_B} = {h_seg, h_anode, vga_h_start, vga_v_start, vga_r_start, vga_g_start, vga_b_start}; // start menu
                 {seg, AN, VGA_R, VGA_G, VGA_B, VGA_HS, VGA_VS} = {c_seg, c_anode, vga_r, vga_g, vga_b, vga_hs, vga_vs};
            end
            1:begin 
                if (!endgame) begin // if game over flag not triggered
                    {seg, AN, VGA_R, VGA_G, VGA_B, VGA_HS, VGA_VS} = {c_seg, c_anode, vga_r, vga_g, vga_b, vga_hs, vga_vs}; // pong game
                end
                else begin // if game over flag triggered
                     {AN, VGA_R, VGA_G, VGA_B, VGA_HS, VGA_VS} = {8'b11111111 ,vga_r_end, vga_g_end, vga_b_end, vga_h_end, vga_v_end}; // game over screen
                end
            end
            2: {seg, AN, VGA_R, VGA_G, VGA_B, VGA_HS, VGA_VS} = {c_seg, c_anode, vga_r, vga_g, vga_b, vga_hs, vga_vs}; // pong game
            3: {seg, AN, VGA_R, VGA_G, VGA_B, VGA_HS, VGA_VS} = {c_seg, c_anode, vga_r, vga_g, vga_b, vga_hs, vga_vs}; // pong game
        endcase
    
    end
    

endmodule
