function sessionInfo = loadSession(pathToSession)
    
    listSessionFiles = dir([pathToSession filesep 'cnd*.mat']);
    listEyelinkRawFiles = dir([pathToSession filesep '*.edf']);
    
    if (~isempty(listEyelinkRawFiles))
        for ef = 1:numel(listEyelinkRawFiles)
            %move raw files out of the way 
            %converter(fullfile(pathToSession, listEyelinkRawFiles(ef).name));
            archive(pathToSession, listEyelinkRawFiles(ef).name);
        end  
    end
    
    %list condition files only
    
    listEyelinkFiles = dir([pathToSession filesep 'cnd*.asc']);
    
    nCndSession = numel(listSessionFiles);
    sessionInfo = cell(nCndSession, 1);
    
    elf = {listEyelinkFiles.name};
    elInfo = loadEyelinkInfo;
  
    %for each condition look if there is an eyelink file 
    for c = 1:nCndSession
        elFilename = ['cnd' num2str(c) '.asc'];
        if(sum(ismember(elf, elFilename)))
            trials = processEyelinkFile(fullfile(pathToSession, elFilename), elInfo);
            %load session timimng
            load(listSessionFiles(c).name);
        end       
    end
end
function checkTiming()



end

function converter(filepath)
    command = ['edf2asc ' filepath];
	[~, ~] = system(command);

end
function archive(filepath, filename)

    dirRaw = fullfile(filepath, 'raw');
    if (~exist(dirRaw, 'dir'))
        mkdir(dirRaw);
    end
    
    command = ['mv ' [filepath filesep filename] ' ' [dirRaw filesep filename]];
	[~, ~] = system(command);   
end