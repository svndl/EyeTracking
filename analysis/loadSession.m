function sessionData = loadSession(pathToSession)
    
    display(['Loading... ' pathToSession]);
    
    sessionMatFile = [strtok(pathToSession, '.') '.mat'];
    
    
    if (exist(sessionMatFile, 'file'))
        load(sessionMatFile);
        for c = 1:numel(sessionData)
            plotSummary(sessionData{c}, pathToSession, c)
        end
    else
        matFiles = getFileList(pathToSession, 'mat', 'cnd');        
        
        % look for edf files first
        eyelinkFiles = getFileList(pathToSession, 'edf', 'cnd');

        % use the non-empty list
        if (isempty(eyelinkFiles))
            eyelinkFiles = getFileList(pathToSession, 'asc', 'cnd');
        end
            
        eyelinkCalibFiles = getFileList(pathToSession, 'edf', 'cali');        

        
        nCndSession = numel(matFiles);
        sessionData = cell(nCndSession, 1);
    
        sessionInfoFile = [strtok(pathToSession, '.') filesep 'sessionInfo.mat'];    
        load(sessionInfoFile);
        
        % check calibration
        
        for nc =1:numel(eyelinkCalibFiles)
            calibError{nc} = loadEyelinkCalibration(fullfile(pathToSession, eyelinkCalibFiles{nc}));
        end
       
        
        %for each condition look if there is an eyelink file 
        for c = 1:nCndSession
            display(['Loading condition ' num2str(c) '/' num2str(nCndSession)]);
            load(fullfile(pathToSession, matFiles{c}));
            % conditionInfo, trials            
            sessionData{c}.info = conditionInfo;
            sessionData{c}.timing = trials.timing;
            
            trialDuration = conditionInfo.cycleSec + conditionInfo.preludeSec;
            % convert edf to asc and extract data
            trialData = getEyelinkData(pathToSession, eyelinkFiles{c}, sessionInfo);
            %check trial timing and eyelink trial duration
                        
            [sessionData{c}.missedFrames, sessionData{c}.samples] = checkBlockTiming(trials.timing, trialData);
            
           [sessionData{c}.timecourse, sessionData{c}.pos, sessionData{c}.vel] =  ...
               convertEyelinkData(trialData, sessionInfo.subj.ipd, trialDuration);
           
           plotSummary(sessionData{c}, pathToSession, c);
        end
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
