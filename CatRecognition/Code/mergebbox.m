function bbox = mergebbox(im, best_pos, w_size)

% compute all coordinates
topY = best_pos(:,1);
bottomY = topY + w_size-1;
topX = best_pos(:,2);
bottomX = topX + w_size-1;

% merge all bounding boxes into one
minX = min(topX);
minY = min(topY);
maxX = max(bottomX);
maxY = max(bottomY);

bbox = [minX minY maxX maxY];

% plot the bounding box on the original image
figure, imshow(im);
hold on;
plot(bbox([1 3 3 1 1]),bbox([2 2 4 4 2]),'y','linewidth',2);
hold off;

end