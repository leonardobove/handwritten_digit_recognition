module predicted_digit #(
    parameter neuron_number = 10,
    parameter resolution = 8
    )(
    input signed [resolution*neuron_number-1:0] output_activations,
    output reg [resolution-1:0] predicted_digit // Reduced the bit-width of the output
    );

    reg signed [resolution-1:0] max;
    reg [resolution-1:0] index;
    integer i;

    always @(*) begin
        max = 0; //have to change because output_activations need to be unsigned
        index = 0;
        
        // Loop through each activation value
        for (i = 0; i < neuron_number; i = i + 1) begin
            if (output_activations[i*resolution +: resolution] >= max) begin
                max = output_activations[i*resolution +: resolution];
                index = i;
            end
        end
        predicted_digit = index;
    end

endmodule
