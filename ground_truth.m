% Code to 
clc; clear all; close all;
%% config

base_path='/home/dsplabserver/Dropbox/Sunit/to_sunit/sunit/unvoicedCasa/TIMIT/30Channel/TestFeatures/';

htk_feature_path='htk_format/';
number_of_channels=1;

% Phonemes for classification
% ph_to_train={'sh','s','f','th'};
 ph_to_train={'s','f','th'};


truth=[];

    
    for ph_index=1:length(ph_to_train) 
        feature_path=cell2mat([base_path, [ph_to_train(ph_index)],'/',htk_feature_path, 'Channel1.mfc']);
        
        X=read_mfcc(feature_path);
       truth=[truth; ph_index*ones(size(X,1),1)];
       
    end
    
    
