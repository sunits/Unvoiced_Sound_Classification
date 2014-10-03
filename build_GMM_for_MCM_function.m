function []=build_GMM_for_MCM_function(full_path, ... %
					ph_to_train, ...                        % Phonemes to Train
					feature_path, ...                       % Path where features are stored inside the phoneme directory
					gender, ...                             % Male('m'), Female('f'), All('')
					gmm_path, ...                           % Neural Network model save path
					number_of_channels, ...                 % Number of channels(for filterbank)
					mod_filter_size_len, ...
					mod_scaling_factor, ...                 % Number of modulation filters (modulation filterbank)
                    lpc_length_peak, ...                    % Number of LPC coefficients to capture Peaks
                    lpc_length_valley, ...                  % Number of LPC coefficients to capture valleys
                    varFloorPer, ...                        % Variance floor - varFloorPer Percentage of global variance will be set as varFloor
                    GMMOptions, ...                         % Contains information about iterations- Should be an output of statset
                    NumMix, ...                             % Number of GMM mixtures
                    CovType)                                % Covariance type- Diagonal/ full?

                
num_of_moments=4;
moment_count=0;
counter=0;

for ph_index=1:length(ph_to_train) 
data_path=cell2mat([full_path, [ph_to_train(ph_index)],feature_path]);
all_cc=dir(strcat(data_path,'*.mat'));

fprintf('\n---%s---\n',cell2mat(ph_to_train(ph_index)));
total_files=length(all_cc);
%for index=1:total_files
     for index=1:250

fprintf(1,'\r%d/%d',index,total_files);
%% Gender specificity- Train for male or female only 
 if(all_cc(index).name(5)==gender | gender=='a')
   
 

%%
    
    load(strcat(data_path,all_cc(index).name));
     
%     TOtal number of phones in the data
    number_of_phones=size(m1,2);
    
    temp=reshape(modPower,number_of_channels,mod_filter_size_len,number_of_phones);
    tempCC=reshape(cross_corr,number_of_channels,number_of_channels,number_of_phones);
    
     if(sum(isnan(tempCC(:))))
        fprintf('\n\n --------------------  NaN detected ------------------\n\n');     
     end
 
    
    moment_count=moment_count+1;
    all_m1(moment_count).m1=m1;
    all_m2(moment_count).m2=m2;
    all_m3(moment_count).m3=m3;
    all_m4(moment_count).m4=m4;
        
    for temp_index=1:number_of_phones
        

         [peaks,valleys]=lpc_based_features(tempCC(:,:,temp_index),lpc_length_peak,lpc_length_valley);
        feature=[peaks valleys];
        
        
         if(sum(isnan(feature(:))))
            fprintf('\n\n --------------------  NaN detected ------------------\n\n');     
         end
     
        counter=counter+1;
%         Put all features into one var
%         all_cross_corr(counter).cc=feature;        NumMix
        all_cross_corr(counter).mod=mod_scaling_factor*temp(:,:,temp_index);
        all_cross_corr(counter).cc=feature;
        all_cross_corr(counter).label=ph_index;

    end
 else 
    continue;
 end
 
end
end

% Vectorize the feature
 all_mod=[all_cross_corr(:).mod];
 all_label=[all_cross_corr(:).label]';
 all_cross_corr=[all_cross_corr(:).cc];
 all_m1=[all_m1(:).m1];
 all_m2=[all_m2(:).m2];
 all_m3=[all_m3(:).m3];
 all_m4=[all_m4(:).m4];
 
 no_of_phs=length(ph_to_train);
 
 
 global_var=var([all_m1(:);all_m2(:);all_m3(:);all_m4(:);all_cross_corr(:);all_mod(:)]);
 varFloorPer=sqrt(varFloorPer*global_var/100);
 fprintf('\n Global variance is %f and varFloor is %f \n',global_var,varFloorPer);
 

for channel=1:number_of_channels
   features_for_training= [all_m1(channel,:) all_m2(channel,:) all_m3(channel,:) all_m4(channel,:) all_cross_corr(channel,:) all_mod(channel,:)];
   number_of_training_samples=length(features_for_training)/(num_of_moments+mod_filter_size_len+(lpc_length_peak+lpc_length_valley));
   features_for_training=reshape(features_for_training,number_of_training_samples,num_of_moments+mod_filter_size_len+(lpc_length_peak+lpc_length_valley));
   
   f_mean=mean(features_for_training); %Global Mean
   f_std=std(features_for_training); % Glodal std
   
   features_for_training=(features_for_training-repmat(f_mean,size(features_for_training,1),1))./repmat(f_std,size(features_for_training,1),1);
   
   for ph_index=1:no_of_phs
    tempGMM = gmdistribution.fit(features_for_training(all_label==ph_index,:),NumMix,'CovType',CovType,'Regularize',varFloorPer,'Options',GMMOptions);
    GMM{ph_index}.model =tempGMM;
   end
   
   save(strcat(gmm_path,'Channel',num2str(channel)),'GMM','f_mean','f_std');
%    save(strcat(gmm_path,'Channel',num2str(channel)),'Theta1','Theta2','f_mean');
   fprintf('\n Complete for channel %d',channel);
end


