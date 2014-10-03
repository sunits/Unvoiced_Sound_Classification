close all; clear all;clc;

% Train for all/Male/Female
gender='m';

%Base path
base_path='/home/dsplabserver/Dropbox/Sunit/to_sunit/sunit/unvoicedCasa/TIMIT/30Channel/TestFeatures/';
%Path where raw features are stored (relative to base path)
feature_path='/LPCSpec_frame/';

prob_model_path='~/Dropbox/Sunit/to_sunit/sunit/unvoicedCasa/TIMIT/30Channel/gmm_100_MMC_s_sh_f_th_LPC_CEP_10_15/prob_model/';
gmm_path='/home/dsplabserver/Dropbox/Sunit/to_sunit/sunit/unvoicedCasa/TIMIT/model/th/matlab_format_converted_128/';


% Number of Gammatone filters in the filter bank
number_of_channels=32;

% Phonemes for classification
%ph_to_train={'sh','s','f','th','jh','ch','p','t','k'};
ph_to_train={'f'};

% mkdir(result_save_path);

lpc_length_peak=10;
lpc_length_valley=15;
mod_filter_size_len=20;
num_of_moments=4;

scaling_factor=1e8;
label=[];

counter=0;

%MMC stands for moments, mod power and cross correlation
test_GMM_MM_fast(base_path, ... %
					ph_to_train, ... % Phonemes to Train
					feature_path, ... % Path where features are stored inside the phoneme directory
					gender, ... %Male('m'), Female('f'), All('')
					gmm_path, ... % Neural Network model save path
					number_of_channels, ... % Number of channels(for filterbank)
					mod_filter_size_len, ...
					scaling_factor, ... % Number of modulation filters (modulation filterbank)
                    lpc_length_peak, ...  % Number of LPC coefficients to capture Peaks
                    lpc_length_valley, ... % Number of LPC coefficients to capture valleys
                    prob_model_path)


