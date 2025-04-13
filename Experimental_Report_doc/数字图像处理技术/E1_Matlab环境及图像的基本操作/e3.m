clear;clc;close all;
%% 1.图像的平移，旋转，缩放等几何变换
clear;clc;close all;
I = imread('football.jpg')

%% 1.1平移
% 定义平移变换矩阵
tform_translate = maketform('affine', [1 0 55; 0 1 115; 0 0 1]');
I_translated = imtransform(I, tform_translate);

%% 1.2旋转
% 定义旋转变换矩阵，顺时针旋转角度为45度
angle = 45;
tform_rotate = maketform('affine', [cosd(angle) -sind(angle) 0; sind(angle) cosd(angle) 0; 0 0 1]);
I_rotated = imtransform(I, tform_rotate);

%% 1.3缩放
% 定义缩放变换矩阵，缩放比例
scale_x = 5;
scale_y = 10;
% [5 0 0;0 10 0;0 0 1]
scale = 0.5;
tform_scale = maketform('affine', [scale_x 0 0; 0 scale_y 0; 0 0 1]);
I_scaled = imtransform(I, tform_scale);

figure;
subplot(2, 2, 1);imshow(I);title('原始图像');
subplot(2, 2, 2);imshow(I_translated);title('平移后的图像');
subplot(2, 2, 3);imshow(I_rotated);title('旋转后的图像');
subplot(2, 2, 4);imshow(I_scaled);title('缩放后的图像');

%% 2.编写函数实现图像的平移，转置，镜像等几何操作

%% 2.1 平移
close all ;clear all ;clc ;
I = imread('football.jpg');
[H,W,Z] = size(I); % 获取图像大小，H为垂直方向，W为水平方向

I=im2double(I);%将图像类型转换成双精度

res = ones(H,W,Z); % 构造结果矩阵。每个像素点默认初始化为1（白色）
delX = 50; % 平移量X
delY = 100; % 平移量Y

tras = [1 0 delX; 0 1 delY; 0 0 1]; % 平移的变换矩阵

for x0 = 1 : H %行
    for y0 = 1 : W %列
        temp = [x0; y0; 1];%将每一点的位置进行缓存，1行1列，1行2列···1行1024列
        temp = tras * temp; % 根据算法进行，矩阵乘法：转换矩阵乘以原像素位置
        x1 = temp(1, 1);%新的像素x1位置，也就是新的行位置
        y1 = temp(2, 1);%新的像素y1位置,也就是新的列位置
        % 变换后的位置判断是否越界
        if (x1 <= H) & (y1 <= W) & (x1 >= 1) & (y1 >= 1)%新的行位置要小于新的列位置
            res1(x1,y1,:)= I(x0,y0,:);%进行图像平移，颜色赋值
        end
    end
end;

%% 2.2 转置
[H,W,Z] = size(I); % 获取图像大小，H为垂直方向，W为水平方向
I=im2double(I);%将图像类型转换成双精度
res = ones(H,W,Z); % 构造结果矩阵。每个像素点默认初始化为1（白色）
tras = [0 1 0; 1 0 0; 0 0 1]; % 转置的变换矩阵
for x0 = 1 : H
    for y0 = 1 : W
        temp = [x0; y0; 1];%将每一点的位置进行缓存，1行1列，1行2列···1行1024列
        temp = tras * temp; % 根据算法进行，矩阵乘法：转换矩阵乘以原像素位置
        x1 = temp(1, 1);%新的像素x1位置，也就是新的行位置（从1~768）
        y1 = temp(2, 1);%新的像素y1位置,也就是新的列位置（从1~1024）
        % 变换后的位置判断是否越界
        if (x1 <= H) & (y1 <= W) & (x1 >= 1) & (y1 >= 1)%新的行位置要小于新的列位置
            res2(x1,y1,:)= I(x0,y0,:);%进行图像颜色赋值
        end
    end
end;

%% 2.3 镜像
[H,W,Z] = size(I); % 获取图像大小，H为垂直方向，W为水平方向
I=im2double(I);%将图像类型转换成双精度
res = ones(H,W,Z); % 构造结果矩阵。每个像素点默认初始化为1（白色）
tras = [1 0 0; 0 -1 W; 0 0 1]; % 水平镜像的变换矩阵 
for x0 = 1 : H
    for y0 = 1 : W
        temp = [x0; y0; 1];%将每一点的位置进行缓存，1行1列，1行2列···1行1024列
        temp = tras * temp; % 根据算法进行，矩阵乘法：转换矩阵乘以原像素位置
        x1 = temp(1, 1);%新的像素x1位置，也就是新的行位置
        y1 = temp(2, 1);%新的像素y1位置,也就是新的列位置
        % 变换后的位置判断是否越界
        if (x1 <= H) & (y1 <= W) & (x1 >= 1) & (y1 >= 1)%新的行位置要小于新的列位置
            res3(x1,y1,:)= I(x0,y0,:);%进行图像颜色赋值
        end
    end
end;
set(0,'defaultFigurePosition',[100,100,1000,500]);%设置窗口大小
set(0,'defaultFigureColor',[1 1 1]);%设置窗口颜色
figure;%打开一个窗口，用来显示（多幅）图像
subplot(2,2,1), imshow(I),axis on ;title('原图');
subplot(2,2,2), imshow(res1),axis on;title('平移');
subplot(2,2,3), imshow(res2),axis on;title('转置');
subplot(2,2,4), imshow(res3),axis on;title('镜像');
