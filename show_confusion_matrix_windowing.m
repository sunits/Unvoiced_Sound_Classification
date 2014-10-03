 clear all;
%   clc;
 
% folder_name='gmm_100_6moments';
% load '/home/dsplabserver/Dropbox/Sunit/to_sunit/sunit/unvoicedCasa/TIMIT/30Channel/TrainFeatures/models/10msec/gmm_100_MC_5_5/prob_model/result_16_32.mat'

load '/media/885C28DA5C28C532/Dropbox/to_sunit/sunit/unvoicedCasa/TIMIT/model/10Sec_mlsp_models/10msec/gmm_100_MC_5_0/prob_model/result_16_32.mat';

% phoneme_seq={'sh','s','f','th','p','k','ch','t'};
phoneme_seq={'sh','s','f','th'};

truth=[];
predicted=[];
frameBoundary=[];
% fprintf('\n\n%s\n',folder_name);

for index=1:length(result)
    truth=[truth index*ones(1,length(result(index).predicted))];
    predicted=[predicted result(index).vote_predicted'];
    frameBoundary=[frameBoundary result(index).boundary];
end


[phTruth,phClassification,phAccuracy]=frameWindowingUsingStoredResults(frameBoundary, ... % Information about number of frames per phonemes
                                        predicted, ... % frame level classification result
                                        truth, ... % frame level truth values
                                        4) ;
confusion_matrix(phTruth,phClassification,phoneme_seq);
