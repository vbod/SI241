# -*- coding: utf-8 -*-

import sys
sys.path.append('utils/')
from load import *

import numpy as np
import cv2 as cv
from matplotlib import pyplot as plt

plt.close("all")

# Load the iamge
image = 'DSCN2645.jpg'
img = load_image(image = image)


## Blur the image with a GaussianFilter (with a size associated to sigma)
sig = 5
ksize = int((sig-0.8)/0.15 +2)
if ksize%2 ==0:
    ksize =ksize+1

img = cv.GaussianBlur(img,(ksize,ksize),sig)
img0 = img

plt.subplot(231),plt.imshow(img0,cmap = 'gray')
plt.title('Original Image'), plt.xticks([]), plt.yticks([])


# Gradient with Sobel
sobelx = cv.Sobel(img,cv.CV_64F,1,0,ksize=3)
sobely = cv.Sobel(img,cv.CV_64F,0,1,ksize=3)

abssobelx = uint8(abs(sobelx))
abssobely = uint8(abs(sobely))
abssobel = sqrt(abssobelx*abssobelx + abssobely*abssobely)

plt.subplot(232), plt.imshow(abssobelx, cmap = 'gray')
plt.title('Sobel Gradient x'), plt.xticks([]), plt.yticks([])
plt.subplot(233), plt.imshow(abssobely, cmap = 'gray')
plt.title('Sobel Gradient y'), plt.xticks([]), plt.yticks([])


# Morphological Gradient
kernel = np.ones((5,5),np.uint8)
gradient = cv.morphologyEx(img, cv.MORPH_GRADIENT, kernel)

plt.subplot(234),plt.imshow(gradient,cmap = 'gray')
plt.title('Morphological gradient'), plt.xticks([]), plt.yticks([])


# Morphological gradient threshold
th2 = cv.adaptiveThreshold(gradient,255,cv.ADAPTIVE_THRESH_GAUSSIAN_C,\
            cv.THRESH_BINARY,13,2)
th2 = 255*ones(shape(th2)) - th2

plt.subplot(235),plt.imshow(th2,cmap = 'gray')
plt.title('Morpho gradient threshold'), plt.xticks([]), plt.yticks([])


# Canny edge
edges = cv.Canny(img,150,150,apertureSize = 3, L2gradient = True)

plt.subplot(236),plt.imshow(edges,cmap = 'gray')
plt.title('Edge Image'), plt.xticks([]), plt.yticks([])


# Hough Line Transform
lines = cv.HoughLines(uint8(th2),1,np.pi/180,500)

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
figure()
plt.imshow(img,cmap = 'gray')
plt.title('Original Image'), plt.xticks([]), plt.yticks([])
plt.show()


# Hough Transform Visualisation
#a,b = shape(img)
#c = sqrt(a*a+b*b)
#hough = zeros((100,180))
#lines = cv.HoughLines(uint8(edges),1,np.pi/180,150)
#for rho,theta in lines[0]:

#    hough[int(100*((rho+c)/(2*c))),180/pi*theta] = 255;
#
#figure()
#plt.imshow(hough,cmap = 'gray')
#plt.title('Hough transform'), plt.xticks([]), plt.yticks([])


## Search for patterns in Hough Transform
#hough = zeros((2*c+1,180))
#lines = cv.HoughLines(uint8(edges),1,np.pi/180,150)
#for rho,theta in lines[0]:
#    hough[rho+c,180/pi*theta] = 255;
#
#houlines = cv.HoughLines(uint8(hough),1,np.pi/180,10)
#
#finallines = []
#for hourho, houtheta in houlines[0]:
#    u = [cos(houtheta),sin(houtheta)]
#    for rho, theta in lines[0]:
#        m = [rho - hourho*cos(houtheta),theta - hourho*sin(houtheta)]
#        test = dot(m,u)
#        if abs(test)<1:
#            finallines.append([rho,theta])
#
#img = load_image(image = image)
#for rho,theta in finallines:
#    a = np.cos(theta)
#    b = np.sin(theta)
#    x0 = a*rho
#    y0 = b*rho
#    x1 = int(x0 + 1000*(-b))
#    y1 = int(y0 + 1000*(a))
#    x2 = int(x0 - 1000*(-b))
#    y2 = int(y0 - 1000*(a))
#
#    cv.line(img,(x1,y1),(x2,y2),(0,0,255),2)
#
#figure()
#plt.imshow(img,cmap = 'gray')
#plt.title('Lines patterns'), plt.xticks([]), plt.yticks([])
#plt.show()
    