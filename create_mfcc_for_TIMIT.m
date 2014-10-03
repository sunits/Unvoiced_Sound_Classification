function []= create_mfcc_for_TIMIT(read_path, ...         % Database Path
    data_path, ...         % First name of the path where features must be saved
    sub_folder, ...        % Where exactly should I save?
    ph_to_test, ...        % Which Phoneme Should I train on ?
    no_of_channel, ...     % Number of Channels (first set decomposition)
    modBand, ...           % Number of Modulation Bands
    data_save_path, ...    % Path to save the data at
    frame_length, ...      % In milli seconds
    frame_shift, ...       % Frame Shift
    fRange, ...            % Frquency range
    modFRange)


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
            
            
            create_mfc_str=['HCopy -C to_htk.config -s ' num2str(round(1e9*start_time/(fs*1e2))) ' -e ' num2str(round(1e9*end_time/(fs*1e2))) ' ' [read_path wav_file] ' to_htk.mfc'];
            system(create_mfc_str);
            
            feature=read_mfcc('to_htk.mfc');
            feature=feature';
            feature=feature(:,1:no_frames);
            

%             param = struct('fs',fs,'featype','mfcc0','winlen',20*fs/1000,'overlap',10*fs/1000,'preemcoef',0.97);
%             [feature,param]=fn_mfcc(signal,param);
%             
            boundary_counter=boundary_counter+1;
            boundary(boundary_counter).b=no_frames;
            counter=counter+1;
            features(counter).mfcc=feature;
            features(counter).ph=[ph '-'];       
        
        else
            continue;
        end
    end
    fclose(fid);    
end


if(counter<1)
    return
end

mfcc=[features(:).mfcc];
boundary=[boundary(:).b];
all_phs=[features(:).ph];
%    Remove the last '-'
%    all_phs=all_phs(1:end-1);
%    save(strcat(data_path,ph_to_test,data_save_path,sub_folder,'.mat'),'m1','m2','m3','m4','all_phs','cross_corr','modPower');
save(strcat(data_path,ph_to_test,data_save_path,sub_folder,'_mfcc.mat'),'mfcc','boundary','all_phs');
%    Use this to split the phones seperated by '-' regexp (all_phs, '-', 'split')
end
