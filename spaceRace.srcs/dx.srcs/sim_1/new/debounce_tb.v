`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/01/2023 02:15:18 PM
// Design Name: 
// Module Name: debounce_tb
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


module debounce_tb;

    reg clk, i_btn;
    wire o_state, o_ondn, o_onup;
    
    debounce d1(clk, i_btn, o_state, o_ondn, o_onup);
    
    always #5 clk = ~clk;
    
    initial begin
        clk = 0;
        i_btn = 0;
        
        #10
        
        i_btn = 1;
        
        #10
        
        i_btn = 0;
        
        #10 
        
        i_btn = 1;
        
        #10
        i_btn = 0;
        
        #10
        
        i_btn = 1;
        #10
        i_btn = 0;
        
        #10
        
        i_btn = 1;
    end
    
endmodule
