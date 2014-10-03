function []=build_GMM_moments_prob_model_fast(full_path, ... %
					ph_to_train, ... % Phonemes to Train
					feature_path, ... % Path where features are stored inside the phoneme directory
					gender, ... %Male('m'), Female('f'), All('')
					gmm_path, ... % Neural Network model save path
					number_of_channels, ... % Number of channels(for filterbank)
					mod_filter_size_len, ...
					mod_scaling_factor, ... % Number of modulation filters (modulation filterbank)
                    lpc_length_peak, ...  % Number of LPC coefficients to capture Peaks
                    lpc_length_valley, ... % Number of LPC coefficients to capture valleys
                    prob_model_save_path, ...   % Where do I save your dumb model?
			num_of_moments)


moment_count=0;
counter=0;
number_of_classes=length(ph_to_train);

prob_model=zeros(number_of_channels,number_of_classes);

for ph_index=1:number_of_classes 
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
%            
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

class_prob=zeros(size(all_m1,2),number_of_channels);

for channel=1:number_of_channels
    
   load([gmm_path 'Channel',num2str(channel)]);
%    features_for_training= [all_m1(channel,:) all_m2(channel,:) all_m3(channel,:) all_m4(channel,:) all_m5(channel,:) all_m6(channel,:) ];
features_for_training= [all_m1(channel,:) all_m2(channel,:) all_m3(channel,:) all_m4(channel,:) ];
   number_of_training_samples=length(features_for_training)/(num_of_moments);
   features_for_training=reshape(features_for_training,number_of_training_samples,num_of_moments);
   
   
   %f_mean  and f_std loads from the stored model
   features_for_training=(features_for_training-repmat(f_mean,size(features_for_training,1),1))./repmat(f_std,size(features_for_training,1),1);
    
   temp_prob=zeros(size(all_m1,2),number_of_classes);
   
   for class_index=1:number_of_classes
        temp_prob(:,class_index)=pdf(GMM{class_index}.model,features_for_training);
   end
   
   [junk class_prob(:,channel)]=max(temp_prob,[],2);
   fprintf('\n Complete for channel %d',channel);
end

prob_model(:,ph_index)= sum(class_prob==ph_index)/size(class_prob,1);
prob_model(:,ph_index)=prob_model(:,ph_index)/sum(prob_model(:,ph_index));
clear all_*;

end

save([prob_model_save_path 'final.mat'],'prob_model');
