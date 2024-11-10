import tkinter as tk
import numpy as np

def draw_pixel(event):
    """Handle drawing pixels on the canvas."""
    x = event.x // pixel_size
    y = event.y // pixel_size
    if 0 <= x < width and 0 <= y < height:
        canvas.create_rectangle(
            x * pixel_size, y * pixel_size, (x + 1) * pixel_size, (y + 1) * pixel_size, 
            fill="white", outline="white"
        )
        pixel_array[y, x] = 1  # Set pixel to white (1)

def save_drawing():
    """Save the drawing to a text file in a format compatible with $readmemb."""
    with open("drawing_init.txt", "w") as file:
        for row in pixel_array:
            for pixel in row:
                file.write(f"{pixel}\n")
    print("File 'drawing_init.txt' has been created successfully.")
    root.destroy()

# Set up canvas dimensions
width, height = 320, 240
pixel_size = 2  # Size of each "pixel" on the canvas for better visibility
pixel_array = np.zeros((height, width), dtype=int)  # Initialize all pixels to black (0)

# Create the Tkinter window
root = tk.Tk()
root.title("Draw on the Canvas (Black: 0, White: 1)")

# Create a canvas widget
canvas = tk.Canvas(root, width=width * pixel_size, height=height * pixel_size, bg="black")
canvas.pack()

# Bind mouse events to the canvas
canvas.bind("<B1-Motion>", draw_pixel)

# Add a button to save the drawing
save_button = tk.Button(root, text="Save Drawing", command=save_drawing)
save_button.pack()

# Run the Tkinter event loop
root.mainloop()
