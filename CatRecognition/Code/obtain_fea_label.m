% obtain features and labels
function [fea_list, fea_list2,label_list] = obtain_fea_label(filename, ctl, win_size)
%
% fea_list: win_size
% fea_list2: win_size/2
%

% change this path if you install the VOC code elsewhere
addpath([cd '/VOCcode']);

% initialize VOC options
VOCinit;

% load image set for Adaboost
[ids,gt]=textread(sprintf(VOCopts.imgsetpath,filename),'%s %d');

% ctl is 1: need to balance for training
if ctl==1
	% balance the dataset
	pos = ids(gt==1);
	neg = ids(gt==-1);
	neg = neg(randperm(size(neg,1),size(pos,1)));
	ids = [pos;neg];
	gt = [ones(size(pos,1),1); -1*ones(size(neg,1),1)];

	% random suffle
	suffle_id = randperm(size(ids,1),size(ids,1));
	ids = ids(suffle_id); 
	gt = gt(suffle_id);
end

% obtain the traing features and labels
fea_list = [];
fea_list2 = [];
label_list = [];
win_size = str2num(win_size);
for j=1:length(ids)
    % read annotation
    rec=PASreadrecord(sprintf(VOCopts.annopath,ids{j}));
    % read image
    I=imread(sprintf(VOCopts.imgpath,ids{j}));
    % read groundTruth
    flag = gt(j);
    
    if flag == 1
    	% cat
	    for z=1:length(rec.objects)
	        if strcmp(rec.objects(z).class,'cat')
	        	% get the object image
		        detect_bbox = rec.objects(z).bbox;
		        x1 = detect_bbox(1);
		        y1 = detect_bbox(2);
		        x2 = detect_bbox(3);
		        y2 = detect_bbox(4);
		        crop_I = imcrop(I,[x1 y1 x2-x1 y2-y1]);

		        % preprocess the image
		        input_I = preprocess(crop_I, win_size);
		        small_I = preprocess(crop_I, win_size/2);

		        % get the feature vector
		        fea = feature_extract(input_I);
		        fea_list = [fea_list; fea];
		        fea2 = feature_extract(small_I);
		        fea_list2 = [fea_list2; fea2];

		        % get the label
	        	label_list = [label_list;1];
	        end
	    end
	else
		% non-cat
		% get the object image
		rand_select = randperm(length(rec.objects),1);
        detect_bbox = rec.objects(rand_select).bbox;
        x1 = detect_bbox(1);
        y1 = detect_bbox(2);
        x2 = detect_bbox(3);
        y2 = detect_bbox(4);
        crop_I = imcrop(I,[x1 y1 x2-x1 y2-y1]);	

        % preprocess the image
        input_I = preprocess(crop_I, win_size);
        small_I = preprocess(crop_I, win_size/2);

        % get the feature vector
        fea = feature_extract(input_I);
        fea_list = [fea_list; fea];
        fea2 = feature_extract(small_I);
        fea_list2 = [fea_list2; fea2];

        % get the label
        label_list = [label_list;-1];
	end    
    
end

end