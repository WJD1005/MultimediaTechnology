function watermark = LSB_Decode(inputImg, watermarkDepth)
%LSB_DECODE LSB水印提取。
% 输入：
% inputImg：待提取水印图片，需要为灰度图。
% watermarkDepth：水印深度。
% 输出：
% outputImg：提取的水印，为灰度图。

% 提取水印
watermark = zeros(size(inputImg));
for i = 1 : size(inputImg, 1)
    for j = 1 : size(inputImg, 2)
        for bit = 1 : watermarkDepth
            watermark(i, j) = bitset(watermark(i, j), bit, bitget(inputImg(i, j), bit));
        end
    end
end

% 还原至8位深以恢复显示效果
watermark = uint8(round(watermark / (2 ^ watermarkDepth - 1) * 255));

end

