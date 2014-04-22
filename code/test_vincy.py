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

image = 'DSCN2369.jpg'
img = load_image(image = image)

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
