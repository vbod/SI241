# -*- coding: utf-8 -*-
"""
Created on Mon Mar 31 20:24:14 2014

@author: Vincent
"""

import sys
sys.path.append('utils/')
from load import *

import numpy as np
import cv2 as cv
from matplotlib import pyplot as plt
from detectors import *
from tools import *

plt.close("all")


# Load the iamge
image = 'DSCN2369.jpg'
img = load_image(image)

edges = Canny_detector(img)
plot_img(img,'Orginal Image',edges,'Edges')

lines = hough_lines(img,edges,100)

hist = cv.calcHist([img],[0],None,[256],[0,256])

kmeanscolor = kmeans_color(img, K = 10)
plot_img(img,'Orginal Image',kmeanscolor,'K-Means Color')

topimg = top_hat(img)
plot_img(img,'Orginal Image',topimg,'Top_Hat')

morphgrad = morpho_grad(img)
plot_img(img,'Orginal Image',morphgrad,'Morphological gradient')
