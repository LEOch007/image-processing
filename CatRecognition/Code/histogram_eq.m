function out_img = histogram_eq(input_img)
%
% Input: an image
% Output: after histogram equlization
%

gray_table = compute_histogram(input_img);

% compute distribution
Pr = gray_table/ (size(input_img,1)*size(input_img,2));

% compute cumulative distribution
Sk = zeros(size(Pr));
Sk(1) = Pr(1);
for i = 2:size(Sk)
	Sk(i) = Sk(i-1) + Pr(i);
end

% manify to intensity range
maxima = max(max(input_img));
Sk = double(maxima)*Sk;

% map old intensity into new intensity values
out_img = input_img;
for i = 1:size(out_img,1)
	for j = 1:size(out_img,2)
		newI = Sk(int16(out_img(i,j))+1);
		out_img(i,j) = newI;
	end
end

end

function gray_table = compute_histogram(im)
%
% Input:  an image 
% Output: the histogram of the input image
%

% intensity range
maxima = max(max(im));
r = 8;
Pr = zeros(1,2^r);

% compute histogram
for i = 1:size(im,1)
	for j = 1:size(im,2)
		Pr(int16(im(i,j))+1) = Pr(int16(im(i,j))+1)+1; % count
	end
end
gray_table = Pr';
end