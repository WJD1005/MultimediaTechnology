clear
clc

% 水印深度，支持二值水印和灰度水印，需要与嵌入设置相同
watermarkDepth = 1;  % 水印深度

% 读取攻击后的图像
% 压缩、旋转、裁剪在Photoshop进行，需重新转换为灰度图
compressImg = rgb2gray(imread('TestImage/LSB_EncodeImg_Compress.jpg'));  % 压缩
rotateImg = rgb2gray(imread('TestImage/LSB_EncodeImg_Rotate.png'));      % 旋转
cropImg = rgb2gray(imread('TestImage/LSB_EncodeImg_Crop.png'));          % 裁剪
gaussianNoiseImg = imread('TestImage/LSB_EncodeImg_GaussianNoise.png');      % 高斯噪声
saltPepperNoiseImg = imread('TestImage/LSB_EncodeImg_SaltPepperNoise.png');  % 椒盐噪声

% 提取水印
compressWatermark = LSB_Decode(compressImg, watermarkDepth);
rotateWatermark = LSB_Decode(rotateImg, watermarkDepth);
cropWatermark = LSB_Decode(cropImg, watermarkDepth);
gaussianNoiseWatermark = LSB_Decode(gaussianNoiseImg, watermarkDepth);
saltPepperNoiseWatermark = LSB_Decode(saltPepperNoiseImg, watermarkDepth);

% 输出
imwrite(compressWatermark, 'TestImage/LSB_EncodeImg_Compress_DecodeImg.png');
imwrite(rotateWatermark, 'TestImage/LSB_EncodeImg_Rotate_DecodeImg.png');
imwrite(cropWatermark, 'TestImage/LSB_EncodeImg_Crop_DecodeImg.png');
imwrite(gaussianNoiseWatermark, 'TestImage/LSB_EncodeImg_GaussianNoise_DecodeImg.png');
imwrite(saltPepperNoiseWatermark, 'TestImage/LSB_EncodeImg_SaltPepperNoise_DecodeImg.png');


