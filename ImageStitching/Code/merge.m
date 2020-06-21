function result = merge(imgA,imgB,H)

[hA,wA,~] = size(imgA); % based on Img A
[hB,wB,~] = size(imgB); % warped Img B 

% get size and coordinates of merged result image
[newH,newW,y1,x1,y2,x2] = getMerge(hB,wB,hA,wA,H);

% merge image A and image B to get new image result
result = uint8(zeros(newH,newW,3));
interpolation_method = 'nearest';

% merge image B into result image
for i = 1:newH
	for j = 1:newW
		if i>=y1 && j>=x1
			% get coordinates of projection
			pos = H*([j,i,1]');
			x=pos(1)./pos(3); y=pos(2)./pos(3);
			if y>=1 && y<=hB && x>=1 && x<=wB
				result(i,j,:) = imgB(round(y),round(x),:);
			end
		end

	end
end

% merge image A into result image and do image blending
result = mergeA_blend(result, imgA, 1,1);

end

% get size and coordinates of merged result image
function [newH,newW,y1,x1,y2,x2] = getMerge(hB,wB,hA,wA,H)

% mesh-grid for the warped image B
[X,Y] = meshgrid(1:wB,1:hB);
posB = ones(3,hB*wB);
posB(1,:) = reshape(X,1,hB*wB);
posB(2,:) = reshape(Y,1,hB*wB);

% determine the four corner 
new_pos = H\posB;
Bleft = min(new_pos(1,:));
Bright = max(new_pos(1,:));
Btop = min(new_pos(2,:));
Bbottom = max(new_pos(2,:));

% round to integer
left = fix(min([1,Bleft]));
right = fix(max([wA,Bright]));
top = fix(min([1,Btop]));
bottom = fix(max([hA,Bbottom]));

newH = bottom - top + 1;
newW = right - left + 1;
x1 = left;
y1 = top;
x2 = 2 - left;
y2 = 2 - top;

end

% merge image A into result image and do image blending
function [newImg] = mergeA_blend(result, unwarped_image, x, y)

% avoid calculation problem
result = double(result);
unwarped_image = double(unwarped_image);

% make masks for both images
result(isnan(result))=0;
mask1 = (result(:,:,1)>0 |result(:,:,2)>0 | result(:,:,3)>0);

newImg = zeros(size(result));
newImg(y:y+size(unwarped_image,1)-1, x: x+size(unwarped_image,2)-1,:) = unwarped_image;
mask2 = (newImg(:,:,1)>0 | newImg(:,:,2)>0 | newImg(:,:,3)>0);

mask = and(mask1, mask2);

% get overlapping region
[~,col] = find(mask);
left = min(col);
right = max(col);
mask = ones(size(mask));

% blend image B part
if(x<2)
	mask(:,left:right) = repmat(linspace(0,1,right-left+1),size(mask,1),1);
else
	mask(:,left:right) = repmat(linspace(1,0,right-left+1),size(mask,1),1);
end
result(:,:,1) = result(:,:,1).*mask;
result(:,:,2) = result(:,:,2).*mask;
result(:,:,3) = result(:,:,3).*mask;

% blend image A part
% reverse the alpha value
if(x<2)
	mask(:,left:right) = repmat(linspace(1,0,right-left+1),size(mask,1),1);
else
	mask(:,left:right) = repmat(linspace(0,1,right-left+1),size(mask,1),1);
end

newImg(:,:,1) = newImg(:,:,1).*mask + result(:,:,1);
newImg(:,:,2) = newImg(:,:,2).*mask + result(:,:,2);
newImg(:,:,3) = newImg(:,:,3).*mask + result(:,:,3);

end