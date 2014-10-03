% move all the inits to the config file build_prob_model_config
clear all; clc;
main_dir='/media/DAA2C0D7A2C0B8F1/Database/TIMIT/train/';
base_path='/home/dsplabserver/Dropbox/Sunit/to_sunit/sunit/unvoicedCasa/TIMIT/30Channel/';
all_folders=dir(main_dir);
write_path='./';
gmm_path='';
nn_folder='nn_MMC_s_sh_f_th_LPC_CEP_15_30/';
save_at='prob_model/'; % path where probability model mus be stored
% ph_to_train={'sh','s','f','th','jh','ch','h','p','t','k'};

ph_to_train={'sh','s','f','th'};

counter=zeros(length(ph_to_train),1);

% for all_ph=1:length(ph_to_train)

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
                    
%                     %% FOR MALE PART ONLY
%                         if(all_sub_folders(sub_index).name(1)=='f')
%                             continue;
%                         end
%                         
%                     
%                     %%
                  
                    
                   fprintf('%s-',all_sub_folders(sub_index).name);
%                      train_from_timit([main_dir,  all_folders(index).name,'/', all_sub_folders(sub_index).name,'/'],data_path, [all_folders(index).name ,'_',all_sub_folders(sub_index).name],[ph_to_train{all_ph}]);
                   [truth predicted]=build_prob_model_for_channels([main_dir,  all_folders(index).name,'/', all_sub_folders(sub_index).name,'/'],nn_folder);
                   
                   for no_of_phonemes=1:length(truth)
                       counter(truth(no_of_phonemes))=counter(truth(no_of_phonemes))+1;
                       ph_all(truth(no_of_phonemes)).predict(:,counter(truth(no_of_phonemes)))=predicted(:,no_of_phonemes);
                   end
                   
                end
            end
            fprintf('\n');
    %         train_from_timit(all_folders(index).name,write_path,all_folders(index));        
        end
    end
% end


mkdir([data_path nn_folder save_at]);

for save_index=1:length(ph_all)
    temp=[ph_all(save_index).predict];
    save([data_path nn_folder save_at num2str(save_index)],'temp');    
end
