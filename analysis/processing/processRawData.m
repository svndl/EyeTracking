function sessionData = processRawData(pathToSession)
% cleaning the data

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
                
                [timecourse, pos, vel] =  ...
                    convertEyelinkData(cndTrackingData, sessionInfo.subj.ipd, trialDuration);
                
                sessionData{c}.timecourse = timecourse;
                sessionData{c}.timing = cndTiming;
                sessionData{c}.quality = cndTrackingQ;
                sessionData{c}.pos = pos;
                sessionData{c}.vel = vel;
                sessionData{c}.response = cndResponse;
                sessionData{c}.info = cndInfo;
                % store raw data
            end
        save(sessionMatFile, 'sessionData');            
        catch
            sessionData = {};
        end
    end
end