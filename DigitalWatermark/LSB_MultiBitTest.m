clear
clc

% 读取图像
inputImg = rgb2gray(imread('TestImage/Input.jpg'));  % 输入原图
originWatermark = rgb2gray(imread('TestImage/Watermark.png'));  % 水印图

for watermarkDepth = 1 : 8
    % 嵌入水印
    outputImg = LSB_Encode(inputImg, originWatermark, watermarkDepth);
    fname = sprintf('TestImage/LSB_EncodeImg_%dbit.png', watermarkDepth);
    imwrite(outputImg, fname);
    
    % 提取水印
    watermark = LSB_Decode(outputImg, watermarkDepth);
    fname = sprintf('TestImage/LSB_DecodeImg_%dbit.png', watermarkDepth);
    imwrite(watermark, fname);
end
