# Function to convert a 2D array into a Verilog-style 32-bit binary string
def decimal_to_twos_complement(value):
    # Convert to two's complement 32-bit binary representation
    if value < 0:
        bin_str = format((1 << 32) + value, '032b')
    else:
        bin_str = format(value, '032b')
    
    return f"32'b{bin_str}"

def matrix_to_verilog_string(matrix):
    flat_values = [decimal_to_twos_complement(val) for row in matrix for val in row]
    return "{ " + ', '.join(flat_values) + " }"

# Example matrix
raw_matrix = '''
  0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0
   0   0   0   0   0   0   0   0   0   0   0   0   0   0  25  70  94 109
  52   0   0   0   0   0   0   0   0   0  49  34  12  10 105   1   0   0
   0   0   0   0   0   0   0   0   0  34  83   0   0   0   0   0   0   0
   0   0   0   3  43 117  38   2   0   0   0   0   0   0   0   0   0  63
  91  67  78  72   0   0   0   0   0   0   0   0   0   0   0   0   0  91
   0   0   0   0   0   0   0   0   0   0   0   0   0  82   2   0   0   0
   0   0   0   0  18   0   0   0  19 106   0   0   0   0   0   0   0   9
 114  43  24  54 112  31   0   0   0   0   0   0   0   0  36 109 114  76
  29   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0
   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0
    '''

# Convert raw input to a matrix format
matrix = [list(map(int, row.split())) for row in raw_matrix.strip().split('\n')]

# Convert matrix to a single Verilog string
verilog_string = matrix_to_verilog_string(matrix)
print(verilog_string)

