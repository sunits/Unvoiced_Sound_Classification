% Junk code- dont bother entering here

clear;clc

channel_number=10;
for channel_number=1:32



    data_path='./30Channel/sh/data/modPower_window_mag_corrected/';

    all=dir([data_path '*.mat']);
    

    prob_val=zeros(2,length(all));
    for i=1:length(all)


        load([data_path all(i).name]);

        
            gmm_path=['./30Channel/sh/gmm_modPower_scaled/Channel' num2str(channel_number) '.mat'];
            load(gmm_path);
            feature=(modPower(channel_number,1:20)-f_mean)./f_std;
             prob_val(1,i)=pdf(model,feature);
         
             gmm_path=['./30Channel/s/gmm_modPower_scaled/Channel' num2str(channel_number) '.mat'];
             load(gmm_path);
             feature=(modPower(channel_number,1:20)-f_mean)./f_std;
             prob_val(2,i)=pdf(model,feature);
         
%          fprintf('prob value:%d\n',prob_val(i));

    end

    subplot(211); plot(prob_val(2,:)); legend('s')
      subplot(212); plot(prob_val(1,:),'r'); legend('sh'); title('sh');
    pause(0.3);
    close all;
    
end