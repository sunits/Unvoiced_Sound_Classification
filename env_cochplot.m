function[]=env_cochplot(signal,fs,frange,title_txt)

    response=gammatone(signal,128,[50 8000],fs);        
    % hilbert computes the envelope of coloumns
    h=hilbert(response');
    h=h';
    h=abs(h);
    h=h.^(0.3);
    addpath /media/885C28DA5C28C532/Dropbox/code/unvoicedCasa/
    cochplot(h,frange,fs);
    colormap(gray);
    colorbar;
    title(title_txt);
    saveas(gcf, ['cross_corr/env_coch/' title_txt num2str(rand(1,1))], 'png');