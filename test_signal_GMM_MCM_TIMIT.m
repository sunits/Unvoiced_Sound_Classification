function [prob]=test_signal_GMM_MCM_TIMIT(signal,fs,no_of_channel,gmm_path,LPC_coeff_peak,LPC_coeff_valley,mod_bands,mod_scaling_factor,frange)
% MCM stands for moments, cross corr and modulation power
% get the probability values for cross_correlation using LPC method

     
    [m1 m2 m3 m4 cross_band modPower]=getModStatistics(signal,fs,no_of_channel,mod_bands,frange);
     
    
    [peaks,valleys]=lpc_based_features(cross_band,LPC_coeff_peak,LPC_coeff_valley);
    f1=[peaks valleys];
    f2=mod_scaling_factor*modPower;
    
    prob=zeros(no_of_channel,1);
    
%     fprintf('\nAlert- Not dividing by sigma\n');
    
    for channel=1:no_of_channel
        load ([gmm_path 'Channel' num2str(channel)])
        % The following variables will be loaded into the memory:
            % GMM- A structure containing models for all classes
            % f_mean
            % f_std
        no_of_classes=length(GMM); 
        % first get the features for cross_correlation followed by features
        % from mod power
        feature=[m1(channel,:) m2(channel,:) m3(channel,:) m4(channel,:) f1(channel,:) f2(channel,:)];
        
%         prob_class=zeros(4,1);
        compare_value=-Inf;
        prob(channel)=2; %By default the 2 class is assigned
        feature_norm=(feature-f_mean )./f_std;
%         feature_norm=(feature-f_mean );
        for class_index=1:no_of_classes            
            temp_prob=pdf(GMM{class_index}.model,feature_norm);
            if(temp_prob>compare_value)
                prob(channel)=class_index;
                compare_value=temp_prob;
            end                       
        end
        
    end
    
    
    