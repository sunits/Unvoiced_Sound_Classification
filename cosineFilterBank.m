function r = cosineFilterBank(in, numChan, fRange, fs)
% Produce an array of filtered responses from a Gammatone filterbank.
% The first variable is required. 
% numChan: number of filter channels.
% fRange: frequency range.
% fs: sampling frequency.
% Written by ZZ Jin, adapted by DLW in Jan'07 and JF Woodruff in Nov'08

if nargin < 2
    numChan = 128;       % default number of filter channels in filterbank
end
if nargin < 3
    fRange = [80, 5000]; % default frequency range in Hz
end
if nargin < 4
    fs = 16000;     % default sampling frequency
end

filterOrder = 4;    % filter order
gL = 2048;          % gammatone filter length or 128 ms for 16 kHz sampling rate



phase(1:numChan) = zeros(numChan,1);        % initial phases
erb_b = hz2erb(fRange);       % upper and lower bound of ERB
erb = [erb_b(1):diff(erb_b)/(numChan-1):erb_b(2)];     % ERB segment
cf = erb2hz(erb);       % center frequency array indexed by channel
% b = 1.019*24.7*(4.37*cf/1000+1);       % rate of decay or bandwidth

b=cf/sqrt(2); %constant Q(=sqrt(2)) filters.


Time_period=2*b;
cosine_freq=1./Time_period;
gt = zeros(numChan,gL);  % Initialization


for i=1:numChan
    f1=(-0.25*Time_period(i)+cf(i));
    if(f1<0)
        f1=0;
    end
    f2=(0.25*Time_period(i)+cf(i));
    if(f2>fRange(2))
        f2=fRange(2);
    end
    
    left_pos=ceil(f1*gL/(0.5*fs));
    right_pos=floor((f2*gL/(0.5*fs)));
   t=linspace(-0.25*Time_period(i),0.25*Time_period(i),(right_pos-left_pos));
   gt(i,left_pos:right_pos)=(0+cos(2*pi*cosine_freq(i)*t))/2;
   plot(linspace(0,fRange(2),size(ft,2)),gt(i,:));
   hold on
end

sigLength = length(in);     % input signal length
sig = reshape(in,sigLength,1);      % convert input to column vector

% gammatone filtering using FFTFILT
r = fftfilt(gt',repmat(sig,1,numChan))';
