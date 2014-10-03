function [m1 m2 m3 m4 m5 m6 cross_band modPower] =getModStatistics(signal,fs,number_of_channels,modulation_bands,frange,modFRange)
% Compute the statitics of a segment 

% Window the  function
window=hamming(length(signal));
% Normalize the window such that sum(window)=1
window=window/sum(window);
% signal=signal.*window;
% temp=gammatone(signal,number_of_channels,[50, 8000],fs);
temp=filterUsingGammatone(signal,number_of_channels,frange,fs);

[m n]=size(temp);
    
    
m6=zeros(number_of_channels,1);
m5=zeros(number_of_channels,1);
m4=zeros(number_of_channels,1);
m3=zeros(number_of_channels,1);
m2=zeros(number_of_channels,1);
m1=zeros(number_of_channels,1);
sigma_k=zeros(number_of_channels,1);
temp_cross_band=zeros(size(temp));
modPower=zeros(number_of_channels,modulation_bands);

%% For each channel
for i=1:m
    % Get the envelope 
    h=hilbert(temp(i,:));
    
    % Simulate basilar membrane compression
%     h=(abs(h)).^(0.3);
    h=abs(h);
    
    % First Moment
    m1(i)=sum(window'.*h);
    sigma_k(i)= sqrt(sum(window'.*(h-repmat(m1(i),size(h))).^2));
    
    % Second Moment
    m2(i)= sigma_k(i)^2/(m1(i)^2 );
    
    % Third Moment
    m3(i)= sum(window'.*(h-repmat(m1(i),size(h))).^3 )/(sigma_k(i)^3 );
    
    % Fourth Moment
    m4(i)= sum(window'.*(h-repmat(m1(i),size(h))).^4 )/(sigma_k(i)^4 );
    
	% Fourth Moment
    m5(i)= sum(window'.*(h-repmat(m1(i),size(h))).^5 )/(sigma_k(i)^5 );
    
    % Fourth Moment
    m6(i)= sum(window'.*(h-repmat(m1(i),size(h))).^6 )/(sigma_k(i)^6 );

%     tempMod=gammatoneForModulationBand(h,modulation_bands,[22 2000],fs);    

    tempMod=modFiltUsingGammatoneFast(h,modulation_bands,modFRange,2*modFRange(2));
    tempMod=repmat(window',size(tempMod,1),1).*tempMod;
%   Computing normalized modulation power
    modPower(i,:)=sum(tempMod.^2,2)/(size(tempMod,2)*sigma_k(i)^2);
    
     temp_cross_band(i,:)=(h-repmat(m1(i),size(h)));
end

%% Bug fixed here: Windowing wasnt happening before
%  cross_band=temp_cross_band*temp_cross_band';

 
 
 cross_band=(temp_cross_band.*repmat(window',m,1))*temp_cross_band';
 
 sigma_mat=sigma_k*sigma_k';
 cross_band=cross_band./sigma_mat;
%  
%  cross_band=cross_band/max(abs(cross_band(:)));
% figure;imagesc(flipud(abs(cross_band)));
% [U S V]=svd(cross_band);
% figure;plot(diag(S));
