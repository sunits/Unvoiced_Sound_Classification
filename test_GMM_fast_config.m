close all; clear all;clc;

% Train for all/Male/Female
gender='m';

%Base path
base_path='/home/dsplabserver/Dropbox/Sunit/to_sunit/sunit/unvoicedCasa/TIMIT/30Channel/TestFeatures/';



%Path where raw features are stored (relative to base path)

feature_path='/LPCSpec_frame/';
model_name='DCT_22';

% 
% prob_model_path=['/media/DAA2C0D7A2C0B8F1/sunit/features/full_phoneme/training/' model_name '/prob_model/final.mat'];
% gmm_path=['/media/DAA2C0D7A2C0B8F1/sunit/features/full_phoneme/training/' model_name '/'];
% result_save_path=['/media/DAA2C0D7A2C0B8F1/sunit/features/full_phoneme/training/' model_name '/prob_model/'];


model_base='/home/dsplabserver/Dropbox/Sunit/to_sunit/sunit/unvoicedCasa/TIMIT/30Channel/TrainFeatures/models/10msec/';
prob_model_path=[model_base model_name '/prob_model/final.mat'];
gmm_path=[ model_base  model_name '/'];
result_save_path=[model_base  model_name '/prob_model/'];

% Number of Gammatone filters in the filter bank
number_of_channels=32;

% Phonemes for classification
  ph_to_train={'sh','s','f','th'};
%ph_to_train={'sh','s','f','th','p','k','ch','t'};

phonemes_to_consider=[1 2 3 4];

mkdir(result_save_path);

lpc_length_peak=2;
lpc_length_valley=2;
mod_filter_size_len=20;
num_of_moments=4;

scaling_factor=1e8;
label=[];

counter=0;
 channels_to_consider=[ ones(1,0) zeros(1,16) ones(1,16)];
%channels_to_consider= [ 1    1     0     0     0     0     0     0     0     0     0     0     0     0     0     0     1     1     0     1     1     1   1     1     0     0     1     1     1     1     1     1];
% channels_to_consider=[ 0     0     1     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     1     1     1     1     1  1     0     0     1     1     1     0     0     0];
    



%MMC stands for moments, mod power and cross correlation
% test_GMM_moment_fast_full_ph
% test_GMM_MM_fast_full_ph
% test_GMM_fast_no_LPC_full_ph
% test_GMM_fast_ful_ph
%test_GMM_fast_no_LPC_full_ph
%  test_GMM_moment_channel_sel
%  test_GMM_fast_ful_ph
% test_GMM_moment_channel_sel
%test_GMM_moment_channel_find_best_channels
% test_GMM_fast
% test_GMM_fast_MC_no_LPC
% test_GMM_MC_fast




test_GMM_MC_DCT_fast(base_path, ... %
					ph_to_train, ... % Phonemes to Train
					feature_path, ... % Path where features are stored inside the phoneme directory
					gender, ... %Male('m'), Female('f'), All('a')
					gmm_path, ... % Neural Network model save path
					number_of_channels, ... % Number of channels(for filterbank)
					mod_filter_size_len, ...
					scaling_factor, ... % Number of modulation filters (modulation filterbank)
                    lpc_length_peak, ...  % Number of LPC coefficients to capture Peaks
                    lpc_length_valley, ... % Number of LPC coefficients to capture valleys
                    prob_model_path, ...   % Where do I find your dumb model?
                    result_save_path, ...
		num_of_moments, ...   
        channels_to_consider, ...
        phonemes_to_consider)
    
    
