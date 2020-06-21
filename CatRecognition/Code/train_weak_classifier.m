function model = train_weak_classifier(type, win_size)

% obtain features and labels
[fea_list,fea_list2,label_list] = obtain_fea_label("cat_train",1, win_size);

% train the model
if strcmp(type,'RF')
	model = TreeBagger(100,fea_list,label_list);
	model2 = TreeBagger(100,fea_list2,label_list);
elseif strcmp(type, 'SVM')
	model = fitcsvm(fea_list,label_list);
	model2 = fitcsvm(fea_list2,label_list);
elseif strcmp(type, 'KNN')
	model = ClassificationKNN.fit(fea_list,label_list,'NumNeighbors',10);
	model2 = ClassificationKNN.fit(fea_list2,label_list,'NumNeighbors',10);
end

% Save the trained model
filename = [type,'_',win_size,'.mat'];
save(filename, 'model');

win_size2 = num2str(str2num(win_size)/2);
filename2 = [type,'_',win_size2,'.mat'];
save(filename2, 'model2');

end
