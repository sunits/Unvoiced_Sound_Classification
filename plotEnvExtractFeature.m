% Author : Sunit Sivasankaran 
% % A function to extract the following features
%         a) First 4 Moments of each channels
%         b) Cross Correlation between each channels
%         c) Modulation power of modulation channels
        


function [] = plotEnvExtractFeature(ph_to_train, ...       % Which phone should I train for now?
                            base_path, ...          % Where can I store
                            feature_store_at, ...   % WHere exactly do I store the feature?
                            data_base_path, ...     % path to the training part of the database
                            no_of_channel, ...      % Number of filters while doing the first step decompositions
                            modBand, ...            % Number of filters while computing the modulation bands    
                            frame_length, ...       % What should the duration of each frame be (try 10ms)?
                            frame_shift, ...        % What should the shift duration be? (50% of the frame_length would be nice)
                            fRange, ...             % frequency Range to build filterbank
                            modFRange, ...
                            channel_number)  % To boost the signal energy



%Very inefficient way of doing this- You are going through the whole
%database for each phoneme. Should be possible to do it in one shot

all_folders=dir(data_base_path);

count=0;
for all_ph=1:length(ph_to_train)
 
    for index=1:length(all_folders)
        if(all_folders(index).isdir)
            if(strcmp(all_folders(index).name,'.') )
                continue;
            end
            if(strcmp(all_folders(index).name,'..') )
                continue;
            end

            fprintf('----%s----\n',all_folders(index).name);
            all_sub_folders=dir([data_base_path, all_folders(index).name,'/' ]);
            for sub_index=1:length(all_sub_folders)
                if(all_sub_folders(sub_index).isdir)
                      if(strcmp(all_sub_folders(sub_index).name,'.') )
                           continue;
                      end
                    if(strcmp(all_sub_folders(sub_index).name,'..') )
                        continue;
                    end

                   fprintf('%s-',all_sub_folders(sub_index).name);
                   
                   
                         
                         
%                       create_mfcc_for_TIMIT
                      [enough count]=plot_env_from_timit([data_base_path,  all_folders(index).name,'/', all_sub_folders(sub_index).name,'/'], ...
                                        base_path, ...
                                        [all_folders(index).name ,'_',all_sub_folders(sub_index).name], ...
                                        [ph_to_train{all_ph}], ...
                                        no_of_channel, ...
                                        modBand, ...
                                        feature_store_at, ...
                                        frame_length, ...
                                        frame_shift, ...
                                        fRange, ...
                                        modFRange, ...
                                        channel_number, ...
                                        count);
                                    
                        if(enough)
                            return;
                        end

                end
            end
            fprintf('\n');
        end
    end
end

    
