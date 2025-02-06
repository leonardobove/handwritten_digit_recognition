# Set the dimensions for the memory array
rows = 240
columns = 320
side_length = 28*8
border_thickness = 1

# Top-left corner of the square (now at (0,0))
top_left_row = 0
top_left_column = 0

# Text settings
text = "<- draw here"
text_start_row = 100  # Roughly vertically centered next to the square
text_start_column = side_length + 5  # Positioned right outside the square

# 5x7 font dictionary for characters used in the text
font_5x7 = {
    "<": ["00010", "00100", "01000", "10000", "01000", "00100", "00010"],
    "-": ["00000", "00000", "11111", "00000", "00000", "00000", "00000"],
    "d": ["00001", "00001", "01111", "10001", "10001", "10001", "01110"],
    "r": ["00000", "00000", "11110", "10001", "10000", "10000", "10000"],
    "a": ["00000", "00000", "01110", "00001", "01111", "10001", "01111"],
    "w": ["00000", "00000", "10001", "10001", "10101", "10101", "01110"],
    "h": ["10000", "10000", "10110", "11001", "10001", "10001", "10001"],
    "e": ["00000", "00000", "01110", "10001", "11111", "10000", "01110"],
    " ": ["00000", "00000", "00000", "00000", "00000", "00000", "00000"],  # Space
}

# Open a text file in write mode
with open("memory_init.txt", "w") as file:
    for r in range(rows):
        for c in range(columns):
            # Check if pixel is part of the square's border
            if (top_left_row <= r < top_left_row + side_length and
                top_left_column <= c < top_left_column + side_length and
                (r < top_left_row + border_thickness or r >= top_left_row + side_length - border_thickness or
                 c < top_left_column + border_thickness or c >= top_left_column + side_length - border_thickness)):
                file.write("1\n")
            # Check if pixel is part of the text
            elif (text_start_column <= c < columns and
                  text_start_row <= r < text_start_row + 7 and
                  c - text_start_column < len(text) * 6):  # Each char is 5 pixels wide + 1 space
                char_index = (c - text_start_column) // 6
                char = text[char_index]
                char_column = (c - text_start_column) % 6
                if char_column < 5 and font_5x7[char][r - text_start_row][char_column] == "1":
                    file.write("1\n")
                else:
                    file.write("0\n")
            else:
                file.write("0\n")

print("File 'memory_init.txt' has been created successfully.")
