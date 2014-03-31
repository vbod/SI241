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
tol_min = 2
tol_max = 4

edges = cv.Canny(img,12,12,apertureSize = 3, L2gradient = True)
hough_input = uint8(255*ones(shape(edges)) - edges) # edges,th1,th2,th3

#lines = cv.HoughLines(uint8(hough_input),1,np.pi/180,500)
#for rho,theta in lines[0]:
#    a = np.cos(theta)
#    b = np.sin(theta)
#    x0 = a*rho
#    y0 = b*rho
#    if np.tan(theta) < tol_min:
#        c = tol_min
#    elif np.tan(theta) > tol_max:
#        c = tol_max
#    else:
#        c = np.tan(theta)
#    x1 = int(x0 + rho*c*b)
#    y1 = 0
#    x2 = 0
#    y2 = int(y0 - rho*1/c*a)
##    if theta > 1e-1 or theta < np.pi/2 - 1e-1:
##        x1 = long(rho/a**2)
##        y1 = 0
##        x2 = 0
##        y2 = long(rho/b**2)
#
#    cv.line(img,(x1,y1),(x2,y2),(0,0,255),2,4)
#
#figure(2)
## Plot Hough Lines
## cv.imwrite('houghlines3.jpg',img)
#plt.imshow(img,cmap = 'gray')
#plt.title('Original Image'), plt.xticks([]), plt.yticks([])
#plt.show()

# gray = cv.cvtColor(img,cv.COLOR_BGR2GRAY)
# edges = cv.Canny(gray,50,150,apertureSize = 3)
minLineLength = 10
maxLineGap = 100
lines = cv.HoughLinesP(hough_input,1,np.pi/180,100,minLineLength,maxLineGap)
for x1,y1,x2,y2 in lines[0]:
    cv.line(img,(x1,y1),(x2,y2),(0,0,255),2,4)

figure(2)
plt.imshow(img,cmap = 'gray')
plt.title('Hough probabilistic'), plt.xticks([]), plt.yticks([])
plt.show()
# cv.imwrite('houghlines5.jpg',img)


