function imgD = cylinderProjection(img, degree)

H = size(img,1); % height of original image
W = size(img,2); % weight of original image
C = size(img,3); % channel of original image

f = W/(2*tan(degree/2)); % locus
newH = H;
newW = floor(2*f*atan(W/2/f));

% new image
imgD = uint8(zeros(newH,newW,C));
interpolation_method = 'nearest';

% Cylindrical Projection
for i = 1:size(imgD,1)
	for j = 1:size(imgD,2) 
		% get coordinates of projection
		pos = reverse_transform(i,j,f,W,H); 
		x = pos(1);y=pos(2);
		
		% assign intensity values (y,x)
		if y>=1 && y<=H && x>=1 && x<=W
			if strcmp(interpolation_method,'nearest')
				for k = 1:size(imgD,3)
					imgD(i,j,k) = img(round(y),round(x),k); 
				end
			elseif strcmp(interpolation_method,'bilinear')
				for k = 1:size(imgD,3)
					y_0 = floor(y); y_1 = ceil(y);
					x_0 = floor(x); x_1 = ceil(x);
					f_00 = img(y_0,x_0,k); f_10 = img(y_1,x_0,k);
					f_01 = img(y_0,x_1,k); f_11 = img(y_1,x_1,k);

					value = f_00*(x_1-x)*(y_1-y) + f_10*(x-x_0)*(y_1-y) + f_01*(x_1-x)*(y-y_0) + f_11*(x-x_0)*(y-y_0);
					imgD(i,j,k) = round(value);
				end
			end		
		end
	end
end

end

% reverse tranformation function of Cylindrical Projection
function pos = reverse_transform(i,j,f,W,H)
% i,j - coordinates
% f - locus
% W,H - weight and height of original image
x = f* tan(j/f - atan(W/(2*f))) + W/2;
y = (i-H/2)* sqrt((x-W/2)*(x-W/2) + f*f)/f + H/2;
pos = [x,y];

end
