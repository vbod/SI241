# -*- coding: utf-8 -*-

import cv2 as cv
import numpy as np

def load_image(image = 'DSCN2366.jpg', display = False, main = True):
    if main:
        path = 'images/' + image
    else:
        path = '../images/' + image
    img = cv.imread(path,0)
    if display:
        cv.imshow('s = sauver, autre touche = fermer', img)
        key_button = cv.waitKey(0)
        if key_button == ord('s'):
            n = str.find(image,'.')
            string = image[:n] + '_modified.png'
            cv.imwrite(string, img)
            cv.destroyAllWindows()
        else:
            cv.destroyAllWindows()
    return img
            
if __name__ == '__main__': 
    img = load_image(display = True, main = False)