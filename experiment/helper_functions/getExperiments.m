function exps = getExperiments(dirExperiments)

    % load possible experiment types into array
    % returns the list of all available experiments (m-files)
    % in dirExperiments directory
    
    listing = dir([dirExperiments filesep '*.m']);

    cnt = 0;
    experiments = cell(numel(listing), 1);
    names = cell(numel(listing), 1);
    
    for x = 1:length(listing)  
        if ~strcmp(listing(x).name,'template.m')
            cnt = cnt + 1;
            experiments{cnt} = eval(strtok(listing(x).name, '.'));
            names{cnt} = strtok(listing(x).name, '.');            
        end
    end
    exps.data  = experiments(1:cnt);
    exps.names = names(1:cnt);    
end
