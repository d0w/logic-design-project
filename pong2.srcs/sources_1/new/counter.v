`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/05/2020 07:18:38 PM
// Design Name: 
// Module Name: counter
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


module incrementer(
    input CLK,
    input [1:0] btn,
    output reg [6:0] duty
    );

    reg [3:0] duty_led = 4'b0000;
    
    wire [6:0] seg_0;

    wire btn0_state, btn0_dn, btn0_up;
    debounce d_btn0 (
        .clk(CLK),
        .i_btn(btn[0]),
        .o_state(btn0_state),
        .o_ondn(btn0_dn),
        .o_onup(btn0_up)
    );

    wire btn1_state, btn1_dn, btn1_up;
    debounce d_btn1 (
        .clk(CLK),
        .i_btn(btn[1]),
        .o_state(btn1_state),
        .o_ondn(btn1_dn),
        .o_onup(btn1_up)
    );

    always @ (posedge CLK) 
    begin
        if (btn0_dn)
        begin
            if (duty_led != 7'b1111111)
            begin
                duty_led <= duty_led + 1;
            end
        end

        if (btn1_dn)
        begin
            if (duty_led != 7'b0000000)
            begin
                duty_led <= duty_led - 1;
            end
        end
    end

    always @(*)
    begin
         duty = duty_led;
    end
endmodule
