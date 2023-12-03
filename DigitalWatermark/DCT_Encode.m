function outputImg = DCT_Encode(inputImg, watermark, watermarkStrength, dctCoef, key)
%DCT_ENCODE DCT水印嵌入。
% 输入：
% inputImg：原图，需要为灰度图（长宽均为8的倍数）。
% watermark：水印图，需要为二值图。
% watermarkStrength：水印强度。
% dctCoef：DCT系数选择矩阵（8*8）。
% key：密钥。
% 输出：
% outputImg：嵌入水印后的灰度图。

blockSize = 8;           % 分块大小

% 根据密钥设置随机数生成器用于校验
rand('state', key); 
pnSequence = round(rand(1, sum(sum(dctCoef))));  % 生成伪随机序列

% 水印预处理
watermark = double(reshape(watermark, 1, []));  % 水印转换为行向量
n = length(watermark);  % 水印点数

% 载体图像预处理和分块
inputImg = double(inputImg);
c = size(inputImg, 1) / blockSize;  % 载体高分块数
d = size(inputImg, 2) / blockSize;  % 载体宽分块数
m = c * d;  % 载体分块数

% 计算分块方差
variance = zeros(1, m);
for i = 1 : c
    for j = 1 : d
        variance((i - 1) * d + j) = std2(inputImg(1 + (i - 1) * blockSize : i * blockSize, 1 + (j - 1) * blockSize : j * blockSize)) ^ 2;
    end
end

% 选择方差最大的n块写入水印数据
[~, blockIndex] = sort(variance, 'descend');  % 方差降序排序
blockIndex = blockIndex(1 : n);  % 取方差最大的n块
watermarkVector = ones(1, m);
watermarkVector(blockIndex) = watermark;

% 嵌入水印
outputImg = inputImg;
for block = 1 : n
    x = (mod(blockIndex(block) - 1, d)) * blockSize + 1;  % 计算分块左上角坐标
    y = floor((blockIndex(block) - 1) / d) * blockSize + 1;
    dctBlock = dct2(inputImg(y : y + blockSize - 1, x : x + blockSize - 1));  % DCT
    if watermarkVector(blockIndex(block)) == 0
        k = 1;
        for i = 1 : blockSize
            for j = 1 : blockSize
                if dctCoef(i, j) == 1
                    dctBlock(i, j) = dctBlock(i, j) + watermarkStrength * pnSequence(k);
                    k = k + 1;
                end
            end
        end
    end
    outputImg(y : y + blockSize - 1, x : x + blockSize - 1) = idct2(dctBlock);
end

outputImg = uint8(outputImg);

end

