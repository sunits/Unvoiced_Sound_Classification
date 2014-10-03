function [prob]=test_signal_gmm_cross_corr_TIMIT(signal,fs,no_of_channel,gmm_path,LPC_coeff)
% get the probability values for cross_correlation using LPC method

%     gmm_path='/media/885C28DA5C28C532/Dropbox/code/unvoicedCasa/TIMIT/moments/gmm/';

%     gmm_path='/media/885C28DA5C28C532/Dropbox/code/unvoicedCasa/TIMIT/30Channel/sh/gmm_moments/';

    
    [m1 m2 m3 m4 cross_corr]=getAllStatistics(signal,fs,no_of_channel);
    [peaks,valleys]=lpc_based_features(cross_corr,LPC_coeff);
    f=[peaks valleys];
    
    for channel=1:no_of_channel
        load ([gmm_path 'Channel' num2str(channel)])
        
        feature=f(channel,:);
        feature_norm=(feature-f_mean )./f_std;
        prob(channel)=pdf(model,feature_norm);
    end
    
    
