function sessionData = processRawData(pathToSession)
% cleaning the data

    sessionMatFile = [strtok(pathToSession, '.') '.mat'];
    
    if (exist(sessionMatFile, 'file'))
        load(sessionMatFile);
    else
        % load raw data
        try
            [missedFrames, response, eyetracking, ...
                trialIndex, sessionInfo] = loadRawData(pathToSession);
        catch err
            display('Function processRawData error loading raw data:')
            display(err.message);            
            for e = 1: numel(err.stack)
                display(err.stack(e).file);
                display(err.stack(e).line);
            end
            sessionData = {};
            return;
        end
        
        nCnd = numel(sessionInfo.conditions);
        sessionData = cell(nCnd, 1);
        % group data by condition number, run artifact rejection and
        % convert good trials 
        for c = 1:nCnd
            try    
                cndInfo = sessionInfo.conditions{c}.info;
                cndTrackingData = eyetracking(trialIndex == c);
                
                cndTiming = missedFrames(trialIndex == c);
                trialDuration = cndInfo.cycleSec + cndInfo.preludeSec;
                cndResponse = response(trialIndex == c);
                
                [timecourse, pos, vel] =  ...
                    convertEyelinkData(cndTrackingData, sessionInfo.subj.ipd, trialDuration);
                
                sessionData{c}.timecourse = timecourse;
                sessionData{c}.timing = cndTiming;
                sessionData{c}.pos = pos;
                sessionData{c}.vel = vel;
                sessionData{c}.response = cndResponse;
                sessionData{c}.info = cndInfo;
                % store raw data
            catch err
                display(['Function processRawData error processing condition data c = ' num2str(c)]);
                display(err.message);            
                for e = 1: numel(err.stack)
                    display(err.stack(e).file);
                    display(err.stack(e).line);
                end
                sessionData{c} = {};
            end
        end
        save(sessionMatFile, 'sessionData');            
    end
end