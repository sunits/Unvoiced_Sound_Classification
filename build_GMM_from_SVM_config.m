

close all; clear all;clc;


%Base path
base_path='/media/DAA2C0D7A2C0B8F1/sunit/features/10msec/training/svm/scaled/';

% Number of Gammatone filters in the filter bank
number_of_channels=30;


scaling_factor=1e8;
%MMC stands for moments, mod power and cross correlation
gmm_path=[base_path,'models/gmm_100_moments/'];

if ~exist(gmm_path,'dir')
    mkdir(gmm_path);
end


%% GMM parameters
NumMix   = 100;               % Number of mixtures in GMM
CovType  = 'diagonal';          % Type of covariance: 'full' or 'diagonal'
VarFloor =  0.1; % VarFloor percent of global variance will be used as Var floor
shCov    = false;           % enable (true) or disable (false) sharing of covariance. 
                            % enable it to force all mixture component to have same covariance
MaxIter  = 200;             % Maximum number of iterations of EM algorithm

options = statset('MaxIter',MaxIter,'Display','final');


 
 
build_GMM_for_SVM(base_path, ...
                            NumMix, ...
                            CovType, ...
                            VarFloor, ...
                            options, ...
                            gmm_path, ...
                            number_of_channels);