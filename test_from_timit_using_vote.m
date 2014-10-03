function [truth,predicted,vote_predicted,boundary]=test_from_timit_using_vote(read_path, ...
                                                                        no_of_channel, ...    % Number of Channels 
                                                                        phonemes, ... % Phonemes to classify
                                                                        nn_path, ... % Where have you kept those models?
                                                                        prob_model_path, ... % Where are the prob models?
                                                                        LPC_peaks, ... % How many co-eff for LPC peaks
                                                                        LPC_valleys, ... % How many for valleys
                                                                        mod_bands, ... % Number of channels for modulation bands
                                                                        mod_scaling_factor, ... % How much do I scale the modulation power
                                                                        frange, ... % Frequency range for gammatone filterbank
                                                                        frame_length, ... % In milliseconds,
                                                                        frame_shift)% In milliseconds,
                                                                        




%% Get a file names
all_phn=dir([read_path, '*_unvoice.phn']);

%% Inits

no_of_files=length(all_phn);

counter=0;
boundary_counter=0;


%% Start
for index=1:no_of_files
%     figure;
    file_name=all_phn(index).name;
    fid=fopen(strcat(read_path,file_name),'r');
    wav_file=strrep(file_name,'_unvoice.phn','.wav');
    bare_file=strrep(file_name,'_unvoice.phn','');
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
            
            
            temp_truth=strcmp(phonemes,ph);
            [junk tPos]=max(temp_truth);
            
            boundary_counter=boundary_counter+1;
            
            boundary(boundary_counter).b=no_frames;
                
            for frame_index=1:no_frames
            
                counter=counter+1;    

            %% For Neural Network            
                channel_decision= test_signal_GMM_MCM_TIMIT(signal((frame_index-1)*shift+1:(frame_index-1)*shift+frame_size), ...
                                                                    fs,no_of_channel,nn_path,LPC_peaks,LPC_valleys,mod_bands,mod_scaling_factor,frange);                

                feature(counter).ph=[ph '-'];
                [count classes]=hist(channel_decision,unique(channel_decision));
                [val max_at]=max(count);            
            

                feature(counter).predicted=(classes(max_at));                
                feature(counter).truth=tPos;

                feature(counter).vote_predicted=voting(channel_decision,length(phonemes),prob_model_path);
            
            end
        

    end
    fclose(fid);
end
vote_predicted= [feature(:).vote_predicted];
predicted= [feature(:).predicted];
truth= [feature(:).truth];
boundary=[boundary(:).b];
 fprintf('\n Accuracy using votes %f -- plain prediction %f \n',check_accuracy( [feature(:).truth], [feature(:).vote_predicted]),check_accuracy([feature(:).truth], [feature(:).predicted]))
end
