module neuron #(parameter input_data_size=784, resolution=8)(
    input clk,
    input reset,
    input signed [resolution*input_data_size-1:0] input_data, // Flattened 1D input_data
    input signed [resolution*input_data_size-1:0] weight,     // Flattened 1D weight
    input signed [resolution-1:0] bias,
    output reg signed [resolution-1:0] output_neuron
    );

    // Internal registers for calculations
    reg signed [2*resolution-1:0] product;
    reg signed [4*resolution-7:0] sum;
    reg signed [4*resolution-6:0] z;   // Register to store z value
    wire signed [4*resolution-6:0] z_w;

    reg signed [resolution-1:0] input_data_element;
    reg signed [resolution-1:0] weight_element;

    // Unpack input_data and weight into 1D arrays
    integer i;
    always @(*) begin
        sum = 0;  // Reset sum on each calculation
        for (i = 0; i < input_data_size; i = i + 1) begin
            // Extract each element from the flattened 1D input and weight
            input_data_element = input_data[(i+1)*resolution-1 -: resolution];
            weight_element = weight[(i+1)*resolution-1 -: resolution];
            
            // Calculate the product and accumulate it into the sum
            product = input_data_element * weight_element;
            sum = sum + product;
        end
        // Add bias to sum to compute z
        z = sum + bias;
    end

    assign z_w = z;

    // Sequential logic for output neuron
    always @ (posedge clk) begin
        if (reset)
            output_neuron <= 0;
        else
            output_neuron <= z_w[4*resolution-6:4*resolution-13]; // Output the most significant bits
    end

endmodule
