`timescale 1ns / 1ps

module controller_tb;
    // Testbench signals
    reg clk;
    reg en;
    reg reset;
    reg button;
    reg painter_ready;
    reg average_pooling_done;
    reg neural_network_done;
    reg [3:0] predicted_digit;
    
    wire [3:0] output_digit;
    wire clear_display;
    wire reset_display;
    wire enable_graphics;
    wire start_average_pooling;
    wire enable_average_pooling;
    wire reset_average_pooling;
    wire start_neural_network;
    wire enable_neural_network;
    wire reset_neural_network;
    
    // Instantiate the controller module
    controller uut (
        .clk(clk),
        .en(en),
        .reset(reset),
        .button(button),
        .output_digit(output_digit),
        .painter_ready(painter_ready),
        .clear_display(clear_display),
        .reset_display(reset_display),
        .enable_graphics(enable_graphics),
        .start_average_pooling(start_average_pooling),
        .enable_average_pooling(enable_average_pooling),
        .reset_average_pooling(reset_average_pooling),
        .average_pooling_done(average_pooling_done),
        .start_neural_network(start_neural_network),
        .enable_neural_network(enable_neural_network),
        .reset_neural_network(reset_neural_network),
        .neural_network_done(neural_network_done),
        .predicted_digit(predicted_digit)
    );
    
    // Clock generation
    always #5 clk = ~clk;
    
    // Test sequence
    initial begin
        // Initialize signals
        clk = 0;
        en = 1;
        reset = 0;
        button = 0;
        painter_ready = 0;
        average_pooling_done = 0;
        neural_network_done = 0;
        predicted_digit = 4'b0000;
        
        // Apply reset
        #10 reset = 1;
        #10 reset = 0;
        #10 reset = 1;
        
        // Wait for reset to complete
        #20;
        
        // Simulate clearing display
        #10 painter_ready = 1;
        #10 painter_ready = 0;
        
        // Press button to start process
        #20 button = 1;
        #10 button = 0;
        
        // Simulate average pooling completion
        #45 average_pooling_done = 1;
        #10 average_pooling_done = 0;
        
        // Simulate neural network completion
        #50 neural_network_done = 1;
        predicted_digit = 4'b1010; // Example prediction
        #10 neural_network_done = 0;
        
        // Wait in DISPLAY_DIGIT state
        #50;
        
        // Press button to clear display and restart
        #20 button = 1;
        #10 button = 0;
        
        // End simulation
        #100;
        $stop;
    end
endmodule
