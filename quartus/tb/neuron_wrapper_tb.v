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
    reg start = 0;
    reg [resolution*input_data_size-1:0] input_data; // Flattened 1D input_data
    reg [resolution*input_data_size-1:0] weight;     // Flattened 1D weight
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
        .start(start),
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
        reset = 1'b0;
        bias = 1'b0;
        #1;
        reset = 1'b1;
        #1;
        reset = 1'b0;

        #5;
        
        // Generate input data and weights
        start = 1'b1;
        input_data = {8'sb10000000, 8'sb00000011, 8'sb00000001, 8'sb00000000};
        weight = {8'sb10000000, 8'sb00000010, 8'sb00000001, 8'sb00000011};
        bias = 8'sb00000001; //16.392

        #20;
        start = 1'b0;

        #100;
        start = 1'b1;
        input_data = {8'sb01111111, 8'sb00000101, 8'sb00000010, 8'sb00000001};
        weight = {8'sb10000000, 8'sb10000010, 8'sb00000011, 8'sb00000010};

        #20;
        start = 1'b0;
        #100;

        // Finish the simulation
        $stop;
    end

endmodule
