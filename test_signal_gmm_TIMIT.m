function [prob]=test_signal_gmm_TIMIT(signal,fs,no_of_channel,gmm_path)

%     gmm_path='/media/885C28DA5C28C532/Dropbox/code/unvoicedCasa/TIMIT/moments/gmm/';

%     gmm_path='/media/885C28DA5C28C532/Dropbox/code/unvoicedCasa/TIMIT/30Channel/sh/gmm_moments/';

    
    [m1 m2 m3 m4 ]=getAllStatistics(signal,fs,no_of_channel);
    
    for channel=1:no_of_channel
        load ([gmm_path 'Channel' num2str(channel)])
        feature=[m1(channel) m2(channel) m3(channel) m4(channel)];
        feature_norm=(feature-f_mean )./f_std;
        prob(channel)=pdf(model,feature_norm);
    end
    
    
