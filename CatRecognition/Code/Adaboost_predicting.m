function boost_predict = Adaboost_predicting(model_list, alpha_list, fea_list1, fea_list2, m1,m2,m3,m4,m5,m6)

% each selected weak classifier makes predictions
pred = [];
for i = 1:length(model_list)
	mid = model_list(i);
	% corresponding feature
	if mod(mid,2)==1
		f_list = fea_list1;
	else
		f_list = fea_list2;
	end

	% corresponding model
	if mid==1
		model = m1;
	elseif mid==2
		model = m2;
	elseif mid==3
		model = m3;
	elseif mid==4
		model = m4;
	elseif mid==5
		model = m5;
	elseif mid==6
		model = m6;
	end
	
	% make predictions
	p_label = predict(model,f_list);
	% change to double datatype
	if ~isa(p_label,'double')	
		p_label = str2num(char(p_label));
	end

	pred = [pred p_label];
end

% voting
boost_predict = sign(alpha_list*pred');
boost_predict = boost_predict';

end