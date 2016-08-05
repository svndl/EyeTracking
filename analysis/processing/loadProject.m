function projectInfo = loadProject(pathToProject)
% loads the project (all sessions located within pathToProject)
    foldersOnly = 1;
    list_sessions = lsdir(pathToProject, foldersOnly);
    nS = numel(list_sessions);
    projectInfo = cell(nS, 1);
    addpath(genpath(pathToProject));
    for ns = 1:nS
        sessionFolder = fullfile(pathToProject, list_sessions{ns});
        projectInfo{ns} = loadSession(sessionFolder);
    end
    projectInfo = projectInfo(~cellfun(@isempty, projectInfo));
end