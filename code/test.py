# -*- coding: utf-8 -*-

import sys
sys.path.append('utils/')
from load import *

import numpy as np
import cv2 as cv
from matplotlib import pyplot as plt

# Load the iamge
image = 'DSCN2369.jpg'
img = load_image(image = image)

# Blur the image with a GaussianFilter (with a size associated to sigma)
sig = 10
ksize = int((sig-0.8)/0.15 +2)
if ksize%2 ==0:
    ksize =ksize+1

img = cv.GaussianBlur(img,(ksize,ksize),sig)

plt.subplot(131),plt.imshow(img,cmap = 'gray')
plt.title('Original Image'), plt.xticks([]), plt.yticks([])

# Gradient with Sobel
#sobelx = cv2.Sobel(img,cv2.CV_64F,1,0,ksize=3)
#sobely = cv2.Sobel(img,cv2.CV_64F,0,1,ksize=3)
#
#abssobelx = uint8(abs(sobelx))
#abssobely = uint8(abs(sobely))
#
#plt.subplot(324), py.imshow(abssobelx, cmap = 'gray' )
#plt.subplot(325), py.imshow(abssobely, cmap = 'gray')

# Canny edge
edges = cv.Canny(img,12,12,apertureSize = 3, L2gradient = True)

plt.subplot(132),plt.imshow(edges,cmap = 'gray')
plt.title('Edge Image'), plt.xticks([]), plt.yticks([])

# Hough Line Transform
lines = cv.HoughLines(edges,1,np.pi/180,500)
for rho,theta in lines[0]:
    a = np.cos(theta)
    b = np.sin(theta)
    x0 = a*rho
    y0 = b*rho
    x1 = int(x0 + 1000*(-b))
    y1 = int(y0 + 1000*(a))
    x2 = int(x0 - 1000*(-b))
    y2 = int(y0 - 1000*(a))

    cv.line(img,(x1,y1),(x2,y2),(0,0,255),2)


# Plot Hough Lines
cv.imwrite('houghlines3.jpg',img)
plt.subplot(133),plt.imshow(img,cmap = 'gray')
plt.title('Original Image'), plt.xticks([]), plt.yticks([])
plt.show()

