function gammatone_plot(r, fRange, fs,x_tick_n)
% Display the image (log intensity) of a cochleagram
% The first variable is required. 
% fRange: frequency range.
% frame_rate: self explanatory
% Written by YP Li, and adapted by DLW in Jan'07

if nargin < 2
    fRange = [80, 5000]; % default frequency range in Hz
end
if nargin < 3
    frame_rate = 10; % default frame rate in ms
end

[numChan, len] = size(r);

% convert to log or root scale for display purposes if hair cell
% transduction is not used
imagesc(flipud(r));
% imagesc(flipud(r.^(1/2)));

% x tick
% x_intv = 200;       % a tick every 200 ms
% x = 0:round(x_intv/frame_rate):numFrame;

x=linspace(0,len,x_tick_n);
x_label = x./fs; % in seconds
x_label=round(x_label*100)/100;

% y tick
y_ntick = 6; % the number of ticks in the frequency axis
cfs = erb2hz(linspace(hz2erb(fRange(1)), hz2erb(fRange(2)), numChan));
y = linspace(1, numChan, y_ntick);
y_label = round(cfs(round(y)));

% set proper tick labels
set(gca, 'XTick', x);
set(gca, 'XTickLabel', x_label);
xlabel('Time (s)');

set(gca, 'YTick', y);
set(gca, 'YTickLabel', fliplr(y_label));
ylabel('Center Frequency (Hz)');



