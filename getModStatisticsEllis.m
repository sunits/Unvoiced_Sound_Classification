function [m1 m2 m3 m4 cross_band modPower] =getModStatistics(signal,fs,number_of_channels,modulation_bands,frange,modFRange)


% Compute the statitics of a segment 
%% Input
%     signal: Input signal whose statistics need to be computed
%     fs: Sampling frequency
%     number_of_channels: Number of Channels for signal decomposition
%     modulation_bands: Number of channles for decomposing the envelopes (second level signal decomposition)
%     frange: Frequency range for first level signal decomposition 
%     modFRange: Frequency range for the modulation band decomposition (second level signal decomposition)

%% Output
% m1 : A vector of first moments in each channel
% m2 : A vector of second moments in each channel
% m3 : A vector of third moments in each channel
% m4 : A vector of fourth moments in each channel
% cross_band: A number_of_channels x number_of_channels matrix giving the correlation values between channels
% modPower: A number_of_channels x modFRange matrix containing modulation power for each channel. 
  

% Author : Sunit Sivasankaran// IIT Madras// me@sunits.in



% Window the  function
window=hamming(length(signal));
% Normalize the window such that sum(window)=1
window=window/sum(window);
% signal=signal.*window;

% temp=gammatone(signal,number_of_channels,[50, 8000],fs);
temp=filterUsingGammatone(signal,number_of_channels,frange,fs);

[m n]=size(temp);
    
    
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
    h=(abs(h)).^(0.3);
    
    % First Moment
    m1(i)=sum(window'.*h);
    sigma_k(i)= sqrt(sum(window'.*(h-repmat(m1(i),size(h))).^2));
    
    % Second Moment
    m2(i)= sigma_k(i)^2/(m1(i)^2 );
    
    % Third Moment
    m3(i)= sum(window'.*(h-repmat(m1(i),size(h))).^3 )/(sigma_k(i)^3 );
    
    % Fourth Moment
    m4(i)= sum(window'.*(h-repmat(m1(i),size(h))).^4 )/(sigma_k(i)^4 );
    
%     tempMod=gammatoneForModulationBand(h,modulation_bands,[22 2000],fs);    

    tempMod=modFiltUsingGammatoneFast(h,modulation_bands,modFRange,fs);
    
    % Supress boundary effects
    tempMod=repmat(window',size(tempMod,1),1).*tempMod;
    
%   Computing normalized modulation power
    modPower(i,:)=sum(tempMod.^2,2)/(size(tempMod,2)*sigma_k(i)^2);
    
     temp_cross_band(i,:)=(h-repmat(m1(i),size(h)));
end


 cross_band=temp_cross_band*temp_cross_band';
 sigma_mat=sigma_k*sigma_k';

 cross_band=cross_band./sigma_mat;
% figure;imagesc(flipud(abs(cross_band)));
% [U S V]=svd(cross_band);
% figure;plot(diag(S));
