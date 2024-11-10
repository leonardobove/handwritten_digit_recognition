module predicted_digit #(
    parameter neuron_number = 10,
    parameter resolution = 8
)(
    input signed [resolution*neuron_number-1:0] output_activations,
    output reg [3:0] predicted_digit // 3-bit output for predicted digit
);

    reg signed [resolution-1:0] max; // to store the maximum activation value
    integer index; // to store the index of the max activation, 4 bits to hold values 0-9
    integer i;

    always @(*) begin
        max = 8'sb10000000; // Initialize to minimum possible value (for signed 8-bit resolution)
        index = 0;

        // Loop through each activation value
        for (i = 0; i < neuron_number; i = i + 1) begin
            // Extract the activation value for this neuron (considering the signed value)
            if (output_activations[i*resolution +: resolution] >= max) begin
                max = output_activations[i*resolution +: resolution];
                index = i;
            end
        end

                // Use a case statement to map index to the 3-bit predicted_digit
        case (index)
            0: predicted_digit = 4'd0;
            1: predicted_digit = 4'd1;
            2: predicted_digit = 4'd2;
            3: predicted_digit = 4'd3;
            4: predicted_digit = 4'd4;
            5: predicted_digit = 4'd5;
            6: predicted_digit = 4'd6;
            7: predicted_digit = 4'd7;
            8: predicted_digit = 4'd8;
            9: predicted_digit = 4'd9;
            default: predicted_digit = 4'd0; // Default case for safety
        endcase

    end

endmodule

