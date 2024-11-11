/***************************************************************************
The neuron module takes as an imput the weights, the imput_data and the bias. ALL the values have already been normalized to the maximum
available number in 8-bit signed format.
The input_data, theoretically, are unsigned, so the maximum is 2^8-1 = 255. But in Verilog we have to operates with the same type, so both
operands need to be signed, so the maximum will be +127. This fact needs to be changed in the sigmoid function because the output has
to be rescaled.
At this point, we have ALL the variables rapresented in fixed point from 0 to 1 in signed 8-bit. When we make the product, the result
has 2*resolution-bit, 6-bit for the fractional part, so, the bias has to be shifted in order to make the sum consitent.

****************************************************************************/

module neuron #(parameter input_data_size=1, resolution=8)(
    input clk,
    input reset,
    input signed [resolution*input_data_size-1:0] input_data, // Flattened 1D input_data
    input signed [resolution*input_data_size-1:0] weight,     // Flattened 1D weight
    input signed [resolution-1:0] bias,
    output reg signed [resolution-1:0] output_neuron
    );

    localparam input_data_size_width = ($clog2(input_data_size));
    parameter signed MAX_8 = 127;
    parameter signed MIN_8 = -128;

    // Internal registers for calculations
    reg signed [2*resolution-1:0] product;
    reg signed [2*resolution+input_data_size_width-1:0] sum;
    reg signed [2*resolution+input_data_size_width:0] z;   
    reg signed [resolution-1:0] z_sat;

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

        //saturation

        if (z > 8'sb01111111)
            z_sat = MAX_8;
        else if (z < 8'sb10000000)
            z_sat = MIN_8;
        else
            z_sat = z[resolution-1:0];
    end

    //reg mod;
    //
    //always @(*) begin
    //    if (z[2*resolution+input_data_size_width]==1) begin
    //        z_mod = -z;
    //        mod = 1;
    //    end
    //    else begin
    //        z_mod = z;
    //        mod = 0;
    //    end
    //end
    
    //assign z_w = (z_sat) >>> (resolution+input_data_size_width+1); // rescale for 8-bit arithmetic shift-keep sign
    //assign z_w = z_sat[resolution-1:0];

    // Sequential logic for output neuron
    always @ (posedge clk) begin
        if (reset)
            output_neuron <= 0;
        else
            output_neuron <= z_sat; 
    end

endmodule
