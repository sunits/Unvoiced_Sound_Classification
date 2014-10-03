 clear all;
%  clc;
% folder_name='gmm_100_6moments';
load '/home/dsplabserver/Dropbox/Sunit/to_sunit/sunit/unvoicedCasa/TIMIT/30Channel/TrainFeatures/models/10msec/DCT/prob_model/result_16_32.mat'
% phoneme_seq={'sh','s','f','th','p','k','ch','t'};
phoneme_seq={'sh','s','f','th'};

truth=[];
predicted=[];

% fprintf('\n\n%s\n',folder_name);

for index=1:length(result)
    truth=[truth index*ones(1,length(result(index).predicted))];
    predicted=[predicted result(index).vote_predicted'];
end

confusion_matrix(truth,predicted,phoneme_seq);
