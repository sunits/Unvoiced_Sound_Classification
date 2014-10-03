%THis is a special code written to reduce the number of features needed to
%be taken - for s phoneme

% Code to 
clc; clear all; close all;
%% config

base_path='/home/dsplabserver/Dropbox/Sunit/to_sunit/sunit/unvoicedCasa/TIMIT/30Channel/20msec/Testing/';
mean_std_base_path='/home/dsplabserver/Dropbox/Sunit/to_sunit/sunit/unvoicedCasa/TIMIT/30Channel/20msec/Training/';
mean_std_path='htk_format_no_LPC/';
feature_path='20msec_frame/';

number_of_channels=32;

save_path='see in the middle'; % This is a message- not a path

% Phonemes for classification
% % ph_to_train={'sh','s','f','th'};
ph_to_train={'sh','s','f','th'};
% ph_to_train={'sh'};

lpc_length_peak=10;
lpc_length_valley=15;
mod_filter_size_len=20;
num_of_moments=4;
mod_scaling_factor=1e8;

percentage_of_features=1;



%% Start conversion to htk format
% X.feat -> features
% X.file -> file path of the mfcc (to be stored)


for ph_index=1:length(ph_to_train) 
	data_path=cell2mat([base_path, [ph_to_train(ph_index)],'/',feature_path]);
	all_cc=dir([data_path '*.mat']);
	total_files=length(all_cc);
	moment_count=0;
	counter=0;
	for index=1:total_files
% 	for index=1:20
	    fprintf(1,'\r%d/%d',index,total_files);
	  
	    load(strcat(data_path,all_cc(index).name));
	     
	%     TOtal number of features
	    number_of_features=size(m1,2);
	    
	    temp=reshape(modPower,number_of_channels,mod_filter_size_len,number_of_features);    
        tempCC=reshape(cross_corr,number_of_channels,number_of_channels,number_of_features);
	    
	    moment_count=moment_count+1;
	    all_m1(moment_count).m1=m1;
	    all_m2(moment_count).m2=m2;
	    all_m3(moment_count).m3=m3;
	    all_m4(moment_count).m4=m4;
	        
	    for temp_index=1:number_of_features      
	
	        counter=counter+1;
            
%              [peaks,valleys]=lpc_based_features(tempCC(:,:,temp_index),lpc_length_peak,lpc_length_valley);
                 feature=dct2(tempCC(:,:,temp_index));
	%         Put all features into one var
	%         all_cross_corr(counter).cc=feature;        NumMix
	        all_cross_corr(counter).mod=mod_scaling_factor*temp(:,:,temp_index);
            all_cross_corr(counter).cc=feature;
	    end
	end
	
	
	
	
	if(counter==0)
	    error('No features were seen in the directory mentioned. Set the right feature path in the config file');
	end
	
	% Vectorize the feature
	 all_mod=[all_cross_corr(:).mod];  
     all_cross_corr=[all_cross_corr(:).cc];
	 all_m1=[all_m1(:).m1];
	 all_m2=[all_m2(:).m2];
	 all_m3=[all_m3(:).m3];
	 all_m4=[all_m4(:).m4];
	 
     
     save_path=[base_path cell2mat(ph_to_train(ph_index)) '/htk_format_noLPC/'];
     
     % Create a directory to store the features
     mkdir(save_path);
	 
	for channel=1:number_of_channels
% 	   features_for_training= [all_m1(channel,:) all_m2(channel,:) all_m3(channel,:) all_m4(channel,:) all_mod(channel,:)];
% 	   number_of_training_samples=length(features_for_training)/(num_of_moments+mod_filter_size_len);
% 	   features_for_training=reshape(features_for_training,number_of_training_samples,num_of_moments+mod_filter_size_len);
%        
       
       features_for_training= [all_m1(channel,:) all_m2(channel,:) all_m3(channel,:) all_m4(channel,:) all_cross_corr(channel,:) all_mod(channel,:)];
        number_of_training_samples=length(features_for_training)/(num_of_moments+mod_filter_size_len+number_of_channels);
        features_for_training=reshape(features_for_training,number_of_training_samples,num_of_moments+mod_filter_size_len+number_of_channels);
   
        features_randomized=randperm(number_of_training_samples);
        features_for_training=features_for_training(features_randomized(1:ceil(number_of_training_samples*percentage_of_features)),:);
       
        load([mean_std_base_path  cell2mat(ph_to_train(ph_index)) '/' mean_std_path 'mean_std' num2str(channel) '.mat'])
% 	   
% 	   f_mean=mean(features_for_training); %Global Mean
% 	   f_std=std(features_for_training); % Glodal std
	   
% 	    save([save_path   '/mean_std' num2str(channel) '.mat'],'f_mean','f_std');
	   features_for_training=(features_for_training-repmat(f_mean,size(features_for_training,1),1))./repmat(f_std,size(features_for_training,1),1);
	   X.feat=features_for_training';
	   X.file=[save_path 'Channel' num2str(channel) '.mfc'];
	   
	   fn_storestruct(X,9);	      
	   fprintf('\n Complete for channel %d\n',channel);
	end
clear all_*;
end
	
