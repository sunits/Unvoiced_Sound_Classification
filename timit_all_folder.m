clc; clear all;
main_dir='/home/dsplws/sunit/TIMIT/timit/test/';
data_path='/home/dsplws/sunit/unvoicedCasa/TIMIT/30Channel/';
all_folders=dir(main_dir);
write_path='./';
gmm_path='';

ph_to_train={'sh','s','f','th','jh','ch','h','p','t','k'};
for all_ph=1:length(ph_to_train)
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

                   fprintf('%s-',all_sub_folders(sub_index).name);
%                      train_from_timit([main_dir,  all_folders(index).name,'/', all_sub_folders(sub_index).name,'/'],data_path, [all_folders(index).name ,'_',all_sub_folders(sub_index).name],[ph_to_train{all_ph}]);
                   test_from_timit_using_vote([main_dir,  all_folders(index).name,'/', all_sub_folders(sub_index).name,'/'],data_path, [all_folders(index).name ,'_',all_sub_folders(sub_index).name],[ph_to_train{all_ph}],data_path);
                end
            end
            fprintf('\n');
    %         train_from_timit(all_folders(index).name,write_path,all_folders(index));        
        end
    end
end

    
