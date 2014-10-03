function [m1,m2,m3,m4,m5,m6]=plot_env_moments(signal,number_of_channels,fs,fRange,type)


% Window the  function
window=hamming(length(signal));
% Normalize the window such that sum(window)=1
window=window/sum(window);


temp=gammatone(signal,number_of_channels,fRange,fs);

[m n]=size(temp);

m6=zeros(number_of_channels,1);
m5=zeros(number_of_channels,1);
m4=zeros(number_of_channels,1);
m3=zeros(number_of_channels,1);
m2=zeros(number_of_channels,1);
m1=zeros(number_of_channels,1);
sigma_k=zeros(number_of_channels,1);



%% For each channel
for i=1:m
    % Get the envelope 
    h=hilbert(temp(i,:));
    
    % Simulate basilar membrane compression
    h=(abs(h)).^(1);
    
    % First Moment
    m1(i)=sum(window'.*h);
    sigma_k(i)= sqrt(sum(window'.*(h-repmat(m1(i),size(h))).^2));
    
    % Second Moment
    m2(i)= sigma_k(i)^2/(m1(i)^2 );
    
    % Third Moment
    m3(i)= sum(window'.*(h-repmat(m1(i),size(h))).^3 )/(sigma_k(i)^3 );
    
    % Fourth Moment
    m4(i)= sum(window'.*(h-repmat(m1(i),size(h))).^4 )/(sigma_k(i)^4 );
    m5(i)= sum(window'.*(h-repmat(m1(i),size(h))).^5 )/(sigma_k(i)^5 );
    m6(i)= sum(window'.*(h-repmat(m1(i),size(h))).^6 )/(sigma_k(i)^6 );
    
%     tempMod=gammatoneForModulationBand(h,modulation_bands,[22 2000],fs);    

    
%      temp_cross_band(i,:)=(h-repmat(m1(i),size(h)));
end
% 
% color='g';
%  if(type==1)
%      plot(m1,color);
%  elseif(type==2)
%      plot(m2,color);
%  elseif(type==3)
%      plot(m3,color);
%  elseif(type==4)
%      plot(m4,color);
%  end
%  