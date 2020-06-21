function pick = non_maximum_suppression(best_pos, w_size, th)
%
% best_pos: the top-left coordinates of bounding boxes
% w_size:   the window size of bounding box
% th:       ratio threshold for overlapping area
%

% the highest overlap ratio
th_high = th;

% compute all coordinates
topY = best_pos(:,1);
bottomY = topY + w_size-1;
topX = best_pos(:,2);
bottomX = topX + w_size-1;

% construct all bounding boxes
boxes =[topX topY bottomX bottomY];

if isempty(boxes)
  pick = [];
else
  x1 = boxes(:,1);
  y1 = boxes(:,2);
  x2 = boxes(:,3);
  y2 = boxes(:,4);
  s = boxes(:,end);
  area = (x2-x1+1) .* (y2-y1+1);

  I = 1:length(best_pos); % original indices
  I = sort(I,'descend');  % reverse: condience from low to high
  pick = [];
  while ~isempty(I)
    last = length(I);
    i = I(last);
    pick = [pick; i];
    suppress = [last];
    for pos = 1:last-1
      j = I(pos);
      xx1 = max(x1(i), x1(j));
      yy1 = max(y1(i), y1(j));
      xx2 = min(x2(i), x2(j));
      yy2 = min(y2(i), y2(j));
      w = xx2-xx1+1;
      h = yy2-yy1+1;
      if w > 0 && h > 0
        % compute overlap 
        o = w * h / area(j);
        if o > th_high
          suppress = [suppress; pos];
        end
      end
    end
    I(suppress) = [];
  end  
end