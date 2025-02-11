import glob
import math
import os

def merge_and_pad_frames_to_mif(input_files, output_file, frame_size):
    """
    Merges multiple frame files into a MIF file with padding to the nearest power of 2.

    Parameters:
        input_files (list of str): List of input file paths.
        output_file (str): Path of the output file (.mif).
        frame_size (int): Number of words per frame.
    """
    total_words = 0
    data_lines = []

    # Read and merge frames into a list
    for file_name in input_files:
        with open(file_name, 'r') as infile:
            for line in infile:
                data_lines.append(line.strip())
                total_words += 1

    # Calculate the nearest power of 2
    required_words = 2 ** math.ceil(math.log2(frame_size * len(input_files)))
    padding_needed = required_words - total_words

    # Add padding with zeros
    data_lines.extend(['0'] * padding_needed)

    # Write to MIF file
    with open(output_file, 'w') as outfile:
        outfile.write("-- Memory Initialization File (.mif)\n")
        outfile.write(f"WIDTH = 1;\n")
        outfile.write(f"DEPTH = {required_words};\n\n")
        outfile.write("ADDRESS_RADIX = DEC;\n")
        outfile.write("DATA_RADIX = BIN;\n\n")
        outfile.write("CONTENT BEGIN\n")

        # Write data lines with addresses
        for address, data in enumerate(data_lines):
            outfile.write(f"    {address} : {data};\n")

        outfile.write("END;\n")

    print(f"Merged {len(input_files)} files into '{output_file}' with {padding_needed} words of padding to reach {required_words} words.")

# Get the current directory
current_directory = os.path.dirname(os.path.abspath(__file__))

# Specify the pattern to match your input files (searching only in the current directory)
input_pattern = os.path.join(current_directory, "frame_*.txt")  # Matches files like frame_1.txt, frame_2.txt, etc.
output_file = "merged_frames.mif"
frame_size = 240 * 320  # Number of words per frame

# Get a list of input files in the current directory
input_files = sorted(glob.glob(input_pattern))

# Merge and pad the frames to a MIF file
merge_and_pad_frames_to_mif(input_files, output_file, frame_size)
