`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/24/2020 06:45:56 PM
// Design Name: 
// Module Name: square
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


module square_4 #(
    RY=10,          // paddle y
    RH=10,          // paddle height
    H_SIZE=80,      // half square width (for ease of co-ordinate calculations)
    IX=320,         // initial horizontal position of square centre
    IY=240,         // initial vertical position of square centre
    IY_DIR=0,       // initial vertical direction: 1 is down, 0 is up
    D_WIDTH=640,    // width of display
    D_HEIGHT=480    // height of display
    )
    (
    input wire toggle,
    input wire [1:0] com,
    input wire [1:0] mode,        // mode
    input wire start,       // start flag
    input wire [11:0] i_x1, // paddle left edge
    input wire [11:0] i_x2, // paddle right edge
    input wire [11:0] i_y1,
    input wire [11:0] i_y2,
    input wire [11:0] t_x1,
    input wire [11:0] t_x2,
    input wire [11:0] t_y1,
    input wire [11:0] t_y2,
    input wire i_clk,         // base clock
    input wire i_ani_stb,     // animation clock: pixel clock is 1 pix/frame
    input wire i_animate,     // animate when input is high
    output wire [11:0] o_x1,  // square left edge: 12-bit value: 0-4095
    output wire [11:0] o_x2,  // square right edge
    output wire [11:0] o_y1,  // square top edge
    output wire [11:0] o_y2,   // square bottom edge
    output reg [8:0] score,
    output reg endgame = 0,
    output reg [2:0] wall1,
    output reg [2:0] wall2,
    output reg [8:0] lives1,
    output reg [8:0] lives2
    );
    
    reg [8:0] s;
    reg [8:0] L1 = 5;
    reg [8:0] L2 = 5;
    reg [11:0] x = IX;   // horizontal position of square centre
    reg [11:0] y = IY;   // vertical position of square centre
    reg y_dir = IY_DIR;  // vertical animation direction
    reg x_dir;           // TODO: create random direction generator
    reg [3:0] incx = 1, incy = 1; // TODO: increment speed over # of collisions
    
    assign o_x1 = x - H_SIZE;  // left: centre minus half horizontal size
    assign o_x2 = x + H_SIZE;  // right
    assign o_y1 = y - H_SIZE;  // top
    assign o_y2 = y + H_SIZE;  // bottom   
       
    reg [28:0] ctr; // counter to assign direction
    
    wire y_state, y_dn, y_up;
    debounce detecty(.clk(i_clk), .i_btn(y_dir), .o_state(y_state), .o_ondn(y_dn), .o_onup(y_up)); // detect change in x_dir
    
    wire x_state, x_dn, x_up;
    debounce detectx(.clk(i_clk), .i_btn(x_dir), .o_state(x_state), .o_ondn(x_dn), .o_onup(x_up)); // detect change in y_dir

      
    always @ (posedge i_clk)
    begin
        ctr = ctr + 1; // increment counter
        if (ctr ==  500000000) begin // count to second(s)
            ctr = 0; // assign counter zero
        end
        if (start & endgame) begin
            endgame <= 0;
            x <= IX; // intialize ball to starting x
            y <= IY; // initialize ball to starting y
            x_dir <= ctr; // initialize ball x direction
            y_dir <= IY_DIR; // intialize ball y direction
            incx <= 1; // intialize x speed
            incy <= 1; // intialize with y speed
        end
        
        if (x <= H_SIZE + 1 && toggle)  // on reset return to starting position
        begin
          
            L1 = L1 - 1;
            x <= IX; // intialize ball to starting x
            y <= IY; // initialize ball to starting y
            x_dir <= ctr; // initialize ball x direction
            y_dir <= IY_DIR; // intialize ball y direction
            incx <= 1; // intialize x speed
            incy <= 1; // intialize y speed
        end
       if (x >= D_WIDTH- H_SIZE - 1 && toggle)  // on reset return to starting position
        begin
            L2 = L2 - 1;
            x <= IX; // intialize ball to starting x
            y <= IY; // initialize ball to starting y
            x_dir <= ctr; // initialize ball x direction
            y_dir <= IY_DIR; // intialize ball y direction
            incx <= 1; // intialize x speed
            incy <= 1; // intialize y speed
        end
        
        if (x_up & incx !=3) begin // check is maximum speed or change in x_dir
            incx <= incx + 1; // increase incx one unit
        end
        if (y_up & incy !=3) begin // check is maximum speed or change in y_dir
                incy <= incy + 1; // increase incy one unit
                if ((com[0] | com[1]) & incx != 3) begin // check if left or right paddle during collision
                    incx <= incx + 1; // increase incx one unit
                end
        end
        
        if (!mode) begin // if we are not in correct mode
            x <= IX; // intialize ball to starting x
            y <= IY; // initialize ball to starting y
            x_dir <= ctr; // initialize ball x direction
            y_dir <= IY_DIR; // intialize ball y direction
            incx <= 1; // intialize x speed
            incy <= 1; // intialize y speed
        end
              
        if (i_animate && i_ani_stb && !endgame && mode)
        begin;
            x <= (x_dir) ? x + incx : x - incx;  // move left if positive x_dir
            y <= (y_dir) ? y + incy : y - incy;  // move down if positive y_dir

//            if (x <= H_SIZE + 1) begin  // edge of square is at left of screen
//                x_dir <= 1;  // change direction to right
//            end
            
//            if (x >= (D_WIDTH - H_SIZE - 1)) begin  // edge of square at right
//                x_dir <= 0;  // change direction to right
//            end
                     
            if (y <= H_SIZE + 1) begin // edge of square at top of screen
                y_dir <= 1;  // change direction to down
                
            end
            
            if (y >= (D_HEIGHT - H_SIZE - 1)) begin //|| y == (PY - PH - 1))  // paddle hit
                y_dir <= 0;  // change direction to up
                if (com[1] & !com[0])
                    x_dir <= 0;
                else if (com[0] & !com[1])
                    x_dir <= 1;
            end
      
//           if (x + H_SIZE == i_x2)
//            begin
//             if (i_y1<=y+H_SIZE<=i_y2 || i_y1<=y-H_SIZE<=i_y2)
//              if (com[1] & !com[0])
                 
//                x_dir <= 1;
//              else if (com[0] & !com[1])
//                x_dir <=0;
            if ((i_x2+1>=o_x1) && ((i_y1<=o_y1 && o_y1<=i_y2) || (i_y1<=o_y2 && o_y2<=i_y2)))
              begin
                x_dir <= 1;
//                 if(x_dir)
//                    x_dir <= 0;
//                 else
//                    x_dir <=1;
           
          end
          if ((t_x1+1<=o_x2) && ((t_y1<=o_y1 && o_y1<=t_y2) || (t_y1<=o_y2 && o_y2<=t_y2)))
              begin
                x_dir <=0;
//                 if(x_dir)
//                    x_dir <= 0;
//                 else
//                    x_dir <=1;
//                 end
            end
       end
    end
    
    always @(posedge i_clk)
    begin
//        if (y_up) // if paddle collision
//            s = s + 1; // increment score
//        else if (endgame | !mode) // if game ended or not in correct mode
//            s = 0; // assign score to zero
        if (L1==0)
        begin
               endgame <= 1; // pass endgame flag
        end
        
        if (L2==0)
        begin
               endgame <= 1; // pass endgame flag
        end
    end
    
    always @(*)
    begin
        score = s; // assign score
        lives1 = L1;
        lives2 = L2;
    end    
    
endmodule
    
