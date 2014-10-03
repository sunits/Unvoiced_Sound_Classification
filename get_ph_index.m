% Gets the index of the phoneme in the ph_array
%input : ph_array={'sh','s','f','th'};
%        phoneme= 'sh'

function index=get_ph_index(phoneme,ph_array)
    index=-1;
    ph_array=cellstr(ph_array);
    
    for ph_index=1:length(ph_array)
       if strcmp(phoneme,ph_array{ph_index})
          index=ph_index;
          break;
       end
    end
end


