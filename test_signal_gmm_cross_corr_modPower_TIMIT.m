function [prob]=test_signal_gmm_cross_corr_modPower_TIMIT(signal,fs,no_of_channel,gmm_path,LPC_coeff)
% get the probability values for cross_correlation using LPC method

%     gmm_path='/media/885C28DA5C28C532/Dropbox/code/unvoicedCasa/TIMIT/moments/gmm/';

%     gmm_path='/media/885C28DA5C28C532/Dropbox/code/unvoicedCasa/TIMIT/30Channel/sh/gmm_moments/';

    
     [m1 m2 m3 m4 cross_band modPower] =getModStatistics(signal,fs,no_of_channel,20);
    [peaks,valleys]=lpc_based_features(cross_band,LPC_coeff);
    f1=[peaks valleys];
    scaling_factor=1e8;
    f2=scaling_factor*modPower;
    
    for channel=1:no_of_channel
        load ([gmm_path 'Channel' num2str(channel)])
        
        % first get the features for cross_correlation followed by features
        % from mod power
        feature=[f1(channel,:) f2(channel,:)];
        
        feature_norm=(feature-f_mean )./f_std;
        prob(channel)=pdf(model,feature_norm);
    end
    
    
