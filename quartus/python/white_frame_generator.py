# Set the dimensions for the memory array
rows = 240
columns = 320

# Open a text file in write mode
with open("memory_init.txt", "w") as file:
    # Write a '1' for each of the 240 * 320 words
    for _ in range(rows * columns):
        file.write("1\n")

print("File 'memory_init.txt' has been created successfully.")
