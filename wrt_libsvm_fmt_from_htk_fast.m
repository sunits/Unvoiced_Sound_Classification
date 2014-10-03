% Code to 
clc; clear all; close all;
%% config

base_path='/home/dsplabserver/Dropbox/Sunit/to_sunit/sunit/unvoicedCasa/TIMIT/30Channel/20msec/Training/';

htk_feature_path='htk_format/';
svm_feature_save_path='svm_format_sh_s_f_th/';
number_of_channels=32;
precision=5;

if(~exist([base_path svm_feature_save_path ]))
   mkdir([base_path svm_feature_save_path ]) ;
end
% Phonemes for classification
ph_to_train={'sh','s','f','th'};
% ph_to_train={'s','f','th'};

% train_percent=1; % the rest of the features will be used for validation





% for channel=1:32
for channel=4:32
    
    tic;
    f=fopen([base_path svm_feature_save_path 'Channel' num2str(channel)],'w');
    fprintf(1,'\r%d/%d  ',channel,number_of_channels);
    for ph_index=1:length(ph_to_train) 
        
        if(strcmp(cell2mat(ph_to_train(ph_index)),''))
            continue;
        end
        
        feature_path=cell2mat([base_path, [ph_to_train(ph_index)],'/',htk_feature_path, 'Channel' num2str(channel) '.mfc']);
        
        X=read_mfcc(feature_path);
        

% 	X=X(1:floor(train_percent*size(X,1)),:);
%     X=X(ceil(train_percent*size(X,1)):size(X,1),:);
    X1=X';
	lim1=repmat([':'],length(X(:)),1);
	space1=repmat([' '],length(X(:)),1);
	append_line=1:size(X,2);
	append1=repmat(append_line',size(X,1),1);
    clear X;
    X1=round(X1*(10^precision))/(10^precision);
    
	tempX=[space1 num2str(append1) lim1 num2str(X1(:))];   
    
    clear append1;
    clear lim1;
    clear space1;
    clear X1;
    
    finalX=mat2str(tempX);
    clear tempX;
	finalX=strrep(finalX,'''',' ');
    finalX=strrep(finalX,';',' ');
    finalX=strrep(finalX,'[',' ');  
    finalX=strrep(finalX,']',' ') ;
    fprintf(f,strrep(finalX,' 1:',['\n ' num2str(ph_index)  ' 1:']));
    
   
  
    clear finalX;
   
    
        
    end
    
    fclose(f);
    remove_first_new_line=['!tail -n +2 '  base_path svm_feature_save_path 'Channel' num2str(channel) ' > ' base_path svm_feature_save_path 'Channel' num2str(channel) '_refined'];
    eval(remove_first_new_line);
    toc
    
end
