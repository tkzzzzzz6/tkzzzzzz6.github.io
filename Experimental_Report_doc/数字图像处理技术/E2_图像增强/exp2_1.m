%% 1.1 对比度拉伸变换
f = imread('football.jpg');
[m,n] = size(f);
f = im2double(f);

% 定义变换参数
alpha = 0.3;  % 第一段斜率
belta = 1.5;  % 第二段斜率
gamma = 0.5;  % 第三段斜率
a = 0.2;      % 第一段分界点
b = 0.7;      % 第二段分界点

% 初始化输出图像
g = ones(m,n);

% 分段线性变换
for i = 1:m
    for j = 1:n
        if(f(i,j) < a && f(i,j) >= 0)
            g(i,j) = f(i,j) * alpha;
        end
        if(f(i,j) < b && f(i,j) >= a)
            g(i,j) = (f(i,j) - a) * belta + a * alpha;
        end
        if(f(i,j) < 1 && f(i,j) >= b)
            g(i,j) = (f(i,j) - b) * gamma + belta * (b-a) + a * alpha;
        end
    end
end

% 显示结果
figure
subplot(121), imshow(f); title('原始图像');
subplot(122), imshow(g); title('分段线性变换后');

%% 1.2 幂律变换
% 读取并转换图像
f = imread('football.jpg');
f = im2double(f);

% 定义变换参数
e = 4;    % 幂次
m = 0.5;  % 缩放因子
m1 = 0.2;
e1 = 1;

% 执行幂律变换
g = 1./(1 + (m./f).^e);
g1 = 1./(1 + (m1./f).^e);
g2 = 1./(1 + (m./f).^e1);

% 显示结果
figure
subplot(221), imshow(f); title('原始图像');
subplot(222), imshow(g); title('幂律变换后(e=4,m=0.5)');
subplot(223), imshow(g1); title('幂律变换后(e=4,m=0.2)');
subplot(224), imshow(g2); title('幂律变换后(e=1,m=0.5)');


%% 2 直方图均衡和匹配
%% 2.1 直方图均衡化
% 读取并转换图像
f = imread('football.jpg');
f = im2double(f);
r1 = histeq(f);

% 显示均衡化后的图像与直方图
figure
subplot(221), imshow(f); title('原始图像');
subplot(222), imhist(f); title('原始直方图');
subplot(223), imshow(r1); title('均衡化后图像');
subplot(224), imhist(r1); title('均衡化后直方图');


%% 2.2 直方图匹配
% 读取源图像和目标图像
f = imread('pout.tif');
f1 = imread('coins.png');
figure
subplot(121),imshow(f);title("原始图像");
subplot(122),imshow(f1);title("用于匹配的图像")
f = im2double(f);

% 执行直方图匹配
g = histeq(f, imhist(f1));

% 显示匹配结果
figure
subplot(121), imshow(f); title('原始图像');
subplot(122), imshow(g); title('直方图匹配后');

% 显示直方图对比
figure
subplot(131), imhist(f); title('原始直方图');
subplot(132), imhist(g); title('匹配后直方图');
subplot(133), imhist(f1); title('目标直方图');

%% 2.3 直方图匹配改进
% 读取源图像和目标图像
f = imread('pout.tif');
f1 = imread('coins.png');
figure
subplot(121),imshow(f);title("原始图像");
subplot(122),imshow(f1);title("用于匹配的图像")

% % 转换为双精度并确保图像大小一致
% f = im2double(f);
% f1 = im2double(f1);
% if ~isequal(size(f), size(f1))
%     f1 = imresize(f1, size(f));
% end

% % 对图像进行预处理 - 对比度调整
% f = imadjust(f);  % 自动调整对比度
% f1 = imadjust(f1);

% 执行直方图匹配
g = histeq(f, imhist(f1));

% 计算评估指标
mse = immse(f, g);  % 均方误差
ssim_val = ssim(f, g);  % 结构相似性
correlation = corr2(f, g);  % 相关系数

% 显示匹配结果
figure('Name', '直方图匹配结果对比', 'NumberTitle', 'off');
subplot(121)
imshow(f)
title('原始图像')
subplot(122)
imshow(g)
title('直方图匹配后')

% 显示直方图对比
figure('Name', '直方图对比', 'NumberTitle', 'off');
subplot(311)
imhist(f)
title('原始直方图')
grid on
subplot(312)
imhist(g)
title('匹配后直方图')
grid on
subplot(313)
imhist(f1)
title('目标直方图')
grid on

% 显示评估指标
fprintf('\n直方图匹配评估指标:\n');
fprintf('均方误差 (MSE): %f\n', mse);
fprintf('结构相似性 (SSIM): %f\n', ssim_val);
fprintf('相关系数: %f\n', correlation);

% 显示累积直方图对比
figure('Name', '累积直方图对比', 'NumberTitle', 'off');
[counts_f, x] = imhist(f);
[counts_g, ~] = imhist(g);
[counts_f1, ~] = imhist(f1);

cdf_f = cumsum(counts_f) / sum(counts_f);
cdf_g = cumsum(counts_g) / sum(counts_g);
cdf_f1 = cumsum(counts_f1) / sum(counts_f1);

plot(x, cdf_f, 'b-', 'LineWidth', 2);
hold on;
plot(x, cdf_g, 'r--', 'LineWidth', 2);
plot(x, cdf_f1, 'g:', 'LineWidth', 2);
grid on;
legend('原始图像', '匹配后图像', '目标图像');
title('累积直方图对比');
xlabel('灰度值');
ylabel('累积概率');

%% 3 均值滤波
clc; close all; clear;

% 读取图像并添加噪声
f = imread('football.jpg');
if size(f,3) == 3
    f_gray = rgb2gray(f);
else
    f_gray = f;
end
f_noise_gaussian = imnoise(f_gray, 'gaussian', 0, 0.01);    % 添加高斯噪声
f_noise_saltpepper = imnoise(f_gray, 'salt & pepper', 0.1); % 添加椒盐噪声

% 创建不同尺寸的均值滤波器
kernel_sizes = [5, 9, 15, 35];
for i = 1:length(kernel_sizes)
    h{i} = fspecial('average', kernel_sizes(i));
end

% 对高斯噪声图像进行均值滤波
for i = 1:length(kernel_sizes)
    gaussian_mean{i} = imfilter(f_noise_gaussian, h{i});
end

% 对椒盐噪声图像进行均值滤波
for i = 1:length(kernel_sizes)
    saltpepper_mean{i} = imfilter(f_noise_saltpepper, h{i});
end

% 对高斯噪声和椒盐噪声图像进行中值滤波（支持彩色图像）
gaussian_median = medfilt2(f_noise_gaussian, [5 5]);
saltpepper_median = medfilt2(f_noise_saltpepper, [5 5]);

% 显示高斯噪声均值滤波效果
figure('Name','高斯噪声均值滤波');
subplot(2,3,1), imshow(f_gray), title('原始图像');
subplot(2,3,2), imshow(f_noise_gaussian), title('高斯噪声');
for i = 1:length(kernel_sizes)
    subplot(2,3,i+2), imshow(gaussian_mean{i}), title([num2str(kernel_sizes(i)),'x',num2str(kernel_sizes(i)),'均值滤波']);
end

% 显示椒盐噪声均值滤波效果
figure('Name','椒盐噪声均值滤波');
subplot(2,3,1), imshow(f_gray), title('原始图像');
subplot(2,3,2), imshow(f_noise_saltpepper), title('椒盐噪声');
for i = 1:length(kernel_sizes)
    subplot(2,3,i+2), imshow(saltpepper_mean{i}), title([num2str(kernel_sizes(i)),'x',num2str(kernel_sizes(i)),'均值滤波']);
end

% 对比均值滤波和中值滤波的结果
figure('Name','均值与中值滤波对比');
subplot(2,2,1), imshow(gaussian_mean{1}), title('高斯噪声-5x5均值滤波');
subplot(2,2,2), imshow(saltpepper_mean{1}), title('椒盐噪声-5x5均值滤波');
subplot(2,2,3), imshow(gaussian_median), title('高斯噪声-5x5中值滤波');
subplot(2,2,4), imshow(saltpepper_median), title('椒盐噪声-5x5中值滤波');

%% 4 拉普拉斯锐化
% 读取并转换图像
f = imread('cameraman.tif');
f = im2double(f);

% 定义标准拉普拉斯算子
h1 = fspecial('laplacian', 0); % Matlab标准
h2 = [-1 -1 -1; -1 8 -1; -1 -1 -1]; % 常用中心对称拉普拉斯

% 应用拉普拉斯算子（指定边界处理方式'replicate'）
lap1 = imfilter(f, h1, 'replicate');
lap2 = imfilter(f, h2, 'replicate');

% 拉普拉斯增强
sharp1 = f - lap1; % 减去拉普拉斯结果
sharp2 = f + lap2; % 加上拉普拉斯结果

% Unsharp Masking（高斯模糊减法锐化）
h3 = fspecial('gaussian', [3 3], 1);
blur = imfilter(f, h3, 'replicate');
sharp3 = imadjust(f + (f - blur)); % 调整对比度

% 定义并应用锐化模板
h4 = [0 -1 0; -1 5 -1; 0 -1 0];
sharp4 = imfilter(f, h4, 'replicate');

% 归一化显示结果，防止超范围
lap1 = mat2gray(lap1);
lap2 = mat2gray(lap2);
sharp1 = mat2gray(sharp1);
sharp2 = mat2gray(sharp2);
sharp3 = mat2gray(sharp3);
sharp4 = mat2gray(sharp4);

% 显示所有结果
figure('Name','拉普拉斯锐化与增强对比');
subplot(2,3,1), imshow(f), title('原始图像');
subplot(2,3,2), imshow(lap1), title('拉普拉斯算子1');
subplot(2,3,3), imshow(lap2), title('拉普拉斯算子2');
subplot(2,3,4), imshow(sharp1), title('增强1: f-lap1');
subplot(2,3,5), imshow(sharp2), title('增强2: f+lap2');
subplot(2,3,6), imshow(sharp4), title('模板锐化');

% 显示Unsharp Masking结果
figure('Name','Unsharp Masking锐化');
subplot(1,2,1), imshow(f), title('原始图像');
subplot(1,2,2), imshow(sharp3), title('Unsharp Masking');
