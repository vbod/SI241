# -*- coding: utf-8 -*-
"""
Created on Wed Apr 16 14:38:34 2014

@author: Vincent
"""
import sys
import numpy as np
import cv2 as cv

class sliding_window(object):
    """
    Classe de sliding_window - fenêtre qui scanne une image et retrouve tous
    possibles endroits où il y a une croix (correspondant à un grillage).
        Attribut :
            - largeur de la fenêtre : self.w, int
            - hauteur de la fenêtre : self.h, int
            - model d'apprentissage : self.model, sklearn object
        Méthode : 
            - constructeur
            - detection
            
    """
    
    def __init__(self, w, h, C=1.):
        """
        Constructeur d'une sliding window.
            - h : hauteur de la fenêtre de détection, int
            - w : largeur fenêtre de détection, int
            - C : paramètre de régularisation du SVM
        """
        from sklearn import svm
        self.width = w
        self.height = h
        self.model = svm.SVC(C = C, kernel = 'linear', tol = 1e-6, 
                             probability = True)
        
    def fit(self, X, y):
        """
        Fit le modèle avec un ensemble de patch d'image, des positifs (croix 
        effectives) et des négatifs.
            - X ensemble de feature, np.array taille n_sample * n_features
            - y labels associés, np.array taille n_sample * 1
        """
        self.model.fit(X, y)
        return self
        
    def test(self, X, y):
        """
        Teste de le modèle appris par fit sur l'ensemble de test (X,y).
            - X ensemble de test, np.array taille n_test * n_features
            - y labels de test associés, np.array taille n_test * 1
        """
        return self.model.score(X, y)
        
    def detection(self, img, th_svm = .5, th_nms = .3):
        """
        Détecte dans une image toutes les fenêtres ayant une croix due à un 
        grillage, grâce à l'apprentissage dans model.
            - img image, format conforme à opencv
            - th_svm seuillage de confiance en l'existence d'une croix pour 
              lequel on garde la fenêtre
            - th_nms seuillage de fusion dans l'algorithme NMS
        """
        h_end = img.size[0] - self.height
        w_end = img.size[1] - self.width
        res = []
        
        for i in range(h_end):
            for j in range(w_end):
                sys.stdout.write('\rDetection...{:6.2%}'.format(
                                (i*w_end + j)*1. / (w_end*h_end)))
                sys.stdout.flush()
                X = np.array(img[i:i+self.height, j:j+self.width]).reshape(-1)
                
                predict = self.model.predict_proba(X)
                if predict[0] > th_svm:
                    res.append((i, j, predict))
        
        return self.NMS(res, th_nms)
                
    def NMS(self, res, th):
        """
        Fusion des patchs suffisamment proches au sens de l'union sur 
        l'intersection.
            - res liste de toutes les détections
            - th seuillage de fusion
        """
        res_nms = []
        proba = [r[2] for r in res] # extrait les confiances associé à la classe +1
        while len(res) != 0:
            i_0 = np.argmax(proba)
            cur = res[i_0]
            del res[i_0], proba[i_0]
            l = [cur[:2]]
            i = 0
            while i < len(res):
                fen = res[i]
                intersect = self.height - min(self.height, abs(fen[0] - cur[0]))
                intersect *= self.width - min(self.width, abs(fen[1] - cur[1]))
                criterion = intersect / (2.*self.height*self.width - intersect)
                
                if criterion > th:
                    l.append(fen[:2])
                    del res[i], proba[i]
                else:
                    i += 1
            
            xy = np.mean(l, axis = 0)
            res_nms.append((xy[0], xy[1]), cur[2])
            
        return res_nms         
        
if __name__ == '__main__':
    w = 15
    h = 15
    
    test = sliding_window(w, h)
    