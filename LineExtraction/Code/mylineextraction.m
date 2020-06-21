function [bp, ep] = mylineextraction(BW)
%   The function extracts the longest line segment from the given binary image
%       Input parameter:
%       BW = A binary image.
%
%       Output parameters:
%       [bp, ep] = beginning and end points of the longest line found
%       in the image.
%
%   You may need the following predefined MATLAB functions: hough,
%   houghpeaks, houghlines.

% Create Hough Transform
[H,T,R] = hough(BW);

% Find the peaks
P = houghpeaks(H,5);

% Map into lines
lines = houghlines(BW,T,R,P);

% Find the longest line segment
Mlen = 0; 					% max len
for k = 1:length(lines)
	p1 = lines(k).point1;
	p2 = lines(k).point2;
	len = norm(p1-p2);     	% Euclidean norm
	if len>Mlen
		Mlen = len;
		bp = p1;
		ep = p2;
	end
end