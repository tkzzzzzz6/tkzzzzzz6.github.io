clear,clc,close all;

%% 1.图像的读取和显示
f1 =imread('football.jpg');
% imshow(f1);
[f2,map2] = imread('trees.tif');
% imshow(f2,map2);
[f3,map3]=imread('cameraman.tif');
% imshow(f3,map3);
figure
subplot(1,3,1);
imshow(f1);
subplot(1,3,2);
imshow(f2,map2);
subplot(1,3,3);
imshow(f3,map3);

%% 2.不同类型的图像的转换
% work1
g1 = rgb2gray(f1);
figure
subplot(1,2,1),imshow(f1);
subplot(1,2,2),imshow(g1);
% work2
bw1 = im2bw(f1,0.3); 
bw2 = im2bw(f1,0.7);
%官方推荐使用imbinarize
figure
subplot(1,3,1),imshow(f1);
subplot(1,3,2),imshow(bw1);
subplot(1,3,3),imshow(bw2);

%% 3.图像数据类型的转换
%work1
f=[-0.5 0.5;0.75 1.5];
G=im2uint8(f);
%work2
A = [128, 300; -12, 66.98];
G1 = mat2gray(A, [0, 255]);
G2 = mat2gray(A);
