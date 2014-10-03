function []=build_prob_model_for_channels_function( main_dir, ...       % Path to the training files
                                            ph_to_train, ...            % Phonemes which need to be trained                    
                                            gender, ...                 % Any specific gender you want to train on ('' for dont care)? Bloody sexist
                                            nn_folder, ...              % Where did you store those horrible models?
                                            no_of_channel, ...          % How many channels
                                            lpc_peaks, ...              % How many co-efficients to capture the peaks
                                            lpc_valley, ...             % How many to capture the valleys
                                            frame_length, ...           % I assume you are splitting the signal into frames? Whats the size?
                                            frame_shift, ...            % How much should I shift the frame each time
                                            prob_model_save_path, ...   % Where do I save your dumb model?
                                            mod_bands, ...              % Modulation bands
                                            mod_scaling_factor, ...     % scaling factor in Mod Bands
                                            frange)                     % frange 

    
all_folders=dir(main_dir);
counter=zeros(length(ph_to_train),1);

    for index=1:length(all_folders)
        if(all_folders(index).isdir)
            if(strcmp(all_folders(index).name,'.') )
                continue;
            end
            if(strcmp(all_folders(index).name,'..') )
                continue;
            end

            fprintf('----%s----\n',all_folders(index).name);
            all_sub_folders=dir([main_dir, all_folders(index).name,'/' ]);
            for sub_index=1:length(all_sub_folders)
                if(all_sub_folders(sub_index).isdir)
                      if(strcmp(all_sub_folders(sub_index).name,'.') )
                           continue;
                      end
                    if(strcmp(all_sub_folders(sub_index).name,'..') )
                        continue;
                    end
                    
                    %% Any gender specificity
                        if(all_sub_folders(sub_index).name(1)==gender | gender=='a')
                                                  
                    
                    %%
                           fprintf('%s-',all_sub_folders(sub_index).name);

                           [truth predicted]=build_prob_model_for_channels([main_dir,  all_folders(index).name,'/', all_sub_folders(sub_index).name,'/'], ...
                                                                            nn_folder, ...
                                                                            no_of_channel, ...
                                                                            ph_to_train, ...
                                                                            lpc_peaks, ...
                                                                            lpc_valley, ...
                                                                            frame_length, ...
                                                                            frame_shift, ...
                                                                            mod_bands, ...
                                                                            mod_scaling_factor, ...
                                                                            frange);                   



                           for no_of_phonemes=1:length(truth)
                               counter(truth(no_of_phonemes))=counter(truth(no_of_phonemes))+1;
                               ph_all(truth(no_of_phonemes)).predict(:,counter(truth(no_of_phonemes)))=predicted(:,no_of_phonemes);
                           end
                        else 
                            continue;
                        end 
                   
                end
            end
            fprintf('\n');
        end
    end




for save_index=1:length(ph_all)
    temp=[ph_all(save_index).predict];
    save([prob_model_save_path num2str(save_index)],'temp');    
end
