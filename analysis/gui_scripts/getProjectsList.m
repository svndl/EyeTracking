function projects = getProjectList(dirData)
    foldersOnly = 1;
    projects = lsdir(dirData, foldersOnly);
end
