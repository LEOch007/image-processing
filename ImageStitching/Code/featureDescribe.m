function descriptors = featureDescribe(img, Points)

% convert to gray scale and avoid overflow
im = double(rgb2gray(img));

% gaussian smoothing 
gau_filter= fspecial('gaussian',[5 5]); 
im = imfilter(im,gau_filter);
% avoid exceeding array bound
win_len = 20;
im = padarray(im,[win_len win_len]);

% go through each corner points
descriptors = [];
for k = 1:size(Points,1)
	y = Points(k,1)+win_len;
	x = Points(k,2)+win_len;
	% region window is center in (y,x)
	region = im(y-win_len+1 : y+win_len, x-win_len+1 : x+win_len);
	region = imresize(region, 0.2);

	% normalized intensity values
	region_value = zscore(region);
	region_value = region_value(:)'; % row vector

	% combine
	descriptors = [descriptors; region_value];

end