`timescale 1ns/1ps

module neuron_tb;

    // Parameters
    parameter input_data_size = 784;
    parameter resolution = 8;

    // Inputs
    reg clk = 0;
    reg reset = 1;
    reg signed [resolution*input_data_size-1:0] input_data; // Flattened 1D input_data
    reg signed [resolution*input_data_size-1:0] weight;     // Flattened 1D weight
    reg signed [resolution-1:0] bias = 0;

    // Outputs
    wire signed [resolution-1:0] output_neuron;

    integer i;

    // Instantiate the neuron module
    neuron #(
        .input_data_size(input_data_size),
        .resolution(resolution)
    ) uut (
        .clk(clk),
        .reset(reset),
        .input_data(input_data),
        .weight(weight),
        .bias(bias),
        .output_neuron(output_neuron)
    );

    // Clock generation
    initial begin
        forever #5 clk = ~clk; // 10ns clock period
    end

    // Test vectors
    initial begin
        // Initialize inputs
        reset = 1;
        bias = 0;
        
        // Generate input data and weights
        
        for (i = 0; i < input_data_size; i = i + 1) begin
            // Assign random values to each "slice" of the flattened 1D input_data and weight
            input_data[(i+1)*resolution-1 -: resolution] = $random % (1 << (resolution - 1)); // Random within range
            weight[(i+1)*resolution-1 -: resolution] = $random % (1 << (resolution - 1));
        end

        // Apply reset
        #10;
        reset = 0;
        
        // Test 1: Apply a bias and observe output
        bias = 8'd5;
        #20; // Wait for a few clock cycles to settle
        
        // Test 2: Change input data and weights, observe output
        for (i = 0; i < input_data_size; i = i + 1) begin
            input_data[(i+1)*resolution-1 -: resolution] = $random % (1 << (resolution - 1)); // New random values
            weight[(i+1)*resolution-1 -: resolution] = $random % (1 << (resolution - 1));
        end

        // Change bias
        bias = -8'd3;
        #20; // Wait for a few clock cycles
        
        // Test 3: Reset and observe output
        reset = 1;
        #10;
        reset = 0;
        #20;

        // Finish the simulation
        $stop;
    end

endmodule
