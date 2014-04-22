# -*- coding: utf-8 -*-

import sys
sys.path.append('utils/')

import numpy as np
import cv2 as cv
from matplotlib import pyplot as plt

from load import *
from detectors import *
from tools import *

plt.close("all")

# Load the iamge
image = 'DSCN2369.jpg'
img = load_image(image, color = True)
img_gray = load_image(image)

kmeanscolor = kmeans_color(img, K = 10)
plot_img(img,'Orginal Image',kmeanscolor,'K-Means Color')

edges = Canny_detector(kmeanscolor)
plot_img(img,'Orginal Image',edges,'Edges')

topimg = top_hat(img_gray)
plot_img(img,'Orginal Image',topimg,'Top_Hat')

morphgrad = morpho_grad(img_gray)
plot_img(img,'Orginal Image',morphgrad,'Morphological gradient')


# Final Hough Transform
lines = hough_lines(img_gray,edges,100)


