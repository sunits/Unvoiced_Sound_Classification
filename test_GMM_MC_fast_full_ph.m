function []=test_GMM_MC_fast_full_ph(full_path, ... %
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
                    prediction_save_path)   % Where do I save your prediction resullts?


num_of_moments=4;
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


            tempCC=reshape(cross_corr,number_of_channels,number_of_channels,number_of_phones);

            moment_count=moment_count+1;
            all_m1(moment_count).m1=m1;
            all_m2(moment_count).m2=m2;
            all_m3(moment_count).m3=m3;
            all_m4(moment_count).m4=m4;
            

            for temp_index=1:number_of_phones


                 [peaks,valleys]=lpc_based_features(tempCC(:,:,temp_index),lpc_length_peak,lpc_length_valley);
                feature=[peaks valleys];

                counter=counter+1;
        %         Put all features into one var
        %         all_cross_corr(counter).cc=feature;        

                all_cross_corr(counter).cc=feature;
                all_cross_corr(counter).label=ph_index;
                

            end
         else 
            continue;
         end

        end


% Vectorize the feature

 all_cross_corr=[all_cross_corr(:).cc];
 all_m1=[all_m1(:).m1];
 all_m2=[all_m2(:).m2];
 all_m3=[all_m3(:).m3];
 all_m4=[all_m4(:).m4];
 
 

class_prob=zeros(size(all_m1,2),number_of_channels);

for channel=1:number_of_channels
    
   load([gmm_path 'Channel',num2str(channel)]);
   features_for_training= [all_m1(channel,:) all_m2(channel,:) all_m3(channel,:) all_m4(channel,:) all_cross_corr(channel,:) ];
   number_of_training_samples=length(features_for_training)/(num_of_moments+(lpc_length_peak+lpc_length_valley));
   features_for_training=reshape(features_for_training,number_of_training_samples,num_of_moments+(lpc_length_peak+lpc_length_valley));
    
  
   
   %f_mean  and f_std loads from the stored model
   features_for_training=(features_for_training-repmat(f_mean,size(features_for_training,1),1))./repmat(f_std,size(features_for_training,1),1);
    
   temp_prob=zeros(size(all_m1,2),number_of_classes);
   
   for class_index=1:number_of_classes
        temp_prob(:,class_index)=pdf(GMM{class_index}.model,features_for_training);
   end
   
   [junk class_prob(:,channel)]=max(temp_prob,[],2);
   fprintf('\n Complete for channel %d',channel);
end


[count classes]=hist(class_prob',unique(class_prob));
[val max_at]=max(count);   
result(ph_index).predicted=(classes(max_at));

result(ph_index).truth=ph_index*ones(number_of_training_samples,1);
result(ph_index).vote_predicted=voting(class_prob,length(ph_to_train),prob_model_path);

acc=check_accuracy([result(ph_index).truth],[result(ph_index).vote_predicted]);
fprintf('Accuracy for ph:%d : %f \n',ph_index,acc);

clear all_*;

end
save([prediction_save_path 'result.mat'],'result');

