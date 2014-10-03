function [prob]=test_signal_NN_MCM_TIMIT(signal,fs,no_of_channel,nn_path,LPC_coeff_peak,LPC_coeff_valley,mod_bands,mod_scaling_factor,frange)
% MCM stands for moments, cross corr and modulation power
% get the probability values for cross_correlation using LPC method

%     gmm_path='/media/885C28DA5C28C532/Dropbox/code/unvoicedCasa/TIMIT/moments/gmm/';

%     gmm_path='/media/885C28DA5C28C532/Dropbox/code/unvoicedCasa/TIMIT/30Channel/sh/gmm_moments/';

    
    

%      [m1 m2 m3 m4 cross_band modPower] =getModStatistics(signal,fs,no_of_channel,20);
     
    [m1 m2 m3 m4 cross_band modPower]=getModStatistics(signal,fs,no_of_channel,mod_bands,frange);
     
    
    [peaks,valleys]=lpc_based_features(cross_band,LPC_coeff_peak,LPC_coeff_valley);
    f1=[peaks valleys];
    f2=mod_scaling_factor*modPower;
    
    prob=zeros(no_of_channel,1);
    
%     fprintf('\nAlert- Not dividing by sigma\n');
    
    for channel=1:no_of_channel
        load ([nn_path 'Channel' num2str(channel)])
        
        % first get the features for cross_correlation followed by features
        % from mod power
        feature=[m1(channel,:) m2(channel,:) m3(channel,:) m4(channel,:) f1(channel,:) f2(channel,:)];
        
        feature_norm=(feature-f_mean )./f_std;
%         feature_norm=(feature-f_mean );
                
        prob(channel)=useNNPredictEx4(feature_norm,Theta1,Theta2);
    end
    
    
    