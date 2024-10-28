module predicted_digit # (
    parameter neuron_number = 10,
    parameter resolution = 8
) (
    input signed [resolution-1:0] output_activations [number_neuron-1:0],
    output signed [resolution-1:0] predicted_digit [number_neuron-1:0]
);
    reg [resolution-1:0] max = 0;
    reg [resolution-1:0] index = 0; 
    
    always @ (*) begin
       
    end



endmodule