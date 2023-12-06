module ball_tb;

// Inputs
reg toggle, mode, start, i_clk, i_ani_stb, i_animate;
reg [1:0] com;
reg [11:0] i_x1;
reg [11:0] i_x2;

wire [11:0] o_x1, o_x2, o_y1, o_y2;
wire [8:0] score;
wire endgame;

always 
begin
    #5 i_clk = ~i_clk;
end

initial begin
    i_clk = 0;
    toggle = 0;
    mode = 0;
    start = 0;
    i_ani_stb = 0;
    i_animate = 0;
    com = 0;
    i_x1 = 0;
    i_x2 = 0;

    #10

    mode = 1;
    start = 1;
    i_ani_stb = 1;
    i_animate = 1;
    com = 2'b01;
    endgame = 1;

    #1000
end