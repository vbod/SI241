# -*- coding: utf-8 -*-
"""
Created on Mon Mar 31 18:08:57 2014

@author: Vincent
"""

import sys
sys.path.append('utils/')
from load import *

import numpy as np
import cv2 as cv
from matplotlib import pyplot as plt

image = 'DSCN2366.jpg'
img = load_image(image = image)

dft = cv.dft(np.float32(img),flags = cv.DFT_COMPLEX_OUTPUT)
dft_shift = np.fft.fftshift(dft)

magnitude_spectrum = 20*np.log(cv.magnitude(dft_shift[:,:,0],dft_shift[:,:,1]))

plt.subplot(121),plt.imshow(img, cmap = 'gray')
plt.title('Input Image'), plt.xticks([]), plt.yticks([])
plt.subplot(122),plt.imshow(magnitude_spectrum, cmap = 'gray')
plt.title('Magnitude Spectrum'), plt.xticks([]), plt.yticks([])
plt.show()