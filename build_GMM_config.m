
close all; clear all;clc;

% Train for all/Male/Female
gender='a'; %/m/f/a - for male/female/all

%Base path
base_path='/home/dsplabserver/Dropbox/Sunit/to_sunit/sunit/unvoicedCasa/TIMIT/30Channel/TrainFeatures/';
%Path where raw features are stored (relative to base path)
feature_path='/LPCSpec_frame/';
% Number of Gammatone filters in the filter bank
number_of_channels=32;

% Phonemes for classification
ph_to_train={'sh','s','f','th'};


lpc_length_peak=2;
lpc_length_valley=2;
mod_filter_size_len=20;
num_of_moments=4;

scaling_factor=1e8;
%MMC stands for moments, mod power and cross correlation
gmm_path=[base_path,'models/10msec/DCT_22/'];

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


% (base_path, ... %
% build_GMM_for_MM_function
% build_GMM_for_MC_function 
% build_GMM_for_MCM_function
% build_GMM_for_MCM_no_LPC_function
% 
build_GMM_for_MC_DCT_function(base_path, ... %
   			ph_to_train, ... % Phonemes to Train
   			feature_path, ... % Path where features are stored inside the phoneme direct
   			gender, ... %Male('m'), Female('f'), All('')
   			gmm_path, ... % Neural Network save Path
   			number_of_channels, ... % Number of channels(for filterbank)
   			mod_filter_size_len, ... % Number of modulation filters (modulation filterbank)
	                scaling_factor, ... % Number of modulation filters (modulation filterbank)
       	        lpc_length_peak, ...  % Number of LPC coefficients to capture Peaks
               	lpc_length_valley, ... % Number of LPC coefficients to capture valleys
	                VarFloor, ...
       	        options, ...
               	NumMix, ...
	                CovType)

 
%  
%  build_GMM_for_moments_function(base_path, ... %
%      			ph_to_train, ... % Phonemes to Train
%      			feature_path, ... % Path where features are stored inside the phoneme direct
%      			gender, ... %Male('m'), Female('f'), All('')
%      			gmm_path, ... % Neural Network save Path
%      			number_of_channels, ... % Number of channels(for filterbank)
%      			mod_filter_size_len, ... % Number of modulation filters (modulation filterbank)
%  	                scaling_factor, ... % Number of modulation filters (modulation filterbank)
%          	        lpc_length_peak, ...  % Number of LPC coefficients to capture Peaks
%                  	lpc_length_valley, ... % Number of LPC coefficients to capture valleys
%  	                VarFloor, ...
%          	        options, ...
%                  	NumMix, ...
%  	                CovType, ...
%                      num_of_moments)
