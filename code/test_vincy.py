# -*- coding: utf-8 -*-
"""
Created on Fri Apr 04 15:48:24 2014

@author: Vincent
"""

import sys
sys.path.append('utils/')
from load import *
from tools import *
from detectors import *

import numpy as np
import cv2 as cv
from matplotlib import pyplot as plt

close('all')

image = 'DSCN2368.jpg'
img = load_image(image = image, color = True)
img = cv.resize(img, (1024, 1024))

""" 
#Fourier test : à oublier car trop difficile de déterminer lignes
dft_shift, spect = spectral_density(img)
plot_img(img, 'Image Originale', spect, 'Spectral Density')
spect = blur(spect,sig = 3)
plot_img(img, 'Image Originale', spect, 'Spectral Density blured')

hamming = np.power(hamming_2d_window(img.shape[0], img.shape[1]), .8)
img2 = img*hamming

dft_shift2, spect2 = spectral_density(img2)
plot_img(img2, 'Image Originale', spect2, 'Spectral Density')
spect2 = blur(spect2,sig = 3)
plot_img(img2, 'Image Originale', spect2, 'Spectral Density blured')
"""

"""
# Harris corner marche pas
gray = load_image(image = image, color = False)
gray = cv.resize(gray, (1024, 1024))
gray = blur(gray, sig = 5)

block_size = 10
aperture_size = 5
k = .1

gray = np.float32(gray)
dst = cv.cornerHarris(gray, block_size, aperture_size, k)

#result is dilated for marking the corners, not important
dst = cv.dilate(dst,None)

# Threshold for an optimal value, it may vary depending on the image.
img[dst > 0.1*dst.max()]=[0,0,255]

cv.imshow('dst',img)
if cv.waitKey(0) & 0xff == 27:
    cv.destroyAllWindows()
"""
