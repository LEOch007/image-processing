function drawBox(im, best_pos, w_size)

figure, imshow(im);
hold on;

% bounding image
for i = 1:size(best_pos,1)
	% compute coordinates
	topY = best_pos(i,1);
	bottomY = topY + w_size-1;
	topX = best_pos(i,2);
	bottomX = topX + w_size-1;

	% construct bounding box
	bbox =[topX topY bottomX bottomY];

	% plot the bounding box
	plot(bbox([1 3 3 1 1]),bbox([2 2 4 4 2]),'y','linewidth',2);
end

hold off;

end
