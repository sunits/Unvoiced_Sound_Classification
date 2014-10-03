function []=test_GMM_fast_MC_no_LPC(full_path, ... %
					ph_to_train, ... % Phonemes to Train
					feature_path, ... % Path where features are stored inside the phoneme directory
					gender, ... %Male('m'), Female('f'), All('')
					gmm_path, ... % Neural Network model save path
					number_of_channels, ... % Number of channels(for filterbank)
					mod_filter_size_len, ...
					mod_scaling_factor, ... % Number of modulation filters (modulation filterbank)
                    lpc_length_peak, ...  % Number of LPC coefficients to capture Peaks
                    lpc_length_valley, ... % Number of LPC coefficients to capture valleys
                    prob_model_path, ... % where is the probability model path
                    prediction_save_path, ...   % Where do I save your prediction resullts?
                    num_of_moments, ...   
                    channels_to_consider, ...
                    phonemes_to_consider)



num_of_moments=4;
moment_count=0;

number_of_classes=length(ph_to_train);
best_channels=zeros(sum(channels_to_consider),number_of_classes);
prob_model=zeros(number_of_channels,number_of_classes);

for ph_index=1:number_of_classes 
    counter=0;
    data_path=cell2mat([full_path, [ph_to_train(ph_index)],feature_path]);
    all_cc=dir(strcat(data_path,'*.mat'));

    fprintf('\n---%s---\n',cell2mat(ph_to_train(ph_index)));
    total_files=length(all_cc);
        for index=1:total_files
%             for index=1:20

        fprintf(1,'\r%d/%d',index,total_files);
        %% Gender specificity- Train for male or female only 
         if(all_cc(index).name(5)==gender | gender=='a')



        %%

            load(strcat(data_path,all_cc(index).name));

        %     TOtal number of phones in the data
            number_of_phones=size(m1,2);

            temp=reshape(modPower,number_of_channels,mod_filter_size_len,number_of_phones);
            tempCC=reshape(cross_corr,number_of_channels,number_of_channels,number_of_phones);

            moment_count=moment_count+1;
            all_m1(moment_count).m1=m1;
            all_m2(moment_count).m2=m2;
            all_m3(moment_count).m3=m3;
            all_m4(moment_count).m4=m4;
            all_boundary(moment_count).b=boundary;

            for temp_index=1:number_of_phones

                feature=[tempCC(:,:,temp_index)];        
                
                counter=counter+1;
        %         Put all features into one var
        %         all_cross_corr(counter).cc=feature;        
                
                all_cross_corr(counter).cc=feature;
                all_cross_corr(counter).label=ph_index;
                

            end
         else 
            continue;
         end

        end


% Vectorize the feature
  all_cross_corr=[all_cross_corr(:).cc];
 all_m1=[all_m1(:).m1];
 all_m2=[all_m2(:).m2];
 all_m3=[all_m3(:).m3];
 all_m4=[all_m4(:).m4];
 all_boundary=[all_boundary(:).b];
 

class_prob=zeros(size(all_m1,2),number_of_channels);

for channel=1:number_of_channels
    
    if(channels_to_consider(channel)==0)
		continue;
    end
	
    
   load([gmm_path 'Channel',num2str(channel)]);
   features_for_training= [all_m1(channel,:) all_m2(channel,:) all_m3(channel,:) all_m4(channel,:) all_cross_corr(channel,:) ];
   number_of_training_samples=length(features_for_training)/(num_of_moments+number_of_channels);
   features_for_training=reshape(features_for_training,number_of_training_samples,num_of_moments+number_of_channels);
    
  
   
   %f_mean  and f_std loads from the stored model   
   features_for_training=(features_for_training-(ones(size(features_for_training,1),1)*f_mean))./(ones(size(features_for_training,1),1)*f_std);
   
   temp_prob=zeros(size(all_m1,2),number_of_classes);
   
   for class_index=1:number_of_classes
        temp_prob(:,class_index)=pdf(GMM{class_index}.model,features_for_training);
   end
   
   [junk class_prob(:,channel)]=max(temp_prob,[],2);
   fprintf('\n Complete for channel %d',channel);
end


% TO consider only required set of channels
class_prob=class_prob(:,channels_to_consider>0);
 best_channels(:,ph_index)= sum(class_prob==ph_index);

 


[count classes]=hist(class_prob',unique(class_prob));
[val max_at]=max(count);   
result(ph_index).predicted=(classes(max_at));
result(ph_index).boundary=all_boundary;
result(ph_index).truth=ph_index*ones(number_of_training_samples,1);
result(ph_index).vote_predicted=voting(class_prob,length(ph_to_train),prob_model_path,phonemes_to_consider,channels_to_consider);


acc=check_accuracy([result(ph_index).truth],[result(ph_index).vote_predicted]);

[phTruth,phClassification,phAccuracy]=frameWindowing(all_boundary, ... % Information about number of frames per phonemes
                                        [result(ph_index).vote_predicted], ... % frame level classification result
                                        [result(ph_index).truth], ... % frame level truth values
                                        number_of_classes); % Total number of classes

                                    

fprintf('\nNormal Acc =%d : With voting = %d\n',acc,phAccuracy);
clear all_*;


end
save([prediction_save_path 'result_1_4_16_32.mat'],'result');

