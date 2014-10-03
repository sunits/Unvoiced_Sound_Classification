 ticks={};
    for index=1:numChans
        if(sum(tick_pos==index)>0)
            ticks{index}=num2str(cf(index));
        else
            ticks{index}=' ';
        end
    end