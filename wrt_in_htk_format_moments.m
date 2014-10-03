% Code to 
clc; clear all; close all;
%% config

base_path='/media/DAA2C0D7A2C0B8F1/sunit/features/10msec/testing/';
save_path='Check in the middle';
feature_path='corr_corrected/';


number_of_channels=32;

% Phonemes for classification
ph_to_train={'sh','s','f','th'};
% ph_to_train={'sh'};

num_of_moments=4;




%% Start conversion to htk format
% X.feat -> features
% X.file -> file path of the mfcc (to be stored)


for ph_index=1:length(ph_to_train) 
	data_path=cell2mat([base_path, [ph_to_train(ph_index)],'/',feature_path]);
	all_cc=dir([data_path '*.mat']);
	total_files=length(all_cc);
	moment_count=0;
	
	for index=1:total_files
% 	for index=1:20
	    fprintf(1,'\r%d/%d',index,total_files);
	  
	    load(strcat(data_path,all_cc(index).name));
	     
	%     TOtal number of features
	    number_of_features=size(m1,2);
	    
	   
	    moment_count=moment_count+1;
	    all_m1(moment_count).m1=m1;
	    all_m2(moment_count).m2=m2;
	    all_m3(moment_count).m3=m3;
	    all_m4(moment_count).m4=m4;

	end
	
	
	
	
	if(moment_count==0)
	    error('No features were seen in the directory mentioned. Set the right feature path in the config file');
	end
	
	% Vectorize the feature

	 all_m1=[all_m1(:).m1];
	 all_m2=[all_m2(:).m2];
	 all_m3=[all_m3(:).m3];
	 all_m4=[all_m4(:).m4];
	 
     
     save_path=[base_path cell2mat(ph_to_train(ph_index)) '/htk_format/'];
     
     % Create a directory to store the features
     mkdir(save_path);
	 
	for channel=1:number_of_channels
% 	   features_for_training= [all_m1(channel,:) all_m2(channel,:) all_m3(channel,:) all_m4(channel,:) all_mod(channel,:)];
% 	   number_of_training_samples=length(features_for_training)/(num_of_moments+mod_filter_size_len);
% 	   features_for_training=reshape(features_for_training,number_of_training_samples,num_of_moments+mod_filter_size_len);
%        
       
       features_for_training= [all_m1(channel,:) all_m2(channel,:) all_m3(channel,:) all_m4(channel,:) ];
        number_of_training_samples=length(features_for_training)/(num_of_moments);
        features_for_training=reshape(features_for_training,number_of_training_samples,num_of_moments);
   
% 	   f_mean=mean(features_for_training); %Global Mean
% 	   f_std=std(features_for_training); % Glodal std
% 	   
% 	    save([save_path   '/mean_std' num2str(channel) '.mat'],'f_mean','f_std');
% 	   features_for_training=(features_for_training-repmat(f_mean,size(features_for_training,1),1))./repmat(f_std,size(features_for_training,1),1);
	   X.feat=features_for_training';
	   X.file=[save_path 'Channel' num2str(channel) '.mfc'];
	   
	   fn_storestruct(X,9);	      
	   fprintf('\n Complete for channel %d\n',channel);
	end
clear all_*;
end
	
