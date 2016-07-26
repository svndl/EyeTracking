function [missedFrames, response, eyetracking, eyetrackingQ, trialIndex, sessionInfo] = loadRawData(pathToSession)
% function will load raw eyelink/ trials data 
% input: path to session folder
% output: cell vectors with tracking and timing data

    %% load the sessionInfo first
    sessionInfoFile = [strtok(pathToSession, '.') filesep 'sessionInfo.mat'];    
    
    try
        load(sessionInfoFile);
    catch
        disp('Cannot process the session without session Info file, exiting');
        exit();
    end
    %% get the list of mat and edf files available
    matFiles = getFileList(pathToSession, 'mat', sessionInfo.runSequence);
    
    % look for edf files first
    eyelinkFiles = getFileList(pathToSession, 'edf', sessionInfo.runSequence);
    
    % use the non-empty list
    if (isempty(eyelinkFiles))
        eyelinkFiles = getFileList(pathToSession, 'asc', sessionInfo.runSequence);
    end

    % check calibration
    eyelinkCalibFiles = getFileList(pathToSession, 'edf', 'cali');    
    
    for nc = 1:numel(eyelinkCalibFiles)
        calibError{nc} = loadEyelinkCalibration(fullfile(pathToSession, eyelinkCalibFiles{nc}));
    end
    
    %% structure to keep the session's info
    missedFrames = cell(numel(sessionInfo.stimSequence), 1);
    response = cell(numel(sessionInfo.stimSequence), 1);
    eyetracking = cell(numel(sessionInfo.stimSequence), 1);
    eyetrackingQ = cell(numel(sessionInfo.stimSequence), 1);
    index = cell(sessionInfo.nBlocks, 1);
    
    %% Load raw data by trials
    for b = 1:sessionInfo.nBlocks
        display(['Loading block ' num2str(b) '/' num2str(sessionInfo.nBlocks)]);
        load(fullfile(pathToSession, matFiles{b}));
        index{b} = trialSequence;
        nT = numel(trialSequence);
        [raw, rawQ] = getEyelinkData(pathToSession, eyelinkFiles{b}, sessionInfo);
        
        for t = 1:nT
            idx = (b - 1) *nT + t;
            missedFrames{idx} = (trials.timing{t}.Missed > 0);
            response{idx} = trials.response{t};
            eyetracking{idx} = raw{t};
            eyetrackingQ{idx} = rawQ{t};
        end
    end
    
    trialIndex = cell2mat(index);
end