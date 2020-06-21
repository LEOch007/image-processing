function gray_table = compute_histogram(im)
%
% Input:  an image 
% Output: the histogram of the input image
%

% intensity range
maxima = max(max(im));
r = ceil(log2(double(maxima)+1)); % int16: avoid overflow
Pr = zeros(1,2^r);

% compute histogram
for i = 1:size(im,1)
	for j = 1:size(im,2)
		Pr(int16(im(i,j))+1) = Pr(int16(im(i,j))+1)+1; % count
	end
end
gray_table = Pr';