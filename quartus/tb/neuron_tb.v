`timescale 1ns/1ps

module neuron_tb;

    // Parameters
    parameter input_data_size = 1;
    parameter resolution = 8;
    parameter input_data_size_width = $clog2(input_data_size);
    wire size = input_data_size_width;

    // Inputs
    reg clk = 0;
    reg reset;
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
        reset = 0;
        bias = 0;
        #1;
        reset = 1;
        #1;
        reset = 0;
        
        // Generate input data and weights
        input_data = -128;
        weight = -128;
        bias = 127;

        #20;
        
        // Test 1: Apply a bias and observe output
        bias = 8'd5;
        #20; // Wait for a few clock cycles to settle

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
