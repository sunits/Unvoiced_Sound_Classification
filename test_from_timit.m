function [return_value]=test_from_timit(read_path,data_path,sub_folder,ph_to_test,gmm_base_path)

%% Init
if(nargin<1)
    gmm_path='/media/885C28DA5C28C532/Dropbox/code/unvoicedCasa/TIMIT/cross_corr/gmm/';
    data_path='/media/885C28DA5C28C532/Dropbox/code/unvoicedCasa/TIMIT/cross_corr/data/';
    read_path='/media/885C28DA5C28C532/data/TIMIT/fcjf0/';
    sub_folder='';
end


% full path of the dir to write to
% if(~strcmp(sub_folder,''))
%     data_path=strcat(data_path,sub_folder,'/');
%     mkdir(data_path);
% end

addpath /media/885C28DA5C28C532/Dropbox/code/unvoicedCasa/

%% Get a file names
all_phn=dir([read_path, '*_unvoice.phn']);

%% Inits
no_of_channel=32;
no_of_files=length(all_phn);

counter=0;

% phonemes={'sh','s','f','th','jh','ch','p','t','k'};
phonemes={'sh','s','f','th','jh','ch','p','t','k'};

%% Start
for index=1:no_of_files
%     figure;
    file_name=all_phn(index).name;
    fid=fopen(strcat(read_path,file_name),'r');
    wav_file=strrep(file_name,'_unvoice.phn','.wav');
    bare_file=strrep(file_name,'_unvoice.phn','');
    [data fs]=wavread([read_path wav_file]);
    
    % Get indivitual phonemes 
    cc=hsv(12);
    
    while(1)
        line=fgetl(fid);        
        if(~ischar(line))
            break;
        end
        str_split=strread(line,'%s','delimiter',' ');
        start_time=str2double(cell2mat(str_split(1)));
        end_time=str2double(cell2mat(str_split(2)));
        ph=cell2mat(str_split(3));
%         fprintf('%s \n',(ph));

%         if(strcmp(ph,ph_to_test))

            counter=counter+1;

            signal=data(start_time:end_time);        
            for ph_index=1:length(phonemes)
%                 prob(ph_index,:,:)=test_signal_gmm_cross_corr_TIMIT(signal,fs,no_of_channel, cell2mat([gmm_base_path phonemes(ph_index) '/gmm_modPower/']),15);
%             prob(ph_index,:,:)=test_signal_gmm_modPower_TIMIT(signal,fs,no_of_channel, cell2mat([gmm_base_path phonemes(ph_index) '/gmm_modPower_scaled/']));
            prob(ph_index,:,:)=test_signal_gmm_cross_corr_modPower_TIMIT(signal,fs,no_of_channel, cell2mat([gmm_base_path phonemes(ph_index) '/gmm_modPower_scaled__cross_corr/']),15);
            end
            
            % set a low value of prob to elements which have zero
            prob(prob==0)=1e-200;
            
            plot(sum(log10(prob),3)); title(ph);
            set(gca, 'XTickLabel', phonemes);
            
            feature(counter).ph=[ph '-'];
            
            feature(counter).prob=sum(log10(prob));

%             plot(log10(prob));title(ph); pause(0.3);
%         end
        

    end
end
return_value= [feature(:).prob];

end
