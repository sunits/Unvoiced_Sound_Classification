function [pos]=voting_part_channel(channel_decisions,no_of_classes,vote_path,indices,channels_to_consider)
%Function which allows a voting scheme. Details will be in the paper which I hope to write sometime in the future, mayan calendar not willing!

%Input:
%	channel_decisions is a vector of all decisions for each channel
%	no_of_classes is the total number of classes- the vote is prepared in the folowing order: 'sh','s','f','th','jh','ch','p','t','k'

%The variable name is "vote"
load([vote_path]);
prob_model=prob_model(:,indices);

final_decision=zeros(size(channel_decisions,1),no_of_classes);

for index=1:no_of_classes
	
	temp=channel_decisions==index;
	final_decision(:,index)=(temp(:,channels_to_consider>0)*prob_model(channels_to_consider>0,index));	
end

[junk  pos]=max(final_decision,[],2);




