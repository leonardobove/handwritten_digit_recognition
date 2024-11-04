import numpy as np

# Generate 8-bit range (-128 to 127)
input_values = np.arange(-128, 128, 1)

# Sigmoid function
def sigmoid(x):
    return 1 / (1 + np.exp(-x))

# Apply sigmoid and scale to 7-bit integer range
sigmoid_values = (sigmoid(input_values / 20) * 127).astype(int)

def decimal_to_signed_binary(value):

    # If the value is negative, calculate two's complement
    if value < 0:
        value = (1 << 8) + value  # Two's complement for negative values

    # Format as an 8-bit binary string
    return f"{value:08b}"

# Print values for Verilog LUT
for i, sigmoid_values in enumerate(sigmoid_values):
    input_val = input_values[i]  # Get the input value from -128 to 127
    #print(input_val)
    binary_sigmoid_value = decimal_to_signed_binary(sigmoid_values)
    binary_input = decimal_to_signed_binary(input_val)
    #print(binary_sigmoid_value)
    #print(binary_input)
    # Generate Verilog LUT output
    if input_val < 0:
        print(f"8'sb{binary_input}: activation <= 8'sb{binary_sigmoid_value}; // input: {input_val}, activation: {int(sigmoid_values)}")
    else:
        print(f"8'sb{binary_input}: activation <= 8'sb{binary_sigmoid_value}; // input: {input_val}, activation: {int(sigmoid_values)}")
