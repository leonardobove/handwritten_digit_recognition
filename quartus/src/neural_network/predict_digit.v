// Module: predict_digit
// Description: Determines the index of the maximum value from 10 inputs.
// Uses a pipelined approach to avoid timing issues.

module predict_digit # (
    parameter WIDTH = 40
) (
    input clk,
    input reset,
    input start,
    input [10*WIDTH-1:0] input_nums,
    output [3:0] predicted_digit,
    output done
);

// Internal registers for pipelining
reg [10*WIDTH-1:0] input_nums_reg;
reg [3:0] max_step1_1, max_step1_1_reg,
          max_step1_2, max_step1_2_reg,
          max_step1_3, max_step1_3_reg,
          max_step1_4, max_step1_4_reg,
          max_step1_5, max_step1_5_reg,                              
          max_step2_1, max_step2_1_reg,
          max_step2_2, max_step2_2_reg,
          max_step2_3, max_step2_3_reg,
          max_step3_1, max_step3_1_reg,
          max_step3_2, max_step3_2_reg,
          max_step4, max_step4_reg;
reg done_step0_reg,
    done_step1_reg,
    done_step2_reg,
    done_step3_reg,
    done_step4_reg;

integer i;

// Final outputs
assign predicted_digit = 4'd9 - max_step4_reg;
assign done = done_step4_reg;

// Sample input data
always @ (posedge clk) begin
    if (reset) begin
        input_nums_reg <= 0;
        done_step0_reg <= 0;
    end else begin
        done_step0_reg <= start;
        if (start)
            input_nums_reg <= input_nums;
        else
            input_nums_reg <= input_nums_reg;
    end
end

// Step 1: compare the 10 input numbers in pairs
always @ (*) begin
    // First pair (the greater is stored in max_step1_1_reg)
    if (input_nums_reg[1*WIDTH +: WIDTH] > input_nums_reg[0*WIDTH +: WIDTH])
        max_step1_1 = 4'd1;
    else
        max_step1_1 = 4'd0;

    // Second pair (the greater is stored in max_step1_2_reg)
    if (input_nums_reg[3*WIDTH +: WIDTH] > input_nums_reg[2*WIDTH +: WIDTH])
        max_step1_2 = 4'd3;
    else
        max_step1_2 = 4'd2;

    // Third pair (the greater is stored in max_step1_3_reg)
    if (input_nums_reg[5*WIDTH +: WIDTH] > input_nums_reg[4*WIDTH +: WIDTH])
        max_step1_3 = 4'd5;
    else
        max_step1_3 = 4'd4;

    // Fourth pair (the greater is stored in max_step1_4_reg)
    if (input_nums_reg[7*WIDTH +: WIDTH] > input_nums_reg[6*WIDTH +: WIDTH])
        max_step1_4 = 4'd7;
    else
        max_step1_4 = 4'd6;

    // Fifth pair (the greater is stored in max_step1_5_reg)
    if (input_nums_reg[9*WIDTH +: WIDTH] > input_nums_reg[8*WIDTH +: WIDTH])
        max_step1_5 = 4'd9;
    else
        max_step1_5 = 4'd8;
end

always @ (posedge clk) begin
    if (reset) begin
        done_step1_reg <= 0;
        max_step1_1_reg <= 0;
        max_step1_2_reg <= 0;
        max_step1_3_reg <= 0;
        max_step1_4_reg <= 0;
        max_step1_5_reg <= 0;
    end else begin
        done_step1_reg <= done_step0_reg;
        max_step1_1_reg <= max_step1_1;
        max_step1_2_reg <= max_step1_2;
        max_step1_3_reg <= max_step1_3;
        max_step1_4_reg <= max_step1_4;
        max_step1_5_reg <= max_step1_5;
    end
end

// Step 2: compare the greatest from the previous step in pairs. One is propagated as is.
always @ (*) begin
    // First pair (the greater is stored in max_step2_1_reg)
    if (input_nums_reg[max_step1_1_reg*WIDTH +: WIDTH] > input_nums_reg[max_step1_2_reg*WIDTH +: WIDTH])
        max_step2_1 = max_step1_1_reg;
    else
        max_step2_1 = max_step1_2_reg;

    // Second pair (the greater is stored in max_step2_2_reg)
    if (input_nums_reg[max_step1_3_reg*WIDTH +: WIDTH] > input_nums_reg[max_step1_4_reg*WIDTH +: WIDTH])
        max_step2_2 = max_step1_3_reg;
    else
        max_step2_2 = max_step1_4_reg;

    // Propagate the other index (this happens because the first layer has an odd number of comparators)
    max_step2_3 = max_step1_5_reg;
end

always @ (posedge clk) begin
    if (reset) begin
        done_step2_reg <= 0;
        max_step2_1_reg <= 0;
        max_step2_2_reg <= 0;
        max_step2_3_reg <= 0;
    end else begin
        done_step2_reg <= done_step1_reg;
        max_step2_1_reg <= max_step2_1;
        max_step2_2_reg <= max_step2_2;
        max_step2_3_reg <= max_step2_3;
    end
end

// Step 3: compare the greatest from the previous step in pairs. One is propagated as is.
always @ (*) begin
    // First pair (the greater is stored in max_step3_1_reg)
    if (input_nums_reg[max_step2_1_reg*WIDTH +: WIDTH] > input_nums_reg[max_step2_2_reg*WIDTH +: WIDTH])
        max_step3_1 = max_step2_1_reg;
    else
        max_step3_1 = max_step2_2_reg;

    // Propagate the other index (this happens because the first layer has an odd number of comparators)
    max_step3_2 = max_step2_3_reg;
end

always @ (posedge clk) begin
    if (reset) begin
        done_step3_reg <= 0;
        max_step3_1_reg <= 0;
        max_step3_2_reg <= 0;
    end else begin
        done_step3_reg <= done_step2_reg;
        max_step3_1_reg <= max_step3_1;
        max_step3_2_reg <= max_step3_2;
    end
end

// Step 4: compare the greatest from the previous step in pairs.
always @ (*) begin
    // Last pair (the greater is stored in max_step4_reg)
    if (input_nums_reg[max_step3_1_reg*WIDTH +: WIDTH] > input_nums_reg[max_step3_2_reg*WIDTH +: WIDTH])
        max_step4 = max_step3_1_reg;
    else
        max_step4 = max_step3_2_reg;
end

always @ (posedge clk) begin
    if (reset) begin
        done_step4_reg <= 0;
        max_step4_reg <= 0;
    end else begin
        done_step4_reg <= done_step3_reg;
        max_step4_reg <= max_step4;
    end
end

endmodule