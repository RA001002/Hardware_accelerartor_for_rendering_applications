import numpy as np
from PIL import Image

WIDTH  = 498
HEIGHT = 378

data = np.loadtxt(
    "C:/Vivado/pixel_output/pixel_output.sim/sim_1/behav/xsim/output.txt",
    dtype=int
)

print("Pixels:", len(data))

img = data.reshape((HEIGHT, WIDTH)).astype(np.uint8)

Image.fromarray(img).save("output_gray.png")

print("Saved grayscale image!")