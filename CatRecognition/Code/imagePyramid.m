function [im,im2] = imagePyramid(im)

% change color images to gray-scale
if size(im,3) > 1
    im = rgb2gray(im);
end

% Obtain layer 2
% gaussian kernel to filter
ker = fspecial('gaussian', 3, 0.5);
im = imfilter(im, ker, 'conv', 'symmetric', 'same');
[im_h, im_w] = size(im);

% image down sampling
im2 = im(1:2:im_h, 1:2:im_w);

end