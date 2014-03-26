# -*- coding: utf-8 -*-
"""
Created on Wed Mar 26 17:06:54 2014

@author: Vincent
"""
import sys
sys.path.append('utils/')
from load import *

import numpy as np
import cv2 as cv
from matplotlib import pyplot as plt

image = 'DSCN2369.jpg'
img = load_image(image = image)

# Blur the image with a GaussianFilter (with a size associated to sigma)
sig = 10
ksize = int((sig-0.8)/0.15 +2)
if ksize%2 ==0:
    ksize =ksize+1

img = cv.GaussianBlur(img,(ksize,ksize),sig)
 
ret,th1 = cv.threshold(img,127,255,cv.THRESH_BINARY)
th2 = cv.adaptiveThreshold(img,255,cv.ADAPTIVE_THRESH_MEAN_C,\
            cv.THRESH_BINARY,11,2)
th3 = cv.adaptiveThreshold(img,255,cv.ADAPTIVE_THRESH_GAUSSIAN_C,\
            cv.THRESH_BINARY,11,2)

figure(1)
plt.subplot(2,2,1),plt.imshow(img,'gray')
plt.title('input image')
plt.subplot(2,2,2),plt.imshow(th1,'gray')
plt.title('Global Thresholding')
plt.subplot(2,2,3),plt.imshow(th2,'gray')
plt.title('Adaptive Mean Thresholding')
plt.subplot(2,2,4),plt.imshow(th3,'gray')
plt.title('Adaptive Gaussian Thresholding')

# Hough Line Transform
tol_min = 1e-3
tol_max = 1e5

hough_input = 255*ones(shape(th2)) - th2
lines = cv.HoughLines(uint8(hough_input),1,np.pi/180,400)
for rho,theta in lines[0]:
    a = np.cos(theta)
    b = np.sin(theta)
    x0 = a*rho
    y0 = b*rho
    if np.tan(theta) < tol_min:
        c = .001
    elif np.tan(theta) > tol_max:
        c = 10000
    else:
        c = np.tan(theta)
    x1 = int(x0 + rho*c*b)
    y1 = 0
    x2 = 0
    y2 = int(y0 - rho*1/c*a)
#    if theta > 1e-1 or theta < np.pi/2 - 1e-1:
#        x1 = long(rho/a**2)
#        y1 = 0
#        x2 = 0
#        y2 = long(rho/b**2)

    cv.line(img,(x1,y1),(x2,y2),(0,0,255),2)

figure(2)
# Plot Hough Lines
# cv.imwrite('houghlines3.jpg',img)
plt.imshow(img,cmap = 'gray')
plt.title('Original Image'), plt.xticks([]), plt.yticks([])
plt.show()
