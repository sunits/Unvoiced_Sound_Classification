function [feat,param] = fn_mfcc(data,param)

% Check this
data = data(:);

if ~exist('param','var') || ~isfield(param,'fs'), param.fs = 16000; end
if ~isfield(param,'featype'), fprintf(1,'Extracting MFCC_0\n'); param.featype = 'mfcc0'; end 

% ZMEANSOURCE (seems to work fine, though HTK implementation is a bit off)
if ~isfield(param,'zmeansource') || param.zmeansource=='T', data = data - mean(data); end

% Short-time processing
if ~isfield(param,'winlen') || ~isfield(param,'overlap') || param.winlen==0 || param.overlap==0
    fprintf(1,'Setting window length = 20 ms and frame rate = 100 per second\n');
    param.winlen    = 20 * param.fs /1000;
    param.overlap   = 10 * param.fs /1000;
end

NumFrames = floor(length(data)/(param.winlen-param.overlap) - 2);       % Number of frames
FrSt = (0:NumFrames-1) * (param.winlen-param.overlap) + 1;              % Starting indices of all frames
FrEn = FrSt+param.winlen-1;                                             % Ending indices of all frames

% Store frames of data as columns of matrix feat
feat = zeros(param.winlen,NumFrames);
for i=1:NumFrames
    feat(:,i) = data(FrSt(i):FrEn(i));
end

% Pre-emphasis
if ~isfield(param,'preemcoef'), param.preemcoef = 0.97; end
fprintf(1,'Performing pre-emphasis with coefficient 0.97\n');
feat = filter([1,-param.preemcoef],1,feat);
feat(1,:) = (1-param.preemcoef) * feat(1,:);

% Hamming window
if ~isfield(param,'usehamming') || param.usehamming=='T',
    fprintf(1,'Using Hamming window\n');
    feat = feat .* (hamming(param.winlen) * ones(1,NumFrames));
end

% Extract magnitude spectrogram features
if ~isfield(param,'nfft'), param.nfft = 2^nextpow2(param.winlen); end
feat = abs(fft(feat,param.nfft));
feat(2+param.nfft/2:param.nfft,:)=[];
if strcmpi(param.featype,'magspec'), return; end
if strcmpi(param.featype,'magsqspec'), feat = feat.^2; return; end

% Get melspec features
if ~isfield(param,'numchans'), param.numchans = 23; end
if ~isfield(param,'lofreq'), param.lofreq = 64; end
if ~isfield(param,'hifreq'), param.hifreq = param.fs/2; end
FBMat = fn_trifbank(param.numchans,1+param.nfft/2,[param.lofreq, param.hifreq],param.fs);
feat = FBMat * feat;
feat(feat<1) = 1;           % This is Mel-Flooring
if strcmpi(param.featype,'melspec'), return; end

% Apply log operator to get fbank features
feat = log(feat);
if strcmpi(param.featype,'fbank'), return; end

% Get cepliftered MFCC_0 features
if ~isfield(param,'numceps'), param.numceps = 12; end
if ~isfield(param,'ceplift'), param.ceplift = 22; end
DCT0 = fn_dct0(param.numchans,param.numceps);
CEP0 = fn_ceplift0(param.numceps,param.ceplift);
feat = CEP0 * DCT0 * feat;

if ~strcmpi(param.featype,'mfcc0'),
    fprintf(1,['Feature type ' param.featype ' not supported. Storing MFCC_0\n']);
end

end

function [H,f,c] = fn_trifbank(M,K,R,fs)
% TRIFBANK Triangular filterbank
%
%   Author
%           Kamil Wojcicki, UTD, June 2011
%   Inputs
%           M is the number of filters, i.e., number of rows of H
%
%           K is the length of frequency response of each filter
%             i.e., number of columns of H
%
%           R is a two element vector that specifies frequency limits (Hz),
%             i.e., R = [ low_frequency high_frequency ];
%
%           FS is the sampling frequency (Hz)
%
%   Outputs
%           H is a M by K triangular filterbank matrix (one filter per row)
%
%           F is a frequency vector (Hz) of 1xK dimension
%
%           C is a vector of filter cutoff frequencies (Hz),
%             note that C(2:end) also represents filter center frequencies,
%             and the dimension of C is 1x(M+2)
%
%   Example
%           fs = 16000;                 % sampling frequency (Hz)
%           nfft = 2^12;                % fft size (number of frequency bins)
%           K = nfft/2+1;               % length of each filter
%           M = 23;                     % number of filters

if nargin~= 4, help fn_trifbank; return; end; % very lite input validation

f_min = 0;                              % filter coefficients start at this frequency (Hz)
f_low = R(1);                           % lower cutoff frequency (Hz) for the filterbank
f_high = R(2);                          % upper cutoff frequency (Hz) for the filterbank
f_max = 0.5*fs;                         % filter coefficients end at this frequency (Hz)
f = linspace( f_min, f_max, K );        % frequency range (Hz), size 1xK
% fw = hz2mel( f );

% filter cutoff frequencies (Hz) for all filters, size 1x(M+2)
c = mel2hz( hz2mel(f_low)+(0:M+1)*((hz2mel(f_high)-hz2mel(f_low))/(M+1)) );
% cw = hz2mel( c );

H = zeros( M, K );                      % zero otherwise
for m = 1:M
    k = f>=c(m)&f<=c(m+1);              % up-slope
    H(m,k) = (f(k)-c(m))/(c(m+1)-c(m));
    k = f>=c(m+1)&f<=c(m+2);            % down-slope
    H(m,k) = (c(m+2)-f(k))/(c(m+2)-c(m+1));
end

end

function M = hz2mel(H)
M = 2595 * log10(1 + H/700);
end

function H = mel2hz(M)
H = 700 * (10.^(M/2595) - 1);
end

function [DCT,IDCT] = fn_dct0(NumChan,NumCeps,C0_Flag)
% VERY IMP NOTE:
% NumCeps MUST EXCLUDE (not count) C0
% C0_Flag = 0 assumes FBANK -> MFCC
% Otherwise  BY DEFAULT, it is FBANK -> MFCC_0

if ~exist('C0_Flag','var') || C0_Flag~=0, C0_Flag = 1; end
if C0_Flag, n = [1:NumCeps 0]; else n = 1:NumCeps; end

DCT = sqrt(2/NumChan) * cos(pi/NumChan * n' * (0.5:NumChan-0.5));
IDCT = sqrt(2/NumChan) * cos(pi/NumChan * (0.5:NumChan-0.5)' * n);
if C0_Flag, IDCT = IDCT * diag([ones(1,NumCeps) 0.5]); end

end

function [CEP,ICEP] = fn_ceplift0(NumCeps,CepLiftPar)

% VERY IMP NOTE: NumCeps MUST EXCLUDE C0

n = [1:NumCeps 0];
% For ceplift without C0, use: n=1:NumCeps-1;

% Elements of the matrices
Ele = 1+(CepLiftPar/2)*sin(pi*n/CepLiftPar);

% Generate matrices
CEP = diag(Ele);
ICEP = diag(1./Ele);

end
