clc; clear all; close all;
dump_to_folder='scaled/';
model_folder='svm_h0/';
base_folder='/home/dsplabserver/Dropbox/Sunit/to_sunit/sunit/unvoicedCasa/TIMIT/30Channel/20msec/Training/svm_format_sh_s_f_th/';
no_of_channels=32;
addpath ~/Dropbox/Sunit/to_sunit/sunit/unvoicedCasa/TIMIT/
addpath ~/software/libsvm-3.16/matlab/
addpath ~/software/liblinear-1.93/matlab/
% test_base_folder='/home/dsplabserver/Dropbox/Sunit/to_sunit/sunit/unvoicedCasa/TIMIT/30Channel/20msec/Testing/svm_format_sh_s_f_th_local_means/';
test_base_folder='/home/dsplabserver/Dropbox/Sunit/to_sunit/sunit/unvoicedCasa/TIMIT/30Channel/TestFeatures/svm_no_normalization/';
% test_htk_folder='/home/dsplabserver/Dropbox/Sunit/to_sunit/sunit/unvoicedCasa/TIMIT/30Channel/20msec/Testing/';
test_htk_folder='/home/dsplabserver/Dropbox/Sunit/to_sunit/sunit/unvoicedCasa/TIMIT/30Channel/TestFeatures/';
train_htk_folder='/home/dsplabserver/Dropbox/Sunit/to_sunit/sunit/unvoicedCasa/TIMIT/30Channel/20msec/Training/';
train_base_folder='/home/dsplabserver/Dropbox/Sunit/to_sunit/sunit/unvoicedCasa/TIMIT/30Channel/20msec/Training/svm_format_sig_scale_fb_norm/';
lib_linear_path='/home/dsplabserver/software/liblinear-1.93/';
folder_path='htk_format_no_normalization';

if(~exist(train_base_folder))
    mkdir(train_base_folder);
end

if(~exist(test_base_folder))
    mkdir(test_base_folder)
end

if(~exist([train_base_folder dump_to_folder ]))
    mkdir([train_base_folder dump_to_folder ])
end


if(~exist([test_base_folder dump_to_folder]))
    mkdir([test_base_folder dump_to_folder]);
end





 %% HTK format to svm-format
 for i=1:no_of_channels
     fprintf(1,'\r%d/%d',i,no_of_channels);
     sh=read_mfcc([test_htk_folder 'sh/' folder_path   '/Channel' num2str(i) '.mfc']);
     s=read_mfcc([test_htk_folder 's/' folder_path  '/Channel' num2str(i) '.mfc']);
     f=read_mfcc([test_htk_folder 'f/' folder_path  '/Channel' num2str(i) '.mfc']);
     th=read_mfcc([test_htk_folder 'th/' folder_path  '/Channel' num2str(i) '.mfc']);
     
     label=[ones(size(sh,1),1); 2*ones(size(s,1),1); 3*ones(size(f,1),1) ; 4*ones(size(th,1),1)];
     features=sparse([sh;s;f;th]);
    
     libsvmwrite([test_base_folder   'Channel' num2str(i)],label,features);    
     
 end



%% Scale Training data
 
% for i=1:no_of_channels
%     
%     fprintf(1,'\r%d/%d',i,no_of_channels);
%     sh=read_mfcc([train_htk_folder 'sh/' folder_path '/Channel' num2str(i) '.mfc']);
%     s=read_mfcc([train_htk_folder 's/' folder_path '/Channel' num2str(i) '.mfc']);
%     f=read_mfcc([train_htk_folder 'f/'  folder_path '/Channel' num2str(i) '.mfc']);
%     th=read_mfcc([train_htk_folder 'th/' folder_path '/Channel' num2str(i) '.mfc']);
%     
%     label=[ones(size(sh,1),1); 2*ones(size(s,1),1); 3*ones(size(f,1),1) ; 4*ones(size(th,1),1)];
%     features=sparse([sh;s;f;th]);
%     
%     libsvmwrite([train_base_folder   'Channel' num2str(i)],label,features);
%     
%     
%     cmd_scale=['svm-scale -l -1 -u 1 -s ' train_base_folder dump_to_folder   'range' num2str(i) ' ' train_base_folder  'Channel' num2str(i) ' > ' train_base_folder  dump_to_folder 'Channel' num2str(i) '.scale'];
%     system(cmd_scale);
%     
% end
% 


 %% Scale Testing data
% for i=1:no_of_channels
%     fprintf(1,'\r%d/%d',i,no_of_channels);
%     sh=read_mfcc([test_htk_folder 'sh/' folder_path   '/Channel' num2str(i) '.mfc']);
%     s=read_mfcc([test_htk_folder 's/' folder_path  '/Channel' num2str(i) '.mfc']);
%     f=read_mfcc([test_htk_folder 'f/' folder_path  '/Channel' num2str(i) '.mfc']);
%     th=read_mfcc([test_htk_folder 'th/' folder_path  '/Channel' num2str(i) '.mfc']);
%     
%     label=[ones(size(sh,1),1); 2*ones(size(s,1),1); 3*ones(size(f,1),1) ; 4*ones(size(th,1),1)];
%     features=sparse([sh;s;f;th]);
%    
%     libsvmwrite([test_base_folder   'Channel' num2str(i)],label,features);
%     
%     cmd_scale=['svm-scale -r '  train_base_folder dump_to_folder   'range' num2str(i) ' ' test_base_folder 'Channel' num2str(i) ' > '  test_base_folder dump_to_folder 'Channel' num2str(i) '.scale'];
%     system(cmd_scale);
% end
%
% 
 %% Build the model
 
%  mkdir([train_base_folder dump_to_folder model_folder ]);
%  for i=1:no_of_channels
%      fprintf(1,'\r%d/%d',i,no_of_channels);
%  %     cmd_scale=[lib_linear_path 'train -s 2  ' base_folder dump_to_folder 'Channel' num2str(i) '.scale ' base_folder dump_to_folder model_folder 'Channel' num2str(i) '.scaleModel' ];
%  %       cmd_scale=['svm-train ' base_folder dump_to_folder 'Channel' num2str(i) '.scale ' base_folder dump_to_folder model_folder 'Channel' num2str(i) '.scaleModel' ];
%         [label inst_mat]=libsvmread([train_base_folder dump_to_folder  'Channel' num2str(i) '.scale' ] ) ;
%        model=svmtrain(label, inst_mat,'-h 0');
%  %         model=train(label,inst_mat,'-s 2');
%        save([train_base_folder dump_to_folder model_folder 'scaleModel' num2str(i) '.mat'],'model');
%      
%  end
 
 
%%% Prediction
%if(~exist([test_base_folder dump_to_folder model_folder]))
%   mkdir([test_base_folder dump_to_folder model_folder]);
%end
%
%
%for i=1:no_of_channels  
%       
%   
%   [label,ins_mat]=libsvmread([ test_base_folder dump_to_folder 'Channel' num2str(i) '.scale']);
%   % load the model
%   load([train_base_folder dump_to_folder model_folder 'scaleModel' num2str(i) '.mat']);
%%    [predicted_label, accuracy, decision_values] = predict(label, ins_mat, model);
%   [predicted_label, accuracy, decision_values] = svmpredict(label, ins_mat, model);
%  save([test_base_folder dump_to_folder model_folder 'scaleModel' num2str(i) '.result'],'predicted_label', 'accuracy', 'decision_values');
%end
