`timescale 1ns/1ps

module neuron_wrapper_tb;

    // Parameters
    parameter input_data_size = 4;
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
    neuron_wrapper #(
        .input_data_size(input_data_size),
        .resolution(resolution)
    ) i_neuron_wrapper (
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

        #5;
        
        // Generate input data and weights
        input_data = {8'sb10000000, 8'sb00000011, 8'sb00000001, 8'sb00000000};
        weight = {8'sb10000000, 8'sb00000010, 8'sb00000001, 8'sb00000011};
        bias = 8'sb00000001;

        #100;

        // Finish the simulation
        $stop;
    end

endmodule
