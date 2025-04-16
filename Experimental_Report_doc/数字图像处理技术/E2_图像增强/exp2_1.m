%% 1.1 �Աȶ�����任
f = imread('football.jpg');
[m,n] = size(f);
f = im2double(f);

% ����任����
alpha = 0.3;  % ��һ��б��
belta = 1.5;  % �ڶ���б��
gamma = 0.5;  % ������б��
a = 0.2;      % ��һ�ηֽ��
b = 0.7;      % �ڶ��ηֽ��

% ��ʼ�����ͼ��
g = ones(m,n);

% �ֶ����Ա任
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

% ��ʾ���
figure
subplot(121), imshow(f); title('ԭʼͼ��');
subplot(122), imshow(g); title('�ֶ����Ա任��');

%% 1.2 ���ɱ任
% ��ȡ��ת��ͼ��
f = imread('football.jpg');
f = im2double(f);

% ����任����
e = 4;    % �ݴ�
m = 0.5;  % ��������
m1 = 0.2;
e1 = 1;

% ִ�����ɱ任
g = 1./(1 + (m./f).^e);
g1 = 1./(1 + (m1./f).^e);
g2 = 1./(1 + (m./f).^e1);

% ��ʾ���
figure
subplot(221), imshow(f); title('ԭʼͼ��');
subplot(222), imshow(g); title('���ɱ任��(e=4,m=0.5)');
subplot(223), imshow(g1); title('���ɱ任��(e=4,m=0.2)');
subplot(224), imshow(g2); title('���ɱ任��(e=1,m=0.5)');


%% 2 ֱ��ͼ�����ƥ��
%% 2.1 ֱ��ͼ���⻯
% ��ȡ��ת��ͼ��
f = imread('football.jpg');
f = im2double(f);
r1 = histeq(f);

% ��ʾ���⻯���ͼ����ֱ��ͼ
figure
subplot(221), imshow(f); title('ԭʼͼ��');
subplot(222), imhist(f); title('ԭʼֱ��ͼ');
subplot(223), imshow(r1); title('���⻯��ͼ��');
subplot(224), imhist(r1); title('���⻯��ֱ��ͼ');


%% 2.2 ֱ��ͼƥ��
% ��ȡԴͼ���Ŀ��ͼ��
f = imread('pout.tif');
f1 = imread('coins.png');
figure
subplot(121),imshow(f);title("ԭʼͼ��");
subplot(122),imshow(f1);title("����ƥ���ͼ��")
f = im2double(f);

% ִ��ֱ��ͼƥ��
g = histeq(f, imhist(f1));

% ��ʾƥ����
figure
subplot(121), imshow(f); title('ԭʼͼ��');
subplot(122), imshow(g); title('ֱ��ͼƥ���');

% ��ʾֱ��ͼ�Ա�
figure
subplot(131), imhist(f); title('ԭʼֱ��ͼ');
subplot(132), imhist(g); title('ƥ���ֱ��ͼ');
subplot(133), imhist(f1); title('Ŀ��ֱ��ͼ');

%% 2.3 ֱ��ͼƥ��Ľ�
% ��ȡԴͼ���Ŀ��ͼ��
f = imread('pout.tif');
f1 = imread('coins.png');
figure
subplot(121),imshow(f);title("ԭʼͼ��");
subplot(122),imshow(f1);title("����ƥ���ͼ��")

% % ת��Ϊ˫���Ȳ�ȷ��ͼ���Сһ��
% f = im2double(f);
% f1 = im2double(f1);
% if ~isequal(size(f), size(f1))
%     f1 = imresize(f1, size(f));
% end

% % ��ͼ�����Ԥ���� - �Աȶȵ���
% f = imadjust(f);  % �Զ������Աȶ�
% f1 = imadjust(f1);

% ִ��ֱ��ͼƥ��
g = histeq(f, imhist(f1));

% ��������ָ��
mse = immse(f, g);  % �������
ssim_val = ssim(f, g);  % �ṹ������
correlation = corr2(f, g);  % ���ϵ��

% ��ʾƥ����
figure('Name', 'ֱ��ͼƥ�����Ա�', 'NumberTitle', 'off');
subplot(121)
imshow(f)
title('ԭʼͼ��')
subplot(122)
imshow(g)
title('ֱ��ͼƥ���')

% ��ʾֱ��ͼ�Ա�
figure('Name', 'ֱ��ͼ�Ա�', 'NumberTitle', 'off');
subplot(311)
imhist(f)
title('ԭʼֱ��ͼ')
grid on
subplot(312)
imhist(g)
title('ƥ���ֱ��ͼ')
grid on
subplot(313)
imhist(f1)
title('Ŀ��ֱ��ͼ')
grid on

% ��ʾ����ָ��
fprintf('\nֱ��ͼƥ������ָ��:\n');
fprintf('������� (MSE): %f\n', mse);
fprintf('�ṹ������ (SSIM): %f\n', ssim_val);
fprintf('���ϵ��: %f\n', correlation);

% ��ʾ�ۻ�ֱ��ͼ�Ա�
figure('Name', '�ۻ�ֱ��ͼ�Ա�', 'NumberTitle', 'off');
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
legend('ԭʼͼ��', 'ƥ���ͼ��', 'Ŀ��ͼ��');
title('�ۻ�ֱ��ͼ�Ա�');
xlabel('�Ҷ�ֵ');
ylabel('�ۻ�����');

%% 3 ��ֵ�˲�
clc; close all; clear;

% ��ȡͼ���������
f = imread('football.jpg');
if size(f,3) == 3
    f_gray = rgb2gray(f);
else
    f_gray = f;
end
f_noise_gaussian = imnoise(f_gray, 'gaussian', 0, 0.01);    % ��Ӹ�˹����
f_noise_saltpepper = imnoise(f_gray, 'salt & pepper', 0.1); % ��ӽ�������

% ������ͬ�ߴ�ľ�ֵ�˲���
kernel_sizes = [5, 9, 15, 35];
for i = 1:length(kernel_sizes)
    h{i} = fspecial('average', kernel_sizes(i));
end

% �Ը�˹����ͼ����о�ֵ�˲�
for i = 1:length(kernel_sizes)
    gaussian_mean{i} = imfilter(f_noise_gaussian, h{i});
end

% �Խ�������ͼ����о�ֵ�˲�
for i = 1:length(kernel_sizes)
    saltpepper_mean{i} = imfilter(f_noise_saltpepper, h{i});
end

% �Ը�˹�����ͽ�������ͼ�������ֵ�˲���֧�ֲ�ɫͼ��
gaussian_median = medfilt2(f_noise_gaussian, [5 5]);
saltpepper_median = medfilt2(f_noise_saltpepper, [5 5]);

% ��ʾ��˹������ֵ�˲�Ч��
figure('Name','��˹������ֵ�˲�');
subplot(2,3,1), imshow(f_gray), title('ԭʼͼ��');
subplot(2,3,2), imshow(f_noise_gaussian), title('��˹����');
for i = 1:length(kernel_sizes)
    subplot(2,3,i+2), imshow(gaussian_mean{i}), title([num2str(kernel_sizes(i)),'x',num2str(kernel_sizes(i)),'��ֵ�˲�']);
end

% ��ʾ����������ֵ�˲�Ч��
figure('Name','����������ֵ�˲�');
subplot(2,3,1), imshow(f_gray), title('ԭʼͼ��');
subplot(2,3,2), imshow(f_noise_saltpepper), title('��������');
for i = 1:length(kernel_sizes)
    subplot(2,3,i+2), imshow(saltpepper_mean{i}), title([num2str(kernel_sizes(i)),'x',num2str(kernel_sizes(i)),'��ֵ�˲�']);
end

% �ԱȾ�ֵ�˲�����ֵ�˲��Ľ��
figure('Name','��ֵ����ֵ�˲��Ա�');
subplot(2,2,1), imshow(gaussian_mean{1}), title('��˹����-5x5��ֵ�˲�');
subplot(2,2,2), imshow(saltpepper_mean{1}), title('��������-5x5��ֵ�˲�');
subplot(2,2,3), imshow(gaussian_median), title('��˹����-5x5��ֵ�˲�');
subplot(2,2,4), imshow(saltpepper_median), title('��������-5x5��ֵ�˲�');

%% 4 ������˹��
% ��ȡ��ת��ͼ��
f = imread('cameraman.tif');
f = im2double(f);

% �����׼������˹����
h1 = fspecial('laplacian', 0); % Matlab��׼
h2 = [-1 -1 -1; -1 8 -1; -1 -1 -1]; % �������ĶԳ�������˹

% Ӧ��������˹���ӣ�ָ���߽紦��ʽ'replicate'��
lap1 = imfilter(f, h1, 'replicate');
lap2 = imfilter(f, h2, 'replicate');

% ������˹��ǿ
sharp1 = f - lap1; % ��ȥ������˹���
sharp2 = f + lap2; % ����������˹���

% Unsharp Masking����˹ģ�������񻯣�
h3 = fspecial('gaussian', [3 3], 1);
blur = imfilter(f, h3, 'replicate');
sharp3 = imadjust(f + (f - blur)); % �����Աȶ�

% ���岢Ӧ����ģ��
h4 = [0 -1 0; -1 5 -1; 0 -1 0];
sharp4 = imfilter(f, h4, 'replicate');

% ��һ����ʾ�������ֹ����Χ
lap1 = mat2gray(lap1);
lap2 = mat2gray(lap2);
sharp1 = mat2gray(sharp1);
sharp2 = mat2gray(sharp2);
sharp3 = mat2gray(sharp3);
sharp4 = mat2gray(sharp4);

% ��ʾ���н��
figure('Name','������˹������ǿ�Ա�');
subplot(2,3,1), imshow(f), title('ԭʼͼ��');
subplot(2,3,2), imshow(lap1), title('������˹����1');
subplot(2,3,3), imshow(lap2), title('������˹����2');
subplot(2,3,4), imshow(sharp1), title('��ǿ1: f-lap1');
subplot(2,3,5), imshow(sharp2), title('��ǿ2: f+lap2');
subplot(2,3,6), imshow(sharp4), title('ģ����');

% ��ʾUnsharp Masking���
figure('Name','Unsharp Masking��');
subplot(1,2,1), imshow(f), title('ԭʼͼ��');
subplot(1,2,2), imshow(sharp3), title('Unsharp Masking');
