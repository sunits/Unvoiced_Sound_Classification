function setTicks(h_fig,axis_name,numChans,number_of_ticks,fRange)
%Sets the ticks for a particular axis
addpath ../

if(strcmp(axis_name,'x'))
    tick_type='XTick';    
    xlabel('Center Frequency (in Hz)');
    ylabel('')
else
    tick_type='YTick';    
    ylabel('Center Frequency (in Hz)');
    xlabel('')
end
for k=1:length(h_fig)
    grid on;
    set(h_fig(k),'XLim',[1 numChans]);
    set(h_fig(k),tick_type,[1:numChans]);
    
    erb_b = hz2erb(fRange);       % upper and lower bound of ERB
    erb = [erb_b(1):diff(erb_b)/(numChans-1):erb_b(2)];     % ERB segment
    cf = erb2hz(erb);       % center frequency array indexed by channel
    cf=round(cf);
    
    tick_pos=floor(linspace(1,numChans,number_of_ticks));
%     tick_label=cf(tick_pos);
    
    ticks={};
    for index=1:numChans
        if(sum(tick_pos==index)>0)
            ticks{index}=num2str(cf(index));
        else
            ticks{index}=' ';
        end
    end
    
    set(h_fig(k),'XTickLabel',ticks);
     axis tight

    
    
    
    
end

