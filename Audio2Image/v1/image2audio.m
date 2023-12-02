% 将TIFF图像储存的音频数据还原为音频

imageFile = 'image.tiff';
audioFile = 'restored_audio.wav';

% 读取图像
image = int16(imread(imageFile));  % 要还原成16bit的音频数据
imgSize = size(image, 1);  % 图像大小

% 图像解码
sampleRate = uint32(image(imgSize, imgSize, 4));  % 读取右下角像素储存的源采样率0~7位
for i = 1 : 3
    % 移位读取8~31位
    sampleRate = bitor(bitshift(uint32(image(imgSize, imgSize, i)), (4 - i) * 8), sampleRate);
end
shiftBit = 8 * ones([imgSize, imgSize]);  % 8bit组合16bit移位矩阵
audioL = bitor(bitshift(image(:, :, 1), shiftBit), image(:, :, 2));  % 还原左声道
audioR = bitor(bitshift(image(:, :, 3), shiftBit), image(:, :, 4));  % 还原右声道
audioL = reshape(audioL, [], 1);  % 转为列向量
audioR = reshape(audioR, [], 1);  % 转为列向量
audio(:, 1) = audioL;  % 双声道组合
audio(:, 2) = audioR;
audio = audio(1 : end - 1, :);  % 去除最后一个用于储存源采样率产生的数据

% 保存音频
audiowrite(audioFile, audio, sampleRate);
