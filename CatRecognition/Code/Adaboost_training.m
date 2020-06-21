function [model_id, w, e, alp] = Adaboost_training(m1,m2,m3,m4,m5,m6, w,fea_list1,fea_list2, label)

% make predictions
pred = [];
pred = [pred str2num(char(predict(m1,fea_list1)))];
pred = [pred str2num(char(predict(m2,fea_list2)))];
pred = [pred predict(m3,fea_list1)];
pred = [pred predict(m4,fea_list2)];
pred = [pred predict(m5,fea_list1)];
pred = [pred predict(m6,fea_list2)];

% compute minima error rate
for j=1:size(pred,2)
	err(j) = sum(w.*((1-pred(:,j).*label)/2));
end
% print errors of six weak classifiers
err
[e,id] = min(err);

% select the weak classifer
model_id = id;

% compute model weight
alp = log((1-e)/e)/2;

% update data record weight
w = w.*exp(-1*alp* (pred(:,id).*label));
w = w/sum(w);

end