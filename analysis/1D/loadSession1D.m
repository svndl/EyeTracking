function sessionData = loadSession1D(pathToSession)
    
    display(['Loading... ' pathToSession]);
    
    sessionMatFile = [strtok(pathToSession, '.') '1D.mat'];
    
    
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
                %trialDuration = cndInfo.cycleSec + cndInfo.preludeSec;
                cndResponse = response(trialIndex == c);
                
                %% remove prelude data
                nSamples = uint32(1000*cndInfo.cycleSec);
                nFrames = uint32(cndInfo.cycleSec*cndInfo.dotUpdateHz);
                tr = removePreludeData(cndTrackingData, nSamples);
                q = removePreludeData(cndTrackingQ, nSamples);
                timing = removePreludeData(cndTiming, nFrames);                
                
                isTrialOK = rejectBadTrials(q, timing); 
                display(['Cnd ' num2str(c) ': Accepted trials ' num2str(sum(isTrialOK)) '/' num2str(cndInfo.nTrials)]);
                [timecourse, pos, vel] =  ...
                    convertEyelinkData1D(tr(isTrialOK), sessionInfo.subj.ipd, cndInfo.cycleSec);

                % reject bad trials
%                 isTrialOK = rejectBadTrials(cndTrackingQ, cndTiming); 
%                 display(['Cnd ' num2str(c) ': Accepted trials ' num2str(sum(isTrialOK)) '/' num2str(cndInfo.nTrials)]);
%                 [timecourse, pos, vel] =  ...
%                     convertEyelinkData(cndTrackingData(isTrialOK), sessionInfo.subj.ipd, trialDuration);
            
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

function t = removePreludeData(data, nSamples)
    t = cellfun(@(x) takeLastN(x, nSamples), data, 'UniformOutput', false);
end
