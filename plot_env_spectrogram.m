function []=plot_env_spectrogram(signal,number_of_channels,fs,fRange)


% Window the  function
window=hamming(length(signal));
% Normalize the window such that sum(window)=1
window=window/sum(window);


temp=gammatone(signal,number_of_channels,fRange,fs);

[m n]=size(temp);
    
    
m4=zeros(number_of_channels,1);
m3=zeros(number_of_channels,1);
m2=zeros(number_of_channels,1);
m1=zeros(number_of_channels,1);
sigma_k=zeros(number_of_channels,1);
temp_cross_band=zeros(size(temp));


%% For each channel
for i=1:m
    % Get the envelope 
    h=hilbert(temp(i,:));
    
    % Simulate basilar membrane compression
    h=(abs(h)).^(0.3);
     temp_cross_band(i,:)=h;
end


 cochplot(temp_cross_band,fRange);
 colormap(flipud(gray));
 colorbar;