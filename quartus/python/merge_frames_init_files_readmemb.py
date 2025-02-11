import glob
import os
import math

# Output file
output_file = "frames.txt"

# Find all matching files
files = sorted(glob.glob("frame_*.txt"))
num_files = len(files)
frame_size = 320 * 240

total_size = frame_size * num_files
padded_size = 2 ** math.ceil(math.log2(total_size))
padding_needed = padded_size - total_size

# Open output file in write mode
with open(output_file, "w") as outfile:
    for filename in files:
        with open(filename, "r") as infile:
            outfile.write(infile.read())
            outfile.write("\n")  # Add a newline between files for separation
    
    # Pad with zeros
    outfile.write("0\n" * padding_needed)

print(f"Merged {num_files} files into {output_file} with {padding_needed} zero padding.")
