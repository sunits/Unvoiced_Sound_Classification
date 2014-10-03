   


function [final_hist] = histTIMIT(ph_to_train, ...       % Which phone should I train for now?
                            base_path, ...          % Where can I store
                            feature_store_at, ...   % WHere exactly do I store the feature?
                            data_base_path, ...     % path to the training part of the database
                            no_of_channel, ...      % Number of filters while doing the first step decompositions
                            modBand, ...            % Number of filters while computing the modulation bands    
                            frame_length, ...       % What should the duration of each frame be (try 10ms)?
                            frame_shift, ...        % What should the shift duration be? (50% of the frame_length would be nice)
                            fRange, ...             % frequency Range to build filterbank
                            modFRange, ...
			    signal_scaling_factor)  % To boost the signal energy



%Very inefficient way of doing this- You are going through the whole
%database for each phoneme. Should be possible to do it in one shot

all_folders=dir(data_base_path);


for all_ph=1:length(ph_to_train)
    
    hist_counter=0;
    counter=0;
    mkdir([base_path [ph_to_train{all_ph}] feature_store_at]);
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
%                       train_from_timit
                        counter=counter+1;
                      env(counter).env=hist_from_timit([data_base_path,  all_folders(index).name,'/', all_sub_folders(sub_index).name,'/'], ...
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
                                        signal_scaling_factor);
                end
            end
            fprintf('\n');
        end
    end
    env=[env(:).env];
    
    
    figure;hold on;
    for balsdasd=1:no_of_channel
        [N,X]=hist(env(balsdasd,:)',100);
        
        hist_counter=hist_counter+1;
        final_hist(hist_counter).N=N;
        final_hist(hist_counter).X=X;
        
        
        plot(X,N/sum(N),'k');
        pause(0.1);
    end
    hold off;
    title([ph_to_train{all_ph}]);

    save([base_path [ph_to_train{all_ph}] feature_store_at '100Hist.mat'],'final_hist');
    final_hist=[];
    

%     [N,X]=hist(env',100);
%     plot(X,N/sum(N),'k');
env=[];
end

    
