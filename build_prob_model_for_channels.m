 function [truth predicted boundary]=build_prob_model_for_channels(read_path, ...                                                        
                                                        nn_model_path, ...              %Path where the NN models are stored                            
                                                        no_of_channel, ...              % Number of channels
                                                        phonemes, ...                   % List of Phomenes to build the  prob model on
                                                        lpc_peak, ...                   % LPC peak coefficients
                                                        lpc_valley, ...                 % LPC Valleys
                                                        frame_length, ...               % frame length in msec
                                                        frame_shift, ...                % Frame shift size
                                                        mod_bands, ...                  % Modulation bands
                                                        mod_scaling_factor, ...         % scaling factor in Mod Bands
                                                        frange)                         % Freq range for gammatone filterbank





%% Get a file names
all_phn=dir([read_path, '*_unvoice.phn']);

no_of_files=length(all_phn);
counter=0;
boundary=0;        
boundary_counter=0;

%% Start
for index=1:no_of_files
%     figure;
    file_name=all_phn(index).name;
    fid=fopen(strcat(read_path,file_name),'r');
    wav_file=strrep(file_name,'_unvoice.phn','.wav');
%     bare_file=strrep(file_name,'_unvoice.phn','');
    [data fs]=wavread([read_path wav_file]);
    
    frame_size=frame_length*fs;
    shift=frame_shift*fs;
    
    
    while(1)
        line=fgetl(fid);        
        if(~ischar(line))
            break;
        end
        str_split=strread(line,'%s','delimiter',' ');
        start_time=str2double(cell2mat(str_split(1)));
        end_time=str2double(cell2mat(str_split(2)));
        ph=cell2mat(str_split(3));

    %% For sh-s-f-th only
    %         If the phoneme is one of sh-s-f-th then proceed  - else continue
        if(sum(strcmp(phonemes,ph))<1)
            continue;
        end
            

        
            signal=data(start_time:end_time);    
            signal_len=length(signal);
            no_frames=floor(signal_len/shift)-1;
        
            
            
%%            For GMM
%             for ph_index=1:length(phonemes)
% %                 prob(ph_index,:,:)=test_signal_gmm_cross_corr_TIMIT(signal,fs,no_of_channel, cell2mat([nn_base_path phonemes(ph_index) '/gmm_modPower/']),15);
% %             prob(ph_index,:,:)=test_signal_gmm_modPower_TIMIT(signal,fs,no_of_channel, cell2mat([nn_base_path phonemes(ph_index) '/gmm_modPower_scaled/']));
%             prob(ph_index,:,:)=test_signal_gmm_cross_corr_modPower_TIMIT(signal,fs,no_of_channel, cell2mat([nn_base_path phonemes(ph_index) '/gmm_modPower_scaled__cross_corr/']),15);
%             end
            
            % set a low value of prob to elements which have zero
%             prob(prob==0)=1e-200;
            
%             plot(sum(log10(prob),3)); title(ph);
%             set(gca, 'XTickLabel', phonemes);
        

%%          For Neural Network
            
%             channel_decision=test_signal_NN_cross_corr_modPower_TIMIT(signal,fs,no_of_channel,nn_path,15);
        
        boundary_counter=boundary_counter+1;            
        boundary(boundary_counter).b=no_frames;
            
        for frame_index=1:no_frames

                    counter=counter+1;
                    %channel_decision=test_signal_NN_MCM_TIMIT(signal((frame_index-1)*shift+1:(frame_index-1)*shift+frame_size), ...
                     %                                               fs,no_of_channel,nn_model_path,lpc_peak,lpc_valley,mod_bands,mod_scaling_factor,frange);

                    channel_decision=test_signal_GMM_MCM_TIMIT(signal((frame_index-1)*shift+1:(frame_index-1)*shift+frame_size), ...
                                                                    fs,no_of_channel,nn_model_path,lpc_peak,lpc_valley,mod_bands,mod_scaling_factor,frange);

                    feature(counter).ph=[ph '-'];
                    feature(counter).predicted=(channel_decision);
                    temp_truth=strcmp(phonemes,ph);
                    [junk tPos]=max(temp_truth);
                    feature(counter).truth=tPos;
                    
        end
            

    end
    fclose(fid);
end
truth= [feature(:).truth];
predicted=[feature(:).predicted];
boundary=[boundary(:).b];
end
