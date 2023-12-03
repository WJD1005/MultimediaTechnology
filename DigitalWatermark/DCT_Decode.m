function watermark = DCT_Decode(inputImg, originImg, watermarkWidth, watermarkHeight, dctCoef, key)
%DCT_DECODE DCT水印提取。
% 输入：
% inputImg：待提取图像，需要为灰度图（长宽均为8的倍数）。
% originImg：原图，需要为灰度图（长款均为8的倍数）。
% watermarkWidth：水印宽度。
% watermarkHeight：水印高度。
% dctCoef：DCT系数选择矩阵（8*8）。
% key：密钥。
% 输出：
% watermark：提取的水印，为灰度图。

blockSize = 8;  % 分块大小

% 根据密钥设置随机数生成器用于校验
rand('state', key); 
pnSequence = round(rand(1, sum(sum(dctCoef))));  % 生成伪随机序列

% 原始图像预处理
originImg = double(originImg);

% 待检测图像预处理和分块
inputImg = double(inputImg);
c = size(inputImg, 1) / blockSize;  % 待检测图片高分块数
d = size(inputImg, 2) / blockSize;  % 待检测图片宽分块数
m = c * d;  % 待检测图片分块数

% 提取水印
correlation = zeros(1, m);
sequence = pnSequence;  % 集成大小
for block = 1 : m
    x = (mod(block - 1, d)) * blockSize + 1;  % 计算分块左上角坐标
    y = floor((block - 1) / d) * blockSize + 1;
    dctBlock1 = dct2(inputImg(y : y + blockSize - 1, x : x + blockSize - 1));
    dctBlock2 = dct2(originImg(y : y + blockSize - 1, x : x + blockSize - 1));
    k = 1;
    for i = 1 : blockSize
        for j = 1 : blockSize
            if dctCoef(i, j) == 1
                sequence(k) = dctBlock1(i, j) - dctBlock2(i, j);
                k = k + 1;
            end
        end
    end

    % 计算序列相关性
    if sequence == 0
        correlation(block) = 0;
    else
        correlation(block) = corr2(pnSequence, sequence);
    end
end

% 相关性大于0.5嵌入0，不大于0.5表明曾经被嵌入
watermarkVector = zeros(1, m);
for block = 1 : m
    if correlation(block) > 0.5
        watermarkVector(block) = 0;
    else
        watermarkVector(block) = 1;
    end
end

% 计算原始图像方差
variance = zeros(1, m);
for i = 1 : c
    for j = 1 : d
        variance((i - 1) * d + j) = std2(originImg(1 + (i - 1) * blockSize : i * blockSize, 1 + (j - 1) * blockSize : j * blockSize)) ^ 2;
    end
end

% 选择方差最大的n块提取水印数据
n = watermarkWidth * watermarkHeight;
[~, blockIndex] = sort(variance, 'descend');  % 方差降序排序
blockIndex = blockIndex(1 : n);  % 取方差最大的n块
watermark = watermarkVector(blockIndex);

% 重组水印
watermark = uint8(reshape(watermark, watermarkWidth, watermarkHeight));

end

