function [f_list, p_list] = slidingWindow(im, w_size, step_size)
%
% f_list: feature lists
% p_list: coordinate lists
%

f_list = [];
p_list = [];
w_size = w_size-1;
% go through entire image 
for i = 1:step_size:(size(im,1)-w_size)
	for j = 1:step_size:(size(im,2)-w_size)

		% obtain sub_image
		sub_img = im(i:i+w_size, j:j+w_size);

		% preprocess the image
		sub_img = preprocess(sub_img, 0); % 0: no need to resize

		% extract the feature vector
		fea = feature_extract(sub_img);
		f_list = [f_list; fea];

		% extract the position vector
		pos = [i j];
		p_list = [p_list; pos];

		% avoid accessing out the image
		if i+w_size >= size(im,1)
			break;
		end
		if j+w_size >= size(im,2)
			break;
		end
	end
end

end