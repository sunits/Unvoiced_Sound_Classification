function build_GMM_for_SVM(basepath, ...
                            NumMix, ...
                            CovType, ...
                            varFloorPer, ...
                            GMMOptions, ...
                            gmm_save_path, ...
                            number_of_channels)

                        


    for channel=1:number_of_channels
        [classInfo features]=libsvmread([basepath 'Channel' num2str(channel) '.scale']);
        features=full(features);
        phones=unique(classInfo);
        
        global_var=double(var(features(:)));
        varFloorPer=double(sqrt(varFloorPer*global_var/100));
        fprintf('\n Global variance is %f and varFloor is %f \n',global_var,varFloorPer);

        for ph_index=1:length(phones)
               
                    tempGMM = gmdistribution.fit(features(classInfo==ph_index,:),NumMix,'CovType',CovType,'Regularize',varFloorPer,'Options',GMMOptions);
                    GMM{ph_index}.model =tempGMM;              

        end
        
        save(strcat(gmm_save_path,'Channel',num2str(channel)),'GMM');
        
        fprintf('\n Complete for channel %d',channel);
        

    end

