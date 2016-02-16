function disp = getDisplays(dirDisplays)


    listing = dir([dirDisplays filesep '*.m']);

    cnt = 0;
    displays = cell(numel(listing), 1);
    names = cell(numel(listing), 1);    
    for x = 1:length(listing)  
        if ~strcmp(listing(x).name, 'display_template.m')
            cnt = cnt + 1;            
            displays{cnt} = eval(strtok(listing(x).name, '.'));
            names{cnt} = strtok(listing(x).name, '.');
        end
    end
    disp.data  = displays(1:cnt);
    disp.names = names(1:cnt);    
end