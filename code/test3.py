# -*- coding: utf-8 -*-
"""
Created on Mon Mar 31 18:08:57 2014

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

image = 'DSCN2366.jpg'
img = load_image(image = image)

dft_shift, spect = spectral_density(img)
plot_img(img, 'Image Originale', spect, 'Spectral Density')
spect = blur(spect,sig = 3)
plot_img(img, 'Image Originale', spect, 'Spectral Density blured')

top_hat = top_hat(uint8(spect), thresh_method = 'binary', thres = 100.)
plot_img(img, 'Image Originale', top_hat, 'Top hat')


