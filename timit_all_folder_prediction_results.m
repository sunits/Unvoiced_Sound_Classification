clc; clear all;
main_dir='~/sunit/TIMIT/timit/test/';
data_path='~/sunit/unvoicedCasa/TIMIT/30Channel/x_mu/';
all_folders=dir(main_dir);
write_path='./';
gmm_path='';
counter=0;
% ph_to_train={'sh','s','f','th','jh','ch','h','p','t','k'};
ph_to_train={'sh','s','f','th'};
% for all_ph=1:length(ph_to_train)
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
                    
                     %% FOR MALE PART ONLY
                        if(all_sub_folders(sub_index).name(1)=='f')
                            continue;
                        end
                        
                    
                    %%
                    

                   fprintf('%s-',all_sub_folders(sub_index).name);
                   counter=counter+1;
                   [truth(counter).val predicted(counter).val vote_predicted(counter).val] = test_from_timit_using_vote ...
                                ([main_dir,  all_folders(index).name,'/', all_sub_folders(sub_index).name,'/'],...
                                data_path, ...
                                [all_folders(index).name ,'_',all_sub_folders(sub_index).name], ...
                                data_path);
                end
            end
            fprintf('\n');

        end
    end
% end

    
truth=[truth(:).val];
p=[predicted(:).val];
vp=[vote_predicted(:).val];
fprintf('\nUse ANN and counting - accuracy: %f\n',check_accuracy(truth,p));
fprintf('\nUse voting  - accuracy: %f\n',check_accuracy(truth,vp));
