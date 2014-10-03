% function [] =build_gmm_for_moments(data_path,gmm_path,ch_data_path)
close all; clear all;clc;
full_path='/home/dsplws/sunit/unvoicedCasa/TIMIT/30Channel/';

tic;

number_of_channels=30;

ph_to_train={'sh','s','f','th','jh','ch','p','t','k'};
VarFloor=0.00001;


nn_path=([full_path, 'nn_ex4_momemts/']);
mkdir(nn_path);

counter=0;
for ph_index=1:length(ph_to_train)
    


data_path=cell2mat([full_path, [ph_to_train(ph_index)], '/data/']);
all_cc=dir(strcat(data_path,'*.mat'));


for index=1:length(all_cc)        
%         for index=1:20
    
    load(strcat(data_path,all_cc(index).name));
    counter=counter+1;
    all_moments(counter).m1=m1;
    all_moments(counter).m2=m2;
    all_moments(counter).m3=m3;
    all_moments(counter).m4=m4;
    temp_labels=ph_index*ones(1,size(m4,2));
    all_moments(counter).label=temp_labels;
end

end

toc
all_m1=[all_moments(:).m1];
all_m2=[all_moments(:).m2];
all_m3=[all_moments(:).m3];
all_m4=[all_moments(:).m4] ;
all_label=[all_moments(:).label]';

clear all_moments;
addpath /home/dsplws/sunit/ex4/;

for channel=1:number_of_channels
   features= [all_m1(channel,:)' all_m2(channel,:)' all_m3(channel,:)' all_m4(channel,:)' ];
   f_mean=mean(features);
   f_std=std(features);
    features(:,1)=(features(:,1)-f_mean(1))/f_std(1);
   features(:,2)=(features(:,2)-f_mean(2))/f_std(2);
   features(:,3)=(features(:,3)-f_mean(3))/f_std(3);
   features(:,4)=(features(:,4)-f_mean(4))/f_std(4);   
   
%    model=gmdistribution.fit(features,7,'CovType','diagonal','Regularize',VarFloor);
  [Theta1 Theta2]=useNNEx4(features,all_label,length(unique(all_label)));
  
   save(strcat(nn_path,'Channel',num2str(channel)),'Theta1','Theta2','f_mean','f_std');
   fprintf('\n Complete for channel %d',channel);
end

toc;