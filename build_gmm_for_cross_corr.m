% function [] =build_gmm_for_moments(data_path,gmm_path,ch_data_path)
close all; clear all;
full_path='/media/885C28DA5C28C532/Dropbox/code/unvoicedCasa/TIMIT/30Channel/';

tic;

number_of_channels=30;

ph_to_train={'sh','s','f','th','jh','ch','p','t','k'};
VarFloor=0.00001;
number_of_phones=0;
lpc_length=15;


for ph_index=1:length(ph_to_train)
    
gmm_path=cell2mat([full_path, [ph_to_train(ph_index)], '/gmm_cross_corr_lpc_',num2str(lpc_length),'/']);


mkdir(gmm_path);

data_path=cell2mat([full_path, [ph_to_train(ph_index)], '/data/']);
all_cc=dir(strcat(data_path,'*.mat'));

counter=0;
for index=1:length(all_cc)        
%     for index=1:20
    
    load(strcat(data_path,all_cc(index).name));
    
%     TOtal number of phones in the data
    number_of_phones=size(m1,2);
    
    temp=reshape(cross_corr,number_of_channels,number_of_channels,number_of_phones);
    
    for temp_index=1:number_of_phones
        
        [peaks,valleys]=lpc_based_features(temp(:,:,temp_index),lpc_length);
        feature=[peaks valleys];
        counter=counter+1;
%         Put all features into one var
        all_cross_corr(counter).cc=feature;        
    end
end
% Vectorize the feature
 all_cross_corr=[all_cross_corr(:).cc];

for channel=1:number_of_channels
   features_for_training= all_cross_corr(channel,:);   
   number_of_training_samples=length(features_for_training)/(2*lpc_length);
   features_for_training=reshape(features_for_training,number_of_training_samples,2*lpc_length);
   
   f_mean=mean(features_for_training);
   f_std=std(features_for_training);
   
   features_for_training=(features_for_training-repmat(f_mean,size(features_for_training,1),1))./repmat(f_std,size(features_for_training,1),1);
%     features(:,1)=(features(:,1)-f_mean(1))/f_std(1);
%    features(:,2)=(features(:,2)-f_mean(2))/f_std(2);
%    features(:,3)=(features(:,3)-f_mean(3))/f_std(3);
%    features(:,4)=(features(:,4)-f_mean(4))/f_std(4);   
%    
   model=gmdistribution.fit(features_for_training,10,'CovType','diagonal','Regularize',VarFloor);
   save(strcat(gmm_path,'Channel',num2str(channel)),'model','f_mean','f_std');
   fprintf('\n Complete for channel %d',channel);
end
clear all_cross_corr
end

toc;