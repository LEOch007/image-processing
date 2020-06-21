close all;
clear;
clc;

tic; % counting time span

% load model
load 'RF_128.mat';  m1 = model;
load 'RF_64.mat';   m2 = model2;
load 'SVM_128.mat'; m3 = model;
load 'SVM_64.mat';  m4 = model2;
load 'KNN_128.mat'; m5 = model;
load 'KNN_64.mat';  m6 = model2;

% obtain test features and labels
fprintf('Loading models and Extracting features ...\n');
[test_fea_128, test_fea_64, test_label] = obtain_fea_label("csit5410_test",0,'128');
fprintf('Loading Done Successfully. \n\n');

% 
% evaluate the weak classifiers
%
fprintf('evaluate the weak classifiers:\n');
predict_label = str2num(char(predict(m1,test_fea_128)));
accuracy = length(find(predict_label == test_label))/length(test_label);
fprintf('accuracy of the weak classifiers #1:   %.5f \n', accuracy);

predict_label = str2num(char(predict(m2,test_fea_64)));
accuracy = length(find(predict_label == test_label))/length(test_label);
fprintf('accuracy of the weak classifiers #2:   %.5f \n', accuracy);

predict_label = predict(m3,test_fea_128);
accuracy = length(find(predict_label == test_label))/length(test_label);
fprintf('accuracy of the weak classifiers #3:   %.5f \n', accuracy);

predict_label = predict(m4,test_fea_64);
accuracy = length(find(predict_label == test_label))/length(test_label);
fprintf('accuracy of the weak classifiers #4:   %.5f \n', accuracy);

predict_label = predict(m5,test_fea_128);
accuracy = length(find(predict_label == test_label))/length(test_label);
fprintf('accuracy of the weak classifiers #5:   %.5f \n', accuracy);

predict_label = predict(m6,test_fea_64);
accuracy = length(find(predict_label == test_label))/length(test_label);
fprintf('accuracy of the weak classifiers #6:   %.5f \n', accuracy);
% obtain validation features and labels
load 'pretrained.mat';

%
% Adaboost to obtain a strong classifer
%
fprintf('\nBoosting ...\n');
w = ones(length(val_label),1)/length(val_label); 
max_iter = 5;
model_list = [];
alpha_list = [];
for i = 1:max_iter
	[model_id, w, e, alp] = Adaboost_training(m1,m2,m3,m4,m5,m6, w,val_fea_128,val_fea_64, val_label);
	model_list = [model_list model_id];
	alpha_list = [alpha_list alp];
end

fprintf('Selected weak classifiers: (in order)\n');
model_list
fprintf('Alpha value for each selected weak classifier: \n');
alpha_list

% strong classifier prediction
boost_predict = Adaboost_predicting(model_list, alpha_list, val_fea_128, val_fea_64, m1,m2,m3,m4,m5,m6);
accuracy = length(find(boost_predict == val_label))/length(val_label);
fprintf('Accuracy of the Strong Classifier:   %.5f \n', accuracy);

predict_label = str2num(char(predict(m1,val_fea_128)));
accuracy = length(find(predict_label == val_label))/length(val_label);
fprintf('Accuracy of the Weak Classifier 1:   %.5f \n', accuracy);

predict_label = str2num(char(predict(m2,val_fea_64)));
accuracy = length(find(predict_label == val_label))/length(val_label);
fprintf('Accuracy of the Weak Classifier 2:   %.5f \n', accuracy);

predict_label = predict(m3,val_fea_128);
accuracy = length(find(predict_label == val_label))/length(val_label);
fprintf('Accuracy of the Weak Classifier 3:   %.5f \n', accuracy);

predict_label = predict(m4,val_fea_64);
accuracy = length(find(predict_label == val_label))/length(val_label);
fprintf('Accuracy of the Weak Classifier 4:   %.5f \n', accuracy);

predict_label = predict(m5,val_fea_128);
accuracy = length(find(predict_label == val_label))/length(val_label);
fprintf('Accuracy of the Weak Classifier 5:   %.5f \n', accuracy);

predict_label = predict(m6,val_fea_64);
accuracy = length(find(predict_label == val_label))/length(val_label);
fprintf('Accuracy of the Weak Classifier 6:   %.5f \n', accuracy);

%
% Do detection based on the strong classifier
%
fprintf('\nStart Detection ...\n');
test_img = ['1','2','3','4','5'];
file_path = './test_images/';
for i = 1:length(test_img)
	% read the test image
	im = imread([file_path, test_img(i), '.jpg']);

	% construct 2-layer image pyramid
	[im, im2] = imagePyramid(im);

	% 
	% Handle im
	%
	% sliding window to get 128*128 image pathes
	w_size = 128;
	step_size = 10;
	[f_list, p_list] = slidingWindow(im,w_size,step_size);

	% make predictions
	[predict_label, scores] = predict(m1, f_list);
	predict_label = str2num(char(predict_label));

	% highest probability
	top_k = 3;
	[s, sid] = sort(scores(:,2), 'descend');
	best_pos = p_list(sid(1:top_k),:);

	% draw the bounding box
	drawBox(im, best_pos, w_size);

	% 
	% Handle im2
	%
	% sliding window to get 128*128 image pathes
	[f_list, p_list] = slidingWindow(im2,w_size,step_size);

	% make predictions
	[predict_label, scores] = predict(m1, f_list);

	% highest probability
	[s, sid] = sort(scores(:,2), 'descend');
	best_pos = p_list(sid(1:top_k),:);

	% draw the bounding box
	drawBox(im2, best_pos, w_size);
end

fprintf('\nTotal Running Time: %.1f minute\n',(toc/60));


%%
% Additional work: 
% utilize nms and merge all bounding boxes into single one
%
% fprintf('\n\nThis is the additional task:\n');
% fprintf('utilize nms and merge all bounding boxes into single one:\n');
% fprintf('\nStart Detection ...\n');
% for i = 1:length(test_img)
% 	% read the test image
% 	im = imread([file_path, test_img(i), '.jpg']);
% 	[im, im2] = imagePyramid(im);
% 
% 	% sliding window to get 128*128 image pathes
% 	[f_list, p_list] = slidingWindow(im,w_size,step_size);
% 
% 	% make predictions
% 	[predict_label, scores] = predict(m1, f_list);
% 	predict_label = str2num(char(predict_label));
% 
% 	% highest probability
% 	top_k = 10;
% 	[s, sid] = sort(scores(:,2), 'descend');
% 	best_pos = p_list(sid(1:top_k),:);
% 
% 	% utilize nms to pick the coordinates from best_pos
% 	th = 7/8; % the ratio range of overlap
% 	pick = non_maximum_suppression(best_pos, w_size, th);
% 	pick_pos = best_pos(pick,:);
% 
% 	% merge all bounding boxes into one
% 	bbox = mergebbox(im, pick_pos, w_size);
% end
% fprintf('\nDetection Done.\n');
% fprintf('Thanks for your interests in my additional work.\n');