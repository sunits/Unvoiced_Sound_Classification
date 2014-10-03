    close all; clear all;clc;

% Train for all/Male/Female
gender='m';

%Base path
base_path='/home/dsplabserver/Dropbox/Sunit/to_sunit/sunit/unvoicedCasa/TIMIT/30Channel/TrainFeatures/';
%Path where raw features are stored (relative to base path)
feature_path='/LPCSpec_frame/';


prob_model_save_path='/home/dsplabserver/Dropbox/Sunit/to_sunit/sunit/MATLAB_GMM_MODEL_ALL_TOGETHER/prob_model/';

gmm_path=struct('path',{ ...                      
                        '/home/dsplabserver/Dropbox/Sunit/to_sunit/sunit/MATLAB_GMM_MODEL_ALL_TOGETHER/s/', ... 
                        '/home/dsplabserver/Dropbox/Sunit/to_sunit/sunit/MATLAB_GMM_MODEL_ALL_TOGETHER/f/', ... 
                        '/home/dsplabserver/Dropbox/Sunit/to_sunit/sunit/MATLAB_GMM_MODEL_ALL_TOGETHER/th/'});
                    
                    
% Number of Gammatone filters in the filter bank
number_of_channels=32;

% Phonemes for classification
%ph_to_train={'sh','s','f','th','jh','ch','p','t','k'};
ph_to_train={'s','f','th'};


lpc_length_peak=10;
lpc_length_valley=15;
mod_filter_size_len=20;
num_of_moments=4;

scaling_factor=1e8;
label=[];

counter=0;

%MMC stands for moments, mod power and cross correlation

mkdir(prob_model_save_path);


build_GMM_prob_model_local_means_fast(base_path, ... %
					ph_to_train, ... % Phonemes to Train
					feature_path, ... % Path where features are stored inside the phoneme directory
					gender, ... %Male('m'), Female('f'), All('')
					gmm_path, ... % Neural Network model save path
					number_of_channels, ... % Number of channels(for filterbank)
					mod_filter_size_len, ...
					scaling_factor, ... % Number of modulation filters (modulation filterbank)
                    lpc_length_peak, ...  % Number of LPC coefficients to capture Peaks
                    lpc_length_valley, ... % Number of LPC coefficients to capture valleys
                    prob_model_save_path)   % Where do I save your dumb model?


