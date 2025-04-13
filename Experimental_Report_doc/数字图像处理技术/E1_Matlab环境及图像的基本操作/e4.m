%% 5 插值算法
% 双线性插值算法
% 载入图像
img = imread('football.jpg'); 

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




% 载入图像
img = imread('football.jpg');  % 替换 'path_to_your_image.jpg' 为你的图像文件路径

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

figure
subplot(131),imshow(img);title('Original Image');
subplot(132),imshow(newImg);title('双线性');
subplot(133),imshow(newImg1);title('最近邻');