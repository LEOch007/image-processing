function vec = extract_LBP (im)

% make color image into gray image
if size(im, 3) > 1
    im = rgb2gray(im);
end
[w, h] = size(im);

% local binary pattern in a neighborhood with 1-radius
I = im;
LBP = uint8(zeros(w-2, h-2));
for i = 2:w-1
    for j = 2:h-1
        % instance by one radius and eight points 
        neighbor = [I(i-1,j-1) I(i-1,j) I(i-1,j+1);  I(i,j-1) I(i,j) I(i,j+1);  I(i+1,j-1) I(i+1,j) I(i+1,j+1)];
        neighbor = uint8(neighbor>=neighbor(2,2));

        % LBP version 3
        % check lbp value
        sum_value = abs(neighbor(1,1)-neighbor(1,2)) + abs(neighbor(1,2)-neighbor(1,3)) ...
                    +abs(neighbor(1,3)-neighbor(2,3)) + abs(neighbor(2,3)-neighbor(3,3)) ...
                    +abs(neighbor(3,3)-neighbor(3,2)) + abs(neighbor(3,2)-neighbor(3,1)) ...
                    +abs(neighbor(3,1)-neighbor(2,1)) + abs(neighbor(2,1)-neighbor(1,1)) ;
        if sum_value <=2
            lbp_value = sum(neighbor(:));
        else
            lbp_value = 10;
        end
        LBP(i-1,j-1) = lbp_value; 
    end
end

% get histogram of LBP values
vec = get_hist(LBP);

end

% get histogram
function vec = get_hist(Im)

vec = zeros(1,10);
for i = 1:size(Im,1)
    for j = 1:size(Im,2)
        vec(Im(i,j)) = vec(Im(i,j))+1;
    end
end

end