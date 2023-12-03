clear
clc

% 嵌入设置
watermarkStrength = 20;  % 水印强度
key = 717;               % 密钥
% 嵌入系数选取，选择中频
dctCoef = [0, 0, 0, 1, 1, 1, 1, 0;
    0, 0, 1, 1, 1, 1, 0, 0;
    0, 1, 1, 1, 1, 0, 0, 0;
    1, 1, 1, 1, 0, 0, 0, 0;
    1, 1, 1, 0, 0, 0, 0, 0;
    1, 1, 0, 0, 0, 0, 0, 0;
    1, 0, 0, 0, 0, 0, 0, 0;
    0, 0, 0, 0, 0, 0, 0, 0];

% 读取图像
inputImg = rgb2gray(imread('TestImage/Input.jpg'));  % 输入原图
watermark = imbinarize(rgb2gray(imread('TestImage/SmallWatermark.jpg')));  % 水印图

% 载体预处理
inputImg = inputImg(1 : floor(size(inputImg, 1) / 8) * 8, 1 : floor(size(inputImg, 2) / 8) * 8);

% 嵌入水印
outputImg = DCT_Encode(inputImg, watermark, watermarkStrength, dctCoef, key);
imwrite(outputImg, 'TestImage/DCT_EncodeImg.png');

% 提取水印
watermark = DCT_Decode(outputImg, inputImg, size(watermark, 1), size(watermark, 2), dctCoef, key);

% 变换为8位深度恢复显示效果
watermark = watermark * 255;
imwrite(watermark, 'TestImage/DCT_DecodeImg.png');
