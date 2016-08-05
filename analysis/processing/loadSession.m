function dataOut = loadSession(pathToSession)
    
    display(['Loading... ' pathToSession]);
    
    processedData = processRawData(pathToSession);
    
    
    nCnd = numel(processedData);
    dataOut = cell(nCnd, 1);
    
    for c = 1:nCnd;
        cnd = processedData{c};
        % remove prelude
        nSamples = uint32(1000*cnd.info.cycleSec);
        nFrames = uint32(cnd.info.cycleSec*cnd.info.dotUpdateHz);
        % pos
        L = startAtZero(takeLastN(cnd.pos.L, nSamples));
        R = startAtZero(takeLastN(cnd.pos.R, nSamples));
        % vel
        Lv = startAtZero(takeLastN(cnd.vel.L, nSamples));
        Rv = startAtZero(takeLastN(cnd.vel.R, nSamples));

        timing = takeLastN(cnd.timing, nFrames);                
        quality = removePreludeData(cnd.quality, nSamples);
        
        isTrialOK = rejectBadTrials(quality, timing); 
        
        dataOut{c}.pos.L = L(:, :, isTrialOK);
        dataOut{c}.pos.R = R(:, :, isTrialOK);
        
        dataOut{c}.vel.L = Lv(:, :, isTrialOK);
        dataOut{c}.vel.R = Rv(:, :, isTrialOK);
        
        dataOut{c}.timecourse = takeLastN(cnd.timecourse', nSamples);
        
        
        dataOut{c}.info = cnd.info;
        dataOut{c}.response = cnd.response(isTrialOK);
       
        display(['Cnd ' num2str(c) ': Trials ' num2str(sum(isTrialOK)) ...
            '/' num2str(cnd.info.nTrials)]);
        
    end
end
function t = removePreludeData(data, nSamples)
    t = cellfun(@(x) takeLastN(x, nSamples), data, 'UniformOutput', false);
end