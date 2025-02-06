`timescale 1ns / 1ps

module average_pooling_n_tb;
    // Parameters
    parameter output_resolution = 8;
    parameter n = 8;
    parameter input_matrix_side_length = 112;
    parameter output_matrix_side_length = input_matrix_side_length >> $clog2(n);
    
    // Inputs
    reg clk;
    reg reset;
    reg en;
    reg start;
    reg [(input_matrix_side_length**2)-1:0] input_pixels;
    
    // Outputs
    wire [(output_matrix_side_length**2)*output_resolution-1:0] output_pixels;
    wire done;
    
    // Instantiate the module under test
    average_pooling_n #(
        .output_resolution(output_resolution),
        .n(n),
        .input_matrix_side_length(input_matrix_side_length),
        .output_matrix_side_length(output_matrix_side_length)
    ) uut (
        .clk(clk),
        .reset(reset),
        .en(en),
        .start(start),
        .input_pixels(input_pixels),
        .output_pixels(output_pixels),
        .done(done)
    );
    
    // Clock generation
    always #5 clk = ~clk; // 10ns period (100 MHz)
    
    initial begin
        // Initialize signals
        clk = 0;
        reset = 1;
        en = 0;
        start = 0;
        input_pixels = 0;
        
        // Apply reset
        #20;
        reset = 0;
        en = 1;
        
        // Test Case 1: All pixels set to 1
        input_pixels = { (input_matrix_side_length**2){1'b1} }; 
        #10;
        start = 1;
        #10;
        start = 0;
        wait (done);
        $display("Test Case 1 - Output Pixels: %h", output_pixels);
        
        // Test Case 2: All pixels set to 0
        input_pixels = 0;
        #10;
        start = 1;
        #10;
        start = 0;
        wait (done);
        $display("Test Case 2 - Output Pixels: %h", output_pixels);
        
        // Test Case 3: Checkerboard pattern
        input_pixels = { (input_matrix_side_length**2)/2{2'b10} }; 
        #10;
        start = 1;
        #10;
        start = 0;
        wait (done);
        $display("Test Case 3 - Output Pixels: %h", output_pixels);
        
        // Test Case 4: Alternating row pattern
        input_pixels = { (input_matrix_side_length/2){ {n{1'b1}}, {n{1'b0}} } };
        #10;
        start = 1;
        #10;
        start = 0;
        wait (done);
        $display("Test Case 4 - Output Pixels: %h", output_pixels);
        
        // Finish simulation
        #50;
        $finish;
    end
    
endmodule