function []=train_from_timit(read_path, ...         % Database Path
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
			     signal_scaling_factor)


%% About frames
% Rectangular wndows are taken- Hamming-'ing' of the window is done in
% while obtaining statistics.


%% Get a file names
all_phn=dir([read_path, '*_unvoice.phn']);

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

    % scale the signal
    data=data*signal_scaling_factor;	    

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
        
        if(strcmp(ph,ph_to_test))
        
            signal=data(start_time:end_time);    
            signal_len=length(signal);
            no_frames=floor(signal_len/shift)-1;
            
            boundary_counter=boundary_counter+1;
            boundary(boundary_counter).b=no_frames;
        
            for frame_index=1:no_frames

                [m1 m2 m3 m4 m5 m6 cross_band modPower]=getModStatistics(signal((frame_index-1)*shift+1:(frame_index-1)*shift+frame_size), ...
                                                                        fs,no_of_channel,modBand,fRange,modFRange);
                                                                    
                counter=counter+1;

                feature(counter).m1=m1;
                feature(counter).m2=m2;
                feature(counter).m3=m3;
                feature(counter).m4=m4;
                feature(counter).m5=m5;
                feature(counter).m6=m6;
                feature(counter).cross_corr=cross_band;
                feature(counter).modPower=modPower;
            %   feature(counter).ph=[ph '-'];    
            end
            
        else
             continue;
        end
    end
    fclose(fid);   
end

if(counter<1)
    return
end

   m1=[feature(:).m1];
   m2=[feature(:).m2];
   m3=[feature(:).m3];
   m4=[feature(:).m4];
   m5=[feature(:).m5];
   m6=[feature(:).m6];
   cross_corr=[feature(:).cross_corr];
   modPower=[feature(:).modPower];
   boundary=[boundary(:).b];
%    all_phs=[feature(:).ph];
%    Remove the last '-'
%    all_phs=all_phs(1:end-1);
%    save(strcat(data_path,ph_to_test,data_save_path,sub_folder,'.mat'),'m1','m2','m3','m4','all_phs','cross_corr','modPower');
     save(strcat(data_path,ph_to_test,data_save_path,sub_folder,'.mat'),'m1','m2','m3','m4','m5','m6','cross_corr','modPower','boundary');
%    Use this to split the phones seperated by '-' regexp (all_phs, '-', 'split')
end
