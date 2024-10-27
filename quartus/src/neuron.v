module neuron #(parameter input_data_size=784, resolution=8)(
    input clk,
    input reset,
    input signed [resolution-1:0] input_data[input_data_size-1:0],
    input signed [resolution-1:0] weight[input_data_size-1:0],
    input signed [resolution-1:0] bias,
    output signed [resolution-1:0] output_neuron
    );

    //reg done = = 0; //neuron evaluation done
    reg signed [2*resolution-1:0] product = 0;
    reg signed [4*resolution-7:0] sum = 0; //26 bit?
    
    reg signed [4*resolution-6:0] z = 0; //reg? wire? 27 bit

    always @ (*) begin
        integer i = 0; //address of the L-1 layer
        for (i=0, i<=input_data_size, i=i+1) begin
            product = input_data[i]*weight[i];
            sum = sum + product;
        end
    end

    assign z = sum + bias;

    always @ (posedge clk) begin
        if (reset)
            output_neuron <= 0;
        else
            output_neuron <= z[4*resolution-6:4*resolution-13];
    end
        
endmodule