clear
clc

% 嵌入设置
watermarkStrength = 20;  % 水印强度
key = 717;               % 密钥

% 嵌入系数选取
% 中频
dctCoefIF = [0, 0, 0, 1, 1, 1, 1, 0;
    0, 0, 1, 1, 1, 1, 0, 0;
    0, 1, 1, 1, 1, 0, 0, 0;
    1, 1, 1, 1, 0, 0, 0, 0;
    1, 1, 1, 0, 0, 0, 0, 0;
    1, 1, 0, 0, 0, 0, 0, 0;
    1, 0, 0, 0, 0, 0, 0, 0;
    0, 0, 0, 0, 0, 0, 0, 0];
% 低频
dctCoefLF = [1, 1, 1, 0, 0, 0, 0, 0;
    1, 1, 1, 0, 0, 0, 0, 0;
    1, 1, 1, 0, 0, 0, 0, 0;
    0, 0, 0, 0, 0, 0, 0, 0;
    0, 0, 0, 0, 0, 0, 0, 0;
    0, 0, 0, 0, 0, 0, 0, 0;
    0, 0, 0, 0, 0, 0, 0, 0;
    0, 0, 0, 0, 0, 0, 0, 0];
% 高频
dctCoefHF = [0, 0, 0, 0, 0, 0, 0, 0;
    0, 0, 0, 0, 0, 0, 0, 0;
    0, 0, 0, 0, 0, 0, 0, 0;
    0, 0, 0, 0, 0, 0, 0, 1;
    0, 0, 0, 0, 0, 0, 1, 1;
    0, 0, 0, 0, 0, 1, 1, 1;
    0, 0, 0, 0, 1, 1, 1, 1;
    0, 0, 0, 1, 1, 1, 1, 1];

% 读取图像
inputImg = rgb2gray(imread('TestImage/Input.jpg'));  % 输入原图
watermark = imbinarize(rgb2gray(imread('TestImage/SmallWatermark.jpg')));  % 水印图

% 载体预处理
inputImg = inputImg(1 : floor(size(inputImg, 1) / 8) * 8, 1 : floor(size(inputImg, 2) / 8) * 8);

% 嵌入水印
outputImgIF = DCT_Encode(inputImg, watermark, watermarkStrength, dctCoefIF, key);
outputImgLF = DCT_Encode(inputImg, watermark, watermarkStrength, dctCoefLF, key);
outputImgHF = DCT_Encode(inputImg, watermark, watermarkStrength, dctCoefHF, key);
imwrite(outputImgIF, 'TestImage/DCT_EncodeImg_IF.png');
imwrite(outputImgLF, 'TestImage/DCT_EncodeImg_LF.png');
imwrite(outputImgHF, 'TestImage/DCT_EncodeImg_HF.png');

% 提取水印
watermarkIF = DCT_Decode(outputImgIF, inputImg, size(watermark, 1), size(watermark, 2), dctCoefIF, key);
watermarkLF = DCT_Decode(outputImgLF, inputImg, size(watermark, 1), size(watermark, 2), dctCoefLF, key);
watermarkHF = DCT_Decode(outputImgHF, inputImg, size(watermark, 1), size(watermark, 2), dctCoefHF, key);

% 变换为8位深度恢复显示效果
watermarkIF = watermarkIF * 255;
watermarkLF = watermarkLF * 255;
watermarkHF = watermarkHF * 255;
imwrite(watermarkIF, 'TestImage/DCT_DecodeImg_IF.png');
imwrite(watermarkLF, 'TestImage/DCT_DecodeImg_LF.png');
imwrite(watermarkHF, 'TestImage/DCT_DecodeImg_HF.png');
