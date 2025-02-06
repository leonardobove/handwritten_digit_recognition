// This module applies an average pooling operation on the input
// matrix of pixels of 1 bit each. The size of the pool
// is nxn, where n must be a multiple of 2.
// The input matrix must be given as a flattened array.
// The output matrix will be a flattened array of input_pixels_number/n^2
// pixels with a different output resolution.

module average_pooling_n #(
    parameter output_resolution = 8,
    parameter n = 8,           // Pool size
    parameter input_matrix_side_length = 112, // Side length of the input square matrix
    parameter output_matrix_side_length = input_matrix_side_length >> $clog2(n) // Side length of the output square matrix
)(
    input clk,
    input reset,
    input en,
    input start,
    input [(input_matrix_side_length**2)-1:0] input_pixels,
    output reg [(output_matrix_side_length**2)*output_resolution-1:0] output_pixels,
    output reg done
);

// FSM states
localparam RESET    = 2'd0,
           IDLE     = 2'd1,
           AVERAGE  = 2'd2,
           DONE     = 2'd3;

reg [1:0] Sreg, Snext;

// Organize the input pixels so that the pixels inside the same pool are adjacent
integer i, j, k, l, pool_index;
reg [(input_matrix_side_length**2)-1:0] pools_array;
always @ (*) begin
    pools_array = 0;
    for (i = 0; i < output_matrix_side_length; i = i + 1)
        for (j = 0; j < output_matrix_side_length; j = j + 1) begin
            // Calculate the starting index of the nxn block
            pool_index = (i * n * input_matrix_side_length) + (j * n);

            // Align the pixels inside the same pool
            for (k = 0; k < n; k = k + 1)
                for (l = 0; l < n; l = l + 1)
                    pools_array[((j+i*output_matrix_side_length)*(n**2)+l+k*n)+:1] = input_pixels[(pool_index+l+k*input_matrix_side_length)+:1];
        end
end

// Counter to keep track of the current pool being currently averaged
localparam POOL_NUM = (output_matrix_side_length**2); // Total number of pools
localparam POOL_NUM_WIDTH = $clog2(POOL_NUM);

reg pool_counter_en_reg;    // Enable for the pool counter
reg pool_counter_reset_reg; // Reset for the pool counter

wire [POOL_NUM_WIDTH-1:0] pool_counter;     // Current pool counter

wire pool_counter_en, pool_counter_reset;
assign pool_counter_en = pool_counter_en_reg && en;
assign pool_counter_reset = pool_counter_reset_reg;

counter #(
    .MAX_VALUE(POOL_NUM)
) pool_counter_instance (
    .clk(clk),
    .en(pool_counter_en),
    .reset(pool_counter_reset),
    .count(pool_counter)
);

// Average pooling of n input pixels
wire [output_resolution-1:0] output_pixel;

average_n_pixels #(
    .output_resolution(output_resolution),
    .n(n**2)
) average_n_pixels_inst (
    .clk(clk),
    .reset(reset),
    .input_pixels(pools_array[pool_counter*(n**2) +: (n**2)]),
    .out(output_pixel)
);

// Update FSM state
always @ (posedge clk) begin
    if (reset) begin
        Sreg <= RESET;
        output_pixels <= 0;
    end else if (en) begin
        Sreg <= Snext;           

        // Update output pixels with the currently averaged pixel
        output_pixels[pool_counter*output_resolution +: output_resolution] <= output_pixel;
    end else begin
        Sreg <= Sreg;
        output_pixels <= output_pixels;
    end
end

// Evaluate next state
always @ (*) begin
    case (Sreg)
        RESET:
            Snext = IDLE;

        IDLE: begin
            if (start)
                Snext = AVERAGE;
            else
                Snext = IDLE;
        end

        AVERAGE: begin
            if (pool_counter == (POOL_NUM-1))
                Snext = DONE;
            else
                Snext = AVERAGE;
        end

        DONE:
            Snext = IDLE;

        default:
            Snext = RESET;
    endcase
end

// Output logic
always @ (Sreg) begin
    case (Sreg)
        RESET: begin
            pool_counter_en_reg = 1'b0;
            pool_counter_reset_reg = 1'b1;
            done = 1'b0;
        end

        IDLE: begin
            pool_counter_en_reg = 1'b0;
            pool_counter_reset_reg = 1'b1;
            done = 1'b0;
        end

        AVERAGE: begin
            pool_counter_en_reg = 1'b1;
            pool_counter_reset_reg = 1'b0;
            done = 1'b0;
        end

        DONE: begin
            pool_counter_en_reg = 1'b0;
            pool_counter_reset_reg = 1'b1;
            done = 1'b1;
        end

        default: begin
            pool_counter_en_reg = 1'b0;
            pool_counter_reset_reg = 1'b1;
            done = 1'b0;
        end
    endcase
end
    
endmodule