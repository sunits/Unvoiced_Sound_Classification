function[predicted truth boundary] = compute_accuracy()

    clc;close all;clear all;
    no_of_channels=32;
    test_features_path='/home/dsplabserver/Dropbox/Sunit/to_sunit/sunit/unvoicedCasa/TIMIT/30Channel/TestFeatures/svm_format_sh_s_f_th/';
    result_base_path='/home/dsplabserver/Dropbox/Sunit/to_sunit/sunit/unvoicedCasa/TIMIT/30Channel/TestFeatures/svm_format_s_f_th/';
    
    model_path='/home/dsplabserver/Dropbox/Sunit/to_sunit/sunit/unvoicedCasa/TIMIT/30Channel/TrainFeatures/svm_format_sh_s_f_th/';
    ground_truth_base_path='/home/dsplabserver/Dropbox/Sunit/to_sunit/sunit/unvoicedCasa/TIMIT/30Channel/TestFeatures/';
%     boundary_base_path='/home/dsplabserver/Dropbox/Sunit/to_sunit/sunit/unvoicedCasa/TIMIT/30Channel/TestFeatures/';
%     boundary_sub_folder='LPCSpec_frame/';
    htk_feature_path='htk_format/';    
    boundary_path='/home/dsplabserver/Dropbox/Sunit/to_sunit/sunit/unvoicedCasa/TIMIT/boundary.mat';
    
    ph_to_test={'s','f','th'};
    class_decided=[];
    
    for index=1:no_of_channels
        fprintf(1,'\r%d/%d',index,no_of_channels);

%     for index=1:2
%        evaluate_svm= ['! svm-predict ' ...
%             test_features_path 'Channel' num2str(index) '_refined'... % test file
%             ' ' model_path 'Channel' num2str(index) '.model' ... % model file
%             ' ' result_base_path 'Channel' num2str(index) '.result']; % Result file
%             
%             eval(evaluate_svm);

        result=load([result_base_path 'Channel' num2str(index) '.result']);

        if(index==1)
            class_decided=zeros(length(result),no_of_channels);
        end

        class_decided(:,index)=result;

    end




    [count classes]=hist(class_decided',unique(class_decided));
    [val max_at]=max(count);   
    predicted=(classes(max_at))';
    truth=get_ground_truth(ph_to_test,ground_truth_base_path,htk_feature_path);    
    acc=check_accuracy(truth,predicted);
    fprintf(1,'Accuracy is :%d\n',acc);
    fprintf(1,'Now doing for using boundaries\n');
    
%     boundary=get_boundary_information(boundary_base_path,boundary_sub_folder,ph_to_test);
       load(boundary_path);
    
    [phTruth,phClassification,phAccuracy]=frameWindowing(boundary, ... % Information about number of frames per phonemes
                                        predicted, ... % frame level classification result
                                        truth, ... % frame level truth values
                                        length(ph_to_test)); % Total number of classes
                                    
    fprintf(1,'Accuracy using boundaries is :%d\n',phAccuracy); 
    
    fprintf(1,'Confusion Matrix without boundary\n');
    confusion_matrix(truth,predicted)
    
    fprintf(1,'Confusion Matrix with boundary\n');
    confusion_matrix(phTruth,phClassification)
    
end


function [truth]= get_ground_truth(ph_to_test, base_path,htk_feature_path)


truth=[];

    
    for ph_index=1:length(ph_to_test) 
        feature_path=cell2mat([base_path, [ph_to_test(ph_index)],'/',htk_feature_path, 'Channel1.mfc']);
        
        X=read_mfcc(feature_path);
       truth=[truth; ph_index*ones(size(X,1),1)];
       
    end
    
end

function [final_boundary]=get_boundary_information(boundary_base_path,boundary_sub_folder,ph_to_test)

number_of_classes=length(ph_to_test);
final_boundary=[];    
    for ph_index=1:number_of_classes 
        data_path=cell2mat([boundary_base_path, [ph_to_test(ph_index)],'/',boundary_sub_folder]);
        all_cc=dir(strcat(data_path,'*.mat'));
        
        total_files=length(all_cc);
        
            for index=1:total_files        
                load(strcat(data_path,all_cc(index).name));
                final_boundary=[final_boundary boundary];
            end
        
    end
end
