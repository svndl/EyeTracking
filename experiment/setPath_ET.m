function etpath = setPath_ET

    [curr_path, ~, ~] = fileparts(mfilename('fullpath'));
    etpath.home = curr_path;
    etpath.experiments = fullfile(curr_path, 'settings');
    etpath.displays = fullfile(curr_path, 'displays');
    epath.modelling = fullfile(curr_path, 'modellling');
    epath.analysis = fullfile(curr_path, 'analysis');    
    
    etpath.results = fullfile(curr_path, 'data'); % data has its own substructure, might want to add up later
    epath.modelling = fullfile(curr_path, 'modellling');
    epath.analysis = fullfile(curr_path, 'analysis');
    
end