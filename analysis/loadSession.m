function sessionData = loadSession(pathToSession)
    
    display(['Loading... ' pathToSession]);
    
    sessionMatFile = [strtok(pathToSession, '.') '.mat'];
    
    if (exist(sessionMatFile, 'file'))
        load(sessionMatFile);
    else
        [eyelinkDataFiles, eyelinkCalibFiles, conditionFiles] = lookForFiles(pathToSession);        
        
        nCndSession = numel(conditionFiles);
        sessionData = cell(nCndSession, 1);
    
        calibError = cell(numel(eyelinkCalibFiles), 1);
        sessionInfoFile = [strtok(pathToSession, '.') filesep 'sessionInfo.mat'];
        
        %process calibrartion first
        for nc =1:numel(eyelinkCalibFiles)
            calibError{nc} = loadEyelinkCalibration(fullfile(pathToSession, eyelinkCalibFiles{nc}));
        end
        
        load(sessionInfoFile)    
        %for each condition look if there is an eyelink file 
        for c = 1:nCndSession
            display(['Loading condition ' num2str(c) '/' num2str(nCndSession)]);
            eyelinkRec = processEyelinkFile(fullfile(pathToSession, eyelinkDataFiles{c}));
            % conditionInfo, trials
            load(conditionFiles{c});
            
            sessionData{c}.info = conditionInfo;
            sessionData{c}.data = eyelinkRec;
           [sessionData{c}.timecourse, sessionData{c}.pos, sessionData{c}.vel] = processTrialData(eyelinkRec, sessionInfo.subj.ipd);
        end
        save(sessionMatFile, 'sessionData');
    end
end

function convert2asc(filepath)
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

function [eyelinkFiles, eyelinkCalibFiles, sessionFiles] = lookForFiles(pathToSession)

    % new names 
    listSessionFiles_new = dir([pathToSession filesep 'cnd*.mat']);
    % old files
    listSessionFiles_old = dir([pathToSession filesep '*.mat']);
  
    %eyelink files
    listEyelinkRawFiles = dir([pathToSession filesep '*.edf']);
    if (~isempty(listEyelinkRawFiles))
        for ef = 1:numel(listEyelinkRawFiles)
            %move raw files out of the way 
            %converter(fullfile(pathToSession, listEyelinkRawFiles(ef).name));
            convert2asc(fullfile(pathToSession, listEyelinkRawFiles(ef).name));
            archive(pathToSession, listEyelinkRawFiles(ef).name);
        end
    end

    EyelinkFilesASC = dir([pathToSession filesep '*cnd*.asc']);
    EyelinkCalibFilesASC = dir([pathToSession filesep '*cali*.asc']);    
    
    %remove calibration 
    eyelinkFiles = {EyelinkFilesASC.name};
    
    eyelinkCalibFiles = {EyelinkCalibFilesASC.name};
    %dealing with the old data format
    if (isempty(listSessionFiles_new))
        sessionFiles = {listSessionFiles_old.name};
    else
        sessionFiles = {listSessionFiles_new.name};
    end        
end