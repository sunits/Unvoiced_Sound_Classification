function [peak_coeff valley_coeff] = lpc_based_features(cross_corr,peaks,valley)

% cross_corr can be two dimensional
% LPC is taken for each row

% If no valley coeff are given use the same number of coefficients for both
% peaks and valley

valley_coeff=[];
peak_coeff=[];

if(nargin<3)
    valley=peaks;
end


% The idea bedhind this is to extract the channels at which peaks and valeys of the the cross_correlation elements are found
% peaks : number of coefficients for peaks
% valleys : number of coefficients for valleys


% make the signal look like a spectrum 

% cross_corr=reshape(cross_corr,1,length(cross_corr));
if(peaks>0)
    corr_spectrum =[cross_corr fliplr(cross_corr(:,2:end))]; % Now the signal looks like a zeros phase symmetric spectrum

    corr_time=(ifft(corr_spectrum'));

    peak_coeff=lpc((corr_time),peaks);
    peak_coeff=lpc2cep(peak_coeff')';
    peak_coeff=peak_coeff(:,2:end);
end

% est = filter([0, -peak_coeff(2:end)], 1, (corr_time));
% 
% err = corr_time - est;
% err_energy = sum(err.^2);   
% 
% [H, W] = freqz(1, peak_coeff,length(cross_corr));
% 
% plot( abs(H)/norm(abs(H)), 'LineWidth', 2); hold on;
% plot(cross_corr/norm(cross_corr),'r'); 
% 


% % Now invert the signal

if(valley>0)
    cross_corr1=-cross_corr+repmat(max(cross_corr),size(cross_corr,1),1);

    corr_spectrum1 =[ cross_corr1 fliplr(cross_corr1(:,2:end))]; % Now the signal looks like a zeros phase symmetric spectrum

    corr_time1=ifft(corr_spectrum1');
    valley_coeff=lpc(corr_time1,valley);
    valley_coeff=lpc2cep(valley_coeff')';
    valley_coeff=valley_coeff(:,2:end);
end
% 
% % est = filter([0, -valley_coeff(2:end)], 1, abs(corr_time));
% % 
% % err = corr_time - est;
% % err_energy = sum(err.^2);   
% 
% 
% % figure;
% 
% [H1, W] = freqz(1, valley_coeff,length(cross_corr1));
% 
% plot( abs(H1)/norm(abs(H1)), '-g','LineWidth', 2); 
% % hold on;
% % plot(cross_corr1/norm(cross_corr1),'r'); 
% hold off;
% 
% 

%% LPC cepstrums









