function [enough counter]=plot_env_from_timit(read_path, ...         % Database Path
                             data_path, ...         % First name of the path where features must be saved
                             sub_folder, ...        % Where exactly should I save?        
                             ph_to_test, ...        % Which Phoneme Should I train on ?
                             no_of_channel, ...     % Number of Channels (first set decomposition)
                             modBand, ...           % Number of Modulation Bands       
                             data_save_path, ...    % Path to save the data at
                             frame_length, ...      % In milli seconds
                             frame_shift, ...       % Frame Shift
                             fRange, ...            % Frquency range
                             modFRange, ...
                             channel_number, ...        % Channel Number
                             counter)


%% Temp fixes

            global  m1
            global  m2
            global  m3
            global  m4


%%

            
%% About frames
% Rectangular wndows are taken- Hamming-'ing' of the window is done in
% while obtaining statistics.


%% Get a file names
all_phn=dir([read_path, '*_unvoice.phn']);

no_of_files=length(all_phn);


boundary_counter=0;
enough=false;

%% Start
for index=1:no_of_files
%     figure;
    file_name=all_phn(index).name;
    fid=fopen(strcat(read_path,file_name),'r');
    wav_file=strrep(file_name,'_unvoice.phn','.wav');
    bare_file=strrep(file_name,'_unvoice.phn','');
    [data fs]=wavread([read_path wav_file]);

    data=data*2^15;
    
   
    while(1)
        line=fgetl(fid);        
        if(~ischar(line))
            break;
        end
        str_split=strread(line,'%s','delimiter',' ');
        start_time=str2double(cell2mat(str_split(1)));
        end_time=str2double(cell2mat(str_split(2)));
        ph=cell2mat(str_split(3));
        
        if(~strcmp(ph,ph_to_test))
           continue; 
        end
        
%         if(input([ph ':']))
            if(counter<300)
                hold on;
                
                fprintf('%s-',ph);
                counter=counter+1;
                signal=data(start_time:end_time);                
%                 plot_env_for_channel(signal,no_of_channel,fs,fRange,channel_number);                
%                 plot_env_corr(signal,no_of_channel,fs,fRange)
%                 plot_env_spectrogram(signal,no_of_channel,fs,fRange)
                

%% Computing the moments
           
                [m1(:,counter),m2(:,counter),m3(:,counter),m4(:,counter)]=plot_env_moments(signal,no_of_channel,fs,fRange,1);
                
                
                title(ph);
%                 figure;
                
            else
%                 scatter(m1(30,:),m3(30,:),'g');
                plot(mean(m4,2),'y');
                enough=true;
                return;
            end
            
       
%         end



    

    end
    fclose(fid);   
end

if(counter<1)
    return
end

end
