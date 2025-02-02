# Set the dimensions for the memory array
rows = 240
columns = 320
side_length = 28
border_thickness = 1

# Calculate the top-left corner of the square
top_left_row = (rows - side_length) // 2
top_left_column = (columns - side_length) // 2

# Text to display and its position
text = "<-draw here"
text_start_row = (rows - 7) // 2  # Center the text vertically
text_start_column = side_length + 1  # Start right after the square

# Simple 5x7 font dictionary for the characters used in the text
font_5x7 = {
    "<": ["01110", "00100", "01000", "10000", "01000", "00100", "01110"],
    "-": ["00000", "00000", "11111", "00000", "00000", "00000", "00000"],
    "d": ["00000", "00000", "01110", "00001", "01111", "10001", "01111"],
    "r": ["00000", "00000", "11110", "00001", "00001", "00001", "00001"],
    "a": ["00000", "00000", "01110", "10001", "11111", "10001", "10001"],
    "w": ["00000", "00000", "10001", "10001", "10101", "10101", "01110"],
    "h": ["10000", "10000", "10110", "11001", "10001", "10001", "10001"],
    "e": ["00000", "00000", "01110", "10001", "11111", "10000", "01110"],
    " ": ["00000", "00000", "00000", "00000", "00000", "00000", "00000"],
}

# Open a text file in write mode
with open("memory_init.txt", "w") as file:
    for r in range(rows):
        for c in range(columns):
            # Determine if the current pixel is part of the square's border
            if (top_left_row <= r < top_left_row + side_length and
                top_left_column <= c < top_left_column + side_length and
                (r < top_left_row + border_thickness or r >= top_left_row + side_length - border_thickness or
                 c < top_left_column + border_thickness or c >= top_left_column + side_length - border_thickness)):
                file.write("1\n")
            # Determine if the current pixel is part of the text
            elif (text_start_column <= c < columns and
                  text_start_row <= r < text_start_row + 7 and
                  c - text_start_column < len(text) * 6):  # Each char is 5 pixels wide + 1 pixel spacing
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
