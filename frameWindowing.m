function [phTruth,phClassification,phAccuracy]=frameWindowing(frame, ... % Information about number of frames per phonemes
                                        prediction, ... % frame level classification result
                                        truth, ... % frame level truth values
                                        number_of_classes) % Total number of classes

%% Output
% phTruth : Truth at phoneme level
% phClassification : classification at Phoneme level
% phAccuracy: final Accuracy


                                    
% Check if the input is right
number_of_frames=length(frame);

if(sum(frame)~=length(prediction))
    error('number of frames per phoneme dont add up');    
end


start_pos=1;

phClassification=zeros(number_of_frames,1);
phTruth=zeros(number_of_frames,1);

for index=1:number_of_frames
    
    frame_predict=prediction(start_pos:start_pos-1+frame(index));
%     frame_truth=truth(start_pos:start_pos+frame(index));
    class_prob=zeros(number_of_classes,1);
    
    phTruth(index)=mean(truth(start_pos:start_pos-1+frame(index))); % Ideally it must be an integer, If not there is something wrong
    
    for class_index=1:number_of_classes
        class_prob(class_index)=(frame_predict==class_index)'*hamming(frame(index));
%         class_prob(class_index)=(frame_predict==class_index)*hamming(frame(index));
    end
    [junk phClassification(index)]=max(class_prob);    
    start_pos=start_pos+frame(index);
    
end

phAccuracy=check_accuracy(phTruth,phClassification);

fprintf('\nAccuraccy is %d\n',phAccuracy)