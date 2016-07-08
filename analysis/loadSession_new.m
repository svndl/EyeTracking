function sessionData = loadSession_new(pathToSession)
% loads and processes the session's data
% input argument: pathToSession -- full path tp session folder 
% output argument: processed session broken down by conditions


    display(['Loading... ' pathToSession]);
    
    sessionMatFile = [strtok(pathToSession, '.') '.mat'];
    
    
    if (exist(sessionMatFile, 'file'))
        load(sessionMatFile);
    else
        sessionInfoFile = [strtok(pathToSession, '.') filesep 'sessionInfo.mat'];    
        load(sessionInfoFile);

        % check for special file extensions
        if (isfield(sessionInfo, 'file_extension'))
            extensions = sessionInfo.file_extension;
        else
            extensions = 'cnd';
        end
        
        matFiles = getFileList(pathToSession, 'mat', extensions);        
        
        % look for edf files first
        eyelinkFiles = getFileList(pathToSession, 'edf', extensions);

        % use the non-empty list
        if (isempty(eyelinkFiles))
            eyelinkFiles = getFileList(pathToSession, 'asc', extensions);
        end
            
        eyelinkCalibFiles = getFileList(pathToSession, 'edf', 'cali');
        
        % check calibration
        for nc =1:numel(eyelinkCalibFiles)
            calibError{nc} = loadEyelinkCalibration(fullfile(pathToSession, eyelinkCalibFiles{nc}));
        end
       
        nBlocks = numel(matFiles);
        %for each condition look if there is an eyelink file 
        for c = 1:nBlocks
            display(['Loading block ' num2str(c) '/' num2str(nBlocks)]);
            load(fullfile(pathToSession, nMatFiles{c}));
            % conditionInfo, trials            
            sessionData{c}.info = conditionInfo;
            
            sessionData{c}.timing = trials.timing;
            
            trialDuration = conditionInfo.cycleSec + conditionInfo.preludeSec;
            % convert edf to asc and extract data
            trialData = getEyelinkData(pathToSession, eyelinkFiles{c}, sessionInfo);
            %check trial timing and eyelink trial duration
                        
            [sessionData{c}.missedFrames, sessionData{c}.samples] = checkBlockTiming(trials.timing, trialData);
            
           
           plotSummary(sessionData{c}, pathToSession, c);
        end
        
        %% break down by conditions
        
        
%         [sessionData{c}.timecourse, sessionData{c}.pos, sessionData{c}.vel] =  ...
%                convertEyelinkData(trialData, sessionInfo.subj.ipd, trialDuration);
        
        
        save(sessionMatFile, 'sessionData');
    end
end

function plotSummary(data, pathToSession, cnd)

    figure;
    subplot(2, 1, 1)
    xlabel('Time samples');
    ylabel('Degrees per second');

    plot(-data.pos.Lavg(:, 1), '-b'); hold on;
    plot(-data.pos.Ravg(:, 1), '-r'); hold on;
    plot(-data.pos.Vergence(:, 1), '-.k'); hold on;
    plot(-data.pos.Version(:, 1), '.k'); hold on;
    
    legend({'position L', 'position R', 'vergence', 'version'});
    
    subplot(2, 1, 2)
    xlabel('Time samples');
    ylabel('Degrees per second');
   
    plot(-data.vel.Lavg(:, 1), '-b'); hold on;
    plot(-data.vel.Ravg(:, 1), '-r'); hold on;
    plot(-data.vel.Vergence(:, 1), '-.k'); hold on;
    plot(-data.vel.Version(:, 1), '.k'); hold on;
    
    legend({'velocity L', 'velocity R', 'vergence velocity', 'version velocity'});
    saveas(gcf, fullfile(pathToSession, num2str(cnd)), 'fig');
    close gcf;
end


function sessionData = loadRandomRec()
end

function sessionData = loadConsecRec()
end



