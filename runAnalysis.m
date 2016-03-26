function runAnalysis

    dirs = setPath;
    projects = dir2(dirs.data);

    for np = 1: numel(projects)
        
        pathToProject = fullfile(dirs.data, projects(np).name);
        projectMatFile = [pathToProject '.mat'];
        
        if (~exist(projectMatFile, 'file'))
            projectInfo = loadProject(pathToProject);
            save(projectMatFile, 'projectInfo');
        else
            load(projectMatFile);
        end
        
    end
end