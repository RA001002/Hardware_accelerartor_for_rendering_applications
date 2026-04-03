from PIL import Image
import numpy as np

INPUT_IMAGE = "input.png"
OUTPUT_HEX  = "input.hex"

img = Image.open("lee.jpg").convert('RGB')
arr = np.array(img)

H, W, _ = arr.shape
print("Size:", W, "x", H)

with open("inpput.hex", "w") as f:
    for pixel in arr.reshape(-1, 3):
        r, g, b = pixel
        f.write(f"{r:02X}\n")
        f.write(f"{g:02X}\n")
        f.write(f"{b:02X}\n")

print("HEX created!")