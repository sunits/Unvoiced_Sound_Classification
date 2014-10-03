function [distance]=hist_dist_from_timit(read_path, ...         % Database Path
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
                             signal_scaling_factor, ...
                             histogram_base_path)


%% About frames
% Rectangular wndows are taken- Hamming-'ing' of the window is done in
% while obtaining statistics.


%% Get a file names
all_phn=dir([read_path, '*_unvoice.phn']);

no_of_files=length(all_phn);

counter=0;
boundary_counter=0;

distance=[];
origHistPath = [histogram_base_path  ph_to_test  '/histogram/100Hist.mat'];

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
           
            temp=filterUsingGammatone(signal,no_of_channel,fRange,fs);
            h=hilbert(temp');
            h=abs(h').^(0.3);
            
            distance=[distance getKLD(h,origHistPath)];
            
            
        else
             continue;
        end
    end
    fclose(fid);   
end

if(counter<1)
    return
end




end

function[distanceArray]= getKLD(h,origHistPath)

no_of_chans=size(h,1);
distanceArray=zeros(size(h,1),1);

%load a variable called final_hist
load(origHistPath);

for index=1:no_of_chans
    N=hist(h(index,:)',final_hist(index).X);   
    N=N/sum(N);
    distanceArray(index)=kld(N,final_hist(index).N/sum(final_hist(index).N));
end


end


function[distance]= kld(p,q)

% TO make sure log of zeror and division by zeros does not happen
p=p+1e-9;
q=q+1e-9;

distance=sum(p.*log(p./q));
distance=distance+sum(q.*log(q./p));

end