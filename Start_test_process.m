function [truth,p,vp,boundary]= Start_test_process( main_dir , ... % Where is the database
                                result_path, ... % Where should the result be stored?
                                no_of_channel, ...
                                phonemes, ... % Phonemes to classify
                                nn_path, ... % Where have you kept those models?
                                prob_model_path, ... % Where are the prob models?
                                LPC_peaks, ... % How many co-eff for LPC peaks
                                LPC_valleys, ... % How many for valleys
                                mod_bands, ... % Number of channels for modulation bands
                                mod_scaling_factor, ... % How much do I scale the modulation power
                                frange, ... %Range for gammatone filterbank   
                                gender, ... % Any particular gender
                                frame_length, ... % In milliseconds,
                                frame_shift)    % In milliseconds
                                

all_folders=dir(main_dir);

counter=0;

% mkdir([data_path [ph_to_train{all_ph}] '/data/modPower_window_mag_corrected/'])
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
                    
                     
                        if(all_sub_folders(sub_index).name(1)==gender | gender=='')
                    
                    %%
                           fprintf('%s-',all_sub_folders(sub_index).name);
                           counter=counter+1;                   

                           [truth(counter).val predicted(counter).val vote_predicted(counter).val boundary(counter).val] = test_from_timit_using_vote( ...
                                                                            [main_dir,  all_folders(index).name,'/', all_sub_folders(sub_index).name,'/'],...
                                                                            no_of_channel, ...
                                                                            phonemes, ... % Phonemes to classify
                                                                            nn_path, ... % Where have you kept those models?
                                                                            prob_model_path, ... % Where are the prob models?
                                                                            LPC_peaks, ... % How many co-eff for LPC peaks
                                                                            LPC_valleys, ... % How many for valleys
                                                                            mod_bands, ... % Number of channels for modulation bands
                                                                            mod_scaling_factor, ... % How much do I scale the modulation power
                                                                            frange, ...
                                                                            frame_length, ... % In milliseconds,
                                                                            frame_shift);
                        end
                end
            end
            fprintf('\n');

        end
    end
% end

    
truth=[truth(:).val];
p=[predicted(:).val];
vp=[vote_predicted(:).val];
boundary=[boundary(:).val];
fprintf('\nUse ANN and counting - accuracy: %f\n',check_accuracy(truth,p));
fprintf('\nUse voting  - accuracy: %f\n',check_accuracy(truth,vp));
save(result_path,'truth','p','vp','boundary');