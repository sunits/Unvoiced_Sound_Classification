clc; clear all;
% main_dir='/media/DAA2C0D7A2C0B8F1/Database/TIMIT/test/';
% data_path='/home/dsplabserver/Dropbox/Sunit/to_sunit/sunit/unvoicedCasa/TIMIT/30Channel/20msec/Testing/';
main_dir='/media/885C28DA5C28C532/data/TIMIT/timit/train/';
data_path='/media/885C28DA5C28C532/Dropbox/to_sunit/sunit/unvoicedCasa/TIMIT/30Channel/mfcc/';
write_path='./';
gmm_path='';
ph_to_train={'f'};
% ph_to_train={'th'};
% other_lib_path='/home/dsplabserver/Dropbox/Sunit/to_sunit/sunit/unvoicedCasa/';
other_lib_path='/media/885C28DA5C28C532/Dropbox/to_sunit/sunit/unvoicedCasa/';
no_of_channel=32;
modBand=20;
frame_length=0.010; %Each phoneme will be divided into frames for feature extraction
frame_shift=0.005; % Shift in milli seconds
feature_store_at='/sig_scale_fb_norm/'; % For each phoneme



addpath /media/885C28DA5C28C532/Dropbox/code/toolkit

frange=[50, 8000];
modFRange=[22 100];
channel_number=13;
addpath(other_lib_path);

plotEnvExtractFeature(ph_to_train, ...       % Which phone should I train for now?
                            data_path, ...          
                            feature_store_at, ...   % WHere do I store the feature?
                            main_dir, ...     % path to the training part of the database
                            no_of_channel, ...      % Number of filters while doing the first step decompositions
                            modBand, ...            % Number of filters while computing the modulation bands    
                            frame_length, ...       % What should the duration of each frame be (try 10ms)?
                            frame_shift, ...
                            frange, ...
                            modFRange, ...
                            channel_number);

                        
