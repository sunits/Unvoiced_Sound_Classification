clc; clear all;close all;
main_dir='/home/dsplabserver/Dropbox/Sunit/to_sunit/sunit/unvoicedCasa/TIMIT/30Channel/nn_MMC_s_sh_f_th_LPC_CEP_10_15/prob_model_male/';
all_decisions=dir(main_dir);
no_of_channels=32;
vote=zeros(no_of_channels,length(all_decisions)-2);
counter=0;
for decisions=1:length(all_decisions)
            if(strcmp(all_decisions(decisions).name,'.') )
                continue;
            end
            if(strcmp(all_decisions(decisions).name,'..') )
                continue;
            end
	load([main_dir all_decisions(decisions).name]);
	temp1=(temp==str2double(all_decisions(decisions).name(1)));
	prob=sum(temp1,2)/size(temp1,2);
	counter=counter+1;
	vote(:,counter)=prob/sum(prob);
	fprintf('%s-',all_decisions(decisions).name(1));
end

 save([main_dir 'final.mat'] ,'vote');   