function exportProjectData( varargin)
%EXPORTDATA Summary of this function goes here
%   Detailed explanation goes here

    %loads session info, exports trial data
    myPath = setPath;
    if (~isempty(varargin))
        projects = varargin;
    else
        projects = getProjectsList(myPath.data);
    end
    
    for np = 1: numel(projects)
        pathToProject = fullfile(myPath.data, projects{np});
        exportData(pathToProject);
    end
end

function exportData(pathToProject)
    exportDir = fullfile(pathToProject, '_export');
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

