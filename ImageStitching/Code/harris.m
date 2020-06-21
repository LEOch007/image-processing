function [Points,V] = harris(Img, threshold)

% convert to gray scale and avoid overflow
im = double(rgb2gray(Img));

% Sobel detector
gx = [-1 -2 -1; 0 0 0; 1 2 1]; % horizontal
gy = [-1 0 1; -2 0 2; -1 0 1]; % vertical

% compute x and y derivatives
Ix = imfilter(im,gx);
Iy = imfilter(im,gy);

% compute products of derivatives
Ix2 = Ix.*Ix;
Iy2 = Iy.*Iy;
Ixy = Ix.*Iy;

% apply gaussian window filter to compute sum
gau_filter= fspecial('gaussian',[10 10]); 
Ix2 = imfilter(Ix2,gau_filter);
Iy2 = imfilter(Iy2,gau_filter);
Ixy = imfilter(Ixy,gau_filter);

% for each pixel, get the value R and Rmax
R = zeros(size(Img,1),size(Img,2));
Rmax = 0;
for i = 1:size(Img,1)
	for j = 1:size(Img,2)
		det_M = Ix2(i,j)*Iy2(i,j) - Ixy(i,j)*Ixy(i,j) ;
		trace_M = Ix2(i,j)+Iy2(i,j) ;
		R(i,j) = det_M - 0.08* (trace_M*trace_M);
		if Rmax < R(i,j)
			Rmax = R(i,j);
		end
	end
end

% get the corner points coordinates and intesities
Points = [];
V = [];
% ignore the image border
for i = 2:size(Img,1)-1
	for j = 2:size(Img,2)-1
		if R(i,j)>=(Rmax*threshold) && nonmax_suppression(R,i,j)==1
			Points = [Points; [i,j]];
			V = [V; Img(i,j)];
		end
	end
end

end

% non max suppression: to pick the local maxima in 9*9 window
function flag = nonmax_suppression(R,i,j)
	flag=1;
	amin = max(i-4,1); amax = min(i+4,size(R,1));
	bmin = max(j-4,1); bmax = min(j+4,size(R,2));
	for a = amin:amax
		for b = bmin:bmax
			if R(a,b)>R(i,j)
				flag=0;
				break;
			end
		end
	end

end
