`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/29/2023 03:51:41 PM
// Design Name: 
// Module Name: game
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


module game(
    input wire [1:0] mode, // 00:none 01:normal 10:shooter 11:hold
    input wire CLK, // 100 Mhz clock
    input wire [1:0] BTN_LU, // left and up buttons
    input wire [1:0] BTN_DR, // left and up buttons
    output wire VGA_HS, // horizontal sync
    output wire VGA_VS, // vertical sync
    output reg [3:0] VGA_R, // red channels
    output reg [3:0] VGA_G, // green channels
    output reg [3:0] VGA_B, // blue channels
    output wire endgame, // game end flag
    output wire [8:0] score
    );
    
    localparam RW = 5; // rocket width
    localparam RH = 10; // rocket height
    localparam RY = 440 - RH; // initial paddle y
    localparam RX = 160; // initial paddle x
    
    localparam IX = 320; // intial ball x
    localparam IY = 470 - RH - RH - 30; //initial ball y
    localparam B_SIZE = 10; // ball size
    
    reg [15:0] cnt = 0; // pixel clock counter
    reg pix_stb = 0; // pixel clock
    
    wire [9:0] x;  // current pixel x position: 10-bit value: 0-1023
    wire [8:0] y;  // current pixel y position:  9-bit value: 0-511
    wire animate;  // high when we're ready to animate at end of drawing
    wire player1, player2;
    wire collide; // collision flag
    
    //reg sq_a, sq_b, sq_c, sq_d, sq_e, sq_f, sq_g, sq_h; // registers to assign objects
    reg sq_a, sq_b, sq_c; // register for rocket
    wire [11:0] sq_a_x1, sq_a_x2, sq_a_y1, sq_a_y2; // positions bits for ball
    wire [11:0] sq_b_x1, sq_b_x2, sq_b_y1, sq_b_y2; // position bits for rocket
    wire [11:0] sq_c_x1, sq_c_x2, sq_c_y1, sq_c_y2; // positions bits for decoy
    //wire [11:0] sq_d_x1, sq_d_x2, sq_d_y1, sq_d_y2; // positions bits for decoy
    //wire [11:0] sq_e_x1, sq_e_x2, sq_e_y1, sq_e_y2; // positions bits for decoy
    //wire [11:0] sq_f_x1, sq_f_x2, sq_f_y1, sq_f_y2; // position bits for decoy
    //wire [11:0] sq_g_x1, sq_g_x2, sq_g_y1, sq_g_y2; // positions bits for decoy
    //wire [11:0] sq_h_x1, sq_h_x2, sq_h_y1, sq_h_y2; // positions bits for decoy

    
    wire active1;
    wire active; // active flag during game over sequence
    wire [1:0] com; // bits to check rocket direction
    wire [1:0] com1; // bits to check rocket direction
           
    always @(posedge CLK)
    begin
        {pix_stb, cnt} <= cnt + 16'h4000;  // divide by 4: (2^16)/4 = 0x4000
    end

    assign player1 = animate;
    assign player2 = animate;
        
    vga640x480 display (
        .i_clk(CLK),
        .i_pix_stb(pix_stb),
        .i_rst(endgame),
        .o_hs(VGA_HS), 
        .o_vs(VGA_VS), 
        .o_x(x), 
        .o_y(y),
        .o_animate(animate)
    ); // vga 640x480 driver
            
    rocket #(.P_WIDTH(RW), .P_HEIGHT(RH), .IX(RX), .IY(RY)) R1(
        .endgame(endgame),
        .i_clk(CLK), 
        .i_ani_stb(pix_stb),
        .i_animate(player1),
        .BTN_DIR(BTN_LU),
        .o_x1(sq_b_x1),
        .o_x2(sq_b_x2),
        .o_y1(sq_b_y1),
        .o_y2(sq_b_y2),
        .active(active),
        .com(com)
        ); // rocket instance
        
    rocket2 #(.P_WIDTH(RW), .P_HEIGHT(RH), .IX(480), .IY(RY)) R2(
        .endgame(endgame),
        .i_clk(CLK), 
        .i_ani_stb(pix_stb),
        .i_animate(player2),
        .BTN_DIR(BTN_DR),
        .o_x1(sq_c_x1),
        .o_x2(sq_c_x2),
        .o_y1(sq_c_y1),
        .o_y2(sq_c_y2),
        .active(active1),
        .com(com1)
    ); // rocket instance
        
    ball #(.RY(RY), .RH(RH), .IX(IX), .IY(IY), .H_SIZE(B_SIZE)) b0 (
        .toggle(player2),
        .com(com),
        .mode(mode),
        .start(active),
        .i_x1(sq_b_x1),
        .i_x2(sq_b_x2),
        .i_clk(CLK), 
        .i_ani_stb(pix_stb),
        .i_animate(player1),
        .o_x1(sq_a_x1),
        .o_x2(sq_a_x2),
        .o_y1(sq_a_y1),
        .o_y2(sq_a_y2),
        .endgame(endgame),
        .score(score)
    ); // ball instance
    
//    square #(.PY(PY), .PH(PH), .IX(30), .IY(340), .H_SIZE(B_SIZE)) b1 (
//        .toggle(0),
//        .com(com),
//        .mode(mode),
//        .start(active),
//        .i_x1(sq_b_x1),
//        .i_x2(sq_b_x2),
//        .i_clk(CLK), 
//        .i_ani_stb(pix_stb),
//        .i_animate(animate),
//        .o_x1(sq_c_x1),
//        .o_x2(sq_c_x2),
//        .o_y1(sq_c_y1),
//        .o_y2(sq_c_y2)
//    ); // ball instance
    
//    square #(.PY(PY), .PH(PH), .IX(50), .IY(120), .H_SIZE(B_SIZE)) b2 (
//        .toggle(0),
//        .com(com),
//        .mode(mode),
//        .start(active),
//        .i_x1(sq_b_x1),
//        .i_x2(sq_b_x2),
//        .i_clk(CLK), 
//        .i_ani_stb(pix_stb),
//        .i_animate(animate),
//        .o_x1(sq_d_x1),
//        .o_x2(sq_d_x2),
//        .o_y1(sq_d_y1),
//        .o_y2(sq_d_y2)
//    ); // ball instance
    
//    square #(.PY(PY), .PH(PH), .IX(30), .IY(140), .H_SIZE(B_SIZE)) b3 (
//        .toggle(0),
//        .com(com),
//        .mode(mode),
//        .start(active),
//        .i_x1(sq_b_x1),
//        .i_x2(sq_b_x2),
//        .i_clk(CLK), 
//        .i_ani_stb(pix_stb),
//        .i_animate(animate),
//        .o_x1(sq_e_x1),
//        .o_x2(sq_e_x2),
//        .o_y1(sq_e_y1),
//        .o_y2(sq_e_y2)
//    ); // ball instance
    
//    square #(.PY(PY), .PH(PH), .IX(20), .IY(100), .H_SIZE(B_SIZE)) b4 (
//        .toggle(0),
//        .com(com),
//        .mode(mode),
//        .start(active),
//        .i_x1(sq_b_x1),
//        .i_x2(sq_b_x2),
//        .i_clk(CLK), 
//        .i_ani_stb(pix_stb),
//        .i_animate(animate),
//        .o_x1(sq_f_x1),
//        .o_x2(sq_f_x2),
//        .o_y1(sq_f_y1),
//        .o_y2(sq_f_y2)
//    ); // ball instance
    
//    square #(.PY(PY), .PH(PH), .IX(70), .IY(240), .H_SIZE(B_SIZE)) b5 (
//        .toggle(0),
//        .com(com),
//        .mode(mode),
//        .start(active),
//        .i_x1(sq_b_x1),
//        .i_x2(sq_b_x2),
//        .i_clk(CLK), 
//        .i_ani_stb(pix_stb),
//        .i_animate(animate),
//        .o_x1(sq_g_x1),
//        .o_x2(sq_g_x2),
//        .o_y1(sq_g_y1),
//        .o_y2(sq_g_y2)
//    ); // ball instance
    
//    square #(.PY(PY), .PH(PH), .IX(370), .IY(150), .H_SIZE(B_SIZE)) b6 (
//        .toggle(0),
//        .com(com),
//        .mode(mode),
//        .start(active),
//        .i_x1(sq_b_x1),
//        .i_x2(sq_b_x2),
//        .i_clk(CLK), 
//        .i_ani_stb(pix_stb),
//        .i_animate(animate),
//        .o_x1(sq_h_x1),
//        .o_x2(sq_h_x2),
//        .o_y1(sq_h_y1),
//        .o_y2(sq_h_y2)
//    ); // ball instance
    
    always @ (*)
    begin
            sq_a = ((x > sq_a_x1) & (y > sq_a_y1) & (x < sq_a_x2) & (y < sq_a_y2)) ? 1 : 0; // draw ball edges
            sq_b = ((x > sq_b_x1) & (y > sq_b_y1) & (x < sq_b_x2) & (y < sq_b_y2)) ? 1 : 0; // draw rocket edges
            sq_c = ((x > sq_c_x1) & (y > sq_c_y1) & (x < sq_c_x2) & (y < sq_c_y2)) ? 1 : 0; // draw ball edges
//            sq_d = ((x > sq_d_x1) & (y > sq_d_y1) & (x < sq_d_x2) & (y < sq_d_y2)) ? 1 : 0; // draw ball edges
//            sq_e = ((x > sq_e_x1) & (y > sq_e_y1) & (x < sq_e_x2) & (y < sq_e_y2)) ? 1 : 0; // draw ball edges
//            sq_f = ((x > sq_f_x1) & (y > sq_f_y1) & (x < sq_f_x2) & (y < sq_f_y2)) ? 1 : 0; // draw ball edges
//            sq_g = ((x > sq_g_x1) & (y > sq_g_y1) & (x < sq_g_x2) & (y < sq_g_y2)) ? 1 : 0; // draw ball edges
//            sq_h = ((x > sq_h_x1) & (y > sq_h_y1) & (x < sq_h_x2) & (y < sq_h_y2)) ? 1 : 0; // draw ball edges            
    end
    
    always @(posedge pix_stb)
    begin
        // assign ball(s) and paddle color white
//        VGA_R[3] <= sq_a | sq_b | (sq_c & score>10) | (sq_d & score>20) | (sq_e & score > 30) | (sq_f & score > 40) | (sq_g & score > 50) | (sq_h & score > 60); 
//        VGA_G[3] <= sq_a | sq_b | (sq_c & score>10) | (sq_d & score>20) | (sq_e & score > 30) | (sq_f & score > 40) | (sq_g & score > 50) | (sq_h & score > 60);
//        VGA_B[3] <= sq_a | sq_b | (sq_c & score>10) | (sq_d & score>20) | (sq_e & score > 30) | (sq_f & score > 40) | (sq_g & score > 50) | (sq_h & score > 60);
//        VGA_R[2] <= sq_a | sq_b | (sq_c & score>10) | (sq_d & score>20) | (sq_e & score > 30) | (sq_f & score > 40) | (sq_g & score > 50) | (sq_h & score > 60);
//        VGA_G[2] <= sq_a | sq_b | (sq_c & score>10) | (sq_d & score>20) | (sq_e & score > 30) | (sq_f & score > 40) | (sq_g & score > 50) | (sq_h & score > 60);
//        VGA_B[2] <= sq_a | sq_b | (sq_c & score>10) | (sq_d & score>20) | (sq_e & score > 30) | (sq_f & score > 40) | (sq_g & score > 50) | (sq_h & score > 60);
//        VGA_R[1] <= sq_a | sq_b | (sq_c & score>10) | (sq_d & score>20) | (sq_e & score > 30) | (sq_f & score > 40) | (sq_g & score > 50) | (sq_h & score > 60);
//        VGA_G[1] <= sq_a | sq_b | (sq_c & score>10) | (sq_d & score>20) | (sq_e & score > 30) | (sq_f & score > 40) | (sq_g & score > 50) | (sq_h & score > 60);
//        VGA_B[1] <= sq_a | sq_b | (sq_c & score>10) | (sq_d & score>20) | (sq_e & score > 30) | (sq_f & score > 40) | (sq_g & score > 50) | (sq_h & score > 60);
//        VGA_R[0] <= sq_a | sq_b | (sq_c & score>10) | (sq_d & score>20) | (sq_e & score > 30) | (sq_f & score > 40) | (sq_g & score > 50) | (sq_h & score > 60);
//        VGA_G[0] <= sq_a | sq_b | (sq_c & score>10) | (sq_d & score>20) | (sq_e & score > 30) | (sq_f & score > 40) | (sq_g & score > 50) | (sq_h & score > 60);
//        VGA_B[0] <= sq_a | sq_b | (sq_c & score>10) | (sq_d & score>20) | (sq_e & score > 30) | (sq_f & score > 40) | (sq_g & score > 50) | (sq_h & score > 60);
          VGA_R[3] <= (sq_a | sq_b | sq_c) && (mode == 2'b00);
          VGA_G[3] <= (sq_a | sq_b | sq_c) && (mode == 2'b01);
          VGA_B[3] <= (sq_a | sq_b | sq_c) && (mode == 2'b10);
          VGA_R[2] <= (sq_a | sq_b | sq_c) && (mode == 2'b00);
          VGA_G[2] <= (sq_a | sq_b | sq_c) && (mode == 2'b01);
          VGA_B[2] <= (sq_a | sq_b | sq_c) && (mode == 2'b10);
          VGA_R[1] <= (sq_a | sq_b | sq_c) && (mode == 2'b00);
          VGA_G[1] <= (sq_a | sq_b | sq_c) && (mode == 2'b01);
          VGA_B[1] <= (sq_a | sq_b | sq_c) && (mode == 2'b10);
          VGA_R[0] <= (sq_a | sq_b | sq_c) && (mode == 2'b00);
          VGA_G[0] <= (sq_a | sq_b | sq_c) && (mode == 2'b01);
          VGA_B[0] <= (sq_a | sq_b | sq_c) && (mode == 2'b10);
    end            
endmodule

