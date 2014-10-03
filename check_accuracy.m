function acc=check_accuracy(truth,predict)
% function to check the accuracty given the predicted and truth value
% Always the truth first ( i mean the order of input)
acc=sum(truth==predict)/length(truth);