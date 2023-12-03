clear
clc

% 嵌入设置，支持二值水印和灰度水印
watermarkDepth = 1;  % 水印深度（量化级数为2^watermarkDepth）

% 读取图像
inputImg = rgb2gray(imread('TestImage/Input.jpg'));  % 输入原图
watermark = rgb2gray(imread('TestImage/BinWatermark.jpg'));  % 水印图

% 嵌入水印
outputImg = LSB_Encode(inputImg, watermark, watermarkDepth);
imwrite(outputImg, 'TestImage/LSB_EncodeImg.png');

% 提取水印
watermark = LSB_Decode(outputImg, watermarkDepth);
imwrite(watermark, 'TestImage/LSB_DecodeImg.png');
