
%% 频域滤波

% clear;close;clc
f=imread('exp5_test.tif');
f=im2double(f);
%图像进行傅里叶变换
F=fft2(f);

%利用dftuv函数生成频域坐标
[U,V]=dftuv(size(f,1),size(f,2));
D=hypot(U,V);

%设置截止频率
D0=40;
%生成理想低通滤波器
H1=single(D<=D0);
%巴特沃斯
N=6;
HB=1./(1+(D/D0).^(2*N));

%高斯
HG=exp(-(D.^2)/(2*D0*D0));

% 显示三种滤波器的频率响应（中心视图）
figure(2)
subplot(131),mesh(fftshift(H1)),title('理想低通滤波器(中心)');
subplot(132),mesh(fftshift(HB)),title('巴特沃斯低通滤波器(中心)');
subplot(133),mesh(fftshift(HG)),title('高斯低通滤波器(中心)');

% 显示三种滤波器的频率响应（四角视图）
figure(5)
subplot(131),mesh(H1),title('理想低通滤波器(四角)');
subplot(132),mesh(HB),title('巴特沃斯低通滤波器(四角)');
subplot(133),mesh(HG),title('高斯低通滤波器(四角)');

% 应用三种滤波器并显示结果
G1=F.*H1;
g1=real(ifft2(G1));

G2=F.*HB;
g2=real(ifft2(G2));

G3=F.*HG;
g3=real(ifft2(G3));

% 显示滤波后的频谱和结果
figure(3)
subplot(221), imshow(f), title('原图');
subplot(222), imshow(g1), title('理想低通滤波结果');
subplot(223), imshow(g2), title('巴特沃斯低通滤波结果');
subplot(224), imshow(g3), title('高斯低通滤波结果');

% 显示滤波后的频谱
figure(4)
subplot(221), imshow(log(1+abs(fftshift(F))), []), title('原图频谱');
subplot(222), imshow(log(1+abs(fftshift(G1))), []), title('理想低通滤波频谱');
subplot(223), imshow(log(1+abs(fftshift(G2))), []), title('巴特沃斯低通滤波频谱');
subplot(224), imshow(log(1+abs(fftshift(G3))), []), title('高斯低通滤波频谱');

% 显示四角视图的滤波结果
figure(6)
subplot(221), imshow(f), title('原图');
subplot(222), imshow(real(ifft2(F.*H1))), title('理想低通滤波结果(四角)');
subplot(223), imshow(real(ifft2(F.*HB))), title('巴特沃斯低通滤波结果(四角)');
subplot(224), imshow(real(ifft2(F.*HG))), title('高斯低通滤波结果(四角)');

% 显示四角视图的滤波频谱
figure(7)
subplot(221), imshow(log(1+abs(F)), []), title('原图频谱(四角)');
subplot(222), imshow(log(1+abs(G1)), []), title('理想低通滤波频谱(四角)');
subplot(223), imshow(log(1+abs(G2)), []), title('巴特沃斯低通滤波频谱(四角)');
subplot(224), imshow(log(1+abs(G3)), []), title('高斯低通滤波频谱(四角)');


%% 高通滤波器
f = imread('exp5_test.tif');

% 生成理想高通滤波器
D0 = 30;  % 截止频率
[M, N] = size(f);
[U, V] = dftuv(M, N);
D = hypot(U, V);
H1 = double(D > D0);

% 生成巴特沃斯高通滤波器
n = 2;  % 阶数
HB = 1./(1 + (D0./D).^(2*n));

% 生成高斯高通滤波器
HG = 1 - exp(-(D.^2)./(2*D0^2));

% 应用滤波器
F = fft2(f);
G1 = F.*H1;
G2 = F.*HB;
G3 = F.*HG;

g1 = real(ifft2(G1));
g2 = real(ifft2(G2));
g3 = real(ifft2(G3));

% 显示结果
figure
subplot(221), imshow(f), title('原图');
subplot(222), imshow(g1, []), title('理想高通滤波结果');
subplot(223), imshow(g2, []), title('巴特沃斯高通滤波结果');
subplot(224), imshow(g3, []), title('高斯高通滤波结果');

%% 带阻滤波器
clc; clear; close all;

%% 1. 生成具有周期噪声的图像
f = imread('exp5_test.tif');
[m, n] = size(f);
fn = f;
for i = 1:m
    for j = 1:n
        fn(i,j) = fn(i,j) + 20*sin(20*i) + 20*sin(20*j);
    end
end

%% 2. 图像显示与频域分析
% 显示原图和添加噪声后的图像
figure(1)
subplot(121), imshow(f), title('原图');
subplot(122), imshow(fn), title('添加周期噪声后的图像');

% 显示频域图像
F = fft2(fn);
FN = fftshift(log(1 + abs(F)));
figure(2)
imshow(FN, []), title('频域图像');

%% 3. 设计高斯带阻滤波器
[U, V] = dftuv(size(FN,1), size(FN,2));
D = hypot(U, V);

% 设置最优参数
D0 = 50;  % 截止频率
W = 30;   % 带宽

% 生成带阻滤波器
H = 1 - exp(-((D.^2 - D0^2)./(D.*W + eps)).^2);

% 显示滤波器频域响应
figure(3)
subplot(121), imshow(fftshift(H), []), title('带阻滤波器频域响应');
subplot(122), mesh(fftshift(H)), title('带阻滤波器3D视图');

%% 4. 应用滤波器并显示结果
H = ifftshift(H);
g = real(ifft2(H.*F));

figure(4)
subplot(221), imshow(f), title('原图');
subplot(222), imshow(fn), title('含噪声图像');
subplot(223), imshow(g, []), title('滤波结果');
subplot(224), imshow(res), title('均值滤波结果');

%% 5. 对比均值滤波结果
avg = fspecial('average', 3);
res = imfilter(fn, avg);
figure(5)
subplot(121), imshow(fn), title('含噪声图像');
subplot(122), imshow(res), title('均值滤波结果');





