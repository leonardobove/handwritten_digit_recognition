import numpy as np

# Generate 8-bit range (-128 to 127)
input_values = np.arange(-128, 128, 1)

# Sigmoid function
def sigmoid(x):
    return 1 / (1 + np.exp(-x))

# Apply sigmoid and scale to 8-bit integer range
sigmoid_values = (sigmoid(input_values / 20) * 255).astype(int)

# Print values for Verilog LUT
for i, val in enumerate(sigmoid_values):
    input_val = input_values[i]  # Get the input value from -128 to 127
    # Generate Verilog LUT output
    if input_val < 0:
        print(f"-8'sd{i}: out <= 8'sd{val};")
    else:
        print(f"8'sd{i}: out <= 8'sd{val};")
