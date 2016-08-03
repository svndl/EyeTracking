function projectInfo = loadProject1D(pathToProject)
% loads the project (all sessions located within pathToProject)
    projectMatFile = [pathToProject '.mat'];
    foldersOnly = 1;
    if (~exist(projectMatFile, 'file'))
        list_sessions = lsdir(pathToProject, foldersOnly);
        nS = numel(list_sessions);
        projectInfo = cell(nS, 1);
        addpath(genpath(pathToProject));    
        for ns = 1:nS
            sessionFolder = fullfile(pathToProject, list_sessions{ns});
            projectInfo{ns} = loadSession1D(sessionFolder);
        end
        projectInfo = projectInfo(~cellfun(@isempty, projectInfo));
        save(projectMatFile, 'projectInfo');
    else
        load(projectMatFile);
    end
end