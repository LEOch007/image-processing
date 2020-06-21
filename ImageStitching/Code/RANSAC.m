function [H, inliers] = RANSAC(pointsA,pointsB,threshold,iteration)
% Random Sample Consensus
% inhomogeneous version

% initilization
max_cnt = 0;
bestH = zeros(3,3);
bestidx = [false false false false false false false false];
iter = 0;

% get the largest set of inliners
while true
	% select 8 pairs of points from two sets
	idx = randperm(size(pointsA,2),8);

	% caculate the transformation matrix H based on 8 pairs of points
	pA = pointsA(:,idx);
	pB = pointsB(:,idx);
	H = computeH(pA,pB);

	% determine the inliners
	v = H*pointsA - pointsB;
	err = sum(v.*v,1);			% sum of square difference
	cnt = sum(err<threshold); 	% the number of inliers

	% check termination condition 
	if ((cnt/size(pointsA,2)) >0.95) || (iter>=iteration)
		break;
	end

	% update H if perform better
	if cnt > max_cnt
		max_cnt = cnt;
		bestH = H;
		bestidx = (err<threshold);
	end
	iter = iter+1;

end

% use Least square fit to re-compute H 
inliers = bestidx;
pA = pointsA(:,bestidx);
pB = pointsB(:,bestidx);
H = least_square(pA,pB);

end

% compute transformation matrix H (inhomogeneous solution)
function H = computeH(pA, pB)

% construct M
M = [];
for i = 1:size(pA,2)
	xi = pA(1,i); yi = pA(2,i); 
	xxi = pB(1,i); yyi = pB(2,i);
	Mi = [xi yi 1 0 0 0 -1*xxi*xi -1*xxi*yi; ...
		  0 0 0 xi yi 1 -1*yyi*xi -1*yyi*yi];
	M = [M; Mi];
end

% construct T
tmp = pB(1:2,:);
T = tmp(:);

% compute h
% pinv: solve singular matrix
h = pinv(M)*T; 	%inv(M)*T;

% get H
% H = [h(1) h(4) h(7); ...
% 	 h(2) h(5) h(8); ...
% 	 h(3) h(6) 1];
H = [h(1) h(2) h(3); ...
	 h(4) h(5) h(6); ...
	 h(7) h(8) 1];

end

% least squre fit to get matrix H
function H = least_square(pA,pB)
H = pB/pA;
end
