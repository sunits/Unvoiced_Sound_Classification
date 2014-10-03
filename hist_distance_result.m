
clc; clear all; close all;
%% Config
hist_distance_base_path='/media/885C28DA5C28C532/Dropbox/to_sunit/sunit/unvoicedCasa/TIMIT/30Channel/histogram_match/';
gender='a';
channels_to_consider=[zeros(1,0) ones(1,32)];
ph_to_train={'sh','s','f','th'};
feature_path='/histogram/';
final_result=[];

%% Count results

for ph_index=1:length(ph_to_train)
    
    counter=0;
    
    data_path=cell2mat([hist_distance_base_path, [ph_to_train(ph_index)],feature_path]);
    all_distance_files=dir(strcat(data_path,'*.mat'));
    total_files=length(all_distance_files);
    
    for file_index=1:total_files
        
        fprintf(1,'\r%d|%d - %d',file_index,total_files,ph_index);
    
        if(all_distance_files(file_index).name(5)==gender | gender=='a')
            load([data_path,all_distance_files(file_index).name]);
            type_data=whos('distance'); % this variable is digged out using load
            
            if(strcmp(type_data.class,'struct'))
                no_of_phones=length(distance);
                
                for file_ph_index=1:no_of_phones
                    
                    counter=counter+1;
                   [junk class_label]= min(distance(file_ph_index).d,[],2);
                   class_label=class_label(channels_to_consider>0);
                   [count classes]=hist(class_label',unique(class_label));
                   [val max_at]=max(count);  
                   result(counter).predicted=(classes(max_at));
                   result(counter).truth=get_ph_index(distance(file_ph_index).truth,ph_to_train);
                   
                   plot(distance(file_ph_index).d);legend('sh','s','f','th');
                   title(strcat( ...
                                cellstr([ph_to_train(ph_index)]), ...
                                '--', ...
                                cellstr(
                            [ph_to_train(result(counter).predicted)]
                            ));
                   pause(0.3)
                   
                end
                
                
                
            else
                % there is nothing in the file, no phonemes at all. 
                continue;
            end
            
            
        else
            continue;
        end
        
    end
    
    final_result(ph_index).predicted=[result(:).predicted];
    final_result(ph_index).truth=[result(:).truth];
    
      
end


confusion_matrix([final_result(:).truth],[final_result(:).predicted],ph_to_train);