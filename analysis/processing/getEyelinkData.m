function [trialData, trialQ] = getEyelinkData(filePath, fileName, sessionInfo)
% function getEyelinkData will extract and process 
% data info from eyelink source file

% fullfilePath is a full path to eyelink file
% sessionInfo is a mat-structure containing eyelink MSG markers

    isRaw = strcmp(fileName(end-2:end), 'edf');
    flags = '-velo';
    if (isRaw)
        convertEyelinkFile(filePath, fileName, flags);
    end
    
    
    %% read asc file
    % we're importing velocity 
    
    % index: 1(time), 2(LX) 3(LY) 5(RX) 6(RY) 8(LVx) 9(LVy) 10(RVx)
    % 11(RVy), 12(Sample Quality)
    idx = [1, 2, 3, 5, 6, 8:12];
    
    rawData = loadEyelinkFile(fullfile(filePath, [fileName(1:end-3) 'asc']), idx);  
    %headers =  {'time', 'Lx', 'Ly', 'Rx', 'Ry',  'Lvx', 'Lvy', 'Rvx', 'Rvy', 'Q'};
    search_args = [];
    
    if (isfield(sessionInfo, 'eyelink_ts'))
        EyelinkFlags = sessionInfo.eyelink_ts;
        search_args = {EyelinkFlags.startCol, EyelinkFlags.stopCol, EyelinkFlags.startFlag, EyelinkFlags.stopFlag};
    end
    
    
    % process asc file, removes saccades/fixations, converts str values to
    % numbers and splits data into trials
    [trialData, trialQ] = processEyelinkData(rawData, search_args);
    
    % trialData structure:
    % 1 - timesamples; 2 - Lx, 3 - Ly; 4 - Rx, 5 - Ry; 6 - Lvx, 7 - Lvy; 8 - Rvx, 9 - Rvy.
        
end
