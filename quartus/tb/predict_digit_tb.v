`timescale 1ns / 1ps

module predict_digit_tb;
    parameter WIDTH = 32;
    
    reg clk;
    reg reset;
    reg start;
    reg [10*WIDTH-1:0] input_nums;
    wire [3:0] predicted_digit;
    wire done;
    
    // Instantiate the DUT (Device Under Test)
    predict_digit #(WIDTH) uut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .input_nums(input_nums),
        .predicted_digit(predicted_digit),
        .done(done)
    );
    
    // Clock generation
    always #5 clk = ~clk;
    
    initial begin
        // Initialize signals
        clk = 0;
        reset = 1;
        start = 0;
        input_nums = 0;
        
        // Apply reset
        #10 reset = 0;
        
        // Test case 1: Random values
        #5 start = 1;
        input_nums = {10{32'h00000001}}; // All values set to 1
        #10 start = 0;
        
        wait(done);
        #10;
        
        // Test case 2: One maximum value
        #10 start = 1;
        input_nums = {32'h00000010, 32'h00000005, 32'h00000003, 32'h00000008, 32'h00000007,
                      32'h00000006, 32'h00000002, 32'h00000004, 32'h00000001, 32'h00000009};
        #10 start = 0;
        
        wait(done);
        #10;
        
        // Test case 3: Different values
        #10 start = 1;
        input_nums = {32'h000000AA, 32'h000000BB, 32'h000000CC, 32'h000000DD, 32'h000000EE,
                      32'h000000FF, 32'h00000011, 32'h00000022, 32'h00000033, 32'h00000044};
        #10 start = 0;
        
        wait(done);
        #10;
        
        // Test case 4: Maximum at last index
        #10 start = 1;
        input_nums = {32'h00000001, 32'h00000002, 32'h00000003, 32'h00000004, 32'h00000005,
                      32'h00000006, 32'h00000007, 32'h00000008, 32'h00000009, 32'h000000FF};
        #10 start = 0;
        
        wait(done);
        #10;
        
        // End of simulation
        $finish;
    end
    
    // Monitor outputs
    initial begin
        $monitor("Time=%0t | Predicted Digit=%d | Done=%b", $time, predicted_digit, done);
    end
endmodule