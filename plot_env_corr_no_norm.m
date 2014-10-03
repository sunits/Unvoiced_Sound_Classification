function [m1 m2 m3 m4 cross_band modPower] =plot_env_corr_no_norm(signal,number_of_channels,fs,frange)

% Compute the statitics of a segment 

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


%% For each channel
for i=1:m
    % Get the envelope 
    h=hilbert(temp(i,:));
    
    % Simulate basilar membrane compression
    h=(abs(h)).^(0.3);
    
%     h=abs(h);
    
    % First Moment
    m1(i)=sum(window'.*h);
    sigma_k(i)= sqrt(sum(window'.*(h-repmat(m1(i),size(h))).^2));
    
    % Second Moment
    m2(i)= sigma_k(i)^2/(m1(i)^2 );
    
    % Third Moment
    m3(i)= sum(window'.*(h-repmat(m1(i),size(h))).^3 )/(sigma_k(i)^3 );
    
    % Fourth Moment
    m4(i)= sum(window'.*(h-repmat(m1(i),size(h))).^4 )/(sigma_k(i)^4 );
     
     temp_cross_band(i,:)=(h-repmat(m1(i),size(h)));
end

%% Bug fixed here: Windowing wasnt happening before
  
  cross_band=(temp_cross_band.*repmat(window',m,1))*temp_cross_band'; 
  sigma_mat=sigma_k*sigma_k';
  cross_band=cross_band./sigma_mat;
  
    imagesc(abs((cross_band)));
    colormap(flipud(gray));
    colorbar;
 
%  
%  cross_band=cross_band/max(abs(cross_band(:)));
% figure;imagesc(flipud(abs(cross_band)));
% [U S V]=svd(cross_band);
% figure;plot(diag(S));
