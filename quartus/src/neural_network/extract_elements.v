 module extract_elements #(
    parameter resolution = 8,
    parameter input_data_size = 1,
    parameter input_data_size_width = ($clog2(input_data_size))
)(
    input clk,
    input extract_en,
    input [input_data_size_width-1:0] index, // Current index
    input [resolution*input_data_size-1:0] input_data, // Flattened input data
    input [resolution*input_data_size-1:0] weight,     // Flattened weight
    output reg signed [resolution-1:0] input_data_element,
    output reg signed [resolution-1:0] weight_element
);

    always @(posedge clk) begin
        if (extract_en) begin
            // Extract the indexed input and weight element
            input_data_element <= input_data[(index+1)*resolution-1 -: resolution];
            weight_element <= weight[(index+1)*resolution-1 -: resolution];
        end else begin
            input_data_element <= 0;
            weight_element <= 0;
        end    
    end
endmodule
