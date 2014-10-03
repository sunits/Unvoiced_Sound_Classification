% Code to 
clc; clear all; close all;
%% config

base_path='/home/dsplabserver/Dropbox/Sunit/to_sunit/sunit/unvoicedCasa/TIMIT/30Channel/TrainFeatures/';

htk_feature_path='htk_format/';
svm_feature_save_path='svm_format/';
number_of_channels=32;

if(~exist([base_path svm_feature_save_path ]))
   mkdir([base_path svm_feature_save_path ]) ;
end
% Phonemes for classification
% ph_to_train={'sh','s','f','th'};
ph_to_train={'s','f','th'};

train_percent=0.75; % the rest of the features will be used for validation



for channel=26:number_of_channels
    f=fopen([base_path svm_feature_save_path 'Channel' num2str(channel)],'w');
    
    str_write='';
    for ph_index=1:length(ph_to_train) 
        
        feature_path=cell2mat([base_path, [ph_to_train(ph_index)],'/',htk_feature_path, 'Channel' num2str(channel) '.mfc']);
        
        X=read_mfcc(feature_path);
        
                for index=1:floor(train_percent*size(X,1))
%             for index=1:train_percent* 100
%                 for index=ceil(train_percent*size(X,1)):size(X,1)  % For
%                 validation

            	    fprintf(1,'\r%d/%d',index,floor(train_percent*size(X,1)));


                    str_write=num2str(ph_index);
                    for dim=1:size(X,2)
                        str_write=[ str_write ' ' num2str(dim) ':' num2str(X(index,dim))];
                    end

                    fprintf(f,str_write);
                    fprintf(f,'\n');

            end
        
        
    end
    
    fclose(f);
    
end
