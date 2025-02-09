/*   This module takes as input 10 numbers of given width and
 *   returns a 4 bit number between 0 and 9, corresponding
 *   to the index of the maximum among the input numbers.
 */

module predict_digit # (
    parameter WIDTH = 32
) (
    input clk,
    input reset,
    input start,
    input [10*WIDTH-1:0] input_nums,
    output [3:0] predicted_digit,
    output done
);

reg [10*WIDTH-1:0] input_nums_reg;
reg [3:0] max_step1, max_step1_reg,
          max_step2, max_step2_reg,
          max_step3, max_step3_reg,
          max_step4, max_step4_reg,
          max_step5, max_step5_reg;
reg done_step0_reg,
    done_step1_reg,
    done_step2_reg,
    done_step3_reg,
    done_step4_reg,
    done_step5_reg;

integer i;

assign predicted_digit = 4'd9 - max_step5_reg;
assign done = done_step5_reg;

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

// Step 1
always @ (*) begin
    max_step1 = 4'd0;
    for (i = 1; i < 3; i = i + 1) begin
        if (input_nums_reg[i*WIDTH +: WIDTH] > input_nums_reg[max_step1*WIDTH +: WIDTH])
            max_step1 = i[3:0];
    end
end

always @ (posedge clk) begin
    if (reset) begin
        max_step1_reg <= 4'd0;
        done_step1_reg <= 0;
    end else begin
        done_step1_reg <= done_step0_reg;
        max_step1_reg <= max_step1;
    end
end

// Step 2
always @ (*) begin
    max_step2 = max_step1_reg;
    for (i = 3; i < 5; i = i + 1) begin
        if (input_nums_reg[i*WIDTH +: WIDTH] > input_nums_reg[max_step2*WIDTH +: WIDTH])
            max_step2 = i[3:0];
    end
end

always @ (posedge clk) begin
    if (reset) begin
        max_step2_reg <= 4'd0;
        done_step2_reg <= 0;
    end else begin
        max_step2_reg <= max_step2;
        done_step2_reg <= done_step1_reg;
    end
end

// Step 3
always @ (*) begin
    max_step3 = max_step2_reg;
    for (i = 5; i < 7; i = i + 1) begin
        if (input_nums_reg[i*WIDTH +: WIDTH] > input_nums_reg[max_step3*WIDTH +: WIDTH])
            max_step3 = i[3:0];
    end
end

always @ (posedge clk) begin
    if (reset) begin
        max_step3_reg <= 4'd0;
        done_step3_reg <= 0;
    end else begin
        max_step3_reg <= max_step3;
        done_step3_reg <= done_step2_reg;
    end
end

// Step 4
always @ (*) begin
    max_step4 = max_step3_reg;
    for (i = 7; i < 9; i = i + 1) begin
        if (input_nums_reg[i*WIDTH +: WIDTH] > input_nums_reg[max_step4*WIDTH +: WIDTH])
            max_step4 = i[3:0];
    end
end

always @ (posedge clk) begin
    if (reset) begin
        max_step4_reg <= 4'd0;
        done_step4_reg <= 0;
    end else begin
        max_step4_reg <= max_step4;
        done_step4_reg <= done_step3_reg;
    end
end

// Step 5
always @ (*) begin
    max_step5 = max_step4_reg;
    for (i = 9; i < 10; i = i + 1) begin
        if (input_nums_reg[i*WIDTH +: WIDTH] > input_nums_reg[max_step5*WIDTH +: WIDTH])
            max_step5 = i[3:0];
    end
end

always @ (posedge clk) begin
    if (reset) begin
        max_step5_reg <= 4'd0;
        done_step5_reg <= 0;
    end else begin
        max_step5_reg <= max_step5;
        done_step5_reg <= done_step4_reg;
    end
end

endmodule