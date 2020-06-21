% MYHISTOGRAM_EQ performs histogram equalization on a gray level image
%
%     out_img = myhistogram_eq(input_img, gray_table) performs histogram 
%     equalization on the gray level image (input_img) given its histogram 
%     (gray_table)
%
% Input parameters:
%     input_img = an input gray level image
%     gray_table = the histogram of the input image
% Output parameters:
%     out_img = the result image after histogram equalization
function out_img = myhistogram_eq(input_img, gray_table)

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
