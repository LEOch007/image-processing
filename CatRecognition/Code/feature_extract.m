function fea = feature_extract(I)

% multi-resolution
fea = [region_lbp(I,2,2), region_lbp(I,3,3), region_lbp(I,5,5), region_lbp(I,7,7)];

end


% divide regions
function r_vec = region_lbp(I,M,N)

r_vec = [];

% make it diviable
[w,h]=size(I);
xb = round(w/M)*M;
yb = round(h/N)*N;
im = imresize(I,[xb,yb]);

[w,h]=size(im);
for i=1:M
    for j=1:N
    	block = im((i-1)*w/M+1:w/M*i,(j-1)*h/N+1:j*h/N,:); 
    	vec = extract_LBP(block);
    	r_vec = [r_vec vec];
    end
end

end

