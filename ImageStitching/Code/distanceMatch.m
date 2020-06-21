function [matchA, matchB] = distanceMatch(describeA,describeB,pointsA,pointsB, threshold)

matchA = []; matchB = [];
for i = 1:size(describeA,1)
	dis = zeros(1,size(describeB,1));
	for j = 1:size(describeB,1)
		dis(1,j) = L2(describeA(i,:)-describeB(j,:));
	end
	sorted_dis = sort(dis); % increasing order

	% closest neighbor has less than threshold times 2nd one
	if sorted_dis(1) < threshold*sorted_dis(2)
		[~,bestj] = min(dis);
		matchA = [matchA [pointsA(i,2) pointsA(i,1) 1]' ];  		% trap: (x,y,1)
		matchB = [matchB [pointsB(bestj,2) pointsB(bestj,1) 1]' ];
	end
end

end


% L2-norm of the vector
function l2 = L2(vec)
l2 = sqrt(sum(vec.*vec));
end

