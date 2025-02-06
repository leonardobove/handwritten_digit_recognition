// This module applies an average pooling operation on the input
// matrix of pixels with given input resolution. The size of the pool
// is nxn, where n must be a multiple of 2.
// The input matrix must be given as a flattened array.
// The output matrix will be a flattened array of input_pixels_number/n^2
// pixels with a different output resolution.
module average_pooling_n #(
    parameter input_resolution = 1,
    parameter output_resolution = 8,
    parameter n = 2,           // Pool size
    parameter input_matrix_side_length = 28, // Side length of the input square matrix
    parameter output_matrix_side_length = input_matrix_side_length >> $clog2(n) // Side length of the output square matrix
)(
    input clk,
    input reset,
    input [(input_matrix_side_length**2)*input_resolution-1:0] input_pixels,
    output [(output_matrix_side_length**2)*output_resolution-1:0] output_pixels
);
    
    // Input vector of pixels inside the same pool
    wire [input_resolution*n*n-1:0] pool_pixels;

    // Organize the input pixels so that the pixels inside the same pool are adjacent
    integer i, j, k, l, pool_index;
    reg [input_resolution*(input_matrix_side_length**2)-1:0] pools_array;
    always @ (*) begin
        pools_array = 0;
        for (i = 0; i < output_matrix_side_length; i = i + 1)
            for (j = 0; j < output_matrix_side_length; j = j + 1) begin
                // Calculate the starting index of the nxn block
                pool_index = (i * n * input_matrix_side_length) + (j * n);

                // Align the pixels inside the same pool
                for (k = 0; k < n; k = k + 1)
                    for (l = 0; l < n; l = l + 1)
                        pools_array[input_resolution*((j+i*output_matrix_side_length)*(n**2)+l+k*n)+:input_resolution] = input_pixels[input_resolution*(pool_index+l+k*input_matrix_side_length)+:input_resolution];
            end
    end

    // Generate parallel instances of average_n_pixels
    genvar r, c;
    generate
        for (r = 0; r < output_matrix_side_length; r = r + 1) begin : row_loop
            for (c = 0; c < output_matrix_side_length; c = c + 1) begin : col_loop
                average_n_pixels #(
                    .input_resolution(input_resolution),
                    .output_resolution(output_resolution),
                    .n(n*n)
                ) average_n_pixels_inst (
                    .clk(clk),
                    .reset(reset),
                    .input_pixels(pools_array[input_resolution*(c+r*output_matrix_side_length)*(n**2)+:input_resolution*(n**2)]),
                    .out(output_pixels[(c+r*output_matrix_side_length)*output_resolution+:output_resolution])
                );
            end
        end
    endgenerate

endmodule