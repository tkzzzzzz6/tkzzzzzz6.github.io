close all; clear all; clc;
f = imread('rectangle.png');
g = rgb2gray(f);
G = fft2(g);
imshow(abs(G),[])
f1 = imread('square.png');
f2 = imread('bld.png');

 