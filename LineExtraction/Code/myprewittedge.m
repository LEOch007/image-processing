% myprewittedge computes a binary edge image from the given image.
%
%   g = myprewittedge(Im,T,direction) computes the binary edge image from the
%   input image Im.
%   
% The function myprewittedge, with the format g=myprewittedge(Im,T,direction), 
% computes the binary edge image from the input image Im. This function takes 
% an intensity image Im as its input, and returns a binary image g of the 
% same size as Im (mxn), with 1's where the function finds edges in Im and 0's 
% elsewhere. This function finds edges using the Prewitt approximation to the 
% derivatives with the assumption that input image values outside the bounds 
% are zero and all calculations are done using double-precision floating 
% point. The function returns g with size mxn. The image g contains edges at 
% those points where the absolute filter response is above or equal to the 
% threshold T.
%   
%       Input parameters:
%       Im = An intensity gray scale image.
%       T = Threshold for generating the binary output image. If you do not
%       specify T, or if T is empty ([ ]), myprewittedge(Im,[],direction) 
%       chooses the value automatically according to the Algorithm 1 (refer
%       to the assignment descripton).
%       direction = A string for specifying whether to look for
%       'horizontal' edges, 'vertical' edges, positive 45 degree 'pos45'
%       edges, negative 45 degree 'neg45' edges or 'all' edges.
%
%   For ALL submitted files in this assignment, 
%   you CANNOT use the following MATLAB functions:
%   edge, fspecial, imfilter, conv, conv2.
%
function g = myprewittedge(Im,T,direction)

% initialization
grad = zeros(size(Im));
gh = grad; gv = grad; gp = grad; gn = grad; % store gradients of all directions

% % zero padding
% Img = padarray(Im,[1,1]);

% prewitt mask 3x3
wh = [-1,-1,-1; 0,0,0; 1,1,1];
wv = [-1,0,1; -1,0,1; -1,0,1];
wp = [0,1,1; -1,0,1; -1,-1,0];
wn = [-1,-1,0; -1,0,1; 0,1,1];

% computing gradients, aka first derivatives
for i = 2:size(Im,1)-1
	for j = 2:size(Im,2)-1
		gh(i,j) = sum(sum(wh .* Im(i-1:i+1, j-1:j+1)));
		gv(i,j) = sum(sum(wv .* Im(i-1:i+1, j-1:j+1)));
		gp(i,j) = sum(sum(wp .* Im(i-1:i+1, j-1:j+1)));
		gn(i,j) = sum(sum(wn .* Im(i-1:i+1, j-1:j+1)));
	end
end

% determined by required direction
if strcmp(direction,'horizontal')
	grad = abs(gh);
elseif strcmp(direction,'vertical')
	grad = abs(gv);
elseif strcmp(direction,'pos45')
	grad = abs(gp);
elseif strcmp(direction,'neg45')
	grad = abs(gn);
elseif strcmp(direction,'all')
	grad = max( max( max(abs(gh),abs(gv)),abs(gp)), abs(gn)); % maximum of all responces
else 
	grad = ones(size(Im));
end

% threshold 
if isempty(T)
	% automatically define threshold
	T = 0.5* (max(max(grad))+min(min(grad)));
	for i = 1:20
		G1 = grad(grad>=T); % 1-dimension
		G2 = grad(grad<T);
		T = 0.5* (mean(G1)+mean(G2));
	end
end

% output result
g = (grad >= T);