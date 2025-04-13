

%% 6 统计图像的直方图
I=imread('cameraman.tif') ;%读取图像数据
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


%%  3.2 图像旋转
close all; clear; clc; %关闭所有图形窗口，清除工作空间所有变量，清空命令行
[I, map] =imread('peppers.png') ;%读入图像
Ta = maketform( 'affine ' ,...
[cosd(30) -sind(30) 0; sind(30) cosd(30) 0; 0 0 1]'); %创建旋转参 数结构体
Ia = imtransform(I, Ta) ;%实现图像旋转
imshow(Ia)

%缩放
Tb = maketform('affine',[5 0 0; 0 10.5 0; 0 0 1]');%创建缩放参数结构体
Ib = imtransform(I,Tb);%实现图像缩放


%平移
xform=[1 0 55;0 1 115;0 0 1]';%创建图像平移参数结构体
Tc = maketform('affine' ,xform) ;
Ic = imtransform(I,Tc, 'XData', ...%进行图像平移
[1 (size(I,2) +xform(3,1))], 'YData',...
[1 (size(I,1) +xform(3,2))],'FillValues', 255) ;


%剪切
Td = maketform('affine',[1 4 0; 2 1 0; 0 0 1]') ;%创建图像整体切变的参数结构体
Id = imtransform(I, Td, 'FillValues', 255); %实现图像整体切变


figure,%显示结果
subplot (221) , imshow(Ia) ,axis on;title('旋转');
subplot (222),imshow(Ib) ,axis on;title('缩放');
subplot (223),imshow(Ic) ,axis on;title('平移');
subplot (224),imshow(Id) ,axis on;title('剪切');



%% 5 插值算法
% 双线性插值算法
% 载入图像
img = imread('lena.jpg');  % 替换 'path_to_your_image.jpg' 为你的图像文件路径
imshow(img);
title('Original Image');

% 获取原图像大小
[rows, cols, channels] = size(img);

% 定义新的大小
newRows = 300;  % 新的行数
newCols = 300;  % 新的列数

% 初始化新图像
newImg = uint8(zeros(newRows, newCols, channels));

% 计算缩放比例
rowScale = rows / newRows;
colScale = cols / newCols;

% 双线性插值算法
for channel = 1:channels
    for i = 1:newRows
        for j = 1:newCols
            % 计算在原图中的坐标
            x = i * rowScale;
            y = j * colScale;

            % 计算周围的四个像素点
            x1 = floor(x);
            x2 = ceil(x);
            y1 = floor(y);
            y2 = ceil(y);

            % 确保坐标不超出图像边界
            x1 = max(x1, 1);
            x2 = min(x2, rows);
            y1 = max(y1, 1);
            y2 = min(y2, cols);

            % 双线性插值公式
            fa = double(img(x1, y1, channel)) * (x2 - x) + double(img(x2, y1, channel)) * (x - x1);
            fb = double(img(x1, y2, channel)) * (x2 - x) + double(img(x2, y2, channel)) * (x - x1);
            pixelValue = fa * (y2 - y) + fb * (y - y1);

            % 分配像素值到新图像
             if(pixelValue==0)
                newImg(i, j, channel) = img(x1,y1,channel);
            else
                newImg(i, j, channel) = pixelValue / ((x2 - x1) * (y2 - y1));
            end
        end
    end
end

% 显示插值后的图像
figure;
imshow(newImg);
title('Resized Image by Bilinear Interpolation');



% 载入图像
img = imread('lena.jpg');  % 替换 'path_to_your_image.jpg' 为你的图像文件路径

% 获取原图像的尺寸
[rows, cols, channels] = size(img);

% 定义新图像的尺寸
newRows = 300;  % 新的行数
newCols = 300;  % 新的列数

% 初始化新图像
newImg1 = uint8(zeros(newRows, newCols, channels));

% 计算缩放比例
rowScale = rows / newRows;
colScale = cols / newCols;

% 最近邻插值算法
for channel = 1:channels
    for i = 1:newRows
        for j = 1:newCols
            % 计算在原图中的坐标
            x = round(i * rowScale);
            y = round(j * colScale);

            % 确保坐标不超出图像边界
            x = min(max(x, 1), rows);
            y = min(max(y, 1), cols);

            % 直接使用最近的像素值
            newImg1(i, j, channel) = img(x, y, channel);
        end
    end
end

% 显示插值后的图像
figure;
imshow(newImg1);
title('Resized Image by Nearest Neighbor Interpolation');

close all
figure
subplot(121),imshow(newImg)
subplot(122),imshow(newImg1)





