function runAnalysis(varargin)
    % function will load and run analysis on existing eyetracking projects
    % Projects should be located in root/data folder. See setPath.m for
    % details.
    
    % Callback example:
    %   runAnalysis(projectList = {projectNameC, ..., projectNameY})
    %       will run analysis on root/data/{projectName1, ..., projectNameN}
    
    %  runAnalysis()
    %       will run analysis on root/data/everything
    
    % Alexandra Yakovleva, Stanford University 2016.
    
    
    dirs = setPath;
    foldersOnly = 1;
    if (~isempty(varargin))
        projects = varargin(1);
    else
        projects = lsdir(dirs.data, foldersOnly);
    end
    
    for np = 1: numel(projects)
        pathToProject = fullfile(dirs.data, projects{np});
        projectInfo = loadProject(pathToProject);
        %do project analysis
    end
end