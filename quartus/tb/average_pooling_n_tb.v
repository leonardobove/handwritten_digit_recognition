`timescale 1ns / 1ps

module average_pooling_n_tb;
    parameter input_resolution = 1;
    parameter output_resolution = 8;
    parameter n = 2;
    parameter input_matrix_side_length = 4;
    parameter output_matrix_side_length = input_matrix_side_length >> $clog2(n);
    
    reg clk;
    reg reset;
    reg [(input_matrix_side_length**2)*input_resolution-1:0] input_pixels;
    wire [(output_matrix_side_length**2)*output_resolution-1:0] output_pixels;
    
    // Instantiate the module
    average_pooling_n #(
        .input_resolution(input_resolution),
        .output_resolution(output_resolution),
        .n(n),
        .input_matrix_side_length(input_matrix_side_length),
        .output_matrix_side_length(output_matrix_side_length)
    ) uut (
        .clk(clk),
        .reset(reset),
        .input_pixels(input_pixels),
        .output_pixels(output_pixels)
    );
    
    // Clock generation
    always #5 clk = ~clk;
    
    initial begin
        clk = 0;
        reset = 1;
        #10;
        reset = 0;
        
        // Initialize input pixels with a test pattern
        input_pixels = {
            1'b1,  1'b1,  1'b1,  1'b0,
            1'b1,  1'b1,  1'b1,  1'b0,
            1'b1,  1'b0,  1'b0,  1'b0,
            1'b0,  1'b0,  1'b0,  1'b0
        };
        
        // Wait for processing
        #50;
        
        // Display results
        $display("Output Pixels: %h", output_pixels);
        
        // End simulation
        #10;
        $finish;
    end
endmodule
