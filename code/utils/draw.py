# -*- coding: utf-8 -*-
"""
Created on Thu Mar 27 15:05:42 2014

@author: Vincent
"""
import cv2 as cv
import numpy as np
from matplotlib import pyplot as plt

def draw_lines(img, lines):
    tol_min = 10^(-3)
    tol_max = 10^3
    for rho,theta in lines[0]:
        a = np.cos(theta)
        b = np.sin(theta)
        x0 = a*rho
        y0 = b*rho
        if np.tan(theta) < tol_min:
            c = tol_min
        elif np.tan(theta) > tol_max:
            c = tol_max
        else:
            c = np.tan(theta)
        x1 = int(x0 + rho*c*b)
        y1 = 0
        x2 = 0
        y2 = int(y0 - rho*1/c*a)
        if theta > 1e-1 or theta < np.pi/2 - 1e-1:
            x1 = long(rho/a**2)
            y1 = 0
            x2 = 0
            y2 = long(rho/b**2)
    
        cv.line(img,(x1,y1),(x2,y2),(0,0,255),2,4)
        
    plt.figure()
    plt.imshow(img,cmap = 'gray')
    plt.title('Original Image'), plt.xticks([]), plt.yticks([])
    plt.show()