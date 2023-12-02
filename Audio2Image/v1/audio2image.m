% 编码方式：
% 使用8bitCMYK的TIFF图像以源采样率储存16bit的高保真音频数据
% 每个像素储存一个双声道采样点，其中C通道和M通道分别储存左声道的高8位和低8位，Y通道和K通道分别储存右声道的高8位和低8位
% 遵循从上到下，从左到右的逐列扫描模式（线性索引）
% 在右下角像素储存采样率，逆变换时可以读取源采样率进行还原

audioFile = 'audio.mp3';
imageFile = 'image.tiff';

% 读取音频数据
[audio, sampleRate] = audioread(audioFile, 'double');  % 读取归一化数据，增强对不同格式和深度音频的兼容性
totalSamples = size(audio, 1);  % 总采样数
if size(audio, 2) == 1
    % 如果只有单声道则复制一个声道
    audio = repmat(audio, 1, 2);
elseif size(audio, 2) > 2
    % 如果多于两声道则取前两个声道
    audio = audio(:, 1 : 2);
end

% 初始化图片
imgSize = ceil(sqrt(totalSamples + 1));  % 1:1正方形图片
image = uint8(zeros([imgSize, imgSize, 4]));  % 8bit4通道

% 图像编码
audio = int16(audio * 32767);  % 归一化数据转int16数据
audio = [audio; zeros([imgSize * imgSize - totalSamples, 2])];  % 末尾补0至图片大小
audioL = audio(:, 1);  % 左声道
audioR = audio(:, 2);  % 右声道
audioL = reshape(audioL, [imgSize, imgSize]);  % 调整为和图片对应的矩阵
audioR = reshape(audioR, [imgSize, imgSize]);  % 调整为和图片对应的矩阵
shiftBit = -8 * ones([imgSize, imgSize]);  % 16bit取高8bit移位矩阵
image(:, :, 1) = bitand(bitshift(audioL, shiftBit), int16(0x00FF));  % C通道存左声道高8位
image(:, :, 2) = bitand(audioL, int16(0x00FF));  % M通道存左声道低8位
image(:, :, 3) = bitand(bitshift(audioR, shiftBit), int16(0x00FF));  % Y通道存右声道高8位
image(:, :, 4) = bitand(audioR, int16(0x00FF));  % K通道存右声道低8位
shiftBit = [-24, -16, -8, 0];  % 32bit拆分8bit移位矩阵
image(imgSize, imgSize, :) = bitand(bitshift(uint32(sampleRate), shiftBit), 0x000000FF);  % 储存采样率

% 保存图像
imwrite(image, imageFile);
