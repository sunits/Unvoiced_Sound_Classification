%% Author: Sunit Sivasankaran
%% Code to plot the features of classes using LDA


clc; clear all; 

% %% Data
% % data is in svm format. Use libsvm to read it
% addpath ~/softwares/libsvm-3.14/matlab/
% 
% file_name='Channel6';
% svm_feature_training_path=['/home/sunit/temp/10msec/' file_name];
% % svm_feature_testing_path=['/home/sunit/temp/10msec/' file_name];
% 
% %Read the data
% [label inst_mat]=libsvmread(svm_feature_training_path) ;

%% Data
rain='/media/885C28DA5C28C532/sound_data/sounds_again/data_23_44_verified/rain/3/sub_band_1K_cut_var_adj_16_dict_wgt/3_new.mfc';
train='/media/885C28DA5C28C532/sound_data/sounds_again/data_23_44_verified/train/3/sub_band_1K_cut_var_adj_16_dict_wgt/3_new.mfc';
restaurant='/media/885C28DA5C28C532/sound_data/sounds_again/data_23_44_verified/restaurant/3/sub_band_1K_cut_var_adj_16_dict_wgt/3_new.mfc';
stream='/media/885C28DA5C28C532/sound_data/sounds_again/data_23_44_verified/stream/3/sub_band_1K_cut_var_adj_16_dict_wgt/23_new.mfc';

[rainMFCC]=read_mfcc(rain);
[trainMFCC]=read_mfcc(train);
[restaurantMFCC]=read_mfcc(restaurant);
% streamMFCC=read_mfcc(stream);
streamMFCC=[];


rainMFCC=rainMFCC(:,13:16);
trainMFCC=trainMFCC(:,13:16);
restaurantMFCC=restaurantMFCC(:,13:16);
% streamMFCC=streamMFCC(:,13:16);

label=[ones(size(rainMFCC,1),1); 2*ones(size(trainMFCC,1),1) ;3*ones(size(restaurantMFCC,1),1); 4*ones(size(streamMFCC,1),1)];
inst_mat=[rainMFCC;trainMFCC;restaurantMFCC;streamMFCC];
%% Overall mean
m=mean(inst_mat);


%% In class scatter

% number of classes 
no_of_class=length(unique(label));

class_mean=zeros( no_of_class,size(inst_mat,2));
in_class_scatter=zeros(size(inst_mat,2),size(inst_mat,2),no_of_class);
between_class_scatter=zeros(size(inst_mat,2),size(inst_mat,2),no_of_class);

for index=1:no_of_class
    
    class_vectors=inst_mat(label==index,:);
    class_mean(index,:)=mean(class_vectors);
    zero_mean_vec=class_vectors-repmat(class_mean(index,:),size(class_vectors,1),1);    
    in_class_scatter(:,:,index)=zero_mean_vec'*zero_mean_vec;
    between_class_scatter(:,:,index)=(class_mean(index,:)-m)'*(class_mean(index,:)-m);
    
end

final_in_class = sum(in_class_scatter,3);
final_bw_class = sum(between_class_scatter,3);

% Compute the SVD
[U S V]=svd(final_in_class\final_bw_class);
% [U S V]=svd(inv(final_in_class)*final_bw_class);

project_val=inst_mat* U(:,1:3);

%% Plot to your convenience 
 
% scatter3(project_val(label==1,1),project_val(label==1,2),project_val(label==1,3)); hold on;
% scatter3(project_val(label==2,1),project_val(label==2,2),project_val(label==2,3),'r');
% scatter3(project_val(label==3,1),project_val(label==3,2),project_val(label==3,3),'g');
% scatter3(project_val(label==4,1),project_val(label==4,2),project_val(label==4,3),'k');


scatter(project_val(label==1,1),project_val(label==1,2)); hold on;
scatter(project_val(label==2,1),project_val(label==2,2),'r+');hold on;
scatter(project_val(label==3,1),project_val(label==3,2),'g^');
scatter(project_val(label==4,1),project_val(label==4,2),'kx');


hold off;


%% Write traing data to SVM format
% libsvmwrite([file_name '_lda'],label,project_val);
% [test_label test_inst_mat]=libsvmread(svm_feature_testing_path) ;
% 
% 
% %% Write testing data to SVM format
% project_val_test=test_inst_mat*U(:,1:3);
% libsvmwrite([file_name '_lda'],label,project_val);
