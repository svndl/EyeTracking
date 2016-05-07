function projectInfo = loadProject(pathToProject)

    projectMatFile = [pathToProject '.mat'];
    
    if (~exist(projectMatFile, 'file'))
        list_sessions = dir2(pathToProject);
        nS = numel(list_sessions);
        projectInfo = cell(nS, 1);
    
        for ns = 1:nS
            sessionFolder = fullfile(pathToProject, list_sessions(ns).name);
            projectInfo{ns} = loadSession(sessionFolder);
        end
        save(projectMatFile, 'projectInfo');
    else
        load(projectMatFile);
    end
end