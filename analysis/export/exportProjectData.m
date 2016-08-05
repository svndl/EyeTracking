function exportProjectData( varargin)
%EXPORTDATA Summary of this function goes here
% Detailed explanation goes here
% Function loads session info, exports trial data
    myPath = setPath;
    if (~isempty(varargin))
        pathToProject = varargin;
    else
        pathToProject = uigetdir('Select project directory', myPath.data);
    end
    
    exportDir = fullfile(project, '_export');
    if (~exist(exportDir, 'dir'))
        mkdir(exportDir);
    end

    projectInfo = loadProject(pathToProject);    
    nS = numel(projectInfo);
    for n = 1:nS
        exportDirSsn = fullfile(exportDir, sprintf('session%d', n));
        if (~exist(exportDirSsn, 'dir'))
            mkdir(exportDirSsn);
        end
        
        session = projectInfo{n};
        exportSessionData(session, exportDirSsn);
    end
end

