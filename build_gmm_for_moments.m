% function [] =build_gmm_for_moments(data_path,gmm_path,ch_data_path)
close all; clear all;
full_path='/home/dsplws/sunit/unvoicedCasa/TIMIT/30Channel/';

tic;

number_of_channels=30;

ph_to_train={'s','f','th','jh','ch','p','t','k'};
VarFloor=0.00001;


for ph_index=1:length(ph_to_train)
    
gmm_path=cell2mat([full_path, [ph_to_train(ph_index)], '/gmm_moments/']);


mkdir(gmm_path);

data_path=cell2mat([full_path, [ph_to_train(ph_index)], '/data/']);
all_cc=dir(strcat(data_path,'*.mat'));


for index=1:length(all_cc)        
    
    load(strcat(data_path,all_cc(index).name));
    
    all_moments(index).m1=m1;
    all_moments(index).m2=m2;
    all_moments(index).m3=m3;
    all_moments(index).m4=m4;
    
end
toc
all_m1=[all_moments(:).m1];
all_m2=[all_moments(:).m2];
all_m3=[all_moments(:).m3];
all_m4=[all_moments(:).m4] ;

clear all_moments;
for channel=1:number_of_channels
   features= [all_m1(channel,:)' all_m2(channel,:)' all_m3(channel,:)' all_m4(channel,:)' ];
   f_mean=mean(features);
   f_std=std(features);
    features(:,1)=(features(:,1)-f_mean(1))/f_std(1);
   features(:,2)=(features(:,2)-f_mean(2))/f_std(2);
   features(:,3)=(features(:,3)-f_mean(3))/f_std(3);
   features(:,4)=(features(:,4)-f_mean(4))/f_std(4);   
   
   model=gmdistribution.fit(features,7,'CovType','diagonal','Regularize',VarFloor);
   save(strcat(gmm_path,'Channel',num2str(channel)),'model','f_mean','f_std');
   fprintf('\n Complete for channel %d',channel);
end
clear all_*;
end

toc;