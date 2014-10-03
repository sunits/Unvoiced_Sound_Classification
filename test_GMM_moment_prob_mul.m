%% GIve bad results

function []=test_GMM_moment_prob_mul(full_path, ... %
					ph_to_train, ... % Phonemes to Train
					feature_path, ... % Path where features are stored inside the phoneme directory
					gender, ... %Male('m'), Female('f'), All('')
					gmm_path, ... % Neural Network model save path
					number_of_channels, ... % Number of channels(for filterbank)
					mod_filter_size_len, ...
					mod_scaling_factor, ... % Number of modulation filters (modulation filterbank)
                    lpc_length_peak, ...  % Number of LPC coefficients to capture Peaks
                    lpc_length_valley, ... % Number of LPC coefficients to capture valleys
                    prob_model_path, ... % where is the probability model path
                    prediction_save_path, ...   % Where do I save your prediction resullts?
			num_of_moments, ...
			channels_to_consider, ... % Not all channels give differentiability. So which ones are to be included
            phonemes_to_compare)     % ph_to_train={'sh','s','f','th','p','k','ch','t'}; give the indices of phonemes in an array, for example to compare /sh/ and /f/, indices should be [1 3]


moment_count=0;

number_of_classes=length(ph_to_train);

prob_model=zeros(number_of_channels,number_of_classes);

for ph_index=1:number_of_classes 
    counter=0;
    data_path=cell2mat([full_path, [ph_to_train(ph_index)],feature_path]);
    all_cc=dir(strcat(data_path,'*.mat'));

    fprintf('\n---%s---\n',cell2mat(ph_to_train(ph_index)));
    total_files=length(all_cc);
        for index=1:total_files
%             for index=1:20

        fprintf(1,'\r%d/%d',index,total_files);
        %% Gender specificity- Train for male or female only 
         if(all_cc(index).name(5)==gender | gender=='a')



        %%

            load(strcat(data_path,all_cc(index).name));

        %     TOtal number of phones in the data
            number_of_phones=size(m1,2);

            
            moment_count=moment_count+1;
            all_m1(moment_count).m1=m1;
            all_m2(moment_count).m2=m2;
            all_m3(moment_count).m3=m3;
            all_m4(moment_count).m4=m4;
%             all_m5(moment_count).m5=m5;
%             all_m6(moment_count).m6=m6;
            

            
         else 
            continue;
         end

        end


% Vectorize the feature
 all_m1=[all_m1(:).m1];
 all_m2=[all_m2(:).m2];
 all_m3=[all_m3(:).m3];
 all_m4=[all_m4(:).m4];
%  all_m5=[all_m5(:).m5];
%  all_m6=[all_m6(:).m6];
 
 

%class_prob=zeros(size(all_m1,2),number_of_channels);
class_prob=zeros(size(all_m1,2),sum(channels_to_consider>0));
class_prob1=zeros(size(all_m1,2),sum(channels_to_consider>0));
load([prob_model_path]);


for channel=1:number_of_channels
    
	if(channels_to_consider(channel)==0)
		continue;
	end
	

   load([gmm_path 'Channel',num2str(channel)]);
%    features_for_training= [all_m1(channel,:) all_m2(channel,:) all_m3(channel,:) all_m4(channel,:) all_m5(channel,:) all_m6(channel,:)];
    features_for_training= [all_m1(channel,:) all_m2(channel,:) all_m3(channel,:) all_m4(channel,:)];
   number_of_training_samples=length(features_for_training)/(num_of_moments);
   features_for_training=reshape(features_for_training,number_of_training_samples,num_of_moments);
    
  
   
   %f_mean  and f_std loads from the stored model
   features_for_training=(features_for_training-repmat(f_mean,size(features_for_training,1),1))./repmat(f_std,size(features_for_training,1),1);
    
   temp_prob=zeros(size(all_m1,2),number_of_classes);
   temp_prob1=zeros(size(all_m1,2),number_of_classes);
   
   for class_index=1:number_of_classes
        temp_prob(:,class_index)=pdf(GMM{class_index}.model,features_for_training)*prob_model(channel,class_index);
        temp_prob1(:,class_index)=pdf(GMM{class_index}.model,features_for_training);
   end
   
   [junk class_prob(:,channel)]=max(temp_prob,[],2);
   [junk class_prob1(:,channel)]=max(temp_prob1,[],2);
   fprintf('\n Complete for channel %d',channel);
end


[count classes]=hist(class_prob',unique(class_prob));
[count1 classes1]=hist(class_prob1',unique(class_prob1));

[val max_at]=max(count);   
result(ph_index).predicted=(classes(max_at));


[val1 max_at1]=max(count1);   
result(ph_index).predicted1=(classes(max_at1));


result(ph_index).truth=ph_index*ones(number_of_training_samples,1);
result(ph_index).vote_predicted=voting_part_channel(class_prob1,length(ph_to_train),prob_model_path,phonemes_to_compare,channels_to_consider);

acc=check_accuracy([result(ph_index).truth],[result(ph_index).predicted']);
acc1=check_accuracy([result(ph_index).truth],[result(ph_index).vote_predicted]);
fprintf('Accuracy for ph:%d : %f and %f\n',ph_index,acc,acc1);

clear all_*;

end
save([prediction_save_path 'result_mul.mat'] ,'result');

