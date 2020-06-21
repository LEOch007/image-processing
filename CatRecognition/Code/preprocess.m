% preprocess image
function img = preprocess(im, win_size)

% make color image into gray image
if size(im, 3) > 1
    im = rgb2gray(im);
end

% histogram equalization
im = histogram_eq(im);

% resize the image
if win_size~=0
	im = imresize(im, [win_size, win_size]);
end

% output
img = im;
end