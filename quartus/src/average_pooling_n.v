// This module applies an average pooling operation on the input
// matrix of pixels of 1 bit each. The size of the pool
// is nxn, where n must be a power of 2.
// The input matrix must be given as a flattened array.
// The output matrix will be a flattened array of input_pixels_number/n^2
// pixels with a different output resolution.
 
module average_pooling_n #(
    parameter output_resolution = 8,
    parameter n = 8,           // Pool size
    parameter input_matrix_side_length = 112, // Side length of the input square matrix
    parameter output_matrix_side_length = input_matrix_side_length >> $clog2(n), // Side length of the output square matrix
    parameter input_pixel_addr_width = $clog2(input_matrix_side_length**2)
)(
    input clk,
    input reset,
    input en,
    input start,
    input input_pixel,
    output reg [input_pixel_addr_width-1:0] input_pixel_addr,
    output reg [(output_matrix_side_length**2)*output_resolution-1:0] output_pixels,
    output reg done
);
 
// FSM states
localparam RESET        = 3'd0,
           IDLE         = 3'd1,
           FETCH        = 3'd2,
           WAIT_RAM     = 3'd3,
           AVERAGE      = 3'd4,
           AVERAGE_WAIT = 3'd5,
           DONE         = 3'd6;
 
reg [2:0] Sreg, Snext;
 
// Counters to keep track of the pool being currently averaged.
// One of this counters keeps track of the current output pixel row, the other the column.
localparam POOL_NUM = (output_matrix_side_length**2); // Total number of pools
localparam POOL_NUM_WIDTH = $clog2(POOL_NUM);
localparam OUT_MAT_SIDE_WIDTH = $clog2(output_matrix_side_length); // Number of bits for the row and column counters
 
reg pool_counter_en_reg;    // Enable for the pool counter
reg pool_counter_reset_reg; // Reset for the pool counter
 
wire [POOL_NUM_WIDTH-1:0] pool_counter;     // Current pool counter
wire [OUT_MAT_SIDE_WIDTH-1:0] output_row_counter, output_col_counter; // Current output row and column
 
// Evaluate current output pixel index
assign pool_counter = output_col_counter + output_row_counter * output_matrix_side_length;
 
wire pool_counter_reset, pool_counter_en;
assign pool_counter_en = pool_counter_en_reg && en;
assign pool_counter_reset = pool_counter_reset_reg;
 
// Output matrix column counter
counter #(
    .MAX_VALUE(output_matrix_side_length)
) output_mat_col_counter (
    .clk(clk),
    .en(pool_counter_en),
    .reset(pool_counter_reset),
    .count(output_col_counter)
);
 
// Output matrix row counter
counter #(
    .MAX_VALUE(output_matrix_side_length)
) output_mat_row_counter (
    .clk(clk),
    .en(pool_counter_en && (output_col_counter == (output_matrix_side_length - 1))),
    .reset(pool_counter_reset),
    .count(output_row_counter)
);
 
// Counters to keep track of the current pixel inside the current pool that has to be fetched.
// One of this counters keeps track of the current row of the pool, the other the column.
localparam POOL_SIZE = n**2;                // Total number of pixels inside the same pool
localparam POOL_SIZE_WIDTH = $clog2(n**2);
localparam POOL_SIDE_WIDTH = $clog2(n);     // Number of bits for the row and column counters
 
reg fetch_pixel_idx_en_reg;     // Enable for the fetch pixel counter
reg fetch_pixel_idx_reset_reg;  // Reset for the fetch pixel counter
 
wire [POOL_SIZE_WIDTH-1:0] fetch_pixel_idx;  // Index of the pixel to be fetched
wire [POOL_SIDE_WIDTH-1:0] pool_row_counter, pool_col_counter; // Current pool row and column
 
// Evaluate index of the pool pixel to be fetched
assign fetch_pixel_idx = pool_col_counter + pool_row_counter * n;
 
wire fetch_pixel_idx_en, fetch_pixel_idx_reset;
assign fetch_pixel_idx_en = fetch_pixel_idx_en_reg;
assign fetch_pixel_idx_reset = fetch_pixel_idx_reset_reg;
 
// Pool pixel column counter
counter #(
    .MAX_VALUE(n)
) pool_pixel_col_counter (
    .clk(clk),
    .en(fetch_pixel_idx_en),
    .reset(fetch_pixel_idx_reset),
    .count(pool_col_counter)
);
 
// Pool pixel row counter
counter #(
    .MAX_VALUE(n)
) pool_pixel_row_counter (
    .clk(clk),
    .en(fetch_pixel_idx_en && (pool_col_counter == (n - 1))),
    .reset(fetch_pixel_idx_reset),
    .count(pool_row_counter)
);
 
// Assign the address of the current pixel to be fetched
integer i;
reg [input_pixel_addr_width-1:0] top_left_pixel_addr;
always @ (*) begin
    top_left_pixel_addr = output_col_counter * n + output_row_counter * n * input_matrix_side_length;
    input_pixel_addr = top_left_pixel_addr + pool_col_counter + pool_row_counter * input_matrix_side_length;
end
 
// Buffer that holds the input pixels of one pool
reg [POOL_SIZE-1:0] pool_inputs;
 
// Update pool input pixels buffer
always @ (posedge clk) begin
    if (reset)
        pool_inputs <= 0;
    else if (en && (Sreg == WAIT_RAM))
        pool_inputs[fetch_pixel_idx] <= input_pixel;
    else
        pool_inputs <= pool_inputs;
end
 
// Average pooling of n input pixels
wire [output_resolution-1:0] output_pixel;
 
average_n_pixels #(
    .output_resolution(output_resolution),
    .n(n**2)
) average_n_pixels_inst (
    .clk(clk),
    .reset(reset),
    .input_pixels(pool_inputs),
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
                Snext = FETCH;
            else
                Snext = IDLE;
        end
 
        FETCH:
            Snext = WAIT_RAM;
 
        WAIT_RAM: begin
            if (fetch_pixel_idx == (POOL_SIZE-1))
                Snext = AVERAGE;
            else
                Snext = FETCH;
        end
 
        AVERAGE:
            Snext = AVERAGE_WAIT;
 
        AVERAGE_WAIT:
            if (pool_counter == (POOL_NUM-1))
                Snext = DONE;
            else
                Snext = FETCH;
 
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
 
            fetch_pixel_idx_en_reg = 1'b0;
            fetch_pixel_idx_reset_reg = 1'b1;
 
            done = 1'b0;
        end
 
        IDLE: begin
            pool_counter_en_reg = 1'b0;
            pool_counter_reset_reg = 1'b1;
           
            fetch_pixel_idx_en_reg = 1'b0;
            fetch_pixel_idx_reset_reg = 1'b1;
 
            done = 1'b0;
        end
 
        FETCH: begin
            pool_counter_en_reg = 1'b0;
            pool_counter_reset_reg = 1'b0;
           
            fetch_pixel_idx_en_reg = 1'b0;
            fetch_pixel_idx_reset_reg = 1'b0;
 
            done = 1'b0;
        end
 
        WAIT_RAM: begin
            pool_counter_en_reg = 1'b0;
            pool_counter_reset_reg = 1'b0;
           
            fetch_pixel_idx_en_reg = 1'b1;
            fetch_pixel_idx_reset_reg = 1'b0;
 
            done = 1'b0;
        end
 
        AVERAGE: begin
            pool_counter_en_reg = 1'b0;
            pool_counter_reset_reg = 1'b0;
           
            fetch_pixel_idx_en_reg = 1'b0;
            fetch_pixel_idx_reset_reg = 1'b1;
 
            done = 1'b0;
        end
 
        AVERAGE_WAIT: begin
            pool_counter_en_reg = 1'b1;
            pool_counter_reset_reg = 1'b0;
           
            fetch_pixel_idx_en_reg = 1'b0;
            fetch_pixel_idx_reset_reg = 1'b1;
 
            done = 1'b0;
        end
 
        DONE: begin
            pool_counter_en_reg = 1'b0;
            pool_counter_reset_reg = 1'b1;
           
            fetch_pixel_idx_en_reg = 1'b0;
            fetch_pixel_idx_reset_reg = 1'b1;
 
            done = 1'b1;
        end
 
        default: begin
            pool_counter_en_reg = 1'b0;
            pool_counter_reset_reg = 1'b1;
 
            fetch_pixel_idx_en_reg = 1'b0;
            fetch_pixel_idx_reset_reg = 1'b1;
 
            done = 1'b0;
        end
    endcase
end
   
endmodule