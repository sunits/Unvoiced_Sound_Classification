function [h]=hist_from_timit(read_path, ...         % Database Path
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
h=[];
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
           
            temp=filterUsingGammatone(signal,no_of_channel,fRange,fs);
            hTemp=hilbert(temp');
            hTemp=abs(hTemp').^(0.3);
            counter=counter+1;
            all_h(counter).h=hTemp;
            
        else
             continue;
        end
    end
    fclose(fid);   
end

if(counter<1)
    return
end

% gmmCheck=whos('gmmObj');
% 
% 
% %% GMM parameters
% NumMix   = 2;               % Number of mixtures in GMM
% CovType  = 'diagonal';          % Type of covariance: 'full' or 'diagonal'
% varFloorPer=  0.1; % VarFloor percent of global variance will be used as Var floor
% shCov    = false;           % enable (true) or disable (false) sharing of covariance. 
%                             % enable it to force all mixture component to have same covariance
% MaxIter  = 200;             % Maximum number of iterations of EM algorithm
% 
% options = statset('MaxIter',MaxIter,'Display','final');


h=[all_h(:).h];
% h=h(no_of_channel,:);

% %% Build GMM
% if(strcmp(gmmCheck.class,'struct'))
%     gmmObj=gmdistribution.fit(h(no_of_channel,:)',NumMix,'Regularize',varFloorPer,'Options',options,'Start',gmmObj);
%     S.mu=gmmObj.mu;
%     S.Sigma=gmmObj.Sigma;
%     S.PComponents=gmmObj.PComponents;
% else
%     gmmObj=gmdistribution.fit(h(no_of_channel,:)',NumMix,'Regularize',varFloorPer,'Options',options);
%     S.mu=gmmObj.mu;
%     S.Sigma=gmmObj.Sigma;
%     S.PComponents=gmmObj.PComponents;
% end
    
%     plot(linspace(0,8,100),pdf(gmmObj,linspace(0,8,100)'))

% 
% [N,X]=hist(h',100);
% hold on
% plot(X,N(:,no_of_channel)/sum(N(:,no_of_channel)),'k');
% pause(0.01)

%    all_phs=[feature(:).ph];
%    Remove the last '-'
%    all_phs=all_phs(1:end-1);
%    save(strcat(data_path,ph_to_test,data_save_path,sub_folder,'.mat'),'m1','m2','m3','m4','all_phs','cross_corr','modPower');

%    Use this to split the phones seperated by '-' regexp (all_phs, '-', 'split')
end
