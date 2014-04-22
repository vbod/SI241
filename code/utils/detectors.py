# -*- coding: utf-8 -*-
"""
Created on Mon Mar 31 20:14:42 2014

@author: Vincent
"""

import cv2 as cv
import numpy as np
from matplotlib import pyplot as plt
from tools import *

# Canny detector with automatic parameters for the thresholds based on the norm of the Sobel Gradeint
def Canny_detector(img):
    sobelx = cv.Sobel(img,cv.CV_64F,1,0,ksize=3)
    sobely = cv.Sobel(img,cv.CV_64F,0,1,ksize=3)
    sobelnorm = np.sqrt(sobelx*sobelx + sobely*sobely)
    
    maxT = 0.3*np.max(np.max(sobelnorm))
    minT = 0.1*maxT
    
    return cv.Canny(img,maxT,minT,apertureSize = 3, L2gradient = True)

# Segmentation with K-means color
def kmeans_color(img, K = 8, Niter = 100, eps = 0.001, attempts = 2):
    Z = img.reshape((-1,3))
    Z = np.float32(Z)
     
    criteria = (cv.TERM_CRITERIA_EPS + cv.TERM_CRITERIA_MAX_ITER, Niter, eps)
    ret,label,center = cv.kmeans(Z,K,criteria,attempts,cv.KMEANS_PP_CENTERS)
     
    center = np.uint8(center)
    res = center[label.flatten()]
    return res.reshape((img.shape))

# Morphological gradient with a threshold
def morpho_grad(img, thresh_method = 'adaptive_gaussian', kernel = np.ones((5,5),np.uint8)):
    # Morphological Gradient
    gradient = cv.morphologyEx(img, cv.MORPH_GRADIENT, kernel)      
    
    # Morphological gradient threshold
    if thresh_method == 'manual':
        gradth = threshold(gradient,  'binary')
    elif  thresh_method == 'adaptive_mean':
        gradth = threshold(gradient, 'adaptive_mean')
    else:
        gradth = threshold(gradient, 'adaptive_gaussian')
    return 255*np.ones(np.shape(gradth)) - gradth

# Top_hat transformation
def top_hat(img,  thresh_method = 'adaptive_gaussian', kernel= np.ones((51,51),np.uint8), thres = 100., max_value = 255.):
    topimg = cv.morphologyEx(img, cv.MORPH_TOPHAT, kernel)
    
    if thresh_method == 'binary':
        topimgth = threshold(topimg,  'binary', thres = thres)
    elif  thresh_method == 'adaptive_mean':
        topimgth = threshold(topimg, 'adaptive_mean')
    else:
        topimgth = threshold(topimg, 'adaptive_gaussian')
    return 255*np.ones(np.shape(topimgth)) - topimgth
    
def hough_lines(img,imgbin,score =500):
    # Hough Line Transform
    lines = cv.HoughLines(imgbin,1,np.pi/180,score)
    
    # Hough Transform Visualisation
    a,b = np.shape(img)
    c = np.sqrt(a*a+b*b)
    hough = np.zeros((100,180))
    for rho,theta in lines[0]:
        hough[int(100*((rho+c)/(2*c))),180/np.pi*theta] = 255;
    
    plt.figure()
    plt.subplot(1,2,1),plt.imshow(hough,cmap = 'gray')
    plt.title('Hough transform'), plt.xticks([]), plt.yticks([])
    
    # Plot Hough Lines
    imghough = np.copy(img)
    for rho,theta in lines[0]:
        a = np.cos(theta)
        b = np.sin(theta)
        x0 = a*rho
        y0 = b*rho
        x1 = int(x0 + 1000*(-b))
        y1 = int(y0 + 1000*(a))
        x2 = int(x0 - 1000*(-b))
        y2 = int(y0 - 1000*(a))
    
        cv.line(imghough,(x1,y1),(x2,y2),(0,0,255),2)

    plt.subplot(1,2,2),plt.imshow(imghough,cmap = 'gray')
    plt.title('Image with lines'), plt.xticks([]), plt.yticks([])
    plt.show()
    
    return lines

if __name__ == '__main__':
    from load import *
    image = 'DSCN2366.jpg'
    img = load_image(image = image, main = False)
    plot_img(img, 'Image Originale')
