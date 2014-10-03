function [m1 m2 m3 m4 cross_band] =getAllStatisticsFast(signal,fs,number_of_channels,frange)
% Compute the statitics of a segment 
if(nargin<4)
    frange=[50 8000];
end

m1=[];m2=[];m3=[];m4=[];cross_band=[];

temp=gammatone(signal,number_of_channels,frange,fs);

[m n]=size(temp);

hTemp=hilbert(temp');
hTemp=abs(hTemp').^(0.3);

% %% Temp stuff
% [N pos]=hist(hTemp(20,:),100);
% plot(pos,N/sum(N),'color',abs(rand(1,3)));
% 
% 
% %%


m1=mean(hTemp');


sigma_k=(sum((hTemp-repmat(m1',1,size(hTemp,2)))'.^2)/n).^(0.5);
m2=sigma_k.^2 ./m1.^2;
m3=(sum((hTemp-repmat(m1',1,size(hTemp,2)))').^3)./(n*sigma_k.^3);
m4=(sum((hTemp-repmat(m1',1,size(hTemp,2)))').^4)./(n*sigma_k.^4);
temp_cross_band=(hTemp-repmat(m1',1,size(hTemp,2)));
cross_band=temp_cross_band*temp_cross_band';
return 

% 83 corresponds to channel haveing center freq 2250
[pdf_val,pos]=hist(hTemp(83,:),100);
m1=pdf_val;
m2=pos;


% cochplot(hTemp, frange)
% colormap(gray)
% plot(pos,pdf_val);



% 
% m1=mean(hTemp');
% m1=m1';
% 
% sigma_k=sum((hTemp-repmat(m1,size(hTemp))).^2)/n
%     
%     
% m4=zeros(number_of_channels,1);
% m3=zeros(number_of_channels,1);
% m2=zeros(number_of_channels,1);
% m1=zeros(number_of_channels,1);
% sigma_k=zeros(number_of_channels,1);
% temp_cross_band=zeros(size(temp));
% 
% for i=1:m
%     h=hilbert(temp(i,:));
%     h=(abs(h)).^(0.3);
%     
%     m1(i)=mean(h);
%     sigma_k(i)= sqrt(sum((h-repmat(m1(i),size(h))).^2)/n);
%     m2(i)= sigma_k(i)^2/(m1(i)^2 );
%     m3(i)= sum((h-repmat(m1(i),size(h))).^3 )/(n*sigma_k(i)^3 );
%     m4(i)= sum((h-repmat(m1(i),size(h))).^4 )/(n*sigma_k(i)^4 );
%     
%      temp_cross_band(i,:)=(h-repmat(m1(i),size(h)));
% end
% 
% 
%  cross_band=temp_cross_band*temp_cross_band';
%  sigma_mat=sigma_k*sigma_k';
%  cross_band=cross_band./sigma_mat;
% % figure;imagesc(flipud(abs(cross_band)));
% % [U S V]=svd(cross_band);
% % figure;plot(diag(S));
