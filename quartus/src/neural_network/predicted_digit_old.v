module predicted_digit #(
    parameter neuron_number = 10,
    parameter resolution = 8
)(
    input clk,
    input reset,
    input digit_en,
    input [resolution*neuron_number-1:0] output_activations,
    output reg [3:0] predicted_digit // 4-bit output for predicted digit
);

    reg [3:0] predicted_digit_reg;
    reg [resolution-1:0] max; // To store the maximum activation value
    reg [3:0] temp_index; // Temporary register to store the index of the max activation
    integer i;

    always @(*) begin
        max = {resolution{1'b0}}; // Initialize to minimum possible value for unsigned resolution
        temp_index = 4'b0000; // Initialize temporary index
        // Loop through each activation value
        for (i = 0; i < neuron_number; i = i + 1) begin
            // Extract the activation value for this neuron
            if (output_activations[i*resolution +: resolution] >= max) begin
                max = output_activations[i*resolution +: resolution];
                temp_index = i[3:0]; // Assign the current index
            end
        end

        predicted_digit_reg <= temp_index; // Update the predicted digit register
    end

    // Sequential block to clear or update data
    always @(posedge clk) begin
        if (reset) begin
            predicted_digit <= 4'b0000; // Reset predicted digit
        end else begin
            predicted_digit <= predicted_digit_reg; // Update predicted digit
        end
    end

endmodule
