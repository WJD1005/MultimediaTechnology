clear
clc

inputImg = imread('TestImage/LSB_EncodeImg.png');  % 原图

% 压缩、旋转、裁剪在Photoshop中进行，以模仿真实环境
gaussianNoiseImg = imnoise(inputImg, 'gaussian');  % 均值为0，方差为0.01的高斯噪声
saltPepperNoiseImg = imnoise(inputImg, 'salt & pepper');  % 密度为0.05的椒盐噪声

imwrite(gaussianNoiseImg, 'TestImage/LSB_EncodeImg_GaussianNoise.png');
imwrite(saltPepperNoiseImg, 'TestImage/LSB_EncodeImg_SaltPepperNoise.png');
