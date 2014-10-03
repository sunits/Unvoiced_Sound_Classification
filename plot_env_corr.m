function []=plot_env_corr(signal,number_of_channels,fs,fRange)


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

correlogram_info=zeros(size(temp));

%% For each channel
for i=1:m
    % Get the envelope 
    h=hilbert(temp(i,:));
    
    % Simulate basilar membrane compression
    h=(abs(h)).^(0.3);
    
    correlogram_info(i,:)=h;
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

    
     temp_cross_band(i,:)=(h-repmat(m1(i),size(h)));
end

% 
%  cross_band=temp_cross_band(17:end,:)*temp_cross_band(17:end,:)';
%  sigma_mat=sigma_k(17:end)*sigma_k(17:end)';
%  cross_band=cross_band./sigma_mat;


%  cross_band=temp_cross_band*temp_cross_band';
 cross_band=(temp_cross_band.*repmat(window',m,1))*temp_cross_band';
 sigma_mat=sigma_k*sigma_k';
 cross_band=cross_band./sigma_mat;
%  figure;
%  gammatone_plot(correlogram_info,[50 8000],fs,10);

%  colormap(flipud(gray));
%  colorbar;
%  
 figure;
 imagesc(abs(flipud(cross_band)));
 colormap(flipud(gray));
 colorbar;