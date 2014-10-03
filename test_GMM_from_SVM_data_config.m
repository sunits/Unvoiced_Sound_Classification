

close all; clear all;clc;


%Base path
base_path='/media/DAA2C0D7A2C0B8F1/sunit/features/10msec/testing/svm/scaled/';


prob_model_path='/media/DAA2C0D7A2C0B8F1/sunit/features/10msec/training/models/10msec/gmm_100_moments_male/prob_model/final.mat';
% Number of Gammatone filters in the filter bank
number_of_channels=30;


phonemes_to_consider=[1 2 3 4];

scaling_factor=1e8;
%MMC stands for moments, mod power and cross correlation
gmm_path='/media/DAA2C0D7A2C0B8F1/sunit/features/10msec/training/svm/scaled/models/gmm_100_moments/';

if ~exist(gmm_path,'dir')
    mkdir(gmm_path);
end





 test_GMM_from_SVM_data(number_of_channels, ...
				base_path, ...
				gmm_path, ...				
                prob_model_path, ...
                phonemes_to_consider)
