OD = imread('OD.png');
grayOD = rgb2gray(OD);  % 转灰度图

img1 = medfilt2(grayOD, [7, 7]);  % 中值滤波去椒盐噪声，噪声较严重须使用较大窗口
imwrite(img1, 'ImageEnhance_img1.png');

L = [1, -2, 1; -2, 4, -2; 1, -2, 1];  % 拉普拉斯算子
img1_L = imfilter(img1, L);
img2 = img1 + img1_L;
imwrite(img2, 'ImageEnhance_img2.png');
