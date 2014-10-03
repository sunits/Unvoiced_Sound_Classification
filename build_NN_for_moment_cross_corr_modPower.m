close all; clear all;clc;
full_path='/home/dsplws/sunit/unvoicedCasa/TIMIT/30Channel/';

tic;

number_of_channels=32;
%ph_to_train={'sh','s','f','th','jh','ch','p','t','k'};
ph_to_train={'sh','s','f','th'};
VarFloor=0.00001;
number_of_phones=0;
lpc_length_peak=15;
lpc_length_valley=30;
mod_filter_size_len=20;
num_of_moments=4;

scaling_factor=1e8;
label=[];

counter=0;

%MMC stands for moments, mod power and cross correlation
nn_path=[full_path,'x_mu/', 'nn_MMC_s_sh_f_th_LPC_CEP_15_30/'];

mkdir(nn_path);
moment_count=0;

for ph_index=1:length(ph_to_train) 

data_path=cell2mat([full_path, [ph_to_train(ph_index)], '/data/modPower_window_mag_corrected/']);
all_cc=dir(strcat(data_path,'*.mat'));


for index=1:length(all_cc)
%     for index=1:20

% %% TO GET THE MALE PART ONLY
% 
% if(all_cc(index).name(5)=='f')
%    continue; 
% end
% 

%%
    
    load(strcat(data_path,all_cc(index).name));
     
%     TOtal number of phones in the data
    number_of_phones=size(m1,2);
    
    temp=reshape(modPower,number_of_channels,mod_filter_size_len,number_of_phones);
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
        all_cross_corr(counter).mod=temp(:,:,temp_index);
        all_cross_corr(counter).cc=feature;
        all_cross_corr(counter).label=ph_index;

    end
end
end

% Vectorize the feature
 all_mod=scaling_factor*[all_cross_corr(:).mod];
 all_label=[all_cross_corr(:).label]';
 all_cross_corr=[all_cross_corr(:).cc];
 all_m1=[all_m1(:).m1];
 all_m2=[all_m2(:).m2];
 all_m3=[all_m3(:).m3];
 all_m4=[all_m4(:).m4];
 

addpath /home/dsplws/sunit/ex4/;

for channel=1:number_of_channels
   features_for_training= [all_m1(channel,:) all_m2(channel,:) all_m3(channel,:) all_m4(channel,:) all_cross_corr(channel,:) all_mod(channel,:)];
   number_of_training_samples=length(features_for_training)/(num_of_moments+mod_filter_size_len+(lpc_length_peak+lpc_length_valley));
   features_for_training=reshape(features_for_training,number_of_training_samples,num_of_moments+mod_filter_size_len+(lpc_length_peak+lpc_length_valley));
   
   f_mean=mean(features_for_training); %Global Mean
%    f_std=std(features_for_training); % Glodal std
   
%    features_for_training=(features_for_training-repmat(f_mean,size(features_for_training,1),1))./repmat(f_std,size(features_for_training,1),1);
    features_for_training=(features_for_training-repmat(f_mean,size(features_for_training,1),1));
   [Theta1 Theta2]=useNNEx4(features_for_training,all_label,length(unique(all_label)));
   
%    save(strcat(nn_path,'Channel',num2str(channel)),'Theta1','Theta2','f_mean','f_std');
   save(strcat(nn_path,'Channel',num2str(channel)),'Theta1','Theta2','f_mean');
   fprintf('\n Complete for channel %d',channel);
end


toc;
