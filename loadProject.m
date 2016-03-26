function sessions = loadProject(pathToProject)

    list_subj = dir2(pathToProject);
    nSubj = numel(list_subj);
    
    
    sessions = cell(nSubj, 1);
    
    for ns = 1:nSubj
        sessionFolder = fullfile(pathToProject, list_subj(ns).name);
        sessionMatFile = [sessionFolder '.mat'];
        if (~exist(sessionMatFile, 'file'))
            sessionInfo = loadSession(sessionFolder);
            save(sessionMatFile, 'sessionInfo');
        else
            load(sessionMatFile);
        end
        sessions{ns} = sessionInfo;
    end
end