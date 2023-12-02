imageFile = 'image.png';
audioFile = 'restored_audio.wav';

% 参数
fps = 10;  % 切分帧率
sampleRate = 44100;  % 采样率


% 读取图像
image = uint16(imread(imageFile));
imgSize = size(image, 1);  % 图像大小

% 提取数据
mainFreqTemp = bitor(bitshift(image(:, imgSize / 2, 1), 8), image(:, imgSize / 2, 2));  % 提取主要频率
amplitudeTemp = image(:, imgSize / 2, 3);  % 提取幅度
mainFreq(:, 1) = mainFreqTemp(1 : imgSize / 2);  % 左右声道数据分离
mainFreq(:, 2) = mainFreqTemp(imgSize : -1 : imgSize / 2 + 1);
amplitude(:, 1) = amplitudeTemp(1 : imgSize / 2);
amplitude(:, 2) = amplitudeTemp(imgSize : -1 : imgSize / 2 + 1);

% 数据处理
mainFreq = double(mainFreq);
amplitude = double(amplitude) / 8;  % 柔和处理
mainFreq = smoothdata(mainFreq, 'sgolay');  % 滤波
amplitude = smoothdata(amplitude, 'sgolay');

% 合成音频
frameLen = sampleRate / fps;  % 帧长（采样数/帧）
sampleSeq = linspace(0, 1 / fps, frameLen);  % 采样序列
audio = zeros(size(mainFreq, 1), 2);
phi = [0, 0];  % 初相
for i = 1 : size(mainFreq, 1)
    audio((i - 1) * frameLen + 1 : i * frameLen, 1) = amplitude(i, 1) * sin(2 * pi * mainFreq(i, 1) * sampleSeq + phi(1));  % 正弦波模拟重采样
    audio((i - 1) * frameLen + 1 : i * frameLen, 2) = amplitude(i, 2) * sin(2 * pi * mainFreq(i, 2) * sampleSeq + phi(2));
    phi = [mod(2 * pi * mainFreq(i, 1) / fps + phi(1), 2 * pi), mod(2 * pi * mainFreq(i, 2) / fps + phi(2), 2 * pi)];  % 更新初相，使波形连续（幅度变化会导致少量不连续），避免不连续杂音
end

% 保存音频
audiowrite(audioFile, audio, sampleRate);
