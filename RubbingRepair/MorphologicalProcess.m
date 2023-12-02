OD = imread('OD.png');
grayOD = rgb2gray(OD);  % 转灰度图
binOD = imbinarize(grayOD);  % 二值化

se = strel('diamond', 1);  % 结构元素
img1 = imopen(binOD, se);  % 开运算
img1 = imclose(img1, se);  % 闭运算

se = strel('square', 3);  % 结构元素
img1 = imopen(img1, se);  % 开运算
img1 = imclose(img1, se);  % 闭运算

imwrite(img1, 'MorphologicalProcess_img1.png');
