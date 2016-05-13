function sessions = getSessionsList(pathToProject)
    foldersOnly = 1;
    sessions = lsdir(pathToProject, foldersOnly);
end
