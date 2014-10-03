clear all;clc;
nn_folder='nn_MMC_s_sh_f_th_LPC_CEP_10_15/';
data_path='/media/DAA2C0D7A2C0B8F1/Database/TIMIT/train/';
base_path='~/Dropbox/Sunit/to_sunit/sunit/unvoicedCasa/TIMIT/30Channel/';
prob_model_path='prob_model_male/';

prob_model_save_path= [base_path nn_folder prob_model_path];
nn_full_path=[base_path nn_folder];


mkdir(prob_model_save_path);


phonemes={'sh','s','f','th'};
 
other_libs='/home/dsplabserver/Dropbox/Sunit/to_sunit/sunit/unvoicedCasa/';
nn_code_path='/home/dsplabserver/Dropbox/Sunit/to_sunit/sunit/ex4/';

addpath(nn_code_path);
addpath(other_libs);

ph_to_train={'sh','s','f','th'};

% move all the inits to the config file build_prob_model_config


gender=''; % Do for all genders


LPC_peak_len=10;
LPC_valley_len=15;
no_of_channel=32;
no_of_modulation_bands=20;
mod_scaling_factor=1e8;
frame_length=0.01;
frame_shift=0.005;
frange=[50 8000];

build_prob_model_for_channels_function( data_path, ...       % Path to the training files
                                            ph_to_train, ...            % Phonemes which need to be trained                    
                                            gender, ...                 % Any specific gender you want to train on? Bloody sexist
                                            nn_full_path, ...              % Where did you store those horrible models?
                                            no_of_channel, ...          % How many channels
                                            LPC_peak_len , ...              % How many co-efficients to capture the peaks
                                            LPC_valley_len, ...             % How many to capture the valleys
                                            frame_length, ...           % I assume you are splitting the signal into frames? Whats the size?
                                            frame_shift, ...            % How much should I shift the frame each time
                                            prob_model_save_path, ...       % Where do I save your dumb model?
                                            no_of_modulation_bands, ...
                                            mod_scaling_factor, ...
                                            frange)
                                            
