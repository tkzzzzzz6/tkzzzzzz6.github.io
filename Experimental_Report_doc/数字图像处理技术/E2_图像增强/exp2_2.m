
%% Ƶ���˲�

% clear;close;clc
f=imread('exp5_test.tif');
f=im2double(f);
%ͼ����и���Ҷ�任
F=fft2(f);

%����dftuv��������Ƶ������
[U,V]=dftuv(size(f,1),size(f,2));
D=hypot(U,V);

%���ý�ֹƵ��
D0=40;
%���������ͨ�˲���
H1=single(D<=D0);
%������˹
N=6;
HB=1./(1+(D/D0).^(2*N));

%��˹
HG=exp(-(D.^2)/(2*D0*D0));

% ��ʾ�����˲�����Ƶ����Ӧ��������ͼ��
figure(2)
subplot(131),mesh(fftshift(H1)),title('�����ͨ�˲���(����)');
subplot(132),mesh(fftshift(HB)),title('������˹��ͨ�˲���(����)');
subplot(133),mesh(fftshift(HG)),title('��˹��ͨ�˲���(����)');

% ��ʾ�����˲�����Ƶ����Ӧ���Ľ���ͼ��
figure(5)
subplot(131),mesh(H1),title('�����ͨ�˲���(�Ľ�)');
subplot(132),mesh(HB),title('������˹��ͨ�˲���(�Ľ�)');
subplot(133),mesh(HG),title('��˹��ͨ�˲���(�Ľ�)');

% Ӧ�������˲�������ʾ���
G1=F.*H1;
g1=real(ifft2(G1));

G2=F.*HB;
g2=real(ifft2(G2));

G3=F.*HG;
g3=real(ifft2(G3));

% ��ʾ�˲����Ƶ�׺ͽ��
figure(3)
subplot(221), imshow(f), title('ԭͼ');
subplot(222), imshow(g1), title('�����ͨ�˲����');
subplot(223), imshow(g2), title('������˹��ͨ�˲����');
subplot(224), imshow(g3), title('��˹��ͨ�˲����');

% ��ʾ�˲����Ƶ��
figure(4)
subplot(221), imshow(log(1+abs(fftshift(F))), []), title('ԭͼƵ��');
subplot(222), imshow(log(1+abs(fftshift(G1))), []), title('�����ͨ�˲�Ƶ��');
subplot(223), imshow(log(1+abs(fftshift(G2))), []), title('������˹��ͨ�˲�Ƶ��');
subplot(224), imshow(log(1+abs(fftshift(G3))), []), title('��˹��ͨ�˲�Ƶ��');

% ��ʾ�Ľ���ͼ���˲����
figure(6)
subplot(221), imshow(f), title('ԭͼ');
subplot(222), imshow(real(ifft2(F.*H1))), title('�����ͨ�˲����(�Ľ�)');
subplot(223), imshow(real(ifft2(F.*HB))), title('������˹��ͨ�˲����(�Ľ�)');
subplot(224), imshow(real(ifft2(F.*HG))), title('��˹��ͨ�˲����(�Ľ�)');

% ��ʾ�Ľ���ͼ���˲�Ƶ��
figure(7)
subplot(221), imshow(log(1+abs(F)), []), title('ԭͼƵ��(�Ľ�)');
subplot(222), imshow(log(1+abs(G1)), []), title('�����ͨ�˲�Ƶ��(�Ľ�)');
subplot(223), imshow(log(1+abs(G2)), []), title('������˹��ͨ�˲�Ƶ��(�Ľ�)');
subplot(224), imshow(log(1+abs(G3)), []), title('��˹��ͨ�˲�Ƶ��(�Ľ�)');


%% ��ͨ�˲���
f = imread('exp5_test.tif');

% ���������ͨ�˲���
D0 = 30;  % ��ֹƵ��
[M, N] = size(f);
[U, V] = dftuv(M, N);
D = hypot(U, V);
H1 = double(D > D0);

% ���ɰ�����˹��ͨ�˲���
n = 2;  % ����
HB = 1./(1 + (D0./D).^(2*n));

% ���ɸ�˹��ͨ�˲���
HG = 1 - exp(-(D.^2)./(2*D0^2));

% Ӧ���˲���
F = fft2(f);
G1 = F.*H1;
G2 = F.*HB;
G3 = F.*HG;

g1 = real(ifft2(G1));
g2 = real(ifft2(G2));
g3 = real(ifft2(G3));

% ��ʾ���
figure
subplot(221), imshow(f), title('ԭͼ');
subplot(222), imshow(g1, []), title('�����ͨ�˲����');
subplot(223), imshow(g2, []), title('������˹��ͨ�˲����');
subplot(224), imshow(g3, []), title('��˹��ͨ�˲����');

%% �����˲���
clc; clear; close all;

%% 1. ���ɾ�������������ͼ��
f = imread('exp5_test.tif');
[m, n] = size(f);
fn = f;
for i = 1:m
    for j = 1:n
        fn(i,j) = fn(i,j) + 20*sin(20*i) + 20*sin(20*j);
    end
end

%% 2. ͼ����ʾ��Ƶ�����
% ��ʾԭͼ������������ͼ��
figure(1)
subplot(121), imshow(f), title('ԭͼ');
subplot(122), imshow(fn), title('��������������ͼ��');

% ��ʾƵ��ͼ��
F = fft2(fn);
FN = fftshift(log(1 + abs(F)));
figure(2)
imshow(FN, []), title('Ƶ��ͼ��');

%% 3. ��Ƹ�˹�����˲���
[U, V] = dftuv(size(FN,1), size(FN,2));
D = hypot(U, V);

% �������Ų���
D0 = 50;  % ��ֹƵ��
W = 30;   % ����

% ���ɴ����˲���
H = 1 - exp(-((D.^2 - D0^2)./(D.*W + eps)).^2);

% ��ʾ�˲���Ƶ����Ӧ
figure(3)
subplot(121), imshow(fftshift(H), []), title('�����˲���Ƶ����Ӧ');
subplot(122), mesh(fftshift(H)), title('�����˲���3D��ͼ');

%% 4. Ӧ���˲�������ʾ���
H = ifftshift(H);
g = real(ifft2(H.*F));

figure(4)
subplot(221), imshow(f), title('ԭͼ');
subplot(222), imshow(fn), title('������ͼ��');
subplot(223), imshow(g, []), title('�˲����');
subplot(224), imshow(res), title('��ֵ�˲����');

%% 5. �ԱȾ�ֵ�˲����
avg = fspecial('average', 3);
res = imfilter(fn, avg);
figure(5)
subplot(121), imshow(fn), title('������ͼ��');
subplot(122), imshow(res), title('��ֵ�˲����');





