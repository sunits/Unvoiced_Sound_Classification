function [prob]=test_signal_gmm_modPower_TIMIT(signal,fs,no_of_channel,gmm_path)
% get the probability values for cross_correlation using LPC method

%     gmm_path='/media/885C28DA5C28C532/Dropbox/code/unvoicedCasa/TIMIT/moments/gmm/';

%     gmm_path='/media/885C28DA5C28C532/Dropbox/code/unvoicedCasa/TIMIT/30Channel/sh/gmm_moments/';

    
     [m1 m2 m3 m4 cross_band modPower] =getModStatistics(signal,fs,no_of_channel,20);
%     [peaks,valleys]=lpc_based_features(cross_corr,LPC_coeff);
%     f=[peaks valleys];
scaling_factor=1e8;
f=scaling_factor*modPower;
    
    for channel=1:no_of_channel
        load ([gmm_path 'Channel' num2str(channel)])
        
        feature=f(channel,:);
        feature_norm=(feature-f_mean )./f_std;
        prob(channel)=pdf(model,feature_norm);
    end
    
    
