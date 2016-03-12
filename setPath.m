function etpath = setPath

    [curr_path, ~, ~] = fileparts(mfilename('fullpath'));
    etpath.home = curr_path;
    etpath.stimsets = fullfile(curr_path, 'experiment', 'stimsets');
    etpath.displays = fullfile(curr_path, 'experiment', 'displays');
    epath.modelling = fullfile(curr_path, 'experiment', 'modelling');
    epath.analysis = fullfile(curr_path, 'experiment', 'analysis');    
    
    etpath.data = fullfile(curr_path, 'data'); % data has its own substructure, might want to add up later    
end