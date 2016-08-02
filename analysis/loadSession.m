function sessionData = loadSession(pathToSession)
    
    display(['Loading... ' pathToSession]);
    
    sessionMatFile = [strtok(pathToSession, '.') '.mat'];
    
    
    if (exist(sessionMatFile, 'file'))
        load(sessionMatFile);
    else
        % load raw data
        try
            [missedFrames, response, eyetracking, eyetrackingQ, ...
                trialIndex, sessionInfo] = loadRawData(pathToSession);
    
            nCnd = numel(sessionInfo.conditions);
            sessionData = cell(nCnd, 1);
            % group data by condition number, run artifact rejection and
            % convert good trials 
            for c = 1:nCnd
                cndInfo = sessionInfo.conditions{c}.info;
                cndTrackingData = eyetracking(trialIndex == c);
                cndTrackingQ = eyetrackingQ(trialIndex == c);
                cndTiming = missedFrames(trialIndex == c);
                trialDuration = cndInfo.cycleSec + cndInfo.preludeSec;
                cndResponse = response(trialIndex == c);
            
                % reject bad trials
                isTrialOK = rejectBadTrials(cndTrackingQ, cndTiming); 
                display(['Cnd ' num2str(c) ': Accepted trials ' num2str(sum(isTrialOK)) '/' num2str(cndInfo.nTrials)]);
                [timecourse, pos, vel] =  ...
                    convertEyelinkData(cndTrackingData(isTrialOK), sessionInfo.subj.ipd, trialDuration);
                %plotSummary(pos, vel, pathToSession, c);
            
                sessionData{c}.timecourse = timecourse;
                sessionData{c}.pos = pos;
                sessionData{c}.vel = vel;
                sessionData{c}.response = cndResponse;
                sessionData{c}.info = cndInfo;
            end
        save(sessionMatFile, 'sessionData');            
        catch
            sessionData = {};
        end
    end
end