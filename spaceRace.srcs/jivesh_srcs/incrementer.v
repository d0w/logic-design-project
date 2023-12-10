module incrementer(
    input wire CLK, // clock
    input wire btn, // button
    output reg [1:0] duty // output 
    );
     
    reg [1:0] n_clicks = 0; // number of presses
    
    wire btn0_state, btn0_dn, btn0_up;
    debounce d_btn0 (
        .clk(CLK),
        .i_btn(btn),
        .o_state(btn0_state),
        .o_ondn(btn0_dn),
        .o_onup(btn0_up)
    ); // debounce instance
    
    always @ (posedge CLK) 
    begin
        if (btn0_dn) // check if button pressed
        begin
            if (n_clicks > 3) n_clicks <= 0;
            n_clicks <= n_clicks + 1;// increment if button down
        end
    end
    
    always @(n_clicks)
    begin
        duty <= n_clicks; // assign number of presses to output
    end
    
endmodule