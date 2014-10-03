function []=build_gmm_from_timit(data_path,gmm_path,ch_data_path)

% Function builds GMM from a set of cross_corr matrices

all_cc=dir(strcat(data_path,'*.mat'));
number_of_channels=30;
fprintf('-----------------------------------------------------\n');
fprintf('You are creating feature of dimension %d and %d of them !\n',number_of_channels,length(all_cc));

 scale_by=1;

%% Now train the GMM
for channel=1:number_of_channels
    fprintf('Started for channel %d \n',channel);
    ch_response=zeros(length(all_cc),number_of_channels);
    
    for tf_index=1:length(all_cc)
        fprintf('-%d.%d-',channel,tf_index);
       load( strcat(data_path,all_cc(tf_index).name));       
%        cross_band_temp=scale_by*cross_band(channel,:)/norm((cross_band(channel,:)),2);
       [peak_coeff valley_coeff]=lpc_based_features(cross_band(channel,:),15,15);
%        cross_band(channel,:)=cross_band(channel,:)-mean(cross_band(channel,:));
       
       ch_response(tf_index,:)=[reshape(peak_coeff,length(peak_coeff),1) ;reshape(valley_coeff,length(valley_coeff),1) ];
%        imagesc(cross_band);
%        pause(0.3);
    end
%     send_mail(strcat('Collected all data for channel number ',num2str(channel)),'');
%     imagesc(abs(ch_response));
%     pause(0.3)
    save(strcat(ch_data_path,'Channel',num2str(channel)),'ch_response');
    fprintf('Done for channel number %d\n',channel);
    model=gmdistribution.fit(ch_response,10,'CovType','diagonal');
    save(strcat(gmm_path,'Channel',num2str(channel)),'model');
    clear ch_response;
end

% send_mail('GMM training done','');

