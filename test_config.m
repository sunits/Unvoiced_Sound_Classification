clc; clear all;



result_path='~/Dropbox/Sunit/to_sunit/sunit/unvoicedCasa/TIMIT/30Channel/gmm_MMC_s_sh_f_th_LPC_CEP_10_15/result/final.mat';
nn_folder='gmm_MMC_s_sh_f_th_LPC_CEP_10_15/';
data_path='/media/DAA2C0D7A2C0B8F1/Database/TIMIT/test/';
base_path='~/Dropbox/Sunit/to_sunit/sunit/unvoicedCasa/TIMIT/30Channel/';
prob_model_path= '~/Dropbox/Sunit/to_sunit/sunit/unvoicedCasa/TIMIT/30Channel/gmm_MMC_s_sh_f_th_LPC_CEP_10_15/prob_model/';

nn_full_path=[base_path nn_folder];
phonemes={'sh','s','f','th'};
 
other_libs='~/Dropbox/Sunit/to_sunit/sunit/unvoicedCasa';
nn_code_path='~/Dropbox/Sunit/to_sunit/sunit/ex4/';

addpath(nn_code_path);
addpath(other_libs);

ph_to_train={'sh','s','f','th'};

% move all the inits to the config file build_prob_model_config


gender='m'; % Do for all genders


LPC_peak_len=10;
LPC_valley_len=15;
no_of_channel=32;
no_of_modulation_bands=20;
mod_scaling_factor=1e8;
frame_length=0.01;
frame_shift=0.005;
frange=[50 8000];

[truth,p,vp,boundary]= Start_test_process( data_path , ... % Where is the database
                    result_path, ... % Where should the result be stored?
                    no_of_channel, ...
                    phonemes, ... % Phonemes to classify
                    nn_full_path, ... % Where have you kept those models?
                    prob_model_path, ... % Where are the prob models?
                    LPC_peak_len, ... % How many co-eff for LPC peaks
                    LPC_valley_len, ... % How many for valleys
                    no_of_modulation_bands, ... % Number of channels for modulation bands
                    mod_scaling_factor, ... % How much do I scale the modulation power
                    frange, ... %Range for gammatone filterbank   
                    gender, ... % Any particular gender
                    frame_length, ...
                    frame_shift);
