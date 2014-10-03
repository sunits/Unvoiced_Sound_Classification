close all; clear all;clc;

% Train for all/Male/Female
gender='m';

%Base path
% base_path='/home/dsplabserver/Dropbox/Sunit/to_sunit/sunit/unvoicedCasa/TIMIT/30Channel/TrainFeatures/';
base_path='/media/MOSER BAER/TrainFeatures/';

%Path where raw features are stored (relative to base path)
feature_path='/LPCSpec_frame/';

gmm_path=[base_path,'models/10msec/gmm_100_MC_30_30/'];
prob_model_save_path=[gmm_path 'prob_model/'];

% Number of Gammatone filters in the filter bank
number_of_channels=32;

% Phonemes for classification
ph_to_train={'sh','s','f','th'};
%ph_to_train={'sh','s','f','th','p','k','ch','t'};


lpc_length_peak=30;
lpc_length_valley=30;
mod_filter_size_len=20;
num_of_moments=4;

scaling_factor=1e8;
label=[];

counter=0;

%MMC stands for moments, mod power and cross correlation

mkdir(prob_model_save_path);

% build_GMM_moments_prob_model_fast
  
%  build_GMM_prob_model_fast
% build_GMM_prob_no_LPC_model_fast
% build_GMM_prob_model_fast
% build_GMM_moments_prob_model_fast
build_GMM_MC_prob_model_fast(base_path, ... %
					ph_to_train, ... % Phonemes to Train
					feature_path, ... % Path where features are stored inside the phoneme directory
					gender, ... %Male('m'), Female('f'), All('')
					gmm_path, ... % Neural Network model save path
					number_of_channels, ... % Number of channels(for filterbank)
					mod_filter_size_len, ...
					scaling_factor, ... % Number of modulation filters (modulation filterbank)
                    lpc_length_peak, ...  % Number of LPC coefficients to capture Peaks
                    lpc_length_valley, ... % Number of LPC coefficients to capture valleys
                    prob_model_save_path, ...   % Where do I save your dumb model?
			num_of_moments)


