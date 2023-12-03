function outputImg = LSB_Encode(inputImg, watermark, watermarkDepth)
%LSB_ENCODE LSB水印嵌入。
% 输入：
% inputImg：原图，需要为灰度图。
% watermark：水印图，需要为灰度图。
% watermarkDepth：水印深度。
% 输出：
% outputImg：嵌入水印后的灰度图。

if watermarkDepth == 1
    watermark = uint8(imbinarize(watermark));  % 二值化
else
    % 重新量化为对应深度的数值（非0~255划分量化级而是0~2^watermarkDepth-1的数值，需要还原至8位深才能得到正常显示效果）
    watermark = double(watermark);
    watermark = uint8(round(watermark / 255 * (2 ^ watermarkDepth - 1)));
end

% 生成平铺水印图
watermark = repmat(watermark, ceil(size(inputImg, 1) / size(watermark, 1)), ceil(size(inputImg, 2) / size(watermark, 2)), 1);
watermark = imresize(watermark, size(inputImg));

% 嵌入水印
outputImg = inputImg;
for i = 1 : size(inputImg, 1)
    for j = 1 : size(inputImg, 2)
        for bit = 1 : watermarkDepth
            outputImg(i, j) = bitset(outputImg(i, j), bit, bitget(watermark(i, j), bit));
        end
    end
end

end

