function pathData = make_data_dirs(dirData, experiment_subj, experiment_name)

%make data dirs
    pathData.dirTrack = fullfile(dirData, 'tracking', experiment_subj, experiment_name);
    pathData.dirStim  = fullfile(dirData, 'stimulus', experiment_subj, experiment_name);
    pathData.dirTrain = fullfile(dirData, 'training', experiment_subj, experiment_name);

    if ~exist(pathData.dirTrack, 'dir')
        mkdir(pathData.dirTrack);
    end

    if ~exist(pathData.dirStim, 'dir')
        mkdir(pathData.dirStim);
    end

    if ~exist(pathData.dirTrain, 'dir')
        mkdir(pathData.dirTrain);
    end
    
end