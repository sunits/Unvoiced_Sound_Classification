function test_GMM_from_SVM_data(number_of_channels, ...
				basepath, ...
				gmm_path, ...				
                prob_model_path, ...
                phonemes_to_consider)


number_of_phones=length(phonemes_to_consider);
load(prob_model_path);
counter=0;
    for channel=10:number_of_channels
        [classInfo features]=libsvmread([basepath 'Channel' num2str(channel) '.scale']);
        features=full(features);
        phones=unique(classInfo);
       
	load([gmm_path 'Channel' num2str(channel)])
	temp_prob=zeros(size(features,1),length(phones));

    

        for class_index=1:length(phones)
                temp_prob(:,class_index)=pdf(GMM{class_index}.model,features)*prob_model(channel,class_index);
%         temp_prob(:,class_index)=pdf(GMM{class_index}.model,features);
        end
    
    
    counter=counter+1;
        
	[junk class_prob(:,counter)]=max(temp_prob,[],2);
        fprintf('\n Complete for channel %d',channel);       

    end



	[count classes]=hist(class_prob',unique(class_prob));
	[val max_at]=max(count);   
	predicted=(classes(max_at));
	
	truth=classInfo;
% 	vote_predicted=voting(class_prob,number_of_phones,prob_model_path,phonemes_to_consider);
% 	result(ph_index).boundary=all_boundary;
	acc=check_accuracy(truth,predicted');
	
	%[phTruth,phClassification,phAccuracy]=frameWindowing(all_boundary, ... % Information about number of frames per phonemes
	%                                        [result(ph_index).vote_predicted], ... % frame level classification result
	%                                        [result(ph_index).truth], ... % frame level truth values
	%                                        number_of_classes); % Total number of classes
	
	fprintf('\nNormal Acc =%d :\n',acc);
    confusion_matrix(truth,predicted',{'sh','s','f','th'})
end
