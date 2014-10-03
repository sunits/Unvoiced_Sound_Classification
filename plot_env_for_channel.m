function [p,N]=plot_env_for_channel(signal,number_of_channels,fs,fRange,channel_number)

% window=hamming(length(signal));
% % Normalize the window such that sum(window)=1
% window=window/sum(window);
% % signal=signal.*window;

% temp=gammatone(signal,number_of_channels,[50, 8000],fs);
temp=gammatone(signal,number_of_channels,fRange,fs);

h=hilbert(temp(channel_number,:));
    
% Simulate basilar membrane compression
 h=(abs(h)).^(0.3);
 
 
  
[N p]=hist(h,100);
plot(p,N/sum(N))
