import tkinter as tk
import numpy as np

# Constants
CANVAS_SIZE = 224
PIXEL_VALUE_WHITE = 127
PIXEL_VALUE_BLACK = 0

def draw(event):
    x, y = event.x, event.y
    canvas.create_rectangle(x, y, x+1, y+1, outline="white", fill="white")
    image_array[y, x] = PIXEL_VALUE_WHITE  # Set white pixel in numpy array

def save_as_numpy():
    with open("drawing.txt", "w") as f:
        f.write("input_image = ")
        f.write(np.array2string(image_array, separator=", ", threshold=np.inf))
    print("Saved as drawing.txt")

# Initialize Tkinter
root = tk.Tk()
root.title("Draw and Save")

# Create Canvas
canvas = tk.Canvas(root, width=CANVAS_SIZE, height=CANVAS_SIZE, bg="black")
canvas.pack()
canvas.bind("<B1-Motion>", draw)  # Draw on left mouse button drag

# Create Save Button
save_button = tk.Button(root, text="Save", command=save_as_numpy)
save_button.pack()

# Initialize numpy array with black pixels
image_array = np.full((CANVAS_SIZE, CANVAS_SIZE), PIXEL_VALUE_BLACK, dtype=np.uint8)

# Run Tkinter loop
root.mainloop()
