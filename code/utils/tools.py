# -*- coding: utf-8 -*-
"""
Created on Mon Mar 31 18:27:49 2014

@author: Vincent
"""
import numpy as np
import cv2 as cv
from matplotlib import pyplot as plt

def threshold(img, method = 'binary', thres = 127., max_value = 255.):
    if method == 'binary':
        ret,th = cv.threshold(img, thres, max_value, cv.THRESH_BINARY)
    elif method == 'adaptative_mean':
        th = cv.adaptiveThreshold(img, max_value, cv.ADAPTIVE_THRESH_MEAN_C, cv.THRESH_BINARY, 11, 2)
    else:
        th = cv.adaptiveThreshold(img, max_value,cv.ADAPTIVE_THRESH_GAUSSIAN_C, cv.THRESH_BINARY,11,2)
    return th
    
def plot_img(img1, label1 = '', img2 = None, label2 = ''):
    if img2 == None:
        plt.figure()
        plt.imshow(img1, 'gray')
        plt.title(str(label1))
    else:
        plt.figure()
        plt.subplot(1,2,1),plt.imshow(img1,'gray')
        plt.title(str(label1))
        plt.subplot(1,2,2),plt.imshow(img2,'gray')
        plt.title(str(label2))

## Blur the image with a GaussianFilter (with a size associated to sigma)
def blur(img,sig = 5):
    ksize = int((sig-0.8)/0.15 +2)
    if ksize%2 ==0:
        ksize =ksize+1
    
    return cv.GaussianBlur(img,(ksize,ksize),sig)
        
def spectral_density(img):
    dft = cv.dft(np.float32(img),flags = cv.DFT_COMPLEX_OUTPUT)
    dft_shift = np.fft.fftshift(dft)
    return dft_shift, 20*np.log(cv.magnitude(dft_shift[:,:,0],dft_shift[:,:,1]))
    
if __name__ == '__main__':
    from load import *
    image = 'DSCN2366.jpg'
    img = load_image(image = image, main = False)
    plot_img(img, 'Image Originale')
    
    dft_shift, spect = spectral_density(img)
    plot_img(img, 'Image Originale', spect, 'Spectral Density')
    
    th = threshold(uint8(spect), method = 'binary', thres = 200)
    plot_img(img, 'Spectral density', th, 'Thresholding')
    
    # Hough transform
    minLineLength = 10
    maxLineGap = 100
    hough_input = uint8(255*ones(shape(th)) - th)
    lines = cv.HoughLinesP(hough_input, 1, np.pi/180, 100, minLineLength, maxLineGap)
    for x1,y1,x2,y2 in lines[0]:
        cv.line(img,(x1,y1),(x2,y2),(0,0,255),2,4)
    plot_img(img, 'Hough line detection')