clear;clc;close all;
f = imread("football.jpg");
%% 1.图像反转
g = im2gray(f);
g1 = 255-g;
figure
subplot(121),imshow(g);
subplot(122),imshow(g1);
%% 2.对数变换
f2 = imread('DFT.tif');
c = 1.0;
%mat2gray将数据缩放到0-1,直接使用imshow只会显示0-1之间的像素
g2 = mat2gray(c*log(1+double(f2)));
figure
subplot(121),imshow(f2);
subplot(122),imshow(g2);

%% 3.消除加性噪声
clear;clc;close all;

rgb = imread('eight.tif');
rgb = im2double(rgb);
I = im2double(zeros(size(rgb)));
M = 100;

for i = 1:M
    A = imnoise(rgb,"gaussian",0,0.05);
    I = imadd(I,A);
end
avg_A = I/M;
figure
subplot(121),imshow(A);
subplot(122),imshow(avg_A);

%% 4.灰度直方图
clear;clc;close all;

f4 = imread('football.jpg');
g = im2gray(f4);

% 计算灰度图像的直方图
[counts, ~] = imhist(g);

figure
subplot(131),imshow(f4),title('原始图像');
subplot(132),imshow(g),title('灰度图像');
subplot(133),bar(counts),title('灰度直方图');
xlabel('灰度级');
ylabel('像素数');

%% 函数实现
%% 6 统计图像的直方图
I=imread('football.jpg') ;%读取图像数据
imshow(I);
r=size(I,1);
c=size(I,2);
N=zeros(1,256);
for i=1:r
    for j=1:c
        m=I(i,j);
        N(m+1) =N(m+1)+1;%记录每个灰度值的像素数
    end
end
%figure
subplot(1,2,1);%subplot将窗口分为1x2两个窗口，现在在第一个小窗口绘制原图
imshow(I); 
subplot(1,2,2);
figure
imhist(I);
figure
bar(N);%bar函数绘制直方图，为N中每一行的每一个元素绘制一个条
axis tight;%设置坐标轴

