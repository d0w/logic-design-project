`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/21/2020 04:34:45 PM
// Design Name: 
// Module Name: increment
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


module increment
    #(
    LIMIT = 9, // maximum incrementable value
    N_BITS = 4 // number of output bits (correpsonds to LIMIT value)
    )
    (
    input CLK, // clock
    input btn, // button
    output reg [N_BITS-1:0] duty // 
    );
     
    reg [N_BITS-1:0] n_clicks = 0; 
    
    wire btn0_state, btn0_dn, btn0_up;
    debounce d_btn0 (
        .clk(CLK),
        .i_btn(btn),
        .o_state(btn0_state),
        .o_ondn(btn0_dn),
        .o_onup(btn0_up)
    );
    
    always @ (posedge CLK) 
    begin
        if (btn0_dn)
        begin
            if (n_clicks == LIMIT)
                n_clicks <= 0;
            else
                n_clicks <= n_clicks + 1;
        end
    end
    
    always @(*)
    begin
        duty = n_clicks;
    end
    
endmodule
