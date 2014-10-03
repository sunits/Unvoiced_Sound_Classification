clc, clear all, close all;

% reading from mfcc files to test the GMM models

no_of_channels=32;

gmm_path=struct('path',{ ...
                        '/home/dsplabserver/Dropbox/Sunit/to_sunit/sunit/MATLAB_GMM_MODEL_ALL_TOGETHER/f/', ... 
                        '/home/dsplabserver/Dropbox/Sunit/to_sunit/sunit/MATLAB_GMM_MODEL_ALL_TOGETHER/th/'});

feature_path='/home/dsplabserver/Dropbox/Sunit/to_sunit/sunit/unvoicedCasa/TIMIT/30Channel/TrainFeatures/f/htk_format/';

no_of_gmm=length(gmm_path);

for i=1:no_of_channels
    fprintf(1,'\r%d/%d',i,no_of_channels);
    mfcc_file=[feature_path  'Channel' num2str(i) '.mfc'];
    [X] = read_mfcc(mfcc_file);
        
        for gmm_i=1:no_of_gmm
            
            load([gmm_path(gmm_i).path  'Channel',num2str(i)]);
            prob(:,gmm_i)=pdf(model,X);
            
        end
        
        
[junk class_prob(:,i)]=max(prob,[],2);
    
    
end

                        