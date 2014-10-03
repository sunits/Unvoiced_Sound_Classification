% function [] =build_gmm_for_moments(data_path,gmm_path,ch_data_path)
close all; clear all;
full_path='/home/dsplws/sunit/unvoicedCasa/TIMIT/30Channel/';

tic;

number_of_channels=32;

ph_to_train={'sh','s','f','th','jh','ch','p','t','k'};
VarFloor=0.00001;
number_of_phones=0;
lpc_length=15;
mod_filter_size_len=0;

scaling_factor=1e8;
label=[];

counter=0;

nn_path=[full_path, 'nn_ex4_cross_corr/'];
mkdir(nn_path);

for ph_index=1:length(ph_to_train) 

data_path=cell2mat([full_path, [ph_to_train(ph_index)], '/data/modPower_window_mag_corrected/']);
all_cc=dir(strcat(data_path,'*.mat'));


for index=1:length(all_cc)        
%     for index=1:20
    
    load(strcat(data_path,all_cc(index).name));
     
%     TOtal number of phones in the data
    number_of_phones=size(m1,2);
    
%     temp=reshape(modPower,number_of_channels,mod_filter_size_len,number_of_phones);
    tempCC=reshape(cross_corr,number_of_channels,number_of_channels,number_of_phones);
    
    for temp_index=1:number_of_phones
        

        [peaks,valleys]=lpc_based_features(tempCC(:,:,temp_index),lpc_length);
        feature=[peaks valleys];
        
        counter=counter+1;
%         Put all features into one var
%         all_cross_corr(counter).cc=feature;        
%         all_cross_corr(counter).mod=temp(:,:,temp_index);
        all_cross_corr(counter).cc=feature;
        all_cross_corr(counter).label=ph_index;
    end
end
end

% Vectorize the feature
%  all_mod=scaling_factor*[all_cross_corr(:).mod];
 all_label=[all_cross_corr(:).label]';
 all_cross_corr=[all_cross_corr(:).cc];
 

addpath /home/dsplws/sunit/ex4/;

for channel=1:number_of_channels
   features_for_training= [all_cross_corr(channel,:)];
   number_of_training_samples=length(features_for_training)/(mod_filter_size_len+2*lpc_length);
   features_for_training=reshape(features_for_training,number_of_training_samples,mod_filter_size_len+2*lpc_length);
   
   f_mean=mean(features_for_training); %Global Mean
   f_std=std(features_for_training); % Glodal std
   
   features_for_training=(features_for_training-repmat(f_mean,size(features_for_training,1),1))./repmat(f_std,size(features_for_training,1),1);
   [Theta1 Theta2]=useNNEx4(features_for_training,all_label,length(unique(all_label)));
   
   save(strcat(nn_path,'Channel',num2str(channel)),'Theta1','Theta2','f_mean','f_std');
   fprintf('\n Complete for channel %d',channel);
end


toc;