% 生成色环图像，图像水平分成上下两部分，上半部分储存左声道数据，下半部分储存右声道数据。
% 采用更常用的RGB色彩方案，兼容更多图像格式和压缩算法，使图片被处理后依然可以被还原成音频。
% 将人耳可听见的声音频率（20~20000Hz）与6位十六进制（0~16777215）直接建立线性映射关系，
% 然后将6位十六进制转为RGB色彩，这样就建立了所有可听见频率与RGB可混合出的所有颜色映射。

audioFile = 'audio.mp3';
imageFile = 'image.png';

% 参数
fps = 10;  % 切分帧率

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

% 音频预处理
if mod(size(audio, 1), sampleRate) ~= 0
    audio = [audio; zeros(sampleRate - mod(size(audio, 1), sampleRate), 2)];  % 长度补到采样率整数倍
end

% 帧切分和主要频率、幅度提取
frameLen = sampleRate / fps;  % 帧长（采样数/帧）
fftNum = 2 ^ nextpow2(frameLen);  % FFT数据点数量
f = sampleRate * (0 : (fftNum / 2)) / fftNum;  % 频率点
mainFreq = zeros(size(audio, 1) / frameLen, 2);  % 主要频率
for i = 1 : size(audio, 1) / frameLen
    frame = audio((i - 1) * frameLen + 1 : i * frameLen, :);  % 取一帧
    Y = fft(frame, fftNum, 1);  % FFT
    P2 = abs(Y / fftNum);  % 双侧频谱
    P1 = P2(1 : fftNum / 2 + 1, :);
    P1(2 : end - 1, :) = 2 * P1(2 : end - 1, :);  % 单侧频谱
    [~, maxPIndex] = max(P1);  % 左声道最大幅度索引
    mainFreq(i, :) = f(maxPIndex);  % 主要频率，由于信息密度所限只提取单一频率了
end

% 数据处理
mainFreq = min(mainFreq, 20000);  % 不大于20000
mainFreq = max(mainFreq, 20);  % 不小于20
mainFreq = uint32(round((mainFreq - 20) / 19980 * double(0xFFFFFF)));  % 20~20000Hz的频率映射到6位十六进制的范围

% 图像编码
imgSize = size(mainFreq, 1) * 2;
image = uint8(zeros(imgSize, imgSize, 3));  % 图片矩阵
LRGB = [bitand(bitshift(mainFreq(:, 1), ones(size(mainFreq, 1), 1) * -16), uint32(0xFF)), bitand(bitshift(mainFreq(:, 1), ones(size(mainFreq, 1), 1) * -8), uint32(0xFF)), bitand(mainFreq(:, 1), uint32(0xFF))];  % 左声道转RGB
RRGB = [bitand(bitshift(mainFreq(:, 2), ones(size(mainFreq, 1), 1) * -16), uint32(0xFF)), bitand(bitshift(mainFreq(:, 2), ones(size(mainFreq, 1), 1) * -8), uint32(0xFF)), bitand(mainFreq(:, 2), uint32(0xFF))];  % 右声道转RGB
% 环形写入图像
for i = 1 : size(mainFreq, 1)
    for j = 1 : 3
        image(i, i : imgSize - i + 1, j) = LRGB(i, j);
        image(i + 1 : imgSize / 2, i, j) = LRGB(i, j);
        image(i + 1 : imgSize / 2, imgSize - i + 1, j) = LRGB(i, j);
        image(imgSize - i + 1, i : imgSize - i + 1, j) = RRGB(i, j);
        image(imgSize / 2 + 1 : imgSize - i + 1, i, j) = RRGB(i, j);
        image(imgSize / 2 + 1 : imgSize - i + 1, imgSize - i + 1, j) = RRGB(i, j);
    end
end

% 保存图像
imwrite(image, imageFile);
