function dirContents = lsdir(dirPath, folderOnly)

    listing = dir(dirPath);
    list_names = {listing(:).name};
    isDir = [listing(:).isdir];
    
    validIdx = (~ismember(list_names, {'.', '..'}));
    if (folderOnly)
        validIdx = validIdx.*isDir;
    end
    dirContents = list_names(logical(validIdx));
end